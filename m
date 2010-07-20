From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] lpfc: Add TM v9.4 target hooks into LPFC v8.3.12
Date: Tue, 20 Jul 2010 16:09:57 -0700
Message-ID: <1279667397-12769-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch contains a forward port from SF_lpfcdriver_8_2_8_14_tm_9_4
into LPFC to add the necessary support for handling target mode operation.

This includes the necessary changes in initialization, ELS, and SLIport v3 HW
and TGTports v3. Note that the LPFC_TARGET_MODE stubs have been left in place
for rev1 of the patch for reference, and will be removed once the latest TM v9.5
with support for TM API v3 is merged.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc.h           |   18 +++
 drivers/scsi/lpfc/lpfc_attr.c      |   78 ++++++++++++-
 drivers/scsi/lpfc/lpfc_crtn.h      |   23 ++++
 drivers/scsi/lpfc/lpfc_ct.c        |   10 ++
 drivers/scsi/lpfc/lpfc_debugfs.c   |    4 +
 drivers/scsi/lpfc/lpfc_disc.h      |   21 ++++
 drivers/scsi/lpfc/lpfc_els.c       |  134 +++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   74 +++++++++++-
 drivers/scsi/lpfc/lpfc_hw.h        |  136 +++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_init.c      |   18 +++
 drivers/scsi/lpfc/lpfc_logmsg.h    |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c      |    9 ++
 drivers/scsi/lpfc/lpfc_mem.c       |    8 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c |  140 ++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c      |    4 +
 drivers/scsi/lpfc/lpfc_sli.c       |  223 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h       |   40 +++++++
 drivers/scsi/lpfc/lpfc_vport.c     |   17 +++
 18 files changed, 936 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e35a4c7..e0432ec 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -418,6 +418,10 @@ struct lpfc_vport {
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
+
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API_BASE
+	tm_tgtport_t target_tgtport;
+#endif
 };
 
 struct hbq_s {
@@ -816,6 +820,20 @@ struct lpfc_hba {
 
 	uint8_t menlo_flag;	/* menlo generic flags */
 #define HBA_MENLO_SUPPORT	0x1 /* HBA supports menlo commands */
+
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API_BASE
+	uint32_t cfg_initialize_link;
+	uint32_t cfg_tgt_brings_link_up;
+	uint32_t cfg_fcp_mode;
+#define LPFC_FCP_MODE_INITIATOR        1
+#define LPFC_FCP_MODE_TARGET           2
+	uint32_t poll_rsp_cnt;
+	uint32_t num_targets_bound;
+	uint32_t tm_terp_capabilities;
+
+	tm_sliport_t target_sliport;
+	tm_driver_data_t *tgt_data;
+#endif
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bf33b31..9fdf5f7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -37,6 +37,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -858,7 +862,7 @@ lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
  * zero on error
  * one for success
  **/
-static int
+int
 lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mxri, uint32_t *axri,
 		  uint32_t *mrpi, uint32_t *arpi,
@@ -3136,6 +3140,39 @@ LPFC_ATTR_R(multi_ring_rctl, FC_RCTL_DD_UNSOL_DATA, 1,
 LPFC_ATTR_R(multi_ring_type, FC_TYPE_IP, 1,
 	     255, "Identifies TYPE for additional ring configuration");
 
+#ifdef LPFC_TARGET_MODE
+/*
+# lpfc_initialize_link:  Bring link up at initialization
+#           0x0  = do NOT bring link up (MBX_INIT_LINK)
+#           0x1  = bring link up (issue MBX_INIT_LINK)
+# Default value is 1.
+*/
+LPFC_ATTR_R(initialize_link, 1, 0, 1, "Bring Link Up at initialization");
+
+/*
+# lpfc_tgt_brings_link_up: Target manually brings link up
+#           0x0  = automatically bring link up at target module load
+#           0x1  = defer MBX_INIT_LINK until requested by the target
+# Default value is 0.
+*/
+LPFC_ATTR_R(tgt_brings_link_up, 0, 0, 1, "Target manually initializes link");
+
+/*
+# lpfc_fcp_mode: determines target/initiator behavior. This is expressed
+# as an array. Every successive pair indicates {n, c}, where "n" is
+# hba number and "c" is characteristics. Value range of "c" is [1, 2].
+# where LPFC_FCP_MODE_INITIATOR        is 1 and LPFC_FCP_MODE_TARGET is 2.
+# Its possible to be both a target and an initiator.
+# The default value can be modified with the pair {-1, c}.
+*/
+static int lpfc_fcp_mode[64] = {-1, LPFC_FCP_MODE_TARGET};
+static int num_lpfc_fcp_mode;
+module_param_array(lpfc_fcp_mode, int, &num_lpfc_fcp_mode, 0);
+MODULE_PARM_DESC(lpfc_fcp_mode,
+    "List of values determining target/initiator behavior");
+#endif
+
+
 /*
 # lpfc_fdmi_on: controls FDMI support.
 #       0 = no FDMI support
@@ -3297,6 +3334,10 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_topology,
 	&dev_attr_lpfc_scan_down,
 	&dev_attr_lpfc_link_speed,
+#ifdef LPFC_TARGET_MODE
+	&dev_attr_lpfc_initialize_link,
+	&dev_attr_lpfc_tgt_brings_link_up,
+#endif
 	&dev_attr_lpfc_cr_delay,
 	&dev_attr_lpfc_cr_count,
 	&dev_attr_lpfc_multi_ring_support,
@@ -4492,6 +4533,28 @@ struct fc_function_template lpfc_vport_transport_functions = {
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
+#ifdef LPFC_TARGET_MODE
+	int i = 0, mode = LPFC_FCP_MODE_TARGET;
+
+	if (num_lpfc_fcp_mode & 1) {
+		printk(KERN_ERR "lpfc_fcp_mode expects pairs. Defaulting to "
+			"LPFC_FCP_MODE_TARGET.\n");
+	} else {
+		for (i = 0; i < num_lpfc_fcp_mode; i += 2) {
+			if (lpfc_fcp_mode[i] == -1) {
+				mode = lpfc_fcp_mode[i + 1];
+				break;
+			}
+			if (lpfc_fcp_mode[i] == phba->brd_no) {
+				mode = lpfc_fcp_mode[i + 1];
+				break;
+			}
+		}
+	}
+	phba->cfg_fcp_mode = mode;
+	lpfc_initialize_link_init(phba, lpfc_initialize_link);
+	lpfc_tgt_brings_link_up_init(phba, lpfc_tgt_brings_link_up);
+#endif
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
 	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
@@ -4521,6 +4584,15 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
+#ifdef LPFC_TARGET_MODE
+	/* Its possible to be BOTH Target and Initiator */
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET) {
+		phba->cfg_initialize_link = 0; /* MUST load tgt module first */
+		phba->cfg_multi_ring_support = 2;
+		phba->cfg_multi_ring_rctl = FC_FCP_CMND;
+		phba->cfg_multi_ring_type = FC_FCP_DATA;
+	}
+#endif
 	return;
 }
 
@@ -4545,5 +4617,9 @@ lpfc_get_vport_cfgparam(struct lpfc_vport *vport)
 	lpfc_max_luns_init(vport, lpfc_max_luns);
 	lpfc_scan_down_init(vport, lpfc_scan_down);
 	lpfc_enable_da_id_init(vport, lpfc_enable_da_id);
+#ifdef LPFC_TARGET_MODE
+	if (!(vport->phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR))
+		vport->cfg_use_adisc = 1;
+#endif
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index fbc9bae..10b3f20 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -101,6 +101,9 @@ void lpfc_cleanup(struct lpfc_vport *);
 void lpfc_disc_timeout(unsigned long);
 
 struct lpfc_nodelist *__lpfc_findnode_rpi(struct lpfc_vport *, uint16_t);
+#ifdef LPFC_TARGET_MODE
+struct lpfc_nodelist *lpfc_findnode_rpi(struct lpfc_vport *, uint16_t);
+#endif
 
 void lpfc_worker_wake_up(struct lpfc_hba *);
 int lpfc_workq_post_event(struct lpfc_hba *, void *, void *, uint32_t);
@@ -282,8 +285,15 @@ struct lpfc_dmabuf * lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *,
 
 int lpfc_sli_hbq_count(void);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
+#ifdef LPFC_TARGET_MODE
+int lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *, uint32_t, uint32_t);
+#endif
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
 int lpfc_sli_hbq_size(void);
