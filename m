From: John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH v2 21/23] hisi_sas: add v2 slot error handler
Date: Tue, 26 Jan 2016 02:47:21 +0800
Message-ID: <1453747643-61875-22-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 421 +++++++++++++++++++++++++++++++++
 1 file changed, 421 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cea0b36..481aff9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -256,12 +256,165 @@ struct hisi_sas_complete_v2_hdr {
 	__le32 dw3;
 };
 
+struct hisi_sas_err_record_v2 {
+	/* dw0 */
+	__le32 trans_tx_fail_type;
+
+	/* dw1 */
+	__le32 trans_rx_fail_type;
+
+	/* dw2 */
+	__le16 dma_tx_err_type;
+	__le16 sipc_rx_err_type;
+
+	/* dw3 */
+	__le32 dma_rx_err_type;
+};
+
 enum {
 	HISI_SAS_PHY_PHY_UPDOWN,
 	HISI_SAS_PHY_CHNL_INT,
 	HISI_SAS_PHY_INT_NR
 };
 
+enum {
+	TRANS_TX_FAIL_BASE = 0x0, /* dw0 */
+	TRANS_RX_FAIL_BASE = 0x100, /* dw1 */
+	DMA_TX_ERR_BASE = 0x200, /* dw2 bit 15-0 */
+	SIPC_RX_ERR_BASE = 0x300, /* dw2 bit 31-16*/
+	DMA_RX_ERR_BASE = 0x400, /* dw3 */
+
+	/* trans tx*/
+	TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS = TRANS_TX_FAIL_BASE, /* 0x0 */
+	TRANS_TX_ERR_PHY_NOT_ENABLE, /* 0x1 */
+	TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION, /* 0x2 */
+	TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION, /* 0x3 */
+	TRANS_TX_OPEN_CNX_ERR_BY_OTHER, /* 0x4 */
+	RESERVED0, /* 0x5 */
+	TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT, /* 0x6 */
+	TRANS_TX_OPEN_CNX_ERR_STP_RESOURCES_BUSY, /* 0x7 */
+	TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED, /* 0x8 */
+	TRANS_TX_OPEN_CNX_ERR_CONNECTION_RATE_NOT_SUPPORTED, /* 0x9 */
+	TRANS_TX_OPEN_CNX_ERR_BAD_DESTINATION, /* 0xa */
+	TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD, /* 0xb */
+	TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER, /* 0xc */
+	TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED, /* 0xd */
+	TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT, /* 0xe */
+	TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION, /* 0xf */
+	TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED, /* 0x10 */
+	TRANS_TX_ERR_FRAME_TXED, /* 0x11 */
+	TRANS_TX_ERR_WITH_BREAK_TIMEOUT, /* 0x12 */
+	TRANS_TX_ERR_WITH_BREAK_REQUEST, /* 0x13 */
+	TRANS_TX_ERR_WITH_BREAK_RECEVIED, /* 0x14 */
+	TRANS_TX_ERR_WITH_CLOSE_TIMEOUT, /* 0x15 */
+	TRANS_TX_ERR_WITH_CLOSE_NORMAL, /* 0x16 for ssp*/
+	TRANS_TX_ERR_WITH_CLOSE_PHYDISALE, /* 0x17 */
+	TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT, /* 0x18 */
+	TRANS_TX_ERR_WITH_CLOSE_COMINIT, /* 0x19 */
+	TRANS_TX_ERR_WITH_NAK_RECEVIED, /* 0x1a for ssp*/
+	TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT, /* 0x1b for ssp*/
+	/*IO_TX_ERR_WITH_R_ERR_RECEVIED, [> 0x1b for sata/stp<] */
+	TRANS_TX_ERR_WITH_CREDIT_TIMEOUT, /* 0x1c for ssp */
+	/*IO_RX_ERR_WITH_SATA_DEVICE_LOST 0x1c for sata/stp */
+	TRANS_TX_ERR_WITH_IPTT_CONFLICT, /* 0x1d for ssp/smp */
+	TRANS_TX_ERR_WITH_OPEN_BY_DES_OR_OTHERS, /* 0x1e */
+	/*IO_TX_ERR_WITH_SYNC_RXD, [> 0x1e <] for sata/stp */
+	TRANS_TX_ERR_WITH_WAIT_RECV_TIMEOUT, /* 0x1f for sata/stp */
+
+	/* trans rx */
+	TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR = TRANS_RX_FAIL_BASE, /* 0x100 */
+	TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR, /* 0x101 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM, /* 0x102 for ssp/smp */
+	/*IO_ERR_WITH_RXFIS_8B10B_CODE_ERR, [> 0x102 <] for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR, /* 0x103 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_CRC_ERR, /* 0x104 for sata/stp */
+	TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN, /* 0x105 for smp */
+	/*IO_ERR_WITH_RXFIS_TX SYNCP, [> 0x105 <] for sata/stp */
+	TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP, /* 0x106 for sata/stp*/
+	TRANS_RX_ERR_WITH_LINK_BUF_OVERRUN, /* 0x107 */
+	TRANS_RX_ERR_WITH_BREAK_TIMEOUT, /* 0x108 */
+	TRANS_RX_ERR_WITH_BREAK_REQUEST, /* 0x109 */
+	TRANS_RX_ERR_WITH_BREAK_RECEVIED, /* 0x10a */
+	RESERVED1, /* 0x10b */
+	TRANS_RX_ERR_WITH_CLOSE_NORMAL, /* 0x10c */
+	TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE, /* 0x10d */
+	TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT, /* 0x10e */
+	TRANS_RX_ERR_WITH_CLOSE_COMINIT, /* 0x10f */
+	TRANS_RX_ERR_WITH_DATA_LEN0, /* 0x110 for ssp/smp */
+	TRANS_RX_ERR_WITH_BAD_HASH, /* 0x111 for ssp */
+	/*IO_RX_ERR_WITH_FIS_TOO_SHORT, [> 0x111 <] for sata/stp */
+	TRANS_RX_XRDY_WLEN_ZERO_ERR, /* 0x112 for ssp*/
+	/*IO_RX_ERR_WITH_FIS_TOO_LONG, [> 0x112 <] for sata/stp */
+	TRANS_RX_SSP_FRM_LEN_ERR, /* 0x113 for ssp */
+	/*IO_RX_ERR_WITH_SATA_DEVICE_LOST, [> 0x113 <] for sata */
+	RESERVED2, /* 0x114 */
+	RESERVED3, /* 0x115 */
+	RESERVED4, /* 0x116 */
+	RESERVED5, /* 0x117 */
+	TRANS_RX_ERR_WITH_BAD_FRM_TYPE, /* 0x118 */
+	TRANS_RX_SMP_FRM_LEN_ERR, /* 0x119 */
+	TRANS_RX_SMP_RESP_TIMEOUT_ERR, /* 0x11a */
+	RESERVED6, /* 0x11b */
+	RESERVED7, /* 0x11c */
+	RESERVED8, /* 0x11d */
+	RESERVED9, /* 0x11e */
+	TRANS_RX_R_ERR, /* 0x11f */
+
+	/* dma tx */
+	DMA_TX_DIF_CRC_ERR = DMA_TX_ERR_BASE, /* 0x200 */
+	DMA_TX_DIF_APP_ERR, /* 0x201 */
+	DMA_TX_DIF_RPP_ERR, /* 0x202 */
+	DMA_TX_DATA_SGL_OVERFLOW, /* 0x203 */
+	DMA_TX_DIF_SGL_OVERFLOW, /* 0x204 */
+	DMA_TX_UNEXP_XFER_ERR, /* 0x205 */
+	DMA_TX_UNEXP_RETRANS_ERR, /* 0x206 */
+	DMA_TX_XFER_LEN_OVERFLOW, /* 0x207 */
+	DMA_TX_XFER_OFFSET_ERR, /* 0x208 */
+	DMA_TX_RAM_ECC_ERR, /* 0x209 */
+	DMA_TX_DIF_LEN_ALIGN_ERR, /* 0x20a */
+
+	/* sipc rx */
+	SIPC_RX_FIS_STATUS_ERR_BIT_VLD = SIPC_RX_ERR_BASE, /* 0x300 */
+	SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR, /* 0x301 */
+	SIPC_RX_FIS_STATUS_BSY_BIT_ERR, /* 0x302 */
+	SIPC_RX_WRSETUP_LEN_ODD_ERR, /* 0x303 */
+	SIPC_RX_WRSETUP_LEN_ZERO_ERR, /* 0x304 */
+	SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR, /* 0x305 */
+	SIPC_RX_NCQ_WRSETUP_OFFSET_ERR, /* 0x306 */
+	SIPC_RX_NCQ_WRSETUP_AUTO_ACTIVE_ERR, /* 0x307 */
+	SIPC_RX_SATA_UNEXP_FIS_ERR, /* 0x308 */
+	SIPC_RX_WRSETUP_ESTATUS_ERR, /* 0x309 */
+	SIPC_RX_DATA_UNDERFLOW_ERR, /* 0x30a */
+
+	/* dma rx */
+	DMA_RX_DIF_CRC_ERR = DMA_RX_ERR_BASE, /* 0x400 */
+	DMA_RX_DIF_APP_ERR, /* 0x401 */
+	DMA_RX_DIF_RPP_ERR, /* 0x402 */
+	DMA_RX_DATA_SGL_OVERFLOW, /* 0x403 */
+	DMA_RX_DIF_SGL_OVERFLOW, /* 0x404 */
+	DMA_RX_DATA_LEN_OVERFLOW, /* 0x405 */
+	DMA_RX_DATA_LEN_UNDERFLOW, /* 0x406 */
+	DMA_RX_DATA_OFFSET_ERR, /* 0x407 */
+	RESERVED10, /* 0x408 */
+	DMA_RX_SATA_FRAME_TYPE_ERR, /* 0x409 */
+	DMA_RX_RESP_BUF_OVERFLOW, /* 0x40a */
+	DMA_RX_UNEXP_RETRANS_RESP_ERR, /* 0x40b */
+	DMA_RX_UNEXP_NORM_RESP_ERR, /* 0x40c */
+	DMA_RX_UNEXP_RDFRAME_ERR, /* 0x40d */
+	DMA_RX_PIO_DATA_LEN_ERR, /* 0x40e */
+	DMA_RX_RDSETUP_STATUS_ERR, /* 0x40f */
+	DMA_RX_RDSETUP_STATUS_DRQ_ERR, /* 0x410 */
+	DMA_RX_RDSETUP_STATUS_BSY_ERR, /* 0x411 */
+	DMA_RX_RDSETUP_LEN_ODD_ERR, /* 0x412 */
+	DMA_RX_RDSETUP_LEN_ZERO_ERR, /* 0x413 */
+	DMA_RX_RDSETUP_LEN_OVER_ERR, /* 0x414 */
+	DMA_RX_RDSETUP_OFFSET_ERR, /* 0x415 */
+	DMA_RX_RDSETUP_ACTIVE_ERR, /* 0x416 */
+	DMA_RX_RDSETUP_ESTATUS_ERR, /* 0x417 */
+	DMA_RX_RAM_ECC_ERR, /* 0x418 */
+	DMA_RX_UNKNOWN_FRM_ERR, /* 0x419 */
+};
+
 #define HISI_SAS_COMMAND_ENTRIES_V2_HW 4096
 
 #define DIR_NO_DATA 0
