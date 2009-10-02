From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 2/6] lpfc 8.3.5: MIsc patch set part 2
Date: Fri, 2 Oct 2009 15:16:45 -0400
Message-ID: <1254511005.32739.19.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63984 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbZJBT6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:58:55 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92JwxOj026942
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:58:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch includes the following fixes and new features:
- Fix mask size for CT field in WQE
- Fix VPI base not used when unregistering VPI on port 1.
- Fix UNREG_VPI mailbox command to unreg the correct VPI
- Fixed Check for aborted els command
- Fix error when trying to load driver with wrong firmware on FCoE HBA.
- Fix bug with probe_one routines not putting the Scsi_Host back upon error
- Add support for Clear Virtual Link Async Events
- Add support for unsolicited CT exchange sequence abort
- Add 0x0714 OCeXXXXX PCI ID


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    5 -
 lpfc_ct.c      |   34 +++++++
 lpfc_els.c     |   12 +-
 lpfc_hbadisc.c |    2 
 lpfc_hw.h      |   10 +-
 lpfc_hw4.h     |   89 ++++++++++++++++---
 lpfc_init.c    |  107 +++++++++++++++++++++-
 lpfc_mbox.c    |   12 +-
 lpfc_sli.c     |  267 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lpfc_sli.h     |    2 
 lpfc_sli4.h    |    5 +
 11 files changed, 498 insertions(+), 47 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-10-01 17:20:57.000000000 -0400
@@ -144,6 +144,8 @@ void lpfc_hb_timeout_handler(struct lpfc
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			 struct lpfc_iocbq *);
+void lpfc_sli4_ct_abort_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
+				    struct lpfc_iocbq *);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_fdmi_tmo(unsigned long);
@@ -188,7 +190,7 @@ int lpfc_mbox_tmo_val(struct lpfc_hba *,
 void lpfc_init_vfi(struct lpfcMboxq *, struct lpfc_vport *);
 void lpfc_reg_vfi(struct lpfcMboxq *, struct lpfc_vport *, dma_addr_t);
 void lpfc_init_vpi(struct lpfc_hba *, struct lpfcMboxq *, uint16_t);
-void lpfc_unreg_vfi(struct lpfcMboxq *, uint16_t);
+void lpfc_unreg_vfi(struct lpfcMboxq *, struct lpfc_vport *);
 void lpfc_reg_fcfi(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
 void lpfc_resume_rpi(struct lpfcMboxq *, struct lpfc_nodelist *);
@@ -361,6 +363,7 @@ void lpfc_stop_port(struct lpfc_hba *);
 void lpfc_parse_fcoe_conf(struct lpfc_hba *, uint8_t *, uint32_t);
 int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 void lpfc_start_fdiscs(struct lpfc_hba *phba);
+struct lpfc_vport *lpfc_find_vport_by_vpid(struct lpfc_hba *, uint16_t);
 
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2009-10-01 17:20:57.000000000 -0400
@@ -87,7 +87,6 @@ void
 lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocbq)
 {
-
 	struct lpfc_dmabuf *mp = NULL;
 	IOCB_t *icmd = &piocbq->iocb;
 	int i;
@@ -160,6 +159,39 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 	}
 }
 
+/**
+ * lpfc_sli4_ct_abort_unsol_event - Default handle for sli4 unsol abort
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to the driver internal I/O ring.
+ * @piocbq: Pointer to the IOCBQ.
+ *
+ * This function serves as the default handler for the sli4 unsolicited
+ * abort event. It shall be invoked when there is no application interface
+ * registered unsolicited abort handler. This handler does nothing but
+ * just simply releases the dma buffer used by the unsol abort event.
+ **/
+void
+lpfc_sli4_ct_abort_unsol_event(struct lpfc_hba *phba,
+			       struct lpfc_sli_ring *pring,
+			       struct lpfc_iocbq *piocbq)
+{
+	IOCB_t *icmd = &piocbq->iocb;
+	struct lpfc_dmabuf *bdeBuf;
+	uint32_t size;
+
+	/* Forward abort event to any process registered to receive ct event */
+	lpfc_bsg_ct_unsol_event(phba, pring, piocbq);
+
+	/* If there is no BDE associated with IOCB, there is nothing to do */
+	if (icmd->ulpBdeCount == 0)
+		return;
+	bdeBuf = piocbq->context2;
+	piocbq->context2 = NULL;
+	size  = icmd->un.cont64[0].tus.f.bdeSize;
+	lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf, size);
+	lpfc_in_buf_free(phba, bdeBuf);
+}
+
 static void
 lpfc_free_ct_rsp(struct lpfc_hba *phba, struct lpfc_dmabuf *mlist)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-10-01 17:20:57.000000000 -0400
@@ -2712,12 +2712,16 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	    !lpfc_error_lost_link(irsp)) {
 		/* FLOGI retry policy */
 		retry = 1;
-		maxretry = 48;
-		if (cmdiocb->retry >= 32)
+		/* retry forever */
+		maxretry = 0;
+		if (cmdiocb->retry >= 100)
+			delay = 5000;
+		else if (cmdiocb->retry >= 32)
 			delay = 1000;
 	}
 