+#ifdef LPFC_TARGET_MODE
+int lpfc_get_hba_info(struct lpfc_hba *phba, uint32_t *mxri, uint32_t *axri,
+	uint32_t *mrpi, uint32_t *arpi, uint32_t *mvpi, uint32_t *avpi);
+#endif
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
@@ -382,6 +392,19 @@ lpfc_send_els_failure_event(struct lpfc_hba *, struct lpfc_iocbq *,
 				struct lpfc_iocbq *);
 struct lpfc_fast_path_event *lpfc_alloc_fast_evt(struct lpfc_hba *);
 void lpfc_free_fast_evt(struct lpfc_hba *, struct lpfc_fast_path_event *);
+
+#ifdef LPFC_TARGET_MODE
+void lpfc_tm_get_hba_terp_cap(struct lpfc_hba *phba);
+
+extern struct lpfc_hbq_init *lpfc_hbq_defs[];
+
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp);
+void lpfc_tm_recv_unsol(struct lpfc_hba *phba,
+		struct lpfc_sli_ring *pring, struct lpfc_iocbq *iocb);
+struct hbq_dmabuf *lpfc_tm_hbq_alloc(struct lpfc_hba *phba);
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp);
+#endif
+
 void lpfc_create_static_vport(struct lpfc_hba *);
 void lpfc_stop_hba_timers(struct lpfc_hba *);
 void lpfc_stop_port(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 463b749..8763f63 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -38,6 +38,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -1252,7 +1256,13 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
 		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
+#ifdef LPFC_TARGET_MODE
+		CtReq->un.rff.fbits = 0;
+		if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR)
+			CtReq->un.rff.fbits = FC4_FEATURE_INIT;
+#else
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
+#endif
 		CtReq->un.rff.type_code = FC_TYPE_FCP;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a80d938..426b818 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -38,6 +38,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 36257a6..b1700d3 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -111,6 +111,23 @@ struct lpfc_nodelist {
 	uint32_t cmd_qdepth;
 	unsigned long last_change_time;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API
+	tm_login_info_t	tm_login_info;
+	tm_login_handle_t login_handle;
+	uint32_t tm_check_login_result;
+	uint8_t tm_check_login_called;
+	uint8_t login_handle_valid;
+	uint16_t tm_login_flags;
+#define NLP_TM_DELAYED_LOGIN	0x8000
+#define NLP_TM_FCP_CONF		0x0001
+#define NLP_TM_FCP_RETRY	0x0002
+#define NLP_TM_FCP_RETRY_ID	0x0004
+#define NLP_TM_CISC_MODE	0x0008
+#define NLP_TM_FCP_4_ERP \
+		(NLP_TM_FCP_CONF | NLP_TM_FCP_RETRY | NLP_TM_FCP_RETRY_ID)
+	uint16_t tm_node_capabilities;
+#endif
+
 };
 
 /* Defines for nlp_flag (uint32) */
@@ -135,6 +152,10 @@ struct lpfc_nodelist {
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
 #define NLP_SC_REQ         0x20000000	/* Target requires authentication */
 #define NLP_RPI_VALID      0x80000000	/* nlp_rpi is valid */
+#ifdef LPFC_TARGET_MODE
+#define NLP_NEED_PRLI 	   0x40000000	/* Need PRLI to determine capability */
+#define NLP_SKIP_REDISC	   0x80000000	/* Skip rediscovery via ADISC */
+#endif
 
 /* ndlp usage management macros */
 #define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c4c7f0a..ab10b9a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -33,6 +33,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -41,6 +45,9 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_protos.h"
+#endif
 
 static int lpfc_els_retry(struct lpfc_hba *, struct lpfc_iocbq *,
 			  struct lpfc_iocbq *);
@@ -1546,6 +1553,18 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	uint16_t cmdsize;
 	int ret;
 
+#ifdef LPFC_TARGET_MODE
+	if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) &&
+	    ((did & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+	    (vport->fc_flag & FC_PT2PT_PLOGI)) {
+		ndlp = lpfc_findnode_did(vport, did);
+		if (ndlp) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		}
+		return 1;
+	}
+#endif
 	psli = &phba->sli;
 
 	ndlp = lpfc_findnode_did(vport, did);
@@ -1713,6 +1732,39 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* For PRLI, remainder of payload is PRLI parameter page */
 	npr = (PRLI *) pcmd;
+#ifdef LPFC_TARGET_MODE
+	/* check if we want to act as target */
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET) {
+		if (lpfc_target_check_login(vport, ndlp) == TM_RCD_SUCCESS) {
+			/* success */
+			npr->targetFunc = 1;
+		}
+
+		/* Set PRLI ERP bits from target API defined capabilities */
+		if (ndlp->tm_node_capabilities & NLP_TM_FCP_CONF)
+			npr->ConfmComplAllowed = 1;
+		if (ndlp->tm_node_capabilities & NLP_TM_FCP_RETRY)
+			npr->Retry = 1;
+		if (ndlp->tm_node_capabilities & NLP_TM_FCP_RETRY_ID)
+			npr->TaskRetryIdReq = 1;
+	}
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) {
+		npr->initiatorFunc = 1;
+		/* Use target capabilities if target mode enabled */
+		if (!npr->targetFunc ||
+		    (!(ndlp->tm_node_capabilities & NLP_TM_FCP_4_ERP))) {
+			/*
+			 * If our firmware version is 3.20 or later,
+			 * set the following bits for FC-TAPE support.
+			 */
+			if (phba->vpd.rev.feaLevelHigh >= 0x02) {
+				npr->ConfmComplAllowed = 1;
+				npr->Retry = 1;
+				npr->TaskRetryIdReq = 1;
+			}
+		}
+	}
+#else
 	/*
 	 * If our firmware version is 3.20 or later,
 	 * set the following bits for FC-TAPE support.
@@ -1722,12 +1774,13 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		npr->Retry = 1;
 		npr->TaskRetryIdReq = 1;
 	}
+	npr->initiatorFunc = 1;
+#endif
 	npr->estabImagePair = 1;
 	npr->readXferRdyDis = 1;
 
 	/* For FCP support */
 	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PRLI:      did:x%x",
