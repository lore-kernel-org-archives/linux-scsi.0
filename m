From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v4 PATCH 2/5] bnx2fc: Header files
Date: Tue, 25 Jan 2011 18:57:47 -0800
Message-ID: <1296010668.3536.2587.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1314 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1AZC6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 21:58:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

This patch contains header files for bnx2fc driver.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  | 1080 ++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc.h           |  520 +++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_constants.h |  206 ++++++
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |   68 ++
 4 files changed, 1874 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_constants.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.h

diff --git a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
new file mode 100644
index 0000000..69d031d
--- /dev/null
+++ b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
@@ -0,0 +1,1080 @@
+#ifndef __57XX_FCOE_HSI_LINUX_LE__
+#define __57XX_FCOE_HSI_LINUX_LE__
+
+/*
+ * common data for all protocols
+ */
+struct b577xx_doorbell_hdr {
+	u8 header;
+#define B577XX_DOORBELL_HDR_RX (0x1<<0)
+#define B577XX_DOORBELL_HDR_RX_SHIFT 0
+#define B577XX_DOORBELL_HDR_DB_TYPE (0x1<<1)
+#define B577XX_DOORBELL_HDR_DB_TYPE_SHIFT 1
+#define B577XX_DOORBELL_HDR_DPM_SIZE (0x3<<2)
+#define B577XX_DOORBELL_HDR_DPM_SIZE_SHIFT 2
+#define B577XX_DOORBELL_HDR_CONN_TYPE (0xF<<4)
+#define B577XX_DOORBELL_HDR_CONN_TYPE_SHIFT 4
+};
+
+/*
+ * doorbell message sent to the chip
+ */
+struct b577xx_doorbell_set_prod {
+#if defined(__BIG_ENDIAN)
+	u16 prod;
+	u8 zero_fill1;
+	struct b577xx_doorbell_hdr header;
+#elif defined(__LITTLE_ENDIAN)
+	struct b577xx_doorbell_hdr header;
+	u8 zero_fill1;
+	u16 prod;
+#endif
+};
+
+
+struct regpair {
+	__le32 lo;
+	__le32 hi;
+};
+
+
+/*
+ * Fixed size structure in order to plant it in Union structure
+ */
+struct fcoe_abts_rsp_union {
+	u32 r_ctl;
+	u32 abts_rsp_payload[7];
+};
+
+
+/*
+ * 4 regs size
+ */
+struct fcoe_bd_ctx {
+	u32 buf_addr_hi;
+	u32 buf_addr_lo;
+#if defined(__BIG_ENDIAN)
+	u16 rsrv0;
+	u16 buf_len;
+#elif defined(__LITTLE_ENDIAN)
+	u16 buf_len;
+	u16 rsrv0;
+#endif
+#if defined(__BIG_ENDIAN)
+	u16 rsrv1;
+	u16 flags;
+#elif defined(__LITTLE_ENDIAN)
+	u16 flags;
+	u16 rsrv1;
+#endif
+};
+
+
+struct fcoe_cleanup_flow_info {
+#if defined(__BIG_ENDIAN)
+	u16 reserved1;
+	u16 task_id;
+#elif defined(__LITTLE_ENDIAN)
+	u16 task_id;
+	u16 reserved1;
+#endif
+	u32 reserved2[7];
+};
+
+
+struct fcoe_fcp_cmd_payload {
+	u32 opaque[8];
+};
+
+struct fcoe_fc_hdr {
+#if defined(__BIG_ENDIAN)
+	u8 cs_ctl;
+	u8 s_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 s_id[3];
+	u8 cs_ctl;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 r_ctl;
+	u8 d_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 d_id[3];
+	u8 r_ctl;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 seq_id;
+	u8 df_ctl;
+	u16 seq_cnt;
+#elif defined(__LITTLE_ENDIAN)
+	u16 seq_cnt;
+	u8 df_ctl;
+	u8 seq_id;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 type;
+	u8 f_ctl[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 f_ctl[3];
+	u8 type;
+#endif
+	u32 parameters;
+#if defined(__BIG_ENDIAN)
+	u16 ox_id;
+	u16 rx_id;
+#elif defined(__LITTLE_ENDIAN)
+	u16 rx_id;
+	u16 ox_id;
+#endif
+};
+
+struct fcoe_fc_frame {
+	struct fcoe_fc_hdr fc_hdr;
+	u32 reserved0[2];
+};
+
+union fcoe_cmd_flow_info {
+	struct fcoe_fcp_cmd_payload fcp_cmd_payload;
+	struct fcoe_fc_frame mp_fc_frame;
+};
+
+
+
+struct fcoe_fcp_rsp_flags {
+	u8 flags;
+#define FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID (0x1<<0)
+#define FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID_SHIFT 0
+#define FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID (0x1<<1)
+#define FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID_SHIFT 1
+#define FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER (0x1<<2)
+#define FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER_SHIFT 2
+#define FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER (0x1<<3)
+#define FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER_SHIFT 3
+#define FCOE_FCP_RSP_FLAGS_FCP_CONF_REQ (0x1<<4)
+#define FCOE_FCP_RSP_FLAGS_FCP_CONF_REQ_SHIFT 4
+#define FCOE_FCP_RSP_FLAGS_FCP_BIDI_FLAGS (0x7<<5)
+#define FCOE_FCP_RSP_FLAGS_FCP_BIDI_FLAGS_SHIFT 5
+};
+
+
+struct fcoe_fcp_rsp_payload {
+	struct regpair reserved0;
+	u32 fcp_resid;
+#if defined(__BIG_ENDIAN)
+	u16 retry_delay_timer;
+	struct fcoe_fcp_rsp_flags fcp_flags;
+	u8 scsi_status_code;
+#elif defined(__LITTLE_ENDIAN)
+	u8 scsi_status_code;
+	struct fcoe_fcp_rsp_flags fcp_flags;
+	u16 retry_delay_timer;
+#endif
+	u32 fcp_rsp_len;
+	u32 fcp_sns_len;
+};
+
+
+/*
+ * Fixed size structure in order to plant it in Union structure
+ */
+struct fcoe_fcp_rsp_union {
+	struct fcoe_fcp_rsp_payload payload;
+	struct regpair reserved0;
+};
+
+
+struct fcoe_fcp_xfr_rdy_payload {
+	u32 burst_len;
+	u32 data_ro;
+};
+
+struct fcoe_read_flow_info {
+	struct fcoe_fc_hdr fc_data_in_hdr;
+	u32 reserved[2];
+};
+
+struct fcoe_write_flow_info {
+	struct fcoe_fc_hdr fc_data_out_hdr;
+	struct fcoe_fcp_xfr_rdy_payload fcp_xfr_payload;
+};
+
+union fcoe_rsp_flow_info {
+	struct fcoe_fcp_rsp_union fcp_rsp;
+	struct fcoe_abts_rsp_union abts_rsp;
+};
+
+/*
+ * 32 bytes used for general purposes
+ */
+union fcoe_general_task_ctx {
+	union fcoe_cmd_flow_info cmd_info;
+	struct fcoe_read_flow_info read_info;
+	struct fcoe_write_flow_info write_info;
+	union fcoe_rsp_flow_info rsp_info;
+	struct fcoe_cleanup_flow_info cleanup_info;
+	u32 comp_info[8];
+};
+
+
+/*
+ * FCoE KCQ CQE parameters
+ */
+union fcoe_kcqe_params {
+	u32 reserved0[4];
+};
+
+/*
+ * FCoE KCQ CQE
+ */
+struct fcoe_kcqe {
+	u32 fcoe_conn_id;
+	u32 completion_status;
+	u32 fcoe_conn_context_id;
+	union fcoe_kcqe_params params;
+#if defined(__BIG_ENDIAN)
+	u8 flags;
+#define FCOE_KCQE_RESERVED0 (0x7<<0)
+#define FCOE_KCQE_RESERVED0_SHIFT 0
+#define FCOE_KCQE_RAMROD_COMPLETION (0x1<<3)
+#define FCOE_KCQE_RAMROD_COMPLETION_SHIFT 3
+#define FCOE_KCQE_LAYER_CODE (0x7<<4)
+#define FCOE_KCQE_LAYER_CODE_SHIFT 4
+#define FCOE_KCQE_LINKED_WITH_NEXT (0x1<<7)
+#define FCOE_KCQE_LINKED_WITH_NEXT_SHIFT 7
+	u8 op_code;
+	u16 qe_self_seq;
+#elif defined(__LITTLE_ENDIAN)
+	u16 qe_self_seq;
+	u8 op_code;
+	u8 flags;
+#define FCOE_KCQE_RESERVED0 (0x7<<0)
+#define FCOE_KCQE_RESERVED0_SHIFT 0
+#define FCOE_KCQE_RAMROD_COMPLETION (0x1<<3)
+#define FCOE_KCQE_RAMROD_COMPLETION_SHIFT 3
+#define FCOE_KCQE_LAYER_CODE (0x7<<4)
+#define FCOE_KCQE_LAYER_CODE_SHIFT 4
+#define FCOE_KCQE_LINKED_WITH_NEXT (0x1<<7)
+#define FCOE_KCQE_LINKED_WITH_NEXT_SHIFT 7
+#endif
+};
+
+/*
+ * FCoE KWQE header
+ */
+struct fcoe_kwqe_header {
+#if defined(__BIG_ENDIAN)
+	u8 flags;
+#define FCOE_KWQE_HEADER_RESERVED0 (0xF<<0)
+#define FCOE_KWQE_HEADER_RESERVED0_SHIFT 0
+#define FCOE_KWQE_HEADER_LAYER_CODE (0x7<<4)
+#define FCOE_KWQE_HEADER_LAYER_CODE_SHIFT 4
+#define FCOE_KWQE_HEADER_RESERVED1 (0x1<<7)
+#define FCOE_KWQE_HEADER_RESERVED1_SHIFT 7
+	u8 op_code;
+#elif defined(__LITTLE_ENDIAN)
+	u8 op_code;
+	u8 flags;
+#define FCOE_KWQE_HEADER_RESERVED0 (0xF<<0)
+#define FCOE_KWQE_HEADER_RESERVED0_SHIFT 0
+#define FCOE_KWQE_HEADER_LAYER_CODE (0x7<<4)
+#define FCOE_KWQE_HEADER_LAYER_CODE_SHIFT 4
+#define FCOE_KWQE_HEADER_RESERVED1 (0x1<<7)
+#define FCOE_KWQE_HEADER_RESERVED1_SHIFT 7
+#endif
+};
+
+/*
+ * FCoE firmware init request 1
+ */
+struct fcoe_kwqe_init1 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 num_tasks;
+#elif defined(__LITTLE_ENDIAN)
+	u16 num_tasks;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 task_list_pbl_addr_lo;
+	u32 task_list_pbl_addr_hi;
+	u32 dummy_buffer_addr_lo;
+	u32 dummy_buffer_addr_hi;
+#if defined(__BIG_ENDIAN)
+	u16 rq_num_wqes;
+	u16 sq_num_wqes;
+#elif defined(__LITTLE_ENDIAN)
+	u16 sq_num_wqes;
+	u16 rq_num_wqes;
+#endif
+#if defined(__BIG_ENDIAN)
+	u16 cq_num_wqes;
+	u16 rq_buffer_log_size;
+#elif defined(__LITTLE_ENDIAN)
+	u16 rq_buffer_log_size;
+	u16 cq_num_wqes;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 flags;
+#define FCOE_KWQE_INIT1_LOG_PAGE_SIZE (0xF<<0)
+#define FCOE_KWQE_INIT1_LOG_PAGE_SIZE_SHIFT 0
+#define FCOE_KWQE_INIT1_LOG_CACHED_PBES_PER_FUNC (0x7<<4)
+#define FCOE_KWQE_INIT1_LOG_CACHED_PBES_PER_FUNC_SHIFT 4
+#define FCOE_KWQE_INIT1_RESERVED1 (0x1<<7)
+#define FCOE_KWQE_INIT1_RESERVED1_SHIFT 7
+	u8 num_sessions_log;
+	u16 mtu;
+#elif defined(__LITTLE_ENDIAN)
+	u16 mtu;
+	u8 num_sessions_log;
+	u8 flags;
+#define FCOE_KWQE_INIT1_LOG_PAGE_SIZE (0xF<<0)
+#define FCOE_KWQE_INIT1_LOG_PAGE_SIZE_SHIFT 0
+#define FCOE_KWQE_INIT1_LOG_CACHED_PBES_PER_FUNC (0x7<<4)
+#define FCOE_KWQE_INIT1_LOG_CACHED_PBES_PER_FUNC_SHIFT 4
+#define FCOE_KWQE_INIT1_RESERVED1 (0x1<<7)
+#define FCOE_KWQE_INIT1_RESERVED1_SHIFT 7
+#endif
+};
+
+/*
+ * FCoE firmware init request 2
+ */
+struct fcoe_kwqe_init2 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 hash_tbl_pbl_addr_lo;
+	u32 hash_tbl_pbl_addr_hi;
+	u32 t2_hash_tbl_addr_lo;
+	u32 t2_hash_tbl_addr_hi;
+	u32 t2_ptr_hash_tbl_addr_lo;
+	u32 t2_ptr_hash_tbl_addr_hi;
+	u32 free_list_count;
+};
+
+/*
+ * FCoE firmware init request 3
+ */
+struct fcoe_kwqe_init3 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 error_bit_map_lo;
+	u32 error_bit_map_hi;
+#if defined(__BIG_ENDIAN)
+	u8 reserved21[3];
+	u8 cached_session_enable;
+#elif defined(__LITTLE_ENDIAN)
+	u8 cached_session_enable;
+	u8 reserved21[3];
+#endif
+	u32 reserved2[4];
+};
+
+/*
+ * FCoE connection offload request 1
+ */
+struct fcoe_kwqe_conn_offload1 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 fcoe_conn_id;
+#elif defined(__LITTLE_ENDIAN)
+	u16 fcoe_conn_id;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 sq_addr_lo;
+	u32 sq_addr_hi;
+	u32 rq_pbl_addr_lo;
+	u32 rq_pbl_addr_hi;
+	u32 rq_first_pbe_addr_lo;
+	u32 rq_first_pbe_addr_hi;
+#if defined(__BIG_ENDIAN)
+	u16 reserved0;
+	u16 rq_prod;
+#elif defined(__LITTLE_ENDIAN)
+	u16 rq_prod;
+	u16 reserved0;
+#endif
+};
+
+/*
+ * FCoE connection offload request 2
+ */
+struct fcoe_kwqe_conn_offload2 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 tx_max_fc_pay_len;
+#elif defined(__LITTLE_ENDIAN)
+	u16 tx_max_fc_pay_len;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 cq_addr_lo;
+	u32 cq_addr_hi;
+	u32 xferq_addr_lo;
+	u32 xferq_addr_hi;
+	u32 conn_db_addr_lo;
+	u32 conn_db_addr_hi;
+	u32 reserved1;
+};
+
+/*
+ * FCoE connection offload request 3
+ */
+struct fcoe_kwqe_conn_offload3 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 vlan_tag;
+#define FCOE_KWQE_CONN_OFFLOAD3_VLAN_ID (0xFFF<<0)
+#define FCOE_KWQE_CONN_OFFLOAD3_VLAN_ID_SHIFT 0
+#define FCOE_KWQE_CONN_OFFLOAD3_CFI (0x1<<12)
+#define FCOE_KWQE_CONN_OFFLOAD3_CFI_SHIFT 12
+#define FCOE_KWQE_CONN_OFFLOAD3_PRIORITY (0x7<<13)
+#define FCOE_KWQE_CONN_OFFLOAD3_PRIORITY_SHIFT 13
+#elif defined(__LITTLE_ENDIAN)
+	u16 vlan_tag;
+#define FCOE_KWQE_CONN_OFFLOAD3_VLAN_ID (0xFFF<<0)
+#define FCOE_KWQE_CONN_OFFLOAD3_VLAN_ID_SHIFT 0
+#define FCOE_KWQE_CONN_OFFLOAD3_CFI (0x1<<12)
+#define FCOE_KWQE_CONN_OFFLOAD3_CFI_SHIFT 12
+#define FCOE_KWQE_CONN_OFFLOAD3_PRIORITY (0x7<<13)
+#define FCOE_KWQE_CONN_OFFLOAD3_PRIORITY_SHIFT 13
+	struct fcoe_kwqe_header hdr;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 tx_max_conc_seqs_c3;
+	u8 s_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 s_id[3];
+	u8 tx_max_conc_seqs_c3;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 flags;
+#define FCOE_KWQE_CONN_OFFLOAD3_B_MUL_N_PORT_IDS (0x1<<0)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_MUL_N_PORT_IDS_SHIFT 0
+#define FCOE_KWQE_CONN_OFFLOAD3_B_E_D_TOV_RES (0x1<<1)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_E_D_TOV_RES_SHIFT 1
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONT_INCR_SEQ_CNT (0x1<<2)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONT_INCR_SEQ_CNT_SHIFT 2
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONF_REQ (0x1<<3)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONF_REQ_SHIFT 3
+#define FCOE_KWQE_CONN_OFFLOAD3_B_REC_VALID (0x1<<4)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_REC_VALID_SHIFT 4
+#define FCOE_KWQE_CONN_OFFLOAD3_B_C2_VALID (0x1<<5)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_C2_VALID_SHIFT 5
+#define FCOE_KWQE_CONN_OFFLOAD3_B_ACK_0 (0x1<<6)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_ACK_0_SHIFT 6
+#define FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG (0x1<<7)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG_SHIFT 7
+	u8 d_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 d_id[3];
+	u8 flags;
+#define FCOE_KWQE_CONN_OFFLOAD3_B_MUL_N_PORT_IDS (0x1<<0)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_MUL_N_PORT_IDS_SHIFT 0
+#define FCOE_KWQE_CONN_OFFLOAD3_B_E_D_TOV_RES (0x1<<1)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_E_D_TOV_RES_SHIFT 1
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONT_INCR_SEQ_CNT (0x1<<2)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONT_INCR_SEQ_CNT_SHIFT 2
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONF_REQ (0x1<<3)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_CONF_REQ_SHIFT 3
+#define FCOE_KWQE_CONN_OFFLOAD3_B_REC_VALID (0x1<<4)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_REC_VALID_SHIFT 4
+#define FCOE_KWQE_CONN_OFFLOAD3_B_C2_VALID (0x1<<5)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_C2_VALID_SHIFT 5
+#define FCOE_KWQE_CONN_OFFLOAD3_B_ACK_0 (0x1<<6)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_ACK_0_SHIFT 6
+#define FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG (0x1<<7)
+#define FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG_SHIFT 7
+#endif
+	u32 reserved;
+	u32 confq_first_pbe_addr_lo;
+	u32 confq_first_pbe_addr_hi;
+#if defined(__BIG_ENDIAN)
+	u16 rx_max_fc_pay_len;
+	u16 tx_total_conc_seqs;
+#elif defined(__LITTLE_ENDIAN)
+	u16 tx_total_conc_seqs;
+	u16 rx_max_fc_pay_len;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 rx_open_seqs_exch_c3;
+	u8 rx_max_conc_seqs_c3;
+	u16 rx_total_conc_seqs;
+#elif defined(__LITTLE_ENDIAN)
+	u16 rx_total_conc_seqs;
+	u8 rx_max_conc_seqs_c3;
+	u8 rx_open_seqs_exch_c3;
+#endif
+};
+
+/*
+ * FCoE connection offload request 4
+ */
+struct fcoe_kwqe_conn_offload4 {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u8 reserved2;
+	u8 e_d_tov_timer_val;
+#elif defined(__LITTLE_ENDIAN)
+	u8 e_d_tov_timer_val;
+	u8 reserved2;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u8 src_mac_addr_lo32[4];
+#if defined(__BIG_ENDIAN)
+	u8 dst_mac_addr_hi16[2];
+	u8 src_mac_addr_hi16[2];
+#elif defined(__LITTLE_ENDIAN)
+	u8 src_mac_addr_hi16[2];
+	u8 dst_mac_addr_hi16[2];
+#endif
+	u8 dst_mac_addr_lo32[4];
+	u32 lcq_addr_lo;
+	u32 lcq_addr_hi;
+	u32 confq_pbl_base_addr_lo;
+	u32 confq_pbl_base_addr_hi;
+};
+
+/*
+ * FCoE connection enable request
+ */
+struct fcoe_kwqe_conn_enable_disable {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u8 src_mac_addr_lo32[4];
+#if defined(__BIG_ENDIAN)
+	u16 vlan_tag;
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_VLAN_ID (0xFFF<<0)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_VLAN_ID_SHIFT 0
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_CFI (0x1<<12)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_CFI_SHIFT 12
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_PRIORITY (0x7<<13)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_PRIORITY_SHIFT 13
+	u8 src_mac_addr_hi16[2];
+#elif defined(__LITTLE_ENDIAN)
+	u8 src_mac_addr_hi16[2];
+	u16 vlan_tag;
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_VLAN_ID (0xFFF<<0)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_VLAN_ID_SHIFT 0
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_CFI (0x1<<12)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_CFI_SHIFT 12
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_PRIORITY (0x7<<13)
+#define FCOE_KWQE_CONN_ENABLE_DISABLE_PRIORITY_SHIFT 13
+#endif
+	u8 dst_mac_addr_lo32[4];
+#if defined(__BIG_ENDIAN)
+	u16 reserved1;
+	u8 dst_mac_addr_hi16[2];
+#elif defined(__LITTLE_ENDIAN)
+	u8 dst_mac_addr_hi16[2];
+	u16 reserved1;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 vlan_flag;
+	u8 s_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 s_id[3];
+	u8 vlan_flag;
+#endif
+#if defined(__BIG_ENDIAN)
+	u8 reserved3;
+	u8 d_id[3];
+#elif defined(__LITTLE_ENDIAN)
+	u8 d_id[3];
+	u8 reserved3;
+#endif
+	u32 context_id;
+	u32 conn_id;
+	u32 reserved4;
+};
+
+/*
+ * FCoE connection destroy request
+ */
+struct fcoe_kwqe_conn_destroy {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 context_id;
+	u32 conn_id;
+	u32 reserved1[5];
+};
+
+/*
+ * FCoe destroy request
+ */
+struct fcoe_kwqe_destroy {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 reserved1[7];
+};
+
+/*
+ * FCoe statistics request
+ */
+struct fcoe_kwqe_stat {
+#if defined(__BIG_ENDIAN)
+	struct fcoe_kwqe_header hdr;
+	u16 reserved0;
+#elif defined(__LITTLE_ENDIAN)
+	u16 reserved0;
+	struct fcoe_kwqe_header hdr;
+#endif
+	u32 stat_params_addr_lo;
+	u32 stat_params_addr_hi;
+	u32 reserved1[5];
+};
+
+/*
+ * FCoE KWQ WQE
+ */
+union fcoe_kwqe {
+	struct fcoe_kwqe_init1 init1;
+	struct fcoe_kwqe_init2 init2;
+	struct fcoe_kwqe_init3 init3;
+	struct fcoe_kwqe_conn_offload1 conn_offload1;
+	struct fcoe_kwqe_conn_offload2 conn_offload2;
+	struct fcoe_kwqe_conn_offload3 conn_offload3;
+	struct fcoe_kwqe_conn_offload4 conn_offload4;
+	struct fcoe_kwqe_conn_enable_disable conn_enable_disable;
+	struct fcoe_kwqe_conn_destroy conn_destroy;
+	struct fcoe_kwqe_destroy destroy;
+	struct fcoe_kwqe_stat statistics;
+};
+
+struct fcoe_mul_sges_ctx {
+	struct regpair cur_sge_addr;
+#if defined(__BIG_ENDIAN)
+	u8 sgl_size;
+	u8 cur_sge_idx;
+	u16 cur_sge_off;
+#elif defined(__LITTLE_ENDIAN)
+	u16 cur_sge_off;
+	u8 cur_sge_idx;
+	u8 sgl_size;
+#endif
+};
+
+struct fcoe_s_stat_ctx {
+	u8 flags;
+#define FCOE_S_STAT_CTX_ACTIVE (0x1<<0)
+#define FCOE_S_STAT_CTX_ACTIVE_SHIFT 0
+#define FCOE_S_STAT_CTX_ACK_ABORT_SEQ_COND (0x1<<1)
+#define FCOE_S_STAT_CTX_ACK_ABORT_SEQ_COND_SHIFT 1
+#define FCOE_S_STAT_CTX_ABTS_PERFORMED (0x1<<2)
+#define FCOE_S_STAT_CTX_ABTS_PERFORMED_SHIFT 2
+#define FCOE_S_STAT_CTX_SEQ_TIMEOUT (0x1<<3)
+#define FCOE_S_STAT_CTX_SEQ_TIMEOUT_SHIFT 3
+#define FCOE_S_STAT_CTX_P_RJT (0x1<<4)
+#define FCOE_S_STAT_CTX_P_RJT_SHIFT 4
+#define FCOE_S_STAT_CTX_ACK_EOFT (0x1<<5)
+#define FCOE_S_STAT_CTX_ACK_EOFT_SHIFT 5
+#define FCOE_S_STAT_CTX_RSRV1 (0x3<<6)
+#define FCOE_S_STAT_CTX_RSRV1_SHIFT 6
+};
+
+struct fcoe_seq_ctx {
+#if defined(__BIG_ENDIAN)
+	u16 low_seq_cnt;
+	struct fcoe_s_stat_ctx s_stat;
+	u8 seq_id;
+#elif defined(__LITTLE_ENDIAN)
+	u8 seq_id;
+	struct fcoe_s_stat_ctx s_stat;
+	u16 low_seq_cnt;
+#endif
+#if defined(__BIG_ENDIAN)
+	u16 err_seq_cnt;
+	u16 high_seq_cnt;
+#elif defined(__LITTLE_ENDIAN)
+	u16 high_seq_cnt;
+	u16 err_seq_cnt;
+#endif
+	u32 low_exp_ro;
+	u32 high_exp_ro;
+};
+
+
+struct fcoe_single_sge_ctx {
+	struct regpair cur_buf_addr;
+#if defined(__BIG_ENDIAN)
+	u16 reserved0;
+	u16 cur_buf_rem;
+#elif defined(__LITTLE_ENDIAN)
+	u16 cur_buf_rem;
+	u16 reserved0;
+#endif
+};
+
+union fcoe_sgl_ctx {
+	struct fcoe_single_sge_ctx single_sge;
+	struct fcoe_mul_sges_ctx mul_sges;
+};
+
+
+
+/*
+ * FCoE SQ element
+ */
+struct fcoe_sqe {
+	u16 wqe;
+#define FCOE_SQE_TASK_ID (0x7FFF<<0)
+#define FCOE_SQE_TASK_ID_SHIFT 0
+#define FCOE_SQE_TOGGLE_BIT (0x1<<15)
+#define FCOE_SQE_TOGGLE_BIT_SHIFT 15
+};
+
+
+
+struct fcoe_task_ctx_entry_tx_only {
+	union fcoe_sgl_ctx sgl_ctx;
+};
+
+struct fcoe_task_ctx_entry_txwr_rxrd {
+#if defined(__BIG_ENDIAN)
+	u16 verify_tx_seq;
+	u8 init_flags;
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TASK_TYPE (0x7<<0)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TASK_TYPE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_DEV_TYPE (0x1<<3)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_DEV_TYPE_SHIFT 3
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_CLASS_TYPE (0x1<<4)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_CLASS_TYPE_SHIFT 4
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_SINGLE_SGE (0x1<<5)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_SINGLE_SGE_SHIFT 5
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV5 (0x3<<6)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV5_SHIFT 6
+	u8 tx_flags;
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TX_STATE (0xF<<0)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TX_STATE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV4 (0xF<<4)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV4_SHIFT 4
+#elif defined(__LITTLE_ENDIAN)
+	u8 tx_flags;
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TX_STATE (0xF<<0)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TX_STATE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV4 (0xF<<4)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV4_SHIFT 4
+	u8 init_flags;
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TASK_TYPE (0x7<<0)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_TASK_TYPE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_DEV_TYPE (0x1<<3)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_DEV_TYPE_SHIFT 3
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_CLASS_TYPE (0x1<<4)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_CLASS_TYPE_SHIFT 4
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_SINGLE_SGE (0x1<<5)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_SINGLE_SGE_SHIFT 5
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV5 (0x3<<6)
+#define FCOE_TASK_CTX_ENTRY_TXWR_RXRD_RSRV5_SHIFT 6
+	u16 verify_tx_seq;
+#endif
+};
+
+/*
+ * Common section. Both TX and RX processing might write and read from it in
+ * different flows
+ */
+struct fcoe_task_ctx_entry_tx_rx_cmn {
+	u32 data_2_trns;
+	union fcoe_general_task_ctx general;
+#if defined(__BIG_ENDIAN)
+	u16 tx_low_seq_cnt;
+	struct fcoe_s_stat_ctx tx_s_stat;
+	u8 tx_seq_id;
+#elif defined(__LITTLE_ENDIAN)
+	u8 tx_seq_id;
+	struct fcoe_s_stat_ctx tx_s_stat;
+	u16 tx_low_seq_cnt;
+#endif
+	u32 common_flags;
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_CID (0xFFFFFF<<0)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_CID_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_VALID (0x1<<24)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_VALID_SHIFT 24
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_SEQ_INIT (0x1<<25)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_SEQ_INIT_SHIFT 25
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_PEND_XFER (0x1<<26)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_PEND_XFER_SHIFT 26
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_PEND_CONF (0x1<<27)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_PEND_CONF_SHIFT 27
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_EXP_FIRST_FRAME (0x1<<28)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_EXP_FIRST_FRAME_SHIFT 28
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_RSRV (0x7<<29)
+#define FCOE_TASK_CTX_ENTRY_TX_RX_CMN_RSRV_SHIFT 29
+};
+
+struct fcoe_task_ctx_entry_rxwr_txrd {
+#if defined(__BIG_ENDIAN)
+	u16 rx_id;
+	u16 rx_flags;
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RX_STATE (0xF<<0)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RX_STATE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_NUM_RQ_WQE (0x7<<4)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_NUM_RQ_WQE_SHIFT 4
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_CONF_REQ (0x1<<7)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_CONF_REQ_SHIFT 7
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_MISS_FRAME (0x1<<8)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_MISS_FRAME_SHIFT 8
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RESERVED0 (0x7F<<9)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RESERVED0_SHIFT 9
+#elif defined(__LITTLE_ENDIAN)
+	u16 rx_flags;
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RX_STATE (0xF<<0)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RX_STATE_SHIFT 0
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_NUM_RQ_WQE (0x7<<4)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_NUM_RQ_WQE_SHIFT 4
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_CONF_REQ (0x1<<7)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_CONF_REQ_SHIFT 7
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_MISS_FRAME (0x1<<8)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_MISS_FRAME_SHIFT 8
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RESERVED0 (0x7F<<9)
+#define FCOE_TASK_CTX_ENTRY_RXWR_TXRD_RESERVED0_SHIFT 9
+	u16 rx_id;
+#endif
+};
+
+struct fcoe_task_ctx_entry_rx_only {
+	struct fcoe_seq_ctx seq_ctx;
+	struct fcoe_seq_ctx ooo_seq_ctx;
+	u32 rsrv3;
+	union fcoe_sgl_ctx sgl_ctx;
+};
+
+struct fcoe_task_ctx_entry {
+	struct fcoe_task_ctx_entry_tx_only tx_wr_only;
+	struct fcoe_task_ctx_entry_txwr_rxrd tx_wr_rx_rd;
+	struct fcoe_task_ctx_entry_tx_rx_cmn cmn;
+	struct fcoe_task_ctx_entry_rxwr_txrd rx_wr_tx_rd;
+	struct fcoe_task_ctx_entry_rx_only rx_wr_only;
+	u32 reserved[4];
+};
+
+
+/*
+ * FCoE XFRQ element
+ */
+struct fcoe_xfrqe {
+	u16 wqe;
+#define FCOE_XFRQE_TASK_ID (0x7FFF<<0)
+#define FCOE_XFRQE_TASK_ID_SHIFT 0
+#define FCOE_XFRQE_TOGGLE_BIT (0x1<<15)
+#define FCOE_XFRQE_TOGGLE_BIT_SHIFT 15
+};
+
+
+/*
+ * FCoE CONFQ element
+ */
+struct fcoe_confqe {
+#if defined(__BIG_ENDIAN)
+	u16 rx_id;
+	u16 ox_id;
+#elif defined(__LITTLE_ENDIAN)
+	u16 ox_id;
+	u16 rx_id;
+#endif
+	u32 param;
+};
+
+
+/*
+ * FCoE conection data base
+ */
+struct fcoe_conn_db {
+#if defined(__BIG_ENDIAN)
+	u16 rsrv0;
+	u16 rq_prod;
+#elif defined(__LITTLE_ENDIAN)
+	u16 rq_prod;
+	u16 rsrv0;
+#endif
+	u32 rsrv1;
+	struct regpair cq_arm;
+};
+
+
+/*
+ * FCoE CQ element
+ */
+struct fcoe_cqe {
+	u16 wqe;
+#define FCOE_CQE_CQE_INFO (0x3FFF<<0)
+#define FCOE_CQE_CQE_INFO_SHIFT 0
+#define FCOE_CQE_CQE_TYPE (0x1<<14)
+#define FCOE_CQE_CQE_TYPE_SHIFT 14
+#define FCOE_CQE_TOGGLE_BIT (0x1<<15)
+#define FCOE_CQE_TOGGLE_BIT_SHIFT 15
+};
+
+
+/*
+ * FCoE error/warning resporting entry
+ */
+struct fcoe_err_report_entry {
+	u32 err_warn_bitmap_lo;
+	u32 err_warn_bitmap_hi;
+	u32 tx_buf_off;
+	u32 rx_buf_off;
+	struct fcoe_fc_hdr fc_hdr;
+};
+
+
+/*
+ * FCoE hash table entry (32 bytes)
+ */
+struct fcoe_hash_table_entry {
+#if defined(__BIG_ENDIAN)
+	u8 d_id_0;
+	u8 s_id_2;
+	u8 s_id_1;
+	u8 s_id_0;
+#elif defined(__LITTLE_ENDIAN)
+	u8 s_id_0;
+	u8 s_id_1;
+	u8 s_id_2;
+	u8 d_id_0;
+#endif
+#if defined(__BIG_ENDIAN)
+	u16 dst_mac_addr_hi;
+	u8 d_id_2;
+	u8 d_id_1;
+#elif defined(__LITTLE_ENDIAN)
+	u8 d_id_1;
+	u8 d_id_2;
+	u16 dst_mac_addr_hi;
+#endif
+	u32 dst_mac_addr_lo;
+#if defined(__BIG_ENDIAN)
+	u16 vlan_id;
+	u16 src_mac_addr_hi;
+#elif defined(__LITTLE_ENDIAN)
+	u16 src_mac_addr_hi;
+	u16 vlan_id;
+#endif
+	u32 src_mac_addr_lo;
+#if defined(__BIG_ENDIAN)
+	u16 reserved1;
+	u8 reserved0;
+	u8 vlan_flag;
+#elif defined(__LITTLE_ENDIAN)
+	u8 vlan_flag;
+	u8 reserved0;
+	u16 reserved1;
+#endif
+	u32 reserved2;
+	u32 field_id;
+#define FCOE_HASH_TABLE_ENTRY_CID (0xFFFFFF<<0)
+#define FCOE_HASH_TABLE_ENTRY_CID_SHIFT 0
+#define FCOE_HASH_TABLE_ENTRY_RESERVED3 (0x7F<<24)
+#define FCOE_HASH_TABLE_ENTRY_RESERVED3_SHIFT 24
+#define FCOE_HASH_TABLE_ENTRY_VALID (0x1<<31)
+#define FCOE_HASH_TABLE_ENTRY_VALID_SHIFT 31
+};
+
+/*
+ * FCoE pending work request CQE
+ */
+struct fcoe_pend_wq_cqe {
+	u16 wqe;
+#define FCOE_PEND_WQ_CQE_TASK_ID (0x3FFF<<0)
+#define FCOE_PEND_WQ_CQE_TASK_ID_SHIFT 0
+#define FCOE_PEND_WQ_CQE_CQE_TYPE (0x1<<14)
+#define FCOE_PEND_WQ_CQE_CQE_TYPE_SHIFT 14
+#define FCOE_PEND_WQ_CQE_TOGGLE_BIT (0x1<<15)
+#define FCOE_PEND_WQ_CQE_TOGGLE_BIT_SHIFT 15
+};
+
+
+/*
+ * FCoE RX statistics parameters section#0
+ */
+struct fcoe_rx_stat_params_section0 {
+	u32 fcoe_ver_cnt;
+	u32 fcoe_rx_pkt_cnt;
+	u32 fcoe_rx_byte_cnt;
+	u32 fcoe_rx_drop_pkt_cnt;
+};
+
+
+/*
+ * FCoE RX statistics parameters section#1
+ */
+struct fcoe_rx_stat_params_section1 {
+	u32 fc_crc_cnt;
+	u32 eofa_del_cnt;
+	u32 miss_frame_cnt;
+	u32 seq_timeout_cnt;
+	u32 drop_seq_cnt;
+	u32 fcoe_rx_drop_pkt_cnt;
+	u32 fcp_rx_pkt_cnt;
+	u32 reserved0;
+};
+
+
+/*
+ * FCoE TX statistics parameters
+ */
+struct fcoe_tx_stat_params {
+	u32 fcoe_tx_pkt_cnt;
+	u32 fcoe_tx_byte_cnt;
+	u32 fcp_tx_pkt_cnt;
+	u32 reserved0;
+};
+
+/*
+ * FCoE statistics parameters
+ */
+struct fcoe_statistics_params {
+	struct fcoe_tx_stat_params tx_stat;
+	struct fcoe_rx_stat_params_section0 rx_stat0;
+	struct fcoe_rx_stat_params_section1 rx_stat1;
+};
+
+
+/*
+ * FCoE t2 hash table entry (64 bytes)
+ */
+struct fcoe_t2_hash_table_entry {
+	struct fcoe_hash_table_entry data;
+	struct regpair next;
+	struct regpair reserved0[3];
+};
+
+/*
+ * FCoE unsolicited CQE
+ */
+struct fcoe_unsolicited_cqe {
+	u16 wqe;
+#define FCOE_UNSOLICITED_CQE_SUBTYPE (0x3<<0)
+#define FCOE_UNSOLICITED_CQE_SUBTYPE_SHIFT 0
+#define FCOE_UNSOLICITED_CQE_PKT_LEN (0xFFF<<2)
+#define FCOE_UNSOLICITED_CQE_PKT_LEN_SHIFT 2
+#define FCOE_UNSOLICITED_CQE_CQE_TYPE (0x1<<14)
+#define FCOE_UNSOLICITED_CQE_CQE_TYPE_SHIFT 14
+#define FCOE_UNSOLICITED_CQE_TOGGLE_BIT (0x1<<15)
+#define FCOE_UNSOLICITED_CQE_TOGGLE_BIT_SHIFT 15
+};
+
+
+
+#endif /* __57XX_FCOE_HSI_LINUX_LE__ */
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
new file mode 100644
index 0000000..df546e3
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -0,0 +1,520 @@
+#ifndef _BNX2FC_H_
+#define _BNX2FC_H_
+/* bnx2fc.h: Broadcom NetXtreme II Linux FCoE offload driver.
+ *
+ * Copyright (c) 2008 - 2010 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/kthread.h>
+#include <linux/crc32.h>
+#include <linux/cpu.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/bitops.h>
+#include <linux/log2.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/libfc.h>
+#include <scsi/libfcoe.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fip.h>
+#include <scsi/fc/fc_fc2.h>
+#include <scsi/fc_frame.h>
+#include <scsi/fc/fc_fcoe.h>
+#include <scsi/fc/fc_fcp.h>
+
+#include "57xx_hsi_bnx2fc.h"
+#include "bnx2fc_debug.h"
+#include "../../net/cnic_if.h"
+#include "bnx2fc_constants.h"
+
+#define BNX2FC_NAME		"bnx2fc"
+#define BNX2FC_VERSION		"1.0.0"
+
+#define PFX			"bnx2fc: "
+
+#define BNX2X_DOORBELL_PCI_BAR		2
+
+#define BNX2FC_MAX_BD_LEN		0xffff
+#define BNX2FC_BD_SPLIT_SZ		0x8000
+#define BNX2FC_MAX_BDS_PER_CMD		256
+
+#define BNX2FC_SQ_WQES_MAX	256
+
+#define BNX2FC_SCSI_MAX_SQES	((3 * BNX2FC_SQ_WQES_MAX) / 8)
+#define BNX2FC_TM_MAX_SQES	((BNX2FC_SQ_WQES_MAX) / 2)
+#define BNX2FC_ELS_MAX_SQES	(BNX2FC_TM_MAX_SQES - 1)
+
+#define BNX2FC_RQ_WQES_MAX	16
+#define BNX2FC_CQ_WQES_MAX	(BNX2FC_SQ_WQES_MAX + BNX2FC_RQ_WQES_MAX)
+
+#define BNX2FC_NUM_MAX_SESS	128
+#define BNX2FC_NUM_MAX_SESS_LOG	(ilog2(BNX2FC_NUM_MAX_SESS))
+
+#define BNX2FC_MAX_OUTSTANDING_CMNDS	4096
+#define BNX2FC_MIN_PAYLOAD		256
+#define BNX2FC_MAX_PAYLOAD		2048
+
+#define BNX2FC_RQ_BUF_SZ		256
+#define BNX2FC_RQ_BUF_LOG_SZ		(ilog2(BNX2FC_RQ_BUF_SZ))
+
+#define BNX2FC_SQ_WQE_SIZE		(sizeof(struct fcoe_sqe))
+#define BNX2FC_CQ_WQE_SIZE		(sizeof(struct fcoe_cqe))
+#define BNX2FC_RQ_WQE_SIZE		(BNX2FC_RQ_BUF_SZ)
+#define BNX2FC_XFERQ_WQE_SIZE		(sizeof(struct fcoe_xfrqe))
+#define BNX2FC_CONFQ_WQE_SIZE		(sizeof(struct fcoe_confqe))
+#define BNX2FC_5771X_DB_PAGE_SIZE	128
+
+#define BNX2FC_MAX_TASKS		BNX2FC_MAX_OUTSTANDING_CMNDS
+#define BNX2FC_TASK_SIZE		128
+#define	BNX2FC_TASKS_PER_PAGE		(PAGE_SIZE/BNX2FC_TASK_SIZE)
+#define BNX2FC_TASK_CTX_ARR_SZ		(BNX2FC_MAX_TASKS/BNX2FC_TASKS_PER_PAGE)
+
+#define BNX2FC_MAX_ROWS_IN_HASH_TBL	8
+#define BNX2FC_HASH_TBL_CHUNK_SIZE	(16 * 1024)
+
+#define BNX2FC_MAX_SEQS			255
+
+#define BNX2FC_READ			(1 << 1)
+#define BNX2FC_WRITE			(1 << 0)
+
+#define BNX2FC_MIN_XID			0
+#define BNX2FC_MAX_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS - 1)
+#define FCOE_MIN_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS)
+#define FCOE_MAX_XID		\
+			(BNX2FC_MAX_OUTSTANDING_CMNDS + (nr_cpu_ids * 256))
+#define BNX2FC_MAX_LUN			0xFFFF
+#define BNX2FC_MAX_FCP_TGT		256
+#define BNX2FC_MAX_CMD_LEN		16
+
+#define BNX2FC_TM_TIMEOUT		60	/* secs */
+#define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
+
+#define BNX2FC_WAIT_CNT			120
+#define BNX2FC_FW_TIMEOUT		(3 * HZ)
+
+#define PORT_MAX			2
+
+#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
+
+/* FC FCP Status */
+#define	FC_GOOD				0
+
+#define BNX2FC_RNID_HBA			0x7
+
+struct bnx2fc_global_s {
+	struct task_struct *l2_thread;
+	struct sk_buff_head fcoe_rx_list;
+	struct page *crc_eof_page;
+	int crc_eof_offset;
+};
+extern struct bnx2fc_global_s bnx2fc_global;
+
+struct fcoe_percpu_s {
+	struct task_struct *thread;
+	struct list_head work_list;
+	spinlock_t fp_work_lock;
+};
+
+
+struct bnx2fc_hba {
+	struct list_head link;
+	struct cnic_dev *cnic;
+	struct pci_dev *pcidev;
+	struct net_device *netdev;
+	struct net_device *phys_dev;
+	unsigned long reg_with_cnic;
+		#define BNX2FC_CNIC_REGISTERED           1
+	struct packet_type fcoe_packet_type;
+	struct packet_type fip_packet_type;
+	struct bnx2fc_cmd_mgr *cmd_mgr;
+	struct workqueue_struct *timer_work_queue;
+	struct kref kref;
+	spinlock_t hba_lock;
+	struct mutex hba_mutex;
+	unsigned long adapter_state;
+		#define ADAPTER_STATE_UP		0
+		#define ADAPTER_STATE_GOING_DOWN	1
+		#define ADAPTER_STATE_LINK_DOWN		2
+		#define ADAPTER_STATE_READY		3
+	u32 flags;
+	unsigned long init_done;
+		#define BNX2FC_FW_INIT_DONE		0
+		#define BNX2FC_CTLR_INIT_DONE		1
+		#define BNX2FC_CREATE_DONE		2
+	struct fcoe_ctlr ctlr;
+	u8 vlan_enabled;
+	int vlan_id;
+	u32 next_conn_id;
+	struct fcoe_task_ctx_entry **task_ctx;
+	dma_addr_t *task_ctx_dma;
+	struct regpair *task_ctx_bd_tbl;
+	dma_addr_t task_ctx_bd_dma;
+
+	int hash_tbl_segment_count;
+	void **hash_tbl_segments;
+	void *hash_tbl_pbl;
+	dma_addr_t hash_tbl_pbl_dma;
+	struct fcoe_t2_hash_table_entry *t2_hash_tbl;
+	dma_addr_t t2_hash_tbl_dma;
+	char *t2_hash_tbl_ptr;
+	dma_addr_t t2_hash_tbl_ptr_dma;
+
+	char *dummy_buffer;
+	dma_addr_t dummy_buf_dma;
+
+	struct fcoe_statistics_params *stats_buffer;
+	dma_addr_t stats_buf_dma;
+
+	/*
+	 * PCI related info.
+	 */
+	u16 pci_did;
+	u16 pci_vid;
+	u16 pci_sdid;
+	u16 pci_svid;
+	u16 pci_func;
+	u16 pci_devno;
+
+	struct task_struct *l2_thread;
+
+	/* linkdown handling */
+	wait_queue_head_t shutdown_wait;
+	int wait_for_link_down;
+
+	/*destroy handling */
+	struct timer_list destroy_timer;
+	wait_queue_head_t destroy_wait;
+
+	/* Active list of offloaded sessions */
+	struct bnx2fc_rport *tgt_ofld_list[BNX2FC_NUM_MAX_SESS];
+	int num_ofld_sess;
+
+	/* statistics */
+	struct completion stat_req_done;
+};
+
+struct bnx2fc_port {
+	struct bnx2fc_hba *hba;
+	struct fc_lport *lport;
+	struct timer_list timer;
+	struct work_struct destroy_work;
+	struct sk_buff_head fcoe_pending_queue;
+	u8 fcoe_pending_queue_active;
+	u8 data_src_addr[ETH_ALEN];
+};
+
+#define bnx2fc_from_ctlr(fip) container_of(fip, struct bnx2fc_hba, ctlr)
+
+struct bnx2fc_cmd_mgr {
+	struct bnx2fc_hba *hba;
+	u16 next_idx;
+	struct list_head *free_list;
+	spinlock_t *free_list_lock;
+	struct io_bdt **io_bdt_pool;
+	struct bnx2fc_cmd **cmds;
+};
+
+struct bnx2fc_rport {
+	struct bnx2fc_port *port;
+	struct fc_rport *rport;
+	struct fc_rport_priv *rdata;
+	void __iomem *ctx_base;
+#define DPM_TRIGER_TYPE		0x40
+	u32 fcoe_conn_id;
+	u32 context_id;
+	u32 sid;
+
+	unsigned long flags;
+#define BNX2FC_FLAG_SESSION_READY	0x1
+#define BNX2FC_FLAG_OFFLOADED		0x2
+#define BNX2FC_FLAG_DISABLED		0x3
+#define BNX2FC_FLAG_DESTROYED		0x4
+#define BNX2FC_FLAG_OFLD_REQ_CMPL	0x5
+#define BNX2FC_FLAG_DESTROY_CMPL	0x6
+#define BNX2FC_FLAG_CTX_ALLOC_FAILURE	0x7
+#define BNX2FC_FLAG_UPLD_REQ_COMPL	0x8
+#define BNX2FC_FLAG_EXPL_LOGO		0x9
+
+	u32 max_sqes;
+	u32 max_rqes;
+	u32 max_cqes;
+
+	struct fcoe_sqe *sq;
+	dma_addr_t sq_dma;
+	u16 sq_prod_idx;
+	u8 sq_curr_toggle_bit;
+	u32 sq_mem_size;
+
+	struct fcoe_cqe *cq;
+	dma_addr_t cq_dma;
+	u32 cq_cons_idx;
+	u8 cq_curr_toggle_bit;
+	u32 cq_mem_size;
+
+	void *rq;
+	dma_addr_t rq_dma;
+	u32 rq_prod_idx;
+	u32 rq_cons_idx;
+	u32 rq_mem_size;
+
+	void *rq_pbl;
+	dma_addr_t rq_pbl_dma;
+	u32 rq_pbl_size;
+
+	struct fcoe_xfrqe *xferq;
+	dma_addr_t xferq_dma;
+	u32 xferq_mem_size;
+
+	struct fcoe_confqe *confq;
+	dma_addr_t confq_dma;
+	u32 confq_mem_size;
+
+	void *confq_pbl;
+	dma_addr_t confq_pbl_dma;
+	u32 confq_pbl_size;
+
+	struct fcoe_conn_db *conn_db;
+	dma_addr_t conn_db_dma;
+	u32 conn_db_mem_size;
+
+	struct fcoe_sqe *lcq;
+	dma_addr_t lcq_dma;
+	u32 lcq_mem_size;
+
+	void *ofld_req[4];
+	dma_addr_t ofld_req_dma[4];
+	void *enbl_req;
+	dma_addr_t enbl_req_dma;
+
+	spinlock_t tgt_lock;
+	spinlock_t cq_lock;
+	atomic_t num_active_ios;
+	u32 flush_in_prog;
+	unsigned long work_time_slice;
+	unsigned long timestamp;
+	struct list_head free_task_list;
+	struct bnx2fc_cmd *pending_queue[BNX2FC_SQ_WQES_MAX+1];
+	atomic_t pi;
+	atomic_t ci;
+	struct list_head active_cmd_queue;
+	struct list_head els_queue;
+	struct list_head io_retire_queue;
+	struct list_head active_tm_queue;
+
+	struct timer_list ofld_timer;
+	wait_queue_head_t ofld_wait;
+
+	struct timer_list upld_timer;
+	wait_queue_head_t upld_wait;
+};
+
+struct bnx2fc_mp_req {
+	u8 tm_flags;
+
+	u32 req_len;
+	void *req_buf;
+	dma_addr_t req_buf_dma;
+	struct fcoe_bd_ctx *mp_req_bd;
+	dma_addr_t mp_req_bd_dma;
+	struct fc_frame_header req_fc_hdr;
+
+	u32 resp_len;
+	void *resp_buf;
+	dma_addr_t resp_buf_dma;
+	struct fcoe_bd_ctx *mp_resp_bd;
+	dma_addr_t mp_resp_bd_dma;
+	struct fc_frame_header resp_fc_hdr;
+};
+
+struct bnx2fc_els_cb_arg {
+	struct bnx2fc_cmd *aborted_io_req;
+	struct bnx2fc_cmd *io_req;
+	u16 l2_oxid;
+};
+
+/* bnx2fc command structure */
+struct bnx2fc_cmd {
+	struct list_head link;
+	u8 on_active_queue;
+	u8 on_tmf_queue;
+	u8 cmd_type;
+#define BNX2FC_SCSI_CMD		1
+#define BNX2FC_TASK_MGMT_CMD		2
+#define BNX2FC_ABTS			3
+#define BNX2FC_ELS			4
+#define BNX2FC_CLEANUP			5
+	u8 io_req_flags;
+	struct kref refcount;
+	struct bnx2fc_port *port;
+	struct bnx2fc_rport *tgt;
+	struct scsi_cmnd *sc_cmd;
+	struct bnx2fc_cmd_mgr *cmd_mgr;
+	struct bnx2fc_mp_req mp_req;
+	void (*cb_func)(struct bnx2fc_els_cb_arg *cb_arg);
+	struct bnx2fc_els_cb_arg *cb_arg;
+	struct delayed_work timeout_work; /* timer for ULP timeouts */
+	struct completion tm_done;
+	int wait_for_comp;
+	u16 xid;
+	struct fcoe_task_ctx_entry *task;
+	struct io_bdt *bd_tbl;
+	struct fcp_rsp *rsp;
+	size_t data_xfer_len;
+	unsigned long req_flags;
+#define BNX2FC_FLAG_ISSUE_RRQ		0x1
+#define BNX2FC_FLAG_ISSUE_ABTS		0x2
+#define BNX2FC_FLAG_ABTS_DONE		0x3
+#define BNX2FC_FLAG_TM_COMPL		0x4
+#define BNX2FC_FLAG_TM_TIMEOUT		0x5
+#define BNX2FC_FLAG_IO_CLEANUP		0x6
+#define BNX2FC_FLAG_RETIRE_OXID		0x7
+#define	BNX2FC_FLAG_EH_ABORT		0x8
+#define BNX2FC_FLAG_IO_COMPL		0x9
+#define BNX2FC_FLAG_ELS_DONE		0xa
+#define BNX2FC_FLAG_ELS_TIMEOUT		0xb
+	u32 fcp_resid;
+	u32 fcp_rsp_len;
+	u32 fcp_sns_len;
+	u8 cdb_status; /* SCSI IO status */
+	u8 fcp_status; /* FCP IO status */
+	u8 fcp_rsp_code;
+	u8 scsi_comp_flags;
+};
+
+struct io_bdt {
+	struct bnx2fc_cmd *io_req;
+	struct fcoe_bd_ctx *bd_tbl;
+	dma_addr_t bd_tbl_dma;
+	u16 bd_valid;
+};
+
+struct bnx2fc_work {
+	struct list_head list;
+	struct bnx2fc_rport *tgt;
+	u16 wqe;
+};
+
+
+
+struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type);
+void bnx2fc_cmd_release(struct kref *ref);
+int bnx2fc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd);
+int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba);
+int bnx2fc_send_fw_fcoe_destroy_msg(struct bnx2fc_hba *hba);
+int bnx2fc_send_session_ofld_req(struct bnx2fc_port *port,
+					struct bnx2fc_rport *tgt);
+int bnx2fc_send_session_disable_req(struct bnx2fc_port *port,
+				    struct bnx2fc_rport *tgt);
+int bnx2fc_send_session_destroy_req(struct bnx2fc_hba *hba,
+					struct bnx2fc_rport *tgt);
+void bnx2fc_map_doorbell(struct bnx2fc_rport *tgt);
+void bnx2fc_indicate_kcqe(void *context, struct kcqe *kcq[],
+					u32 num_cqe);
+int bnx2fc_setup_task_ctx(struct bnx2fc_hba *hba);
+void bnx2fc_free_task_ctx(struct bnx2fc_hba *hba);
+int bnx2fc_setup_fw_resc(struct bnx2fc_hba *hba);
+void bnx2fc_free_fw_resc(struct bnx2fc_hba *hba);
+struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
+						u16 min_xid, u16 max_xid);
+void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr);
+void bnx2fc_get_link_state(struct bnx2fc_hba *hba);
+char *bnx2fc_get_next_rqe(struct bnx2fc_rport *tgt, u8 num_items);
+void bnx2fc_return_rqe(struct bnx2fc_rport *tgt, u8 num_items);
+int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen);
+void bnx2fc_fill_fc_hdr(struct fc_frame_header *fc_hdr, enum fc_rctl r_ctl,
+			u32 sid, u32 did, enum fc_fh_type fh_type,
+			u32 f_ctl, u32 param_offset);
+int bnx2fc_send_rrq(struct bnx2fc_cmd *aborted_io_req);
+int bnx2fc_send_adisc(struct bnx2fc_rport *tgt, struct fc_frame *fp);
+int bnx2fc_send_logo(struct bnx2fc_rport *tgt, struct fc_frame *fp);
+int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req);
+int bnx2fc_initiate_abts(struct bnx2fc_cmd *io_req);
+void bnx2fc_cmd_timer_set(struct bnx2fc_cmd *io_req,
+			  unsigned int timer_msec);
+int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req);
+void bnx2fc_init_cleanup_task(struct bnx2fc_cmd *io_req,
+			      struct fcoe_task_ctx_entry *task,
+			      u16 orig_xid);
+void bnx2fc_init_mp_task(struct bnx2fc_cmd *io_req,
+			 struct fcoe_task_ctx_entry *task);
+void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
+			     struct fcoe_task_ctx_entry *task);
+void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
+void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
+int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
+void bnx2fc_rport_event_handler(struct fc_lport *lport,
+				struct fc_rport_priv *rport,
+				enum fc_rport_event event);
+void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
+				   struct fcoe_task_ctx_entry *task,
+				   u8 num_rq);
+void bnx2fc_process_cleanup_compl(struct bnx2fc_cmd *io_req,
+			       struct fcoe_task_ctx_entry *task,
+			       u8 num_rq);
+void bnx2fc_process_abts_compl(struct bnx2fc_cmd *io_req,
+			       struct fcoe_task_ctx_entry *task,
+			       u8 num_rq);
+void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
+			     struct fcoe_task_ctx_entry *task,
+			     u8 num_rq);
+void bnx2fc_process_els_compl(struct bnx2fc_cmd *els_req,
+			      struct fcoe_task_ctx_entry *task,
+			      u8 num_rq);
+void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
+			   struct fcp_cmnd *fcp_cmnd);
+
+
+
+void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt);
+struct fc_seq *bnx2fc_elsct_send(struct fc_lport *lport, u32 did,
+				      struct fc_frame *fp, unsigned int op,
+				      void (*resp)(struct fc_seq *,
+						   struct fc_frame *,
+						   void *),
+				      void *arg, u32 timeout);
+int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt);
+void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe);
+struct bnx2fc_rport *bnx2fc_tgt_lookup(struct bnx2fc_port *port,
+					     u32 port_id);
+void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
+				   unsigned char *buf,
+				   u32 frame_len, u16 l2_oxid);
+int bnx2fc_send_stat_req(struct bnx2fc_hba *hba);
+
+#endif
diff --git a/drivers/scsi/bnx2fc/bnx2fc_constants.h b/drivers/scsi/bnx2fc/bnx2fc_constants.h
new file mode 100644
index 0000000..fe77691
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc_constants.h
@@ -0,0 +1,206 @@
+#ifndef __BNX2FC_CONSTANTS_H_
+#define __BNX2FC_CONSTANTS_H_
+
+/**
+ * This file defines HSI constants for the FCoE flows
+ */
+
+/* KWQ/KCQ FCoE layer code */
+#define FCOE_KWQE_LAYER_CODE   (7)
+
+/* KWQ (kernel work queue) request op codes */
+#define FCOE_KWQE_OPCODE_INIT1			(0)
+#define FCOE_KWQE_OPCODE_INIT2			(1)
+#define FCOE_KWQE_OPCODE_INIT3			(2)
+#define FCOE_KWQE_OPCODE_OFFLOAD_CONN1	(3)
+#define FCOE_KWQE_OPCODE_OFFLOAD_CONN2	(4)
+#define FCOE_KWQE_OPCODE_OFFLOAD_CONN3	(5)
+#define FCOE_KWQE_OPCODE_OFFLOAD_CONN4	(6)
+#define FCOE_KWQE_OPCODE_ENABLE_CONN	(7)
+#define FCOE_KWQE_OPCODE_DISABLE_CONN	(8)
+#define FCOE_KWQE_OPCODE_DESTROY_CONN	(9)
+#define FCOE_KWQE_OPCODE_DESTROY		(10)
+#define FCOE_KWQE_OPCODE_STAT			(11)
+
+/* KCQ (kernel completion queue) response op codes */
+#define FCOE_KCQE_OPCODE_INIT_FUNC				(0x10)
+#define FCOE_KCQE_OPCODE_DESTROY_FUNC			(0x11)
+#define FCOE_KCQE_OPCODE_STAT_FUNC				(0x12)
+#define FCOE_KCQE_OPCODE_OFFLOAD_CONN			(0x15)
+#define FCOE_KCQE_OPCODE_ENABLE_CONN			(0x16)
+#define FCOE_KCQE_OPCODE_DISABLE_CONN			(0x17)
+#define FCOE_KCQE_OPCODE_DESTROY_CONN			(0x18)
+#define FCOE_KCQE_OPCODE_CQ_EVENT_NOTIFICATION  (0x20)
+#define FCOE_KCQE_OPCODE_FCOE_ERROR				(0x21)
+
+/* KCQ (kernel completion queue) completion status */
+#define FCOE_KCQE_COMPLETION_STATUS_SUCCESS				(0x0)
+#define FCOE_KCQE_COMPLETION_STATUS_ERROR				(0x1)
+#define FCOE_KCQE_COMPLETION_STATUS_INVALID_OPCODE		(0x2)
+#define FCOE_KCQE_COMPLETION_STATUS_CTX_ALLOC_FAILURE	(0x3)
+#define FCOE_KCQE_COMPLETION_STATUS_CTX_FREE_FAILURE	(0x4)
+#define FCOE_KCQE_COMPLETION_STATUS_NIC_ERROR			(0x5)
+
+/* Unsolicited CQE type */
+#define FCOE_UNSOLICITED_FRAME_CQE_TYPE			0
+#define FCOE_ERROR_DETECTION_CQE_TYPE			1
+#define FCOE_WARNING_DETECTION_CQE_TYPE			2
+
+/* Task context constants */
+/* After driver has initialize the task in case timer services required */
+#define	FCOE_TASK_TX_STATE_INIT					0
+/* In case timer services are required then shall be updated by Xstorm after
+ * start processing the task. In case no timer facilities are required then the
+ * driver would initialize the state to this value */
+#define	FCOE_TASK_TX_STATE_NORMAL				1
+/* Task is under abort procedure. Updated in order to stop processing of
+ * pending WQEs on this task */
+#define	FCOE_TASK_TX_STATE_ABORT				2
+/* For E_D_T_TOV timer expiration in Xstorm (Class 2 only) */
+#define	FCOE_TASK_TX_STATE_ERROR				3
+/* For REC_TOV timer expiration indication received from Xstorm */
+#define	FCOE_TASK_TX_STATE_WARNING				4
+/* For completed unsolicited task */
+#define	FCOE_TASK_TX_STATE_UNSOLICITED_COMPLETED		5
+/* For exchange cleanup request task */
+#define	FCOE_TASK_TX_STATE_EXCHANGE_CLEANUP			6
+/* For sequence cleanup request task */
+#define	FCOE_TASK_TX_STATE_SEQUENCE_CLEANUP			7
+/* Mark task as aborted and indicate that ABTS was not transmitted */
+#define	FCOE_TASK_TX_STATE_BEFORE_ABTS_TX			8
+/* Mark task as aborted and indicate that ABTS was transmitted */
+#define	FCOE_TASK_TX_STATE_AFTER_ABTS_TX			9
+/* For completion the ABTS task. */
+#define	FCOE_TASK_TX_STATE_ABTS_TX_COMPLETED			10
+/* Mark task as aborted and indicate that Exchange cleanup was not transmitted
+ */
+#define	FCOE_TASK_TX_STATE_BEFORE_EXCHANGE_CLEANUP_TX		11
+/* Mark task as aborted and indicate that Exchange cleanup was transmitted */
+#define	FCOE_TASK_TX_STATE_AFTER_EXCHANGE_CLEANUP_TX		12
+
+#define	FCOE_TASK_RX_STATE_NORMAL				0
+#define	FCOE_TASK_RX_STATE_COMPLETED				1
+/* Obsolete: Intermediate completion (middle path with local completion) */
+#define	FCOE_TASK_RX_STATE_INTER_COMP				2
+/* For REC_TOV timer expiration indication received from Xstorm */
+#define	FCOE_TASK_RX_STATE_WARNING				3
+/* For E_D_T_TOV timer expiration in Ustorm */
+#define	FCOE_TASK_RX_STATE_ERROR				4
+/* ABTS ACC arrived wait for local completion to finally complete the task. */
+#define	FCOE_TASK_RX_STATE_ABTS_ACC_ARRIVED			5
+/* local completion arrived wait for ABTS ACC to finally complete the task. */
+#define	FCOE_TASK_RX_STATE_ABTS_LOCAL_COMP_ARRIVED		6
+/* Special completion indication in case of task was aborted. */
+#define FCOE_TASK_RX_STATE_ABTS_COMPLETED			7
+/* Special completion indication in case of task was cleaned. */
+#define FCOE_TASK_RX_STATE_EXCHANGE_CLEANUP_COMPLETED		8
+/* Special completion indication (in task requested the exchange cleanup) in
+ * case cleaned task is in non-valid. */
+#define FCOE_TASK_RX_STATE_ABORT_CLEANUP_COMPLETED		9
+/* Special completion indication (in task requested the sequence cleanup) in
+ * case cleaned task was already returned to normal. */
+#define FCOE_TASK_RX_STATE_IGNORED_SEQUENCE_CLEANUP		10
+/* Exchange cleanup arrived wait until xfer will be handled to finally
+ * complete the task. */
+#define	FCOE_TASK_RX_STATE_EXCHANGE_CLEANUP_ARRIVED		11
+/* Xfer handled, wait for exchange cleanup to finally complete the task. */
+#define	FCOE_TASK_RX_STATE_EXCHANGE_CLEANUP_HANDLED_XFER	12
+
+#define	FCOE_TASK_TYPE_WRITE			0
+#define	FCOE_TASK_TYPE_READ				1
+#define	FCOE_TASK_TYPE_MIDPATH			2
+#define	FCOE_TASK_TYPE_UNSOLICITED		3
+#define	FCOE_TASK_TYPE_ABTS				4
+#define	FCOE_TASK_TYPE_EXCHANGE_CLEANUP	5
+#define	FCOE_TASK_TYPE_SEQUENCE_CLEANUP	6
+
+#define FCOE_TASK_DEV_TYPE_DISK			0
+#define FCOE_TASK_DEV_TYPE_TAPE			1
+
+#define FCOE_TASK_CLASS_TYPE_3			0
+#define FCOE_TASK_CLASS_TYPE_2			1
+
+/* Everest FCoE connection type */
+#define B577XX_FCOE_CONNECTION_TYPE		4
+
+/* Error codes for Error Reporting in fast path flows */
+/* XFER error codes */
+#define FCOE_ERROR_CODE_XFER_OOO_RO					0
+#define FCOE_ERROR_CODE_XFER_RO_NOT_ALIGNED				1
+#define FCOE_ERROR_CODE_XFER_NULL_BURST_LEN				2
+#define FCOE_ERROR_CODE_XFER_RO_GREATER_THAN_DATA2TRNS			3
+#define FCOE_ERROR_CODE_XFER_INVALID_PAYLOAD_SIZE			4
+#define FCOE_ERROR_CODE_XFER_TASK_TYPE_NOT_WRITE			5
+#define FCOE_ERROR_CODE_XFER_PEND_XFER_SET				6
+#define FCOE_ERROR_CODE_XFER_OPENED_SEQ					7
+#define FCOE_ERROR_CODE_XFER_FCTL					8
+
+/* FCP RSP error codes */
+#define FCOE_ERROR_CODE_FCP_RSP_BIDI_FLAGS_SET				9
+#define FCOE_ERROR_CODE_FCP_RSP_UNDERFLOW				10
+#define FCOE_ERROR_CODE_FCP_RSP_OVERFLOW				11
+#define FCOE_ERROR_CODE_FCP_RSP_INVALID_LENGTH_FIELD			12
+#define FCOE_ERROR_CODE_FCP_RSP_INVALID_SNS_FIELD			13
+#define FCOE_ERROR_CODE_FCP_RSP_INVALID_PAYLOAD_SIZE			14
+#define FCOE_ERROR_CODE_FCP_RSP_PEND_XFER_SET				15
+#define FCOE_ERROR_CODE_FCP_RSP_OPENED_SEQ				16
+#define FCOE_ERROR_CODE_FCP_RSP_FCTL					17
+#define FCOE_ERROR_CODE_FCP_RSP_LAST_SEQ_RESET				18
+#define FCOE_ERROR_CODE_FCP_RSP_CONF_REQ_NOT_SUPPORTED_YET		19
+
+/* FCP DATA error codes */
+#define FCOE_ERROR_CODE_DATA_OOO_RO					20
+#define FCOE_ERROR_CODE_DATA_EXCEEDS_DEFINED_MAX_FRAME_SIZE		21
+#define FCOE_ERROR_CODE_DATA_EXCEEDS_DATA2TRNS				22
+#define FCOE_ERROR_CODE_DATA_SOFI3_SEQ_ACTIVE_SET			23
+#define FCOE_ERROR_CODE_DATA_SOFN_SEQ_ACTIVE_RESET			24
+#define FCOE_ERROR_CODE_DATA_EOFN_END_SEQ_SET				25
+#define FCOE_ERROR_CODE_DATA_EOFT_END_SEQ_RESET			26
+#define FCOE_ERROR_CODE_DATA_TASK_TYPE_NOT_READ			27
+#define FCOE_ERROR_CODE_DATA_FCTL					28
+
+/* Middle path error codes */
+#define FCOE_ERROR_CODE_MIDPATH_TYPE_NOT_ELS				29
+#define FCOE_ERROR_CODE_MIDPATH_SOFI3_SEQ_ACTIVE_SET			30
+#define FCOE_ERROR_CODE_MIDPATH_SOFN_SEQ_ACTIVE_RESET			31
+#define FCOE_ERROR_CODE_MIDPATH_EOFN_END_SEQ_SET			32
+#define FCOE_ERROR_CODE_MIDPATH_EOFT_END_SEQ_RESET			33
+#define FCOE_ERROR_CODE_MIDPATH_ELS_REPLY_FCTL				34
+#define FCOE_ERROR_CODE_MIDPATH_INVALID_REPLY				35
+#define FCOE_ERROR_CODE_MIDPATH_ELS_REPLY_RCTL				36
+
+/* ABTS error codes */
+#define FCOE_ERROR_CODE_ABTS_REPLY_F_CTL				37
+#define FCOE_ERROR_CODE_ABTS_REPLY_DDF_RCTL_FIELD			38
+#define FCOE_ERROR_CODE_ABTS_REPLY_INVALID_BLS_RCTL			39
+#define FCOE_ERROR_CODE_ABTS_REPLY_INVALID_RCTL			40
+#define FCOE_ERROR_CODE_ABTS_REPLY_RCTL_GENERAL_MISMATCH		41
+
+/* Common error codes */
+#define FCOE_ERROR_CODE_COMMON_MIDDLE_FRAME_WITH_PAD			42
+#define FCOE_ERROR_CODE_COMMON_SEQ_INIT_IN_TCE				43
+#define FCOE_ERROR_CODE_COMMON_FC_HDR_RX_ID_MISMATCH			44
+#define FCOE_ERROR_CODE_COMMON_INCORRECT_SEQ_CNT			45
+#define FCOE_ERROR_CODE_COMMON_DATA_FC_HDR_FCP_TYPE_MISMATCH		46
+#define FCOE_ERROR_CODE_COMMON_DATA_NO_MORE_SGES			47
+#define FCOE_ERROR_CODE_COMMON_OPTIONAL_FC_HDR				48
+#define FCOE_ERROR_CODE_COMMON_READ_TCE_OX_ID_TOO_BIG			49
+#define FCOE_ERROR_CODE_COMMON_DATA_WAS_NOT_TRANSMITTED		50
+
+/* Unsolicited Rx error codes */
+#define FCOE_ERROR_CODE_UNSOLICITED_TYPE_NOT_ELS			51
+#define FCOE_ERROR_CODE_UNSOLICITED_TYPE_NOT_BLS			52
+#define FCOE_ERROR_CODE_UNSOLICITED_FCTL_ELS				53
+#define FCOE_ERROR_CODE_UNSOLICITED_FCTL_BLS				54
+#define FCOE_ERROR_CODE_UNSOLICITED_R_CTL				55
+
+#define FCOE_ERROR_CODE_RW_TASK_DDF_RCTL_INFO_FIELD			56
+#define FCOE_ERROR_CODE_RW_TASK_INVALID_RCTL				57
+#define FCOE_ERROR_CODE_RW_TASK_RCTL_GENERAL_MISMATCH			58
+
+/* Timer error codes */
+#define FCOE_ERROR_CODE_E_D_TOV_TIMER_EXPIRATION			60
+#define FCOE_ERROR_CODE_REC_TOV_TIMER_EXPIRATION			61
+
+
+#endif /* BNX2FC_CONSTANTS_H_ */
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
new file mode 100644
index 0000000..9abbdd0
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
@@ -0,0 +1,68 @@
+#ifndef __BNX2FC_DEBUG__
+#define __BNX2FC_DEBUG__
+
+/* Log level bit mask */
+#define LOG_IO		0x01	/* scsi cmd error, cleanup */
+#define LOG_TGT		0x02	/* Session setup, cleanup, etc' */
+#define LOG_HBA		0x04	/* lport events, link, mtu, etc' */
+#define LOG_ELS		0x08	/* ELS logs */
+#define LOG_MISC	0x10	/* fcoe L2 frame related logs*/
+#define LOG_ALL		0xff	/* LOG all messages */
+
+extern unsigned int bnx2fc_debug_level;
+
+#define BNX2FC_CHK_LOGGING(LEVEL, CMD)					\
+	do {								\
+		if (unlikely(bnx2fc_debug_level & LEVEL))		\
+			do {						\
+				CMD;					\
+			} while (0);					\
+	} while (0)
+
+#define BNX2FC_ELS_DBG(fmt, arg...)					\
+	BNX2FC_CHK_LOGGING(LOG_ELS,					\
+			   printk(KERN_ALERT PFX fmt, ##arg))
+
+#define BNX2FC_MISC_DBG(fmt, arg...)					\
+	BNX2FC_CHK_LOGGING(LOG_MISC,					\
+			   printk(KERN_ALERT PFX fmt, ##arg))
+
+#define BNX2FC_IO_DBG(io_req, fmt, arg...)				\
+	do {								\
+		if (!io_req || !io_req->port || !io_req->port->lport ||	\
+		    !io_req->port->lport->host)				\
+			BNX2FC_CHK_LOGGING(LOG_IO,			\
+			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+		else							\
+			BNX2FC_CHK_LOGGING(LOG_IO,			\
+			   printk(KERN_ALERT PFX "host%u: xid:0x%x " fmt,\
+				  (io_req)->port->lport->host->host_no,	\
+				  (io_req)->xid, ##arg));		\
+	} while (0)
+
+#define BNX2FC_TGT_DBG(tgt, fmt, arg...)				\
+	do {								\
+		if (!tgt || !tgt->port || !tgt->port->lport ||		\
+		    !tgt->port->lport->host || !tgt->rport)		\
+			BNX2FC_CHK_LOGGING(LOG_TGT,			\
+			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+		else							\
+			BNX2FC_CHK_LOGGING(LOG_TGT,			\
+			   printk(KERN_ALERT PFX "host%u: port:%x " fmt,\
+				  (tgt)->port->lport->host->host_no,	\
+				  (tgt)->rport->port_id, ##arg));	\
+	} while (0)
+
+
+#define BNX2FC_HBA_DBG(lport, fmt, arg...)				\
+	do {								\
+		if (!lport || !lport->host)				\
+			BNX2FC_CHK_LOGGING(LOG_HBA,			\
+			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+		else							\
+			BNX2FC_CHK_LOGGING(LOG_HBA,			\
+			   printk(KERN_ALERT PFX "host%u: " fmt,	\
+				  lport->host->host_no, ##arg));	\
+	} while (0)
+
+#endif
-- 
1.7.0.6




