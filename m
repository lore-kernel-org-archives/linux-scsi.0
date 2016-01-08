From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/23] hisi_sas: add v2 code to send smp command
Date: Fri, 8 Jan 2016 22:15:37 +0800
Message-ID: <1452262542-64589-19-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 71 ++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e9d3db9..94499b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -743,6 +743,76 @@ static int prep_prd_sge_v2_hw(struct hisi_hba *hisi_hba,
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
@@ -1399,6 +1469,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
