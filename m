From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [PATCH] sdev_printk - scsi_device helper macro
Date: Mon, 19 Jan 2004 13:55:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401191355.37522.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:29420 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263053AbUASV6q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:58:46 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0JLwjvM678228
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2004 16:58:45 -0500
Received: from DYN319713.beaverton.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0JLwiGl122118
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2004 16:58:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello all,

I originally posted this patch for comments back in September:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106487047707538&w=2

This patch is intended for the mid-layer and for LLDs, its purpose is:

1) Add consistency to printks. The macro enables a consistent format for 
scsi_device information. The format will help readability and will provide a 
means to automate log message responses. 

2) Identify a log message with a specific scsi_device.

3) Provide a single point for changing scsi_device information necessary for 
identifying the device. One could simply change the macro to change what 
scsi_device information is printed with printks rather than having to edit 
every single printk in the mid-layer and LLDs.

The patch isn't very invasive, merely adding a set of macros in scsi_device.h 
and then applying those macros to certain places in the mid-layer. The macros 
are very similar to the currently accepted and used dev_printk macros. 

I have made this patch against the scsi-misc-2.6 tree (had done to 2.7, but 
that disappeared). It should also apply to 2.6.1. 

All comments are welcome. 

Please apply.

Thanks,

Dan


PATCH FOLLOWS:
----------------------

diff -Nur --exclude=SCCS scsi-misc-2.6/include/scsi/scsi_device.h 
scsi-misc-2.6-sdevpk/include/scsi/scsi_device.h
--- scsi-misc-2.6/include/scsi/scsi_device.h	2004-01-19 11:30:55.000000000 
-0800
+++ scsi-misc-2.6-sdevpk/include/scsi/scsi_device.h	2004-01-19 
11:42:03.000000000 -0800
@@ -110,6 +110,23 @@
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
 
