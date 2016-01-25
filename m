From: John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH v2 18/23] hisi_sas: add v2 code to send smp command
Date: Tue, 26 Jan 2016 02:47:18 +0800
Message-ID: <1453747643-61875-19-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:49866 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbcAYSfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 13:35:09 -0500
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 71 ++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ab6ea25..2c6a753 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -744,6 +744,76 @@ static int prep_prd_sge_v2_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static int prep_smp_v2_hw(struct hisi_hba *hisi_hba,
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
+			       (2 << CMD_HDR_CMD_OFF)); /* smp */
+
+	/* map itct entry */
+	hdr->dw1 = cpu_to_le32((sas_dev->device_id << CMD_HDR_DEV_ID_OFF) |
+			       (1 << CMD_HDR_FRAME_TYPE_OFF) |
+			       (DIR_NO_DATA << CMD_HDR_DIR_OFF));
+
+	/* dw2 */
+	hdr->dw2 = cpu_to_le32((((req_len - 4) / 4) << CMD_HDR_CFL_OFF) |
+			       (HISI_SAS_MAX_SMP_RESP_SZ / 4 <<
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
+
 static int prep_ssp_v2_hw(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_slot *slot, int is_tmf,
 			  struct hisi_sas_tmf_task *tmf)
@@ -1395,6 +1465,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
-- 
1.9.1

