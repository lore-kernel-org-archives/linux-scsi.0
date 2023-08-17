Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7225CC41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 06:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348253AbjHQGbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 02:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbjHQGbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 02:31:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0394
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 23:31:42 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37H3Olbw015652;
        Wed, 16 Aug 2023 23:31:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=67qlbvYWFpXrmTQ2xlSu5PxlMyIx+BSJrYh1tUjAb0U=;
 b=isC59xhmo4udg7+UuMOX1l2gWkt76HIw0zNCSzsJFHSb3tClan2XbfNj8ai37x9EXrqB
 hdMHSVbUnFxe6XNcG1b30YzTiWozdOoAgFNThAkChARza2Db8jMqDHIKwHTSXlKB6QOp
 VXvL7ikjgcUT2BhM1r0Bgjc9PIwnUUirgN2iTKIqQZBE8qVfCv9GR6wnbvPer7VSSJop
 vc6voSuwKphD8cKHxJfdm6pOgZMsuDLczVwKDkqphvcrkUI3fgWpZTBkl+Xrl617QIwM
 LXibvpA3FVY7agc8jq3Aq/jYR9T8Mj4rSqPe56xQsS/PUZZRTARlFTaGMQ+Vjw2bih9z nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sgptkvss9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 23:31:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 16 Aug
 2023 23:31:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 16 Aug 2023 23:31:38 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 412A93F7084;
        Wed, 16 Aug 2023 23:31:35 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 1/2] qla2xxx: Move resource to allow code reuse
Date:   Thu, 17 Aug 2023 12:01:31 +0530
Message-ID: <20230817063132.21900-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230817063132.21900-1-njavali@marvell.com>
References: <20230817063132.21900-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BNtfo0pxTo-_95bd299Seow8k8Ibyiid
X-Proofpoint-GUID: BNtfo0pxTo-_95bd299Seow8k8Ibyiid
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-15_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

dsd_list contain a list of dsd buffer resource allocated
during traffic time. It resides in the qla_hw_data location
where some of the code is not re-useable.

Move this list to qpair to allow reuse by either single queue
or multi queue adapter / code.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 11 +++++-----
 drivers/scsi/qla2xxx/qla_init.c | 14 +++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 20 +++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   | 36 ++++++++++++++++-----------------
 4 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b5ec15bbce99..9ec39bcd41b5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3825,6 +3825,12 @@ struct qla_qpair {
 
 	uint16_t id;			/* qp number used with FW */
 	uint16_t vp_idx;		/* vport ID */
+
+	uint16_t dsd_inuse;
+	uint16_t dsd_avail;
+	struct list_head dsd_list;
+#define NUM_DSD_CHAIN 4096
+
 	mempool_t *srb_mempool;
 
 	struct pci_dev  *pdev;
@@ -4752,11 +4758,6 @@ struct qla_hw_data {
 	struct fw_blob	*hablob;
 	struct qla82xx_legacy_intr_set nx_legacy_intr;
 
-	uint16_t	gbl_dsd_inuse;
-	uint16_t	gbl_dsd_avail;
-	struct list_head gbl_dsd_list;
-#define NUM_DSD_CHAIN 4096
-
 	uint8_t fw_type;
 	uint32_t file_prd_off;	/* File firmware product offset */
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d4df07aaa0ab..82077edfda1f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9655,6 +9655,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->vp_idx = vp_idx;
 		qpair->fw_started = ha->flags.fw_started;
 		INIT_LIST_HEAD(&qpair->hints_list);
+		INIT_LIST_HEAD(&qpair->dsd_list);
 		qpair->chip_reset = ha->base_qpair->chip_reset;
 		qpair->enable_class_2 = ha->base_qpair->enable_class_2;
 		qpair->enable_explicit_conf =
@@ -9783,6 +9784,19 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	if (ret != QLA_SUCCESS)
 		goto fail;
 
+	if (!list_empty(&qpair->dsd_list)) {
+		struct dsd_dma *dsd_ptr, *tdsd_ptr;
+
+		/* clean up allocated prev pool */
+		list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
+					 &qpair->dsd_list, list) {
+			dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
+				      dsd_ptr->dsd_list_dma);
+			list_del(&dsd_ptr->list);
+			kfree(dsd_ptr);
+		}
+	}
+
 	mutex_lock(&ha->mq_lock);
 	ha->queue_pair_map[qpair->id] = NULL;
 	clear_bit(qpair->id, ha->qpair_qid_map);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5124907a5d8f..5014d0db7242 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -636,14 +636,13 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 		tot_dsds -= avail_dsds;
 		dsd_list_len = (avail_dsds + 1) * QLA_DSD_SIZE;
 
-		dsd_ptr = list_first_entry(&ha->gbl_dsd_list,
-		    struct dsd_dma, list);
+		dsd_ptr = list_first_entry(&qpair->dsd_list, struct dsd_dma, list);
 		next_dsd = dsd_ptr->dsd_addr;
 		list_del(&dsd_ptr->list);
-		ha->gbl_dsd_avail--;
+		qpair->dsd_avail--;
 		list_add_tail(&dsd_ptr->list, &ctx->dsd_list);
 		ctx->dsd_use_cnt++;
