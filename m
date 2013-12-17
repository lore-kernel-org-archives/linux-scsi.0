From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 05/20] qla2xxx: Remove init control block related dead code for ISPFX00.
Date: Mon, 16 Dec 2013 22:28:28 -0500
Message-ID: <1387250923-1041-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45153 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab3LQECJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:02:09 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |   24 ------------------------
 drivers/scsi/qla2xxx/qla_mr.c  |   14 --------------
 drivers/scsi/qla2xxx/qla_os.c  |    1 -
 3 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 02ad5d8..d7184f5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1197,30 +1197,6 @@ typedef struct {
 	uint8_t  reserved_3[26];
 } init_cb_t;
 
-
-struct init_cb_fx {
-	uint16_t	version;
-	uint16_t	reserved_1[13];
-	__le16		request_q_outpointer;
-	__le16		response_q_inpointer;
-	uint16_t	reserved_2[2];
-	__le16		response_q_length;
-	__le16		request_q_length;
-	uint16_t	reserved_3[2];
-	__le32		request_q_address[2];
-	__le32		response_q_address[2];
-	uint16_t	reserved_4[4];
-	uint8_t		response_q_msivec;
-	uint8_t		reserved_5[19];
-	uint16_t	interrupt_delay_timer;
-	uint16_t	reserved_6;
-	uint32_t	fwoptions1;
-	uint32_t	fwoptions2;
-	uint32_t	fwoptions3;
-	uint8_t		reserved_7[24];
-};
-
-
 /*
  * Get Link Status mailbox command return buffer.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 7c7849d..4542247 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -631,20 +631,6 @@ qlafx00_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_fx00 __iomem *reg = &ha->iobase->ispfx00;
-	struct init_cb_fx *icb;
-	struct req_que *req = ha->req_q_map[0];
-	struct rsp_que *rsp = ha->rsp_q_map[0];
-
-	/* Setup ring parameters in initialization control block. */
-	icb = (struct init_cb_fx *)ha->init_cb;
-	icb->request_q_outpointer = __constant_cpu_to_le16(0);
-	icb->response_q_inpointer = __constant_cpu_to_le16(0);
-	icb->request_q_length = cpu_to_le16(req->length);
-	icb->response_q_length = cpu_to_le16(rsp->length);
-	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
-	icb->request_q_address[1] = cpu_to_le32(MSD(req->dma));
-	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
-	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
 	WRT_REG_DWORD(&reg->req_q_in, 0);
 	WRT_REG_DWORD(&reg->req_q_out, 0);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 53edc4b..c698e10 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2489,7 +2489,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->aen_mbx_count = AEN_MAILBOX_REGISTER_COUNT_FX00;
 		req_length = REQUEST_ENTRY_CNT_FX00;
 		rsp_length = RESPONSE_ENTRY_CNT_FX00;
-		ha->init_cb_size = sizeof(struct init_cb_fx);
 		ha->isp_ops = &qlafx00_isp_ops;
 		ha->port_down_retry_count = 30; /* default value */
 		ha->mr.fw_hbt_cnt = QLAFX00_HEARTBEAT_INTERVAL;
-- 
1.7.7

