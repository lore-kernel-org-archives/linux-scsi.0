Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C06C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351091AbiA1WWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:19 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:42761 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351667AbiA1WV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:57 -0500
Received: by mail-pj1-f51.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so7747796pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0uK34FHeF3Ias0TEmXBKKLpaBsfRQUJQprRkSixOyE=;
        b=oma2Kf6soUCj5uBr8sXWq49G1XKOdR3ZSQmQ/jWYyjy/hKgldU4Ep664RE5cYy6d71
         iQz+0FkSawIFYWLuvybyndEa6EQArJ12I+Yqhs67vIvHQJTijXYOZI8bvj55qguh1NL7
         A6gC6k2AdQJekb3QfReAHD/WB0DJ2GRJAN/optsuYjXg/6+XO5UMxqBB8G+V7qczoEqI
         3M8YGxcaF/kF6ai+BX14p9j2RVhn7lncshrBXDPIY70vMS13sIu4wT3JCDLlBcHLSXuf
         j/BKcKbsUmBa9eit3AoaHrxEHa3ZEUcSk61cRQd1hUmpCweuaFbDCYYVdd7SfHB58rbJ
         yusg==
X-Gm-Message-State: AOAM533xA8VtYqiCDM/PVZp4feaq2hp+OLdWz3fBYkH+BYglzlWJdBRg
        yf+ribyFAmX+tl9CCJShbNc=
X-Google-Smtp-Source: ABdhPJz540Od78BCzLzztyaSX4hMTzGRL6JXoAqTxi4Nuh9mORETzhahkQ6S0Sy3QLrta3dD/KOoTA==
X-Received: by 2002:a17:902:d50d:: with SMTP id b13mr10447958plg.36.1643408509633;
        Fri, 28 Jan 2022 14:21:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 37/44] qla2xxx: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:19:02 -0800
Message-Id: <20220128221909.8141-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using the SCp.ptr field to track whether or not a command is
in flight, use the sp->type field to track this information. sp->type
must be set for proper operation of the qla2xxx driver. See e.g. the
switch (sp->type) statement in qla2x00_ct_entry().

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 --
 drivers/scsi/qla2xxx/qla_os.c  | 13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ebf4a234d9a..064496f9eba3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5191,8 +5191,6 @@ struct secure_flash_update_block_pk {
 
 #define	QLA_DSDS_PER_IOCB	37
 
-#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-
 #define QLA_SG_ALL	1024
 
 enum nexus_wait_type {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index abcd30917263..6c45379a5306 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -730,7 +730,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 
 	sp->free(sp);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -821,7 +821,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 
 	sp->free(sp);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -923,8 +923,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2x00_sp_free_dma;
 	sp->done = qla2x00_sp_compl;
 
@@ -1012,7 +1010,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2xxx_qpair_sp_free_dma;
 	sp->done = qla2xxx_qpair_sp_compl;
 
@@ -1057,6 +1054,7 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp = scsi_cmd_priv(cmd);
 	int ret = QLA_SUCCESS;
 
 	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
@@ -1065,10 +1063,9 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 		return ret;
 	}
 
-	while (CMD_SP(cmd) && wait_iter--) {
+	while (sp->type && wait_iter--)
 		msleep(ABORT_POLLING_PERIOD);
-	}
-	if (CMD_SP(cmd))
+	if (sp->type)
 		ret = QLA_FUNCTION_FAILED;
 
 	return ret;
