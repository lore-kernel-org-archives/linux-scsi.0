Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DA5C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47BBE60EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhHIXE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:27 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:40596 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhHIXE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:27 -0400
Received: by mail-pj1-f45.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so1409911pji.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=761fWMl75+wsVDGt9yeKDzSh1OgPq6loa+fxh9u0FxE=;
        b=XkecUSM9BhGuIwIOaA+6TeUXP9humrJo6IaW84Wk77N+GnSqrJhxpra01DpZCmV6N7
         SYdDsTCxmOboTN9CWhIdzPQanObocBOLoYprMFqCLVYhwESbvPvGo/BE8DhUDEBp63TX
         PeICwT4PgTU+sKyx5TPIw9xy3AVpzdjSviLC7XRJqIXWcxHs8Y1CopElKTM0lsP1Nebj
         ZwgScOnVwKbFTcAz5xLz7mQlRlXk9OzE8UghLCPXf58oSPFQX1EHZAw6/aEymDHTDMYS
         +0nEjslnOBhtF/Cqw5RZp221n+/VvmB2iR7yLMksu6JIT4mFgb05WLB7/RbArV/sEYj2
         hIvA==
X-Gm-Message-State: AOAM530ucYCDmI11xYg9x6+SnyFh77PL+Mhj4a2XRwmiCbLYYOgv99BQ
        V1R8r3R1hcH9OB43qFY0loE=
X-Google-Smtp-Source: ABdhPJzjU6TWrx+qP28meJjpd0ngcwx/bda/H50Z9c6RE+68MUGqJ1LftzvQ3lkP8IWqsNkSThlQbQ==
X-Received: by 2002:a17:903:188:b029:12c:d12c:8ddf with SMTP id z8-20020a1709030188b029012cd12c8ddfmr3694057plg.17.1628550245839;
        Mon, 09 Aug 2021 16:04:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 02/52] core: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:05 -0700
Message-Id: <20210809230355.8186-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. Cast away constness where necessary when passing a SCSI command
pointer to scsi_cmd_to_rq(). This patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c         |  2 +-
 drivers/scsi/scsi_error.c   | 15 ++++++++-------
 drivers/scsi/scsi_lib.c     | 28 +++++++++++++++-------------
 drivers/scsi/scsi_logging.c | 18 ++++++++++--------
 include/scsi/scsi_cmnd.h    |  8 +++++---
 include/scsi/scsi_device.h  | 16 +++++++++-------
 6 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d26025cf5de3..b241f9e3885c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -190,7 +190,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
