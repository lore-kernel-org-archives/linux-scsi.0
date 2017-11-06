From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 4/4] qla2xxx_nvmet: Add FC-NVMe Target handling
Date: Mon, 6 Nov 2017 11:55:30 -0800
Message-ID: <20171106195530.17408-5-himanshu.madhani@cavium.com>
References: <20171106195530.17408-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:33120
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753973AbdKFTzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Nov 2017 14:55:52 -0500
In-Reply-To: <20171106195530.17408-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Anil Gurumurthy <anil.gurumurthy@cavium.com>

This patch Adds following code in the driver to
support FC-NVMe Target

- Updated ql2xenablenvme to allow FC-NVMe Target operation
- Added LS Request handling for NVMe Target
- Added passthr IOCB for LS4 request
- Added CTIO for sending response to FW
- Added FC4 Registration for FC-NVMe Target
- Added PUREX IOCB support for login processing in FC-NVMe Target mode
- Added Continuation IOCB for PUREX
- Added Session creation with PUREX IOCB in FC-NVMe Target mode

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  35 +-
 drivers/scsi/qla2xxx/qla_fw.h     | 263 +++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  17 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  15 +-
 drivers/scsi/qla2xxx/qla_init.c   |  49 +-
 drivers/scsi/qla2xxx/qla_isr.c    |  70 +++
 drivers/scsi/qla2xxx/qla_mbx.c    | 100 +++-
 drivers/scsi/qla2xxx/qla_nvme.h   |  33 --
 drivers/scsi/qla2xxx/qla_os.c     |  75 ++-
 drivers/scsi/qla2xxx/qla_target.c | 932 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.h |  93 +++-
 11 files changed, 1625 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 01a9b8971e88..74813c144974 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -447,13 +447,21 @@ struct srb_iocb {
 			uint32_t dl;
 			uint32_t timeout_sec;
 			struct	list_head   entry;
+			uint32_t exchange_address;
+			uint16_t nport_handle;
+			uint8_t vp_index;
+			void *cmd;
 		} nvme;
 	} u;
 
 	struct timer_list timer;
 	void (*timeout)(void *);
 };
-
+struct srb_nvme_els_rsp {
+		dma_addr_t dma_addr;
+		void *dma_ptr;
+		void *ptr;
+};
 /* Values for srb_ctx type */
 #define SRB_LOGIN_CMD	1
 #define SRB_LOGOUT_CMD	2
