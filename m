From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Make error printing more user friendly
Date: Fri, 09 Feb 2007 03:03:51 -0500
Message-ID: <yq1hctvycyg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:37952 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946190AbXBIIEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 03:04:10 -0500
Received: from rgmgw2.us.oracle.com (rgmgw2.us.oracle.com [138.1.186.111])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id l19848SH025397
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 01:04:08 -0700
Received: from rcsmt251.oracle.com (rcsmt251.oracle.com [148.87.90.196])
	by rgmgw2.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l197vWnr023031
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 01:04:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch makes SCSI error printing more user friendly by:

1. Replacing the (currently unused) functions scsi_print_hostbyte()
   and scsi_print_driverbyte() with scsi_print_result()

2. Replacing the dreaded "SCSI error: return code" in
   scsi_io_completion with a call to scsi_print_result()

3. Making scmd_printk() output the disk name if available

The net result is that:

   sd 0:0:0:0: SCSI error: return code = 0x08000002
   sda: Current: sense key: Aborted Command
       Additional sense: Logical block reference tag check failed

becomes:

   sda: Error: hostbyte=DID_OK  driverbyte=DRIVER_SENSE,SUGGEST_OK
   sda: Current: sense key: Aborted Command
       Additional sense: Logical block reference tag check failed

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

 drivers/scsi/constants.c   |   48 +++++++++++++++++++--------------------------
 drivers/scsi/scsi_lib.c    |    4 ---
 include/scsi/scsi_dbg.h    |    3 --
 include/scsi/scsi_device.h |    3 ++
 4 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 61f6024..48038ea 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1327,25 +1327,6 @@ static const char * const hostbyte_table[]={
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
-void scsi_print_hostbyte(int scsiresult)
-{
-	int hb = host_byte(scsiresult);
-
-	printk("Hostbyte=0x%02x", hb);
-	if (hb < NUM_HOSTBYTE_STRS)
-		printk("(%s) ", hostbyte_table[hb]);
-	else
-		printk("is invalid ");
-}
-#else
-void scsi_print_hostbyte(int scsiresult)
-{
-	printk("Hostbyte=0x%02x ", host_byte(scsiresult));
-}
-#endif
-
-#ifdef CONFIG_SCSI_CONSTANTS
-
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
@@ -1356,19 +1337,32 @@ static const char * const driversuggest_table[]={"SUGGEST_OK",
 "SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
 #define NUM_SUGGEST_STRS ARRAY_SIZE(driversuggest_table)
 
-void scsi_print_driverbyte(int scsiresult)
+void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	int dr = (driver_byte(scsiresult) & DRIVER_MASK);
-	int su = ((driver_byte(scsiresult) & SUGGEST_MASK) >> 4);
+	int hb = host_byte(cmd->result);
+	int db = (driver_byte(cmd->result) & DRIVER_MASK);
+	int su = ((driver_byte(cmd->result) & SUGGEST_MASK) >> 4);
+
+	scmd_printk(KERN_INFO, cmd, "Error: ");
 
-	printk("Driverbyte=0x%02x ", driver_byte(scsiresult));
-	printk("(%s,%s) ",
-	       (dr < NUM_DRIVERBYTE_STRS ? driverbyte_table[dr] : "invalid"),
+	printk("hostbyte=%s  driverbyte=%s,%s\n",
+	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb] : "invalid"),
+	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"),
 	       (su < NUM_SUGGEST_STRS ? driversuggest_table[su] : "invalid"));
 }
+
 #else
-void scsi_print_driverbyte(int scsiresult)
+
+void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	printk("Driverbyte=0x%02x ", driver_byte(scsiresult));
+	int result = cmd->result;
+
+	scmd_printk(KERN_INFO, cmd,
+		    "Error: hostbyte=0x%02x  driverbyte=0x%02x\n",
+		    host_byte(result), driver_byte(result));
 }
+
 #endif
+
+EXPORT_SYMBOL(scsi_print_result);
+
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0f9b6c2..bf766d8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -969,9 +969,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
-			scmd_printk(KERN_INFO, cmd,
-				    "SCSI error: return code = 0x%08x\n",
-				    result);
+			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 3bbbfbe..426cfa3 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -11,8 +11,7 @@ extern void scsi_print_sense(const char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_print_driverbyte(int);
-extern void scsi_print_hostbyte(int);
+extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ebf31b1..3510df5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
+#include <linux/blkdev.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -154,6 +155,8 @@ struct scsi_device {
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
 #define scmd_printk(prefix, scmd, fmt, a...)	\
+	(&(scmd)->request->rq_disk) ?		\
+        printk(prefix "%s: " fmt, (char *) &(scmd)->request->rq_disk->disk_name, ##a) : \
 	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
 
 enum scsi_target_state {