-	if (!blk_rq_is_passthrough(cmd->request)) {
+	if (!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd))) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 58a252c38992..d85d308a0683 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -242,7 +242,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
  */
 static void scsi_eh_reset(struct scsi_cmnd *scmd)
 {
-	if (!blk_rq_is_passthrough(scmd->request)) {
+	if (!blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_reset)
 			sdrv->eh_reset(scmd);
@@ -1182,7 +1182,7 @@ static enum scsi_disposition scsi_request_sense(struct scsi_cmnd *scmd)
 static enum scsi_disposition
 scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
 {
-	if (!blk_rq_is_passthrough(scmd->request)) {
+	if (!blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_action)
 			rtn = sdrv->eh_action(scmd, rtn);
@@ -1750,21 +1750,23 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
  */
 int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 {
+	struct request *req = scsi_cmd_to_rq(scmd);
+
 	switch (host_byte(scmd->result)) {
 	case DID_OK:
 		break;
 	case DID_TIME_OUT:
 		goto check_type;
 	case DID_BUS_BUSY:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
+		return req->cmd_flags & REQ_FAILFAST_TRANSPORT;
 	case DID_PARITY:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
+		return req->cmd_flags & REQ_FAILFAST_DEV;
 	case DID_ERROR:
 		if (get_status_byte(scmd) == SAM_STAT_RESERVATION_CONFLICT)
 			return 0;
 		fallthrough;
 	case DID_SOFT_ERROR:
-		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
+		return req->cmd_flags & REQ_FAILFAST_DRIVER;
 	}
 
 	if (!scsi_status_is_check_condition(scmd->result))
@@ -1775,8 +1777,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
 	 */
-	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
-	    blk_rq_is_passthrough(scmd->request))
+	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
 		return 1;
 
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 77578b221a71..909a422ec8f4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -119,13 +119,15 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 
 static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 {
-	if (cmd->request->rq_flags & RQF_DONTPREP) {
-		cmd->request->rq_flags &= ~RQF_DONTPREP;
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	if (rq->rq_flags & RQF_DONTPREP) {
+		rq->rq_flags &= ~RQF_DONTPREP;
 		scsi_mq_uninit_cmd(cmd);
 	} else {
 		WARN_ON_ONCE(true);
 	}
-	blk_mq_requeue_request(cmd->request, true);
+	blk_mq_requeue_request(rq, true);
 }
 
 /**
@@ -164,7 +166,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 */
 	cmd->result = 0;
 
-	blk_mq_requeue_request(cmd->request, true);
+	blk_mq_requeue_request(scsi_cmd_to_rq(cmd), true);
 }
 
 /**
@@ -478,7 +480,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 {
-	if (!blk_rq_is_passthrough(cmd->request)) {
+	if (!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd))) {
 		struct scsi_driver *drv = scsi_cmd_to_driver(cmd);
 
 		if (drv->uninit_command)
@@ -624,7 +626,7 @@ static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
 
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
-	struct request *req = cmd->request;
+	struct request *req = scsi_cmd_to_rq(cmd);
 	unsigned long wait_for;
 
 	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
@@ -643,7 +645,7 @@ static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
 	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
+	struct request *req = scsi_cmd_to_rq(cmd);
 	int level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
@@ -818,7 +820,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 {
 	bool sense_valid;
 	bool sense_current = true;	/* false implies "deferred sense" */
-	struct request *req = cmd->request;
+	struct request *req = scsi_cmd_to_rq(cmd);
 	struct scsi_sense_hdr sshdr;
 
 	sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -907,7 +909,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
 	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
+	struct request *req = scsi_cmd_to_rq(cmd);
 	blk_status_t blk_stat = BLK_STS_OK;
 
 	if (unlikely(result))	/* a nz result may or may not be an error */
@@ -978,7 +980,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	unsigned short nr_segs = blk_rq_nr_phys_segments(rq);
 	struct scatterlist *last_sg = NULL;
 	blk_status_t ret;
@@ -1112,7 +1114,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
-	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
 	unsigned long jiffies_at_alloc;
 	int retries, to_clear;
@@ -1577,12 +1579,12 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
-	if (unlikely(blk_should_fake_timeout(cmd->request->q)))
+	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
 		return;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
 		return;
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request);
+	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
 
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 2317717935e9..ed9572252a42 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -28,8 +28,9 @@ static void scsi_log_release_buffer(char *bufptr)
 
 static inline const char *scmd_name(const struct scsi_cmnd *scmd)
 {
-	return scmd->request->rq_disk ?
-		scmd->request->rq_disk->disk_name : NULL;
+	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
+
+	return rq->rq_disk ? rq->rq_disk->disk_name : NULL;
 }
 
 static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
@@ -91,7 +92,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	if (!logbuf)
 		return;
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
-				 scmd->request->tag);
+				 scsi_cmd_to_rq((struct scsi_cmnd *)scmd)->tag);
 	if (off < logbuf_len) {
 		va_start(args, fmt);
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -188,7 +189,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 		return;
 
 	off = sdev_format_header(logbuf, logbuf_len,
-				 scmd_name(cmd), cmd->request->tag);
+				 scmd_name(cmd), scsi_cmd_to_rq(cmd)->tag);
 	if (off >= logbuf_len)
 		goto out_printk;
 	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");
@@ -210,7 +211,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 
 			off = sdev_format_header(logbuf, logbuf_len,
 						 scmd_name(cmd),
-						 cmd->request->tag);
+						 scsi_cmd_to_rq(cmd)->tag);
 			if (!WARN_ON(off > logbuf_len - 58)) {
 				off += scnprintf(logbuf + off, logbuf_len - off,
 						 "CDB[%02x]: ", k);
@@ -373,7 +374,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
 /* Normalize and print sense buffer in SCSI command */
 void scsi_print_sense(const struct scsi_cmnd *cmd)
 {
-	scsi_log_print_sense(cmd->device, scmd_name(cmd), cmd->request->tag,
+	scsi_log_print_sense(cmd->device, scmd_name(cmd),
+			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
 			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -391,8 +393,8 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	if (!logbuf)
 		return;
 
-	off = sdev_format_header(logbuf, logbuf_len,
-				 scmd_name(cmd), cmd->request->tag);
+	off = sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
+				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
 
 	if (off >= logbuf_len)
 		goto out_printk;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index e76278ea1fee..b9265b15d37a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -164,7 +164,9 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 /* make sure not to use it with passthrough commands */
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	return *(struct scsi_driver **)rq->rq_disk->private_data;
 }
 
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
@@ -228,14 +230,14 @@ static inline int scsi_sg_copy_to_buffer(struct scsi_cmnd *cmd,
 
 static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
 {
-	return blk_rq_pos(scmd->request);
+	return blk_rq_pos(scsi_cmd_to_rq(scmd));
 }
 
 static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 {
 	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
 
-	return blk_rq_pos(scmd->request) >> shift;
+	return blk_rq_pos(scsi_cmd_to_rq(scmd)) >> shift;
 }
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7137e7924913..09a17f6e93a7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -271,13 +271,15 @@ sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 __printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 
-#define scmd_dbg(scmd, fmt, a...)					   \
-	do {								   \
-		if ((scmd)->request->rq_disk)				   \
-			sdev_dbg((scmd)->device, "[%s] " fmt,		   \
-				 (scmd)->request->rq_disk->disk_name, ##a);\
-		else							   \
-			sdev_dbg((scmd)->device, fmt, ##a);		   \
+#define scmd_dbg(scmd, fmt, a...)					\
+	do {								\
+		struct request *__rq = scsi_cmd_to_rq((scmd));		\
+									\
+		if (__rq->rq_disk)					\
+			sdev_dbg((scmd)->device, "[%s] " fmt,		\
+				 __rq->rq_disk->disk_name, ##a);	\
+		else							\
+			sdev_dbg((scmd)->device, fmt, ##a);		\
 	} while (0)
 
 enum scsi_target_state {
