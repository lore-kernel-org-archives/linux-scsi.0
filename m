Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63704C48BD1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 10:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F983611C9
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 10:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhFIK2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 06:28:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38552 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhFIK2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 06:28:41 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D7E45219AF;
        Wed,  9 Jun 2021 09:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623232234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvW0mHPDOY2f5vF2VERxSgZ7iWKgInFYzb+o7n87p3Y=;
        b=IwHRgY2gpyS8zg3lLb7hhAOoCeF335f24+a6gmGqKFAUrl93rdww0hcU4QNJwrPax8S3MW
        6zXB5NNBi5h2kv+uhMTMBHGPIYdPXV59SewYrtGxKbnmiL79N9JLTCxNRgiVlfRfsvoCzR
        5GAiIdWEB/1EchUuS3Td3mzTC79NQFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623232234;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvW0mHPDOY2f5vF2VERxSgZ7iWKgInFYzb+o7n87p3Y=;
        b=VmxFXjatL1IpMgt1H1mGLL6m4tJ53rwtrocntVoh7KVdBcf2xnuOHjH3xkpUO617hV8GUw
        l3fzSjN1H7fYARBQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BD5FE118DD;
        Wed,  9 Jun 2021 09:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623232234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvW0mHPDOY2f5vF2VERxSgZ7iWKgInFYzb+o7n87p3Y=;
        b=IwHRgY2gpyS8zg3lLb7hhAOoCeF335f24+a6gmGqKFAUrl93rdww0hcU4QNJwrPax8S3MW
        6zXB5NNBi5h2kv+uhMTMBHGPIYdPXV59SewYrtGxKbnmiL79N9JLTCxNRgiVlfRfsvoCzR
        5GAiIdWEB/1EchUuS3Td3mzTC79NQFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623232234;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvW0mHPDOY2f5vF2VERxSgZ7iWKgInFYzb+o7n87p3Y=;
        b=VmxFXjatL1IpMgt1H1mGLL6m4tJ53rwtrocntVoh7KVdBcf2xnuOHjH3xkpUO617hV8GUw
        l3fzSjN1H7fYARBQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id PjKULuqOwGDUGAAALh3uQQ
        (envelope-from <dwagner@suse.de>); Wed, 09 Jun 2021 09:50:34 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>
Cc:     linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: synchronize rport dev_loss_tmo setting
Date:   Wed,  9 Jun 2021 11:49:56 +0200
Message-Id: <20210609094956.11286-1-dwagner@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Currently, the dev_loss_tmo setting is only ever used for SCSI
devices. This patch reshuffles initialisation such that the SCSI
remote ports are registered before the NVMe ones, allowing the
dev_loss_tmo setting to be synchronized between SCSI and NVMe.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

This is a followup on

  https://lore.kernel.org/linux-scsi/20210419100014.47144-1-dwagner@suse.de/

Hannes and I started to play with this patch. After a few iterations
on getting the right dev_loss_tmo variables set, it works as
hoped. With this change, it's possible to use the same udev rule for
qla2xxx as we currently use for lpfc driver. And it survived serious
testing sessions.

Thanks,
Daniel

 drivers/scsi/qla2xxx/qla_attr.c |  6 ++++++
 drivers/scsi/qla2xxx/qla_init.c | 10 +++-------
 drivers/scsi/qla2xxx/qla_nvme.c |  5 ++++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3aa9869f6fae..c762c940970f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2648,7 +2648,13 @@ qla2x00_get_starget_port_id(struct scsi_target *starget)
 static inline void
 qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+
 	rport->dev_loss_tmo = timeout ? timeout : 1;
+
+	if (fcport->nvme_remote_port)
+		nvme_fc_set_remoteport_devloss(fcport->nvme_remote_port,
+					       rport->dev_loss_tmo);
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index eb825318e3f5..7f5b64a5ec90 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5629,13 +5629,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla2x00_dfs_create_rport(vha, fcport);
 
-	if (NVME_TARGET(vha->hw, fcport)) {
-		qla_nvme_register_remote(vha, fcport);
-		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-		return;
-	}
-
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 
 	switch (vha->host->active_mode) {
@@ -5657,6 +5650,9 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		break;
 	}
 
+	if (NVME_TARGET(vha->hw, fcport))
+		qla_nvme_register_remote(vha, fcport);
+
 	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index e119f8b24e33..5cc58957dbec 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -41,7 +41,7 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 	req.port_name = wwn_to_u64(fcport->port_name);
 	req.node_name = wwn_to_u64(fcport->node_name);
 	req.port_role = 0;
-	req.dev_loss_tmo = 0;
+	req.dev_loss_tmo = fcport->dev_loss_tmo;
 
 	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_INITIATOR)
 		req.port_role = FC_PORT_ROLE_NVME_INITIATOR;
@@ -68,6 +68,9 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 		return ret;
 	}
 
+	nvme_fc_set_remoteport_devloss(fcport->nvme_remote_port,
+				       fcport->dev_loss_tmo);
+
 	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_SLER)
 		ql_log(ql_log_info, vha, 0x212a,
 		       "PortID:%06x Supports SLER\n", req.port_id);
-- 
2.29.2

