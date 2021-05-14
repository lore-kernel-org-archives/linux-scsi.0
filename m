Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57737C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEF9613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhENVf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:26 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:44694 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhENVfW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:22 -0400
Received: by mail-pj1-f50.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so463796pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9eNLBbWyJdAEstBuikUSsfFCEsoVQw3ceJKTmdTdJRE=;
        b=bopLG4JuoHYF7hgzk36gOUyb22Su7Pc6xbUQom8IP3E9gfoKT/8qyJbuEJXhGRwjvT
         lxG/SJSwUfZ77HePSDuZlb0DdtiRVbGYQ/ZPCPj8wlfijXnTgb69l9LW5hfBcbMr18jc
         woGQwY+MRE1hVNiE9JpaoiPs7layUpISKotz+tzfEFDLT4Gih8gJQZjrcq9cevybZh8+
         xIdTtkgb74dN+8XnlvFFjDKXVawJqmn+2+XYif4d+mae+z/4zPyhcZn8XqkrMoNFINoV
         cP5ss/MVfiCQVcAMpzgC5eepATwBTjWkGj/Yor/ZOwW+9ed4qpgAANvN3FDPHixNzUKG
         2hOg==
X-Gm-Message-State: AOAM532NSpksaO3u0cq4e49zCmcUTTi8ZqB3Cvdzo9x14Ocymm5rcVKG
        Ba3h5pmxM6bqRV5te+C9MAY=
X-Google-Smtp-Source: ABdhPJyOvKUxmTaiEbYWt2B1oLvvbHfzXGID0Mzuu+9rpnj5PsmgEwjA3fsgkak6HlBKeIIQYBVZVw==
X-Received: by 2002:a17:90a:b388:: with SMTP id e8mr13101336pjr.167.1621028049520;
        Fri, 14 May 2021 14:34:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 02/50] core: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:17 -0700
Message-Id: <20210514213356.5264-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c         |  2 +-
 drivers/scsi/scsi_error.c   | 14 +++++++-------
 drivers/scsi/scsi_lib.c     | 26 +++++++++++++-------------
 drivers/scsi/scsi_logging.c | 18 ++++++++++--------
 include/scsi/scsi_cmnd.h    |  4 ++--
 include/scsi/scsi_device.h  | 16 +++++++++-------
 6 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e9e2f0e15ac8..a226f2d380a3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -197,7 +197,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
-	if (!blk_rq_is_passthrough(cmd->request)) {
+	if (!blk_rq_is_passthrough(blk_req(cmd))) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d8fafe77dbbe..8846e5066f92 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -242,7 +242,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
  */
 static void scsi_eh_reset(struct scsi_cmnd *scmd)
 {
-	if (!blk_rq_is_passthrough(scmd->request)) {
+	if (!blk_rq_is_passthrough(blk_req(scmd))) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_reset)
 			sdrv->eh_reset(scmd);
@@ -1188,7 +1188,7 @@ static enum scsi_disposition scsi_request_sense(struct scsi_cmnd *scmd)
 static enum scsi_disposition
 scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
 {
-	if (!blk_rq_is_passthrough(scmd->request)) {
+	if (!blk_rq_is_passthrough(blk_req(scmd))) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_action)
 			rtn = sdrv->eh_action(scmd, rtn);
@@ -1762,16 +1762,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	case DID_TIME_OUT:
 		goto check_type;
 	case DID_BUS_BUSY:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
+		return blk_req(scmd)->cmd_flags & REQ_FAILFAST_TRANSPORT;
 	case DID_PARITY:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
+		return blk_req(scmd)->cmd_flags & REQ_FAILFAST_DEV;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
 			return 0;
 		fallthrough;
 	case DID_SOFT_ERROR:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
+		return blk_req(scmd)->cmd_flags & REQ_FAILFAST_DRIVER;
 	}
 
 	if (status_byte(scmd->result) != CHECK_CONDITION)
@@ -1782,8 +1782,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
 	 */
-	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
-	    blk_rq_is_passthrough(scmd->request))
+	if (blk_req(scmd)->cmd_flags & REQ_FAILFAST_DEV ||
+	    blk_rq_is_passthrough(blk_req(scmd)))
 		return 1;
 
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 532304d42f00..e88ce8f747ee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -119,13 +119,13 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 
 static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 {
-	if (cmd->request->rq_flags & RQF_DONTPREP) {
-		cmd->request->rq_flags &= ~RQF_DONTPREP;
+	if (blk_req(cmd)->rq_flags & RQF_DONTPREP) {
+		blk_req(cmd)->rq_flags &= ~RQF_DONTPREP;
 		scsi_mq_uninit_cmd(cmd);
 	} else {
 		WARN_ON_ONCE(true);
 	}
-	blk_mq_requeue_request(cmd->request, true);
+	blk_mq_requeue_request(blk_req(cmd), true);
 }
 
 /**
@@ -164,7 +164,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 */
 	cmd->result = 0;
 
-	blk_mq_requeue_request(cmd->request, true);
+	blk_mq_requeue_request(blk_req(cmd), true);
 }
 
 /**
@@ -475,7 +475,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 {
-	if (!blk_rq_is_passthrough(cmd->request)) {
+	if (!blk_rq_is_passthrough(blk_req(cmd))) {
 		struct scsi_driver *drv = scsi_cmd_to_driver(cmd);
 
 		if (drv->uninit_command)
@@ -626,7 +626,7 @@ static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
 
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
-	struct request *req = cmd->request;
+	struct request *req = blk_req(cmd);
 	unsigned long wait_for;
 
 	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
@@ -645,7 +645,7 @@ static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
 	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
+	struct request *req = blk_req(cmd);
 	int level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
@@ -819,7 +819,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 {
 	bool sense_valid;
 	bool sense_current = true;	/* false implies "deferred sense" */
-	struct request *req = cmd->request;
+	struct request *req = blk_req(cmd);
 	struct scsi_sense_hdr sshdr;
 
 	sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -908,7 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
 	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
+	struct request *req = blk_req(cmd);
 	blk_status_t blk_stat = BLK_STS_OK;
 
 	if (unlikely(result))	/* a nz result may or may not be an error */
@@ -979,7 +979,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	unsigned short nr_segs = blk_rq_nr_phys_segments(rq);
 	struct scatterlist *last_sg = NULL;
 	blk_status_t ret;
@@ -1108,7 +1108,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
-	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	struct request *rq = blk_req(cmd);
 	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
 	unsigned long jiffies_at_alloc;
 	int retries, to_clear;
@@ -1573,12 +1573,12 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
-	if (unlikely(blk_should_fake_timeout(cmd->request->q)))
+	if (unlikely(blk_should_fake_timeout(blk_req(cmd)->q)))
 		return;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
 		return;
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request);
+	blk_mq_complete_request(blk_req(cmd));
 }
 
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 8ea44c6595ef..706986e7f5ef 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -28,8 +28,9 @@ static void scsi_log_release_buffer(char *bufptr)
 
 static inline const char *scmd_name(const struct scsi_cmnd *scmd)
 {
-	return scmd->request->rq_disk ?
-		scmd->request->rq_disk->disk_name : NULL;
+	struct request *rq = blk_req((struct scsi_cmnd *)scmd);
+
+	return rq->rq_disk ? rq->rq_disk->disk_name : NULL;
 }
 
 static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