+#define sdev_printk(level, sdev, format, arg...) \
+	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ##arg)
+
+#ifdef DEBUG
+#define sdev_dbg(sdev, format, arg...)            \
+	sdev_printk(KERN_DEBUG , sdev , format , ## arg)
+#else
+#define sdev_dbg(sdev, format, arg...) do {} while (0)
+#endif
+
+#define sdev_err(sdev, format, arg...)            \
+	sdev_printk(KERN_ERR , sdev , format , ## arg)
+#define sdev_info(sdev, format, arg...)           \
+	sdev_printk(KERN_INFO , sdev , format , ## arg)
+#define sdev_warn(sdev, format, arg...)           \
+	sdev_printk(KERN_WARNING , sdev , format , ## arg)
+
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/constants.c 
scsi-misc-2.6-sdevpk/drivers/scsi/constants.c
--- scsi-misc-2.6/drivers/scsi/constants.c	2004-01-19 11:30:41.000000000 -0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/constants.c	2004-01-19 
11:42:03.000000000 -0800
@@ -1123,11 +1123,7 @@
 }
 
 void print_Scsi_Cmnd(struct scsi_cmnd *cmd) {
-    printk("scsi%d : destination target %d, lun %d\n", 
-	   cmd->device->host->host_no, 
-	   cmd->device->id, 
-	   cmd->device->lun);
-    printk("        command = ");
+    sdev_info(cmd->device, "        command = ");
     print_command(cmd->cmnd);
 }
 
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/scsi.c 
scsi-misc-2.6-sdevpk/drivers/scsi/scsi.c
--- scsi-misc-2.6/drivers/scsi/scsi.c	2004-01-19 11:30:42.000000000 -0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/scsi.c	2004-01-19 11:42:03.000000000 
-0800
@@ -388,9 +388,7 @@
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> send ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_info(sdev, "send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -434,9 +432,7 @@
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> done ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_info(sdev, "done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -820,8 +816,9 @@
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
-				"for device %d %x\n", sdev->id, cmd->result));
+	SCSI_LOG_MLCOMPLETE(4, sdev_info(sdev,
+				"Notifying upper driver of completion "
+				"for device with result %x\n", cmd->result));
 
 	cmd->owner = SCSI_OWNER_HIGHLEVEL;
 	cmd->state = SCSI_STATE_FINISHED;
@@ -902,10 +899,8 @@
 			sdev->simple_tags = 1;
 			break;
 		default:
-			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
-				"scsi_adjust_queue_depth, bad queue type, "
-				"disabled\n", sdev->host->host_no,
-				sdev->channel, sdev->id, sdev->lun); 
+			sdev_warn(sdev, "scsi_adjust_queue_depth,"
+				" bad queue type, disabled\n");
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
 			sdev->queue_depth = tags;
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/scsi_error.c 
scsi-misc-2.6-sdevpk/drivers/scsi/scsi_error.c
--- scsi-misc-2.6/drivers/scsi/scsi_error.c	2004-01-19 11:30:42.000000000 
-0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/scsi_error.c	2004-01-19 
11:42:03.000000000 -0800
@@ -221,12 +221,9 @@
 		}
 
 		if (cmd_cancel || cmd_failed) {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				printk("%s: %d:%d:%d:%d cmds failed: %d,"
-				       " cancel: %d\n",
-				       __FUNCTION__, shost->host_no,
-				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_cancel));
+			SCSI_LOG_ERROR_RECOVERY(3, sdev_info(sdev, 
+					"%s: cmds failed: %d, cancel: %d\n",
+				       __FUNCTION__, cmd_failed, cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
@@ -1059,13 +1056,8 @@
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-		printk(KERN_INFO "scsi: Device offlined - not"
-		       		" ready after error recovery: host"
-				" %d channel %d id %d lun %d\n",
-				scmd->device->host->host_no,
-				scmd->device->channel,
-				scmd->device->id,
-				scmd->device->lun);
+		sdev_info(scmd->device, 
+			"Device offlined - not ready after error recovery\n");
 		scmd->device->online = FALSE;
 		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
 			/*
@@ -1257,9 +1249,7 @@
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		sdev_info(scmd->device, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/scsi_lib.c 
scsi-misc-2.6-sdevpk/drivers/scsi/scsi_lib.c
--- scsi-misc-2.6/drivers/scsi/scsi_lib.c	2004-01-19 11:30:42.000000000 -0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/scsi_lib.c	2004-01-19 11:42:03.000000000 
-0800
@@ -806,9 +806,8 @@
 			break;
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
-			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
-			       cmd->device->host->host_no, (int) cmd->device->channel,
-			       (int) cmd->device->id, (int) cmd->device->lun);
+			sdev_err(cmd->device, "ERROR on channel %d, CDB: ", 
+				cmd->device->channel);
 			print_command(cmd->data_cmnd);
 			print_sense("", cmd);
 			cmd = scsi_end_request(cmd, 0, block_sectors, 1);
@@ -827,11 +826,8 @@
 		return;
 	}
 	if (result) {
-		printk("SCSI error : <%d %d %d %d> return code = 0x%x\n",
-		       cmd->device->host->host_no,
-		       cmd->device->channel,
-		       cmd->device->id,
-		       cmd->device->lun, result);
+		sdev_err(cmd->device, "SCSI error : return code = 0x%x\n", 
+			result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
 			print_sense("", cmd);
@@ -931,8 +927,7 @@
 		if(sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_err(sdev, "rejecting I/O to dead device\n");
 			return BLKPREP_KILL;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -963,8 +958,8 @@
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 
 		if(unlikely(specials_only)) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_err(sdev, 
+				"rejecting I/O to device being removed\n");
 			return BLKPREP_KILL;
 		}
 			
@@ -977,8 +972,7 @@
 		 * it back online)
 		 */
 		if(!sdev->online) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_err(sdev, "rejecting I/O to offline device\n");
 			return BLKPREP_KILL;
 		}
 		/*
@@ -1078,10 +1072,8 @@
 		 * unblock after device_blocked iterates to zero
 		 */
 		if (--sdev->device_blocked == 0) {
-			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d (%d:%d) unblocking device at"
-				       " zero depth\n", sdev->host->host_no,
-				       sdev->id, sdev->lun));
+			SCSI_LOG_MLQUEUE(3, sdev_info(sdev, 
+				"unblocking device at zero depth\n"));
 		} else {
 			blk_plug_device(q);
 			return 0;
@@ -1111,9 +1103,8 @@
 		 * unblock after host_blocked iterates to zero
 		 */
 		if (--shost->host_blocked == 0) {
-			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d unblocking host at zero depth\n",
-					shost->host_no));
+			SCSI_LOG_MLQUEUE(3, sdev_info(sdev, 
+				"unblocking host at zero depth\n"));
 		} else {
 			blk_plug_device(q);
 			return 0;
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/scsi_scan.c 
scsi-misc-2.6-sdevpk/drivers/scsi/scsi_scan.c
--- scsi-misc-2.6/drivers/scsi/scsi_scan.c	2004-01-19 11:30:42.000000000 -0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/scsi_scan.c	2004-01-19 
11:42:03.000000000 -0800
@@ -318,9 +318,7 @@
 
 	*bflags = 0;
  repeat_inquiry:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
-			" channel %d id %d lun %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id, sdev->lun));
+	SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, "scan: INQUIRY to host\n"));
 
 	memset(scsi_cmd, 0, 6);
 	scsi_cmd[0] = INQUIRY;