@@ -3660,6 +3713,10 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+#ifdef LPFC_TARGET_MODE
+	uint16_t erp_cap = 0;
+	uint8_t rem_initiatorFunc;
+#endif
 
 	psli = &phba->sli;
 
@@ -3672,6 +3729,22 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	icmd = &elsiocb->iocb;
 	oldcmd = &oldiocb->iocb;
 	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
+#ifdef LPFC_TARGET_MODE
+	/* Check if the remote port support initiatorFunc */
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) oldiocb->context2)->virt);
+	pcmd += sizeof(uint32_t);
+	npr = (PRLI *) pcmd;
+	rem_initiatorFunc = npr->initiatorFunc;
+
+	/* Prepare to merge the initiator and our target capabilities */
+	ndlp->tm_login_flags &= ~NLP_TM_FCP_4_ERP;
+	if (npr->ConfmComplAllowed)
+		erp_cap |= NLP_TM_FCP_CONF;
+	if (npr->Retry)
+		erp_cap |= NLP_TM_FCP_RETRY;
+	if (npr->TaskRetryIdReq)
+		erp_cap |= NLP_TM_FCP_RETRY_ID;
+#endif
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0131 Xmit PRLI ACC response tag x%x xri x%x, "
@@ -3689,6 +3762,42 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 
 	npr = (PRLI *) pcmd;
 	vpd = &phba->vpd;
+#ifdef LPFC_TARGET_MODE
+	/* Check if we want to act as target */
+	if (rem_initiatorFunc && (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)) {
+		/* Target should set tERP capabilities in this call */
+		if (lpfc_target_check_login(vport, ndlp) == TM_RCD_SUCCESS) {
+			/* success */
+			npr->targetFunc = 1;
+			/* Merge capabilities with incoming PRLI */
+			ndlp->tm_login_flags |= NLP_TM_FCP_4_ERP &
+					erp_cap & ndlp->tm_node_capabilities;
+		}
+
+		/* Set PRLI ERP bits from merged capabilities */
+		if (ndlp->tm_login_flags & NLP_TM_FCP_CONF)
+			npr->ConfmComplAllowed = 1;
+		if (ndlp->tm_login_flags & NLP_TM_FCP_RETRY)
+			npr->Retry = 1;
+		if (ndlp->tm_login_flags & NLP_TM_FCP_RETRY_ID)
+			npr->TaskRetryIdReq = 1;
+	}
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) {
+		npr->initiatorFunc = 1;
+		/* Use target capabilities if target mode enabled */
+		if (!npr->targetFunc) {
+			/*
+			 * If our firmware version is 3.20 or later,
+			 * set the following bits for FC-TAPE support.
+			 */
+			if (vpd->rev.feaLevelHigh >= 0x02) {
+				npr->ConfmComplAllowed = 1;
+				npr->Retry = 1;
+				npr->TaskRetryIdReq = 1;
+			}
+		}
+	}
+#else
 	/*
 	 * If the remote port is a target and our firmware version is 3.20 or
 	 * later, set the following bits for FC-TAPE support.
@@ -3699,6 +3808,8 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		npr->Retry = 1;
 		npr->TaskRetryIdReq = 1;
 	}
+	npr->initiatorFunc = 1;
+#endif
 
 	npr->acceptRspCode = PRLI_REQ_EXECUTED;
 	npr->estabImagePair = 1;
@@ -3706,7 +3817,6 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	npr->ConfmComplAllowed = 1;
 
 	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue ACC PRLI:  did:x%x flg:x%x",
@@ -3714,7 +3824,25 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-
+#ifdef LPFC_TARGET_MODE
+	/* at this point initialize the target */
+	if ((npr->acceptRspCode == PRLI_REQ_EXECUTED) &&
+	    (npr->prliType == PRLI_FCP_TYPE) &&
+	     ndlp->tm_check_login_called &&
+	    (ndlp->tm_check_login_result == TM_RCD_SUCCESS) &&
+	    !ndlp->login_handle_valid &&
+	     rem_initiatorFunc) {
+
+		if (ndlp->nlp_rpi) {
+			if (ndlp->tm_login_flags & NLP_TM_FCP_4_ERP)
+				lpfc_tm_terp_reg_login(vport, ndlp);
+			ndlp->login_handle = lpfc_tm_tgtport_login(vport, ndlp);
+			if (ndlp->login_handle)
+				ndlp->login_handle_valid = 1;
+		} else
+			ndlp->tm_login_flags |= NLP_TM_DELAYED_LOGIN;
+        }
+#endif
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 1f87b4f..8949df2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -32,16 +32,23 @@
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
-#include "lpfc_nl.h"
-#include "lpfc_disc.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_protos.h"
+#endif
 
 /* AlpaArray for assignment of scsid for scan-down and bind_method */
 static uint8_t lpfcAlpaArray[] = {
@@ -2728,6 +2735,18 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 */
 	lpfc_nlp_put(ndlp);
 
+#ifdef LPFC_TARGET_MODE
+	/* check if we need to notify the target api
+	 * set when prli has completed before reg_login mailbox cmd */
+	if (ndlp->tm_login_flags & NLP_TM_DELAYED_LOGIN) {
+		ndlp->tm_login_flags &= ~NLP_TM_DELAYED_LOGIN;
+		if (ndlp->tm_login_flags & NLP_TM_FCP_4_ERP)
+			lpfc_tm_terp_reg_login(vport, ndlp);
+		ndlp->login_handle = lpfc_tm_tgtport_login(vport, ndlp);
+		if (ndlp->login_handle != NULL)
+			ndlp->login_handle_valid = 1;
+	}
+#endif
 	return;
 }
 
@@ -2821,9 +2840,16 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	spin_unlock_irq(shost->host_lock);
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
+#ifdef LPFC_TARGET_MODE
+	if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+	    (vport->fc_flag & FC_PT2PT_PLOGI)) {
+		if (vport->fc_npr_cnt)
+			lpfc_els_disc_plogi(vport);
+	}
+#else
 	if (vport->fc_npr_cnt)
 		lpfc_els_disc_plogi(vport);