@@ -476,6 +484,11 @@ struct srb_iocb {
 #define SRB_NVME_CMD	19
 #define SRB_NVME_LS	20
 #define SRB_PRLI_CMD	21
+#define SRB_NVME_ELS_RSP 22
+#define SRB_NVMET_LS	23
+#define SRB_NVMET_FCP	24
+#define SRB_NVMET_ABTS	25
+#define SRB_NVMET_SEND_ABTS	26
 
 enum {
 	TYPE_SRB,
@@ -505,6 +518,7 @@ typedef struct srb {
 		struct srb_iocb iocb_cmd;
 		struct bsg_job *bsg_job;
 		struct srb_cmd scmd;
+		struct srb_nvme_els_rsp snvme_els;
 	} u;
 	void (*done)(void *, int);
 	void (*free)(void *);
@@ -2250,6 +2264,15 @@ struct qlt_plogi_ack_t {
 	void		*fcport;
 };
 
+/* NVMET */
+struct qlt_purex_plogi_ack_t {
+	struct list_head	list;
+	struct __fc_plogi rcvd_plogi;
+	port_id_t	id;
+	int		ref_count;
+	void		*fcport;
+};
+
 struct ct_sns_desc {
 	struct ct_sns_pkt	*ct_sns;
 	dma_addr_t		ct_sns_dma;
@@ -2346,6 +2369,8 @@ typedef struct fc_port {
 	struct work_struct free_work;
 
 	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
+	/* NVMET */
+	struct qlt_purex_plogi_ack_t *purex_plogi_link[QLT_PLOGI_LINK_MAX];
 
 	uint16_t tgt_id;
 	uint16_t old_tgt_id;
@@ -3125,6 +3150,7 @@ enum qla_work_type {
 	QLA_EVT_UPD_FCPORT,
 	QLA_EVT_GNL,
 	QLA_EVT_NACK,
+	QLA_EVT_NEW_NVMET_SESS,
 };
 
 
@@ -4097,6 +4123,7 @@ typedef struct scsi_qla_host {
 		uint32_t	qpairs_req_created:1;
 		uint32_t	qpairs_rsp_created:1;
 		uint32_t	nvme_enabled:1;
+		uint32_t	nvmet_enabled:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -4139,6 +4166,7 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED	28
 #define DETECT_SFP_CHANGE	29
 #define N2N_LOGIN_NEEDED	30
+#define NVMET_PUREX		31
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
@@ -4179,6 +4207,7 @@ typedef struct scsi_qla_host {
 	uint8_t		fabric_node_name[WWN_SIZE];
 
 	struct		nvme_fc_local_port *nvme_local_port;
+	struct		nvmet_fc_target_port *targetport;
 	struct completion nvme_del_done;
 	struct list_head nvme_rport_list;
 	atomic_t 	nvme_active_aen_cnt;
@@ -4252,6 +4281,9 @@ typedef struct scsi_qla_host {
 	uint8_t n2n_node_name[WWN_SIZE];
 	uint8_t n2n_port_name[WWN_SIZE];
 	uint16_t	n2n_id;
+	/*NVMET*/
+	struct list_head	purex_atio_list;
+	struct completion	purex_plogi_sess;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
@@ -4512,6 +4544,7 @@ struct sff_8247_a0 {
 	(IS_QLA27XX(_ha) || IS_QLA83XX(_ha)))
 
 #include "qla_target.h"
+#include "qla_nvmet.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d5cef0727e72..d27d46601f48 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -723,6 +723,269 @@ struct ct_entry_24xx {
 	uint32_t dseg_1_len;		/* Data segment 1 length. */
 };
 
+/* NVME-T changes */
+/*
+ * Fibre Channel Header
+ * Little Endian format.  As received in PUREX and PURLS
+ */
+struct __fc_hdr {
+	uint16_t	did_lo;
+	uint8_t		did_hi;
+	uint8_t		r_ctl;
+	uint16_t	sid_lo;
+	uint8_t		sid_hi;
+	uint8_t		cs_ctl;
+	uint16_t	f_ctl_lo;
+	uint8_t		f_ctl_hi;
+	uint8_t		type;
+	uint16_t	seq_cnt;
+	uint8_t		df_ctl;
+	uint8_t		seq_id;
+	uint16_t	rx_id;
+	uint16_t	ox_id;
+	uint32_t	param;
+};
+
+/*
+ * Fibre Channel LOGO acc
+ * In big endian format
+ */
+struct __fc_logo_acc {
+	uint8_t	op_code;
+	uint8_t	reserved[3];
+};
+
+struct __fc_lsrjt {
+	uint8_t	op_code;
+	uint8_t	reserved[3];
+	uint8_t	reserved2;
+	uint8_t	reason;
+	uint8_t	exp;
+	uint8_t	vendor;
+};
+
+/*
+ * Fibre Channel LOGO Frame
+ * Little Endian format. As received in PUREX
+ */
+struct __fc_logo {
+	struct __fc_hdr	hdr;
+	uint16_t	reserved;
+	uint8_t		reserved1;
+	uint8_t		op_code;
+	uint16_t	sid_lo;
+	uint8_t		sid_hi;
+	uint8_t		reserved2;
+	uint8_t		pname[8];
+};
+
+/*
+ * Fibre Channel PRLI Frame
+ * Little Endian format. As received in PUREX
+ */
+struct __fc_prli {
+	struct  __fc_hdr	hdr;
+	uint16_t		pyld_length;  /* word 0 of prli */
+	uint8_t		page_length;
+	uint8_t		op_code;
+	uint16_t	common;/* word 1.  1st word of SP page */
+	uint8_t		type_ext;
+	uint8_t		prli_type;
+#define PRLI_TYPE_FCP  0x8
+#define PRLI_TYPE_NVME 0x28
+	union {
+		struct {
+			uint32_t	reserved[2];
+			uint32_t	sp_info;
+		} fcp;
+		struct {
+			uint32_t	reserved[2];
+			uint32_t	sp_info;
+#define NVME_PRLI_DISC BIT_3
+#define NVME_PRLI_TRGT BIT_4
+#define NVME_PRLI_INIT BIT_5
+#define NVME_PRLI_CONFIRMATION BIT_7
+			uint32_t	reserved1;
+		} nvme;
+	};
+};
+
+/*
+ * Fibre Channel PLOGI Frame
+ * Little Endian format.  As received in PUREX
+ */
+struct __fc_plogi {
+	uint16_t        did_lo;
+	uint8_t         did_hi;
+	uint8_t         r_ctl;
+	uint16_t        sid_lo;
+	uint8_t         sid_hi;
+	uint8_t         cs_ctl;
+	uint16_t        f_ctl_lo;
+	uint8_t         f_ctl_hi;
+	uint8_t         type;
+	uint16_t        seq_cnt;
+	uint8_t         df_ctl;
+	uint8_t         seq_id;
+	uint16_t        rx_id;
+	uint16_t        ox_id;
+	uint32_t        param;
+	uint8_t         rsvd[3];
+	uint8_t         op_code;
+	uint32_t        cs_params[4]; /* common service params */
+	uint8_t         pname[8];     /* port name */
+	uint8_t         nname[8];     /* node name */
+	uint32_t        class1[4];    /* class 1 service params */
+	uint32_t        class2[4];    /* class 2 service params */
+	uint32_t        class3[4];    /* class 3 service params */
+	uint32_t        class4[4];
+	uint32_t        vndr_vers[4];
+};
+
+#define IOCB_TYPE_ELS_PASSTHRU 0x53
+
+/* ELS Pass-Through IOCB (IOCB_TYPE_ELS_PASSTHRU = 0x53)
+ */
+struct __els_pt {
+	uint8_t	entry_type;		/* Entry type. */
+	uint8_t	entry_count;		/* Entry count. */
+	uint8_t	sys_define;		/* System defined. */
+	uint8_t	entry_status;		/* Entry Status. */
+	uint32_t	handle;
+	uint16_t	status;       /* when returned from fw */
+	uint16_t	nphdl;
+	uint16_t	tx_dsd_cnt;
+	uint8_t	vp_index;
+	uint8_t	sof;          /* bits 7:4 */
+	uint32_t	rcv_exchg_id;
+	uint16_t	rx_dsd_cnt;
+	uint8_t	op_code;
+	uint8_t	rsvd1;
+	uint16_t	did_lo;
+	uint8_t	did_hi;
+	uint8_t	sid_hi;
+	uint16_t	sid_lo;
+	uint16_t	cntl_flags;
+#define ELS_PT_RESPONDER_ACC   (1 << 13)
+	uint32_t	rx_bc;
+	uint32_t	tx_bc;
+	uint32_t	tx_dsd[2];	/* Data segment 0 address. */
+	uint32_t	tx_dsd_len;		/* Data segment 0 length. */
+	uint32_t	rx_dsd[2];	/* Data segment 1 address. */
+	uint32_t	rx_dsd_len;		/* Data segment 1 length. */
+};
+
+/*
+ * Reject a FCP PRLI
+ *
+ */
+struct __fc_prli_rjt {
+	uint8_t op_code;	/* word 0 of prli rjt */
+	uint8_t rsvd1[3];
+	uint8_t rsvd2;		/* word 1 of prli rjt */
+	uint8_t	reason;
+#define PRLI_RJT_REASON 0x3	/* logical error */
+	uint8_t	expl;
+	uint8_t vendor;
+#define PRLI_RJT_FCP_RESP_LEN 8
+};
+
+/*
+ * Fibre Channel PRLI ACC
+ * Payload only
+ */
+struct __fc_prli_acc {
+/* payload only.  In big-endian format */
+	uint8_t         op_code;      /* word 0 of prli acc */
+	uint8_t         page_length;
+#define PRLI_FCP_PAGE_LENGTH  16
+#define PRLI_NVME_PAGE_LENGTH 20
+	uint16_t        pyld_length;
+	uint8_t         type;         /* word 1 of prli acc */
+	uint8_t         type_ext;
+	uint16_t        common;
+#define PRLI_EST_FCP_PAIR 0x2000
+#define PRLI_REQ_EXEC     0x0100
+#define PRLI_REQ_DOES_NOT_EXIST 0x0400
+	union {
+		struct {
+			uint32_t	reserved[2];
+			uint32_t	sp_info;
+			/* hard coding resp.  target, rdxfr disabled.*/
+#define FCP_PRLI_SP 0x12
+		} fcp;
+		struct {
+			uint32_t	reserved[2];
+			uint32_t	sp_info;
+			uint16_t	reserved2;
+			uint16_t	first_burst;
+		} nvme;
+	};
+#define PRLI_ACC_FCP_RESP_LEN  20
+#define PRLI_ACC_NVME_RESP_LEN 24
+
+};
+
+/*
+ * ISP queue - PUREX IOCB entry structure definition
+ */
+#define PUREX_IOCB_TYPE		0x51 /* CT Pass Through IOCB entry */
+struct purex_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint16_t reserved1;
+	uint8_t vp_idx;
+	uint8_t reserved2;
+
+	uint16_t status_flags;
+	uint16_t nport_handle;
+
+	uint16_t frame_size;
+	uint16_t trunc_frame_size;
+
+	uint32_t rx_xchg_addr;
+
+	uint8_t d_id[3];
+	uint8_t r_ctl;
+
+	uint8_t s_id[3];
+	uint8_t cs_ctl;
+
+	uint8_t f_ctl[3];
+	uint8_t type;
+
+	uint16_t seq_cnt;
+	uint8_t df_ctl;
+	uint8_t seq_id;
+
+	uint16_t rx_id;
+	uint16_t ox_id;
+	uint32_t param;
+
+	uint8_t pyld[20];
+#define PUREX_PYLD_SIZE 44 /* Number of bytes (hdr+pyld) in this IOCB */
+};
+
+#define PUREX_ENTRY_SIZE	(sizeof(purex_entry_24xx_t))
+
+#define CONT_SENSE_DATA 60
+/*
+ * Continuation Status Type 0 (IOCB_TYPE_STATUS_CONT = 0x10)
+ * Section 5.6 FW Interface Spec
+ */
+struct __status_cont {
+	uint8_t entry_type;		/* Entry type. - 0x10 */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t entry_status;		/* Entry Status. */
+	uint8_t reserved;
+
+	uint8_t data[CONT_SENSE_DATA];
+} __packed;
+
+
 /*
  * ISP queue - ELS Pass-Through entry structure definition.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0a23af5aa479..166704019de6 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -299,7 +299,10 @@ extern int
 qla2x00_set_fw_options(scsi_qla_host_t *, uint16_t *);
 
 extern int
-qla2x00_mbx_reg_test(scsi_qla_host_t *);
+qla2x00_set_purex_mode(scsi_qla_host_t *vha);
+
+extern int
+qla2x00_mbx_reg_test(scsi_qla_host_t *vha);
 
 extern int
 qla2x00_verify_checksum(scsi_qla_host_t *, uint32_t);
@@ -874,6 +877,16 @@ void qlt_update_host_map(struct scsi_qla_host *, port_id_t);
 void qlt_remove_target_resources(struct qla_hw_data *);
 void qlt_clr_qp_table(struct scsi_qla_host *vha);
 
+extern int qla2x00_get_plogi_template(scsi_qla_host_t *vha, dma_addr_t buf,
+	uint16_t length);
+extern void qlt_dequeue_purex(struct scsi_qla_host *vha);
+int qla24xx_post_nvmet_newsess_work(struct scsi_qla_host *vha, port_id_t *id,
+	u8 *port_name, void *pla);
+int qlt_send_els_resp(srb_t *sp, struct __els_pt *pkt);
+extern void nvmet_release_sessions(struct scsi_qla_host *vha);
+struct fc_port *qla_nvmet_find_sess_by_s_id(scsi_qla_host_t *vha,
+	const uint32_t s_id);
 void qla_nvme_cmpl_io(struct srb_iocb *);
-
+void qla24xx_nvmet_abts_resp_iocb(struct scsi_qla_host *vha,
+	struct abts_resp_to_24xx *pkt, struct req_que *req);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index bc3db6abc9a0..9b480ae2a5f5 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -548,9 +548,10 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
 	ct_req->req.rft_id.port_id[1] = vha->d_id.b.area;
 	ct_req->req.rft_id.port_id[2] = vha->d_id.b.al_pa;
 
-	ct_req->req.rft_id.fc4_types[2] = 0x01;		/* FCP-3 */
+	if (!vha->flags.nvmet_enabled)
+		ct_req->req.rft_id.fc4_types[2] = 0x01;		/* FCP-3 */
 
-	if (vha->flags.nvme_enabled)
+	if (vha->flags.nvme_enabled || vha->flags.nvmet_enabled)
 		ct_req->req.rft_id.fc4_types[6] = 1;    /* NVMe type 28h */
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -592,6 +593,10 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8 type)
 		return (QLA_SUCCESS);
 	}
 
+	/* only single mode for now */
+	if ((vha->flags.nvmet_enabled) && (type == FC4_TYPE_FCP_SCSI))
+		return (QLA_SUCCESS);
+
 	arg.iocb = ha->ms_iocb;
 	arg.req_dma = ha->ct_sns_dma;
 	arg.rsp_dma = ha->ct_sns_dma;
@@ -613,7 +618,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8 type)
 	ct_req->req.rff_id.port_id[1] = vha->d_id.b.area;
 	ct_req->req.rff_id.port_id[2] = vha->d_id.b.al_pa;
 
-	qlt_rff_id(vha, ct_req);
+	qlt_rff_id(vha, ct_req, type);
 
 	ct_req->req.rff_id.fc4_type = type;		/* SCSI - FCP */
 
@@ -2166,7 +2171,7 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 	    eiter->a.fc4_types[2],
 	    eiter->a.fc4_types[1]);
 
-	if (vha->flags.nvme_enabled) {
+	if (vha->flags.nvme_enabled || vha->flags.nvmet_enabled) {
 		eiter->a.fc4_types[6] = 1;	/* NVMe type 28h */
 		ql_dbg(ql_dbg_disc, vha, 0x211f,
 		    "NVME FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
@@ -2370,7 +2375,7 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 	    "Port Active FC4 Type = %02x %02x.\n",
 	    eiter->a.port_fc4_type[2], eiter->a.port_fc4_type[1]);
 
-	if (vha->flags.nvme_enabled) {
+	if (vha->flags.nvme_enabled || vha->flags.nvmet_enabled) {
 		eiter->a.port_fc4_type[4] = 0;
 		eiter->a.port_fc4_type[5] = 0;
 		eiter->a.port_fc4_type[6] = 1;	/* NVMe type 28h */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 76edb4a02a8d..6fd941c66169 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -19,6 +19,7 @@
 
 #include <target/target_core_base.h>
 #include "qla_target.h"
+#include "qla_nvmet.h"
 
 /*
 *  QLogic ISP2x00 Hardware Support Function Prototypes.
@@ -786,6 +787,23 @@ int qla24xx_post_gpdb_work(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	return qla2x00_post_work(vha, e);
 }
 
+/* NVMET */
+int qla24xx_post_nvmet_newsess_work(struct scsi_qla_host *vha, port_id_t *id,
+	u8 *port_name, void *pla)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_NEW_NVMET_SESS);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.new_sess.id = *id;
+	e->u.new_sess.pla = pla;
+	memcpy(e->u.new_sess.port_name, port_name, WWN_SIZE);
+
+	return qla2x00_post_work(vha, e);
+}
+
 int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 {
 	srb_t *sp;
@@ -3044,6 +3062,13 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 					rval = qla2x00_get_fw_version(vha);
 				if (rval != QLA_SUCCESS)
 					goto failed;
+
+				if (vha->flags.nvmet_enabled) {
+					ql_log(ql_log_info, vha, 0xffff,
+					    "Enabling PUREX mode\n");
+					qla2x00_set_purex_mode(vha);
+				}
+
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
@@ -3261,11 +3286,14 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
 	if (ql2xmvasynctoatio &&
 	    (IS_QLA83XX(ha) || IS_QLA27XX(ha))) {
-		if (qla_tgt_mode_enabled(vha) ||
-		    qla_dual_mode_enabled(vha))
+		if ((qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)) &&
+		    qlt_op_target_mode) {
+			ql_log(ql_log_info, vha, 0xffff,
+			    "Moving Purex to ATIO Q\n");
 			ha->fw_options[2] |= BIT_11;
-		else
+		} else {
 			ha->fw_options[2] &= ~BIT_11;
+		}
 	}
 
 	if (IS_QLA25XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
@@ -4898,7 +4926,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 				    &vha->dpc_flags))
 					break;
 			}
-			if (vha->flags.nvme_enabled) {
+			if (vha->flags.nvme_enabled ||
+			    vha->flags.nvmet_enabled) {
 				if (qla2x00_rff_id(vha, FC_TYPE_NVME)) {
 					ql_dbg(ql_dbg_disc, vha, 0x2049,
 					    "Register NVME FC Type Features failed.\n");
@@ -4940,6 +4969,9 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	if (!vha->nvme_local_port && vha->flags.nvme_enabled)
 		qla_nvme_register_hba(vha);
 
+	if (!vha->targetport && vha->flags.nvmet_enabled)
+		qla_nvmet_create_targetport(vha);
+
 	if (rval)
 		ql_dbg(ql_dbg_disc, vha, 0x2068,
 		    "Configure fabric error exit rval=%d.\n", rval);
@@ -5059,7 +5091,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 				new_fcport->nvme_flag = 0;
 				new_fcport->fc4f_nvme = 0;
-				if (vha->flags.nvme_enabled &&
+				if ((vha->flags.nvme_enabled ||
+				    vha->flags.nvmet_enabled) &&
 				    swl[swl_idx].fc4f_nvme) {
 					new_fcport->fc4f_nvme =
 					    swl[swl_idx].fc4f_nvme;
@@ -7812,6 +7845,12 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] |= BIT_11;
 		else
 			ha->fw_options[2] &= ~BIT_11;
+
+		if (ql2xnvmeenable == 2 && qlt_op_target_mode) {
+			/* Enabled PUREX node */
+			ha->fw_options[1] |= FO1_ENABLE_PUREX;
+			ha->fw_options[2] |= BIT_11;
+		}
 	}
 
 	if (qla_tgt_mode_enabled(vha) ||
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2fd79129bb2a..b1d5947feaea 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1579,6 +1579,12 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			sp->name);
 		sp->done(sp, res);
 		return;
+	case SRB_NVME_ELS_RSP:
+		type = "nvme els";
+		ql_log(ql_log_info, vha, 0xffff,
+			"Completing %s: (%p) type=%d.\n", type, sp, sp->type);
+		sp->done(sp, 0);
+		return;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x503e,
 		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp->type);
@@ -2432,6 +2438,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	if (sp->type == SRB_NVMET_LS) {
+		ql_log(ql_log_info, vha, 0xffff,
+			"Dump NVME-LS response pkt\n");
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+			(uint8_t *)pkt, 64);
+	}
+
 	if (unlikely((state_flags & BIT_1) && (sp->type == SRB_BIDI_CMD))) {
 		qla25xx_process_bidir_status_iocb(vha, pkt, req, handle);
 		return;
@@ -2800,6 +2813,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
 	    pkt->entry_type, pkt->entry_status, pkt->handle, rsp->id);
 
+	ql_log(ql_log_info, vha, 0xffff,
+		"(%s-%d)Dumping the NVMET-ERROR pkt IOCB\n",
+		__func__, __LINE__);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+		(uint8_t *)pkt, 64);
+
 	if (que >= ha->max_req_queues || !ha->req_q_map[que])
 		goto fatal;
 
@@ -2903,10 +2922,56 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
 	if (!sp)
 		return;
 
+	ql_log(ql_log_info, vha, 0xc01f,
+		"Dumping response pkt for SRB type: %#x\n", sp->type);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+		(uint8_t *)pkt, 16);
+
+	comp_status = le16_to_cpu(pkt->status);
+	sp->done(sp, comp_status);
+}
+
+static void qla24xx_nvmet_fcp_iocb(struct scsi_qla_host *vha,
+	struct ctio_nvme_from_27xx *pkt, struct req_que *req)
+{
+	srb_t *sp;
+	const char func[] = "NVMET_FCP_IOCB";
+	uint16_t comp_status;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	if ((pkt->entry_status) || (pkt->status != 1)) {
+		ql_log(ql_log_info, vha, 0xc01f,
+			"Dumping response pkt for SRB type: %#x\n", sp->type);
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+			(uint8_t *)pkt, 16);
+	}
+
 	comp_status = le16_to_cpu(pkt->status);
 	sp->done(sp, comp_status);
 }
 
