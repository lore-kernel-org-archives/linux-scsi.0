From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/27] Remove scsi_show_result()
Date: Fri, 24 Oct 2014 14:27:00 +0200
Message-ID: <1414153627-2863-21-git-send-email-hare@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564AbaJXM1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:18 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Open-code scsi_print_result in sd.c, and cleanup logging to
not print duplicate informations.
Also remove the call to scsi_show_result() in ufshcd.c
to be consistent with other callers of scsi_execute().

With that we can remove scsi_show_result in constants.c

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c  | 16 ---------------
 drivers/scsi/sd.c         | 50 ++++++++++++++++++++++++-----------------------
 drivers/scsi/ufs/ufshcd.c |  4 ++--
 include/scsi/scsi_dbg.h   |  1 -
 4 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 0fe50b4..5e64afc 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1439,22 +1439,6 @@ const char *scsi_driverbyte_string(int result)
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
index 3ae7540..242f9b1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -116,7 +116,7 @@ static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(struct scsi_disk *, int);
+static void sd_print_result(const struct scsi_disk *, const char *, int);
 
 static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
@@ -1492,7 +1492,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	}
 
 	if (res) {
-		sd_print_result(sdkp, res);
+		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
@@ -1713,17 +1713,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
 	sdkp->medium_access_timed_out = 0;
 
 	if (driver_byte(result) != DRIVER_SENSE &&
@@ -1778,6 +1767,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		break;
 	}
  out:
+	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
+					   "sd_done: completed %d of %d bytes\n",
+					   good_bytes, scsi_bufflen(SCpnt)));
+
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
@@ -1833,12 +1826,12 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
-				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
-				sd_print_result(sdkp, the_result);
+				sd_print_result(sdkp, "Test Unit Ready failed",
+						the_result);
 			}
 			break;
 		}
-					
+
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
@@ -1954,7 +1947,6 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	sd_print_result(sdkp, the_result);
 	if (driver_byte(the_result) & DRIVER_SENSE)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
@@ -2035,7 +2027,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	} while (the_result && retries);
 
 	if (the_result) {
-		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
+		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
 		return -EINVAL;
 	}
@@ -2117,7 +2109,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	} while (the_result && retries);
 
 	if (the_result) {
-		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY failed\n");
+		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
 		return -EINVAL;
 	}
@@ -3141,8 +3133,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
 			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 	if (res) {
-		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
-		sd_print_result(sdkp, res);
+		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		if (scsi_sense_valid(&sshdr) &&
@@ -3343,9 +3334,20 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			     sshdr->asc, sshdr->ascq);
 }
 
-static void sd_print_result(struct scsi_disk *sdkp, int result)
+static void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
+			    int result)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_result(result);
+	const char *hb_string = scsi_hostbyte_string(result);
+	const char *db_string = scsi_driverbyte_string(result);
+
+	if (hb_string || db_string)
+		sd_printk(KERN_INFO, sdkp,
+			  "%s: Result: hostbyte=%s driverbyte=%s\n", msg,
+			  hb_string ? hb_string : "invalid",
+			  db_string ? db_string : "invalid");
+	else
+		sd_printk(KERN_INFO, sdkp,
+			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+			  msg, host_byte(result), driver_byte(result));
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eb3997e..9da3191 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4707,8 +4707,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     START_STOP_TIMEOUT, 0, NULL, REQ_PM);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
-			  "START_STOP failed for power mode: %d\n", pwr_mode);
-		scsi_show_result(ret);
+			    "START_STOP failed for power mode: %d, result %x\n",
+			    pwr_mode, ret);
 		if (driver_byte(ret) & DRIVER_SENSE) {
 			scsi_show_sense_hdr(sdp, NULL, &sshdr);
 			scsi_show_extd_sense(sdp, NULL, sshdr.asc, sshdr.ascq);
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 50f4d85..f41a86b 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -17,7 +17,6 @@ extern void scsi_print_sense(const struct scsi_cmnd *);
 extern void __scsi_print_sense(const struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern const char *scsi_hostbyte_string(int);
 extern const char *scsi_driverbyte_string(int);
-- 
1.8.5.2

