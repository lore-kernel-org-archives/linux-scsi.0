From: John Garry <john.garry@huawei.com>
Subject: [PATCH 15/23] scsi: hisi_sas: process error codes according to their priority
Date: Thu, 23 Mar 2017 01:25:31 +0800
Message-ID: <1490203539-228029-16-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4375 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760872AbdCVQ6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:43 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

There are some rules to decide which error code has the high
priority  when errors happen together:
(1) Error phase of CQ decides the error happens on RX or TX;
(2) For TX error, when DMA/TRANS TX error happen simultaneously,
the priority of DMA TX error is higher than TRANS TX error, so
for the priority of TX error:
DW2 (DMA TX part) > DW0;
(3) For RX error, when TRANS/DMA/SIPC RX error happen simultaneously,
the priority of TRANS RX error is higher than DMA and SIPC RX error,
and we should also keep the rules (the priority of DW3 > DW2), so for
the priority of RX error:
DW1 > DW3 > DW2(SIPC RX part);
(4) There are also a priority we should keep in the same error type.

So, modify slot error code to handle this.

In addition to this, some some error codes are modified according to
recommendation from SoC designer.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 553 ++++++++++++++++++++++++---------
 1 file changed, 398 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 2b6e64c..66a458b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -313,6 +313,8 @@
 
 /* Completion header */
 /* dw0 */
+#define CMPLT_HDR_ERR_PHASE_OFF	2
+#define CMPLT_HDR_ERR_PHASE_MSK	(0xff << CMPLT_HDR_ERR_PHASE_OFF)
 #define CMPLT_HDR_RSPNS_XFRD_OFF	10
 #define CMPLT_HDR_RSPNS_XFRD_MSK	(0x1 << CMPLT_HDR_RSPNS_XFRD_OFF)
 #define CMPLT_HDR_ERX_OFF		12
