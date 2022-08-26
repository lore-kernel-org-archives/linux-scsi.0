Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1178ECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343681AbiHZK01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245240AbiHZK0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15812CD504
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q6TUeN001371
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=H1FpKouDBqTWqMRnM1hp51U8muX0Vib+l5VfxR264cA=;
 b=M8Frdsgj0LNrF1B4Gq1x+quv/Bim6QqEMvvjMKPp9n3Gr7zWLGWLJ+Qi1UA9cTX0YP6D
 R7NGH7CZIAczVska4/dsAhB9yXNuMAw8E3G48ZRpMg3yIJp1R+dlCfLa/yZu077WRjZw
 wxBEuCBbw/hHXbizWphBarC3K8P8CV25SupE3tg4ai4dMiHjKrLeahM8lupPy677ZWqB
 D5e0RVyOPbRVKtDLeAsSkoxWqY7v8yOPbMwzNwAuvsYoOGui30wpC/Q+FwyfxhLXj7Om
 dVmh3PDI1ipjR9bVOhnTXVvDKmMvlV+6Ho8SuPvhKmPg5INTVOkwJjOxCfB3GLgO8LF2 ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 26 Aug
 2022 03:26:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 600463F713B;
        Fri, 26 Aug 2022 03:26:17 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 2/7] qla2xxx: Fix response queue handler reading stale packets
Date:   Fri, 26 Aug 2022 03:25:54 -0700
Message-ID: <20220826102559.17474-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iiUpE2D0ewFWfCKw3a76RTFd4inKviy4
X-Proofpoint-GUID: iiUpE2D0ewFWfCKw3a76RTFd4inKviy4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

On some platforms, the current logic of relying on finding new packet
solely based on signature pattern can lead to driver reading stale
packets. Though this is a bug in those platforms, reduce such exposures by
limiting reading packets until the IN pointer.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ede76357ccb6..e19fde304e5c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,7 +3763,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 cur_ring_index;
+	u16 rsp_in = 0, cur_ring_index;
+	int is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3773,7 +3774,18 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)			\
+	do {								\
+		_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :		\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+
+	__update_rsp_in(is_shadow_hba, rsp, rsp_in);
+
+	while (rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
@@ -3887,6 +3899,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
-- 
2.19.0.rc0

