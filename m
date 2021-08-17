Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C046C43216
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA8660720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbhHQJRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33236 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0ADF521D1A;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0twZ8+gpwMBts+TajsUwzMhyCe/gO42X6KQ2yfFXzV0=;
        b=dpoMU9DCBagQfgcwnrHRYaqL6VWkA/19ggw/+qNg4DN0V0/Uau51fKGegShSXfSlCaDKk5
        OIfyDmzM8i51NK4JDMsAigKI5PkRY3EtvpVNGE72FJTL3B1eiVjgJcHUgBC8ywqF1lvVjo
        dRfUgDJJSNU/dArQujYoRNVXrktr3r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0twZ8+gpwMBts+TajsUwzMhyCe/gO42X6KQ2yfFXzV0=;
        b=84Vn1BCKxdhdfL+MAAfcINPOt1nZ/2BX0dMUVOtYrfYUJaXpn5iNYhrwQlCT2PIuhp5/pb
        ewVWCXQEPcBs0BAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 029EDA3BA2;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F2864518CE7D; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 15/51] qla2xxx: open-code qla2xxx_generic_reset()
Date:   Tue, 17 Aug 2021 11:14:20 +0200
Message-Id: <20210817091456.73342-16-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Device and target reset will be using different calling sequences,
so there's not point in trying to combine both.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 91 +++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 97568af82750..64820a3d34dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1388,13 +1388,20 @@ static char *reset_errors[] = {
 };
 
 static int
-__qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, int))
+qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x803e,
+		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
+		return FAILED;
+	}
+
 	if (!fcport) {
 		return FAILED;
 	}
@@ -1407,8 +1414,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		return SUCCESS;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
-	    cmd->device->id, cmd->device->lun, cmd);
+	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
@@ -1417,29 +1424,29 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		goto eh_reset_failed;
 	}
 	err = 2;
-	if (do_reset(fcport, cmd->device->lun, 1)
+	if (ha->isp_ops->lun_reset(fcport, cmd->device->lun, 1)
 		!= QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
-		    "do_reset failed for cmd=%p.\n", cmd);
+		    "lun_reset failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, type) != QLA_SUCCESS) {
+	    cmd->device->lun, WAIT_LUN) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
 		    "wait for pending cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n", name,
+	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n",
 	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n", name,
+	    "DEVICE RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n",
 	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
 	    cmd);
 	vha->reset_cmd_err_cnt++;
@@ -1447,37 +1454,69 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 }
 
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct qla_hw_data *ha = vha->hw;
+	int err;
 
 	if (qla2x00_isp_reg_stat(ha)) {
-		ql_log(ql_log_info, vha, 0x803e,
+		ql_log(ql_log_info, vha, 0x803f,
 		    "PCI/Register disconnect, exiting.\n");
 		qla_pci_set_eeh_busy(vha);
 		return FAILED;
 	}
 
-	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
-	    ha->isp_ops->lun_reset);
-}
+	if (!fcport) {
+		return FAILED;
+	}
 
-static int
-qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
-{
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	struct qla_hw_data *ha = vha->hw;
+	err = fc_block_scsi_eh(cmd);
+	if (err != 0)
+		return err;
 
-	if (qla2x00_isp_reg_stat(ha)) {
-		ql_log(ql_log_info, vha, 0x803f,
-		    "PCI/Register disconnect, exiting.\n");
-		qla_pci_set_eeh_busy(vha);
-		return FAILED;
+	if (fcport->deleted)
+		return SUCCESS;
+
+	ql_log(ql_log_info, vha, 0x8009,
+	    "TARGET RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
+	    cmd->device->id, cmd->device->lun, cmd);
+
+	err = 0;
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800a,
+		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
+	}
+	err = 2;
+	if (ha->isp_ops->target_reset(fcport, cmd->device->lun, 1)
+		!= QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800c,
+		    "target_reset failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
 	}
+	err = 3;
+	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
+	    cmd->device->lun, WAIT_TARGET) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800d,
+		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		goto eh_reset_failed;
+	}
+
+	ql_log(ql_log_info, vha, 0x800e,
+	    "TARGET RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
 
-	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
-	    ha->isp_ops->target_reset);
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