-	if ((++cmdiocb->retry) >= maxretry) {
+	cmdiocb->retry++;
+	if (maxretry && (cmdiocb->retry >= maxretry)) {
 		phba->fc_stat.elsRetryExceeded++;
 		retry = 0;
 	}
@@ -5671,7 +5675,7 @@ dropit:
  *    NULL - No vport with the matching @vpi found
  *    Otherwise - Address to the vport with the matching @vpi.
  **/
-static struct lpfc_vport *
+struct lpfc_vport *
 lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 {
 	struct lpfc_vport *vport;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:20:57.000000000 -0400
@@ -4474,7 +4474,7 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 		return;
 	}
 
-	lpfc_unreg_vfi(mbox, phba->pport->vfi);
+	lpfc_unreg_vfi(mbox, phba->pport);
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_unregister_vfi_cmpl;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2009-10-01 17:20:57.000000000 -0400
@@ -425,7 +425,7 @@ struct lpfc_wqe_generic{
 #define lpfc_wqe_gen_status_MASK	0x0000000F
 #define lpfc_wqe_gen_status_WORD	word7
 #define lpfc_wqe_gen_ct_SHIFT		2
-#define lpfc_wqe_gen_ct_MASK		0x00000007
+#define lpfc_wqe_gen_ct_MASK		0x00000003
 #define lpfc_wqe_gen_ct_WORD		word7
 	uint32_t abort_tag;
 	uint32_t word9;
@@ -760,6 +760,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_MQ_DESTROY		0x35
 #define LPFC_MBOX_OPCODE_CQ_DESTROY		0x36
 #define LPFC_MBOX_OPCODE_EQ_DESTROY		0x37
+#define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
 
 /* FCoE Opcodes */
@@ -1273,6 +1274,51 @@ struct lpfc_mbx_del_fcf_tbl_entry {
 #define lpfc_mbx_del_fcf_tbl_index_WORD		word10
 };
 
+struct lpfc_mbx_query_fw_cfg {
+	struct mbox_header header;
+	uint32_t config_number;
+	uint32_t asic_rev;
+	uint32_t phys_port;
+	uint32_t function_mode;
+/* firmware Function Mode */
+#define lpfc_function_mode_toe_SHIFT		0
+#define lpfc_function_mode_toe_MASK		0x00000001
+#define lpfc_function_mode_toe_WORD		function_mode
+#define lpfc_function_mode_nic_SHIFT		1
+#define lpfc_function_mode_nic_MASK		0x00000001
+#define lpfc_function_mode_nic_WORD		function_mode
+#define lpfc_function_mode_rdma_SHIFT		2
+#define lpfc_function_mode_rdma_MASK		0x00000001
+#define lpfc_function_mode_rdma_WORD		function_mode
+#define lpfc_function_mode_vm_SHIFT		3
+#define lpfc_function_mode_vm_MASK		0x00000001
+#define lpfc_function_mode_vm_WORD		function_mode
+#define lpfc_function_mode_iscsi_i_SHIFT	4
+#define lpfc_function_mode_iscsi_i_MASK		0x00000001
+#define lpfc_function_mode_iscsi_i_WORD		function_mode
+#define lpfc_function_mode_iscsi_t_SHIFT	5
+#define lpfc_function_mode_iscsi_t_MASK		0x00000001
+#define lpfc_function_mode_iscsi_t_WORD		function_mode
+#define lpfc_function_mode_fcoe_i_SHIFT		6
+#define lpfc_function_mode_fcoe_i_MASK		0x00000001
+#define lpfc_function_mode_fcoe_i_WORD		function_mode
+#define lpfc_function_mode_fcoe_t_SHIFT		7
+#define lpfc_function_mode_fcoe_t_MASK		0x00000001
+#define lpfc_function_mode_fcoe_t_WORD		function_mode
+#define lpfc_function_mode_dal_SHIFT		8
+#define lpfc_function_mode_dal_MASK		0x00000001
+#define lpfc_function_mode_dal_WORD		function_mode
+#define lpfc_function_mode_lro_SHIFT		9
+#define lpfc_function_mode_lro_MASK		0x00000001
+#define lpfc_function_mode_lro_WORD		function_mode9
+#define lpfc_function_mode_flex10_SHIFT		10
+#define lpfc_function_mode_flex10_MASK		0x00000001
+#define lpfc_function_mode_flex10_WORD		function_mode
+#define lpfc_function_mode_ncsi_SHIFT		11
+#define lpfc_function_mode_ncsi_MASK		0x00000001
+#define lpfc_function_mode_ncsi_WORD		function_mode
+};
+
 /* Status field for embedded SLI_CONFIG mailbox command */
 #define STATUS_SUCCESS					0x0
 #define STATUS_FAILED 					0x1
@@ -1804,6 +1850,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_read_config rd_config;
 		struct lpfc_mbx_request_features req_ftrs;
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
+		struct lpfc_mbx_query_fw_cfg query_fw_cfg;
 		struct lpfc_mbx_nop nop;
 	} un;
 };
