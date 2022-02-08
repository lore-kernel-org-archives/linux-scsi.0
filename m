Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349E9C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384161AbiBHR1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384339AbiBHR0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:54 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A5C061266
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:52 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso3540972pjm.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzWP2OcUmUpNS3okRoFAY0jR6PTP8SLWWhXRQKvrbzI=;
        b=lgX9EKGEI0PHdMZ6U21fi9WnbR4PxR1CVorbR85ouBoirT6VpPGWmj1G/NPtqBmis8
         yV8xZYCl9Z6xczDNKVRjIY4lA1OMI2FYXTozoWbHim/gqIp6nhlY76kRyhh7cZNxIUzs
         /1Rm5n7zmH7vpvoxkd0h8w+1JB/SlFmRDQcZfbPKlHw+F6AIgJ14OqJuFSC1QKmF0E5G
         eC5+KZldSOJtk1bbEH7OKetErP2UsNDZgC8t/JI7ZVfuXetCDInpaSWpd9RVZYriROS4
         5fcKlIqWb6qAnXP14+OAqrrcNPMiZGir+ad4O2A5wvlkktjlhckjnfu0WrVac5GHYBUX
         M6cA==
X-Gm-Message-State: AOAM532L0obeppfOtI3M+ktkb1/Y6gWoov3pdjFDcNE9t3MDbLQN7Ehn
        f8Ki6T5WqMB1tpA6BkrcUAM=
X-Google-Smtp-Source: ABdhPJyROxNDcWhZ9rDvV0gW7ao2v31iIBOIlOEMhg7wt1ydu4PyJatwIdQwbP+5SrVI+2Hhtr6Zeg==
X-Received: by 2002:a17:902:7606:: with SMTP id k6mr5422416pll.56.1644341211429;
        Tue, 08 Feb 2022 09:26:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 37/44] qla2xxx: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:07 -0800
Message-Id: <20220208172514.3481-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
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
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Ewan D. Milne <emilne@redhat.com>
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