@@ -1013,6 +1166,273 @@ static void sata_done_v2_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 
 	ts->buf_valid_size = sizeof(*resp);
 }
+
+/* by default, task resp is complete */
+static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
+			   struct sas_task *task,
+			   struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct hisi_sas_err_record_v2 *err_record = slot->status_buffer;
+	u32 trans_tx_fail_type = cpu_to_le32(err_record->trans_tx_fail_type);
+	u32 trans_rx_fail_type = cpu_to_le32(err_record->trans_rx_fail_type);
+	u16 dma_tx_err_type = cpu_to_le16(err_record->dma_tx_err_type);
+	u16 sipc_rx_err_type = cpu_to_le16(err_record->sipc_rx_err_type);
+	u32 dma_rx_err_type = cpu_to_le32(err_record->dma_rx_err_type);
+	int error = -1;
+
+	if (dma_rx_err_type) {
+		error = ffs(dma_rx_err_type)
+			- 1 + DMA_RX_ERR_BASE;
+	} else if (sipc_rx_err_type) {
+		error = ffs(sipc_rx_err_type)
+			- 1 + SIPC_RX_ERR_BASE;
+	}  else if (dma_tx_err_type) {
+		error = ffs(dma_tx_err_type)
+			- 1 + DMA_TX_ERR_BASE;
+	} else if (trans_rx_fail_type) {
+		error = ffs(trans_rx_fail_type)
+			- 1 + TRANS_RX_FAIL_BASE;
+	} else if (trans_tx_fail_type) {
+		error = ffs(trans_tx_fail_type)
+			- 1 + TRANS_TX_FAIL_BASE;
+	}
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		switch (error) {
+		case TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_NO_DEST;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_PATH_BLOCKED;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_EPROTO;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_CONNECTION_RATE_NOT_SUPPORTED:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_BAD_DESTINATION:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_BAD_DEST;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER:
+		{
+			/* not sure */
+			ts->stat = SAS_DEV_NO_RESPONSE;
+			break;
+		}
+		case TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE:
+		{
+			ts->stat = SAS_PHY_DOWN;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
+		{
+			ts->stat = SAS_OPEN_TO;
+			break;
+		}
+		case DMA_RX_DATA_LEN_OVERFLOW:
+		{
+			ts->stat = SAS_DATA_OVERRUN;
+			ts->residual = 0;
+			break;
+		}
+		case DMA_RX_DATA_LEN_UNDERFLOW:
+		case SIPC_RX_DATA_UNDERFLOW_ERR:
+		{
+			ts->residual = trans_tx_fail_type;
+			ts->stat = SAS_DATA_UNDERRUN;
+			break;
+		}
+		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
+		case TRANS_TX_ERR_PHY_NOT_ENABLE:
+		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
+		case TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT:
+		case TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED:
+		case TRANS_TX_ERR_WITH_BREAK_TIMEOUT:
+		case TRANS_TX_ERR_WITH_BREAK_REQUEST:
+		case TRANS_TX_ERR_WITH_BREAK_RECEVIED:
+		case TRANS_TX_ERR_WITH_CLOSE_TIMEOUT:
+		case TRANS_TX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT:
+		case TRANS_TX_ERR_WITH_CLOSE_COMINIT:
+		case TRANS_TX_ERR_WITH_NAK_RECEVIED:
+		case TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT:
+		case TRANS_TX_ERR_WITH_IPTT_CONFLICT:
+		case TRANS_TX_ERR_WITH_CREDIT_TIMEOUT:
+		case TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR:
+		case TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR:
+		case TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM:
+		case TRANS_RX_ERR_WITH_BREAK_TIMEOUT:
+		case TRANS_RX_ERR_WITH_BREAK_REQUEST:
+		case TRANS_RX_ERR_WITH_BREAK_RECEVIED:
+		case TRANS_RX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT:
+		case TRANS_RX_ERR_WITH_CLOSE_COMINIT:
+		case TRANS_RX_ERR_WITH_DATA_LEN0:
+		case TRANS_RX_ERR_WITH_BAD_HASH:
+		case TRANS_RX_XRDY_WLEN_ZERO_ERR:
+		case TRANS_RX_SSP_FRM_LEN_ERR:
+		case TRANS_RX_ERR_WITH_BAD_FRM_TYPE:
+		case DMA_TX_UNEXP_XFER_ERR:
+		case DMA_TX_UNEXP_RETRANS_ERR:
+		case DMA_TX_XFER_LEN_OVERFLOW:
+		case DMA_TX_XFER_OFFSET_ERR:
+		case DMA_RX_DATA_OFFSET_ERR:
+		case DMA_RX_UNEXP_NORM_RESP_ERR:
+		case DMA_RX_UNEXP_RDFRAME_ERR:
+		case DMA_RX_UNKNOWN_FRM_ERR:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+			break;
+		}
+		default:
+			break;
+		}
+	}
+		break;
+	case SAS_PROTOCOL_SMP:
+		ts->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		switch (error) {
+		case TRANS_TX_OPEN_CNX_ERR_LOW_PHY_POWER:
+		case TRANS_TX_OPEN_CNX_ERR_PATHWAY_BLOCKED:
+		case TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION:
+		{
+			ts->resp = SAS_TASK_UNDELIVERED;
+			ts->stat = SAS_DEV_NO_RESPONSE;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED:
+		case TRANS_TX_OPEN_CNX_ERR_CONNECTION_RATE_NOT_SUPPORTED:
+		case TRANS_TX_OPEN_CNX_ERR_BAD_DESTINATION:
+		case TRANS_TX_OPEN_CNX_ERR_BREAK_RCVD:
+		case TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION:
+		case TRANS_TX_OPEN_CNX_ERR_ZONE_VIOLATION:
+		case TRANS_TX_OPEN_CNX_ERR_STP_RESOURCES_BUSY:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			break;
+		}
+		case TRANS_TX_OPEN_CNX_ERR_OPEN_TIMEOUT:
+		{
+			ts->stat = SAS_OPEN_TO;
+			break;
+		}
+		case DMA_RX_DATA_LEN_OVERFLOW:
+		{
+			ts->stat = SAS_DATA_OVERRUN;
+			break;
+		}
+		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
+		case TRANS_TX_ERR_PHY_NOT_ENABLE:
+		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
+		case TRANS_TX_OPEN_CNX_ERR_AIP_TIMEOUT:
+		case TRANS_TX_OPEN_RETRY_ERR_THRESHOLD_REACHED:
+		case TRANS_TX_ERR_WITH_BREAK_TIMEOUT:
+		case TRANS_TX_ERR_WITH_BREAK_REQUEST:
+		case TRANS_TX_ERR_WITH_BREAK_RECEVIED:
+		case TRANS_TX_ERR_WITH_CLOSE_TIMEOUT:
+		case TRANS_TX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_TX_ERR_WITH_CLOSE_DWS_TIMEOUT:
+		case TRANS_TX_ERR_WITH_CLOSE_COMINIT:
+		case TRANS_TX_ERR_WITH_NAK_RECEVIED:
+		case TRANS_TX_ERR_WITH_ACK_NAK_TIMEOUT:
+		case TRANS_TX_ERR_WITH_CREDIT_TIMEOUT:
+		case TRANS_TX_ERR_WITH_WAIT_RECV_TIMEOUT:
+		case TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR:
+		case TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM:
+		case TRANS_RX_ERR_WITH_RXFIS_DECODE_ERROR:
+		case TRANS_RX_ERR_WITH_RXFIS_CRC_ERR:
+		case TRANS_RX_ERR_WITH_RXFRAME_LENGTH_OVERRUN:
+		case TRANS_RX_ERR_WITH_RXFIS_RX_SYNCP:
+		case TRANS_RX_ERR_WITH_CLOSE_NORMAL:
+		case TRANS_RX_ERR_WITH_CLOSE_PHY_DISABLE:
+		case TRANS_RX_ERR_WITH_CLOSE_DWS_TIMEOUT:
+		case TRANS_RX_ERR_WITH_CLOSE_COMINIT:
+		case TRANS_RX_ERR_WITH_DATA_LEN0:
+		case TRANS_RX_ERR_WITH_BAD_HASH:
+		case TRANS_RX_XRDY_WLEN_ZERO_ERR:
+		case TRANS_RX_SSP_FRM_LEN_ERR:
+		case SIPC_RX_FIS_STATUS_ERR_BIT_VLD:
+		case SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR:
+		case SIPC_RX_FIS_STATUS_BSY_BIT_ERR:
+		case SIPC_RX_WRSETUP_LEN_ODD_ERR:
+		case SIPC_RX_WRSETUP_LEN_ZERO_ERR:
+		case SIPC_RX_WRDATA_LEN_NOT_MATCH_ERR:
+		case SIPC_RX_SATA_UNEXP_FIS_ERR:
+		case DMA_RX_SATA_FRAME_TYPE_ERR:
+		case DMA_RX_UNEXP_RDFRAME_ERR:
+		case DMA_RX_PIO_DATA_LEN_ERR:
+		case DMA_RX_RDSETUP_STATUS_ERR:
+		case DMA_RX_RDSETUP_STATUS_DRQ_ERR:
+		case DMA_RX_RDSETUP_STATUS_BSY_ERR:
+		case DMA_RX_RDSETUP_LEN_ODD_ERR:
+		case DMA_RX_RDSETUP_LEN_ZERO_ERR:
+		case DMA_RX_RDSETUP_LEN_OVER_ERR:
+		case DMA_RX_RDSETUP_OFFSET_ERR:
+		case DMA_RX_RDSETUP_ACTIVE_ERR:
+		case DMA_RX_RDSETUP_ESTATUS_ERR:
+		case DMA_RX_UNKNOWN_FRM_ERR:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			break;
+		}
+		default:
+		{
+			ts->stat = SAS_PROTO_RESPONSE;
+			break;
+		}
+		}
+		sata_done_v2_hw(hisi_hba, task, slot);
+	}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 		    int abort)
@@ -1055,6 +1475,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 			__func__, slot->cmplt_queue_slot,
 			complete_hdr->dw0 & CMPLT_HDR_ERX_MSK);
 
+		slot_err_v2_hw(hisi_hba, task, slot);
 		goto out;
 	}
 
-- 
1.9.1