-		ha->gbl_dsd_inuse++;
+		qpair->dsd_inuse++;
 
 		if (first_iocb) {
 			first_iocb = 0;
@@ -3367,6 +3366,7 @@ qla82xx_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	struct qla_qpair *qpair = sp->qpair;
 
 	/* Setup device pointers. */
 	reg = &ha->iobase->isp82;
@@ -3415,18 +3415,18 @@ qla82xx_start_scsi(srb_t *sp)
 		uint16_t i;
 
 		more_dsd_lists = qla24xx_calc_dsd_lists(tot_dsds);
-		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN) {
+		if ((more_dsd_lists + qpair->dsd_inuse) >= NUM_DSD_CHAIN) {
 			ql_dbg(ql_dbg_io, vha, 0x300d,
 			    "Num of DSD list %d is than %d for cmd=%p.\n",
-			    more_dsd_lists + ha->gbl_dsd_inuse, NUM_DSD_CHAIN,
+			    more_dsd_lists + qpair->dsd_inuse, NUM_DSD_CHAIN,
 			    cmd);
 			goto queuing_error;
 		}
 
-		if (more_dsd_lists <= ha->gbl_dsd_avail)
+		if (more_dsd_lists <= qpair->dsd_avail)
 			goto sufficient_dsds;
 		else
-			more_dsd_lists -= ha->gbl_dsd_avail;
+			more_dsd_lists -= qpair->dsd_avail;
 
 		for (i = 0; i < more_dsd_lists; i++) {
 			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
@@ -3446,8 +3446,8 @@ qla82xx_start_scsi(srb_t *sp)
 				    "for cmd=%p.\n", cmd);
 				goto queuing_error;
 			}
-			list_add_tail(&dsd_ptr->list, &ha->gbl_dsd_list);
-			ha->gbl_dsd_avail++;
+			list_add_tail(&dsd_ptr->list, &qpair->dsd_list);
+			qpair->dsd_avail++;
 		}
 
 sufficient_dsds:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b9f9d1bb2634..50db08265c51 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -433,6 +433,7 @@ static void qla_init_base_qpair(struct scsi_qla_host *vha, struct req_que *req,
 	ha->base_qpair->msix = &ha->msix_entries[QLA_MSIX_RSP_Q];
 	ha->base_qpair->srb_mempool = ha->srb_mempool;
 	INIT_LIST_HEAD(&ha->base_qpair->hints_list);
+	INIT_LIST_HEAD(&ha->base_qpair->dsd_list);
 	ha->base_qpair->enable_class_2 = ql2xenableclass2;
 	/* init qpair to this cpu. Will adjust at run time. */
 	qla_cpu_update(rsp->qpair, raw_smp_processor_id());
@@ -751,9 +752,9 @@ void qla2x00_sp_free_dma(srb_t *sp)
 
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
 		    ctx1->fcp_cmnd_dma);
-		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
-		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
-		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
+		list_splice(&ctx1->dsd_list, &sp->qpair->dsd_list);
+		sp->qpair->dsd_inuse -= ctx1->dsd_use_cnt;
+		sp->qpair->dsd_avail += ctx1->dsd_use_cnt;
 	}
 
 	if (sp->flags & SRB_GOT_BUF)
@@ -837,9 +838,9 @@ void qla2xxx_qpair_sp_free_dma(srb_t *sp)
 
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
 		    ctx1->fcp_cmnd_dma);
-		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
-		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
-		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
+		list_splice(&ctx1->dsd_list, &sp->qpair->dsd_list);
+		sp->qpair->dsd_inuse -= ctx1->dsd_use_cnt;
+		sp->qpair->dsd_avail += ctx1->dsd_use_cnt;
 		sp->flags &= ~SRB_FCP_CMND_DMA_VALID;
 	}
 
@@ -4407,7 +4408,6 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 			   "sf_init_cb=%p.\n", ha->sf_init_cb);
 	}
 
-	INIT_LIST_HEAD(&ha->gbl_dsd_list);
 
 	/* Get consistent memory allocated for Async Port-Database. */
 	if (!IS_FWI2_CAPABLE(ha)) {
@@ -4953,18 +4953,16 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
 
-	if (IS_QLA82XX(ha)) {
-		if (!list_empty(&ha->gbl_dsd_list)) {
-			struct dsd_dma *dsd_ptr, *tdsd_ptr;
-
-			/* clean up allocated prev pool */
-			list_for_each_entry_safe(dsd_ptr,
-				tdsd_ptr, &ha->gbl_dsd_list, list) {
-				dma_pool_free(ha->dl_dma_pool,
-				dsd_ptr->dsd_addr, dsd_ptr->dsd_list_dma);
-				list_del(&dsd_ptr->list);
-				kfree(dsd_ptr);
-			}
+	if (!list_empty(&ha->base_qpair->dsd_list)) {
+		struct dsd_dma *dsd_ptr, *tdsd_ptr;
+
+		/* clean up allocated prev pool */
+		list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
+					 &ha->base_qpair->dsd_list, list) {
+			dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
+				      dsd_ptr->dsd_list_dma);
+			list_del(&dsd_ptr->list);
+			kfree(dsd_ptr);
 		}
 	}
 
-- 
2.23.1

