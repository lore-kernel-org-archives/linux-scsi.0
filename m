Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A956C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5525B61131
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhHSJUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:20:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60734 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhHSJUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:20:01 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4F61C220C5;
        Thu, 19 Aug 2021 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFO7tT0n3EW5EYtL7RILnY9dE6WFfaS/BUVBhwtUwtI=;
        b=tldG65aY2QWssRrU1AfbU/jYVhEi2WO2NrI3DmFHcKXvYq4UNijeNBzu08oPfpHgnhhVrT
        koJonkRvCnNeB+V8Xska6JI9wkXk8sK/ibGZWdFgADQTWxa2ttdmF6YKB6WZZRJLBIIvfi
        2jCjruccw2QNaTAtNp/iPCUKNXMjzY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFO7tT0n3EW5EYtL7RILnY9dE6WFfaS/BUVBhwtUwtI=;
        b=xMmc77DEXLyF/4JtDFplY9l+n9DS+RajAZSfhpj2relQsQ0a+C7olRmdyiold7le+O58e0
        rBDzp3FTIebM4yAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8A253A3BA1;
        Thu, 19 Aug 2021 09:19:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3676B518D29A; Thu, 19 Aug 2021 11:19:24 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] qla2xxx: Open-code qla2xxx_eh_target_reset()
Date:   Thu, 19 Aug 2021 11:19:12 +0200
Message-Id: <20210819091913.94436-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091913.94436-1-hare@suse.de>
References: <20210819091913.94436-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Device reset and target reset will be using different calling sequences,
so open-code __qla2xxx_eh_generic_reset() in qla2xxx_eh_target_reset().
No functional changes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 56 +++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 54254bd3a7d7..7786af46224a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1466,8 +1466,12 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	scsi_qla_host_t *vha = shost_priv(rport_to_shost(rport));
 	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+	int err;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x803f,
@@ -1476,8 +1480,54 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
-	    ha->isp_ops->target_reset);
+	if (!fcport) {
+		return FAILED;
+	}
+
+	err = fc_block_rport(rport);
+	if (err != 0)
+		return err;
+
+	if (fcport->deleted)
+		return SUCCESS;
+
+	ql_log(ql_log_info, vha, 0x8009,
+	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,
+	    sdev->id, cmd);
+
+	err = 0;
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800a,
+		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
+	}
+	err = 2;
+	if (ha->isp_ops->target_reset(fcport, 0, 0) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800c,
+		    "target_reset failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
+	}
+	err = 3;
+	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+	    0, WAIT_TARGET) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800d,
+		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
+	}
+
+	ql_log(ql_log_info, vha, 0x800e,
+	    "TARGET RESET SUCCEEDED nexus:%ld:%d cmd=%p.\n",
+	    vha->host_no, sdev->id, cmd);
+
+	return SUCCESS;
+
+eh_reset_failed:
+	ql_log(ql_log_info, vha, 0x800f,
+	    "TARGET RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n",
+	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
+	    cmd);
+	vha->reset_cmd_err_cnt++;
+	return FAILED;
 }
 
 /**************************************************************************
-- 
2.29.2

