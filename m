Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAB5C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 08:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344968AbiCHIWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 03:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344950AbiCHIWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 03:22:05 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5523F312
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 00:21:08 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22881NI8019263
        for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2022 00:21:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0BLKYEdapfD48YfBugNg0r93uA6yWTnAFxU0b3Ib8BE=;
 b=gEUkm2MrmqznimlvWaBVPF5b9MzyYzxKOCMLSGLitgkJV35378vsq3vNVAn9Zh8ejebS
 WqN7yjsRLkYgcK2+9A8oqvH9YIM7/c5PGM17WR8/gd6Vn+Ppg/F9RLW+8GyZ8ieUl73w
 x54y6V+qZCBev5mn484ds/M7dI1O6MElhyQy8EhDBqoLkgTZURkWLvphwrDwppfVZ2qq
 t/k5Qp1heRO8gNbEkL9QzalRGa/YxDYv1cm+/QKOzVKPLZYoQmSGGYZQLJch7qWTcE7c
 QEf+WrIvqJnFYJGtWTMDuNGnI1/Q0ejSfoko0oBEl7h8lEYRAkivwDnGvOjnvcA798cv +w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38p838b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 00:21:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Mar
 2022 00:21:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Mar 2022 00:21:05 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9B93A5B6929;
        Tue,  8 Mar 2022 00:21:05 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2288L5L6009817;
        Tue, 8 Mar 2022 00:21:05 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2288L52E009816;
        Tue, 8 Mar 2022 00:21:05 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/13] qla2xxx: Fix disk failure to rediscover
Date:   Tue, 8 Mar 2022 00:20:37 -0800
Message-ID: <20220308082048.9774-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220308082048.9774-1-njavali@marvell.com>
References: <20220308082048.9774-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8sjtvDFpeAE8qtOZrJtR2N_GouPdEQ_x
X-Proofpoint-ORIG-GUID: 8sjtvDFpeAE8qtOZrJtR2N_GouPdEQ_x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experience some of the LUN failed to rediscovered after
long cable pull test. The issue is triggered by a race
condition between driver setting session online state vs upper layer/UL
starting the LUN scan process at the same time. Current code
set the online state after notifying upper layer the session is
available. In this case, UL was faster on the trigger to start
the LUN scan process before driver could set the session in
online state. LUN scan ends up with failure due to the session
online check was failing.

Set the online state before reporting to UL
of the availability of the session.

Cc: stable@vger.kernel.org
Fixes: aecf043443d3 ("scsi: qla2xxx: Fix Remote port registration")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 drivers/scsi/qla2xxx/qla_nvme.c | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 835ed4179887..6ffe44b805b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5758,6 +5758,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5858,6 +5860,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
+		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5875,8 +5878,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (NVME_TARGET(vha->hw, fcport))
 		qla_nvme_register_remote(vha, fcport);
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	if (IS_IIDMA_CAPABLE(vha->hw) && vha->hw->flags.gpsc_supported) {
 		if (fcport->id_changed) {
 			fcport->id_changed = 0;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 718c761ff5f8..5723082d94d6 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -37,6 +37,11 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 		(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return 0;
 
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		return 0;
+
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
 	fcport->nvme_flag &= ~NVME_FLAG_RESETTING;
 
 	memset(&req, 0, sizeof(struct nvme_fc_port_info));
-- 
2.19.0.rc0