@@ -389,10 +391,10 @@ enum {
 
 enum {
 	TRANS_TX_FAIL_BASE = 0x0, /* dw0 */
-	TRANS_RX_FAIL_BASE = 0x100, /* dw1 */
-	DMA_TX_ERR_BASE = 0x200, /* dw2 bit 15-0 */
-	SIPC_RX_ERR_BASE = 0x300, /* dw2 bit 31-16*/
-	DMA_RX_ERR_BASE = 0x400, /* dw3 */
+	TRANS_RX_FAIL_BASE = 0x20, /* dw1 */
+	DMA_TX_ERR_BASE = 0x40, /* dw2 bit 15-0 */
+	SIPC_RX_ERR_BASE = 0x50, /* dw2 bit 31-16*/
+	DMA_RX_ERR_BASE = 0x60, /* dw3 */
 
 	/* trans tx*/
 	TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS = TRANS_TX_FAIL_BASE, /* 0x0 */
@@ -432,97 +434,100 @@ enum {
 	TRANS_TX_ERR_WITH_WAIT_RECV_TIMEOUT, /* 0x1f for sata/stp */
 
 	/* trans rx */
-	TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR = TRANS_RX_FAIL_BASE, /* 0x100 */
-	TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR, /* 0x101 for sata/stp */
-	TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM, /* 0x102 for ssp/smp */
-	/*IO_ERR_WITH_RXFIS_8B10B_CODE_ERR, [> 0x102 <] for sata/stp */
-	TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR, /* 0x103 for sata/stp */
-	TRANS_RX_ERR_WITH_RXFIS_CRC_ERR, /* 0x104 for sata/stp */
-	TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN, /* 0x105 for smp */
-	/*IO_ERR_WITH_RXFIS_TX SYNCP, [> 0x105 <] for sata/stp */
-	TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP, /* 0x106 for sata/stp*/
-	TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN, /* 0x107 */
-	TRANS_RX_ERR_WITH_BREAK_TIMEOUT, /* 0x108 */
-	TRANS_RX_ERR_WITH_BREAK_REQUEST, /* 0x109 */
-	TRANS_RX_ERR_WITH_BREAK_RECEVIED, /* 0x10a */
-	RESERVED1, /* 0x10b */
-	TRANS_RX_ERR_WITH_CLOSE_NORMAL, /* 0x10c */
-	TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE, /* 0x10d */
-	TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT, /* 0x10e */
-	TRANS_RX_ERR_WITH_CLOSE_COMINIT, /* 0x10f */
-	TRANS_RX_ERR_WITH_DATA_LEN0, /* 0x110 for ssp/smp */
-	TRANS_RX_ERR_WITH_BAD_HASH, /* 0x111 for ssp */
-	/*IO_RX_ERR_WITH_FIS_TOO_SHORT, [> 0x111 <] for sata/stp */
-	TRANS_RX_XRDY_WLEN_ZERO_ERR, /* 0x112 for ssp*/
-	/*IO_RX_ERR_WITH_FIS_TOO_LONG, [> 0x112 <] for sata/stp */
-	TRANS_RX_SSP_FRM_LEN_ERR, /* 0x113 for ssp */
-	/*IO_RX_ERR_WITH_SATA_DEVICE_LOST, [> 0x113 <] for sata */
-	RESERVED2, /* 0x114 */
-	RESERVED3, /* 0x115 */
-	RESERVED4, /* 0x116 */
-	RESERVED5, /* 0x117 */
-	TRANS_RX_ERR_WITH_BAD_FRM_TYPE, /* 0x118 */
-	TRANS_RX_SMP_FRM_LEN_ERR, /* 0x119 */
-	TRANS_RX_SMP_RESP_TIMEOUT_ERR, /* 0x11a */
-	RESERVED6, /* 0x11b */
-	RESERVED7, /* 0x11c */
-	RESERVED8, /* 0x11d */
-	RESERVED9, /* 0x11e */
-	TRANS_RX_R_ERR, /* 0x11f */
+	TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR = TRANS_RX_FAIL_BASE, /* 0x20 */
+	TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR, /* 0x21 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM, /* 0x22 for ssp/smp */
+	/*IO_ERR_WITH_RXFIS_8B10B_CODE_ERR, [> 0x22 <] for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR, /* 0x23 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_CRC_ERR, /* 0x24 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN, /* 0x25 for smp */
+	/*IO_ERR_WITH_RXFIS_TX SYNCP, [> 0x25 <] for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP, /* 0x26 for sata/stp*/
+	TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN, /* 0x27 */
+	TRANS_RX_ERR_WITH_BREAK_TIMEOUT, /* 0x28 */
+	TRANS_RX_ERR_WITH_BREAK_REQUEST, /* 0x29 */
+	TRANS_RX_ERR_WITH_BREAK_RECEVIED, /* 0x2a */
+	RESERVED1, /* 0x2b */
+	TRANS_RX_ERR_WITH_CLOSE_NORMAL, /* 0x2c */
+	TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE, /* 0x2d */
+	TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT, /* 0x2e */
+	TRANS_RX_ERR_WITH_CLOSE_COMINIT, /* 0x2f */
+	TRANS_RX_ERR_WITH_DATA_LEN0, /* 0x30 for ssp/smp */
+	TRANS_RX_ERR_WITH_BAD_HASH, /* 0x31 for ssp */
+	/*IO_RX_ERR_WITH_FIS_TOO_SHORT, [> 0x31 <] for sata/stp */
+	TRANS_RX_XRDY_WLEN_ZERO_ERR, /* 0x32 for ssp*/
+	/*IO_RX_ERR_WITH_FIS_TOO_LONG, [> 0x32 <] for sata/stp */
+	TRANS_RX_SSP_FRM_LEN_ERR, /* 0x33 for ssp */
+	/*IO_RX_ERR_WITH_SATA_DEVICE_LOST, [> 0x33 <] for sata */
+	RESERVED2, /* 0x34 */
+	RESERVED3, /* 0x35 */
+	RESERVED4, /* 0x36 */
+	RESERVED5, /* 0x37 */
+	TRANS_RX_ERR_WITH_BAD_FRM_TYPE, /* 0x38 */
+	TRANS_RX_SMP_FRM_LEN_ERR, /* 0x39 */
+	TRANS_RX_SMP_RESP_TIMEOUT_ERR, /* 0x3a */
+	RESERVED6, /* 0x3b */
+	RESERVED7, /* 0x3c */
+	RESERVED8, /* 0x3d */
+	RESERVED9, /* 0x3e */
+	TRANS_RX_R_ERR, /* 0x3f */
 
 	/* dma tx */
-	DMA_TX_DIF_CRC_ERR = DMA_TX_ERR_BASE, /* 0x200 */
-	DMA_TX_DIF_APP_ERR, /* 0x201 */
-	DMA_TX_DIF_RPP_ERR, /* 0x202 */
-	DMA_TX_DATA_SGL_OVERFLOW, /* 0x203 */
-	DMA_TX_DIF_SGL_OVERFLOW, /* 0x204 */
-	DMA_TX_UNEXP_XFER_ERR, /* 0x205 */
-	DMA_TX_UNEXP_RETRANS_ERR, /* 0x206 */
-	DMA_TX_XFER_LEN_OVERFLOW, /* 0x207 */
-	DMA_TX_XFER_OFFSET_ERR, /* 0x208 */
-	DMA_TX_RAM_ECC_ERR, /* 0x209 */
-	DMA_TX_DIF_LEN_ALIGN_ERR, /* 0x20a */
+	DMA_TX_DIF_CRC_ERR = DMA_TX_ERR_BASE, /* 0x40 */
+	DMA_TX_DIF_APP_ERR, /* 0x41 */
+	DMA_TX_DIF_RPP_ERR, /* 0x42 */
+	DMA_TX_DATA_SGL_OVERFLOW, /* 0x43 */
+	DMA_TX_DIF_SGL_OVERFLOW, /* 0x44 */
+	DMA_TX_UNEXP_XFER_ERR, /* 0x45 */
+	DMA_TX_UNEXP_RETRANS_ERR, /* 0x46 */
+	DMA_TX_XFER_LEN_OVERFLOW, /* 0x47 */
+	DMA_TX_XFER_OFFSET_ERR, /* 0x48 */
+	DMA_TX_RAM_ECC_ERR, /* 0x49 */
+	DMA_TX_DIF_LEN_ALIGN_ERR, /* 0x4a */
+	DMA_TX_MAX_ERR_CODE,
 
 	/* sipc rx */
-	SIPC_RX_FIS_STATUS_ERR_BIT_VLD = SIPC_RX_ERR_BASE, /* 0x300 */
-	SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR, /* 0x301 */
-	SIPC_RX_FIS_STATUS_BSY_BIT_ERR, /* 0x302 */
-	SIPC_RX_WRSETUP_LEN_ODD_ERR, /* 0x303 */
-	SIPC_RX_WRSETUP_LEN_ZERO_ERR, /* 0x304 */
-	SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR, /* 0x305 */
-	SIPC_RX_NCQ_WRSETUP_OFFSET_ERR, /* 0x306 */
-	SIPC_RX_NCQ_WRSETUP_AUTO_ACTIVE_ERR, /* 0x307 */
-	SIPC_RX_SATA_UNEXP_FIS_ERR, /* 0x308 */
-	SIPC_RX_WRSETUP_ESTATUS_ERR, /* 0x309 */
-	SIPC_RX_DATA_UNDERFLOW_ERR, /* 0x30a */
+	SIPC_RX_FIS_STATUS_ERR_BIT_VLD = SIPC_RX_ERR_BASE, /* 0x50 */
+	SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR, /* 0x51 */
+	SIPC_RX_FIS_STATUS_BSY_BIT_ERR, /* 0x52 */
+	SIPC_RX_WRSETUP_LEN_ODD_ERR, /* 0x53 */
+	SIPC_RX_WRSETUP_LEN_ZERO_ERR, /* 0x54 */
+	SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR, /* 0x55 */
+	SIPC_RX_NCQ_WRSETUP_OFFSET_ERR, /* 0x56 */
+	SIPC_RX_NCQ_WRSETUP_AUTO_ACTIVE_ERR, /* 0x57 */
+	SIPC_RX_SATA_UNEXP_FIS_ERR, /* 0x58 */
+	SIPC_RX_WRSETUP_ESTATUS_ERR, /* 0x59 */
+	SIPC_RX_DATA_UNDERFLOW_ERR, /* 0x5a */
+	SIPC_RX_MAX_ERR_CODE,
 
 	/* dma rx */
-	DMA_RX_DIF_CRC_ERR = DMA_RX_ERR_BASE, /* 0x400 */
-	DMA_RX_DIF_APP_ERR, /* 0x401 */
-	DMA_RX_DIF_RPP_ERR, /* 0x402 */
-	DMA_RX_DATA_SGL_OVERFLOW, /* 0x403 */
-	DMA_RX_DIF_SGL_OVERFLOW, /* 0x404 */
-	DMA_RX_DATA_LEN_OVERFLOW, /* 0x405 */
-	DMA_RX_DATA_LEN_UNDERFLOW, /* 0x406 */
-	DMA_RX_DATA_OFFSET_ERR, /* 0x407 */
-	RESERVED10, /* 0x408 */
-	DMA_RX_SATA_FRAME_TYPE_ERR, /* 0x409 */
-	DMA_RX_RESP_BUF_OVERFLOW, /* 0x40a */
-	DMA_RX_UNEXP_RETRANS_RESP_ERR, /* 0x40b */
-	DMA_RX_UNEXP_NORM_RESP_ERR, /* 0x40c */
-	DMA_RX_UNEXP_RDFRAME_ERR, /* 0x40d */
-	DMA_RX_PIO_DATA_LEN_ERR, /* 0x40e */
-	DMA_RX_RDSETUP_STATUS_ERR, /* 0x40f */
-	DMA_RX_RDSETUP_STATUS_DRQ_ERR, /* 0x410 */
-	DMA_RX_RDSETUP_STATUS_BSY_ERR, /* 0x411 */
-	DMA_RX_RDSETUP_LEN_ODD_ERR, /* 0x412 */
-	DMA_RX_RDSETUP_LEN_ZERO_ERR, /* 0x413 */
-	DMA_RX_RDSETUP_LEN_OVER_ERR, /* 0x414 */
-	DMA_RX_RDSETUP_OFFSET_ERR, /* 0x415 */
-	DMA_RX_RDSETUP_ACTIVE_ERR, /* 0x416 */
-	DMA_RX_RDSETUP_ESTATUS_ERR, /* 0x417 */
-	DMA_RX_RAM_ECC_ERR, /* 0x418 */
-	DMA_RX_UNKNOWN_FRM_ERR, /* 0x419 */
+	DMA_RX_DIF_CRC_ERR = DMA_RX_ERR_BASE, /* 0x60 */
+	DMA_RX_DIF_APP_ERR, /* 0x61 */
+	DMA_RX_DIF_RPP_ERR, /* 0x62 */
+	DMA_RX_DATA_SGL_OVERFLOW, /* 0x63 */
+	DMA_RX_DIF_SGL_OVERFLOW, /* 0x64 */
+	DMA_RX_DATA_LEN_OVERFLOW, /* 0x65 */
+	DMA_RX_DATA_LEN_UNDERFLOW, /* 0x66 */
+	DMA_RX_DATA_OFFSET_ERR, /* 0x67 */
+	RESERVED10, /* 0x68 */
+	DMA_RX_SATA_FRAME_TYPE_ERR, /* 0x69 */
+	DMA_RX_RESP_BUF_OVERFLOW, /* 0x6a */
+	DMA_RX_UNEXP_RETRANS_RESP_ERR, /* 0x6b */
+	DMA_RX_UNEXP_NORM_RESP_ERR, /* 0x6c */
+	DMA_RX_UNEXP_RDFRAME_ERR, /* 0x6d */
+	DMA_RX_PIO_DATA_LEN_ERR, /* 0x6e */
+	DMA_RX_RDSETUP_STATUS_ERR, /* 0x6f */
+	DMA_RX_RDSETUP_STATUS_DRQ_ERR, /* 0x70 */
+	DMA_RX_RDSETUP_STATUS_BSY_ERR, /* 0x71 */
+	DMA_RX_RDSETUP_LEN_ODD_ERR, /* 0x72 */
+	DMA_RX_RDSETUP_LEN_ZERO_ERR, /* 0x73 */
+	DMA_RX_RDSETUP_LEN_OVER_ERR, /* 0x74 */
+	DMA_RX_RDSETUP_OFFSET_ERR, /* 0x75 */
+	DMA_RX_RDSETUP_ACTIVE_ERR, /* 0x76 */
+	DMA_RX_RDSETUP_ESTATUS_ERR, /* 0x77 */
+	DMA_RX_RAM_ECC_ERR, /* 0x78 */
+	DMA_RX_UNKNOWN_FRM_ERR, /* 0x79 */
+	DMA_RX_MAX_ERR_CODE,
 };
 
 #define HISI_SAS_COMMAND_ENTRIES_V2_HW 4096
@@ -538,6 +543,12 @@ enum {
 #define SATA_PROTOCOL_FPDMA		0x8
 #define SATA_PROTOCOL_ATAPI		0x10
 
+#define ERR_ON_TX_PHASE(err_phase) (err_phase == 0x2 || \
+		err_phase == 0x4 || err_phase == 0x8 ||\
+		err_phase == 0x6 || err_phase == 0xa)
+#define ERR_ON_RX_PHASE(err_phase) (err_phase == 0x10 || \
+		err_phase == 0x20 || err_phase == 0x40)
+
 static void hisi_sas_link_timeout_disable_link(unsigned long data);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
@@ -1451,10 +1462,205 @@ static void sata_done_v2_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	ts->buf_valid_size = sizeof(*resp);
 }
 