+void qla24xx_nvmet_abts_resp_iocb(struct scsi_qla_host *vha,
+	struct abts_resp_to_24xx *pkt, struct req_que *req)
+{
+	srb_t *sp;
+	const char func[] = "NVMET_ABTS_RESP_IOCB";
+	uint16_t comp_status;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	ql_log(ql_log_info, vha, 0xc01f,
+		"Dumping response pkt for SRB type: %#x\n", sp->type);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+		(uint8_t *)pkt, 16);
+
+	comp_status = le16_to_cpu(pkt->entry_status);
+	sp->done(sp, comp_status);
+}
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -2984,6 +3049,11 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_nvme_ls4_iocb(vha, (struct pt_ls4_request *)pkt,
 			    rsp->req);
 			break;
+		case CTIO_NVME:
+			qla24xx_nvmet_fcp_iocb(vha,
+			    (struct ctio_nvme_from_27xx *)pkt,
+			    rsp->req);
+			break;
 		case NOTIFY_ACK_TYPE:
 			if (pkt->handle == QLA_TGT_SKIP_HANDLE)
 				qlt_response_pkt_all_vps(vha, rsp,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index cb717d47339f..2616afaf9a58 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -58,6 +58,7 @@ static struct rom_cmd {
 	{ MBC_IOCB_COMMAND_A64 },
 	{ MBC_GET_ADAPTER_LOOP_ID },
 	{ MBC_READ_SFP },
+	{ MBC_SET_RNID_PARAMS },
 };
 
 static int is_rom_cmd(uint16_t cmd)
@@ -1024,9 +1025,11 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		 * FW supports nvme and driver load parameter requested nvme.
 		 * BIT 26 of fw_attributes indicates NVMe support.
 		 */
-		if ((ha->fw_attributes_h & 0x400) && ql2xnvmeenable)
+		if ((ha->fw_attributes_h & 0x400) && (ql2xnvmeenable == 1))
 			vha->flags.nvme_enabled = 1;
 
+		if ((ha->fw_attributes_h & 0x400) && (ql2xnvmeenable == 2))
+			vha->flags.nvmet_enabled = 1;
 	}
 
 	if (IS_QLA27XX(ha)) {
@@ -1101,6 +1104,101 @@ qla2x00_get_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 	return rval;
 }
 
+#define OPCODE_PLOGI_TMPLT 7
+int
+qla2x00_get_plogi_template(scsi_qla_host_t *vha, dma_addr_t buf,
+	uint16_t length)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval;
+
+	mcp->mb[0] = MBC_GET_RNID_PARAMS;
+	mcp->mb[1] = OPCODE_PLOGI_TMPLT << 8;
+	mcp->mb[2] = MSW(LSD(buf));
+	mcp->mb[3] = LSW(LSD(buf));
+	mcp->mb[6] = MSW(MSD(buf));
+	mcp->mb[7] = LSW(MSD(buf));
+	mcp->mb[8] = length;
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->buf_size = length;
+	mcp->flags = MBX_DMA_IN;
+	mcp->tov = MBX_TOV_SECONDS;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	ql_dbg(ql_dbg_mbx, vha, 0x118f,
+	    "%s: %s rval=%x mb[0]=%x,%x.\n", __func__,
+	    (rval == QLA_SUCCESS) ? "Success" : "Failed",
+	    rval, mcp->mb[0], mcp->mb[1]);
+
+	return rval;
+}
+
+#define        OPCODE_LIST_LENGTH      32       /* ELS opcode list */
+#define        OPCODE_ELS_CMD          5        /* MBx1 cmd param */
+/*
+ * qla2x00_set_purex_mode
+ *	Enable purex mode for ELS commands
+ *
+ * Input:
+ *	vha = adapter block pointer.
+ *
+ * Returns:
+ *	qla2x00 local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla2x00_set_purex_mode(scsi_qla_host_t *vha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	uint8_t *els_cmd_map;
+	dma_addr_t els_cmd_map_dma;
+	struct qla_hw_data *ha = vha->hw;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
+	    "Entered %s.\n", __func__);
+
+	els_cmd_map = dma_zalloc_coherent(&ha->pdev->dev, OPCODE_LIST_LENGTH,
+	    &els_cmd_map_dma, GFP_KERNEL);
+	if (!els_cmd_map) {
+		ql_log(ql_log_warn, vha, 0x7101,
+		    "Failed to allocate RDP els command param.\n");
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	els_cmd_map[0] = 0x28; /* enable PLOGI and LOGO ELS */
+	els_cmd_map[4] = 0x13; /* enable PRLI ELS */
+	els_cmd_map[10] = 0x5;
+
+	mcp->mb[0] = MBC_SET_RNID_PARAMS;
+	mcp->mb[1] = OPCODE_ELS_CMD << 8;
+	mcp->mb[2] = MSW(LSD(els_cmd_map_dma));
+	mcp->mb[3] = LSW(LSD(els_cmd_map_dma));
+	mcp->mb[6] = MSW(MSD(els_cmd_map_dma));
+	mcp->mb[7] = LSW(MSD(els_cmd_map_dma));
+	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = MBX_DMA_OUT;
+	mcp->buf_size = OPCODE_LIST_LENGTH;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	ql_dbg(ql_dbg_mbx, vha, 0x118d,
+	    "%s: %s rval=%x mb[0]=%x,%x.\n", __func__,
+	    (rval == QLA_SUCCESS) ? "Success" : "Failed",
+	    rval, mcp->mb[0], mcp->mb[1]);
+
+	dma_free_coherent(&ha->pdev->dev, OPCODE_LIST_LENGTH,
+	   els_cmd_map, els_cmd_map_dma);
+
+	return rval;
+}
+
 
 /*
  * qla2x00_set_fw_options
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index 7f05fa1c77db..be4e2d4f2aee 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -103,39 +103,6 @@ struct pt_ls4_request {
 	uint32_t dseg1_address[2];
 	uint32_t dseg1_len;
 };
-
-#define PT_LS4_UNSOL 0x56	/* pass-up unsolicited rec FC-NVMe request */
-struct pt_ls4_rx_unsol {
-	uint8_t entry_type;
-	uint8_t entry_count;
-	uint16_t rsvd0;
-	uint16_t rsvd1;
-	uint8_t vp_index;
-	uint8_t rsvd2;
-	uint16_t rsvd3;
-	uint16_t nport_handle;
-	uint16_t frame_size;
-	uint16_t rsvd4;
-	uint32_t exchange_address;
-	uint8_t d_id[3];
-	uint8_t r_ctl;
-	uint8_t s_id[3];
-	uint8_t cs_ctl;
-	uint8_t f_ctl[3];
-	uint8_t type;
-	uint16_t seq_cnt;
-	uint8_t df_ctl;
-	uint8_t seq_id;
-	uint16_t rx_id;
-	uint16_t ox_id;
-	uint32_t param;
-	uint32_t desc0;
-#define PT_LS4_PAYLOAD_OFFSET 0x2c
-#define PT_LS4_FIRST_PACKET_LEN 20
-	uint32_t desc_len;
-	uint32_t payload[3];
-};
-
 /*
  * Global functions prototype in qla_nvme.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 66fe5e386b10..3b9e4745eaf8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -135,13 +135,17 @@ MODULE_PARM_DESC(ql2xenabledif,
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
 int ql2xnvmeenable = 1;
+#elif (IS_ENABLED(CONFIG_NVME_TARGET_FC))
+int ql2xnvmeenable = 2;
 #else
 int ql2xnvmeenable;
 #endif
 module_param(ql2xnvmeenable, int, 0644);
 MODULE_PARM_DESC(ql2xnvmeenable,
-    "Enables NVME support. "
-    "0 - no NVMe.  Default is Y");
+		"Enables NVME support.\n"
+		"0 - no NVMe.\n"
+		"1 - initiator,\n"
+		"2 - target. Default is 1\n");
 
 int ql2xenablehba_err_chk = 2;
 module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
@@ -3607,6 +3611,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla_nvme_delete(base_vha);
 
+	qla_nvmet_delete(base_vha);
+
 	dma_free_coherent(&ha->pdev->dev,
 		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
 
@@ -4772,6 +4778,54 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	}
 }
 
+/* NVMET */
+static
+void qla24xx_create_new_nvmet_sess(struct scsi_qla_host *vha,
+	struct qla_work_evt *e)
+{
+	unsigned long flags;
+	fc_port_t *fcport = NULL;
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
+	if (fcport) {
+		ql_log(ql_log_info, vha, 0x11020,
+		    "Found fcport: %p for WWN: %8phC\n", fcport,
+		    e->u.new_sess.port_name);
+		fcport->d_id = e->u.new_sess.id;
+
+		/* Session existing with No loop_ID assigned */
+		if (fcport->loop_id == FC_NO_LOOP_ID) {
+			fcport->loop_id = qla2x00_find_new_loop_id(vha, fcport);
+			ql_log(ql_log_info, vha, 0x11021,
+			    "Allocated new loop_id: %#x for fcport: %p\n",
+			    fcport->loop_id, fcport);
+			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+		}
+	} else {
+		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+		if (fcport) {
+			fcport->d_id = e->u.new_sess.id;
+			fcport->loop_id = qla2x00_find_new_loop_id(vha, fcport);
+			ql_log(ql_log_info, vha, 0x11022,
+			    "Allocated new loop_id: %#x for fcport: %p\n",
+			    fcport->loop_id, fcport);
+
+			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->flags |= FCF_FABRIC_DEVICE;
+			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+
+			memcpy(fcport->port_name, e->u.new_sess.port_name,
+			    WWN_SIZE);
+
+			list_add_tail(&fcport->list, &vha->vp_fcports);
+		}
+	}
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	complete(&vha->purex_plogi_sess);
+}
+
 void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -4850,6 +4904,10 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_NACK:
 			qla24xx_do_nack_work(vha, e);
 			break;