-
+#endif
 	if (!vport->num_disc_nodes) {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_NDISC_ACTIVE;
@@ -3689,6 +3715,13 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	LPFC_MBOXQ_t    *mbox;
 	int rc;
 
+#ifdef LPFC_TARGET_MODE
+	/* if there is a valid target login, need to logout now. */
+	lpfc_tm_tgtport_logout(vport, ndlp->login_handle);
+	ndlp->login_handle = 0;
+	ndlp->login_handle_valid = 0;
+	ndlp->tm_check_login_called = 0;
+#endif
 	if (ndlp->nlp_flag & NLP_RPI_VALID) {
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
@@ -4013,6 +4046,10 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
+#ifdef LPFC_TARGET_MODE
+		if (!(vport->phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR))
+			return NULL;
+#endif
 		if ((vport->fc_flag & FC_RSCN_MODE) != 0 &&
 		    lpfc_rscn_payload_check(vport, did) == 0)
 			return NULL;
@@ -4235,9 +4272,16 @@ lpfc_disc_start(struct lpfc_vport *vport)
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
 			/* go thru NPR nodes and issue ELS PLOGIs */
+#ifdef LPFC_TARGET_MODE
+			if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+			    (vport->fc_flag & FC_PT2PT_PLOGI)) {
+				if (vport->fc_npr_cnt)
+					lpfc_els_disc_plogi(vport);
+			}
+#else
 			if (vport->fc_npr_cnt)
 				lpfc_els_disc_plogi(vport);
-
+#endif
 			if (!vport->num_disc_nodes) {
 				spin_lock_irq(shost->host_lock);
 				vport->fc_flag &= ~FC_NDISC_ACTIVE;
@@ -4248,8 +4292,14 @@ lpfc_disc_start(struct lpfc_vport *vport)
 		vport->port_state = LPFC_VPORT_READY;
 	} else {
 		/* Next do PLOGIs - if any */
+#ifdef LPFC_TARGET_MODE
+		if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+		    (vport->fc_flag & FC_PT2PT_PLOGI)) {
+			num_sent = lpfc_els_disc_plogi(vport);
+		}
+#else
 		num_sent = lpfc_els_disc_plogi(vport);
-
+#endif
 		if (num_sent)
 			return;
 
@@ -4687,6 +4737,20 @@ __lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 	return __lpfc_find_node(vport, lpfc_filter_by_rpi, &rpi);
 }
 
+#ifdef LPFC_TARGET_MODE
+struct lpfc_nodelist *
+lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_nodelist *ndlp;
+
+	spin_lock_irq(shost->host_lock);
+	ndlp = __lpfc_findnode_rpi(vport, rpi);
+	spin_unlock_irq(shost->host_lock);
+	return ndlp;
+}
+#endif
+
 /*
  * This routine looks up the ndlp lists for the given WWPN. If WWPN found it
  * returns the node element list pointer else return NULL.
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index e654d01..391acc3 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1124,6 +1124,21 @@ typedef struct {
 /* Number of 4-byte words in an IOCB. */
 #define IOCB_WORD_SZ    8
 
+/* defines for type field in fc header */
+#define FC_ELS_DATA	0x1
+#define FC_LLC_SNAP	0x5
+#define FC_FCP_DATA	0x8
+#define FC_COMMON_TRANSPORT_ULP 0x20
+
+/* defines for rctl field in fc header */
+#define FC_DEV_DATA	0x0
+#define FC_UNSOL_CTL	0x2
+#define FC_SOL_CTL	0x3
+#define FC_UNSOL_DATA	0x4
+#define FC_FCP_CMND	0x6
+#define FC_ELS_REQ	0x22
+#define FC_ELS_RSP	0x23
+
 /* network headers for Dfctl field */
 #define FC_NET_HDR      0x20
 