@@ -332,9 +330,10 @@
 	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
 		      SCSI_TIMEOUT + 4 * HZ, 3);
 
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
-			" code 0x%x\n", sreq->sr_result ?
-			"failed" : "successful", sreq->sr_result));
+	SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, 
+			"scan: 1st INQUIRY %s with code 0x%x\n", 
+			sreq->sr_result ? "failed" : "successful", 
+			sreq->sr_result));
 
 	if (sreq->sr_result) {
 		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
@@ -380,14 +379,15 @@
 		scsi_wait_req(sreq, (void *) scsi_cmd,
 			      (void *) inq_result,
 			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
-				" %s with code 0x%x\n", sreq->sr_result ?
-				"failed" : "successful", sreq->sr_result));
+		SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, 
+				"scan: 2nd INQUIRY %s with code 0x%x\n", 
+				sreq->sr_result ? "failed" : "successful", 
+				sreq->sr_result));
 		if (sreq->sr_result) {
 			/* if the longer inquiry has failed, flag the device
 			 * as only accepting 36 byte inquiries and retry the
 			 * 36 byte inquiry */
-			printk(KERN_INFO "scsi scan: %d byte inquiry failed"
+			sdev_info(sdev, "scan: %d byte inquiry failed"
 			       " with code %d.  Consider BLIST_INQUIRY_36 for"
 			       " this device\n", possible_inq_resp_len,
 			       sreq->sr_result);
@@ -512,7 +512,7 @@
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		sdev_info(sdev, "unknown device type %d\n", sdev->type);
 	}
 
 	print_inquiry(inq_result);
@@ -534,8 +534,9 @@
 	 * use up an sd slot.
 	 */
 	if (((inq_result[0] >> 5) & 7) == 1) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: peripheral"
-				" qualifier of 1, device offlined\n"));
+		SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, 
+				"scan: peripheral qualifier of 1,"
+				" device offlined\n"));
 		sdev->online = FALSE;
 	}
 
