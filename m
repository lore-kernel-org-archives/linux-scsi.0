From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug version 1.66 against 2.5.50bk3
Date: Thu, 05 Dec 2002 10:16:22 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DEE8CC6.7070507@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050707030009070303080008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-59.triode.net.au [202.147.125.59])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gB4NEhU13220
	for <linux-scsi@vger.kernel.org>; Thu, 5 Dec 2002 10:14:44 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050707030009070303080008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a small clean up of scsi_debug against
lk 2.5.50bk3

Module load time parameters still don't work so
I tweak this driver's _DEF defines and recompile
as required. [Evidentally Rusty has patches to
recognize module load time parameters but they haven't
made it through to the main tree yet.]

Doug Gilbert

--------------050707030009070303080008
Content-Type: text/plain;
 name="scsi_debug2550bk3_166.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug2550bk3_166.diff"

--- linux/drivers/scsi/scsi_debug.c	2002-12-04 10:21:16.000000000 +1100
+++ linux/drivers/scsi/scsi_debug.c2550bk3_166	2002-12-05 10:06:14.000000000 +1100
@@ -51,7 +51,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.65 (20021119)";
+static const char * scsi_debug_version_str = "Version: 1.66 (20021205)";
 
 #ifndef SCSI_CMD_READ_16
 #define SCSI_CMD_READ_16 0x88
@@ -397,7 +397,7 @@
 		if ((errsts = check_reset(SCpnt, devip)))
 			break;
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x20, 0, 14);
-		errsts = (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		errsts = (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 		break;
 	}
 	return schedule_resp(SCpnt, devip, done, errsts, scsi_debug_delay);
@@ -417,7 +417,7 @@
 	if (devip->reset) {
 		devip->reset = 0;
 		mk_sense_buffer(devip, UNIT_ATTENTION, 0x29, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	return 0;
 }
@@ -478,7 +478,7 @@
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
 		int dev_id_num, len;
 		char dev_id_str[6];
@@ -503,7 +503,7 @@
 		} else {
 			/* Illegal request, invalid field in cdb */
 			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-			return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+			return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 		}
 		memcpy(buff, arr, min_len); 
 		return 0;
@@ -616,7 +616,7 @@
 	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x39, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	dev_spec = DEV_READONLY(target) ? 0x80 : 0x0;
 	if (msense_6) {
@@ -659,7 +659,7 @@
 		break;
 	default:
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if (msense_6)
 		arr[0] = offset - 1;
@@ -683,14 +683,14 @@
 
 	if (upper_blk || (block + num > sdebug_capacity)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x21, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
 	    (block >= OPT_MEDIUM_ERR_ADDR) && 
 	    (block < (OPT_MEDIUM_ERR_ADDR + num))) {
 		mk_sense_buffer(devip, MEDIUM_ERROR, 0x11, 0, 14);
 		/* claim unrecoverable read error */
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	read_lock_irqsave(&atomic_rw, iflags);
         sgcount = 0;
@@ -732,7 +732,7 @@
 
 	if (upper_blk || (block + num > sdebug_capacity)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x21, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 
 	write_lock_irqsave(&atomic_rw, iflags);
@@ -773,7 +773,7 @@
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	if ((alloc_len < 16) || (select_report > 2)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if (bufflen > 3) {
 		lun_cnt = min((int)(bufflen / sizeof(ScsiLun)),

--------------050707030009070303080008--