@@ -1354,6 +1369,8 @@ typedef struct {		/* FireFly BIU registers */
 #define MBX_PORT_IOV_CONTROL 0x3C
 
 #define MBX_CONFIG_HBQ	    0x7C
+#define MBX_PAUSE_HBQ       0x7D
+#define MBX_RESUME_HBQ      0x7E
 #define MBX_LOAD_AREA       0x81
 #define MBX_RUN_BIU_DIAG64  0x84
 #define MBX_CONFIG_PORT     0x88
@@ -1433,6 +1450,8 @@ typedef struct {		/* FireFly BIU registers */
 #define CMD_ELS_REQUEST64_CX    0x8B
 #define CMD_ABORT_MXRI64_CN     0x8C
 #define CMD_RCV_ELS_REQ64_CX    0x8D
+#define CMD_RCV_SRR_REQ64_CX	0x8E
+#define CMD_XMIT_SRR_RSP64_CX	0x8F
 #define CMD_XMIT_ELS_RSP64_CX   0x95
 #define CMD_XMIT_BLS_RSP64_CX   0x97
 #define CMD_FCP_IWRITE64_CR     0x98
@@ -1772,6 +1791,9 @@ typedef struct {
 #define	FLAGS_UNREG_LOGIN_ALL	     0x08 /* UNREG_LOGIN all on link down */
 #define FLAGS_LIRP_LILP              0x80 /* LIRP / LILP is disabled */
 
+#define FLAGS_DISABLE_TGT_ABTS	     0x20	/* Bit 5 */
+#define FLAGS_DISABLE_GLBL_ABTS	     0x02000	/* Bit 13 */
+
 #define FLAGS_TOPOLOGY_FAILOVER      0x0400	/* Bit 10 */
 #define FLAGS_LINK_SPEED             0x0800	/* Bit 11 */
 #define FLAGS_IMED_ABORT             0x04000	/* Bit 14 */
@@ -2222,13 +2244,21 @@ typedef struct {
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint16_t rsvd1;
 	uint16_t rpi;
-	uint32_t rsvd2:8;
+	uint32_t cisc:1;
+	uint32_t fcpConf:1;
+	uint32_t tERP:1;
+	uint32_t rsvd2:4;
+	uint32_t tUPD:1;
 	uint32_t did:24;
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
 	uint16_t rpi;
 	uint16_t rsvd1;
 	uint32_t did:24;
-	uint32_t rsvd2:8;
+	uint32_t tUPD:1;
+	uint32_t rsvd2:4;
+	uint32_t tERP:1;
+	uint32_t fcpConf:1;
+	uint32_t cisc:1;
 #endif
 
 	union {
@@ -2698,6 +2728,41 @@ struct config_hbq_var {
 
 };
 
+/* Structure for MB Command PAUSE_HBQ (7d) */
+
+struct pause_hbq_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t hbqId:16;
+	uint32_t rsvd1:16;
+#else   /*  __LITTLE_ENDIAN */
+	uint32_t rsvd1:16;
+	uint32_t hbqId:16;
+#endif
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd2:16;
+	uint32_t mbTag16:16;
+#else   /*  __LITTLE_ENDIAN */
+	uint32_t mbTag16:16;
+	uint32_t rsvd2:16;
+#endif
+
+};
+
+
+
+/* Structure for MB Command RESUME_HBQ (7e) */
+
+struct resume_hbq_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t hbqId:16;
+	uint32_t hbqGetPtr:16;
+#else   /*  __LITTLE_ENDIAN */
+	uint32_t hbqGetPtr:16;
+	uint32_t hbqId:16;
+#endif
+
+};
 
 
 /* Structure for MB Command CONFIG_PORT (0x88) */
@@ -2930,6 +2995,64 @@ typedef struct {
 #endif
 } ASYNCEVT_ENABLE_VAR;
 
+/* Structures for MB Command MBX_PORT_CAPABILITIES (0x3B) */
+
+struct query_supported_pages {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint8_t rsvd;
+	uint8_t elementCount;
+	uint8_t nextOffset;
+	uint8_t listOffset;
+#else /*  __LITTLE_ENDIAN */
+	uint8_t listOffset;
+	uint8_t nextOffset;
+	uint8_t elementCount;
+	uint8_t rsvd;
+#endif
+	uint8_t pn[29 * 4];
+};
+
+struct query_terp_support {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd:29;
+	uint32_t TaskRetryIdReq:1;
+	uint32_t Retry:1;
+	uint32_t ConfmComplAllowed:1;
+#else /*  __LITTLE_ENDIAN */
+	uint32_t ConfmComplAllowed:1;
+	uint32_t Retry:1;
+	uint32_t TaskRetryIdReq:1;
+	uint32_t rsvd:29;
+#endif
+};
+
+struct port_capabilities_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint8_t rsvd0;
+	uint8_t cpn;
+	uint8_t pf;
+	uint8_t rsvd1:6;
+	uint8_t wr:1;
+	uint8_t qs:1;
+#else /*  __LITTLE_ENDIAN */
+	uint8_t qs:1;
+	uint8_t wr:1;
+	uint8_t rsvd1:6;
+	uint8_t pf;
+	uint8_t cpn;
+	uint8_t rsvd0;
+#endif
+	union {
+		struct query_supported_pages qsp;
+		struct query_terp_support qts;
+	} un;
+};
+
+#define PORT_CAPABILITY_SUPPORTED_PAGES 0x00
+#define PORT_CAPABILITY_DII_CPN		0x01
+#define PORT_CAPABILITY_SLI4_CPN	0x02
+#define PORT_CAPABILITY_TERP_CPN	0x03
+
 /* Union of all Mailbox Command types */
 #define MAILBOX_CMD_WSIZE	32
 #define MAILBOX_CMD_SIZE	(MAILBOX_CMD_WSIZE * sizeof(uint32_t))
@@ -2972,15 +3095,22 @@ typedef union {
 					 * NEW_FEATURE
 					 */
 	struct config_hbq_var varCfgHbq;/* cmd = 0x7c (CONFIG_HBQ)  */
+#ifdef LPFC_TARGET_MODE
+	struct pause_hbq_var varPauseHbq; /* cmd = 0x7d (PAUSE_HBQ)  */
+	struct resume_hbq_var varResumeHbq; /* cmd = 0x7e (RESUME_HBQ)  */
+#endif
 	struct update_cfg_var varUpdateCfg; /* cmd = 0x1B (UPDATE_CFG)*/
 	CONFIG_PORT_VAR varCfgPort;	/* cmd = 0x88 (CONFIG_PORT)  */
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
 	ASYNCEVT_ENABLE_VAR varCfgAsyncEvent; /*cmd = x33 (CONFIG_ASYNC) */
+	struct config_msi_var varCfgMSI;/* cmd = x30 (CONFIG_MSI)     */
 	struct READ_EVENT_LOG_VAR varRdEventLog;	/* cmd = 0x38
 							 * (READ_EVENT_LOG)
 							 */
-	struct config_msi_var varCfgMSI;/* cmd = x30 (CONFIG_MSI)     */
+#ifdef LPFC_TARGET_MODE
+	struct port_capabilities_var varPortCapabilities; /* cmd = 0x3B  */
+#endif
 } MAILVARIANTS;
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cd9697e..95ad5d0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -40,6 +40,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -615,6 +619,12 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
 
+#ifdef LPFC_TARGET_MODE
+	lpfc_tm_get_hba_terp_cap(phba);
+
+	if (!phba->cfg_initialize_link)
+		return 0;
+#endif
 	return 0;
 }
 
@@ -5021,6 +5031,14 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0428 Perform SCSI scan\n");
+
+#ifdef LPFC_TARGET_MODE
+	if (!phba->cfg_initialize_link) {
+		/* After initialization, this should always be set */
+		phba->cfg_initialize_link = 1;
+		return;
+	}
+#endif
 	/* Send board arrival event to upper layer */
 	adapter_event.event_type = FC_REG_ADAPTER_EVENT;
 	adapter_event.subcategory = LPFC_EVENT_ARRIVAL;
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index bb59e92..bf9a546 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -36,6 +36,7 @@
 #define LOF_SECURITY	0x00008000	/* Security events */
 #define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
 #define LOG_FIP		0x00020000	/* FIP events */
+#define LOG_TARGET	0x00040000	/* Target API events */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index e84dc33..004c1e3 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -33,6 +33,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -535,6 +539,11 @@ lpfc_init_link(struct lpfc_hba * phba,
 	else
 		mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
 
+#ifdef LPFC_TARGET_MODE
+	/* This flag must be set for FCP-4 tERP to work */
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		mb->un.varInitLnk.link_flags |= FLAGS_DISABLE_TGT_ABTS;
+#endif
 	mb->mbxCommand = (volatile uint8_t)MBX_INIT_LINK;
 	mb->mbxOwner = OWN_HOST;
 	mb->un.varInitLnk.fabric_AL_PA = phba->fc_pref_ALPA;
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 8f879e4..5b0f14b 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -33,6 +33,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -522,6 +526,10 @@ lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 		if (hbq_entry->tag == -1) {
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
 				(phba, hbq_entry);
+#ifdef LPFC_TARGET_MODE
+		} else if (hbq_entry->tag & QUE_BUFTAG_BIT) {
+			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)(phba, hbq_entry);
+#endif
 		} else {
 			lpfc_sli_free_hbq(phba, hbq_entry);
 		}
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index b90820a..6584a1e 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -33,6 +33,11 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#include "lpfc_target_protos.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -1173,6 +1178,9 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
+#ifdef LPFC_TARGET_MODE
+	struct ls_rjt	stat;
+#endif
 	IOCB_t *irsp;
 	ADISC *ap;
 	int rc;
@@ -1183,6 +1191,70 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 	ap = (ADISC *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
 	irsp = &rspiocb->iocb;
 
+#ifdef LPFC_TARGET_MODE
+	if (irsp->ulpStatus) {
+		stat.un.lsRjtError = be32_to_cpu(irsp->un.ulpWord[4]);
+
+		/* did is alive but can't be authenticated */
+		if (stat.un.b.lsRjtRsnCode == LSRJT_UNABLE_TPC ||
+		    stat.un.b.lsRjtRsnCode == LSRJT_CMD_UNSUPPORTED) {
+
+			lpfc_issue_els_logo(vport, ndlp, 0);
+			/* Put ndlp in npr state set plogi timer for 1 sec */
+			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_DELAY_TMO;
+			spin_unlock_irq(shost->host_lock);
+			ndlp->nlp_last_elscmd = ELS_CMD_ADISC;
+			ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+			return ndlp->nlp_state;
+		}
+
+		/* 1 sec timeout */
+		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag |= NLP_DELAY_TMO;
+		spin_unlock_irq(shost->host_lock);
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+
+		memset(&ndlp->nlp_nodename, 0, sizeof(struct lpfc_name));
+		memset(&ndlp->nlp_portname, 0, sizeof(struct lpfc_name));
+
+		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		lpfc_unreg_rpi(vport, ndlp);
+		return ndlp->nlp_state;
+
+	} else if (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName)) {
+		/* 1 sec timeout */
+		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag |= NLP_DELAY_TMO;
+		spin_unlock_irq(shost->host_lock);
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+
+		memset(&ndlp->nlp_nodename, 0, sizeof(struct lpfc_name));
+		memset(&ndlp->nlp_portname, 0, sizeof(struct lpfc_name));
+
+		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		lpfc_unreg_rpi(vport, ndlp);
+		return ndlp->nlp_state;
+	}
+	if (ndlp->nlp_flag & NLP_NEED_PRLI) {
+		/* Only if we are not a fabric nport do we issue PRLI */
+		if (!(ndlp->nlp_type & NLP_FABRIC)) {
+			ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
+			lpfc_issue_els_prli(vport, ndlp, 0);
+		} else {
+			ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		}
+		return ndlp->nlp_state;
+	}
+#else
 	if ((irsp->ulpStatus) ||
 	    (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName))) {
 		/* 1 sec timeout */
@@ -1200,7 +1272,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 		lpfc_unreg_rpi(vport, ndlp);
 		return ndlp->nlp_state;
 	}
