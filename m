From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/22] Use sdev as argument for scsi_print_result
Date: Thu, 28 Aug 2014 19:33:23 +0200
Message-ID: <1409247216-76074-10-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Passing in the SCSI device will tag the logging message with
the originating device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 28 ++++++++++++++++++----------
 drivers/scsi/sd.c        |  3 +--
 include/scsi/scsi_dbg.h  |  2 +-
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index ecce5b3..c0d7b3d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1503,31 +1503,39 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(int result)
+void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
 {
 	int hb = host_byte(result);
 	int db = driver_byte(result);
+	const char *hb_string;
+	const char *db_string;
 
-	printk("Result: hostbyte=%s driverbyte=%s\n",
-	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
-	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
+	hb_string = (hb < NUM_HOSTBYTE_STRS) ? hostbyte_table[hb] : "invalid";
+	db_string = (db < NUM_DRIVERBYTE_STRS) ?
+		driverbyte_table[db] : "invalid";
+
+
+	sdev_prefix_printk(KERN_INFO, sdev, name,
+			   "Result: hostbyte=%s driverbyte=%s\n",
+			   hb_string, db_string);
 }
 
 #else
 
-void scsi_show_result(int result)
+void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
+	sdev_prefix_printk(KERN_INFO, sdev, name,
+			   "Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+			   host_byte(result), driver_byte(result));
 }
 
 #endif
 EXPORT_SYMBOL(scsi_show_result);
 
-
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_result(cmd->result);
+	const char *devname = cmd->request->rq_disk ?
+		cmd->request->rq_disk->disk_name : NULL;
+	scsi_show_result(cmd->device, devname, cmd->result);
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aac267a..e780644 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3328,7 +3328,6 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_result(result);
+	scsi_show_result(sdkp->device, sdkp->disk->disk_name, result);
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 0bbf118..3d9ac9f 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,7 +19,7 @@ extern int __scsi_print_sense(struct scsi_device *, const char *,
 extern void scsi_dump_sense(struct scsi_cmnd *);
 extern void __scsi_dump_sense(struct scsi_device *, const char *,
 			      const unsigned char *, int);
-extern void scsi_show_result(int);
+extern void scsi_show_result(struct scsi_device *, const char *, int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
-- 
1.8.5.2