+		/* FC-NVMe Target */
+		case QLA_EVT_NEW_NVMET_SESS:
+			qla24xx_create_new_nvmet_sess(vha, e);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
@@ -5793,6 +5851,12 @@ qla2x00_do_dpc(void *data)
 				set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 		}
 
+		if (test_and_clear_bit(NVMET_PUREX, &base_vha->dpc_flags)) {
+			ql_log(ql_log_info, base_vha, 0x11022,
+			    "qla2xxx-nvmet: Received a frame on the wire\n");
+			qlt_dequeue_purex(base_vha);
+		}
+
 		if (test_and_clear_bit(ISP_ABORT_NEEDED,
 						&base_vha->dpc_flags)) {
 
@@ -5944,6 +6008,13 @@ qla2x00_do_dpc(void *data)
 						ha->nvme_last_rptd_aen);
 			}
 		}
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
+		if (test_and_clear_bit(NVMET_PUREX, &base_vha->dpc_flags)) {
+			ql_log(ql_log_info, base_vha, 0x11025,
+				"nvmet: Received a frame on the wire\n");
+			qlt_dequeue_purex(base_vha);
+		}
+#endif
 
 		if (!IS_QLAFX00(ha))
 			qla2x00_do_dpc_all_vps(base_vha);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 12976a25f082..ec996fbc35f0 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -40,6 +40,7 @@
 #include <target/target_core_fabric.h>
 
 #include "qla_def.h"
+#include "qla_nvmet.h"
 #include "qla_target.h"
 
 static int ql2xtgt_tape_enable;
@@ -77,6 +78,8 @@ int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
 static int temp_sam_status = SAM_STAT_BUSY;
 
+int qlt_op_target_mode;
+
 /*
  * From scsi/fc/fc_fcp.h
  */
@@ -146,8 +149,10 @@ static void qlt_send_busy(struct qla_qpair *, struct atio_from_isp *,
  */
 static struct kmem_cache *qla_tgt_mgmt_cmd_cachep;
 struct kmem_cache *qla_tgt_plogi_cachep;
+static struct kmem_cache *qla_tgt_purex_plogi_cachep;
 static mempool_t *qla_tgt_mgmt_cmd_mempool;
 static struct workqueue_struct *qla_tgt_wq;
+static struct workqueue_struct *qla_nvmet_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
 static LIST_HEAD(qla_tgt_glist);
 
@@ -345,13 +350,652 @@ void qlt_unknown_atio_work_fn(struct work_struct *work)
 	qlt_try_to_dequeue_unknown_atios(vha, 0);
 }
 