+#define TRANS_TX_ERR	0
+#define TRANS_RX_ERR	1
+#define DMA_TX_ERR		2
+#define SIPC_RX_ERR		3
+#define DMA_RX_ERR		4
+
+#define DMA_TX_ERR_OFF	0
+#define DMA_TX_ERR_MSK	(0xffff << DMA_TX_ERR_OFF)
+#define SIPC_RX_ERR_OFF	16
+#define SIPC_RX_ERR_MSK (0xffff << SIPC_RX_ERR_OFF)
+
+static int parse_trans_tx_err_code_v2_hw(u32 err_msk)
+{
+	const u8 trans_tx_err_code_prio[] = {
+		TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS,
+		TRANS_TX_ERR_PHY_NOT_ENABLE,
+		TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION,
+		TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION,
+		TRANS_TX_OPEN_CNX_ERR_BY_OTHER,
+		RESERVED0,
+		TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT,
+		TRANS_TX_OPEN_CNX_ERR_STP_RESOURCES_BUSY,
+		TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED,
+		TRANS_TX_OPEN_CNX_ERR_CONNECTION_RATE_NOT_SUPPORTED,
+		TRANS_TX_OPEN_CNX_ERR_BAD_DESTINATION,
+		TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD,
+		TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER,
+		TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED,
+		TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT,
+		TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION,
+		TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED,
+		TRANS_TX_ERR_WITH_CLOSE_PHYDISALE,
+		TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT,
+		TRANS_TX_ERR_WITH_CLOSE_COMINIT,
+		TRANS_TX_ERR_WITH_BREAK_TIMEOUT,
+		TRANS_TX_ERR_WITH_BREAK_REQUEST,
+		TRANS_TX_ERR_WITH_BREAK_RECEVIED,
+		TRANS_TX_ERR_WITH_CLOSE_TIMEOUT,
+		TRANS_TX_ERR_WITH_CLOSE_NORMAL,
+		TRANS_TX_ERR_WITH_NAK_RECEVIED,
+		TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT,
+		TRANS_TX_ERR_WITH_CREDIT_TIMEOUT,
+		TRANS_TX_ERR_WITH_IPTT_CONFLICT,
+		TRANS_TX_ERR_WITH_OPEN_BY_DES_OR_OTHERS,
+		TRANS_TX_ERR_WITH_WAIT_RECV_TIMEOUT,
+	};
+	int index, i;
+
+	for (i = 0; i < ARRAY_SIZE(trans_tx_err_code_prio); i++) {
+		index = trans_tx_err_code_prio[i] - TRANS_TX_FAIL_BASE;
+		if (err_msk & (1 << index))
+			return trans_tx_err_code_prio[i];
+	}
+	return -1;
+}
+
+static int parse_trans_rx_err_code_v2_hw(u32 err_msk)
+{
+	const u8 trans_rx_err_code_prio[] = {
+		TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR,
+		TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR,
+		TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM,
+		TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR,
+		TRANS_RX_ERR_WITH_RXFIS_CRC_ERR,
+		TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN,
+		TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP,
+		TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN,
+		TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE,
+		TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT,
+		TRANS_RX_ERR_WITH_CLOSE_COMINIT,
+		TRANS_RX_ERR_WITH_BREAK_TIMEOUT,
+		TRANS_RX_ERR_WITH_BREAK_REQUEST,
+		TRANS_RX_ERR_WITH_BREAK_RECEVIED,
+		RESERVED1,
+		TRANS_RX_ERR_WITH_CLOSE_NORMAL,
+		TRANS_RX_ERR_WITH_DATA_LEN0,
+		TRANS_RX_ERR_WITH_BAD_HASH,
+		TRANS_RX_XRDY_WLEN_ZERO_ERR,
+		TRANS_RX_SSP_FRM_LEN_ERR,
+		RESERVED2,
+		RESERVED3,
+		RESERVED4,
+		RESERVED5,
+		TRANS_RX_ERR_WITH_BAD_FRM_TYPE,
+		TRANS_RX_SMP_FRM_LEN_ERR,
+		TRANS_RX_SMP_RESP_TIMEOUT_ERR,
+		RESERVED6,
+		RESERVED7,
+		RESERVED8,
+		RESERVED9,
+		TRANS_RX_R_ERR,
+	};
+	int index, i;
+
+	for (i = 0; i < ARRAY_SIZE(trans_rx_err_code_prio); i++) {
+		index = trans_rx_err_code_prio[i] - TRANS_RX_FAIL_BASE;
+		if (err_msk & (1 << index))
+			return trans_rx_err_code_prio[i];
+	}
+	return -1;
+}
+
+static int parse_dma_tx_err_code_v2_hw(u32 err_msk)
+{
+	const u8 dma_tx_err_code_prio[] = {
+		DMA_TX_UNEXP_XFER_ERR,
+		DMA_TX_UNEXP_RETRANS_ERR,
+		DMA_TX_XFER_LEN_OVERFLOW,
+		DMA_TX_XFER_OFFSET_ERR,
+		DMA_TX_RAM_ECC_ERR,
+		DMA_TX_DIF_LEN_ALIGN_ERR,
+		DMA_TX_DIF_CRC_ERR,
+		DMA_TX_DIF_APP_ERR,
+		DMA_TX_DIF_RPP_ERR,
+		DMA_TX_DATA_SGL_OVERFLOW,
+		DMA_TX_DIF_SGL_OVERFLOW,
+	};
+	int index, i;
+
+	for (i = 0; i < ARRAY_SIZE(dma_tx_err_code_prio); i++) {
+		index = dma_tx_err_code_prio[i] - DMA_TX_ERR_BASE;
+		err_msk = err_msk & DMA_TX_ERR_MSK;
+		if (err_msk & (1 << index))
+			return dma_tx_err_code_prio[i];
+	}
+	return -1;
+}
+
+static int parse_sipc_rx_err_code_v2_hw(u32 err_msk)
+{
+	const u8 sipc_rx_err_code_prio[] = {
+		SIPC_RX_FIS_STATUS_ERR_BIT_VLD,
+		SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR,
+		SIPC_RX_FIS_STATUS_BSY_BIT_ERR,
+		SIPC_RX_WRSETUP_LEN_ODD_ERR,
+		SIPC_RX_WRSETUP_LEN_ZERO_ERR,
+		SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR,
+		SIPC_RX_NCQ_WRSETUP_OFFSET_ERR,
+		SIPC_RX_NCQ_WRSETUP_AUTO_ACTIVE_ERR,
+		SIPC_RX_SATA_UNEXP_FIS_ERR,
+		SIPC_RX_WRSETUP_ESTATUS_ERR,
+		SIPC_RX_DATA_UNDERFLOW_ERR,
+	};
+	int index, i;
+
+	for (i = 0; i < ARRAY_SIZE(sipc_rx_err_code_prio); i++) {
+		index = sipc_rx_err_code_prio[i] - SIPC_RX_ERR_BASE;
+		err_msk = err_msk & SIPC_RX_ERR_MSK;
+		if (err_msk & (1 << (index + 0x10)))
+			return sipc_rx_err_code_prio[i];
+	}
+	return -1;
+}
+
+static int parse_dma_rx_err_code_v2_hw(u32 err_msk)
+{
+	const u8 dma_rx_err_code_prio[] = {
+		DMA_RX_UNKNOWN_FRM_ERR,
+		DMA_RX_DATA_LEN_OVERFLOW,
+		DMA_RX_DATA_LEN_UNDERFLOW,
+		DMA_RX_DATA_OFFSET_ERR,
+		RESERVED10,
+		DMA_RX_SATA_FRAME_TYPE_ERR,
+		DMA_RX_RESP_BUF_OVERFLOW,
+		DMA_RX_UNEXP_RETRANS_RESP_ERR,
+		DMA_RX_UNEXP_NORM_RESP_ERR,
+		DMA_RX_UNEXP_RDFRAME_ERR,
+		DMA_RX_PIO_DATA_LEN_ERR,
+		DMA_RX_RDSETUP_STATUS_ERR,
+		DMA_RX_RDSETUP_STATUS_DRQ_ERR,
+		DMA_RX_RDSETUP_STATUS_BSY_ERR,
+		DMA_RX_RDSETUP_LEN_ODD_ERR,
+		DMA_RX_RDSETUP_LEN_ZERO_ERR,
+		DMA_RX_RDSETUP_LEN_OVER_ERR,
+		DMA_RX_RDSETUP_OFFSET_ERR,
+		DMA_RX_RDSETUP_ACTIVE_ERR,
+		DMA_RX_RDSETUP_ESTATUS_ERR,
+		DMA_RX_RAM_ECC_ERR,
+		DMA_RX_DIF_CRC_ERR,
+		DMA_RX_DIF_APP_ERR,
+		DMA_RX_DIF_RPP_ERR,
+		DMA_RX_DATA_SGL_OVERFLOW,
+		DMA_RX_DIF_SGL_OVERFLOW,
+	};
+	int index, i;
+
+	for (i = 0; i < ARRAY_SIZE(dma_rx_err_code_prio); i++) {
+		index = dma_rx_err_code_prio[i] - DMA_RX_ERR_BASE;
+		if (err_msk & (1 << index))
+			return dma_rx_err_code_prio[i];
+	}
+	return -1;
+}
+
 /* by default, task resp is complete */
 static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			   struct sas_task *task,
