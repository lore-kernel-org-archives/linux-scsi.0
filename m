Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C38C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE376103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbhJGUbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:31 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:52873 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJGUba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:30 -0400
Received: by mail-pj1-f48.google.com with SMTP id oa4so5092605pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLO3bI2ukg4hM2P6jquFRoxBPqd4s8Qin+BxyvHB8to=;
        b=aMcCG6Oug/MhSHtq/pwpi8fWJS4IZeddjaWGos+ONCZ3hv/rMjlQ4YuYtyPL9uIkpO
         a5dNhlnQAZZbbVQRDA7ej4zw1I1Y+vrX1SSz6A57q1P2NBGxKveNRhyisNETY5THr/U/
         24yXSW+5vfb8B+jZy4qEPKL8sOUoA2oK0x+00B17dzjzjUj8O0FY9C0qgkiRMfW+78/f
         FfPhwEzQ0XPtEKsFeMaZi7bxU/Nfe9at2XPK1tBB7j/Fc9vuhZjuFUqiSOh+g3iGObtE
         88QBpgIn1YKnyRX0p7sEg2KgiOd1oFFdHnwBr6A+vdDMI1lfTFvIKY8Bq3ZQ6NM/DPsS
         g+Rg==
X-Gm-Message-State: AOAM531BjVzuX2KHp+iiMPIBKOG/WAB3WqDZZ/S1VAwqbaVr5W0y6ZV3
        LhU8eYCG54dQfw3FqYM8f2y3ToJNe20=
X-Google-Smtp-Source: ABdhPJzCYvvEyW7yV9YzOn2ZOoT3C4/A9R5mlI4Rxelk95YYaYmt3wpOZLJd7ds2JTv5LeRlXKLRnw==
X-Received: by 2002:a17:90b:1642:: with SMTP id il2mr7130874pjb.167.1633638576424;
        Thu, 07 Oct 2021 13:29:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 01/88] scsi: core: Use a structure member to track the SCSI command submitter
Date:   Thu,  7 Oct 2021 13:27:56 -0700
Message-Id: <20211007202923.2174984-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Use a structure
member to track the SCSI command submitter such that later patches can
call scsi_done(scmd) instead of scmd->scsi_done(scmd).

The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
context to the SCSI error handler and that it does not restore the
submission context to the SCSI core is retained.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 17 ++++++-----------
 drivers/scsi/scsi_lib.c   | 10 ++++++++++
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_cmnd.h  |  7 +++++++
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b6c86cce57bf..3de03925550e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -50,8 +50,6 @@
 
 #include <asm/unaligned.h>
 
-static void scsi_eh_done(struct scsi_cmnd *scmd);
-
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
@@ -520,7 +518,8 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		/* handler does not care. Drop down to default handling */
 	}
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+	if (scmd->cmnd[0] == TEST_UNIT_READY &&
+	    scmd->submitter != SUBMITTED_BY_SCSI_ERROR_HANDLER)
 		/*
 		 * nasty: for mid-layer issued TURs, we need to return the
 		 * actual sense data without any recovery attempt.  For eh
@@ -782,7 +781,7 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
  * scsi_eh_done - Completion function for error handling.
  * @scmd:	Cmd that is done.
  */
-static void scsi_eh_done(struct scsi_cmnd *scmd)
+void scsi_eh_done(struct scsi_cmnd *scmd)
 {
 	struct completion *eh_action;
 
@@ -1082,7 +1081,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
-	scmd->scsi_done = scsi_eh_done;
+	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
 
 	/*
 	 * Lock sdev->state_mutex to avoid that scsi_device_quiesce() can
@@ -1109,6 +1108,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 	if (rtn) {
 		if (timeleft > stall_for) {
 			scsi_eh_restore_cmnd(scmd, &ses);
+
 			timeleft -= stall_for;
 			msleep(jiffies_to_msecs(stall_for));
 			goto retry;
@@ -2338,11 +2338,6 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
 
-static void
-scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
-{
-}
-
 /**
  * scsi_ioctl_reset: explicitly reset a host/bus/target/device
  * @dev:	scsi_device to operate on
@@ -2379,7 +2374,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	scsi_init_command(dev, scmd);
 	scmd->cmnd = scsi_req(rq)->cmd;
 
-	scmd->scsi_done		= scsi_reset_provider_done_command;
+	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f5ad22512f5..3fd24144b805 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1577,6 +1577,15 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
+	switch (cmd->submitter) {
+	case SUBMITTED_BY_BLOCK_LAYER:
+		break;
+	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
+		return scsi_eh_done(cmd);
+	case SUBMITTED_BY_SCSI_RESET_IOCTL:
+		return;
+	}
+
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
 		return;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
@@ -1683,6 +1692,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 	cmd->scsi_done = scsi_mq_done;
 
 	blk_mq_start_request(req);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 6d9152031a40..b7f963149352 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,6 +84,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
+void scsi_eh_done(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2315aac93c7..893c24aab8e4 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -64,6 +64,12 @@ struct scsi_pointer {
 #define SCMD_STATE_COMPLETE	0
 #define SCMD_STATE_INFLIGHT	1
 
+enum scsi_cmnd_submitter {
+	SUBMITTED_BY_BLOCK_LAYER = 0,
+	SUBMITTED_BY_SCSI_ERROR_HANDLER = 1,
+	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
+} __packed;
+
 struct scsi_cmnd {
 	struct scsi_request req;
 	struct scsi_device *device;
@@ -89,6 +95,7 @@ struct scsi_cmnd {
 	unsigned char prot_op;
 	unsigned char prot_type;
 	unsigned char prot_flags;
+	enum scsi_cmnd_submitter submitter;
 
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
