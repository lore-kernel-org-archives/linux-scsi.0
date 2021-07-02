Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFF7C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 09:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF86861090
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 09:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGBJXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 05:23:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35490 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhGBJXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 05:23:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1756A228DD;
        Fri,  2 Jul 2021 09:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625217662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=917ZlYP36XkgOQn6r9EovU4chAB4GY0K6ElVDj7YODY=;
        b=sLajJTTFNmV8Nvktrd+o8uuIMUZxAEl9Tr+QVltAoqWdc0T68npjmSCP4hl6TO1Wztud5m
        VSRRya4UauV2ui9ptakCit2uKdYO8xW5KXl0wtAM11svE+jfQ7ZgYmITEsrJV5hWG1wto4
        BBLOehp4Ll9UayhwyK/cnS3LVEHxNAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625217662;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=917ZlYP36XkgOQn6r9EovU4chAB4GY0K6ElVDj7YODY=;
        b=M+nDoxHbMNqYAN19hifaQ4MMP4HpxJ+X4dKVxedPAkqyOlTdCvbAcktsKmUfUopxSTgbTP
        y6Ekl88qQ9B30IDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 0A1DAA3B87;
        Fri,  2 Jul 2021 09:21:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 17828)
        id EFDFA5170E26; Fri,  2 Jul 2021 11:21:01 +0200 (CEST)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] qla2xxx: synchronize rport dev_loss_tmo setting
Date:   Fri,  2 Jul 2021 11:20:52 +0200
Message-Id: <20210702092052.93202-1-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
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
[lkp: Do not depend on nvme_fc_set_remoteport_devloss() for !NVME_FC]
Reported-by: kernel test robot <lkp@intel.com>
---

This patch got some more testing by one of our partners. So far, no
regression identified.

changes v2:
 - fixed build failure for !NVME_FC reported by lkp

 drivers/scsi/qla2xxx/qla_attr.c |  6 ++++++
 drivers/scsi/qla2xxx/qla_init.c | 10 +++-------
 drivers/scsi/qla2xxx/qla_nvme.c |  5 ++++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3aa9869f6fae..dad48a982804 100644
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
+	if (IS_ENABLED(CONFIG_NVME_FC) && fcport->nvme_remote_port)
+		nvme_fc_set_remoteport_devloss(fcport->nvme_remote_port,
+					       rport->dev_loss_tmo);
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0de250570e39..d078f16933c0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5631,13 +5631,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
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
@@ -5659,6 +5652,9 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		break;
 	}
 
+	if (NVME_TARGET(vha->hw, fcport))
+		qla_nvme_register_remote(vha, fcport);
+
 	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0cacb667a88b..678083a34e4d 100644
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

