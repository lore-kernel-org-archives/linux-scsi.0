From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 4/9] lpfc: Add support for using block multi-queue
Date: Fri, 22 May 2015 10:42:38 -0400
Message-ID: <555f405e.2o5/YwCIJ/19LVTb%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:33202 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbbEVOmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:49 -0400
Received: by qgfa63 with SMTP id a63so9116441qgf.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:49 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id n64sm1413241qkh.31.2015.05.22.07.42.47
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for using block multi-queue

With blk-mq support in the mid-layer, lpfc can do IO steering based
on the information in the request tag.  This patch allows lpfc to use
blk-mq if enabled. If not enabled, we fall back into the emulex-internal
affinity mappings.

This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
scsi_mod.use_blk_mq=Y as a parameter to the kernel.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  4 ++-
 drivers/scsi/lpfc/lpfc_scsi.c | 43 +++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.h |  3 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 74 ++++++++++++++-----------------------------
 4 files changed, 72 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 14424e6..f962118 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3303,6 +3303,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
+	shost->nr_hw_queues = phba->cfg_fcp_io_channel;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		shost->dma_boundary =
 			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
@@ -8980,7 +8981,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->cfg_fcp_io_channel = vectors;
 	}
 
-	lpfc_sli4_set_affinity(phba, vectors);
+	if (!shost_use_blk_mq(lpfc_shost_from_vport(phba->pport)))
+		lpfc_sli4_set_affinity(phba, vectors);
 	return rc;
 
 cfg_fail_out:
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 116df9c..4a2a818 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3846,6 +3846,49 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
+ * lpfc_sli4_scmd_to_wqidx_distr - scsi command to SLI4 WQ index distribution
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine performs a roundrobin SCSI command to SLI4 FCP WQ index
+ * distribution.  This is called by __lpfc_sli_issue_iocb_s4() with the hbalock
+ * held.
+ * If scsi-mq is enabled, get the default block layer mapping of software queues
+ * to hardware queues. This information is saved in request tag.
+ *
+ * Return: index into SLI4 fast-path FCP queue index.
+ **/
+int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
+				  struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
+	struct lpfc_vector_map_info *cpup;
+	int chann, cpu;
+	uint32_t tag;
+	uint16_t hwq;
+
+	if (shost_use_blk_mq(cmnd->device->host)) {
+		tag = blk_mq_unique_tag(cmnd->request);
+		hwq = blk_mq_unique_tag_to_hwq(tag);
+
+		return hwq;
+	}
+
+	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
+	    && phba->cfg_fcp_io_channel > 1) {
+		cpu = smp_processor_id();
+		if (cpu < phba->sli4_hba.num_present_cpu) {
+			cpup = phba->sli4_hba.cpu_map;
+			cpup += cpu;
+			return cpup->channel_id;
+		}
+	}
+	chann = atomic_add_return(1, &phba->fcp_qidx);
+	chann = (chann % phba->cfg_fcp_io_channel);
+	return chann;
+}
+
+
+/**
  * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
  * @phba: The Hba for which this call is being executed.
  * @pIocbIn: The command IOCBQ for the scsi cmnd.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 474e30c..18b9260 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -184,3 +184,6 @@ struct lpfc_scsi_buf {
 #define FIND_FIRST_OAS_LUN		 0
 #define NO_MORE_OAS_LUN			-1
 #define NOT_OAS_ENABLED_LUN		NO_MORE_OAS_LUN
+
+int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
+				  struct lpfc_scsi_buf *lpfc_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 41d3370..07df296 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8138,36 +8138,6 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
 }
 
 /**
- * lpfc_sli4_scmd_to_wqidx_distr - scsi command to SLI4 WQ index distribution
- * @phba: Pointer to HBA context object.
- *
- * This routine performs a roundrobin SCSI command to SLI4 FCP WQ index
- * distribution.  This is called by __lpfc_sli_issue_iocb_s4() with the hbalock
- * held.
- *
- * Return: index into SLI4 fast-path FCP queue index.
- **/
-static inline int
-lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba)
-{
-	struct lpfc_vector_map_info *cpup;
-	int chann, cpu;
-
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
-	    && phba->cfg_fcp_io_channel > 1) {
-		cpu = smp_processor_id();
-		if (cpu < phba->sli4_hba.num_present_cpu) {
-			cpup = phba->sli4_hba.cpu_map;
-			cpup += cpu;
-			return cpup->channel_id;
-		}
-	}
-	chann = atomic_add_return(1, &phba->fcp_qidx);
-	chann = (chann % phba->cfg_fcp_io_channel);
-	return chann;
-}
-
-/**
  * lpfc_sli_iocb2wqe - Convert the IOCB to a work queue entry.
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to command iocb.
@@ -8807,27 +8777,29 @@ int
 lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb)
 {
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
-			if (!(phba->cfg_fof) ||
-			    (!(piocb->iocb_flag & LPFC_IO_FOF))) {
-				if (unlikely(!phba->sli4_hba.fcp_wq))
-					return LPFC_HBA_ERROR;
-				/*
-				 * for abort iocb fcp_wqidx should already
-				 * be setup based on what work queue we used.
-				 */
-				if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
-					piocb->fcp_wqidx =
-					    lpfc_sli4_scmd_to_wqidx_distr(phba);
-				ring_number = MAX_SLI3_CONFIGURED_RINGS +
-						piocb->fcp_wqidx;
-			} else {
-				if (unlikely(!phba->sli4_hba.oas_wq))
-					return LPFC_HBA_ERROR;
-				piocb->fcp_wqidx = 0;
-				ring_number =  LPFC_FCP_OAS_RING;
-			}
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return ring_number;
+
+	if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
+		if (!(phba->cfg_fof) ||
+				(!(piocb->iocb_flag & LPFC_IO_FOF))) {
+			if (unlikely(!phba->sli4_hba.fcp_wq))
+				return LPFC_HBA_ERROR;
+			/*
+			 * for abort iocb fcp_wqidx should already
+			 * be setup based on what work queue we used.
+			 */
+			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
+				piocb->fcp_wqidx =
+					lpfc_sli4_scmd_to_wqidx_distr(phba,
+							      piocb->context1);
+			ring_number = MAX_SLI3_CONFIGURED_RINGS +
+				piocb->fcp_wqidx;
+		} else {
+			if (unlikely(!phba->sli4_hba.oas_wq))
+				return LPFC_HBA_ERROR;
+			piocb->fcp_wqidx = 0;
+			ring_number =  LPFC_FCP_OAS_RING;
 		}
 	}
 	return ring_number;
-- 
1.7.11.7