+#define ELS_RJT 0x01
+#define ELS_ACC 0x02
+
+struct fc_port *qla_nvmet_find_sess_by_s_id(
+	scsi_qla_host_t *vha,
+	const uint32_t s_id)
+{
+	struct fc_port *sess = NULL, *other_sess;
+	uint32_t other_sid;
+
+	list_for_each_entry(other_sess, &vha->vp_fcports, list) {
+		other_sid = other_sess->d_id.b.domain << 16 |
+				other_sess->d_id.b.area << 8 |
+				other_sess->d_id.b.al_pa;
+
+		if (other_sid == s_id) {
+			sess = other_sess;
+			break;
+		}
+	}
+	return sess;
+}
+
+/* Send an ELS response */
+int qlt_send_els_resp(srb_t *sp, struct __els_pt *els_pkt)
+{
+	struct purex_entry_24xx *purex = (struct purex_entry_24xx *)
+					sp->u.snvme_els.ptr;
+	dma_addr_t udma = sp->u.snvme_els.dma_addr;
+	struct fc_port *fcport;
+	port_id_t port_id;
+	uint16_t loop_id;
+
+	port_id.b.domain = purex->s_id[2];
+	port_id.b.area   = purex->s_id[1];
+	port_id.b.al_pa  = purex->s_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	fcport = qla2x00_find_fcport_by_nportid(sp->vha, &port_id, 1);
+	if (fcport)
+		/* There is no session with the swt */
+		loop_id = fcport->loop_id;
+	else
+		loop_id = 0xFFFF;
+
+	ql_log(ql_log_info, sp->vha, 0xfff9,
+	    "sp: %p, purex: %p, udam: %#llx, loop_id: 0x%x\n",
+	    sp, purex, udma, loop_id);
+
+	els_pkt->entry_type = ELS_IOCB_TYPE;
+	els_pkt->entry_count = 1;
+
+	els_pkt->handle = sp->handle;
+	els_pkt->nphdl = cpu_to_le16(loop_id);
+	els_pkt->tx_dsd_cnt = cpu_to_le16(1);
+	els_pkt->vp_index = purex->vp_idx;
+	els_pkt->sof = EST_SOFI3;
+	els_pkt->rcv_exchg_id = cpu_to_le32(purex->rx_xchg_addr);
+	els_pkt->op_code = sp->cmd_type;
+	els_pkt->did_lo = cpu_to_le16(purex->s_id[0] | (purex->s_id[1] << 8));
+	els_pkt->did_hi = purex->s_id[2];
+	els_pkt->sid_hi = purex->d_id[2];
+	els_pkt->sid_lo = cpu_to_le16(purex->d_id[0] | (purex->d_id[1] << 8));
+
+	if (sp->gen2 == ELS_ACC)
+		els_pkt->cntl_flags = cpu_to_le16(EPD_ELS_ACC);
+	else
+		els_pkt->cntl_flags = cpu_to_le16(EPD_ELS_RJT);
+
+	els_pkt->tx_bc = cpu_to_le32(sp->gen1);
+	els_pkt->tx_dsd[0] = cpu_to_le32(LSD(udma));
+	els_pkt->tx_dsd[1] = cpu_to_le32(MSD(udma));
+	els_pkt->tx_dsd_len = cpu_to_le32(sp->gen1);
+	/* Memory Barrier */
+	wmb();
+
+	ql_log(ql_log_info, sp->vha, 0x11030, "Dumping PLOGI ELS\n");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, sp->vha, 0xffff,
+		(uint8_t *)els_pkt, sizeof(*els_pkt));
+
+	return 0;
+}
+
+static void qlt_nvme_els_done(void *s, int res)
+{
+	struct srb *sp = s;
+
+	ql_log(ql_log_info, sp->vha, 0x11031,
+	    "Done with NVME els command\n");
+
+	ql_log(ql_log_info, sp->vha, 0x11032,
+	    "sp: %p vha: %p, dma_ptr: %p, dma_addr: %#llx, len: %#x\n",
+	    sp, sp->vha, sp->u.snvme_els.dma_ptr, sp->u.snvme_els.dma_addr,
+	    sp->gen1);
+
+	qla2x00_rel_sp(sp);
+}
+
+static int qlt_send_plogi_resp(struct scsi_qla_host *vha, uint8_t op_code,
+	struct purex_entry_24xx *purex, struct fc_port *fcport)
+{
+	int ret, rval, i;
+	dma_addr_t plogi_ack_udma = vha->vha_tgt.qla_tgt->nvme_els_rsp;
+	void *plogi_ack_buf = vha->vha_tgt.qla_tgt->nvme_els_ptr;
+	uint8_t *tmp;
+	uint32_t *opcode;
+	srb_t *sp;
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp) {
+		ql_log(ql_log_info, vha, 0x11033,
+		    "Failed to allocate SRB\n");
+		return -ENOMEM;
+	}
+
+	sp->type = SRB_NVME_ELS_RSP;
+	sp->done = qlt_nvme_els_done;
+	sp->vha = vha;
+
+	ql_log(ql_log_info, vha, 0x11034,
+	    "sp: %p, vha: %p, plogi_ack_buf: %p, plogi_ack_udma: %#llx\n",
+	    sp, vha, plogi_ack_buf, plogi_ack_udma);
+
+	sp->u.snvme_els.dma_addr = plogi_ack_udma;
+	sp->u.snvme_els.dma_ptr = plogi_ack_buf;
+	sp->gen1 = 116;
+	sp->gen2 = ELS_ACC;
+	sp->u.snvme_els.ptr = (struct purex_entry_24xx *)purex;
+	sp->cmd_type = ELS_PLOGI;
+
+	tmp = (uint8_t *)plogi_ack_udma;
+
+	tmp += 4;	/* fw doesn't return 1st 4 bytes where opcode goes */
+
+	ret = qla2x00_get_plogi_template(vha, (uint64_t)tmp, (116/4 - 1));
+	if (ret) {
+		ql_log(ql_log_warn, vha, 0x11035,
+		    "Failed to get plogi template\n");
+		return -ENOMEM;
+	}
+
+	opcode = (uint32_t *) plogi_ack_buf;
+	*opcode = cpu_to_be32(ELS_ACC << 24);
+
+	for (i = 0; i < 0x1c; i++) {
+		++opcode;
+		*opcode = cpu_to_be32(*opcode);
+	}
+
+	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xfff3,
+	    "Dumping the PLOGI from fw\n");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_verbose, vha, 0x70cf,
+		(uint8_t *)plogi_ack_buf, 116);
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		qla2x00_rel_sp(sp);
+
+	return 0;
+}
+
+static struct qlt_purex_plogi_ack_t *
+qlt_plogi_find_add(struct scsi_qla_host *vha, port_id_t *id,
+		struct __fc_plogi *rcvd_plogi)
+{
+	struct qlt_purex_plogi_ack_t *pla;
+
+	list_for_each_entry(pla, &vha->plogi_ack_list, list) {
+		if (pla->id.b24 == id->b24)
+			return pla;
+	}
+
+	pla = kmem_cache_zalloc(qla_tgt_purex_plogi_cachep, GFP_ATOMIC);
+	if (!pla) {
+		ql_dbg(ql_dbg_async, vha, 0x5088,
+		       "qla_target(%d): Allocation of plogi_ack failed\n",
+		       vha->vp_idx);
+		return NULL;
+	}
+
+	pla->id = *id;
+	memcpy(&pla->rcvd_plogi, rcvd_plogi, sizeof(struct __fc_plogi));
+	ql_log(ql_log_info, vha, 0xf101,
+	    "New session(%p) created for port: %#x\n",
+	    pla, pla->id.b24);
+
+	list_add_tail(&pla->list, &vha->plogi_ack_list);
+
+	return pla;
+}
+
+static void __swap_wwn(uint8_t *ptr, uint32_t size)
+{
+	uint32_t *iptr = (uint32_t *)ptr;
+	uint32_t *optr = (uint32_t *)ptr;
+	uint32_t i = size >> 2;
+
+	for (; i ; i--)
+		*optr++ = be32_to_cpu(*iptr++);
+}
+
+static int abort_cmds_for_s_id(struct scsi_qla_host *vha, port_id_t *s_id);
+/*
+ * Parse the PLOGI from the peer port
+ * Retrieve WWPN, WWNN from the payload
+ * Create and fc port if it is a new WWN
+ * else clean up the prev exchange
+ * Return a response
+ *
+ */
+static void qlt_process_plogi(struct scsi_qla_host *vha,
+		struct purex_entry_24xx *purex, void *buf)
+{
+	uint64_t pname, nname;
+	struct __fc_plogi *rcvd_plogi = (struct __fc_plogi *)buf;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	uint16_t loop_id;
+	unsigned long flags;
+	struct fc_port *sess = NULL, *conflict_sess = NULL;
+	struct qlt_purex_plogi_ack_t *pla;
+	port_id_t port_id;
+	int sess_handling = 0;
+
+	port_id.b.domain = purex->s_id[2];
+	port_id.b.area   = purex->s_id[1];
+	port_id.b.al_pa  = purex->s_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	if (IS_SW_RESV_ADDR(port_id)) {
+		ql_log(ql_log_info, vha, 0x11036,
+		    "Received plogi from switch, just send an ACC\n");
+		goto send_plogi_resp;
+	}
+
+	loop_id = le16_to_cpu(purex->nport_handle);
+
+	/* Clean up prev commands if any */
+	if (sess_handling) {
+		ql_log(ql_log_info, vha, 0x11037,
+		   "%s %d Cleaning up prev commands\n",
+		   __func__, __LINE__);
+		abort_cmds_for_s_id(vha, &port_id);
+	}
+
+	__swap_wwn(rcvd_plogi->pname, 4);
+	__swap_wwn(&rcvd_plogi->pname[4], 4);
+	pname = wwn_to_u64(rcvd_plogi->pname);
+
+	__swap_wwn(rcvd_plogi->nname, 4);
+	__swap_wwn(&rcvd_plogi->nname[4], 4);
+	nname = wwn_to_u64(rcvd_plogi->nname);
+
+	ql_log(ql_log_info, vha, 0x11038,
+	    "%s %d, pname:%llx, nname:%llx port_id: %#x\n",
+	    __func__, __LINE__, pname, nname, loop_id);
+
+	/* Invalidate other sessions if any */
+	spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
+	sess = qlt_find_sess_invalidate_other(vha, pname,
+	    port_id, loop_id, &conflict_sess);
+	spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
+
+	/* Add the inbound plogi(if from a new device) to the list */
+	pla = qlt_plogi_find_add(vha, &port_id, rcvd_plogi);
+
+	/* If there is no existing session, create one */
+	if (unlikely(!sess)) {
+		ql_log(ql_log_info, vha, 0xf102,
+		    "Creating a new session\n");
+		init_completion(&vha->purex_plogi_sess);
+		qla24xx_post_nvmet_newsess_work(vha, &port_id,
+			rcvd_plogi->pname, pla);
+		wait_for_completion_timeout(&vha->purex_plogi_sess, 500);
+		/* Send a PLOGI response */
+		goto send_plogi_resp;
+	} else {
+		/* Session existing with No loop_ID assigned */
+		if (sess->loop_id == FC_NO_LOOP_ID) {
+			sess->loop_id = qla2x00_find_new_loop_id(vha, sess);
+			ql_log(ql_log_info, vha, 0x11039,
+			    "Allocated new loop_id: %#x for fcport: %p\n",
+			    sess->loop_id, sess);
+		}
+		sess->d_id = port_id;
+
+		sess->fw_login_state = DSC_LS_PLOGI_PEND;
+	}
+send_plogi_resp:
+	/* Send a PLOGI response */
+	qlt_send_plogi_resp(vha, ELS_PLOGI, purex, sess);
+}
+
+static int qlt_process_logo(struct scsi_qla_host *vha,
+		struct purex_entry_24xx *purex, void *buf)
+{
+	struct __fc_logo_acc *logo_acc;
+	dma_addr_t logo_ack_udma = vha->vha_tgt.qla_tgt->nvme_els_rsp;
+	void *logo_ack_buf = vha->vha_tgt.qla_tgt->nvme_els_ptr;
+	srb_t *sp;
+	int rval;
+	uint32_t look_up_sid;
+	fc_port_t *sess = NULL;
+	port_id_t port_id;
+
+	port_id.b.domain = purex->s_id[2];
+	port_id.b.area   = purex->s_id[1];
+	port_id.b.al_pa  = purex->s_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	if (!IS_SW_RESV_ADDR(port_id)) {
+		look_up_sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 |
+				purex->s_id[0];
+		ql_log(ql_log_info, vha, 0x11040,
+			"%s - Look UP sid: %#x\n", __func__, look_up_sid);
+
+		sess = qla_nvmet_find_sess_by_s_id(vha, look_up_sid);
+		if (unlikely(!sess))
+			WARN_ON(1);
+	}
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp) {
+		ql_log(ql_log_info, vha, 0x11041,
+		    "Failed to allocate SRB\n");
+		return -ENOMEM;
+	}
+
+	sp->type = SRB_NVME_ELS_RSP;
+	sp->done = qlt_nvme_els_done;
+	sp->vha = vha;
+	sp->fcport = sess;
+
+	ql_log(ql_log_info, vha, 0x11042,
+	    "sp: %p, vha: %p, logo_ack_buf: %p, logo_ack_buf: %#llx\n",
+	    sp, vha, logo_ack_buf, logo_ack_udma);
+
+	logo_acc = (struct __fc_logo_acc *)logo_ack_buf;
+	memset(logo_acc, 0, sizeof(*logo_acc));
+	logo_acc->op_code = ELS_ACC;
+
+	/* Send response */
+	sp->u.snvme_els.dma_addr = logo_ack_udma;
+	sp->u.snvme_els.dma_ptr = logo_ack_buf;
+	sp->gen1 = sizeof(struct __fc_logo_acc);
+	sp->gen2 = ELS_ACC;
+	sp->u.snvme_els.ptr = (struct purex_entry_24xx *)purex;
+	sp->cmd_type = ELS_LOGO;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		qla2x00_rel_sp(sp);
+
+	return 0;
+}
+
+static int qlt_process_prli(struct scsi_qla_host *vha,
+		struct purex_entry_24xx *purex, void *buf)
+{
+	struct __fc_prli *prli = (struct __fc_prli *)buf;
+	struct __fc_prli_acc *prli_acc;
+	struct __fc_prli_rjt *prli_rej;
+	dma_addr_t prli_ack_udma = vha->vha_tgt.qla_tgt->nvme_els_rsp;
+	void *prli_ack_buf = vha->vha_tgt.qla_tgt->nvme_els_ptr;
+	srb_t *sp;
+	struct fc_port *sess = NULL;
+	int rval;
+	uint32_t look_up_sid;
+	port_id_t port_id;
+
+	port_id.b.domain = purex->s_id[2];
+	port_id.b.area   = purex->s_id[1];
+	port_id.b.al_pa  = purex->s_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	if (!IS_SW_RESV_ADDR(port_id)) {
+		look_up_sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 |
+				purex->s_id[0];
+		ql_log(ql_log_info, vha, 0x11043,
+		    "%s - Look UP sid: %#x\n", __func__, look_up_sid);
+
+		sess = qla_nvmet_find_sess_by_s_id(vha, look_up_sid);
+		if (unlikely(!sess))
+			WARN_ON(1);
+	}
+	/* Alloc SRB structure */
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp) {
+		ql_log(ql_log_info, vha, 0x11044,
+		    "Failed to allocate SRB\n");
+		return -ENOMEM;
+	}
+
+	sp->type = SRB_NVME_ELS_RSP;
+	sp->done = qlt_nvme_els_done;
+	sp->vha = vha;
+	sp->fcport = sess;
+
+	ql_log(ql_log_info, vha, 0x11045,
+	    "sp: %p, vha: %p, prli_ack_buf: %p, prli_ack_udma: %#llx\n",
+	    sp, vha, prli_ack_buf, prli_ack_udma);
+
+	memset(prli_ack_buf, 0, sizeof(struct __fc_prli_acc));
+
+	/* Parse PRLI */
+	if (prli->prli_type == PRLI_TYPE_FCP) {
+		/* Send a RJT for FCP */
+		prli_rej = (struct __fc_prli_rjt *)prli_ack_buf;
+		prli_rej->op_code = ELS_RJT;
+		prli_rej->reason = PRLI_RJT_REASON;
+	} else if (prli->prli_type == PRLI_TYPE_NVME) {
+		uint32_t spinfo;
+
+		prli_acc = (struct __fc_prli_acc *)prli_ack_buf;
+		prli_acc->op_code = ELS_ACC;
+		prli_acc->type = PRLI_TYPE_NVME;
+		prli_acc->page_length = PRLI_NVME_PAGE_LENGTH;
+		prli_acc->common = cpu_to_be16(PRLI_REQ_EXEC);
+		prli_acc->pyld_length = cpu_to_be16(PRLI_ACC_NVME_RESP_LEN);
+		spinfo = NVME_PRLI_DISC | NVME_PRLI_TRGT;
+		prli_acc->nvme.sp_info = cpu_to_be32(spinfo);
+	}
+
+	/* Send response */
+	sp->u.snvme_els.dma_addr = prli_ack_udma;
+	sp->u.snvme_els.dma_ptr = prli_ack_buf;
+
+	if (prli->prli_type == PRLI_TYPE_FCP) {
+		sp->gen1 = sizeof(struct __fc_prli_rjt);
+		sp->gen2 = ELS_RJT;
+	} else if (prli->prli_type == PRLI_TYPE_NVME) {
+		sp->gen1 = sizeof(struct __fc_prli_acc);
+		sp->gen2 = ELS_ACC;
+	}
+
+	sp->u.snvme_els.ptr = (struct purex_entry_24xx *)purex;
+	sp->cmd_type = ELS_PRLI;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		qla2x00_rel_sp(sp);
+
+	return 0;
+}
+
+static void *qlt_get_next_atio_pkt(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	void *pkt;
+
+	ha->tgt.atio_ring_index++;
+	if (ha->tgt.atio_ring_index == ha->tgt.atio_q_length) {
+		ha->tgt.atio_ring_index = 0;
+		ha->tgt.atio_ring_ptr = ha->tgt.atio_ring;
+	} else {
+		ha->tgt.atio_ring_ptr++;
+	}
+	pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
+
+	return pkt;
+}
+
+static void qlt_process_purex(struct scsi_qla_host *vha,
+		struct qla_tgt_purex_op *p)
+{
+	struct atio_from_isp *atio = &p->atio;
+	struct purex_entry_24xx *purex =
+		(struct purex_entry_24xx *)&atio->u.raw;
+	uint16_t len = purex->frame_size;
+
+	ql_log(ql_log_info, vha, 0xf100,
+	    "Purex IOCB: EC:%#x, Len:%#x ELS_OP:%#x oxid:%#x  rxid:%#x\n",
+	    purex->entry_count, len, purex->pyld[3],
+	    purex->ox_id, purex->rx_id);
+
+	switch (purex->pyld[3]) {
+	case ELS_PLOGI:
+		qlt_process_plogi(vha, purex, p->purex_pyld);
+		break;
+	case ELS_PRLI:
+		qlt_process_prli(vha, purex, p->purex_pyld);
+		break;
+	case ELS_LOGO:
+		qlt_process_logo(vha, purex, p->purex_pyld);
+		break;
+	default:
+		ql_log(ql_log_warn, vha, 0x11046,
+		    "Unexpected ELS 0x%x\n", purex->pyld[3]);
+		break;
+	}
+}
+
+void qlt_dequeue_purex(struct scsi_qla_host *vha)
+{
+	struct qla_tgt_purex_op *p, *t;
+	unsigned long flags;
+
+	list_for_each_entry_safe(p, t, &vha->purex_atio_list, cmd_list) {
+		ql_log(ql_log_info, vha, 0xff1e,
+		    "Processing ATIO %p\n", &p->atio);
+
+		qlt_process_purex(vha, p);
+		spin_lock_irqsave(&vha->cmd_list_lock, flags);
+		list_del(&p->cmd_list);
+		spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+		kfree(p->purex_pyld);
+		kfree(p);
+	}
+}
+
+static void qlt_queue_purex(scsi_qla_host_t *vha,
+	struct atio_from_isp *atio)
+{
+	struct qla_tgt_purex_op *p;
+	unsigned long flags;
+	struct purex_entry_24xx *purex =
+		(struct purex_entry_24xx *)&atio->u.raw;
+	uint16_t len = purex->frame_size;
+	uint8_t *purex_pyld_tmp;
+
+	p = kzalloc(sizeof(*p), GFP_ATOMIC);
+	if (p == NULL)
+		goto out;
+
+	p->vha = vha;
+	memcpy(&p->atio, atio, sizeof(*atio));
+
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xff11,
+	    "Dumping the Purex IOCB received\n");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe012,
+		(uint8_t *)purex, 64);
+
+	p->purex_pyld = kzalloc(sizeof(purex->entry_count * 64), GFP_ATOMIC);
+	purex_pyld_tmp = (uint8_t *)p->purex_pyld;
+	p->purex_pyld_len = len;
+
+	if (len < PUREX_PYLD_SIZE)
+		len = PUREX_PYLD_SIZE;
+
+	memcpy(p->purex_pyld, &purex->d_id, PUREX_PYLD_SIZE);
+	purex_pyld_tmp += PUREX_PYLD_SIZE;
+	len -= PUREX_PYLD_SIZE;
+
+	while (len > 0) {
+		int cpylen;
+		struct __status_cont *cont_atio;
+
+		cont_atio = (struct __status_cont *)qlt_get_next_atio_pkt(vha);
+		cpylen = len > CONT_SENSE_DATA ? CONT_SENSE_DATA : len;
+		ql_log(ql_log_info, vha, 0xff12,
+		    "cont_atio: %p, cpylen: %#x\n", cont_atio, cpylen);
+
+		memcpy(purex_pyld_tmp, &cont_atio->data[0], cpylen);
+
+		purex_pyld_tmp += cpylen;
+		len -= cpylen;
+	}
+
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xff11,
+	    "Dumping the Purex IOCB(%p) received\n", p->purex_pyld);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe011,
+		(uint8_t *)p->purex_pyld, p->purex_pyld_len);
+
+	INIT_LIST_HEAD(&p->cmd_list);
+
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
+	list_add_tail(&p->cmd_list, &vha->purex_atio_list);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+
+out:
+	return;
+}
+
+static void sys_to_be32_cpy(uint8_t *dest, uint8_t *src, uint16_t len)
+{
+	uint32_t *d, *s, i;
+
+	d = (uint32_t *) dest;
+	s = (uint32_t *) src;
+	for (i = 0; i < len; i++)
+		d[i] = cpu_to_be32(s[i]);
+}
+
+/* Prepare an LS req received from the wire to be sent to the nvmet */
+static void *qlt_nvmet_prepare_ls(struct scsi_qla_host *vha,
+	struct pt_ls4_rx_unsol *ls4)
+{
+	int desc_len = cpu_to_le16(ls4->desc_len) + 8;
+	int copy_len, bc;
+	void *buf;
+	uint8_t *cpy_buf;
+	int i;
+	struct __status_cont *cont_atio;
+
+	ql_dbg(ql_dbg_tgt, vha, 0xe072,
+	    "%s: desc_len:%d\n", __func__, desc_len);
+
+	buf = kzalloc(desc_len, GFP_ATOMIC);
+	if (!buf) {
+		ql_dbg(ql_dbg_tgt, vha, 0xe072,
+		    "%s: Failed to allocate mem\n", __func__);
+		return NULL;
+	}
+	cpy_buf = buf;
+	bc = desc_len;
+
+	if (bc < PT_LS4_FIRST_PACKET_LEN)
+		copy_len = bc;
+	else
+		copy_len = PT_LS4_FIRST_PACKET_LEN;
+
+	sys_to_be32_cpy(cpy_buf, &((uint8_t *)ls4)[PT_LS4_PAYLOAD_OFFSET],
+				copy_len/4);
+
+	bc -= copy_len;
+	cpy_buf += copy_len;
+
+	cont_atio = (struct __status_cont *)ls4;
+
+	for (i = 1; i < ls4->entry_count && bc > 0; i++) {
+		if (bc < CONT_SENSE_DATA)
+			copy_len = bc;
+		else
+			copy_len = CONT_SENSE_DATA;
+
+		cont_atio = (struct __status_cont *)qlt_get_next_atio_pkt(vha);
+
+		sys_to_be32_cpy(cpy_buf, (uint8_t *)&cont_atio->data,
+			copy_len/4);
+		cpy_buf += copy_len;
+		bc -= copy_len;
+	}
+
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xc0f1,
+	    "Dump the first 128 bytes of LS request\n");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+		(uint8_t *)buf, 128);
+
+	return buf;
+}
+
 static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint8_t ha_locked)
 {
-	ql_dbg(ql_dbg_tgt, vha, 0xe072,
-		"%s: qla_target(%d): type %x ox_id %04x\n",
-		__func__, vha->vp_idx, atio->u.raw.entry_type,
-		be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id));
+	void *buf;
 
 	switch (atio->u.raw.entry_type) {
 	case ATIO_TYPE7:
@@ -424,18 +1068,53 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 		}
 		if (!ha_locked)
 			spin_lock_irqsave(&host->hw->hardware_lock, flags);
