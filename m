Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50D2CA9ECF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE972087F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfJaLFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:37464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727558AbfJaLFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4678DB391;
        Thu, 31 Oct 2019 11:05:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/24] scsi: Drop the now obsolete driver_byte definitions
Date:   Thu, 31 Oct 2019 12:04:52 +0100
Message-Id: <20191031110452.73463-25-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver_byte field in the result is now unused, so we can drop
the definitions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_mid_low_api.txt |  3 +--
 block/bsg-lib.c                         |  2 +-
 block/bsg.c                             |  2 +-
 block/scsi_ioctl.c                      |  2 +-
 drivers/scsi/constants.c                | 14 --------------
 drivers/scsi/scsi_logging.c             | 10 ++--------
 drivers/scsi/sd.c                       |  9 ++++-----
 drivers/scsi/sd_zbc.c                   |  4 ++--
 drivers/scsi/sg.c                       |  5 ++---
 drivers/scsi/sr.c                       |  2 +-
 drivers/scsi/sr_ioctl.c                 |  2 +-
 drivers/scsi/st.c                       |  4 ++--
 include/scsi/scsi.h                     |  3 ---
 include/scsi/scsi_cmnd.h                |  4 ----
 include/trace/events/scsi.h             |  7 +------
 15 files changed, 19 insertions(+), 54 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index c1dd4939f4ae..ab072fff5fb8 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1160,8 +1160,7 @@ Members of interest:
                    target device). 'result' is a 32 bit unsigned integer that
                    can be viewed as 4 related bytes. The SCSI status value is
                    in the LSB. See include/scsi/scsi.h status_byte(),
-                   msg_byte(), host_byte() and driver_byte() macros and
-                   related constants.
+                   msg_byte() and host_byte() macros and related constants.
     sense_buffer - an array (maximum size: SCSI_SENSE_BUFFERSIZE bytes) that
                    should be written when the SCSI status (LSB of 'result')
                    is set to CHECK_CONDITION (2). When CHECK_CONDITION is
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 347dda16c2f4..bc0c813b3a99 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -84,7 +84,7 @@ static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	 */
 	hdr->device_status = job->result & 0xff;
 	hdr->transport_status = host_byte(job->result);
-	hdr->driver_status = driver_byte(job->result);
+	hdr->driver_status = 0;
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
diff --git a/block/bsg.c b/block/bsg.c
index 833c44b3d458..dcde05348a48 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -96,7 +96,7 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	 */
 	hdr->device_status = sreq->result & 0xff;
 	hdr->transport_status = host_byte(sreq->result);
-	hdr->driver_status = driver_byte(sreq->result);
+	hdr->driver_status = 0;
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 1ab1b8d9641c..b8b9b72fab2a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -252,7 +252,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->masked_status = status_byte(req->result);
 	hdr->msg_status = msg_byte(req->result);
 	hdr->host_status = host_byte(req->result);
-	hdr->driver_status = driver_byte(req->result);
+	hdr->driver_status = 0;
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index be7eacb67841..924131ea0b11 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -406,9 +406,6 @@ static const char * const hostbyte_table[]={
 "DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
 "DID_NEXUS_FAILURE" };
 
-static const char * const driverbyte_table[]={
-"DRIVER_OK"};
-
 const char *scsi_hostbyte_string(int result)
 {
 	const char *hb_string = NULL;
@@ -420,17 +417,6 @@ const char *scsi_hostbyte_string(int result)
 }
 EXPORT_SYMBOL(scsi_hostbyte_string);
 
