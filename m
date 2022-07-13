Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB723CCA480
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiGMFVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534D2D4BF6
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2MG1u026753
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=pSSAG7T/NH4CIGkT7i/UvtDQOiqz6yld63HWwG/WhJg=;
 b=LKUNrBkjxiN9pP9fFkuapqE0ioBkM4qk8STKB3U4D35sR6Oxb+dLKLOvN7UNupsfprdH
 iNYioOcqMuIV64u+fXNItqTUPa1h97zffMycvRX+4Kk34nmvaTZUXNbaqUDrB4aLWjHZ
 MSAjYG6jnLtWrYfJgZTaq9xwSPzVAsCrauXBRP8xE55Cz/U+5HOAxNfWmLvINknncMtF
 Qk+LVlvlrZSauvCbiLBo6q5zmhonXk3xsT9VXGYWNPSB5k+pz9M65BRtXkWHzbq6RzXw
 4BsJhuIHq1ZhBF7VfLcbRHLx6/IPsKncqGaQ6Y7R084askXU34rms/FdsN6zYEZTQRBa vQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Jul
 2022 22:20:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0028D3F70AB;
        Tue, 12 Jul 2022 22:20:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/10] qla2xxx: Fix response queue handler reading stale packets
Date:   Tue, 12 Jul 2022 22:20:39 -0700
Message-ID: <20220713052045.10683-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WhW4YIXvxuYWrz6xtal_q1RC010ON2HG
X-Proofpoint-GUID: WhW4YIXvxuYWrz6xtal_q1RC010ON2HG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

On some platforms, the current logic of relying on finding new
packet solely based on signature pattern can lead to driver
reading stale packets. Though this is a bug in those platforms,
reduce such exposures by limiting reading packets until the IN
pointer.

Two module parameters are introduced:
ql2xrspq_follow_inptr:
When set, on newer adapters that has queue pointer shadowing,
look for response packets only until response queue in
pointer.

When reset, response packets are read based on a
signature pattern logic (old way).

ql2xrspq_follow_inptr_legacy:
Like ql2xrspq_follow_inptr, but for those
adapters where there is no queue pointer shadowing.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 ++
 drivers/scsi/qla2xxx/qla_isr.c | 24 +++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 10 ++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3674b35196b0..96147ca40126 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,6 +193,8 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
+extern int ql2xrspq_follow_inptr;
+extern int ql2xrspq_follow_inptr_legacy;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4fa24d318f14..35b425c446b9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3780,6 +3780,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
+	u16 rsp_in = 0;
+	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3789,7 +3791,25 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
+	do {								\
+		if (_update) {						\
+			_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :	\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+		}							\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+	follow_inptr = is_shadow_hba ? ql2xrspq_follow_inptr :
+				ql2xrspq_follow_inptr_legacy;
+
+	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
+
+	while ((likely(follow_inptr &&
+		       rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED)) ||
+		       (!follow_inptr &&
+			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
 		rsp->ring_index++;
@@ -3902,6 +3922,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(follow_inptr, is_shadow_hba,
+						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7fb6484db2..0bd0fd1042df 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,6 +338,16 @@ module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");
 
+int ql2xrspq_follow_inptr = 1;
+module_param(ql2xrspq_follow_inptr, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr,
+		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (default: 1).");
+
+int ql2xrspq_follow_inptr_legacy = 1;
+module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
+MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
+		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (default: 1).");
+
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
-- 
2.19.0.rc0