+
+		if (unlikely(atio->u.nvme_isp27.fcnvme_hdr.scsi_fc_id ==
+			NVMEFC_CMD_IU_SCSI_FC_ID))
+			qla_nvmet_handle_abts(host, entry);
+
 		qlt_24xx_handle_abts(host, (struct abts_recv_from_24xx *)atio);
 		if (!ha_locked)
 			spin_unlock_irqrestore(&host->hw->hardware_lock, flags);
 		break;
 	}
 
-	/* case PUREX_IOCB_TYPE: ql2xmvasynctoatio */
+	/* NVME */
+	case ATIO_PURLS:
+	{
+		struct scsi_qla_host *host = vha;
+		unsigned long flags;
+
+		/* Received an LS4 from the init, pass it to the NVMEt */
+		ql_log(ql_log_info, vha, 0x11047,
+		    "%s %d Received an LS4 from the initiator on ATIO\n",
+		    __func__, __LINE__);
+		spin_lock_irqsave(&host->hw->hardware_lock, flags);
+		buf = qlt_nvmet_prepare_ls(host,
+		    (struct pt_ls4_rx_unsol *)atio);
+		if (buf)
+			qla_nvmet_handle_ls(host,
+			    (struct pt_ls4_rx_unsol *)atio, buf);
+		spin_unlock_irqrestore(&host->hw->hardware_lock, flags);
+	}
+	break;
+
+	case PUREX_IOCB_TYPE: /* NVMET */
+	{
+		/* Received a PUREX IOCB */
+		/* Queue the iocb and wake up dpc */
+		qlt_queue_purex(vha, atio);
+		set_bit(NVMET_PUREX, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		break;
+	}
 
 	default:
 		ql_dbg(ql_dbg_tgt, vha, 0xe040,
 		    "qla_target(%d): Received unknown ATIO atio "
 		    "type %x\n", vha->vp_idx, atio->u.raw.entry_type);
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe011,
+		    (uint8_t *)atio, sizeof(*atio));
 		break;
 	}
 
