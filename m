From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 20/25] scsi: hisi_sas: add smp protocol support
Date: Mon, 12 Oct 2015 23:20:32 +0800
Message-ID: <1444663237-238302-21-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add support for smp function, which allows devices
attached by expander to be controlled.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  9 +++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 97 +++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 265d9bd..be2cdf5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -34,6 +34,8 @@
 		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
 
 #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
+#define HISI_SAS_MAX_SMP_RESP_SZ 1028
+
 #define HISI_SAS_NAME_LEN 32
 #define HISI_SAS_RESET_REG_CNT 5
 
@@ -372,6 +374,8 @@ extern int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s);
 extern int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_tei *tei, int is_tmf,
 			  struct hisi_sas_tmf_task *tmf);
+extern int prep_smp_v1_hw(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_tei *tei);
 extern int interrupt_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 36ef8cd..91620b0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -109,6 +109,11 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 	memset(slot, 0, sizeof(*slot));
 }
 
+static int hisi_sas_task_prep_smp(struct hisi_hba *hisi_hba,
+				struct hisi_sas_tei *tei)
+{
+	return prep_smp_v1_hw(hisi_hba, tei);
+}
 
 static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
 				  struct hisi_sas_tei *tei, int is_tmf,
@@ -235,10 +240,12 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	tei.n_elem = n_elem;
 	tei.slot = slot;
 	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		rc = hisi_sas_task_prep_smp(hisi_hba, &tei);
+		break;
 	case SAS_PROTOCOL_SSP:
 		rc = hisi_sas_task_prep_ssp(hisi_hba, &tei, is_tmf, tmf);
 		break;
-	case SAS_PROTOCOL_SMP:
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2ad2ffa..b470c72 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -913,6 +913,80 @@ static int prep_prd_sge_v1_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+int prep_smp_v1_hw(struct hisi_hba *hisi_hba,
+		   struct hisi_sas_tei *tei)
+{
+	struct sas_task *task = tei->task;
+	struct hisi_sas_cmd_hdr *hdr = tei->hdr;
+	struct domain_device *device = task->dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_port *port = tei->port;
+	struct scatterlist *sg_req, *sg_resp;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	dma_addr_t req_dma_addr;
+	unsigned int req_len, resp_len;
+	int elem, rc;
+	struct hisi_sas_slot *slot = tei->slot;
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
+	hdr->transfer_tags = cpu_to_le32(tei->iptt << CMD_HDR_IPTT_OFF);
+
+	hdr->cmd_table_addr_lo = cpu_to_le32(lower_32_bits(req_dma_addr));
+	hdr->cmd_table_addr_hi = cpu_to_le32(upper_32_bits(req_dma_addr));
+
+	hdr->sts_buffer_addr_lo =
+			cpu_to_le32(lower_32_bits(slot->status_buffer_dma));
+	hdr->sts_buffer_addr_hi =
+			cpu_to_le32(upper_32_bits(slot->status_buffer_dma));
+
+	return 0;
+
+err_out_resp:
+	dma_unmap_sg(dev, &tei->task->smp_task.smp_resp, 1,
+		     DMA_FROM_DEVICE);
+err_out_req:
+	dma_unmap_sg(dev, &tei->task->smp_task.smp_req, 1,
+		     DMA_TO_DEVICE);
+	return rc;
+}
 
 int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 		   struct hisi_sas_tei *tei, int is_tmf,
@@ -1132,11 +1206,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 	}
 		break;
 	case SAS_PROTOCOL_SMP:
+		tstat->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 	{
-		dev_err(dev, "slot err: SMP/SATA/STP not supported");
+		dev_err(dev, "slot err: SATA/STP not supported");
 	}
 		break;
 	default:
@@ -1245,8 +1322,24 @@ int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
-		dev_err(dev, "slot complete: SMP not supported");
+	{
+		void *to;
+		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
+
+		tstat->stat = SAM_STAT_GOOD;
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
 		break;
+	}
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
