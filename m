From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] ncr53c8xx: kill INQUIRY snooping and believe the mid-layer
	flags
Date: 04 Oct 2004 12:49:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096912175.1748.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18079 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268342AbUJDRtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 13:49:36 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i94HnZm13507
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2004 13:49:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

No driver should ever have to snoop inquirys ...

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/04 09:28:13-05:00 jejb@pashleys.(none) 
#   mcr53c8xx: remove INQUIRY snooping and believe the mid-layer flags
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/sym53c8xx_comm.h
#   2004/10/04 09:25:15-05:00 jejb@pashleys.(none) +0 -30
#   mcr53c8xx: remove INQUIRY snooping and believe the mid-layer flags
# 
# drivers/scsi/ncr53c8xx.c
#   2004/10/04 09:25:14-05:00 jejb@pashleys.(none) +23 -81
#   mcr53c8xx: remove INQUIRY snooping and believe the mid-layer flags
# 
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	2004-10-04 12:47:45 -05:00
+++ b/drivers/scsi/ncr53c8xx.c	2004-10-04 12:47:45 -05:00
@@ -398,17 +398,6 @@
 
 /*==========================================================
 **
-**	Capability bits in Inquire response byte 7.
-**
-**==========================================================
-*/
-
-#define	INQ7_QUEUE	(0x02)
-#define	INQ7_SYNC	(0x10)
-#define	INQ7_WIDE16	(0x20)
-
-/*==========================================================
-**
 **	Misc.
 **
 **==========================================================
@@ -500,8 +489,6 @@
 	*/
 	struct link     jump_lcb[4];	/* JUMPs for reselection	*/
 	struct lcb *	lp[MAX_LUN];	/* The lcb's of this tcb	*/
-	u_char		inq_done;	/* Target capabilities received	*/
-	u_char		inq_byte7;	/* Contains these capabilities	*/
 
 	/*----------------------------------------------------------------
 	**	Pointer to the ccb used for negotiation.
@@ -545,6 +532,7 @@
 	u_char	usrwide;
 	u_char	usrtags;
 	u_char	usrflag;
+	struct scsi_device *sdev;
 };
 
 /*========================================================================
@@ -611,7 +599,6 @@
 	u_char		usetags;	/* Command queuing is active	*/
 	u_char		maxtags;	/* Max nr of tags asked by user	*/
 	u_char		numtags;	/* Current number of tags	*/