@@ -537,6 +1216,10 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha,
 			break;
 		}
 		qlt_response_pkt(host, rsp, pkt);
+		if (unlikely(qlt_op_target_mode))
+			qla24xx_nvmet_abts_resp_iocb(vha,
+				(struct abts_resp_to_24xx *)pkt,
+				rsp->req);
 		break;
 	}
 
@@ -1563,6 +2246,11 @@ static void qlt_release(struct qla_tgt *tgt)
 	if (ha->tgt.tgt_ops && ha->tgt.tgt_ops->remove_target)
 		ha->tgt.tgt_ops->remove_target(vha);
 
+	if (tgt->nvme_els_ptr) {
+		dma_free_coherent(&vha->hw->pdev->dev, 256,
+			tgt->nvme_els_ptr, tgt->nvme_els_rsp);
+	}
+
 	vha->vha_tgt.qla_tgt = NULL;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00d,
@@ -5336,6 +6024,101 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha, struct qla_qpair *qpair,
 	return 1;
 }
 
+/*
+ * Worker thread that dequeues the nvme cmd off the list and
+ * called nvme-t to process the cmd
+ */
+static void qla_nvmet_work(struct work_struct *work)
+{
+	struct qla_nvmet_cmd *cmd =
+		container_of(work, struct qla_nvmet_cmd, work);
+	scsi_qla_host_t *vha = cmd->vha;
+
+	qla_nvmet_process_cmd(vha, cmd);
+}
+/*
+ * Handle the NVME cmd IU
+ */
+static void qla_nvmet_handle_cmd(struct scsi_qla_host *vha,
+		struct atio_from_isp *atio)
+{
+	struct qla_nvmet_cmd *tgt_cmd;
+	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
+	struct fc_port *fcport;
+	struct fcp_hdr *fcp_hdr;
+	uint32_t s_id = 0;
+	void *next_pkt;
+	uint8_t *nvmet_cmd_ptr;
+	uint32_t nvmet_cmd_iulen = 0;
+	uint32_t nvmet_cmd_iulen_min = 64;
+
+	/* Create an NVME cmd and queue it up to the work queue */
+	tgt_cmd = kzalloc(sizeof(struct qla_nvmet_cmd), GFP_ATOMIC);
+	if (tgt_cmd == NULL)
+		return;
+
+	tgt_cmd->vha = vha;
+
+	fcp_hdr = &atio->u.nvme_isp27.fcp_hdr;
+
+	/* Get the session for this command */
+	s_id = fcp_hdr->s_id[0] << 16 | fcp_hdr->s_id[1] << 8
+		| fcp_hdr->s_id[2];
+	tgt_cmd->ox_id = fcp_hdr->ox_id;
+
+	fcport = qla_nvmet_find_sess_by_s_id(vha, s_id);
+	if (unlikely(!fcport)) {
+		ql_log(ql_log_warn, vha, 0x11049,
+			"Cant' find the session for port_id: %#x\n", s_id);
+		kfree(tgt_cmd);
+		return;
+	}
+
+	tgt_cmd->fcport = fcport;
+
+	memcpy(&tgt_cmd->atio, atio, sizeof(*atio));
+
+	/* The FC-NMVE cmd covers 2 ATIO IOCBs */
+
+	nvmet_cmd_ptr = (uint8_t *)&tgt_cmd->nvme_cmd_iu;
+	nvmet_cmd_iulen = be16_to_cpu(atio->u.nvme_isp27.fcnvme_hdr.iu_len) * 4;
+	tgt_cmd->cmd_len = nvmet_cmd_iulen;
+
+	if (unlikely(ha->tgt.atio_ring_index + atio->u.raw.entry_count >
+			ha->tgt.atio_q_length)) {
+		uint8_t i;
+
+		memcpy(nvmet_cmd_ptr, &((uint8_t *)atio)[NVME_ATIO_CMD_OFF],
+			ATIO_NVME_FIRST_PACKET_CMDLEN);
+		nvmet_cmd_ptr += ATIO_NVME_FIRST_PACKET_CMDLEN;
+		nvmet_cmd_iulen -= ATIO_NVME_FIRST_PACKET_CMDLEN;
+
+		for (i = 1; i < atio->u.raw.entry_count; i++) {
+			uint8_t cplen = min(nvmet_cmd_iulen_min,
+			nvmet_cmd_iulen);
+
+			next_pkt = qlt_get_next_atio_pkt(vha);
+			memcpy(nvmet_cmd_ptr, (uint8_t *)next_pkt, cplen);
+			nvmet_cmd_ptr += cplen;
+			nvmet_cmd_iulen -= cplen;
+		}
+	} else {
+		memcpy(nvmet_cmd_ptr, &((uint8_t *)atio)[NVME_ATIO_CMD_OFF],
+			nvmet_cmd_iulen);
+		next_pkt = qlt_get_next_atio_pkt(vha);
+	}
+
+	/* Add cmd to the list */
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
+	list_add_tail(&tgt_cmd->cmd_list, &vha->qla_cmd_list);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+
+	/* Queue the work item */
+	INIT_WORK(&tgt_cmd->work, qla_nvmet_work);
+	queue_work(qla_nvmet_wq, &tgt_cmd->work);
+}
+
 /* ha->hardware_lock supposed to be held on entry */
 /* called via callback from qla2xxx */
 static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
@@ -5376,6 +6159,13 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 			break;
 		}
 
+		/* NVME Target*/
+		if (unlikely(atio->u.nvme_isp27.fcnvme_hdr.scsi_fc_id
+				== NVMEFC_CMD_IU_SCSI_FC_ID)) {
+			qla_nvmet_handle_cmd(vha, atio);
+			break;
+		}
+
 		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
 			rc = qlt_chk_qfull_thresh_hold(vha, ha->base_qpair,
 			    atio, ha_locked);
@@ -6167,6 +6957,14 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	if (ha->tgt.tgt_ops && ha->tgt.tgt_ops->add_target)
 		ha->tgt.tgt_ops->add_target(base_vha);
 
+	tgt->nvme_els_ptr = dma_alloc_coherent(&base_vha->hw->pdev->dev, 256,
+		&tgt->nvme_els_rsp, GFP_KERNEL);
+	if (!tgt->nvme_els_ptr) {
+		ql_dbg(ql_dbg_tgt, base_vha, 0xe066,
+		    "Unable to allocate DMA buffer for NVME ELS request\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -6446,10 +7244,11 @@ qlt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 }
 
 void
-qlt_rff_id(struct scsi_qla_host *vha, struct ct_sns_req *ct_req)
+qlt_rff_id(struct scsi_qla_host *vha, struct ct_sns_req *ct_req, u8 type)
 {
 	/*
 	 * FC-4 Feature bit 0 indicates target functionality to the name server.
+	 * NVME FC-4 Feature bit 2 indicates discovery controller
 	 */
 	if (qla_tgt_mode_enabled(vha)) {
 		ct_req->req.rff_id.fc4_feature = BIT_0;
@@ -6457,6 +7256,11 @@ qlt_rff_id(struct scsi_qla_host *vha, struct ct_sns_req *ct_req)
 		ct_req->req.rff_id.fc4_feature = BIT_1;
 	} else if (qla_dual_mode_enabled(vha))
 		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
+
+	/* force only target and disc controller for nvmet */
+	if ((vha->flags.nvmet_enabled) && (type == FC_TYPE_NVME))
+		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_2;
+
 }
 
 /*
@@ -6485,6 +7289,76 @@ qlt_init_atio_q_entries(struct scsi_qla_host *vha)
 
 }
 
+static void
+qlt_27xx_process_nvme_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct atio_from_isp *pkt;
+	int cnt;
+	uint32_t atio_q_in;
+	uint16_t num_atios = 0;
+	uint8_t nvme_pkts = 0;
+
+	if (!ha->flags.fw_started)
+		return;
+
+	pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
+	while (num_atios < pkt->u.raw.entry_count) {
+		atio_q_in =	RD_REG_DWORD(ISP_ATIO_Q_IN(vha));
+		if (atio_q_in < ha->tgt.atio_ring_index)
+			num_atios = ha->tgt.atio_q_length -
+				(ha->tgt.atio_ring_index - atio_q_in);
+		else
+			num_atios = atio_q_in - ha->tgt.atio_ring_index;
+		if (num_atios == 0)
+			return;
+	}
+
+	while ((num_atios) || fcpcmd_is_corrupted(ha->tgt.atio_ring_ptr)) {
+		pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
+		cnt = pkt->u.raw.entry_count;
+
+		if (unlikely(fcpcmd_is_corrupted(ha->tgt.atio_ring_ptr))) {
+			/*
+			 * This packet is corrupted. The header + payload
+			 * can not be trusted. There is no point in passing
+			 * it further up.
+			 */
+			ql_log(ql_log_warn, vha, 0xd03c,
+			    "corrupted fcp frame SID[%3phN] OXID[%04x] EXCG[%x] %64phN\n",
+			    pkt->u.isp24.fcp_hdr.s_id,
+			    be16_to_cpu(pkt->u.isp24.fcp_hdr.ox_id),
+			    le32_to_cpu(pkt->u.isp24.exchange_addr), pkt);
+
+			adjust_corrupted_atio(pkt);
+			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
+			    ha_locked, 0);
+		} else {
+			qlt_24xx_atio_pkt_all_vps(vha,
+			    (struct atio_from_isp *)pkt, ha_locked);
+			nvme_pkts++;
+		}
+
+		/* Just move by one index since we have already accounted the
+		 * additional ones while processing individual ATIOs
+		 */
+		ha->tgt.atio_ring_index++;
+		if (ha->tgt.atio_ring_index == ha->tgt.atio_q_length) {
+			ha->tgt.atio_ring_index = 0;
+			ha->tgt.atio_ring_ptr = ha->tgt.atio_ring;
+		} else
+			ha->tgt.atio_ring_ptr++;
+
+		pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
+		num_atios -= cnt;
+		/* memory barrier */
+		wmb();
+	}
+
+	/* Adjust ring index */
+	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
+}
+
 /*
  * qlt_24xx_process_atio_queue() - Process ATIO queue entries.
  * @ha: SCSI driver HA context
@@ -6496,9 +7370,15 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 	struct atio_from_isp *pkt;
 	int cnt, i;
 
+	if (unlikely(qlt_op_target_mode)) {
+		qlt_27xx_process_nvme_atio_queue(vha, ha_locked);
+		return;
+	}
+
 	if (!ha->flags.fw_started)
 		return;
 
+	pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
 	while ((ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) ||
 	    fcpcmd_is_corrupted(ha->tgt.atio_ring_ptr)) {
 		pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
@@ -6524,6 +7404,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 			    (struct atio_from_isp *)pkt, ha_locked);
 		}
 
+		cnt = 1;
 		for (i = 0; i < cnt; i++) {
 			ha->tgt.atio_ring_index++;
 			if (ha->tgt.atio_ring_index == ha->tgt.atio_q_length) {
@@ -6535,11 +7416,13 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 			pkt->u.raw.signature = ATIO_PROCESSED;
 			pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
 		}
+		/* memory barrier */
 		wmb();
 	}
 
 	/* Adjust ring index */
 	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
