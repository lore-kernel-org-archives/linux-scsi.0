From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 16/23] scsi: hisi_sas: add v3 code to send SMP frame
Date: Fri, 9 Jun 2017 22:16:29 +0800
Message-ID: <1497017796-105067-17-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:7796 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdFINtv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 09:49:51 -0400
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Add code to prepare SMP frame.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 74 ++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c869aca..515f50c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -186,6 +186,9 @@
 #define CMD_HDR_MRFL_MSK		(0x1ff << CMD_HDR_MRFL_OFF)
 #define CMD_HDR_SG_MOD_OFF		24
 #define CMD_HDR_SG_MOD_MSK		(0x3 << CMD_HDR_SG_MOD_OFF)
+/* dw3 */
+#define CMD_HDR_IPTT_OFF		0
+#define CMD_HDR_IPTT_MSK		(0xffff << CMD_HDR_IPTT_OFF)
 /* dw6 */
 #define CMD_HDR_DIF_SGL_LEN_OFF		0
 #define CMD_HDR_DIF_SGL_LEN_MSK		(0xffff << CMD_HDR_DIF_SGL_LEN_OFF)
@@ -652,6 +655,76 @@ static int prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static int prep_smp_v3_hw(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_slot *slot)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
+	struct domain_device *device = task->dev;
+	struct device *dev = hisi_hba->dev;
+	struct hisi_sas_port *port = slot->port;
+	struct scatterlist *sg_req, *sg_resp;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	dma_addr_t req_dma_addr;
+	unsigned int req_len, resp_len;
+	int elem, rc;
+
+	/*
+	 * DMA-map SMP request, response buffers
+	 */
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
 static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -1225,6 +1298,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.sl_notify = sl_notify_v3_hw,
 	.prep_ssp = prep_ssp_v3_hw,
+	.prep_smp = prep_smp_v3_hw,
 	.get_free_slot = get_free_slot_v3_hw,
 	.start_delivery = start_delivery_v3_hw,
 	.slot_complete = slot_complete_v3_hw,
-- 
1.9.1
