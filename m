Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B872BECAAD5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbiHZK00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245175AbiHZK0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A651BCCE38
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q6TUeM001371
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RmF61vHP3111WNpuYDtji5b78W9LtHyzT1foJ4J3+iI=;
 b=BuvXOqPw/reSu4G8JM9Ahu0F8CNaecN7aYw26DOjrvV2qTVkroJS6HqfhmmRDET6LwT9
 8/gTFGIXto4EQTmMO7sPv0whaT8lX8woylVVpwuDJ1IRyI2NIGPggwDH5V5UYOF6nXdO
 Q9GaVRUIsCXMSAUHBZ0FYYWBb5xgKJRikhnyKQzB9Qk3rRhz1TX0AmaP28olxMejQHNW
 ytHFxQQZ2vVPNvGzu5BsaaDiUH4y3T0zbeps0uZGmlrb0xNW95BsiOqzkCk3l3hiNhbf
 9N3tfvNd5rmOGscR9tfeKKwmRlK1x/AskUGyA6hyagp4K+cnaNgqrQaYE1Bjg0Tm9eAp Iw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 26 Aug
 2022 03:26:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 298A33F7137;
        Fri, 26 Aug 2022 03:26:17 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 1/7] Revert "scsi: qla2xxx: Fix response queue handler reading stale packets"
Date:   Fri, 26 Aug 2022 03:25:53 -0700
Message-ID: <20220826102559.17474-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bTw8nNGetLnQ8RH3vWH4WTOaG2fiLr7_
X-Proofpoint-GUID: bTw8nNGetLnQ8RH3vWH4WTOaG2fiLr7_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Reverting this patch so that a fixed up patch, without adding new module
parameters, could be submitted.

    Link: https://lore.kernel.org/stable/166039743723771@kroah.com/

This reverts commit b1f707146923335849fb70237eec27d4d1ae7d62.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 --
 drivers/scsi/qla2xxx/qla_isr.c | 25 ++-----------------------
 drivers/scsi/qla2xxx/qla_os.c  | 10 ----------
 3 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5dd2932382ee..bb69fa8b956a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,8 +193,6 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
-extern int ql2xrspq_follow_inptr;
-extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 76e79f350a22..ede76357ccb6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,8 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0, cur_ring_index;
-	int follow_inptr, is_shadow_hba;
+	u16 cur_ring_index;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3774,25 +3773,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
-	do {								\
-		if (_update) {						\
-			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
-				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
-		}							\
-	} while (0)
-
-	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
-	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
-				ql2xrspq_follow_inptr_legacy;
-
-	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
-
-	while ((likely(follow_inptr &&
-		       rsp->ring_index != rsp_in &&
-		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
-		       (!follow_inptr &&
-			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
+	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
@@ -3906,8 +3887,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
-				__update_rsp_in(follow_inptr, is_shadow_hba,
-						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0bd0fd1042df..1c7fb6484db2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,16 +338,6 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
-int ql2xrspq_follow_inptr = 1;
-module_param(ql2xrspq_follow_inptr, int, 0644);
-MODULE_PARM_DESC(ql2xrspq_follow_inptr,
-		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
-
-int ql2xrspq_follow_inptr_legacy = 1;
-module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
-MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
-		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
-
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
-- 
2.19.0.rc0

