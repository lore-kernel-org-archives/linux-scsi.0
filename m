Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E640CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiBPVE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiBPVEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:33 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C5E2B1679
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:12 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id j4so2951754plj.8
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nBwtGryv3+hjFI6gPofqHnRhTZ05RYrc/eDIGaEQe1I=;
        b=kSGrsv91IjDZW540efBzYIJccRkz+ekQ2tyCgD+2XHxk9ijji9a61jd2IzUEUp+qgz
         IYfjhg9mYcAn5foDBkDO0fVtAw5A0UCODCxRhou7gerfKaWaDsLzVByEubJtbYCC/F58
         mwztTCPHXM3jESV8t0mYn1CO7HOWruSCNRMsq2TeEiDXyhQpkU2iJPxcUiw5xSUMIRVb
         ui/ds1lPsEhCNGYEt2GLpNOflEp+a55+XP8t340YpWKQFgI6HSfHSrS6Vqqq6ht+6MKA
         aMCwYhLlfyySCoJpD0CII06sOS3HZ4jbG0cFRfbh98hTGz0UJwVpNKaCC5yF8ONv93lu
         WVwQ==
X-Gm-Message-State: AOAM533ONo3066xC0WxlvrFSQbHHjJVXevRc1PagowZM1qdrT5+gyAWj
        ODgx/Ka/SxICKkoyVifNDi8=
X-Google-Smtp-Source: ABdhPJwTC6jV4sboA6BHVAtJ/YxLQFu03S6ovz9hTF5Fg97+HnuyXlNx9dU6+WAWO/mq/NA3I+vs7A==
X-Received: by 2002:a17:90b:f0c:b0:1b9:c6b7:7cd6 with SMTP id br12-20020a17090b0f0c00b001b9c6b77cd6mr3780577pjb.231.1645045451829;
        Wed, 16 Feb 2022 13:04:11 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:11 -0800 (PST)
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
Subject: [PATCH v4 43/50] scsi: qla2xxx: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:26 -0800
Message-Id: <20220216210233.28774-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
index 47d7fa1c7ae8..174e80fbbdae 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5201,8 +5201,6 @@ struct secure_flash_update_block_pk {
 
 #define	QLA_DSDS_PER_IOCB	37
 
-#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-
 #define QLA_SG_ALL	1024
 
 enum nexus_wait_type {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a4546346c18b..58c83525f006 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -739,7 +739,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	/* kref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -831,7 +831,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
-	CMD_SP(cmd) = NULL;
+	sp->type = 0;
 	scsi_done(cmd);
 	if (comp)
 		complete(comp);
@@ -934,8 +934,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2x00_sp_free_dma;
 	sp->done = qla2x00_sp_compl;
 
@@ -1025,7 +1023,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2xxx_qpair_sp_free_dma;
 	sp->done = qla2xxx_qpair_sp_compl;
 
@@ -1071,6 +1068,7 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp = scsi_cmd_priv(cmd);
 	int ret = QLA_SUCCESS;
 
 	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
@@ -1079,10 +1077,9 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
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