@@ -1885,7 +1932,7 @@ struct lpfc_acqe_link {
 };
 
 struct lpfc_acqe_fcoe {
-	uint32_t fcf_index;
+	uint32_t index;
 	uint32_t word1;
 #define lpfc_acqe_fcoe_fcf_count_SHIFT		0
 #define lpfc_acqe_fcoe_fcf_count_MASK		0x0000FFFF
@@ -1896,6 +1943,7 @@ struct lpfc_acqe_fcoe {
 #define LPFC_FCOE_EVENT_TYPE_NEW_FCF		0x1
 #define LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL	0x2
 #define LPFC_FCOE_EVENT_TYPE_FCF_DEAD		0x3
+#define LPFC_FCOE_EVENT_TYPE_CVL		0x4
 	uint32_t event_tag;
 	uint32_t trailer;
 };
@@ -1924,9 +1972,9 @@ struct lpfc_bmbx_create {
 #define NO_XRI ((uint16_t)-1)
 struct wqe_common {
 	uint32_t word6;
-#define wqe_xri_SHIFT         0
-#define wqe_xri_MASK          0x0000FFFF
-#define wqe_xri_WORD          word6
+#define wqe_xri_tag_SHIFT     0
+#define wqe_xri_tag_MASK      0x0000FFFF
+#define wqe_xri_tag_WORD      word6
 #define wqe_ctxt_tag_SHIFT    16
 #define wqe_ctxt_tag_MASK     0x0000FFFF
 #define wqe_ctxt_tag_WORD     word6
@@ -1987,7 +2035,7 @@ struct wqe_common {
 #define wqe_wqec_MASK       0x00000001
 #define wqe_wqec_WORD       word11
 #define wqe_cqid_SHIFT      16
-#define wqe_cqid_MASK       0x000003ff
+#define wqe_cqid_MASK       0x0000ffff
 #define wqe_cqid_WORD       word11
 };
 
@@ -1996,6 +2044,9 @@ struct wqe_did {
 #define wqe_els_did_SHIFT         0
 #define wqe_els_did_MASK          0x00FFFFFF
 #define wqe_els_did_WORD          word5
+#define wqe_xmit_bls_pt_SHIFT         28
+#define wqe_xmit_bls_pt_MASK          0x00000003
+#define wqe_xmit_bls_pt_WORD          word5
 #define wqe_xmit_bls_ar_SHIFT         30
 #define wqe_xmit_bls_ar_MASK          0x00000001
 #define wqe_xmit_bls_ar_WORD          word5
@@ -2044,6 +2095,23 @@ struct xmit_els_rsp64_wqe {
 
 struct xmit_bls_rsp64_wqe {
 	uint32_t payload0;
+/* Payload0 for BA_ACC */
+#define xmit_bls_rsp64_acc_seq_id_SHIFT        16
+#define xmit_bls_rsp64_acc_seq_id_MASK         0x000000ff
+#define xmit_bls_rsp64_acc_seq_id_WORD         payload0
+#define xmit_bls_rsp64_acc_seq_id_vald_SHIFT   24
+#define xmit_bls_rsp64_acc_seq_id_vald_MASK    0x000000ff
+#define xmit_bls_rsp64_acc_seq_id_vald_WORD    payload0
+/* Payload0 for BA_RJT */
+#define xmit_bls_rsp64_rjt_vspec_SHIFT   0
+#define xmit_bls_rsp64_rjt_vspec_MASK    0x000000ff
+#define xmit_bls_rsp64_rjt_vspec_WORD    payload0
+#define xmit_bls_rsp64_rjt_expc_SHIFT    8
+#define xmit_bls_rsp64_rjt_expc_MASK     0x000000ff
+#define xmit_bls_rsp64_rjt_expc_WORD     payload0
+#define xmit_bls_rsp64_rjt_rsnc_SHIFT    16
+#define xmit_bls_rsp64_rjt_rsnc_MASK     0x000000ff
+#define xmit_bls_rsp64_rjt_rsnc_WORD     payload0
 	uint32_t word1;
 #define xmit_bls_rsp64_rxid_SHIFT  0
 #define xmit_bls_rsp64_rxid_MASK   0x0000ffff
@@ -2052,18 +2120,19 @@ struct xmit_bls_rsp64_wqe {
 #define xmit_bls_rsp64_oxid_MASK   0x0000ffff
 #define xmit_bls_rsp64_oxid_WORD   word1
 	uint32_t word2;
-#define xmit_bls_rsp64_seqcntlo_SHIFT  0
-#define xmit_bls_rsp64_seqcntlo_MASK   0x0000ffff
-#define xmit_bls_rsp64_seqcntlo_WORD   word2
-#define xmit_bls_rsp64_seqcnthi_SHIFT  16
+#define xmit_bls_rsp64_seqcnthi_SHIFT  0
 #define xmit_bls_rsp64_seqcnthi_MASK   0x0000ffff
 #define xmit_bls_rsp64_seqcnthi_WORD   word2
+#define xmit_bls_rsp64_seqcntlo_SHIFT  16
+#define xmit_bls_rsp64_seqcntlo_MASK   0x0000ffff
+#define xmit_bls_rsp64_seqcntlo_WORD   word2
 	uint32_t rsrvd3;
 	uint32_t rsrvd4;
 	struct wqe_did	wqe_dest;
 	struct wqe_common wqe_com; /* words 6-11 */
 	uint32_t rsvd_12_15[4];
 };
+
 struct wqe_rctl_dfctl {
 	uint32_t word5;
 #define wqe_si_SHIFT 2
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2009-10-01 17:20:57.000000000 -0400
@@ -1183,6 +1183,7 @@ typedef struct {
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
+#define PCI_DEVICE_ID_TS_BE3        0x0714
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
@@ -1444,6 +1445,7 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_ABORT_MXRI64_CN     0x8C
 #define CMD_RCV_ELS_REQ64_CX    0x8D
 #define CMD_XMIT_ELS_RSP64_CX   0x95
+#define CMD_XMIT_BLS_RSP64_CX   0x97
 #define CMD_FCP_IWRITE64_CR     0x98
 #define CMD_FCP_IWRITE64_CX     0x99
 #define CMD_FCP_IREAD64_CR      0x9A
@@ -2326,7 +2328,13 @@ typedef struct {
 /* Structure for MB Command UNREG_VPI (0x97) */
 typedef struct {
 	uint32_t rsvd1;
-	uint32_t rsvd2;
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint16_t rsvd2;
+	uint16_t sli4_vpi;
+#else	/*  __LITTLE_ENDIAN */
+	uint16_t sli4_vpi;
+	uint16_t rsvd2;
+#endif
 	uint32_t rsvd3;
 	uint32_t rsvd4;
 	uint32_t rsvd5;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:20:57.000000000 -0400
@@ -1669,6 +1669,10 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		oneConnect = 1;
 		m = (typeof(m)) {"OCe10100-F", max_speed, "PCIe"};
 		break;
+	case PCI_DEVICE_ID_TS_BE3:
+		oneConnect = 1;
+		m = (typeof(m)) {"OCeXXXXX-F", max_speed, "PCIe"};
+		break;
 	default:
 		m = (typeof(m)){ NULL };
 		break;
@@ -2699,6 +2703,63 @@ lpfc_sli_remove_dflt_fcf(struct lpfc_hba
 }
 
 /**
+ * lpfc_sli4_fw_cfg_check - Read the firmware config and verify FCoE support
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This function uses the QUERY_FW_CFG mailbox command to determine if the
+ * firmware loaded supports FCoE. A return of zero indicates that the mailbox
+ * was successful and the firmware supports FCoE. Any other return indicates
+ * a error. It is assumed that this function will be called before interrupts
+ * are enabled.
+ **/
+static int
+lpfc_sli4_fw_cfg_check(struct lpfc_hba *phba)
+{
+	int rc = 0;
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mbx_query_fw_cfg *query_fw_cfg;
+	uint32_t length;
+	uint32_t shdr_status, shdr_add_status;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2621 Failed to allocate mbox for "
+				"query firmware config cmd\n");
+		return -ENOMEM;
+	}
+	query_fw_cfg = &mboxq->u.mqe.un.query_fw_cfg;
+	length = (sizeof(struct lpfc_mbx_query_fw_cfg) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_QUERY_FW_CFG,
+			 length, LPFC_SLI4_MBX_EMBED);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr_status = bf_get(lpfc_mbox_hdr_status,
+			     &query_fw_cfg->header.cfg_shdr.response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+				 &query_fw_cfg->header.cfg_shdr.response);
+	if (shdr_status || shdr_add_status || rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2622 Query Firmware Config failed "
+				"mbx status x%x, status x%x add_status x%x\n",
+				rc, shdr_status, shdr_add_status);
+		return -EINVAL;
+	}
+	if (!bf_get(lpfc_function_mode_fcoe_i, query_fw_cfg)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2623 FCoE Function not supported by firmware. "
+				"Function mode = %08x\n",
+				query_fw_cfg->function_mode);
+		return -EINVAL;
+	}
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+	return 0;
+}
+
+/**
  * lpfc_sli4_parse_latt_fault - Parse sli4 link-attention link fault code
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async link completion queue entry.
@@ -2918,6 +2979,9 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 {
 	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
 	int rc;
+	struct lpfc_vport *vport;
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host  *shost;
 
 	phba->fc_eventTag = acqe_fcoe->event_tag;
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
@@ -2925,7 +2989,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
 			"2546 New FCF found index 0x%x tag 0x%x\n",
-			acqe_fcoe->fcf_index,
+			acqe_fcoe->index,
 			acqe_fcoe->event_tag);
 		/*
 		 * If the current FCF is in discovered state, or
@@ -2958,10 +3022,10 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
 			"2549 FCF disconnected fron network index 0x%x"
-			" tag 0x%x\n", acqe_fcoe->fcf_index,
+			" tag 0x%x\n", acqe_fcoe->index,
 			acqe_fcoe->event_tag);
 		/* If the event is not for currently used fcf do nothing */
-		if (phba->fcf.fcf_indx != acqe_fcoe->fcf_index)
+		if (phba->fcf.fcf_indx != acqe_fcoe->index)
 			break;
 		/*
 		 * Currently, driver support only one FCF - so treat this as
@@ -2971,7 +3035,28 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		/* Unregister FCF if no devices connected to it */
 		lpfc_unregister_unused_fcf(phba);
 		break;
-
+	case LPFC_FCOE_EVENT_TYPE_CVL:
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+			"2718 Clear Virtual Link Received for VPI 0x%x"
+			" tag 0x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
+		vport = lpfc_find_vport_by_vpid(phba,
+				acqe_fcoe->index /*- phba->vpi_base*/);
+		if (!vport)
+			break;
+		ndlp = lpfc_findnode_did(vport, Fabric_DID);
+		if (!ndlp)
+			break;
+		shost = lpfc_shost_from_vport(vport);
+		lpfc_linkdown_port(vport);
+		if (vport->port_type != LPFC_NPIV_PORT) {
+			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_DELAY_TMO;
+			spin_unlock_irq(shost->host_lock);
+			ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
+			vport->port_state = LPFC_FLOGI;
+		}
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0288 Unknown FCoE event type 0x%x event tag "
@@ -3463,6 +3548,10 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (unlikely(rc))
 		goto out_free_bsmbx;
 
+	rc = lpfc_sli4_fw_cfg_check(phba);
+	if (unlikely(rc))
+		goto out_free_bsmbx;
+
 	/* Set up the hba's configuration parameters. */
 	rc = lpfc_sli4_read_config(phba);
 	if (unlikely(rc))
@@ -6687,6 +6776,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pd
 {
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
+	struct Scsi_Host  *shost = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
 
@@ -6765,6 +6855,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pd
 		goto out_destroy_shost;
 	}
 
+	shost = lpfc_shost_from_vport(vport); /* save shost for error cleanup */
 	/* Now, trying to enable interrupt and bring up the device */
 	cfg_mode = phba->cfg_use_msi;
 	while (true) {
@@ -6831,6 +6922,8 @@ out_unset_pci_mem_s3:
 	lpfc_sli_pci_mem_unset(phba);
 out_disable_pci_dev:
 	lpfc_disable_pci_dev(phba);
+	if (shost)
+		scsi_host_put(shost);
 out_free_phba:
 	lpfc_hba_free(phba);
 	return error;
@@ -7214,6 +7307,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 {
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
+	struct Scsi_Host  *shost = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
 	int mcnt;
@@ -7294,6 +7388,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		goto out_destroy_shost;
 	}
 
+	shost = lpfc_shost_from_vport(vport); /* save shost for error cleanup */
 	/* Now, trying to enable interrupt and bring up the device */
 	cfg_mode = phba->cfg_use_msi;
 	while (true) {
@@ -7362,6 +7457,8 @@ out_unset_pci_mem_s4:
 	lpfc_sli4_pci_mem_unset(phba);
 out_disable_pci_dev:
 	lpfc_disable_pci_dev(phba);
+	if (shost)
+		scsi_host_put(shost);
 out_free_phba:
 	lpfc_hba_free(phba);
 	return error;
@@ -7936,6 +8033,8 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TS_BE3,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-10-01 17:20:57.000000000 -0400
@@ -849,7 +849,10 @@ lpfc_unreg_vpi(struct lpfc_hba *phba, ui
 	MAILBOX_t *mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	mb->un.varUnregVpi.vpi = vpi + phba->vpi_base;
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		mb->un.varUnregVpi.vpi = vpi + phba->vpi_base;
+	else
+		mb->un.varUnregVpi.sli4_vpi = vpi + phba->vpi_base;
 
 	mb->mbxCommand = MBX_UNREG_VPI;
 	mb->mbxOwner = OWN_HOST;
@@ -1850,7 +1853,7 @@ lpfc_init_vpi(struct lpfc_hba *phba, str
 /**
  * lpfc_unreg_vfi - Initialize the UNREG_VFI mailbox command
  * @mbox: pointer to lpfc mbox command to initialize.
- * @vfi: VFI to be unregistered.
+ * @vport: vport associated with the VF.
  *
  * The UNREG_VFI mailbox command causes the SLI Host to put a virtual fabric
  * (logical NPort) into the inactive state. The SLI Host must have logged out
@@ -1859,11 +1862,12 @@ lpfc_init_vpi(struct lpfc_hba *phba, str
  * fabric inactive.
  **/
 void
-lpfc_unreg_vfi(struct lpfcMboxq *mbox, uint16_t vfi)
+lpfc_unreg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport)
 {
 	memset(mbox, 0, sizeof(*mbox));
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_UNREG_VFI);
-	bf_set(lpfc_unreg_vfi_vfi, &mbox->u.mqe.un.unreg_vfi, vfi);
+	bf_set(lpfc_unreg_vfi_vfi, &mbox->u.mqe.un.unreg_vfi,
+	       vport->vfi + vport->phba->vfi_base);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:20:57.000000000 -0400
@@ -58,6 +58,11 @@
 #define LPFC_FCOE_FKA_ADV_PER	0
 #define LPFC_FCOE_FIP_PRIORITY	0x80
 
+#define sli4_sid_from_fc_hdr(fc_hdr)  \
+	((fc_hdr)->fh_s_id[0] << 16 | \
+	 (fc_hdr)->fh_s_id[1] <<  8 | \
+	 (fc_hdr)->fh_s_id[2])
+
 enum lpfc_sli4_queue_type {
 	LPFC_EQ,
 	LPFC_GCQ,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:20:57.000000000 -0400
@@ -59,7 +59,8 @@ static int lpfc_sli_issue_mbox_s4(struct
 				  uint32_t);
 static int lpfc_sli4_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *,
 			    uint8_t *, uint32_t *);
-
+static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
+				      struct hbq_dmabuf *);
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
 {
@@ -572,9 +573,9 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_xritag);
 	if (sglq)  {
 		if (iocbq->iocb_flag & LPFC_DRIVER_ABORTED
-			|| ((iocbq->iocb.ulpStatus == IOSTAT_LOCAL_REJECT)
+			&& ((iocbq->iocb.ulpStatus == IOSTAT_LOCAL_REJECT)
 			&& (iocbq->iocb.un.ulpWord[4]
-				== IOERR_SLI_ABORTED))) {
+				== IOERR_ABORT_REQUESTED))) {
 			spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock,
 					iflag);
 			list_add(&sglq->list,
@@ -767,6 +768,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_CLOSE_XRI_CX:
 	case CMD_XRI_ABORTED_CX:
 	case CMD_ABORT_MXRI64_CN:
+	case CMD_XMIT_BLS_RSP64_CX:
 		type = LPFC_ABORT_IOCB;
 		break;
 	case CMD_RCV_SEQUENCE_CX:
@@ -6081,6 +6083,23 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		command_type = OTHER_COMMAND;
 		xritag = 0;
 	break;
+	case CMD_XMIT_BLS_RSP64_CX:
+		/* As BLS ABTS-ACC WQE is very different from other WQEs,
+		 * we re-construct this WQE here based on information in
+		 * iocbq from scratch.
+		 */
+		memset(wqe, 0, sizeof(union lpfc_wqe));
+		bf_set(xmit_bls_rsp64_oxid, &wqe->xmit_bls_rsp,
+		       iocbq->iocb.un.ulpWord[3]);
+		bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
+		       iocbq->sli4_xritag);
+		bf_set(xmit_bls_rsp64_seqcnthi, &wqe->xmit_bls_rsp, 0xffff);
+		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
+		bf_set(wqe_ctxt_tag, &wqe->xmit_bls_rsp.wqe_com,
+		       iocbq->iocb.ulpContext);
+		/* Overwrite the pre-set comnd type with OTHER_COMMAND */
+		command_type = OTHER_COMMAND;
+	break;
 	case CMD_XRI_ABORTED_CX:
 	case CMD_CREATE_XRI_CR: /* Do we expect to use this? */
 		/* words0-2 are all 0's no bde */
@@ -6139,7 +6158,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
-			piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
+		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			sglq = NULL;
 		else {
 			sglq = __lpfc_sli_get_sglq(phba);
@@ -6464,7 +6483,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 			pring->iotag_max = 4096;
 			pring->lpfc_sli_rcv_async_status =
 				lpfc_sli_async_event_handler;
-			pring->num_mask = 4;
+			pring->num_mask = LPFC_MAX_RING_MASK;
 			pring->prt[0].profile = 0;	/* Mask 0 */
 			pring->prt[0].rctl = FC_ELS_REQ;
 			pring->prt[0].type = FC_ELS_DATA;
@@ -6489,6 +6508,12 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 			pring->prt[3].type = FC_COMMON_TRANSPORT_ULP;
 			pring->prt[3].lpfc_sli_rcv_unsol_event =
 			    lpfc_ct_unsol_event;
+			/* abort unsolicited sequence */
+			pring->prt[4].profile = 0;	/* Mask 4 */
+			pring->prt[4].rctl = FC_RCTL_BA_ABTS;
+			pring->prt[4].type = FC_TYPE_BLS;
+			pring->prt[4].lpfc_sli_rcv_unsol_event =
+			    lpfc_sli4_ct_abort_unsol_event;
 			break;
 		}
 		totiocbsize += (pring->numCiocb * pring->sizeCiocb) +
@@ -10870,6 +10895,177 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 }
 
 /**
+ * lpfc_sli4_abort_partial_seq - Abort partially assembled unsol sequence
+ * @vport: pointer to a vitural port
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function tries to abort from the partially assembed sequence, described
+ * by the information from basic abbort @dmabuf. It checks to see whether such
+ * partially assembled sequence held by the driver. If so, it shall free up all
+ * the frames from the partially assembled sequence.
+ *
+ * Return
+ * true  -- if there is matching partially assembled sequence present and all
+ *          the frames freed with the sequence;
+ * false -- if there is no matching partially assembled sequence present so
+ *          nothing got aborted in the lower layer driver
+ **/
+static bool
+lpfc_sli4_abort_partial_seq(struct lpfc_vport *vport,
+			    struct hbq_dmabuf *dmabuf)
+{
+	struct fc_frame_header *new_hdr;
+	struct fc_frame_header *temp_hdr;
+	struct lpfc_dmabuf *d_buf, *n_buf, *h_buf;
+	struct hbq_dmabuf *seq_dmabuf = NULL;
+
+	/* Use the hdr_buf to find the sequence that matches this frame */
+	INIT_LIST_HEAD(&dmabuf->dbuf.list);
+	INIT_LIST_HEAD(&dmabuf->hbuf.list);
+	new_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
+		temp_hdr = (struct fc_frame_header *)h_buf->virt;
+		if ((temp_hdr->fh_seq_id != new_hdr->fh_seq_id) ||
+		    (temp_hdr->fh_ox_id != new_hdr->fh_ox_id) ||
+		    (memcmp(&temp_hdr->fh_s_id, &new_hdr->fh_s_id, 3)))
+			continue;
+		/* found a pending sequence that matches this frame */
+		seq_dmabuf = container_of(h_buf, struct hbq_dmabuf, hbuf);
+		break;
+	}
+
+	/* Free up all the frames from the partially assembled sequence */
+	if (seq_dmabuf) {
+		list_for_each_entry_safe(d_buf, n_buf,
+					 &seq_dmabuf->dbuf.list, list) {
+			list_del_init(&d_buf->list);
+			lpfc_in_buf_free(vport->phba, d_buf);
+		}
+		return true;
+	}
+	return false;
+}
+
+/**
+ * lpfc_sli4_seq_abort_acc_cmpl - Accept seq abort iocb complete handler
+ * @phba: Pointer to HBA context object.
+ * @cmd_iocbq: pointer to the command iocbq structure.
+ * @rsp_iocbq: pointer to the response iocbq structure.
+ *
+ * This function handles the sequence abort accept iocb command complete
+ * event. It properly releases the memory allocated to the sequence abort
+ * accept iocb.
+ **/
+static void
+lpfc_sli4_seq_abort_acc_cmpl(struct lpfc_hba *phba,
+			     struct lpfc_iocbq *cmd_iocbq,
+			     struct lpfc_iocbq *rsp_iocbq)
+{
+	if (cmd_iocbq)
+		lpfc_sli_release_iocbq(phba, cmd_iocbq);
+}
+
+/**
+ * lpfc_sli4_seq_abort_acc - Accept sequence abort
+ * @phba: Pointer to HBA context object.
+ * @fc_hdr: pointer to a FC frame header.
+ *
+ * This function sends a basic accept to a previous unsol sequence abort
+ * event after aborting the sequence handling.
+ **/
+static void
+lpfc_sli4_seq_abort_acc(struct lpfc_hba *phba,
+			struct fc_frame_header *fc_hdr)
+{
+	struct lpfc_iocbq *ctiocb = NULL;
+	struct lpfc_nodelist *ndlp;
+	uint16_t oxid;
+	uint32_t sid;
+	IOCB_t *icmd;
+
+	if (!lpfc_is_link_up(phba))
+		return;
+
+	sid = sli4_sid_from_fc_hdr(fc_hdr);
+	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+
+	ndlp = lpfc_findnode_did(phba->pport, sid);
+	if (!ndlp) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+				"1268 Find ndlp returned NULL for oxid:x%x "
+				"SID:x%x\n", oxid, sid);
+		return;
+	}
+
+	/* Allocate buffer for acc iocb */
+	ctiocb = lpfc_sli_get_iocbq(phba);
+	if (!ctiocb)
+		return;
+
+	icmd = &ctiocb->iocb;
+	icmd->un.xseq64.bdl.ulpIoTag32 = 0;
+	icmd->un.xseq64.bdl.bdeSize = 0;
+	icmd->un.xseq64.w5.hcsw.Dfctl = 0;
+	icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_ACC;
+	icmd->un.xseq64.w5.hcsw.Type = FC_TYPE_BLS;
+
+	/* Fill in the rest of iocb fields */
+	icmd->ulpCommand = CMD_XMIT_BLS_RSP64_CX;
+	icmd->ulpBdeCount = 0;
+	icmd->ulpLe = 1;
+	icmd->ulpClass = CLASS3;
+	icmd->ulpContext = ndlp->nlp_rpi;
+	icmd->un.ulpWord[3] = oxid;
+
+	ctiocb->sli4_xritag = NO_XRI;
+	ctiocb->iocb_cmpl = NULL;
+	ctiocb->vport = phba->pport;
+	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_acc_cmpl;
+
+	/* Xmit CT abts accept on exchange <xid> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"1200 Xmit CT ABTS ACC on exchange x%x Data: x%x\n",
+			CMD_XMIT_BLS_RSP64_CX, phba->link_state);
+	lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
+}
+
+/**
+ * lpfc_sli4_handle_unsol_abort - Handle sli-4 unsolicited abort event
+ * @vport: Pointer to the vport on which this sequence was received
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function handles an SLI-4 unsolicited abort event. If the unsolicited
+ * receive sequence is only partially assembed by the driver, it shall abort
+ * the partially assembled frames for the sequence. Otherwise, if the
+ * unsolicited receive sequence has been completely assembled and passed to
+ * the Upper Layer Protocol (UPL), it then mark the per oxid status for the
+ * unsolicited sequence has been aborted. After that, it will issue a basic
+ * accept to accept the abort.
+ **/
+void
+lpfc_sli4_handle_unsol_abort(struct lpfc_vport *vport,
+			     struct hbq_dmabuf *dmabuf)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct fc_frame_header fc_hdr;
+	bool abts_par;
+
+	/* Try to abort partially assembled seq */
+	abts_par = lpfc_sli4_abort_partial_seq(vport, dmabuf);
+
+	/* Make a copy of fc_hdr before the dmabuf being released */
+	memcpy(&fc_hdr, dmabuf->hbuf.virt, sizeof(struct fc_frame_header));
+
+	/* Send abort to ULP if partially seq abort failed */
+	if (abts_par == false)
+		lpfc_sli4_send_seq_to_ulp(vport, dmabuf);
+	else
+		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+	/* Send basic accept (BA_ACC) to the abort requester */
+	lpfc_sli4_seq_abort_acc(phba, &fc_hdr);
+}
+
+/**
  * lpfc_seq_complete - Indicates if a sequence is complete
  * @dmabuf: pointer to a dmabuf that describes the FC sequence
  *
@@ -10941,9 +11137,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 	/* remove from receive buffer list */
 	list_del_init(&seq_dmabuf->hbuf.list);
 	/* get the Remote Port's SID */
-	sid = (fc_hdr->fh_s_id[0] << 16 |
-	       fc_hdr->fh_s_id[1] << 8 |
-	       fc_hdr->fh_s_id[2]);
+	sid = sli4_sid_from_fc_hdr(fc_hdr);
 	/* Get an iocbq struct to fill in. */
 	first_iocbq = lpfc_sli_get_iocbq(vport->phba);
 	if (first_iocbq) {
@@ -11010,6 +11204,43 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 	return first_iocbq;
 }
 
+static void
+lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
+			  struct hbq_dmabuf *seq_dmabuf)
+{
+	struct fc_frame_header *fc_hdr;
+	struct lpfc_iocbq *iocbq, *curr_iocb, *next_iocb;
+	struct lpfc_hba *phba = vport->phba;
+
+	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
+	iocbq = lpfc_prep_seq(vport, seq_dmabuf);
+	if (!iocbq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2707 Ring %d handler: Failed to allocate "
+				"iocb Rctl x%x Type x%x received\n",
+				LPFC_ELS_RING,
+				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+		return;
+	}
+	if (!lpfc_complete_unsol_iocb(phba,
+				      &phba->sli.ring[LPFC_ELS_RING],
+				      iocbq, fc_hdr->fh_r_ctl,
+				      fc_hdr->fh_type))
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2540 Ring %d handler: unexpected Rctl "
+				"x%x Type x%x received\n",
+				LPFC_ELS_RING,
+				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+
+	/* Free iocb created in lpfc_prep_seq */
+	list_for_each_entry_safe(curr_iocb, next_iocb,
+		&iocbq->list, list) {
+		list_del_init(&curr_iocb->list);
+		lpfc_sli_release_iocbq(phba, curr_iocb);
+	}
+	lpfc_sli_release_iocbq(phba, iocbq);
+}
+
 /**
  * lpfc_sli4_handle_received_buffer - Handle received buffers from firmware
  * @phba: Pointer to HBA context object.
@@ -11030,7 +11261,6 @@ lpfc_sli4_handle_received_buffer(struct 
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_vport *vport;
 	uint32_t fcfi;
-	struct lpfc_iocbq *iocbq;
 
 	/* Clear hba flag and get all received buffers into the cmplq */
 	spin_lock_irq(&phba->hbalock);
@@ -11051,6 +11281,12 @@ lpfc_sli4_handle_received_buffer(struct 
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
+	/* Handle the basic abort sequence (BA_ABTS) event */
+	if (fc_hdr->fh_r_ctl == FC_RCTL_BA_ABTS) {
+		lpfc_sli4_handle_unsol_abort(vport, dmabuf);
+		return;
+	}
+
 	/* Link this frame */
 	seq_dmabuf = lpfc_fc_frame_add(vport, dmabuf);
 	if (!seq_dmabuf) {
@@ -11068,17 +11304,8 @@ lpfc_sli4_handle_received_buffer(struct 
 		dmabuf->tag = -1;
 		return;
 	}
-	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
-	iocbq = lpfc_prep_seq(vport, seq_dmabuf);
-	if (!lpfc_complete_unsol_iocb(phba,
-				      &phba->sli.ring[LPFC_ELS_RING],
-				      iocbq, fc_hdr->fh_r_ctl,
-				      fc_hdr->fh_type))
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"2540 Ring %d handler: unexpected Rctl "
-				"x%x Type x%x received\n",
-				LPFC_ELS_RING,
-				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+	/* Send the complete sequence to the upper layer protocol */
+	lpfc_sli4_send_seq_to_ulp(vport, seq_dmabuf);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-10-01 17:20:57.000000000 -0400
@@ -113,7 +113,7 @@ typedef struct lpfcMboxq {
 				   return */
 #define MBX_NOWAIT      2	/* issue command then return immediately */
 
-#define LPFC_MAX_RING_MASK  4	/* max num of rctl/type masks allowed per
+#define LPFC_MAX_RING_MASK  5	/* max num of rctl/type masks allowed per
 				   ring */
 #define LPFC_MAX_RING       4	/* max num of SLI rings used by driver */
 


