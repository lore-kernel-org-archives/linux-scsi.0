Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3474BC43214
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A42761100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhHSJUD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:20:03 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60742 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhHSJUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:20:01 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4E2A0220C4;
        Thu, 19 Aug 2021 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzdRI3i/ZZX7zfPKC+RwdzU5N22XOOUpC4VfI+Pkmeo=;
        b=K4L2nl7jdUE+sYoRICMzf7m3tgAy/JP8SuAGnuwUY9pJL2fHoJv0zUfxqxZQxeV4agyU8b
        dNeOxCwOLX5L7qj+bLBRDs+v69LKQzDj1fxr32Pn93ciP2U8DHYdfEba4ekzmkRgdzwyEE
        kTZg7OVH5kRD20HXoDQAibimAtCAz/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzdRI3i/ZZX7zfPKC+RwdzU5N22XOOUpC4VfI+Pkmeo=;
        b=zJwZbhzB/miE3BcB2qXoPLQEHg+wekAn9VgLGlO1LIIZNh72W1GVlwHN7Y4rYNM+Ip5wfy
        hWEITqVr+C+PQ3DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8B2FDA3BA2;
        Thu, 19 Aug 2021 09:19:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3CE0B518D29C; Thu, 19 Aug 2021 11:19:24 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] qla2xxx: Open-code qla2xxx_eh_device_reset()
Date:   Thu, 19 Aug 2021 11:19:13 +0200
Message-Id: <20210819091913.94436-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091913.94436-1-hare@suse.de>
References: <20210819091913.94436-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Device reset and target reset will be using different calling sequences,
so open-code __qla2xxx_eh_generic_reset() in qla2xxx_eh_device_reset(),
and remove the now obsolete function __qla2xxx_eh_generic_reset().
No functional changes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 54 +++++++++++++++--------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7786af46224a..ea804dc69b6f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1388,18 +1388,27 @@ static char *reset_errors[] = {
 };
 
 static int
-__qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, int))
+qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct scsi_device *sdev = cmd->device;
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
+	struct qla_hw_data *ha = vha->hw;
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
 
-	err = fc_block_scsi_eh(cmd);
+	err = fc_block_rport(rport);
 	if (err != 0)
 		return err;
 
@@ -1407,8 +1416,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		return SUCCESS;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
-	    cmd->device->id, cmd->device->lun, cmd);
+	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
+	    sdev->id, sdev->lun, cmd);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
@@ -1417,52 +1426,35 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		goto eh_reset_failed;
 	}
 	err = 2;
-	if (do_reset(fcport, cmd->device->lun, 1)
+	if (ha->isp_ops->lun_reset(fcport, sdev->lun, 1)
 		!= QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
 		    "do_reset failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, type) != QLA_SUCCESS) {
+	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+	    sdev->lun, WAIT_LUN) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
 		    "wait for pending cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n", name,
-	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
+	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n",
+	    vha->host_no, sdev->id, sdev->lun, cmd);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n", name,
-	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
+	    "DEVICE RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n",
+	    reset_errors[err], vha->host_no, sdev->id, sdev->lun,
 	    cmd);
 	vha->reset_cmd_err_cnt++;
 	return FAILED;
 }
 
-static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
-{
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	struct qla_hw_data *ha = vha->hw;
-
-	if (qla2x00_isp_reg_stat(ha)) {
-		ql_log(ql_log_info, vha, 0x803e,
-		    "PCI/Register disconnect, exiting.\n");
-		qla_pci_set_eeh_busy(vha);
-		return FAILED;
-	}
-
-	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
-	    ha->isp_ops->lun_reset);
-}
-
 static int
 qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-- 
2.29.2

