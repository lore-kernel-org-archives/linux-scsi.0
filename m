From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [RFC] scsi_device printk helper macro - sdev_printk -> with patch
Date: Mon, 29 Sep 2003 14:13:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309291413.51987.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:13184 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263069AbTI2VO4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 17:14:56 -0400
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e6.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id h8TLEtIq463596
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 17:14:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Larry Kessler <lkessler@us.ibm.com>, James Keniston <kenistoj@us.ibm.com>


The purpose of the sdev_printk macro, which is intended for the scsi mid-layer 
and LLDs, is to help with the following:

- Adding consistency to printk messages in mid-layer and LLDs where 
scsi_device is concerned. Scsi_device information will be printed in the same 
consistent format. A consistent format will help readability and provide a 
means to automate responding to log messages.

- Identifing a printk with a specific scsi_device. 

- Providing one point for changing what identification information is printed. 
Instead of having to edit every single printk, one could simply change the 
macro. 

The patch below does a couple things:

1) Moves setting scsi_device's sdev_gendev struct device bus_id from 
scsi_sysfs.c to scsi_scan.c.

2) Adds sdev_printk definition to scsi_device.h

3) Replaces many printks in the mid-layer with sdev_printk.

Please take a look, all comments and suggestions are welcome.


Thanks,


Dan



Example Output - Rescan
-----------------------------

Sep 26 13:31:48 elm3b99 kernel: scsi_scan_host_selected: 
<3:4294967295:4294967295:4294967295>
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 0
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 1
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 2
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:3:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:3:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:49 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 3
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:1>: scan: INQUIRY to host
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:1>: scan: 1st INQUIRY failed with 
code 0x10000


Patch Follows:
----------------

diff -urN linux-2.6.0-test5/include/scsi/scsi_device.h 
linux-2.6.0-test5-sdev/include/scsi/scsi_device.h
--- linux-2.6.0-test5/include/scsi/scsi_device.h	2003-09-08 12:49:51.000000000 
-0700
+++ linux-2.6.0-test5-sdev/include/scsi/scsi_device.h	2003-09-26 
14:47:23.155988528 -0700
@@ -102,6 +102,9 @@
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
 
+#define sdev_printk(level, sdev, format, arg...) \
+	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id, ## arg)
+
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
diff -urN linux-2.6.0-test5/drivers/scsi/scsi.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi.c
--- linux-2.6.0-test5/drivers/scsi/scsi.c	2003-09-08 12:50:06.000000000 -0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi.c	2003-09-26 09:49:42.000000000 
-0700
@@ -742,8 +742,9 @@
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(3, printk("Notifying upper driver of completion "
-				"for device %d %x\n", sdev->id, cmd->result));
+	SCSI_LOG_MLCOMPLETE(3, sdev_printk(KERN_INFO, sdev, 
+				"Notifying upper driver of completion "
+				"for device with result %x\n", cmd->result));
 
 	cmd->owner = SCSI_OWNER_HIGHLEVEL;
 	cmd->state = SCSI_STATE_FINISHED;
@@ -824,10 +825,9 @@
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
diff -urN linux-2.6.0-test5/drivers/scsi/scsi_debug.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi_debug.c
--- linux-2.6.0-test5/drivers/scsi/scsi_debug.c	2003-09-08 12:50:08.000000000 
-0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi_debug.c	2003-09-26 
10:08:29.000000000 -0700
@@ -920,8 +920,7 @@
 static int scsi_debug_slave_alloc(struct scsi_device * sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_alloc\n");
 	return 0;
 }
 
@@ -930,8 +929,7 @@
 	struct sdebug_dev_info * devip; 
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_configure\n");
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
 	devip = devInfoReg(sdp);
@@ -948,8 +946,7 @@
 				(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_destroy\n");
 	if (devip) {
 		/* make this slot avaliable for re-use */
 		devip->used = 0;
@@ -1169,9 +1166,9 @@
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug: ... <%u %u %u %u> "
-			       "non-zero result=0x%x\n", sdp->host->host_no,
-			       sdp->channel, sdp->id, sdp->lun, scsi_result);
+			sdev_printk(KERN_INFO, sdp, 
+				"scsi_debug: non-zero result=0x%x\n", 
+				scsi_result);
 		}
 	}
 	if (cmnd && devip) {
diff -urN linux-2.6.0-test5/drivers/scsi/scsi_error.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi_error.c
--- linux-2.6.0-test5/drivers/scsi/scsi_error.c	2003-09-08 12:49:51.000000000 
-0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi_error.c	2003-09-26 
10:02:55.000000000 -0700
@@ -226,11 +226,9 @@
 
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
@@ -1068,13 +1066,9 @@
 
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
@@ -1274,9 +1268,7 @@
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		sdev_printk(KERN_INFO, scmd->device, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff -urN linux-2.6.0-test5/drivers/scsi/scsi_lib.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi_lib.c
--- linux-2.6.0-test5/drivers/scsi/scsi_lib.c	2003-09-08 12:50:06.000000000 
-0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi_lib.c	2003-09-26 
10:28:02.000000000 -0700
@@ -822,11 +822,8 @@
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
@@ -948,8 +945,8 @@
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
@@ -1050,9 +1047,8 @@
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
diff -urN linux-2.6.0-test5/drivers/scsi/scsi_scan.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi_scan.c
--- linux-2.6.0-test5/drivers/scsi/scsi_scan.c	2003-09-08 12:50:21.000000000 
-0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi_scan.c	2003-09-26 
13:20:27.000000000 -0700
@@ -264,6 +264,9 @@
 	if (!sdev->scsi_level)
 		sdev->scsi_level = SCSI_2;
 
+	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+
 	/*
 	 * Add it to the end of the shost->my_devices list.
 	 */
@@ -332,9 +335,8 @@
 
 	*bflags = 0;
  repeat_inquiry:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
-			" channel %d id %d lun %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id, sdev->lun));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+			"scan: INQUIRY to host\n"));
 
 	memset(scsi_cmd, 0, 6);
 	scsi_cmd[0] = INQUIRY;
@@ -346,9 +348,10 @@
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
@@ -394,17 +397,19 @@
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
-			       " with code %d.  Consider BLIST_INQUIRY_36 for"
-			       " this device\n", possible_inq_resp_len,
-			       sreq->sr_result);
+			sdev_printk(KERN_INFO, sdev, 
+				"scan: %d byte inquiry failed"
+				" with code %d.  Consider BLIST_INQUIRY_36 for"
+				" this device\n", possible_inq_resp_len,
+				sreq->sr_result);
 			*bflags = BLIST_INQUIRY_36;
 			goto repeat_inquiry;
 		}