@@ -599,7 +600,8 @@
 		if (!starget) {
 			starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
 			if (!starget) {
-				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+				sdev_info(sdev, ALLOC_FAILURE_MSG, 
+					__FUNCTION__);
 				spin_unlock_irqrestore(sdev->host->host_lock,
 						       flags);
 				return SCSI_SCAN_NO_RESPONSE;
@@ -672,9 +674,8 @@
 	if (rescan) {
 		sdev = scsi_device_lookup(host, channel, id, lun);
 		if (sdev) {
-			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-				"scsi scan: device exists on <%d:%d:%d:%d>\n",
-				host->host_no, channel, id, lun));
+			SCSI_LOG_SCAN_BUS(3, sdev_info(sdev,
+						"scan: device found\n"));
 			if (sdevp)
 				*sdevp = sdev;
 			if (bflagsp)
@@ -888,7 +889,6 @@
 static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
 				int rescan)
 {
-	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
@@ -910,9 +910,6 @@
 	if (!sreq)
 		goto out;
 
-	sprintf(devname, "host %d channel %d id %d",
-		sdev->host->host_no, sdev->channel, sdev->id);
-
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the max number of luns we are requesting.
@@ -960,15 +957,15 @@
 	 * a retry.
 	 */
 	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
+		SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, 
+				"scan: Sending REPORT LUNS (try %d)\n",
 				retries));
 		scsi_wait_req(sreq, scsi_cmd, lun_data, length,
 				SCSI_TIMEOUT + 4*HZ, 3);
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", sreq->sr_result
-				?  "failed" : "successful", retries,
-				sreq->sr_result));
+		SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, 
+				"scan: REPORT LUNS %s (try %d) result 0x%x\n", 
+				sreq->sr_result	? "failed" : "successful", 
+				retries, sreq->sr_result));
 		if (sreq->sr_result == 0 ||
 		    sreq->sr_sense_buffer[2] != UNIT_ATTENTION)
 			break;
@@ -993,16 +990,13 @@
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
-		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, num_luns);
+		sdev_warn(sdev, "Only %d (max_scsi_report_luns) of %d luns"
+			" reported, try increasing max_scsi_report_luns.\n",
+			max_scsi_report_luns, num_luns);
 		num_luns = max_scsi_report_luns;
 	}
 
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUN scan of"
-			" host %d channel %d id %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id));
+	SCSI_LOG_SCAN_BUS(3, sdev_info(sdev, "scan: REPORT LUN scan\n"));
 
 	/*
 	 * Scan the luns in lun_data. The entry at offset 0 is really
@@ -1023,7 +1017,7 @@
 			 * this differs from what linux would print for the
 			 * integer LUN value.
 			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
+			sdev_warn(sdev, "lun 0x");
 			data = (char *)lunp->scsi_lun;
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
@@ -1033,9 +1027,8 @@
 			 * LUN 0 has already been scanned.
 			 */
 		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+			sdev_warn(sdev, "lun%d has a LUN larger than allowed"
+				" by the host adapter\n", lun);
 		} else {
 			int res;
 
@@ -1045,9 +1038,8 @@
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				printk(KERN_ERR "scsi: Unexpected response"
-				       " from %s lun %d while scanning, scan"
-				       " aborted\n", devname, lun);
+				sdev_err(sdev, "Unexpected response from lun %d"
+					" while scanning, scan aborted\n", lun);
 				break;
 			}
 		}
@@ -1062,7 +1054,7 @@
 	/*
 	 * We are out of memory, don't try scanning any further.
 	 */
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+	sdev_info(sdev, ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
 #else
diff -Nur --exclude=SCCS scsi-misc-2.6/drivers/scsi/scsi_sysfs.c 
scsi-misc-2.6-sdevpk/drivers/scsi/scsi_sysfs.c
--- scsi-misc-2.6/drivers/scsi/scsi_sysfs.c	2004-01-19 11:30:42.000000000 
-0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/scsi_sysfs.c	2004-01-19 
11:42:03.000000000 -0800
@@ -353,13 +353,13 @@
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		printk(KERN_INFO "error 1\n");
+		sdev_info(sdev, "error 1\n");
 		return error;
 	}
 
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_info(sdev, "error 2\n");
 		goto clean_device;
 	}
 