+	RD_REG_DWORD_RELAXED(ISP_ATIO_Q_OUT(vha));
 }
 
 void
@@ -6826,6 +7709,9 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 	INIT_DELAYED_WORK(&base_vha->unknown_atio_work,
 	    qlt_unknown_atio_work_fn);
 
+	/* NVMET */
+	INIT_LIST_HEAD(&base_vha->purex_atio_list);
+
 	qlt_clear_mode(base_vha);
 
 	rc = btree_init32(&ha->tgt.host_map);
@@ -7057,13 +7943,25 @@ int __init qlt_init(void)
 		goto out_mgmt_cmd_cachep;
 	}
 
+	qla_tgt_purex_plogi_cachep =
+		kmem_cache_create("qla_tgt_purex_plogi_cachep",
+			sizeof(struct qlt_purex_plogi_ack_t),
+			__alignof__(struct qlt_purex_plogi_ack_t), 0, NULL);
+
+	if (!qla_tgt_purex_plogi_cachep) {
+		ql_log(ql_log_fatal, NULL, 0xe06d,
+		    "kmem_cache_create for qla_tgt_purex_plogi_cachep failed\n");
+		ret = -ENOMEM;
+		goto out_plogi_cachep;
+	}
+
 	qla_tgt_mgmt_cmd_mempool = mempool_create(25, mempool_alloc_slab,
 	    mempool_free_slab, qla_tgt_mgmt_cmd_cachep);
 	if (!qla_tgt_mgmt_cmd_mempool) {
 		ql_log(ql_log_fatal, NULL, 0xe06e,
 		    "mempool_create for qla_tgt_mgmt_cmd_mempool failed\n");
 		ret = -ENOMEM;
-		goto out_plogi_cachep;
+		goto out_purex_plogi_cachep;
 	}
 
 	qla_tgt_wq = alloc_workqueue("qla_tgt_wq", 0, 0);
@@ -7073,6 +7971,14 @@ int __init qlt_init(void)
 		ret = -ENOMEM;
 		goto out_cmd_mempool;
 	}
+
+	qla_nvmet_wq = alloc_workqueue("qla_nvmet_wq", 0, 0);
+	if (!qla_nvmet_wq) {
+		ql_log(ql_log_fatal, NULL, 0xe070,
+		    "alloc_workqueue for qla_nvmet_wq failed\n");
+		ret = -ENOMEM;
+		goto out_cmd_mempool;
+	}
 	/*
 	 * Return 1 to signal that initiator-mode is being disabled
 	 */
@@ -7080,6 +7986,8 @@ int __init qlt_init(void)
 
 out_cmd_mempool:
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
+out_purex_plogi_cachep:
+	kmem_cache_destroy(qla_tgt_purex_plogi_cachep);
 out_plogi_cachep:
 	kmem_cache_destroy(qla_tgt_plogi_cachep);
 out_mgmt_cmd_cachep:
@@ -7092,8 +8000,18 @@ void qlt_exit(void)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
+	destroy_workqueue(qla_nvmet_wq);
 	destroy_workqueue(qla_tgt_wq);
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
 	kmem_cache_destroy(qla_tgt_plogi_cachep);
+	kmem_cache_destroy(qla_tgt_purex_plogi_cachep);
 	kmem_cache_destroy(qla_tgt_mgmt_cmd_cachep);
 }
+
+void nvmet_release_sessions(struct scsi_qla_host *vha)
+{
+	struct qlt_plogi_ack_t *pla;
+
+	list_for_each_entry(pla, &vha->plogi_ack_list, list)
+		list_del(&pla->list);
+}
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index aba58d3848a6..c0dfe2548848 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -322,6 +322,67 @@ struct atio7_fcp_cmnd {
 	/* uint32_t data_length; */
 } __packed;
 
+struct fc_nvme_hdr {
+	union {
+		struct {
+			uint8_t scsi_id;
+#define NVMEFC_CMD_IU_SCSI_ID   0xfd
+			uint8_t fc_id;
+#define NVMEFC_CMD_IU_FC_ID     0x28
+		};
+		struct {
+			uint16_t scsi_fc_id;
+#define NVMEFC_CMD_IU_SCSI_FC_ID  0x28fd
+		};
+	};
+	uint16_t iu_len;
+	uint8_t rsv1[3];
+	uint8_t flags;
+#define NVMEFC_CMD_WRITE        0x1
+#define NVMEFC_CMD_READ         0x2
+	uint64_t conn_id;
+	uint32_t        csn;
+	uint32_t        dl;
+} __packed;
+
+struct atio7_nvme_cmnd {
+	struct fc_nvme_hdr fcnvme_hdr;
+
+	struct nvme_command nvme_cmd;
+	uint32_t        rsv2[2];
+} __packed;
+
+#define ATIO_PURLS	0x56
+struct pt_ls4_rx_unsol {
+	uint8_t entry_type; /* 0x56 */
+	uint8_t entry_count;
+	uint16_t rsvd0;
+	uint16_t rsvd1;
+	uint8_t vp_index;
+	uint8_t rsvd2;
+	uint16_t rsvd3;
+	uint16_t nport_handle;
+	uint16_t frame_size;
+	uint16_t rsvd4;
+	uint32_t exchange_address;
+	uint8_t d_id[3];
+	uint8_t r_ctl;
+	uint8_t s_id[3];
+	uint8_t cs_ctl;
+	uint8_t f_ctl[3];
+	uint8_t type;
+	uint16_t seq_cnt;
+	uint8_t df_ctl;
+	uint8_t seq_id;
+	uint16_t rx_id;
+	uint16_t ox_id;
+	uint32_t param;
+	uint32_t desc0;
+#define PT_LS4_PAYLOAD_OFFSET 0x2c
+#define PT_LS4_FIRST_PACKET_LEN 20
+	uint32_t desc_len;
+	uint32_t payload[3];
+};
 /*
  * ISP queue -	Accept Target I/O (ATIO) type entry IOCB structure.
  *		This is sent from the ISP to the target driver.
@@ -368,6 +429,21 @@ struct atio_from_isp {
 			uint32_t signature;
 #define ATIO_PROCESSED 0xDEADDEAD		/* Signature */
 		} raw;
+		/* FC-NVME */
+		struct {
+			uint8_t  entry_type;	/* Entry type. */
+			uint8_t  entry_count;	/* Entry count. */
+			uint8_t  fcp_cmnd_len_low;
+			uint8_t  fcp_cmnd_len_high:4;
+			uint8_t  attr:4;
+			uint32_t exchange_addr;
+#define ATIO_NVME_ATIO_CMD_OFF 32
+#define ATIO_NVME_FIRST_PACKET_CMDLEN (64 - ATIO_NVME_ATIO_CMD_OFF)
+			struct fcp_hdr fcp_hdr;
+			struct fc_nvme_hdr fcnvme_hdr;
+			uint8_t	nvmd_cmd[8];
+		} nvme_isp27;
+		struct pt_ls4_rx_unsol pt_ls4;
 	} u;
 } __packed;
 
@@ -836,6 +912,8 @@ struct qla_tgt {
 	int modify_lun_expected;
 	atomic_t tgt_global_resets_count;
 	struct list_head tgt_list_entry;
+	dma_addr_t nvme_els_rsp;
+	void *nvme_els_ptr;
 };
 
 struct qla_tgt_sess_op {
@@ -848,6 +926,16 @@ struct qla_tgt_sess_op {
 	struct rsp_que *rsp;
 };
 
+/* NVMET */
+struct qla_tgt_purex_op {
+	struct scsi_qla_host *vha;
+	struct atio_from_isp atio;
+	uint8_t *purex_pyld;
+	uint16_t purex_pyld_len;
+	struct work_struct work;
+	struct list_head cmd_list;
+};
+
 enum trace_flags {
 	TRC_NEW_CMD = BIT_0,
 	TRC_DO_WORK = BIT_1,
@@ -1072,7 +1160,8 @@ extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-extern void qlt_rff_id(struct scsi_qla_host *, struct ct_sns_req *);
+extern void qlt_rff_id(struct scsi_qla_host *vha, struct ct_sns_req *ct_req,
+	u8 type);
 extern void qlt_init_atio_q_entries(struct scsi_qla_host *);
 extern void qlt_24xx_process_atio_queue(struct scsi_qla_host *, uint8_t);
 extern void qlt_24xx_config_rings(struct scsi_qla_host *);
@@ -1104,4 +1193,6 @@ void qlt_send_resp_ctio(struct qla_qpair *, struct qla_tgt_cmd *, uint8_t,
 extern void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *,
     struct qla_tgt_cmd *);
 
+/* 0 for FCP and 1 for NVMET */
+extern int qlt_op_target_mode;
 #endif /* __QLA_TARGET_H */
-- 
2.12.0
