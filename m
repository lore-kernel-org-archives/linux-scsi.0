Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D7BECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJaWs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJaWsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:48:25 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A62606
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:48:24 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id b11so11622267pjp.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pa1RofQj1I6p4dlAc/iGs5usi5F8KYKWv/Bkiy6WdKE=;
        b=oogVGWm6FoEezIlgBzdQdF3CeTZ7laSVp3ZH0Kbm9GjlZpUUlCZ+NUMtCCtNamqvWL
         taS6Z8WH61WhceZQKdeyqtXk+8bA8LuXgxpJgX2nIy0bHGxmDO507n05edmQ9smtPV7b
         0UXEsNAPLwTNqD0PuI5Gzp3LNdU+6Il1cMfgK3wSbtE17LfjhThwZ1szfR+q/fxJhYZV
         djTuu+CAMjPjgpwHTFy8b09gkBHj2mc9n+uMfIVg+5EoU28huWzUngH0HkwofvTgl3gi
         WFHLmQM6dW8vPm/cnc3vSomCHbN5f1VSO1t13o4nEIamtVgk864yGOKzbjjda2+rnRpX
         swDw==
X-Gm-Message-State: ACrzQf0zaeXnurjl2dnt0T4qQiNaW2Mc6ugWU0P916MrR0VgZNN7Yf4z
        MMqFqc7SH/W/PnzWv67dZu/SanjtPkE=
X-Google-Smtp-Source: AMsMyM4nsY8Hwjl0AtJN5PKb2XqvJtgZ6dZGkLgYvQvp/PeDOw4F8E5FFIQrwLRMGzhCxStTs/WDRw==
X-Received: by 2002:a17:902:edd5:b0:187:1e83:8b96 with SMTP id q21-20020a170902edd500b001871e838b96mr8386008plk.1.1667256503895;
        Mon, 31 Oct 2022 15:48:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090a4b4700b002137d3da760sm4687067pjl.39.2022.10.31.15.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:48:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <arun.easi@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: [PATCH] scsi: qla2xxx: Fix set-but-not-used variable warnings
Date:   Mon, 31 Oct 2022 15:48:18 -0700
Message-Id: <20221031224818.2607882-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following two compiler warnings:

drivers/scsi/qla2xxx/qla_init.c: In function ‘qla24xx_async_abort_cmd’:
drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
  171 |         uint8_t bail;
      |                 ^~~~
drivers/scsi/qla2xxx/qla_init.c: In function ‘qla2x00_async_tm_cmd’:
drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
 2023 |         uint8_t bail;
      |                 ^~~~

Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 22 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c   |  6 ++----
 drivers/scsi/qla2xxx/qla_inline.h |  4 +---
 drivers/scsi/qla2xxx/qla_os.c     |  4 +---
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 802eec6407d9..a26a373be9da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5136,17 +5136,17 @@ struct secure_flash_update_block_pk {
 		(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
 			 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
 
-#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		\
-	atomic_inc(&__vha->vref_count);			\
-	mb();						\
-	if (__vha->flags.delete_progress) {		\
-		atomic_dec(&__vha->vref_count);		\
-		wake_up(&__vha->vref_waitq);		\
-		__bail = 1;				\
-	} else {					\
-		__bail = 0;				\
-	}						\
-} while (0)
+static inline bool qla_vha_mark_busy(scsi_qla_host_t *vha)
+{
+	atomic_inc(&vha->vref_count);
+	mb();
+	if (vha->flags.delete_progress) {
+		atomic_dec(&vha->vref_count);
+		wake_up(&vha->vref_waitq);
+		return true;
+	}
+	return false;
+}
 
 #define QLA_VHA_MARK_NOT_BUSY(__vha) do {		\
 	atomic_dec(&__vha->vref_count);			\
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e12db95de688..631993504a76 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -168,7 +168,6 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
@@ -176,7 +175,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (!sp)
 		return QLA_MEMORY_ALLOC_FAILED;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
@@ -2020,14 +2019,13 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index db17f7f410cd..5185dc5daf80 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -225,11 +225,9 @@ static inline srb_t *
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
-	uint8_t bail;
 	struct qla_qpair *qpair;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (unlikely(bail))
+	if (unlikely(qla_vha_mark_busy(vha)))
 		return NULL;
 
 	qpair = vha->hw->base_qpair;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c85f3cce726..96ba1398f20c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5069,13 +5069,11 @@ struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
-	uint8_t bail;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
 		return NULL;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (bail)
+	if (qla_vha_mark_busy(vha))
 		return NULL;
 
 	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
