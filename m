From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fixup some tagged queuing mess
Date: Mon, 25 Aug 2003 14:27:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122751.GF15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:58779 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261815AbTHYM14 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:27:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, dledford@redhat.com
Cc: linux-scsi@vger.kernel.org

This is a followup to Doug's comments and older work.  It kills
sdev->tagged_queue which wasn't ever set in 2.5/2.6 except through
obscure and broken ioctls (!).  As a reason of that tagged queing
didn't work for a lot of drivers, so this does change behaviour.
Be careful..

James, can you review the code in 53c700.c?  Calling scsi_activate_tcq
in ->queuecommand rather than ->slave_configure looks rather strange to
me..


diff -Nru a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/message/fusion/mptscsih.c	Mon Aug 25 13:37:34 2003
@@ -3328,9 +3328,8 @@
 		device, device->id, device->lun, device->channel));
 	dsprintk((KERN_INFO "sdtr %d wdtr %d ppr %d inq length=%d\n",
 		device->sdtr, device->wdtr, device->ppr, device->inquiry_len));
-	dsprintk(("tagged %d queue %d simple %d ordered %d\n",
-		device->tagged_supported, device->tagged_queue,
-		device->simple_tags, device->ordered_tags));
+	dsprintk(("tagged %d simple %d ordered %d\n",
+		device->tagged_supported, device->simple_tags, device->ordered_tags));
 
 	/*	set target parameters, queue depths, set dv flags ?  */
 	if (hd && (hd->Targets != NULL)) {
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/53c700.c	Mon Aug 25 13:37:34 2003
@@ -1758,7 +1758,7 @@
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
 	print_command(SCp->cmnd);
 #endif
-	if(SCp->device->tagged_supported && !SCp->device->tagged_queue
+	if(SCp->device->tagged_supported && !SCp->device->simple_tags &&
 	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
 	   && NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING)) {
 		/* upper layer has indicated tags are supported.  We don't
diff -Nru a/drivers/scsi/AM53C974.c b/drivers/scsi/AM53C974.c
--- a/drivers/scsi/AM53C974.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/AM53C974.c	Mon Aug 25 13:37:34 2003
@@ -1231,8 +1231,8 @@
 				hostdata->sel_cmd = NULL;
 				hostdata->selecting = 0;
 #ifdef SCSI2
-				if (!hostdata->connected->device->tagged_queue)
-#endif
+				if (!hostdata->conneted->device->simple_tags)
+#else
 					hostdata->busy[hostdata->connected->device->id] |= (1 << hostdata->connected->device->lun);
 				/* very strange -- use_sg is sometimes nonzero for request sense commands !! */
 				if ((hostdata->connected->cmnd[0] == REQUEST_SENSE) && hostdata->connected->use_sg) {
@@ -1811,7 +1811,7 @@
 			case HEAD_OF_QUEUE_TAG:
 			    case ORDERED_QUEUE_TAG:
 			    case SIMPLE_QUEUE_TAG:
-			    cmd->device->tagged_queue = 0;
+			    cmd->device->simple_tags = 0;
 			hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 			break;
 			default:
@@ -1958,7 +1958,7 @@
 #endif
 
 #ifdef SCSI2
-	if (cmd->device->tagged_queue && (tag != TAG_NONE)) {
+	if (cmd->device->simple_tags && (tag != TAG_NONE)) {
 		tmp[1] = SIMPLE_QUEUE_TAG;
 		if (tag == TAG_NEXT) {
 			/* 0 is TAG_NONE, used to imply no tag for this command */
diff -Nru a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/NCR5380.c	Mon Aug 25 13:37:34 2003
@@ -2514,7 +2514,7 @@
 					case HEAD_OF_QUEUE_TAG:
 					case ORDERED_QUEUE_TAG:
 					case SIMPLE_QUEUE_TAG:
-						cmd->device->tagged_queue = 0;
+						cmd->device->simple_tags = 0;
 						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 						break;
 					default:
diff -Nru a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
--- a/drivers/scsi/arm/acornscsi.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/arm/acornscsi.c	Mon Aug 25 13:37:34 2003
@@ -768,7 +768,7 @@
 	/*
 	 * tagged queueing - allocate a new tag to this command
 	 */
-	if (SCpnt->device->tagged_queue) {
+	if (SCpnt->device->simple_tags) {
 	    SCpnt->device->current_tag += 1;
 	    if (SCpnt->device->current_tag == 0)
 		SCpnt->device->current_tag = 1;
@@ -1590,7 +1590,7 @@
 	     */
 	    printk(KERN_NOTICE "scsi%d.%c: disabling tagged queueing\n",
 		    host->host->host_no, acornscsi_target(host));
-	    host->SCpnt->device->tagged_queue = 0;
+	    host->SCpnt->device->simple_tags = 0;
 	    set_bit(host->SCpnt->device->id * 8 + host->SCpnt->device->lun, host->busyluns);
 	    break;
 #endif
@@ -2935,7 +2935,7 @@
 	p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
 	if (scd->tagged_supported)
 		p += sprintf(p, "%3sabled(%3d) ",
-			     scd->tagged_queue ? "en" : "dis",
+			     scd->simple_tags ? "en" : "dis",
 			     scd->current_tag);
 	else
 		p += sprintf(p, "unsupported  ");
diff -Nru a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/arm/fas216.c	Mon Aug 25 13:37:34 2003
@@ -1819,7 +1819,7 @@
 	/*
 	 * tagged queuing - allocate a new tag to this command
 	 */
-	if (SCpnt->device->tagged_queue && SCpnt->cmnd[0] != REQUEST_SENSE &&
+	if (SCpnt->device->simple_tags && SCpnt->cmnd[0] != REQUEST_SENSE &&
 	    SCpnt->cmnd[0] != INQUIRY) {
 	    SCpnt->device->current_tag += 1;
 		if (SCpnt->device->current_tag == 0)
@@ -3012,7 +3012,7 @@
 		p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
 			p += sprintf(p, "%3sabled(%3d) ",
-				     scd->tagged_queue ? "en" : "dis",
+				     scd->simple_tags ? "en" : "dis",
 				     scd->current_tag);
 		else
 			p += sprintf(p, "unsupported   ");
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/ncr53c8xx.c	Mon Aug 25 13:37:34 2003
@@ -4357,19 +4357,6 @@
 	}
 	cp->cmd = cmd;
 
-	/*---------------------------------------------------
-	**
-	**	Enable tagged queue if asked by scsi ioctl
-	**
-	**----------------------------------------------------
-	*/
-#if 0	/* This stuff was only useful for linux-1.2.13 */
-	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {
-		lp->numtags = tp->usrtags;
-		ncr_setup_tags (np, cmd->device->id, cmd->device->lun);
-	}
-#endif
-
 	/*----------------------------------------------------
 	**
 	**	Build the identify / tag / sdtr message
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/qla1280.c	Mon Aug 25 13:37:34 2003
@@ -3649,7 +3649,7 @@
 		(SCSI_TCN_32(cmd) | BIT_7) : SCSI_TCN_32(cmd);
 
 	/* Enable simple tag queuing if device supports it. */
-	if (cmd->device->tagged_queue)
+	if (cmd->device->simple_tags)
 		pkt->control_flags |= cpu_to_le16(BIT_3);
 
 	/* Load SCSI command packet. */
@@ -3949,7 +3949,7 @@
 		(SCSI_TCN_32(cmd) | BIT_7) : SCSI_TCN_32(cmd);
 
 	/* Enable simple tag queuing if device supports it. */
-	if (cmd->device->tagged_queue)
+	if (cmd->device->simple_tags)
 		pkt->control_flags |= cpu_to_le16(BIT_3);
 
 	/* Load SCSI command packet. */
@@ -4909,7 +4909,7 @@
 	} else
 		printk(" Async");
 
-	if (device->tagged_queue)
+	if (device->simple_tags)
 		printk(", Tagged queuing: depth %d", device->queue_depth);
 	printk("\n");
 }
diff -Nru a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/scsi_ioctl.c	Mon Aug 25 13:37:34 2003
@@ -408,30 +408,6 @@
 		return 0;
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		return put_user(sdev->host->host_no, (int *)arg);
-	/*
-	 * The next two ioctls either need to go or need to be changed to
-	 * pass tagged queueing changes through the low level drivers.
-	 * Simply enabling or disabling tagged queueing without the knowledge
-	 * of the low level driver is a *BAD* thing.
-	 *
-	 * Oct. 10, 2002 - Doug Ledford <dledford@redhat.com>
-	 */
-	case SCSI_IOCTL_TAGGED_ENABLE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		if (!sdev->tagged_supported)
-			return -EINVAL;
-		sdev->tagged_queue = 1;
-		sdev->current_tag = 1;
-		return 0;
-	case SCSI_IOCTL_TAGGED_DISABLE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		if (!sdev->tagged_supported)
-			return -EINVAL;
-		sdev->tagged_queue = 0;
-		sdev->current_tag = 0;
-		return 0;
 	case SCSI_IOCTL_PROBE_HOST:
 		return ioctl_probe(sdev->host, arg);
 	case SCSI_IOCTL_SEND_COMMAND:
diff -Nru a/drivers/scsi/sym53c8xx.c b/drivers/scsi/sym53c8xx.c
--- a/drivers/scsi/sym53c8xx.c	Mon Aug 25 13:37:34 2003
+++ b/drivers/scsi/sym53c8xx.c	Mon Aug 25 13:37:34 2003
@@ -6595,19 +6595,6 @@
 	}
 	cp->cmd = cmd;
 
-	/*---------------------------------------------------
-	**
-	**	Enable tagged queue if asked by scsi ioctl
-	**
-	**----------------------------------------------------
-	*/
-#if 0	/* This stuff was only useful for linux-1.2.13 */
-	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {
-		lp->numtags = tp->usrtags;
-		ncr_setup_tags (np, cp->target, cp->lun);
-	}
-#endif
-
 	/*----------------------------------------------------
 	**
 	**	Build the identify / tag / sdtr message
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Mon Aug 25 13:37:34 2003
+++ b/include/scsi/scsi_device.h	Mon Aug 25 13:37:34 2003
@@ -74,8 +74,6 @@
 	unsigned wdtr:1;	/* Device supports WDTR messages */
 	unsigned ppr:1;		/* Device supports PPR messages */
 	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
-	unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
-				   instead!!!  Please fix your driver now!! */
 	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
 	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */
 	unsigned single_lun:1;	/* Indicates we should only allow I/O to
