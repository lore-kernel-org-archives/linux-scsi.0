From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [PATCH 2/2] sdev_printk - using scsi_device helper macro
Date: Tue, 7 Oct 2003 13:22:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310071322.06798.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:64138 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262766AbTJGUVL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 16:21:11 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e2.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id h97KLA42186362
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 16:21:11 -0400
Received: from DYN318271BLD.beaverton.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h97KL93s231018
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 16:21:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Here's a patch that applies the sdev_printk to the mid-layer. Please apply or 
let me know if there are objections.

Thanks,

Dan

Patch #2 Follows:
--------------------

diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/constants.c 
scsi-misc-2.5-sdev-use/drivers/scsi/constants.c
--- scsi-misc-2.5-sdev/drivers/scsi/constants.c	2003-10-06 16:26:25.000000000 
-0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/constants.c	2003-10-06 
20:42:45.000000000 -0700
@@ -1127,11 +1127,7 @@
 }
 
 void print_Scsi_Cmnd(struct scsi_cmnd *cmd) {
-    printk("scsi%d : destination target %d, lun %d\n", 
-	   cmd->device->host->host_no, 
-	   cmd->device->id, 
-	   cmd->device->lun);
-    printk("        command = ");
+    sdev_printk(KERN_INFO, cmd->device, "        command = ");
     print_command(cmd->cmnd);
 }
 
diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/scsi.c 
scsi-misc-2.5-sdev-use/drivers/scsi/scsi.c
--- scsi-misc-2.5-sdev/drivers/scsi/scsi.c	2003-10-06 16:26:26.000000000 -0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/scsi.c	2003-10-07 11:37:36.278438936 
-0700
@@ -373,9 +373,7 @@
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> send ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_printk(KERN_INFO, sdev, "send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -419,9 +417,7 @@
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> done ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_printk(KERN_INFO, sdev, "done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -795,8 +791,9 @@
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
-				"for device %d %x\n", sdev->id, cmd->result));
+	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev, 
+				"Notifying upper driver of completion "
+				"for device with result %x\n", cmd->result));
 
 	cmd->owner = SCSI_OWNER_HIGHLEVEL;
 	cmd->state = SCSI_STATE_FINISHED;
@@ -877,10 +874,9 @@
 			sdev->simple_tags = 1;
 			break;
 		default:
-			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
+			sdev_printk(KERN_WARNING, sdev, 
 				"scsi_adjust_queue_depth, bad queue type, "
-				"disabled\n", sdev->host->host_no,
-				sdev->channel, sdev->id, sdev->lun); 
+				"disabled\n");
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
 			sdev->queue_depth = tags;
diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/scsi_error.c 
scsi-misc-2.5-sdev-use/drivers/scsi/scsi_error.c
--- scsi-misc-2.5-sdev/drivers/scsi/scsi_error.c	2003-10-06 16:26:26.000000000 
-0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/scsi_error.c	2003-10-06 
20:42:45.000000000 -0700
@@ -222,11 +222,9 @@
 
 		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				printk("%s: %d:%d:%d:%d cmds failed: %d,"
-				       " cancel: %d\n",
-				       __FUNCTION__, shost->host_no,
-				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_cancel));
+				sdev_printk(KERN_INFO, sdev, 
+					"%s: cmds failed: %d, cancel: %d\n",
+				       __FUNCTION__, cmd_failed, cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
@@ -1055,13 +1053,9 @@
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-		printk(KERN_INFO "scsi: Device offlined - not"
-		       		" ready after error recovery: host"
-				" %d channel %d id %d lun %d\n",
-				scmd->device->host->host_no,
-				scmd->device->channel,
-				scmd->device->id,
-				scmd->device->lun);
+		sdev_printk(KERN_INFO, scmd->device, 
+				"Device offlined - not ready after error"
+				" recovery\n");
 		scmd->device->online = FALSE;
 		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
 			/*
@@ -1253,9 +1247,7 @@
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		sdev_printk(KERN_INFO, scmd->device, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/scsi_lib.c 
scsi-misc-2.5-sdev-use/drivers/scsi/scsi_lib.c
--- scsi-misc-2.5-sdev/drivers/scsi/scsi_lib.c	2003-10-06 16:26:26.000000000 
-0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/scsi_lib.c	2003-10-06 
20:42:45.000000000 -0700
@@ -821,11 +821,8 @@
 		return;
 	}
 	if (result) {
-		printk("SCSI error : <%d %d %d %d> return code = 0x%x\n",
-		       cmd->device->host->host_no,
-		       cmd->device->channel,
-		       cmd->device->id,
-		       cmd->device->lun, result);
+		sdev_printk(KERN_INFO, cmd->device, 
+			"SCSI error : return code = 0x%x\n", result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
 			print_sense("", cmd);
@@ -947,8 +944,8 @@
 		 * it back online)
 		 */
 		if(!sdev->online) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_printk(KERN_ERR, sdev, 
+				"rejecting I/O to offline device\n");
 			return BLKPREP_KILL;
 		}
 		/*
@@ -1049,9 +1046,8 @@
 		 */
 		if (--sdev->device_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d (%d:%d) unblocking device at"
-				       " zero depth\n", sdev->host->host_no,
-				       sdev->id, sdev->lun));
+				sdev_printk(KERN_INFO, sdev, 
+					"unblocking device at zero depth\n"));
 		} else {
 			blk_plug_device(q);
 			return 0;
diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/scsi_scan.c 
scsi-misc-2.5-sdev-use/drivers/scsi/scsi_scan.c
--- scsi-misc-2.5-sdev/drivers/scsi/scsi_scan.c	2003-10-06 20:08:42.000000000 
-0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/scsi_scan.c	2003-10-07 
11:12:19.751986000 -0700
@@ -329,9 +329,8 @@
 
 	*bflags = 0;
  repeat_inquiry:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
-			" channel %d id %d lun %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id, sdev->lun));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+			"scan: INQUIRY to host\n"));
 
 	memset(scsi_cmd, 0, 6);
 	scsi_cmd[0] = INQUIRY;
@@ -343,9 +342,10 @@
 	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
 		      SCSI_TIMEOUT + 4 * HZ, 3);
 
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
-			" code 0x%x\n", sreq->sr_result ?
-			"failed" : "successful", sreq->sr_result));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+			"scan: 1st INQUIRY %s with code 0x%x\n", 
+			sreq->sr_result ? "failed" : "successful", 
+			sreq->sr_result));
 
 	if (sreq->sr_result) {
 		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
@@ -391,14 +391,16 @@
 		scsi_wait_req(sreq, (void *) scsi_cmd,
 			      (void *) inq_result,
 			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
-				" %s with code 0x%x\n", sreq->sr_result ?
-				"failed" : "successful", sreq->sr_result));
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+				"scan: 2nd INQUIRY %s with code 0x%x\n", 
+				sreq->sr_result ? "failed" : "successful", 
+				sreq->sr_result));
 		if (sreq->sr_result) {
 			/* if the longer inquiry has failed, flag the device
 			 * as only accepting 36 byte inquiries and retry the
 			 * 36 byte inquiry */
-			printk(KERN_INFO "scsi scan: %d byte inquiry failed"
+			sdev_printk(KERN_INFO, sdev, 
+			       "scan: %d byte inquiry failed"
 			       " with code %d.  Consider BLIST_INQUIRY_36 for"
 			       " this device\n", possible_inq_resp_len,
 			       sreq->sr_result);
@@ -523,7 +525,8 @@
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		sdev_printk(KERN_INFO, sdev, "unknown device type %d\n", 
+				sdev->type);
 	}
 
 	print_inquiry(inq_result);
@@ -545,8 +548,9 @@
 	 * use up an sd slot.
 	 */
 	if (((inq_result[0] >> 5) & 7) == 1) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: peripheral"
-				" qualifier of 1, device offlined\n"));
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+				"scan: peripheral qualifier of 1,"
+				" device offlined\n"));
 		sdev->online = FALSE;
 	}
 