@@ -526,7 +531,8 @@
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		sdev_printk(KERN_INFO, sdev,  
+				"scsi: unknown device type %d\n", sdev->type);
 	}
 
 	print_inquiry(inq_result);
@@ -548,8 +554,9 @@
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
 
@@ -613,7 +620,8 @@
 		if (!starget) {
 			starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
 			if (!starget) {
-				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+				sdev_printk(KERN_INFO, sdev, ALLOC_FAILURE_MSG,
+					__FUNCTION__);
 				spin_unlock_irqrestore(sdev->host->host_lock,
 						       flags);
 				return SCSI_SCAN_NO_RESPONSE;
@@ -678,9 +686,8 @@
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
@@ -719,8 +726,8 @@
 		 * logical disk configured at sdev->lun, but there
 		 * is a target id responding.
 		 */
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-					"scsi scan: peripheral qualifier of 3,"
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+					"scan: peripheral qualifier of 3,"
 					" no device added\n"));
 		res = SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
@@ -888,7 +895,6 @@
 static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
 				int rescan)
 {
-	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
@@ -910,9 +916,6 @@
 	if (!sreq)
 		goto out;
 
-	sprintf(devname, "host %d channel %d id %d",
-		sdev->host->host_no, sdev->channel, sdev->id);
-
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the max number of luns we are requesting.
@@ -960,13 +963,14 @@
 	 * a retry.
 	 */
 	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
+		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev, 
+				"scan: Sending REPORT LUNS (try %d)\n", 
 				retries));
 		scsi_wait_req(sreq, scsi_cmd, lun_data, length,
 				SCSI_TIMEOUT + 4*HZ, 3);
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", sreq->sr_result
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev, 
+				"scan: REPORT LUNS %s (try %d)"
+				" result 0x%x\n", sreq->sr_result
 				?  "failed" : "successful", retries,
 				sreq->sr_result));
 		if (sreq->sr_result == 0 ||
@@ -993,16 +997,15 @@
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
-		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, num_luns);
+		sdev_printk(KERN_WARNING, sdev, 
+			"scsi: Only %d (max_scsi_report_luns) of %d luns"
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
@@ -1023,7 +1026,7 @@
 			 * this differs from what linux would print for the
 			 * integer LUN value.
 			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
+			sdev_printk(KERN_WARNING, sdev, "scsi: lun 0x");
 			data = (char *)lunp->scsi_lun;
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
@@ -1033,9 +1036,9 @@
 			 * LUN 0 has already been scanned.
 			 */
 		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+			sdev_printk(KERN_WARNING, sdev, 
+				"scsi: lun%d has a LUN larger than allowed"
+			       " by the host adapter\n", lun);
 		} else {
 			int res;
 
@@ -1045,9 +1048,9 @@
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				printk(KERN_ERR "scsi: Unexpected response"
-				       " from %s lun %d while scanning, scan"
-				       " aborted\n", devname, lun);
+				sdev_printk(KERN_ERR, sdev, 
+					"scsi: Unexpected response from lun %d"
+				       " while scanning, scan aborted\n", lun);
 				break;
 			}
 		}
@@ -1062,7 +1065,7 @@
 	/*
 	 * We are out of memory, don't try scanning any further.
 	 */
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+	sdev_printk(KERN_INFO, sdev, ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
 #else
diff -urN linux-2.6.0-test5/drivers/scsi/scsi_sysfs.c 
linux-2.6.0-test5-sdev/drivers/scsi/scsi_sysfs.c
--- linux-2.6.0-test5/drivers/scsi/scsi_sysfs.c	2003-09-08 12:49:56.000000000 
-0700
+++ linux-2.6.0-test5-sdev/drivers/scsi/scsi_sysfs.c	2003-09-26 
10:21:30.000000000 -0700
@@ -345,8 +345,6 @@
 
 	set_bit(SDEV_ADD, &sdev->sdev_state);
 	device_initialize(&sdev->sdev_gendev);
-	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;
@@ -359,7 +357,7 @@
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev, "error 1\n");
 		return error;
 	}
 
@@ -367,7 +365,7 @@
 
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_printk(KERN_INFO, sdev, "error 2\n");
 		goto clean_device;
 		return error;
 	}


