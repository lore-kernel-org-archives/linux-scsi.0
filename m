From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 06/32] scsi: hisi_sas: add HW DMA structures
Date: Wed, 18 Nov 2015 00:50:33 +0800
Message-ID: <1447779059-136143-7-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 131 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 87f4b61..19d40b7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -66,5 +66,136 @@ struct hisi_hba {
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 };
 
+/* Generic HW DMA host memory structures */
+/* Delivery queue header */
+struct hisi_sas_cmd_hdr {
+	/* dw0 */
+	__le32 dw0;
+
+	/* dw1 */
+	__le32 dw1;
+
+	/* dw2 */
+	__le32 dw2;
+
+	/* dw3 */
+	__le32 transfer_tags;
+
+	/* dw4 */
+	__le32 data_transfer_len;
+
+	/* dw5 */
+	__le32 first_burst_num;
+
+	/* dw6 */
+	__le32 sg_len;
+
+	/* dw7 */
+	__le32 dw7;
+
+	/* dw8-9 */
+	__le64 cmd_table_addr;
+
+	/* dw10-11 */
+	__le64 sts_buffer_addr;
+
+	/* dw12-13 */
+	__le64 prd_table_addr;
+
+	/* dw14-15 */
+	__le64 dif_prd_table_addr;
+};
+
+struct hisi_sas_itct {
+	__le64 qw0;
+	__le64 sas_addr;
+	__le64 qw2;
+	__le64 qw3;
+	__le64 qw4;
+	__le64 qw_sata_ncq0_3;
+	__le64 qw_sata_ncq7_4;
+	__le64 qw_sata_ncq11_8;
+	__le64 qw_sata_ncq15_12;
+	__le64 qw_sata_ncq19_16;
+	__le64 qw_sata_ncq23_20;
+	__le64 qw_sata_ncq27_24;
+	__le64 qw_sata_ncq31_28;
+	__le64 qw_non_ncq_iptt;
+	__le64 qw_rsvd0;
+	__le64 qw_rsvd1;
+};
+
+struct hisi_sas_iost {
+	__le64 qw0;
+	__le64 qw1;
+	__le64 qw2;
+	__le64 qw3;
+};
+
+struct hisi_sas_err_record {
+	/* dw0 */
+	__le32 dma_err_type;
+
+	/* dw1 */
+	__le32 trans_tx_fail_type;
+
+	/* dw2 */
+	__le32 trans_rx_fail_type;
+
+	/* dw3 */
+	u32 rsvd;
+};
+
+struct hisi_sas_initial_fis {
+	struct hisi_sas_err_record err_record;
+	struct dev_to_host_fis fis;
+	u32 rsvd[3];
+};
+
+struct hisi_sas_breakpoint {
+	u8	data[128];	/*io128 byte*/
+};
+
+struct hisi_sas_sge {
+	__le64 addr;
+	__le32 page_ctrl_0;
+	__le32 page_ctrl_1;
+	__le32 data_len;
+	__le32 data_off;
+};
+
+struct hisi_sas_command_table_smp {
+	u8 bytes[44];
+};
+
+struct hisi_sas_command_table_stp {
+	struct	host_to_dev_fis command_fis;
+	u8	dummy[12];
+	u8	atapi_cdb[ATAPI_CDB_LEN];
+};
+
 #define HISI_SAS_SGE_PAGE_CNT SCSI_MAX_SG_SEGMENTS
+struct hisi_sas_sge_page {
+	struct hisi_sas_sge sge[HISI_SAS_SGE_PAGE_CNT];
+};
+
+struct hisi_sas_command_table_ssp {
+	struct ssp_frame_hdr hdr;
+	union {
+		struct {
+			struct ssp_command_iu task;
+			u32 prot[6];
+		};
+		struct ssp_tmf_iu ssp_task;
+		struct xfer_rdy_iu xfer_rdy;
+		struct ssp_response_iu ssp_res;
+	} u;
+};
+
+union hisi_sas_command_table {
+	struct hisi_sas_command_table_ssp ssp;
+	struct hisi_sas_command_table_smp smp;
+	struct hisi_sas_command_table_stp stp;
+};
+
 #endif
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
