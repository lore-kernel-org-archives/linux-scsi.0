Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5F6C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 11:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiG1LuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiG1LuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 07:50:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4839EF1B
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 04:50:09 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7D58133FD2;
        Thu, 28 Jul 2022 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659009008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=onwjqwmZp1XKnAVi3DqvLMaDrBfUynJjcYLbd5abIrg=;
        b=trPMWjMC5V5Nv+jdlpF+EwU3znGbxNyLxhgABKzOygJc87yd9AhHnnz/w2eiExkQWZky0w
        4acHj9K+w8Klah+hzOQUUFIWvHAl9Zh3M0JVzMOROckoaUz1dMNQnKNytBidH1AyJ6wXJm
        ixQVWsipZ6FNZ03y3V2RrGZtdEuX0V8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659009008;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=onwjqwmZp1XKnAVi3DqvLMaDrBfUynJjcYLbd5abIrg=;
        b=OXXcsCxuQGSwPDtyxguY5HQSziQdrua6+1KqjQuGOb4FTxQNnZMRuzGoIpdLZ9Euc/A44g
        LKqCG/ftGfoZLrCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 60B4E2C141;
        Thu, 28 Jul 2022 11:50:08 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 17828)
        id 680C351A6244; Thu, 28 Jul 2022 13:50:08 +0200 (CEST)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH v1] qla2xxx: Allow nvme report port registration
Date:   Thu, 28 Jul 2022 13:50:07 +0200
Message-Id: <20220728115007.4376-1-dwagner@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the both ONLINE state check into qla2x00_update_fcport and call
both register port register functions.

Currently, qla2x00_reg_remote_port and qla_nvme_register_remote check
the state if it is ONLINE. If it not, the state is set to ONLINE and
the function is executed.

qla2x00_reg_remote_port is called before qla_nvme_register_remote and
hence qla_nvme_register_remote will always bail out and never register
a nvme remote port.

Fixes: 6a45c8e137d4 ("scsi: qla2xxx: Fix disk failure to rediscover")
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_init.c | 33 ++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_nvme.c |  5 -----
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f3417a3e891..71b804cfd808 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5764,11 +5764,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct fc_rport *rport;
 	unsigned long flags;
 
-	if (atomic_read(&fcport->state) == FCS_ONLINE)
-		return;
-
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5864,18 +5859,25 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 
+	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
+		switch (vha->host->active_mode) {
+		case MODE_INITIATOR:
+		case MODE_DUAL:
+			qla2x00_reg_remote_port(vha, fcport);
+			break;
+		default:
+			break;
+		}
+
+		if (NVME_TARGET(vha->hw, fcport))
+			qla_nvme_register_remote(vha, fcport);
+	}
+
 	switch (vha->host->active_mode) {
-	case MODE_INITIATOR:
-		qla2x00_reg_remote_port(vha, fcport);
-		break;
 	case MODE_TARGET:
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
-			!vha->vha_tgt.qla_tgt->tgt_stopped)
-			qlt_fc_port_added(vha, fcport);
-		break;
 	case MODE_DUAL:
-		qla2x00_reg_remote_port(vha, fcport);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5884,9 +5886,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		break;
 	}
 
-	if (NVME_TARGET(vha->hw, fcport))
-		qla_nvme_register_remote(vha, fcport);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 87c9404aa401..7450c3458be7 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -37,11 +37,6 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
-	if (atomic_read(&fcport->state) == FCS_ONLINE)
-		return 0;
-
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));
-- 
2.35.3