-			   struct hisi_sas_slot *slot)
+			   struct hisi_sas_slot *slot,
+			   int err_phase)
 {
 	struct task_status_struct *ts = &task->task_status;
 	struct hisi_sas_err_record_v2 *err_record = slot->status_buffer;
@@ -1465,21 +1671,23 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	u32 dma_rx_err_type = cpu_to_le32(err_record->dma_rx_err_type);
 	int error = -1;
 
-	if (dma_rx_err_type) {
-		error = ffs(dma_rx_err_type)
-			- 1 + DMA_RX_ERR_BASE;
-	} else if (sipc_rx_err_type) {
-		error = ffs(sipc_rx_err_type)
-			- 1 + SIPC_RX_ERR_BASE;
-	}  else if (dma_tx_err_type) {
-		error = ffs(dma_tx_err_type)
-			- 1 + DMA_TX_ERR_BASE;
-	} else if (trans_rx_fail_type) {
-		error = ffs(trans_rx_fail_type)
-			- 1 + TRANS_RX_FAIL_BASE;
-	} else if (trans_tx_fail_type) {
-		error = ffs(trans_tx_fail_type)
-			- 1 + TRANS_TX_FAIL_BASE;
+	if (err_phase == 1) {
+		/* error in TX phase, the priority of error is: DW2 > DW0 */
+		error = parse_dma_tx_err_code_v2_hw(dma_tx_err_type);
+		if (error == -1)
+			error = parse_trans_tx_err_code_v2_hw(
+					trans_tx_fail_type);
+	} else if (err_phase == 2) {
+		/* error in RX phase, the priority is: DW1 > DW3 > DW2 */
+		error = parse_trans_rx_err_code_v2_hw(
+					trans_rx_fail_type);
+		if (error == -1) {
+			error = parse_dma_rx_err_code_v2_hw(
+					dma_rx_err_type);
+			if (error == -1)
+				error = parse_sipc_rx_err_code_v2_hw(
+						sipc_rx_err_type);
+		}
 	}
 
 	switch (task->task_proto) {
@@ -1490,13 +1698,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		{
 			ts->stat = SAS_OPEN_REJECT;
 			ts->open_rej_reason = SAS_OREJ_NO_DEST;
-			break;
-		}
-		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
-		{
-			ts->stat = SAS_OPEN_REJECT;
-			ts->open_rej_reason = SAS_OREJ_PATH_BLOCKED;
-			break;
 		}
 		case TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED:
 		{
@@ -1516,19 +1717,15 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 			break;
 		}
-		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
-		{
-			ts->stat = SAS_OPEN_REJECT;
-			ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
-			break;
-		}
 		case TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION:
 		{
 			ts->stat = SAS_OPEN_REJECT;
 			ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 			break;
 		}
+		case DMA_RX_UNEXP_NORM_RESP_ERR:
 		case TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION:
+		case DMA_RX_RESP_BUF_OVERFLOW:
 		{
 			ts->stat = SAS_OPEN_REJECT;
 			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -1540,16 +1737,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			ts->stat = SAS_DEV_NO_RESPONSE;
 			break;
 		}
-		case TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE:
-		{
-			ts->stat = SAS_PHY_DOWN;
-			break;
-		}
-		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
-		{
-			ts->stat = SAS_OPEN_TO;
-			break;
-		}
 		case DMA_RX_DATA_LEN_OVERFLOW:
 		{
 			ts->stat = SAS_DATA_OVERRUN;
@@ -1557,60 +1744,65 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			break;
 		}
 		case DMA_RX_DATA_LEN_UNDERFLOW:
-		case SIPC_RX_DATA_UNDERFLOW_ERR:
 		{
-			ts->residual = trans_tx_fail_type;
+			ts->residual = dma_rx_err_type;
 			ts->stat = SAS_DATA_UNDERRUN;
 			break;
 		}
-		case TRANS_TX_ERR_FRAME_TXED:
-		{
-			/* This will request a retry */
-			ts->stat = SAS_QUEUE_FULL;
-			slot->abort = 1;
-			break;
-		}
 		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
 		case TRANS_TX_ERR_PHY_NOT_ENABLE:
 		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
 		case TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT:
+		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
+		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
+		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
 		case TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED:
 		case TRANS_TX_ERR_WITH_BREAK_TIMEOUT:
 		case TRANS_TX_ERR_WITH_BREAK_REQUEST:
 		case TRANS_TX_ERR_WITH_BREAK_RECEVIED:
 		case TRANS_TX_ERR_WITH_CLOSE_TIMEOUT:
 		case TRANS_TX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_TX_ERR_WITH_CLOSE_PHYDISALE:
 		case TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT:
 		case TRANS_TX_ERR_WITH_CLOSE_COMINIT:
 		case TRANS_TX_ERR_WITH_NAK_RECEVIED:
 		case TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT:
-		case TRANS_TX_ERR_WITH_IPTT_CONFLICT:
 		case TRANS_TX_ERR_WITH_CREDIT_TIMEOUT:
+		case TRANS_TX_ERR_WITH_IPTT_CONFLICT:
 		case TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR:
 		case TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR:
 		case TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM:
+		case TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN:
 		case TRANS_RX_ERR_WITH_BREAK_TIMEOUT:
 		case TRANS_RX_ERR_WITH_BREAK_REQUEST:
 		case TRANS_RX_ERR_WITH_BREAK_RECEVIED:
 		case TRANS_RX_ERR_WITH_CLOSE_NORMAL:
 		case TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT:
 		case TRANS_RX_ERR_WITH_CLOSE_COMINIT:
+		case TRANS_TX_ERR_FRAME_TXED:
+		case TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE:
 		case TRANS_RX_ERR_WITH_DATA_LEN0:
 		case TRANS_RX_ERR_WITH_BAD_HASH:
 		case TRANS_RX_XRDY_WLEN_ZERO_ERR:
 		case TRANS_RX_SSP_FRM_LEN_ERR:
 		case TRANS_RX_ERR_WITH_BAD_FRM_TYPE:
+		case DMA_TX_DATA_SGL_OVERFLOW:
 		case DMA_TX_UNEXP_XFER_ERR:
 		case DMA_TX_UNEXP_RETRANS_ERR:
 		case DMA_TX_XFER_LEN_OVERFLOW:
 		case DMA_TX_XFER_OFFSET_ERR:
+		case SIPC_RX_DATA_UNDERFLOW_ERR:
+		case DMA_RX_DATA_SGL_OVERFLOW:
 		case DMA_RX_DATA_OFFSET_ERR:
-		case DMA_RX_UNEXP_NORM_RESP_ERR:
-		case DMA_RX_UNEXP_RDFRAME_ERR:
+		case DMA_RX_RDSETUP_LEN_ODD_ERR:
+		case DMA_RX_RDSETUP_LEN_ZERO_ERR:
+		case DMA_RX_RDSETUP_LEN_OVER_ERR:
+		case DMA_RX_SATA_FRAME_TYPE_ERR:
 		case DMA_RX_UNKNOWN_FRM_ERR:
 		{
-			ts->stat = SAS_OPEN_REJECT;
-			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+			/* This will request a retry */
+			ts->stat = SAS_QUEUE_FULL;
+			slot->abort = 1;
 			break;
 		}
 		default:
@@ -1627,57 +1819,92 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 	{
 		switch (error) {
-		case TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER:
-		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
 		case TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION:
 		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_NO_DEST;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER:
+		{
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_DEV_NO_RESPONSE;
 			break;
 		}
 		case TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_EPROTO;
+			break;
+		}
 		case TRANS_TX_OPEN_CNX_ERR_CONNECTION_RATE_NOT_SUPPORTED:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+			break;
+		}
 		case TRANS_TX_OPEN_CNX_ERR_BAD_DESTINATION:
-		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+			break;
+		}
 		case TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION:
-		case TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION:
-		case TRANS_TX_OPEN_CNX_ERR_STP_RESOURCES_BUSY:
 		{
 			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 			break;
 		}
-		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
+		case DMA_RX_RESP_BUF_OVERFLOW:
+		case DMA_RX_UNEXP_NORM_RESP_ERR:
+		case TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION:
 		{
-			ts->stat = SAS_OPEN_TO;
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 			break;
 		}
 		case DMA_RX_DATA_LEN_OVERFLOW:
 		{
 			ts->stat = SAS_DATA_OVERRUN;
+			ts->residual = 0;
+			break;
+		}
+		case DMA_RX_DATA_LEN_UNDERFLOW:
+		{
+			ts->residual = dma_rx_err_type;
+			ts->stat = SAS_DATA_UNDERRUN;
 			break;
 		}
 		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
 		case TRANS_TX_ERR_PHY_NOT_ENABLE:
 		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
 		case TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT:
+		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
+		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
+		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
 		case TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED:
 		case TRANS_TX_ERR_WITH_BREAK_TIMEOUT:
 		case TRANS_TX_ERR_WITH_BREAK_REQUEST:
 		case TRANS_TX_ERR_WITH_BREAK_RECEVIED:
 		case TRANS_TX_ERR_WITH_CLOSE_TIMEOUT:
 		case TRANS_TX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_TX_ERR_WITH_CLOSE_PHYDISALE:
 		case TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT:
 		case TRANS_TX_ERR_WITH_CLOSE_COMINIT:
-		case TRANS_TX_ERR_WITH_NAK_RECEVIED:
 		case TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT:
 		case TRANS_TX_ERR_WITH_CREDIT_TIMEOUT:
+		case TRANS_TX_ERR_WITH_OPEN_BY_DES_OR_OTHERS:
 		case TRANS_TX_ERR_WITH_WAIT_RECV_TIMEOUT:
-		case TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR:
 		case TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM:
+		case TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR:
 		case TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR:
 		case TRANS_RX_ERR_WITH_RXFIS_CRC_ERR:
 		case TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN:
 		case TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP:
+		case TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN:
+		case TRANS_RX_ERR_WITH_BREAK_TIMEOUT:
+		case TRANS_RX_ERR_WITH_BREAK_REQUEST:
+		case TRANS_RX_ERR_WITH_BREAK_RECEVIED:
 		case TRANS_RX_ERR_WITH_CLOSE_NORMAL:
 		case TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE:
 		case TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT:
@@ -1685,7 +1912,12 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		case TRANS_RX_ERR_WITH_DATA_LEN0:
 		case TRANS_RX_ERR_WITH_BAD_HASH:
 		case TRANS_RX_XRDY_WLEN_ZERO_ERR:
-		case TRANS_RX_SSP_FRM_LEN_ERR:
+		case TRANS_RX_ERR_WITH_BAD_FRM_TYPE:
+		case DMA_TX_DATA_SGL_OVERFLOW:
+		case DMA_TX_UNEXP_XFER_ERR:
+		case DMA_TX_UNEXP_RETRANS_ERR:
+		case DMA_TX_XFER_LEN_OVERFLOW:
+		case DMA_TX_XFER_OFFSET_ERR:
 		case SIPC_RX_FIS_STATUS_ERR_BIT_VLD:
 		case SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR:
 		case SIPC_RX_FIS_STATUS_BSY_BIT_ERR:
@@ -1693,6 +1925,8 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		case SIPC_RX_WRSETUP_LEN_ZERO_ERR:
 		case SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR:
 		case SIPC_RX_SATA_UNEXP_FIS_ERR:
+		case DMA_RX_DATA_SGL_OVERFLOW:
+		case DMA_RX_DATA_OFFSET_ERR:
 		case DMA_RX_SATA_FRAME_TYPE_ERR:
 		case DMA_RX_UNEXP_RDFRAME_ERR:
 		case DMA_RX_PIO_DATA_LEN_ERR:
@@ -1706,8 +1940,11 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		case DMA_RX_RDSETUP_ACTIVE_ERR:
 		case DMA_RX_RDSETUP_ESTATUS_ERR:
 		case DMA_RX_UNKNOWN_FRM_ERR:
+		case TRANS_RX_SSP_FRM_LEN_ERR:
+		case TRANS_TX_OPEN_CNX_ERR_STP_RESOURCES_BUSY:
 		{
-			ts->stat = SAS_OPEN_REJECT;
+			slot->abort = 1;
+			ts->stat = SAS_PHY_DOWN;
 			break;
 		}
 		default:
@@ -1794,8 +2031,14 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 
 	if ((complete_hdr->dw0 & CMPLT_HDR_ERX_MSK) &&
 		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
-
-		slot_err_v2_hw(hisi_hba, task, slot);
+		u32 err_phase = (complete_hdr->dw0 & CMPLT_HDR_ERR_PHASE_MSK)
+				>> CMPLT_HDR_ERR_PHASE_OFF;
+
+		/* Analyse error happens on which phase TX or RX */
+		if (ERR_ON_TX_PHASE(err_phase))
+			slot_err_v2_hw(hisi_hba, task, slot, 1);
+		else if (ERR_ON_RX_PHASE(err_phase))
+			slot_err_v2_hw(hisi_hba, task, slot, 2);
 
 		if (unlikely(slot->abort))
 			return ts->stat;
-- 
1.9.1