@@ -610,7 +614,8 @@
 		if (!starget) {
 			starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
 			if (!starget) {
-				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+				sdev_printk(KERN_INFO, sdev, ALLOC_FAILURE_MSG, 
+						__FUNCTION__);
 				spin_unlock_irqrestore(sdev->host->host_lock,
 						       flags);
 				return SCSI_SCAN_NO_RESPONSE;
@@ -683,9 +688,8 @@
 	if (rescan) {
 		sdev = scsi_find_device(host, channel, id, lun);
 		if (sdev) {
-			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-				"scsi scan: device exists on <%d:%d:%d:%d>\n",
-				host->host_no, channel, id, lun));
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scan: device found\n"));
 			if (sdevp)
 				*sdevp = sdev;
 			if (bflagsp)
@@ -894,7 +898,6 @@
 static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
 				int rescan)
 {
-	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
@@ -916,9 +919,6 @@
 	if (!sreq)
 		goto out;
 
-	sprintf(devname, "host %d channel %d id %d",
-		sdev->host->host_no, sdev->channel, sdev->id);
-
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the max number of luns we are requesting.
@@ -966,15 +966,15 @@
 	 * a retry.
 	 */
 	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+				"scan: Sending REPORT LUNS (try %d)\n",
 				retries));
 		scsi_wait_req(sreq, scsi_cmd, lun_data, length,
 				SCSI_TIMEOUT + 4*HZ, 3);
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", sreq->sr_result
-				?  "failed" : "successful", retries,
-				sreq->sr_result));
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+				"scan: REPORT LUNS %s (try %d) result 0x%x\n", 
+				sreq->sr_result	? "failed" : "successful", 
+				retries, sreq->sr_result));
 		if (sreq->sr_result == 0 ||
 		    sreq->sr_sense_buffer[2] != UNIT_ATTENTION)
 			break;
@@ -999,16 +999,15 @@
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
-		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, num_luns);
+		sdev_printk(KERN_WARNING, sdev, 
+			"Only %d (max_scsi_report_luns) of %d luns"
+			" reported, try increasing max_scsi_report_luns.\n", 
+			max_scsi_report_luns, num_luns);
 		num_luns = max_scsi_report_luns;
 	}
 
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUN scan of"
-			" host %d channel %d id %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+			"scan: REPORT LUN scan\n"));
 
 	/*
 	 * Scan the luns in lun_data. The entry at offset 0 is really
@@ -1029,7 +1028,7 @@
 			 * this differs from what linux would print for the
 			 * integer LUN value.
 			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
+			sdev_printk(KERN_WARNING, sdev, "lun 0x");
 			data = (char *)lunp->scsi_lun;
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
@@ -1039,9 +1038,9 @@
 			 * LUN 0 has already been scanned.
 			 */
 		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+			sdev_printk(KERN_WARNING, sdev, 
+				"lun%d has a LUN larger than allowed"
+				" by the host adapter\n", lun);
 		} else {
 			int res;
 
@@ -1051,9 +1050,9 @@
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				printk(KERN_ERR "scsi: Unexpected response"
-				       " from %s lun %d while scanning, scan"
-				       " aborted\n", devname, lun);
+				sdev_printk(KERN_ERR, sdev, 
+					"Unexpected response from lun %d"
+					" while scanning, scan aborted\n", lun);
 				break;
 			}
 		}
@@ -1068,7 +1067,7 @@
 	/*
 	 * We are out of memory, don't try scanning any further.
 	 */
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+	sdev_printk(KERN_INFO, sdev, ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
 #else
diff -urN --exclude=SCCS scsi-misc-2.5-sdev/drivers/scsi/scsi_sysfs.c 
scsi-misc-2.5-sdev-use/drivers/scsi/scsi_sysfs.c
--- scsi-misc-2.5-sdev/drivers/scsi/scsi_sysfs.c	2003-10-06 20:09:14.000000000 
-0700
+++ scsi-misc-2.5-sdev-use/drivers/scsi/scsi_sysfs.c	2003-10-06 
20:51:32.000000000 -0700
@@ -352,7 +352,7 @@
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev, "error 1\n");
 		return error;
 	}
 
@@ -360,7 +360,7 @@
 
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_printk(KERN_INFO, sdev, "error 2\n");
 		goto clean_device;
 		return error;
 	}