-
+#endif
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		rc = lpfc_sli4_resume_rpi(ndlp);
 		if (rc) {
@@ -1412,9 +1484,22 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
+#ifdef LPFC_TARGET_MODE
+		struct lpfc_hba   *phba = vport->phba;
+
+		if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) {
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
+			lpfc_issue_els_prli(vport, ndlp, 0);
+		} else {
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		}
+#else
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
+#endif
 	} else {
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
@@ -1536,6 +1621,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
+#ifdef LPFC_TARGET_MODE
+	ndlp->nlp_flag &= ~NLP_NEED_PRLI;
+#endif
 	npr = (PRLI *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
 
 	irsp = &rspiocb->iocb;
@@ -1580,6 +1668,44 @@ out:
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
 	else
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+
+#ifdef LPFC_TARGET_MODE
+	/* Check if we are a target with a remote initiator */
+	if (npr->initiatorFunc && (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)) {
+		/* Target should set tERP capabilities in this call */
+		if (lpfc_target_check_login(vport, ndlp) == TM_RCD_SUCCESS) {
+			/* Success, Merge capabilities with tERP capabilities */
+			uint16_t erp_cap = 0;
+
+			ndlp->tm_login_flags &= ~NLP_TM_FCP_4_ERP;
+			if (npr->ConfmComplAllowed)
+				erp_cap |= NLP_TM_FCP_CONF;
+			if (npr->Retry)
+				erp_cap |= NLP_TM_FCP_RETRY;
+			if (npr->TaskRetryIdReq)
+				erp_cap |= NLP_TM_FCP_RETRY_ID;
+			ndlp->tm_login_flags |= NLP_TM_FCP_4_ERP &
+					erp_cap & ndlp->tm_node_capabilities;
+		}
+		/* at this point initialize the target */
+		if (npr->acceptRspCode == PRLI_REQ_EXECUTED &&
+		    npr->prliType == PRLI_FCP_TYPE &&
+		    ndlp->tm_check_login_called &&
+		    ndlp->tm_check_login_result == TM_RCD_SUCCESS &&
+		    !ndlp->login_handle_valid && npr->initiatorFunc) {
+
+			if (ndlp->nlp_rpi) {
+				if (ndlp->tm_login_flags & NLP_TM_FCP_4_ERP)
+					lpfc_tm_terp_reg_login(vport, ndlp);
+
+				ndlp->login_handle = lpfc_tm_tgtport_login(vport, ndlp);
+				if (ndlp->login_handle)
+					ndlp->login_handle_valid = 1;
+			} else
+				ndlp->tm_login_flags |= NLP_TM_DELAYED_LOGIN;
+		}
+	}
+#endif
 	return ndlp->nlp_state;
 }
 
@@ -1661,6 +1787,9 @@ lpfc_device_recov_prli_issue(struct lpfc_vport *vport,
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
+#ifdef LPFC_TARGET_MODE
+	ndlp->nlp_flag |= NLP_NEED_PRLI;
+#endif
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -1841,7 +1970,16 @@ lpfc_rcv_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 	struct ls_rjt     stat;
+#ifdef LPFC_TARGET_MODE
+	struct lpfc_hba   *phba = vport->phba;
 
+	if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR)) {
+		lpfc_rcv_prli(vport, ndlp, cmdiocb);
+		ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		return ndlp->nlp_state;
+	}
+#endif
 	memset(&stat, 0, sizeof (struct ls_rjt));
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f4a3b2e..aff5172 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -36,6 +36,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7a61455..37aadf9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -37,6 +37,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -762,6 +766,9 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case CMD_GEN_REQUEST64_CR:
 	case CMD_GEN_REQUEST64_CX:
 	case CMD_XMIT_ELS_RSP64_CX:
+#ifdef LPFC_TARGET_MODE
+	case CMD_XMIT_SRR_RSP64_CX:
+#endif
 	case DSSCMD_IWRITE64_CR:
 	case DSSCMD_IWRITE64_CX:
 	case DSSCMD_IREAD64_CR:
@@ -786,6 +793,10 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case CMD_IOCB_RCV_ELS64_CX:
 	case CMD_IOCB_RCV_CONT64_CX:
 	case CMD_IOCB_RET_XRI64_CX:
+#ifdef LPFC_TARGET_MODE
+	case CMD_IOCB_RET_HBQE64_CN:
+	case CMD_RCV_SRR_REQ64_CX:
+#endif
 		type = LPFC_UNSOL_IOCB;
 		break;
 	case CMD_IOCB_XMIT_MSEQ64_CR:
@@ -794,7 +805,6 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case CMD_IOCB_RCV_ELS_LIST64_CX:
 	case CMD_IOCB_CLOSE_EXTENDED_CN:
 	case CMD_IOCB_ABORT_EXTENDED_CN:
-	case CMD_IOCB_RET_HBQE64_CN:
 	case CMD_IOCB_FCP_IBIDIR64_CR:
 	case CMD_IOCB_FCP_IBIDIR64_CX:
 	case CMD_IOCB_FCP_ITASKMGT64_CX:
