Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58A6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiGMFVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E0D4BED
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1T025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=N0rYDc0ZgRpAE1vniMOFo1XkXLZLfqatmLha/WDLbxo=;
 b=QtG4WFmOicqOSrTRWN7VNECUfAp/t4rpBERp8zyULJRi0s67MBGCFB8rgWefP3uQHfnR
 uv8sbfDdrqjcCOPeA3jxLIpXaZsddQRC6FRzU8j9nfsvLN7Ol2VvLL5Tb2GsromMaXT2
 a7QopT+ssQeaVITeoBkt0b8RLA7xXiUHRXuq02L9k6JPmBQKF0tDfiBGHa5yGkskZ1Db
 IVzQfi4Z8ewgY4nuOxJF46jZoYtRU+65WWW+ar+E/Tid/3j2XA89GpNZ/wff1TLYhPcm
 daGCGk+ukcrbiTMQFLrmcNDj/z8XDs5wun4gpsCnYY30IQwz6kMJ4XoZbuuBbGmh7Gyx pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6B4A53F7084;
        Tue, 12 Jul 2022 22:20:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/10] Revert "scsi: qla2xxx: Fix disk failure to rediscover"
Date:   Tue, 12 Jul 2022 22:20:36 -0700
Message-ID: <20220713052045.10683-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KhfBLj8jNoXl5ra26fcezk3R9LIchAoY
X-Proofpoint-GUID: KhfBLj8jNoXl5ra26fcezk3R9LIchAoY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the regression of nvme discovery failure during
driver load time.

This reverts commit 6a45c8e137d4e2c72eecf1ac7cf64f2fdfcead99.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++---
 drivers/scsi/qla2xxx/qla_nvme.c | 5 -----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 41ffad65d29e..e9bc93395e2f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5789,8 +5789,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (atomic_read(&fcport->state) == FCS_ONLINE)
 		return;
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
@@ -5891,7 +5889,6 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		qla2x00_reg_remote_port(vha, fcport);
 		break;
 	case MODE_TARGET:
-		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
 			!vha->vha_tgt.qla_tgt->tgt_stopped)
 			qlt_fc_port_added(vha, fcport);
@@ -5909,6 +5906,8 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (NVME_TARGET(vha->hw, fcport))
 		qla_nvme_register_remote(vha, fcport);
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
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
2.19.0.rc0