-const char *scsi_driverbyte_string(int result)
-{
-	const char *db_string = NULL;
-	int db = driver_byte(result);
-
-	if (db < ARRAY_SIZE(driverbyte_table))
-		db_string = driverbyte_table[db];
-	return db_string;
-}
-EXPORT_SYMBOL(scsi_driverbyte_string);
-
 #define scsi_mlreturn_name(result)	{ result, #result }
 static const struct value_name_pair scsi_mlreturn_arr[] = {
 	scsi_mlreturn_name(NEEDS_RETRY),
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index c91fa3feb930..d0b646430375 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -389,7 +389,6 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	size_t off, logbuf_len;
 	const char *mlret_string = scsi_mlreturn_string(disposition);
 	const char *hb_string = scsi_hostbyte_string(cmd->result);
-	const char *db_string = scsi_driverbyte_string(cmd->result);
 	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
@@ -430,13 +429,8 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	if (WARN_ON(off >= logbuf_len))
 		goto out_printk;
 
-	if (db_string)
-		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "driverbyte=%s ", db_string);
-	else
-		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "driverbyte=0x%02x ",
-				 driver_byte(cmd->result));
+	off += scnprintf(logbuf + off, logbuf_len - off,
+			 "driverbyte=DRIVER_OK ");
 
 	off += scnprintf(logbuf + off, logbuf_len - off,
 			 "cmd_age=%lus", cmd_age);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 220990183b6b..4599954b7bb0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3716,16 +3716,15 @@ static void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
 			    int result)
 {
 	const char *hb_string = scsi_hostbyte_string(result);
-	const char *db_string = scsi_driverbyte_string(result);
 
-	if (hb_string || db_string)
+	if (hb_string)
 		sd_printk(KERN_INFO, sdkp,
 			  "%s: Result: hostbyte=%s driverbyte=%s\n", msg,
 			  hb_string ? hb_string : "invalid",
-			  db_string ? db_string : "invalid");
+			  "DRIVER_OK");
 	else
 		sd_printk(KERN_INFO, sdkp,
-			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-			  msg, host_byte(result), driver_byte(result));
+			  "%s: Result: hostbyte=0x%02x driverbyte=%s\n",
+			  msg, host_byte(result), "DRIVER_OK");
 }
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index de4019dc0f0b..d96a2506d965 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -87,9 +87,9 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 				  timeout, SD_MAX_RETRIES, NULL);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
-			  "REPORT ZONES lba %llu failed with %d/%d\n",
+			  "REPORT ZONES lba %llu failed with %d/0\n",
 			  (unsigned long long)lba,
-			  host_byte(result), driver_byte(result));
+			  host_byte(result));
 		return -EIO;
 	}
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c6f5e0a8d271..7c5d3c25ccea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1354,7 +1354,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		srp->header.masked_status = status_byte(result) >> 1;
 		srp->header.msg_status = msg_byte(result);
 		srp->header.host_status = host_byte(result);
-		srp->header.driver_status = driver_byte(result);
+		srp->header.driver_status = 0;
 		if ((sdp->sgdebug > 0) &&
 		    ((SAM_STAT_CHECK_CONDITION == srp->header.status) ||
 		     (SAM_STAT_COMMAND_TERMINATED == srp->header.status)))
@@ -1362,8 +1362,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
-		if (driver_byte(result) != 0
-		    && scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)
+		if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)
 		    && !scsi_sense_is_deferred(&sshdr)
 		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4664fdf75c0f..05969bb1860c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -336,7 +336,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	 * care is taken to avoid unnecessary additional work such as
 	 * memcpy's that could be avoided.
 	 */
-	if (driver_byte(result) != 0 &&		/* An error occurred */
+	if (status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ffcf902da390..02bfbbfb6f03 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -205,7 +205,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
-	if (driver_byte(result) != 0) {
+	if (status_byte(result) == SAM_STAT_CHECK_CONDITION) {
 		switch (sshdr->sense_key) {
 		case UNIT_ATTENTION:
 			SDev->changed = 1;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5f38369cc62f..9ac262d6ccab 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -388,8 +388,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
 			st_printk(KERN_WARNING, STp,
-			       "Error %x (driver bt 0x%x, host bt 0x%x).\n",
-			       result, driver_byte(result), host_byte(result));
+			       "Error %x (driver bt 0, host bt 0x%x).\n",
+			       result, host_byte(result));
 		else if (cmdstatp->have_sense &&
 			 scode != NO_SENSE &&
 			 scode != RECOVERED_ERROR &&
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index acd0b2182db1..39ae398d98a9 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -159,7 +159,6 @@ static inline int scsi_is_wlun(u64 lun)
 				 * paths might yield different results */
 #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
 #define DID_MEDIUM_ERROR  0x13  /* Medium error */
-#define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
  * Internal return values.
@@ -191,12 +190,10 @@ static inline int scsi_is_wlun(u64 lun)
  *      status byte = set from target device
  *      msg_byte    = return status from host adapter itself.
  *      host_byte   = set by low-level driver to indicate status.
- *      driver_byte = set by mid-level.
  */
 #define status_byte(result) ((result) & 0xff)
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
-#define driver_byte(result) (((result) >> 24) & 0xff)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9b9ca629097d..fe1ac844c114 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -322,10 +322,6 @@ static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
 }
 
-static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
-{
-	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
-}
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 5984db6996bb..428cca71c2ba 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -124,11 +124,6 @@
 		scsi_hostbyte_name(DID_TRANSPORT_DISRUPTED),	\
 		scsi_hostbyte_name(DID_TRANSPORT_FAILFAST))
 
-#define scsi_driverbyte_name(result)	{ result, #result }
-#define show_driverbyte_name(val)				\
-	__print_symbolic(val,					\
-		scsi_driverbyte_name(DRIVER_OK))
-
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
 	__print_symbolic(val,					\
@@ -319,7 +314,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
+		  "DRIVER_OK",
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
 		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
 		  show_statusbyte_name(__entry->result & 0xff))
-- 
2.16.4

