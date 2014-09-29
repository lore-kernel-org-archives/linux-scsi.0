From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/38] sd: Cleanup logging
Date: Mon, 29 Sep 2014 13:58:48 +0200
Message-ID: <1411991947-130166-20-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaI2L7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:15 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Open-code scsi_print_result in sd.c, and cleanup logging to
not print duplicate informations.

With that we can remove scsi_show_result in constants.c

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 16 ----------------
 drivers/scsi/sd.c        | 45 +++++++++++++++++++++++----------------------
 include/scsi/scsi_dbg.h  |  1 -
 3 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d3e1900..b131900 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1437,22 +1437,6 @@ const char *scsi_driverbyte_string(int result)
 }
 EXPORT_SYMBOL(scsi_driverbyte_string);
 
-void scsi_show_result(int result)
-{
-	const char *hb_string = scsi_hostbyte_string(result);
-	const char *db_string = scsi_driverbyte_string(result);
-
-	if (hb_string || db_string)
-		printk("Result: hostbyte=%s driverbyte=%s\n",
-		       hb_string ? hb_string : "invalid",
-		       db_string ? db_string : "invalid");
-	else
-		printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-		       host_byte(result), driver_byte(result));
-}
-EXPORT_SYMBOL(scsi_show_result);
-
-
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
 	const char *hb_string = scsi_hostbyte_string(cmd->result);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 848b17d..2cc8703 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -116,7 +116,7 @@ static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(struct scsi_disk *, int);
+static void sd_print_result(struct scsi_disk *, const char *, int);
 
 static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
@@ -1479,7 +1479,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	}
 
 	if (res) {
-		sd_print_result(sdkp, res);
+		sd_print_result(sdkp, "SYNCHRONIZE_CACHE failed", res);
 
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
@@ -1700,17 +1700,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
-#ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
-	if (sense_valid) {
-		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
-						   "sd_done: sb[respc,sk,asc,"
-						   "ascq]=%x,%x,%x,%x\n",
-						   sshdr.response_code,
-						   sshdr.sense_key, sshdr.asc,
-						   sshdr.ascq));
-	}
-#endif
+	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
+					   "sd_done: completed %d bytes\n",
+					   good_bytes));
 	sdkp->medium_access_timed_out = 0;
 
 	if (driver_byte(result) != DRIVER_SENSE &&
@@ -1820,12 +1812,12 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
-				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
-				sd_print_result(sdkp, the_result);
+				sd_print_result(sdkp, "Unit Not Ready",
+						the_result);
 			}
 			break;
 		}
-					
+
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
@@ -1941,7 +1933,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	sd_print_result(sdkp, the_result);
+	sd_print_result(sdkp, "READ CAPACITY failed", the_result);
 	if (driver_byte(the_result) & DRIVER_SENSE)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
@@ -3126,8 +3118,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
 			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 	if (res) {
-		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
-		sd_print_result(sdkp, res);
+		sd_print_result(sdkp, "START_STOP failed", res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		if (scsi_sense_valid(&sshdr) &&
@@ -3328,9 +3319,19 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			     sshdr->asc, sshdr->ascq);
 }
 
-static void sd_print_result(struct scsi_disk *sdkp, int result)
+static void sd_print_result(struct scsi_disk *sdkp, const char *msg,
+			    int result)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_result(result);
+	const char *hb_string = scsi_hostbyte_string(result);
+	const char *db_string = scsi_driverbyte_string(result);
+
+	if (hb_string && db_string)
+		sd_printk(KERN_INFO, sdkp,
+			  "%s: Result: hostbyte=%s driverbyte=%s\n",
+			  msg, hb_string, db_string);
+	else
+		sd_printk(KERN_INFO, sdkp,
+			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+			  msg, host_byte(result), driver_byte(result));
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index fb3e0d4..43d7b2b 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -17,7 +17,6 @@ extern void scsi_print_sense(struct scsi_cmnd *);
 extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern const char *scsi_hostbyte_string(int);
 extern const char *scsi_driverbyte_string(int);
-- 
1.8.5.2

