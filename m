From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug delayed result, lk 2.4.27
Date: Tue, 31 Aug 2004 23:29:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41347D44.1000808@torque.net>
References: <4134700A.30701@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060802060008070200000509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:34228 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268482AbUHaNaY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 09:30:24 -0400
In-Reply-To: <4134700A.30701@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: marcelo.tosatti@cyclades.com

This is a multi-part message in MIME format.
--------------060802060008070200000509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> The error result code is not conveyed back to the mid-level
> for delayed commands (i.e. when scsi_debug_delay!=0) in
> lk 2.4.27 (and earlier). [This bug is not present in the
> lk 2.6 version of scsi_debug.]
> 
> Change:
>     - convey error result back to midlevel for delayed commands

Hmm, looks like version 0.62 didn't make it into the lk 2.4
series. Here are both 0.62 and 0.63 rolled together.

Changes:
     - convey error result back to midlevel for delayed commands
     - set both DRIVER_SENSE and CHECK_CONDITION in error results
     - refine MEDIUM ERROR generation

Doug Gilbert

--------------060802060008070200000509
Content-Type: text/x-patch;
 name="scsi_debug2427b.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug2427b.diff"

--- linux/drivers/scsi/scsi_debug.c	2002-11-29 21:26:14.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c2427fix	2004-08-31 20:01:41.000000000 +1000
@@ -48,7 +48,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 0.61 (20020815)";
+static const char * scsi_debug_version_str = "Version: 0.63 (20040831)";
 
 
 #ifndef SCSI_CMD_READ_16
@@ -73,7 +73,7 @@
 #define SCSI_DEBUG_OPT_MEDIUM_ERR   2
 #define SCSI_DEBUG_OPT_EVERY_NTH   4
 
-#define OPT_MEDIUM_ERR_ADDR   0x1234
+#define OPT_MEDIUM_ERR_ADDR   0x1234  /* that's 4660 in decimal */
 
 static int scsi_debug_num_devs = DEF_NR_FAKE_DEVS;
 static int scsi_debug_opts = DEF_OPTS;
@@ -124,7 +124,7 @@
 
 static unsigned char * fake_storep;	/* ramdisk storage */
 
-static unsigned char broken_buff[SDEBUG_SENSE_LEN];
+static unsigned char spare_buff[SDEBUG_SENSE_LEN];
 
 static int num_aborts = 0;
 static int num_dev_resets = 0;
@@ -193,8 +193,7 @@
 	else 
 		buff = (unsigned char *) SCpnt->request_buffer;
 	if (NULL == buff) {
-		printk(KERN_WARNING "scsi_debug:qc: buff was NULL??\n");
-		buff = broken_buff;	/* just point at dummy */
+		buff = spare_buff;	/* just point at dummy */
 		bufflen = SDEBUG_SENSE_LEN;
 	}
 
@@ -370,7 +369,7 @@
 		if ((errsts = check_reset(SCpnt, devip)))
 			break;
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x20, 0, 14);
-		errsts = (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		errsts = (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 		break;
 	}
 	return schedule_resp(SCpnt, devip, done, errsts, scsi_debug_delay);
@@ -390,7 +389,7 @@
 	if (devip->reset) {
 		devip->reset = 0;
 		mk_sense_buffer(devip, UNIT_ATTENTION, 0x29, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	return 0;
 }
@@ -451,7 +450,7 @@
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
 		int dev_id_num, len;
 		char dev_id_str[6];
@@ -476,7 +475,7 @@
 		} else {
 			/* Illegal request, invalid field in cdb */
 			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-			return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+			return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 		}
 		memcpy(buff, arr, min_len); 
 		return 0;
@@ -589,7 +588,7 @@
 	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x39, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	dev_spec = DEV_READONLY(target) ? 0x80 : 0x0;
 	if (msense_6) {
@@ -631,7 +630,7 @@
 		break;
 	default:
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if (msense_6)
 		arr[0] = offset - 1;
@@ -655,14 +654,14 @@
 
 	if (upper_blk || (block + num > CAPACITY)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x21, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
-	    (block >= OPT_MEDIUM_ERR_ADDR) && 
-	    (block < (OPT_MEDIUM_ERR_ADDR + num))) {
+	    (block <= OPT_MEDIUM_ERR_ADDR) &&
+            ((block + num) > OPT_MEDIUM_ERR_ADDR)) {
 		mk_sense_buffer(devip, MEDIUM_ERROR, 0x11, 0, 14);
 		/* claim unrecoverable read error */
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	read_lock_irqsave(&atomic_rw, iflags);
         sgcount = 0;
@@ -704,7 +703,7 @@
 
 	if (upper_blk || (block + num > CAPACITY)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x21, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 
 	write_lock_irqsave(&atomic_rw, iflags);
@@ -744,7 +743,7 @@
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	if ((alloc_len < 16) || (select_report > 2)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x24, 0, 14);
-		return (COMMAND_COMPLETE << 8) | (CHECK_CONDITION << 1);
+		return (DRIVER_SENSE << 24) | (CHECK_CONDITION << 1);
 	}
 	if (bufflen > 3) {
 		memset(buff, 0, bufflen);
@@ -773,8 +772,10 @@
 		return;
 	}
 	sqcp->in_use = 0;
-	if (sqcp->done_funct)
+	if (sqcp->done_funct) {
+		sqcp->a_cmnd->result = sqcp->scsi_result;
 		sqcp->done_funct(sqcp->a_cmnd); /* callback to mid level */
+	}
 	sqcp->done_funct = NULL;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }

--------------060802060008070200000509--