-	u_char		inq_byte7;	/* Store unit CmdQ capabitility	*/
 
 	/*----------------------------------------------------------------
 	**	QUEUE FULL control and ORDERED tag control.
@@ -1225,8 +1212,7 @@
 static	void	ncr_init_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_tcb	(struct ncb *np, u_char tn);
 static	struct lcb *	ncr_alloc_lcb	(struct ncb *np, u_char tn, u_char ln);
-static	struct lcb *	ncr_setup_lcb	(struct ncb *np, u_char tn, u_char ln,
-				 u_char *inq_data);
+static	struct lcb *	ncr_setup_lcb	(struct ncb *np, u_char tn, u_char ln);
 static	void	ncr_getclock	(struct ncb *np, int mult);
 static	void	ncr_selectclock	(struct ncb *np, u_char scntl3);
 static	struct ccb *ncr_get_ccb	(struct ncb *np, u_char tn, u_char ln);
@@ -3377,15 +3363,16 @@
 	struct tcb *tp = &np->target[cp->target];
 	int msglen = 0;
 	int nego = 0;
+	struct scsi_device *sdev = tp->sdev;
 
-	if (tp->inq_done) {
+	if (likely(sdev)) {
 
 		/*
 		**	negotiate wide transfers ?
 		*/
 
 		if (!tp->widedone) {
-			if (tp->inq_byte7 & INQ7_WIDE16) {
+			if (sdev->wdtr) {
 				nego = NS_WIDE;
 			} else
 				tp->widedone=1;
@@ -3397,7 +3384,7 @@
 		*/
 
 		if (!nego && !tp->period) {
-			if (tp->inq_byte7 & INQ7_SYNC) {
+			if (sdev->sdtr) {
 				nego = NS_SYNC;
 			} else {
 				tp->period  =0xffff;
@@ -4274,19 +4261,6 @@
 		if (!lp)
 			ncr_alloc_lcb (np, cmd->device->id, cmd->device->lun);
 
-		/*
-		**	On standard INQUIRY response (EVPD and CmDt 
-		**	not set), setup logical unit according to 
-		**	announced capabilities (we need the 1rst 7 bytes).
-		*/
-		if (cmd->cmnd[0] == 0x12 && !(cmd->cmnd[1] & 0x3) &&
-		    cmd->cmnd[4] >= 7 && !cmd->use_sg) {
-			sync_scsi_data_for_cpu(np, cmd);	/* SYNC the data */
-			ncr_setup_lcb (np, cmd->device->id, cmd->device->lun,
-				       (char *) cmd->request_buffer);
-			sync_scsi_data_for_device(np, cmd);	/* SYNC the data */
-		}
-
 		tp->bytes     += cp->data_len;
 		tp->transfers ++;
 
@@ -5009,11 +4983,12 @@
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char   reqtags, maxdepth;
+	struct scsi_device *sdev = tp->sdev;
 
 	/*
 	**	Just in case ...
 	*/
-	if ((!tp) || (!lp))
+	if ((!tp) || (!lp) || !sdev)
 		return;
 
 	/*
@@ -5037,7 +5012,7 @@
 	**	only devices capable of tagged commands
 	**	only if enabled by user ..
 	*/
-	if ((lp->inq_byte7 & INQ7_QUEUE) && lp->numtags > 1) {
+	if (sdev->tagged_supported && lp->numtags > 1) {
 		reqtags = lp->numtags;
 	} else {
 		reqtags = 1;
@@ -6298,8 +6273,8 @@
 		**	      it CAN transfer synch.
 		*/
 
-		if (ofs)
-			tp->inq_byte7 |= INQ7_SYNC;
+		if (ofs && tp->sdev)
+			tp->sdev->sdtr = 1;
 
 		/*
 		**	check values against driver limits.
@@ -6419,8 +6394,8 @@
 		**	      it CAN transfer wide.
 		*/
 
-		if (wide)
-			tp->inq_byte7 |= INQ7_WIDE16;
+		if (wide && tp->sdev)
+			tp->sdev->wdtr = 1;
 
 		/*
 		**	check values against driver limits.
@@ -7019,11 +6994,11 @@
 **	will play with CHANGE DEFINITION commands. :-)
 **------------------------------------------------------------------------
 */
-static struct lcb *ncr_setup_lcb (struct ncb *np, u_char tn, u_char ln, u_char *inq_data)
+static struct lcb *ncr_setup_lcb (struct ncb *np, u_char tn, u_char ln)
 {
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
-	u_char inq_byte7;
+	struct scsi_device *sdev = tp->sdev;
 
 	/*
 	**	If no lcb, try to allocate it.
@@ -7032,46 +7007,16 @@
 		goto fail;
 
 	/*
-	**	Evaluate trustable target/unit capabilities.
-	**	We only believe device version >= SCSI-2 that 
-	**	use appropriate response data format (2).
-	**	But it seems that some CCS devices also 
-	**	support SYNC and I donnot want to frustrate 
-	**	anybody. ;-)
+	**	Prepare negotiation
 	*/
-	inq_byte7 = 0;
-	if	((inq_data[2] & 0x7) >= 2 && (inq_data[3] & 0xf) == 2)
-		inq_byte7 = inq_data[7];
-	else if ((inq_data[2] & 0x7) == 1 && (inq_data[3] & 0xf) == 1)
-		inq_byte7 = INQ7_SYNC;
-
-	/*
-	**	Throw away announced LUN capabilities if we are told 
-	**	that there is no real device supported by the logical unit.
-	*/
-	if ((inq_data[0] & 0xe0) > 0x20 || (inq_data[0] & 0x1f) == 0x1f)
-		inq_byte7 &= (INQ7_SYNC | INQ7_WIDE16);
-
-	/*
-	**	If user is wanting SYNC, force this feature.
-	*/
-	if (driver_setup.force_sync_nego)
-		inq_byte7 |= INQ7_SYNC;
-
-	/*
-	**	Prepare negotiation if SIP capabilities have changed.
-	*/
-	tp->inq_done = 1;
-	if ((inq_byte7 ^ tp->inq_byte7) & (INQ7_SYNC | INQ7_WIDE16)) {
-		tp->inq_byte7 = inq_byte7;
+	if (sdev->wdtr || sdev->sdtr)
 		ncr_negotiate(np, tp);
-	}
 
 	/*
 	**	If unit supports tagged commands, allocate the 
 	**	CCB JUMP table if not yet.
 	*/
-	if ((inq_byte7 & INQ7_QUEUE) && lp->jump_ccb == &lp->jump_ccb_0) {
+	if (sdev->tagged_supported && lp->jump_ccb == &lp->jump_ccb_0) {
 		int i;
 		lp->jump_ccb = m_calloc_dma(256, "JUMP_CCB");
 		if (!lp->jump_ccb) {
@@ -7086,17 +7031,10 @@
 			lp->cb_tags[i] = i;
 		lp->maxnxs = MAX_TAGS;
 		lp->tags_stime = ktime_get(3*HZ);
-	}
-
-	/*
-	**	Adjust tagged queueing status if needed.
-	*/
-	if ((inq_byte7 ^ lp->inq_byte7) & INQ7_QUEUE) {
-		lp->inq_byte7 = inq_byte7;
-		lp->numtags   = lp->maxtags;
 		ncr_setup_tags (np, tn, ln);
 	}
 
+
 fail:
 	return lp;
 }
@@ -7477,6 +7415,10 @@
 	struct tcb *tp = &np->target[device->id];
 	struct lcb *lp = tp->lp[device->lun];
 	int numtags, depth_to_use;
+
+	tp->sdev = device;
+
+	ncr_setup_lcb(np, device->id, device->lun);
 
 	/*
 	**	Select queue depth from driver setup.
diff -Nru a/drivers/scsi/sym53c8xx_comm.h b/drivers/scsi/sym53c8xx_comm.h
--- a/drivers/scsi/sym53c8xx_comm.h	2004-10-04 12:47:45 -05:00
+++ b/drivers/scsi/sym53c8xx_comm.h	2004-10-04 12:47:45 -05:00
@@ -502,36 +502,6 @@
 	return use_sg;
 }
 
-static void __sync_scsi_data_for_cpu(struct device *dev, struct scsi_cmnd *cmd)
-{
-	switch(cmd->__data_mapped) {
-	case 2:
-		dma_sync_sg_for_cpu(dev, cmd->buffer, cmd->use_sg,
-				cmd->sc_data_direction);
-		break;
-	case 1:
-		dma_sync_single_for_cpu(dev, cmd->__data_mapping,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-		break;
-	}
-}
-
-static void __sync_scsi_data_for_device(struct device *dev, struct scsi_cmnd *cmd)
-{
-	switch(cmd->__data_mapped) {
-	case 2:
-		dma_sync_sg_for_device(dev, cmd->buffer, cmd->use_sg,
-				cmd->sc_data_direction);
-		break;
-	case 1:
-		dma_sync_single_for_device(dev, cmd->__data_mapping,
-					   cmd->request_bufflen,
-					   cmd->sc_data_direction);
-		break;
-	}
-}
-
 #define unmap_scsi_data(np, cmd)	__unmap_scsi_data(np->dev, cmd)
 #define map_scsi_single_data(np, cmd)	__map_scsi_single_data(np->dev, cmd)
 #define map_scsi_sg_data(np, cmd)	__map_scsi_sg_data(np->dev, cmd)