@@ -1273,8 +1283,13 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
 				(phba, hbq_buf);
 		} else {
+#ifdef LPFC_TARGET_MODE
+			hbqno = lpfc_hbqno_get(hbq_buf->tag);
+			if (hbq_buf->tag & QUE_BUFTAG_BIT)
+#else
 			hbqno = hbq_buf->tag >> 16;
 			if (hbqno >= LPFC_MAX_HBQS)
+#endif
 				(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
 					(phba, hbq_buf);
 			else
@@ -1418,13 +1433,16 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = {
  * given HBQ. The function returns the number of HBQ buffers successfully
  * posted.
  **/
-static int
+int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
 	uint32_t i, posted = 0;
 	unsigned long flags;
 	struct hbq_dmabuf *hbq_buffer;
 	LIST_HEAD(hbq_buf_list);
+
+	dump_stack();
+
 	if (!phba->hbqs[hbqno].hbq_alloc_buffer)
 		return 0;
 
@@ -1448,8 +1466,16 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 	while (!list_empty(&hbq_buf_list)) {
 		list_remove_head(&hbq_buf_list, hbq_buffer, struct hbq_dmabuf,
 				 dbuf.list);
+#ifdef LPFC_TARGET_MODE
+		i = phba->hbqs[hbqno].buffer_count;
+		printk("Using hbqno: %d buffer_count: %d orig hbq_buffer *: %p tag: 0x%08x\n",
+				hbqno, i, hbq_buffer, hbq_buffer->tag);
+		hbq_buffer->tag = lpfc_build_hbq_tag(hbqno, i, hbq_buffer->tag);
+		printk("Generated new hbq_buffer->tag: 0x%08x\n", hbq_buffer->tag);
+#else
 		hbq_buffer->tag = (phba->hbqs[hbqno].buffer_count |
 				      (hbqno << 16));
+#endif
 		if (!lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
 			phba->hbqs[hbqno].buffer_count++;
 			posted++;
@@ -1537,31 +1563,44 @@ lpfc_sli_hbqbuf_get(struct list_head *rb_list)
  * it returns NULL.
  **/
 static struct hbq_dmabuf *
-lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
+__lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 {
 	struct lpfc_dmabuf *d_buf;
 	struct hbq_dmabuf *hbq_buf;
 	uint32_t hbqno;
-
+#ifdef LPFC_TARGET_MODE
+	hbqno = lpfc_hbqno_get(tag);
+	if (tag & QUE_BUFTAG_BIT)
+		return NULL;
+#else
 	hbqno = tag >> 16;
 	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
-
-	spin_lock_irq(&phba->hbalock);
+#endif
 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
 		hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 		if (hbq_buf->tag == tag) {
-			spin_unlock_irq(&phba->hbalock);
 			return hbq_buf;
 		}
 	}
-	spin_unlock_irq(&phba->hbalock);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_VPORT,
 			"1803 Bad hbq tag. Data: x%x x%x\n",
-			tag, phba->hbqs[tag >> 16].buffer_count);
+			tag, phba->hbqs[hbqno].buffer_count);
 	return NULL;
 }
 
+static struct hbq_dmabuf *
+lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
+{
+	struct hbq_dmabuf *hbq_buf;
+
+	spin_lock_irq(&phba->hbalock);
+	hbq_buf = __lpfc_sli_hbqbuf_find(phba, tag);
+	spin_unlock_irq(&phba->hbalock);
+
+	return hbq_buf;
+}
+
 /**
  * lpfc_sli_free_hbq - Give back the hbq buffer to firmware
  * @phba: Pointer to HBA context object.
@@ -1577,7 +1616,11 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba, struct hbq_dmabuf *hbq_buffer)
 	uint32_t hbqno;
 
 	if (hbq_buffer) {
+#ifdef LPFC_TARGET_MODE
+		hbqno = lpfc_hbqno_get(hbq_buffer->tag);
+#else
 		hbqno = hbq_buffer->tag >> 16;
+#endif
 		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
 			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
 	}
@@ -1885,6 +1928,55 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 	return 0;
 }
 
+static struct lpfc_dmabuf *
+lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
+{
+	struct hbq_dmabuf *hbq_entry, *new_hbq_entry;
+	uint32_t hbqno, hbqidx, new_tag;
+	void *virt;		/* virtual address ptr */
+	dma_addr_t phys;	/* mapped address */
+	unsigned long flags;
+
+	/* Check whether HBQ is still in use */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (!phba->hbq_in_use) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return NULL;
+	}
+
+	hbq_entry = __lpfc_sli_hbqbuf_find(phba, tag);
+	if (hbq_entry == NULL) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return NULL;
+	}
+	list_del(&hbq_entry->dbuf.list);
+
+	hbqno = lpfc_hbqno_get(tag);
+
+	hbqidx = lpfc_hbq_idx_get(tag);
+	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
+	if (new_hbq_entry == NULL) {
+		list_add_tail(&hbq_entry->dbuf.list, &phba->rb_pend_list);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return &hbq_entry->dbuf;
+	}
+	new_tag = lpfc_build_hbq_tag(hbqno, hbqidx, new_hbq_entry->tag);
+
+	phys = new_hbq_entry->dbuf.phys;
+	virt = new_hbq_entry->dbuf.virt;
+	new_hbq_entry->dbuf.phys = hbq_entry->dbuf.phys;
+	new_hbq_entry->dbuf.virt = hbq_entry->dbuf.virt;
+	new_hbq_entry->tag = tag;
+	hbq_entry->dbuf.phys = phys;
+	hbq_entry->dbuf.virt = virt;
+	hbq_entry->tag = new_tag;
+	lpfc_sli_free_hbq(phba, hbq_entry);
+	list_add_tail(&new_hbq_entry->dbuf.list, &phba->rb_pend_list);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	return &new_hbq_entry->dbuf;
+}
+
 /**
  * lpfc_sli_get_buff - Get the buffer associated with the buffer tag
  * @phba: Pointer to HBA context object.
@@ -1906,10 +1998,14 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 
 	if (tag & QUE_BUFTAG_BIT)
 		return lpfc_sli_ring_taggedbuf_get(phba, pring, tag);
+#ifdef LPFC_TARGET_MODE
+	return lpfc_sli_replace_hbqbuff(phba, tag);
+#else
 	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
 	if (!hbq_entry)
 		return NULL;
 	return &hbq_entry->dbuf;
+#endif
 }
 
 /**
@@ -1932,6 +2028,14 @@ lpfc_complete_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	int i;
 
 	/* unSolicited Responses */
