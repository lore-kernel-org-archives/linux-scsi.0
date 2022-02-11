Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5073CC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354078AbiBKWen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354160AbiBKWee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:34 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B1BD61
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:33 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id 9so15764323pfx.12
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=obqFmcwegg7HOsCBvXyobrImMxvfaN5PxLK3qmy5aNY=;
        b=6kQ0fb/vmtwh2owKuLH0ra7vptlJUKmeBmT8Ych3uTASsvWF4KM5FmW2Ps1jBF+BOY
         nIVXvrSI7i4nHPvjLhMm+jHkiVG1dQzlpeLqq/rD73fD5pDtu2VmUDogSDSMd+1heN8i
         vvXnei79h73BntVWw56GukexxMSgeCs6LUlShbP8WsZCiKsGW3U8pv7HWRhSVZI0sg4s
         vLUY90lM/pFKQKgD4D0NWAnD1PNKbLGJWXwxhyVzPs1WqiYf6MaJS+eASmUN1N0Kkzeo
         Dh2DsBaWi0gvkzrOwyXeRS+fv4LVV1C+kh8jVg9zOoIGaGD0cH5TgI6bUkgM76Z4DL3E
         iNWw==
X-Gm-Message-State: AOAM533bwYbdcPQ+uaonFUvWNAh6wav4772m064YfZkHrmbF30slQEnr
        PF1XbbmKYIlOJE5LTIhMEGti0ChmlDhmPswg
X-Google-Smtp-Source: ABdhPJzckR8WG5Qt5b5cuEcNpSYXwlMxH49GmmMaBU+fVJ3aisqF1dd6QSw1r261UnHA8b4oc9sGyQ==
X-Received: by 2002:a63:5b1c:: with SMTP id p28mr2705124pgb.227.1644618872560;
        Fri, 11 Feb 2022 14:34:32 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 41/48] scsi: qla2xxx: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:40 -0800
Message-Id: <20220211223247.14369-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
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
