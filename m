Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEEC6124D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347043AbhI2WIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:00 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40815 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344298AbhI2WH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:07:59 -0400
Received: by mail-pg1-f172.google.com with SMTP id h3so4140269pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TfTiZ3edd6c86PtaAT6AwyYW9o+FdCauqGDHiHet/BU=;
        b=uZ+9u5kPiS27Jgi2ahV8x9uzthu0Ek2x4XtCbq8XUSXqqPYPcplB/aeQ62Nz/3PGWk
         b0o4tijIVO01wGNPuQcysHQ8FJeqGrmCtqqkg6g1G3Ww6ci4aLFyjl1Gd6NOY5vSxCsH
         RggYKDOyr3VlV0w5S5cSokyYMQTmKcH9gmZZQ6Q54hmoVXx8ovlcMXTCLpLAdJpsyDP7
         iEVAUJ3RlTOag/TM9uZ8P2orRoWnmANkWLoHbGQ70YPONKrvAh24XOpXDfIk7T2isVno
         t15W8dMX8TBkRiwBKs9Z5puKo3n2znLl7EhaqXpwaiVlTihxP0UK/rS77pIJEkf0GEgo
         ByuQ==
X-Gm-Message-State: AOAM530PWRk6rB+F2iJlHRQ0DXRWxtFI1vcXNILW2l+3X9wiZnkCJyE0
        qV4RSFjiV/v5hx4d4U3xNnY=
X-Google-Smtp-Source: ABdhPJwI1L/WDxeouJ2no0xlfgS5Zov4LcwZYAkQMQ3qL8wHe4beXOlTLaZ4edqLlalCLkSDLWclqQ==
X-Received: by 2002:a05:6a00:1390:b0:447:961d:39b9 with SMTP id t16-20020a056a00139000b00447961d39b9mr2002307pfg.83.1632953178067;
        Wed, 29 Sep 2021 15:06:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 01/84] scsi: core: Use a member variable to track the SCSI command submitter
Date:   Wed, 29 Sep 2021 15:04:37 -0700
Message-Id: <20210929220600.3509089-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Use a member variable
to track the SCSI command submitter such that later patches can call
scsi_done(scmd) instead of scmd->scsi_done(scmd).

The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
context to the SCSI error handler and that it does not restore the
submission context to the SCSI core is retained.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 18 +++++++-----------
 drivers/scsi/scsi_lib.c   | 10 ++++++++++
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_cmnd.h  |  7 +++++++
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b6c86cce57bf..26f1388decef 100644
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
 
@@ -986,6 +985,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->prot_op = scmd->prot_op;
 	ses->eh_eflags = scmd->eh_eflags;
 
+	WARN_ON_ONCE(scmd->submitter != SUBMITTED_BY_BLOCK_LAYER);
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->eh_eflags = 0;
 	scmd->cmnd = ses->eh_cmnd;
@@ -1082,7 +1082,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
-	scmd->scsi_done = scsi_eh_done;
+	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
 
 	/*
 	 * Lock sdev->state_mutex to avoid that scsi_device_quiesce() can
@@ -1109,6 +1109,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 	if (rtn) {
 		if (timeleft > stall_for) {
 			scsi_eh_restore_cmnd(scmd, &ses);
+
 			timeleft -= stall_for;
 			msleep(jiffies_to_msecs(stall_for));
 			goto retry;
@@ -2338,11 +2339,6 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
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
@@ -2379,7 +2375,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	scsi_init_command(dev, scmd);
 	scmd->cmnd = scsi_req(rq)->cmd;
 
-	scmd->scsi_done		= scsi_reset_provider_done_command;
+	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dcf105287a76..c0c1f1ca0382 100644
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