+#ifdef LPFC_TARGET_MODE
+	if (pring->ringno == LPFC_EXTRA_RING) {
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event) {
+			(pring->prt[0].lpfc_sli_rcv_unsol_event)(phba, pring, saveq);
+			return 1;
+		}
+	}
+#endif
 	if (pring->prt[0].profile) {
 		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
 			(pring->prt[0].lpfc_sli_rcv_unsol_event) (phba, pring,
@@ -1980,6 +2084,22 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	match = 0;
 	irsp = &(saveq->iocb);
 
+	printk("-------------------------> lpfc_sli_process_unsol_iocb():"
+			" Dump IOCB_t *irsp: %p\n", irsp);
+	printk("ulpCommand: 0x%08x ulpContext: 0x%04x ulpIoTag: 0x%04x\n",
+		irsp->ulpCommand, irsp->ulpContext, irsp->ulpIoTag);
+
+	if (unlikely(irsp->ulpStatus == IOSTAT_NEED_BUFFER)) {
+#ifdef LPFC_TARGET_MODE
+		if (pring->ringno == LPFC_EXTRA_RING) {
+			printk("got ulpStatus == IOSTAT_NEED_BUFFER, calling "
+					"lpfc_sli_hbqbuf_add_hbqs()\n");
+			lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_EXTRA_HBQ);
+		}
+#endif
+		return 1;
+	}
+
 	if (irsp->ulpCommand == CMD_ASYNC_STATUS) {
 		if (pring->lpfc_sli_rcv_async_status)
 			pring->lpfc_sli_rcv_async_status(phba, pring, saveq);
@@ -1995,6 +2115,25 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		return 1;
 	}
 
+#ifdef LPFC_TARGET_MODE
+	/* Forward XRI ABORTED async response to target driver */
+	if ((saveq->iocb.ulpCommand == CMD_XRI_ABORTED_CX) &&
+	    (pring->ringno == LPFC_EXTRA_RING)) {
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
+			(pring->prt[0].lpfc_sli_rcv_unsol_event)(phba, pring, saveq);
+
+		return 1;
+	}
+	/* Forward SRR Request async command to target driver */
+	if ((saveq->iocb.ulpCommand == CMD_RCV_SRR_REQ64_CX) &&
+	    (pring->ringno == LPFC_EXTRA_RING)) {
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
+			(pring->prt[0].lpfc_sli_rcv_unsol_event)(phba, pring, saveq);
+
+		return 1;
+	}
+#endif
+
 	if ((irsp->ulpCommand == CMD_IOCB_RET_XRI64_CX) &&
 		(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)) {
 		if (irsp->ulpBdeCount > 0) {
@@ -2018,6 +2157,41 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		return 1;
 	}
 
+#ifdef LPFC_TARGET_MODE
+	if ((irsp->ulpCommand == CMD_IOCB_RET_HBQE64_CN) &&
+	    (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)) {
+		struct hbq_dmabuf *hbq_entry;
+		int i, tag;
+
+		if (pring->ringno != LPFC_EXTRA_RING)
+			return 1;
+
+		for (i = 0; i < irsp->ulpBdeCount; i++) {
+			switch (i) {
+			case 0:
+				tag = irsp->un.ulpWord[3];
+				break;
+			case 1:
+				tag = irsp->unsli3.sli3Words[3];
+				break;
+			case 2:
+				tag = irsp->unsli3.sli3Words[7];
+				break;
+			default:
+				return 1;
+			}
+			hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
+
+			if (hbq_entry) {
+				list_del(&hbq_entry->dbuf.list);
+				lpfc_tm_hbq_free(phba, hbq_entry);
+			}
+		}
+
+		return 1;
+	}
+#endif
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		if (irsp->ulpBdeCount != 0) {
 			saveq->context2 = lpfc_sli_get_buff(phba, pring,
@@ -2448,6 +2622,9 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 	lpfc_iocb_type type;
 	unsigned long iflag;
 	uint32_t rsp_cmpl = 0;
+#ifdef LPFC_TARGET_MODE
+	int rsp_cnt = 0;
+#endif
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	pring->stats.iocb_event++;
@@ -2527,6 +2704,17 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 			 * resources need to be recovered.
 			 */
 			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
+#ifdef LPFC_TARGET_MODE
+				/* If target mode port */
+				/* send XRI_ABORTED to target driver */
+				if ((pring->ringno == LPFC_EXTRA_RING) &&
+				    (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)) {
+					spin_unlock_irqrestore(&phba->hbalock, iflag);
+					lpfc_sli_process_unsol_iocb(phba, pring, &rspiocbq);
+					spin_lock_irqsave(&phba->hbalock, iflag);
+					break;
+				}
+#endif
 				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 						"0333 IOCB cmd 0x%x"
 						" processed. Skipping"
@@ -2585,6 +2773,13 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 
 		if (pring->rspidx == portRspPut)
 			portRspPut = le32_to_cpu(pgp->rspPutInx);
+#ifdef LPFC_TARGET_MODE
+		if ((pring->ringno == LPFC_EXTRA_RING) && phba->poll_rsp_cnt) {
+			rsp_cnt++;
+			if (rsp_cnt >= phba->poll_rsp_cnt)
+				break;
+		}
+#endif
 	}
 
 	if ((rsp_cmpl > 0) && (mask & HA_R0RE_REQ)) {
@@ -4064,6 +4259,16 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET) {
+		dev_printk(KERN_NOTICE, &phba->pcidev->dev, "lpfc%d: "
+			"Enabled LPFC_FCP_MODE_TARGET for WWPN %02x:%02x:%02x:%02x:"
+			"%02x:%02x:%02x:%02x\n", phba->brd_no, phba->wwpn[0],
+			phba->wwpn[1], phba->wwpn[2], phba->wwpn[3],
+			phba->wwpn[4], phba->wwpn[5], phba->wwpn[6],
+			phba->wwpn[7]);
+        }
+#endif
 	return rc;
 
 lpfc_sli_hba_setup_error:
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index e379215..2507db1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -297,3 +297,43 @@ struct lpfc_sli {
 					 * multiple flash erases that can be
 					 * spawned.
 					 */
+#ifdef LPFC_TARGET_MODE
+
+/*
+ * Functions to build or extract fields for HBQ buffer tags.
+ * The libdfc functions use the high order bit (bit 31) aka
+ * QUE_BUFTAG_BIT. Since we will never use more than 7 HBQs,
+ * the hbqno occupies only bits 30:28.  The the hbqno is in 30:28,
+ * applications tag is in bits 27:14, the hbq entry index
+ * is in bits 13:0.
+ */
+
+#define LPFC_MAX_HBQ_ENTRIES 0x3fff
+
+static inline uint32_t
+lpfc_build_hbq_tag(uint16_t hbqno, uint16_t hbqidx, uint16_t app_tag)
+{
+	return ((hbqno & 0x7) << 28) |
+		((app_tag & LPFC_MAX_HBQ_ENTRIES) << 14) |
+		(hbqidx & LPFC_MAX_HBQ_ENTRIES);
+}
+
+static inline uint16_t
+lpfc_hbq_app_tag_get(uint32_t tag)
+{
+	return (tag >> 14) & LPFC_MAX_HBQ_ENTRIES;
+}
+
+static inline uint16_t
+lpfc_hbq_idx_get(uint32_t tag)
+{
+	return tag & LPFC_MAX_HBQ_ENTRIES;
+}
+
+static inline uint16_t
+lpfc_hbqno_get(uint32_t tag)
+{
+	return (tag >> 28) & 0x7;
+}
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index ab91359..1807aad 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -37,6 +37,10 @@
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -45,6 +49,9 @@
 #include "lpfc_crtn.h"
 #include "lpfc_version.h"
 #include "lpfc_vport.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_protos.h"
+#endif
 
 inline void lpfc_vport_set_state(struct lpfc_vport *vport,
 				 enum fc_vport_state new_state)
@@ -416,6 +423,11 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		goto out;
 	}
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		lpfc_target_new_tgtport(vport);
+#endif
+
 	if ((phba->link_state < LPFC_LINK_UP) ||
 	    (pport->port_state < LPFC_FABRIC_CFG_LINK) ||
 	    (phba->fc_topology == TOPOLOGY_LOOP)) {
@@ -739,6 +751,11 @@ skip_logo:
 	} else
 		scsi_host_put(shost);
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		lpfc_tm_tgtport_unbind(vport);
+#endif
+
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;
 	spin_lock_irq(&phba->hbalock);
-- 
1.5.6.5