@@ -91,7 +92,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	if (!logbuf)
 		return;
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
-				 scmd->request->tag);
+				 blk_req((struct scsi_cmnd *)scmd)->tag);
 	if (off < logbuf_len) {
 		va_start(args, fmt);
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -188,7 +189,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 		return;
 
 	off = sdev_format_header(logbuf, logbuf_len,
-				 scmd_name(cmd), cmd->request->tag);
+				 scmd_name(cmd), blk_req(cmd)->tag);
 	if (off >= logbuf_len)
 		goto out_printk;
 	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");
@@ -210,7 +211,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 
 			off = sdev_format_header(logbuf, logbuf_len,
 						 scmd_name(cmd),
-						 cmd->request->tag);
+						 blk_req(cmd)->tag);
 			if (!WARN_ON(off > logbuf_len - 58)) {
 				off += scnprintf(logbuf + off, logbuf_len - off,
 						 "CDB[%02x]: ", k);
@@ -373,7 +374,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
 /* Normalize and print sense buffer in SCSI command */
 void scsi_print_sense(const struct scsi_cmnd *cmd)
 {
-	scsi_log_print_sense(cmd->device, scmd_name(cmd), cmd->request->tag,
+	scsi_log_print_sense(cmd->device, scmd_name(cmd),
+			     blk_req((struct scsi_cmnd *)cmd)->tag,
 			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -392,8 +394,8 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	if (!logbuf)
 		return;
 
-	off = sdev_format_header(logbuf, logbuf_len,
-				 scmd_name(cmd), cmd->request->tag);
+	off = sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
+				 blk_req((struct scsi_cmnd *)cmd)->tag);
 
 	if (off >= logbuf_len)
 		goto out_printk;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index f5825be7ee76..a68521e6ce57 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -164,7 +164,7 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 /* make sure not to use it with passthrough commands */
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+	return *(struct scsi_driver **)blk_req(cmd)->rq_disk->private_data;
 }
 
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
@@ -290,7 +290,7 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 
 static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 {
-	return blk_rq_pos(scmd->request);
+	return blk_rq_pos(blk_req(scmd));
 }
 
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ac6ab16abee7..2614e4a6a01e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -265,13 +265,15 @@ sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 __printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 
-#define scmd_dbg(scmd, fmt, a...)					   \
-	do {								   \
-		if ((scmd)->request->rq_disk)				   \
-			sdev_dbg((scmd)->device, "[%s] " fmt,		   \
-				 (scmd)->request->rq_disk->disk_name, ##a);\
-		else							   \
-			sdev_dbg((scmd)->device, fmt, ##a);		   \
+#define scmd_dbg(scmd, fmt, a...)				\
+	do {							\
+		struct request *rq = blk_req((scmd));		\
+								\
+		if (rq->rq_disk)				\
+			sdev_dbg((scmd)->device, "[%s] " fmt,	\
+				 rq->rq_disk->disk_name, ##a);	\
+		else						\
+			sdev_dbg((scmd)->device, fmt, ##a);	\
 	} while (0)
 
 enum scsi_target_state {
