From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 27/32] scsi: hisi_sas: add smp protocol support
Date: Mon, 16 Nov 2015 21:06:13 +0800
Message-ID: <1447679178-220222-28-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Add support for smp function, which allows devices
attached by expander to be controlled

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  9 ++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 88 ++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e5ee3c9..f34f73b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -36,6 +36,7 @@
 		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
 
 #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
+#define HISI_SAS_MAX_SMP_RESP_SZ 1028
 
 #define HISI_SAS_NAME_LEN 32
 
@@ -132,6 +133,8 @@ struct hisi_sas_hw {
 	int (*prep_ssp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot, int is_tmf,
 			struct hisi_sas_tmf_task *tmf);
+	int (*prep_smp)(struct hisi_hba *hisi_hba,
+			struct hisi_sas_slot *slot);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot, int abort);
 	void (*free_device)(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1797851..406ffa0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -98,6 +98,12 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
 
+static int hisi_sas_task_prep_smp(struct hisi_hba *hisi_hba,
+				  struct hisi_sas_slot *slot)
+{
+	return hisi_hba->hw->prep_smp(hisi_hba, slot);
+}
+
 static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
 				  struct hisi_sas_slot *slot, int is_tmf,
 				  struct hisi_sas_tmf_task *tmf)
@@ -215,6 +221,9 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
 
 	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		rc = hisi_sas_task_prep_smp(hisi_hba, slot);
+		break;
 	case SAS_PROTOCOL_SSP:
 		rc = hisi_sas_task_prep_ssp(hisi_hba, slot, is_tmf, tmf);
 		break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index ad50aed..64b17a1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -903,6 +903,74 @@ static int prep_prd_sge_v1_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static int prep_smp_v1_hw(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_slot *slot)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
+	struct domain_device *device = task->dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_port *port = slot->port;
+	struct scatterlist *sg_req, *sg_resp;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	dma_addr_t req_dma_addr;
+	unsigned int req_len, resp_len;
+	int elem, rc;
+
+	/*
+	* DMA-map SMP request, response buffers
+	*/
+	/* req */
+	sg_req = &task->smp_task.smp_req;
+	elem = dma_map_sg(dev, sg_req, 1, DMA_TO_DEVICE);
+	if (!elem)
+		return -ENOMEM;
+	req_len = sg_dma_len(sg_req);
+	req_dma_addr = sg_dma_address(sg_req);
+
+	/* resp */
+	sg_resp = &task->smp_task.smp_resp;
+	elem = dma_map_sg(dev, sg_resp, 1, DMA_FROM_DEVICE);
+	if (!elem) {
+		rc = -ENOMEM;
+		goto err_out_req;
+	}
+	resp_len = sg_dma_len(sg_resp);
+	if ((req_len & 0x3) || (resp_len & 0x3)) {
+		rc = -EINVAL;
+		goto err_out_resp;
+	}
+
+	/* create header */
+	/* dw0 */
+	hdr->dw0 = cpu_to_le32((port->id << CMD_HDR_PORT_OFF) |
+			       (1 << CMD_HDR_PRIORITY_OFF) | /* high pri */
+			       (1 << CMD_HDR_MODE_OFF) | /* ini mode */
+			       (2 << CMD_HDR_CMD_OFF)); /* smp */
+
+	/* map itct entry */
+	hdr->dw1 = cpu_to_le32(sas_dev->device_id << CMD_HDR_DEVICE_ID_OFF);
+
+	/* dw2 */
+	hdr->dw2 = cpu_to_le32((((req_len-4)/4) << CMD_HDR_CFL_OFF) |
+			       (HISI_SAS_MAX_SMP_RESP_SZ/4 <<
+			       CMD_HDR_MRFL_OFF));
+
+	hdr->transfer_tags = cpu_to_le32(slot->idx << CMD_HDR_IPTT_OFF);
+
+	hdr->cmd_table_addr = cpu_to_le64(req_dma_addr);
+	hdr->sts_buffer_addr = cpu_to_le64(slot->status_buffer_dma);
+
+	return 0;
+
+err_out_resp:
+	dma_unmap_sg(dev, &slot->task->smp_task.smp_resp, 1,
+		     DMA_FROM_DEVICE);
+err_out_req:
+	dma_unmap_sg(dev, &slot->task->smp_task.smp_req, 1,
+		     DMA_TO_DEVICE);
+	return rc;
+}
 
 static int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_slot *slot, int is_tmf,
@@ -1223,6 +1291,25 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		sas_ssp_task_response(dev, task, iu);
 		break;
 	}
+	case SAS_PROTOCOL_SMP:
+	{
+		void *to;
+		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
+
+		ts->stat = SAM_STAT_GOOD;
+		to = kmap_atomic(sg_page(sg_resp));
+
+		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
+			     DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
+			     DMA_TO_DEVICE);
+		memcpy(to + sg_resp->offset,
+		       slot->status_buffer +
+		       sizeof(struct hisi_sas_err_record),
+		       sg_dma_len(sg_resp));
+		kunmap_atomic(to);
+		break;
+	}
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
@@ -1595,6 +1682,7 @@ static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.setup_itct = setup_itct_v1_hw,
 	.sl_notify = sl_notify_v1_hw,
 	.free_device = free_device_v1_hw,
+	.prep_smp = prep_smp_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
 	.get_free_slot = get_free_slot_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
-- 
1.9.1
