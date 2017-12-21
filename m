From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: fix dma_unmap_sg() parameter in some drivers
Date: Thu, 21 Dec 2017 16:15:30 +0800
Message-ID: <1513844130-52564-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750866AbdLUH2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 02:28:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: john.garry@huawei.com, jgarzik@pobox.com, jack_wang@usish.com, =dan.j.williams@intel.com, bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, chenxiang <chenxiang66@hisilicon.com>

For function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatterlist prior to the mapping, not after the mapping.
So fix this usage in ibmvscsi_tgt/isci/mvsas/pm8001.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/ibmvscsi_tgt/libsrp.c | 6 ++++--
 drivers/scsi/isci/request.c        | 2 +-
 drivers/scsi/mvsas/mv_sas.c        | 4 ++--
 drivers/scsi/pm8001/pm8001_sas.c   | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/libsrp.c b/drivers/scsi/ibmvscsi_tgt/libsrp.c
index 5a4cc28..16054c0 100644
--- a/drivers/scsi/ibmvscsi_tgt/libsrp.c
+++ b/drivers/scsi/ibmvscsi_tgt/libsrp.c
@@ -193,7 +193,8 @@ static int srp_direct_data(struct ibmvscsis_cmd *cmd, struct srp_direct_buf *md,
 	err = rdma_io(cmd, sg, nsg, md, 1, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+				DMA_BIDIRECTIONAL);
 
 	return err;
 }
@@ -265,7 +266,8 @@ static int srp_indirect_data(struct ibmvscsis_cmd *cmd, struct srp_cmd *srp_cmd,
 	err = rdma_io(cmd, sg, nsg, md, nmd, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+				DMA_BIDIRECTIONAL);
 
 free_mem:
 	if (token && dma_map) {
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index ed197bc..225d947 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2914,7 +2914,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 					 task->total_xfer_len, task->data_dir);
 		else  /* unmap the sgl dma addresses */
 			dma_unmap_sg(&ihost->pdev->dev, task->scatter,
-				     request->num_sg_entries, task->data_dir);
+				     task->num_scatter, task->data_dir);
 		break;
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index cff43bd..4b2cf36 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -848,7 +848,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -899,7 +899,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 947d601..576a0f0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -466,7 +466,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
-			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
+			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
 				t->data_dir);
 out_done:
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-- 
1.9.1
