From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [RFC PATCH 2/2] lpfc: add target hooks
Date: Sun, 12 Apr 2015 16:17:40 +0200
Message-ID: <20150412161740.00001d41@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Add target hooks.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---

diff -uNrp 4.0-rc7.orig/drivers/scsi/Kconfig 4.0-rc7/drivers/scsi/Kconfig
--- 4.0-rc7.orig/drivers/scsi/Kconfig	2015-04-12 12:52:36.830558971 +0200
+++ 4.0-rc7/drivers/scsi/Kconfig	2015-04-12 12:53:01.582559694 +0200
@@ -1299,6 +1299,12 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+config SCSI_LPFC_TARGET
+	bool "Emulex LightPulse Fibre Channel Target Support"
+	depends on SCSI_LPFC
+	help
+	  Support target mode.
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/Makefile 4.0-rc7/drivers/scsi/lpfc/Makefile
--- 4.0-rc7.orig/drivers/scsi/lpfc/Makefile	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/Makefile	2015-04-12 10:32:24.654179770 +0200
@@ -31,3 +31,8 @@ obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\
 	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
 	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
+
+ifdef CONFIG_SCSI_LPFC_TARGET
+	ccflags-y += -DLPFC_TARGET_MODE
+	lpfc-objs += lpfc_target_api.o
+endif
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc.h 4.0-rc7/drivers/scsi/lpfc/lpfc.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc.h	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc.h	2015-04-12 10:32:24.658179770 +0200
@@ -438,6 +438,9 @@ struct lpfc_vport {
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API_BASE
+	tm_tgtport_t target_tgtport;
+#endif
 };
 
 struct hbq_s {
@@ -988,6 +991,15 @@ struct lpfc_hba {
 	spinlock_t devicelock;	/* lock for luns list */
 	mempool_t *device_data_mem_pool;
 	struct list_head luns;
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API_BASE
+	uint32_t cfg_initialize_link;
+	uint32_t cfg_fcp_mode;
+#define LPFC_FCP_MODE_INITIATOR		1
+#define LPFC_FCP_MODE_TARGET		2
+	uint32_t poll_rsp_cnt;
+	uint32_t num_targets_bound;
+	tm_sliport_t target_sliport;
+#endif
 };
 
 static inline struct Scsi_Host *
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_attr.c 4.0-rc7/drivers/scsi/lpfc/lpfc_attr.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_attr.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_attr.c	2015-04-12 11:02:29.706161456 +0200
@@ -39,6 +39,10 @@
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
@@ -1139,7 +1143,7 @@ board_mode_out:
  * zero on error
  * one for success
  **/
-static int
+int
 lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mxri, uint32_t *axri,
 		  uint32_t *mrpi, uint32_t *arpi,
@@ -4566,6 +4570,30 @@ LPFC_ATTR_R(multi_ring_rctl, FC_RCTL_DD_
 LPFC_ATTR_R(multi_ring_type, FC_TYPE_IP, 1,
 	     255, "Identifies TYPE for additional ring configuration");
 
+#ifdef LPFC_TARGET_MODE
+/*
+# lpfc_initialize_link:  Bring link up at initialization
+#            0x0  = do NOT bring link up (MBX_INIT_LINK)
+#            0x1  = bring link up (issue MBX_INIT_LINK)
+# Default value is 1.
+*/
+LPFC_ATTR_R(initialize_link, 1, 0, 1, "Bring Link Up at initialization");
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
+	"List of values determining target/initiator behavior");
+#endif
+
 /*
 # lpfc_fdmi_on: controls FDMI support.
 #       0 = no FDMI support
@@ -4795,6 +4823,9 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_ack0,
 	&dev_attr_lpfc_topology,
 	&dev_attr_lpfc_scan_down,
+#ifdef LPFC_TARGET_MODE
+	&dev_attr_lpfc_initialize_link,
+#endif
 	&dev_attr_lpfc_link_speed,
 	&dev_attr_lpfc_fcp_io_sched,
 	&dev_attr_lpfc_fcp2_no_tgt_reset,
@@ -5797,6 +5828,27 @@ struct fc_function_template lpfc_vport_t
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
+#ifdef LPFC_TARGET_MODE
+	int i = 0, mode = LPFC_FCP_MODE_TARGET;
+
+	if (num_lpfc_fcp_mode & 1) {
+		printk("lpfc_fcp_mode expects pairs. Defaulting to "
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
+#endif
 	lpfc_fcp_io_sched_init(phba, lpfc_fcp_io_sched);
 	lpfc_fcp2_no_tgt_reset_init(phba, lpfc_fcp2_no_tgt_reset);
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
@@ -5844,6 +5896,16 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	phba->cfg_enable_dss = 1;
+#ifdef LPFC_TARGET_MODE
+	/* Its possible to be BOTH Target and Initiator */
+	if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR))
+		phba->cfg_initialize_link = 0;
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET) {
+		phba->cfg_multi_ring_support = 2;
+		phba->cfg_multi_ring_rctl = FC_RCTL_DD_UNSOL_CMD;
+		phba->cfg_multi_ring_type = FC_TYPE_FCP;
+	}
+#endif
 	return;
 }
 
@@ -5870,5 +5932,9 @@ lpfc_get_vport_cfgparam(struct lpfc_vpor
 	lpfc_max_luns_init(vport, lpfc_max_luns);
 	lpfc_scan_down_init(vport, lpfc_scan_down);
 	lpfc_enable_da_id_init(vport, lpfc_enable_da_id);
+#ifdef LPFC_TARGET_MODE
+	if (!(vport->phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR))
+		vport->cfg_use_adisc = 1;
+#endif
 	return;
 }
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_ct.c 4.0-rc7/drivers/scsi/lpfc/lpfc_ct.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_ct.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_ct.c	2015-04-12 10:32:24.682179769 +0200
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
@@ -1247,7 +1251,13 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
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
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_debugfs.c 4.0-rc7/drivers/scsi/lpfc/lpfc_debugfs.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_debugfs.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_debugfs.c	2015-04-12 10:32:24.686179769 +0200
@@ -40,6 +40,10 @@
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_disc.h 4.0-rc7/drivers/scsi/lpfc/lpfc_disc.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_disc.h	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_disc.h	2015-04-12 10:32:24.686179769 +0200
@@ -119,6 +119,15 @@ struct lpfc_nodelist {
 	unsigned long last_change_time;
 	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
+#if defined LPFC_TARGET_MODE && defined _H_LPFC_TGT_API
+	tm_login_info_t      tm_login_info;
+	tm_login_handle_t    login_handle;
+	uint32_t             tm_check_login_result;
+	uint8_t              tm_check_login_called;
+	uint8_t              login_handle_valid;
+	uint16_t             tm_login_flags;
+#define NLP_TM_DELAYED_LOGIN   0x1
+#endif
 };
 struct lpfc_node_rrq {
 	struct list_head list;
@@ -147,6 +156,9 @@ struct lpfc_node_rrq {
 #define NLP_LOGO_ACC       0x00100000	/* Process LOGO after ACC completes */
 #define NLP_TGT_NO_SCSIID  0x00200000	/* good PRLI but no binding for scsid */
 #define NLP_ISSUE_LOGO     0x00400000	/* waiting to issue a LOGO */
+#ifdef LPFC_TARGET_MODE
+#define NLP_NEED_PRLI      0x00800000   /* Need PRLI to determine capability */
+#endif
 #define NLP_ACC_REGLOGIN   0x01000000	/* Issue Reg Login after successful
 					   ACC */
 #define NLP_NPR_ADISC      0x02000000	/* Issue ADISC when dq'ed from
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_els.c 4.0-rc7/drivers/scsi/lpfc/lpfc_els.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_els.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_els.c	2015-04-12 11:17:28.250152339 +0200
@@ -34,6 +34,10 @@
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
@@ -42,6 +46,9 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_protos.h"
+#endif
 
 static int lpfc_els_retry(struct lpfc_hba *, struct lpfc_iocbq *,
 			  struct lpfc_iocbq *);
@@ -1963,6 +1970,18 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	uint16_t cmdsize;
 	int ret;
 
+#ifdef LPFC_TARGET_MODE
+	if (!(phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) &&
+		((did & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+		!(vport->fc_flag & FC_PT2PT_PLOGI)) {
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
@@ -2137,6 +2156,29 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 
 	/* For PRLI, remainder of payload is PRLI parameter page */
 	npr = (PRLI *) pcmd;
+#ifdef LPFC_TARGET_MODE
+	/* check if we want to act as target */
+	if (lpfc_target_check_login(vport, ndlp) == TM_RCD_SUCCESS) {
+		/* success */
+		npr->targetFunc = 1;
+	}
+	npr->initiatorFunc = 0;
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) {
+		npr->initiatorFunc = 1;
+		/* If we don't want to act as target, then tape OK */
+		if (!npr->targetFunc) {
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
@@ -2146,6 +2188,8 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 		npr->Retry = 1;
 		npr->TaskRetryIdReq = 1;
 	}
+	npr->initiatorFunc = 1;
+#endif
 	npr->estabImagePair = 1;
 	npr->readXferRdyDis = 1;
 	 if (vport->cfg_first_burst_size)
@@ -2153,7 +2197,6 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 
 	/* For FCP support */
 	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PRLI:      did:x%x",
@@ -4214,6 +4257,9 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+#ifdef LPFC_TARGET_MODE
+	uint8_t rem_initiatorFunc;
+#endif
 
 	psli = &phba->sli;
 
@@ -4228,6 +4274,13 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 	icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
 	icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
 
+#ifdef LPFC_TARGET_MODE
+	/* Check if the remote port support initiatorFunc */
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) oldiocb->context2)->virt);
+	pcmd += sizeof(uint32_t);
+	npr = (PRLI *) pcmd;
+	rem_initiatorFunc = npr->initiatorFunc;
+#endif
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0131 Xmit PRLI ACC response tag x%x xri x%x, "
@@ -4245,6 +4298,29 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 
 	npr = (PRLI *) pcmd;
 	vpd = &phba->vpd;
+#ifdef LPFC_TARGET_MODE
+	/* check if we want to act as target */
+	if (lpfc_target_check_login(vport, ndlp) == TM_RCD_SUCCESS) {
+		/* success */
+		npr->targetFunc = 1;
+	}
+	npr->initiatorFunc = 0;
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) {
+		npr->initiatorFunc = 1;
+		/* If we don't want to act as target, then tape OK */
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
@@ -4255,6 +4331,8 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 		npr->Retry = 1;
 		npr->TaskRetryIdReq = 1;
 	}
+	npr->initiatorFunc = 1;
+#endif
 
 	npr->acceptRspCode = PRLI_REQ_EXECUTED;
 	npr->estabImagePair = 1;
@@ -4262,7 +4340,6 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 	npr->ConfmComplAllowed = 1;
 
 	npr->prliType = PRLI_FCP_TYPE;
-	npr->initiatorFunc = 1;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue ACC PRLI:  did:x%x flg:x%x",
@@ -4276,6 +4353,23 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+#ifdef LPFC_TARGET_MODE
+	/* at this point initialize the target */
+	if (npr->acceptRspCode == PRLI_REQ_EXECUTED
+		&& npr->prliType == PRLI_FCP_TYPE
+		&& ndlp->tm_check_login_called
+		&& ndlp->tm_check_login_result == TM_RCD_SUCCESS
+		&& !ndlp->login_handle_valid
+		&& rem_initiatorFunc) {
+
+		if (ndlp->nlp_rpi) {
+			ndlp->login_handle = tm_tgtport_login(vport, ndlp);
+			if (ndlp->login_handle)
+				ndlp->login_handle_valid = 1;
+		} else
+			ndlp->tm_login_flags |= NLP_TM_DELAYED_LOGIN;
+	}
+#endif
 	return 0;
 }
 
@@ -8100,7 +8194,7 @@ static void lpfc_fabric_abort_vport(stru
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
-	struct lpfc_hba  *phba = ndlp->phba;
+	struct lpfc_hba  *phba = ndlp->vport->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_hbadisc.c 4.0-rc7/drivers/scsi/lpfc/lpfc_hbadisc.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-04-12 11:04:15.786160379 +0200
@@ -33,6 +33,10 @@
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_sli.h"
@@ -43,6 +47,9 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_protos.h"
+#endif
 
 /* AlpaArray for assignment of scsid for scan-down and bind_method */
 static uint8_t lpfcAlpaArray[] = {
@@ -3468,6 +3475,17 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba
 	 */
 	lpfc_nlp_put(ndlp);
 
+#ifdef LPFC_TARGET_MODE
+	/* check if we need to notify the target api
+	 * set when prli has completed before reg_login mailbox cmd */
+	if (ndlp->tm_login_flags & NLP_TM_DELAYED_LOGIN) {
+		ndlp->tm_login_flags &= ~NLP_TM_DELAYED_LOGIN;
+		ndlp->login_handle = tm_tgtport_login(vport, ndlp);
+		if (ndlp->login_handle != NULL)
+			ndlp->login_handle_valid = 1;
+	}
+#endif
+
 	return;
 }
 
@@ -3562,8 +3580,16 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *p
 	spin_unlock_irq(shost->host_lock);
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
+#ifdef LPFC_TARGET_MODE
+	if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+		(vport->fc_flag & FC_PT2PT_PLOGI)) {
+		if (vport->fc_npr_cnt)
+			lpfc_els_disc_plogi(vport);
+	}
+#else
 	if (vport->fc_npr_cnt)
 		lpfc_els_disc_plogi(vport);
+#endif
 
 	if (!vport->num_disc_nodes) {
 		spin_lock_irq(shost->host_lock);
@@ -4493,6 +4519,13 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	int rc;
 	uint16_t rpi;
 
+#ifdef LPFC_TARGET_MODE
+	/* if there is a valid target login, need to logout now. */
+	tm_tgtport_logout(vport, ndlp->login_handle);
+	ndlp->login_handle = 0;
+	ndlp->login_handle_valid = 0;
+	ndlp->tm_check_login_called = 0;
+#endif
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED ||
 	    ndlp->nlp_flag & NLP_REG_LOGIN_SEND) {
 		if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
@@ -4869,6 +4902,10 @@ lpfc_setup_disc_node(struct lpfc_vport *
 
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
+#ifdef LPFC_TARGET_MODE
+		if (!(vport->phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR))
+			return NULL;
+#endif
 		if ((vport->fc_flag & FC_RSCN_MODE) != 0 &&
 		    lpfc_rscn_payload_check(vport, did) == 0)
 			return NULL;
@@ -5088,8 +5125,16 @@ lpfc_disc_start(struct lpfc_vport *vport
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
 			/* go thru NPR nodes and issue ELS PLOGIs */
+#ifdef LPFC_TARGET_MODE
+			if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+				(vport->fc_flag & FC_PT2PT_PLOGI)) {
+				if (vport->fc_npr_cnt)
+					lpfc_els_disc_plogi(vport);
+			}
+#else
 			if (vport->fc_npr_cnt)
 				lpfc_els_disc_plogi(vport);
+#endif
 
 			if (!vport->num_disc_nodes) {
 				spin_lock_irq(shost->host_lock);
@@ -5101,7 +5146,14 @@ lpfc_disc_start(struct lpfc_vport *vport
 		vport->port_state = LPFC_VPORT_READY;
 	} else {
 		/* Next do PLOGIs - if any */
+#ifdef LPFC_TARGET_MODE
+		if ((phba->cfg_fcp_mode & LPFC_FCP_MODE_INITIATOR) ||
+			(vport->fc_flag & FC_PT2PT_PLOGI)) {
+			num_sent = lpfc_els_disc_plogi(vport);
+		}
+#else
 		num_sent = lpfc_els_disc_plogi(vport);
+#endif
 
 		if (num_sent)
 			return;
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_hw.h 4.0-rc7/drivers/scsi/lpfc/lpfc_hw.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_hw.h	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_hw.h	2015-04-12 10:32:24.702179769 +0200
@@ -1439,6 +1439,8 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_PORT_IOV_CONTROL 0x3C
 
 #define MBX_CONFIG_HBQ	    0x7C
+#define MBX_PAUSE_HBQ      0x7D
+#define MBX_RESUME_HBQ     0x7E
 #define MBX_LOAD_AREA       0x81
 #define MBX_RUN_BIU_DIAG64  0x84
 #define MBX_CONFIG_PORT     0x88
@@ -1874,6 +1876,10 @@ typedef struct {
 #define	FLAGS_UNREG_LOGIN_ALL	     0x08 /* UNREG_LOGIN all on link down */
 #define FLAGS_LIRP_LILP              0x80 /* LIRP / LILP is disabled */
 
+#ifdef LPFC_TARGET_MODE
+#define FLAGS_DISABLE_TGT_ABTS       0x20       /* Bit 5 */
+#define FLAGS_DISABLE_GLBL_ABTS      0x02000    /* Bit 13 */
+#endif
 #define FLAGS_TOPOLOGY_FAILOVER      0x0400	/* Bit 10 */
 #define FLAGS_LINK_SPEED             0x0800	/* Bit 11 */
 #define FLAGS_IMED_ABORT             0x04000	/* Bit 14 */
@@ -2799,7 +2805,37 @@ struct config_hbq_var {
 
 };
 
+/* Structure for MB Command PAUSE_HBQ (7d) */
+struct pause_hbq_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t hbqId:16;
+	uint32_t rsvd1:16;
+#else  /*  __LITTLE_ENDIAN */
+	uint32_t rsvd1:16;
+	uint32_t hbqId:16;
+#endif
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd2:16;
+	uint32_t mbTag16:16;
+#else  /*  __LITTLE_ENDIAN */
+	uint32_t mbTag16:16;
+	uint32_t rsvd2:16;
+#endif
+
+};
+
+/* Structure for MB Command RESUME_HBQ (7e) */
+struct resume_hbq_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t hbqId:16;
+	uint32_t hbqGetPtr:16;
+#else  /*  __LITTLE_ENDIAN */
+	uint32_t hbqGetPtr:16;
+	uint32_t hbqId:16;
+#endif
 
+};
 
 /* Structure for MB Command CONFIG_PORT (0x88) */
 typedef struct {
@@ -3080,6 +3116,8 @@ typedef union {
 					 * NEW_FEATURE
 					 */
 	struct config_hbq_var varCfgHbq;/* cmd = 0x7c (CONFIG_HBQ)  */
+	struct pause_hbq_var varPauseHbq; /* cmd = 0x7d (PAUSE_HBQ)  */
+	struct resume_hbq_var varResumeHbq; /* cmd = 0x7e (RESUME_HBQ)  */
 	struct update_cfg_var varUpdateCfg; /* cmd = 0x1B (UPDATE_CFG)*/
 	CONFIG_PORT_VAR varCfgPort;	/* cmd = 0x88 (CONFIG_PORT)  */
 	struct lpfc_mbx_read_top varReadTop; /* cmd = 0x95 (READ_TOPOLOGY) */
@@ -3723,6 +3761,9 @@ typedef struct _IOCB {	/* IOCB structure
 	uint32_t ulpTimeout:8;
 #endif
 
+#define ulpAc ulpOwner
+#define ulpAutoResponse ulpFCP2Rcvy
+
 	union {
 		struct rcv_sli3 rcvsli3; /* words 8 - 15 */
 
@@ -3760,7 +3801,7 @@ typedef struct _IOCB {	/* IOCB structure
 #define IOSTAT_INTERMED_RSP    0x8
 #define IOSTAT_LS_RJT          0x9
 #define IOSTAT_BA_RJT          0xA
-#define IOSTAT_RSVD1           0xB
+#define IOSTAT_CMD_RJT         0xB
 #define IOSTAT_RSVD2           0xC
 #define IOSTAT_RSVD3           0xD
 #define IOSTAT_RSVD4           0xE
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_init.c 4.0-rc7/drivers/scsi/lpfc/lpfc_init.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_init.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_init.c	2015-04-12 11:04:34.706160187 +0200
@@ -44,6 +44,10 @@
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
@@ -570,6 +574,11 @@ lpfc_config_port_post(struct lpfc_hba *p
 	mod_timer(&phba->eratt_poll,
 		  jiffies + msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_initialize_link)
+		lpfc_init_link(phba, pmb, phba->cfg_topology,
+				phba->cfg_link_speed);
+#endif
 	if (phba->hba_flag & LINK_DISABLED) {
 		lpfc_printf_log(phba,
 			KERN_ERR, LOG_INIT,
@@ -6188,6 +6197,14 @@ lpfc_post_init_setup(struct lpfc_hba *ph
 		spin_unlock_irq(shost->host_lock);
 	}
 
+#ifdef LPFC_TARGET_MODE
+	if (!phba->cfg_initialize_link) {
+		/* After initialization, this should always be set */
+		phba->cfg_initialize_link = 1;
+		return;
+	}
+#endif
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0428 Perform SCSI scan\n");
 	/* Send board arrival event to upper layer */
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_mbox.c 4.0-rc7/drivers/scsi/lpfc/lpfc_mbox.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_mbox.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_mbox.c	2015-04-12 10:32:24.710179769 +0200
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
@@ -553,6 +557,12 @@ lpfc_init_link(struct lpfc_hba * phba,
 	else
 		mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET) {
+		mb->un.varInitLnk.link_flags |=
+			(FLAGS_DISABLE_TGT_ABTS | FLAGS_DISABLE_TGT_ABTS);
+	}
+#endif
 	mb->mbxCommand = (volatile uint8_t)MBX_INIT_LINK;
 	mb->mbxOwner = OWN_HOST;
 	mb->un.varInitLnk.fabric_AL_PA = phba->fc_pref_ALPA;
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_mem.c 4.0-rc7/drivers/scsi/lpfc/lpfc_mem.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_mem.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_mem.c	2015-04-12 10:32:24.714179769 +0200
@@ -34,6 +34,10 @@
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -560,6 +564,7 @@ lpfc_in_buf_free(struct lpfc_hba *phba,
 {
 	struct hbq_dmabuf *hbq_entry;
 	unsigned long flags;
+	uint32_t hbqno;
 
 	if (!mp)
 		return;
@@ -573,7 +578,8 @@ lpfc_in_buf_free(struct lpfc_hba *phba,
 		}
 		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		list_del(&hbq_entry->dbuf.list);
-		if (hbq_entry->tag == -1) {
+		hbqno = lpfc_hbqno_get(hbq_entry->tag);
+		if (hbqno >= LPFC_MAX_HBQS) {
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
 				(phba, hbq_entry);
 		} else {
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_nportdisc.c 4.0-rc7/drivers/scsi/lpfc/lpfc_nportdisc.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_nportdisc.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_nportdisc.c	2015-04-12 11:05:14.614159783 +0200
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
@@ -372,9 +376,11 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
 			break;
+	case  NLP_STE_UNMAPPED_NODE:
+		if (!ndlp->nlp_rpi)
+			break;
 	case  NLP_STE_REG_LOGIN_ISSUE:
 	case  NLP_STE_PRLI_ISSUE:
-	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
 		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
 		return 1;
@@ -1312,6 +1318,9 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
+#ifdef LPFC_TARGET_MODE
+	struct ls_rjt     stat;
+#endif
 	IOCB_t *irsp;
 	ADISC *ap;
 	int rc;
@@ -1322,6 +1331,72 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 	ap = (ADISC *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
 	irsp = &rspiocb->iocb;
 
+#ifdef LPFC_TARGET_MODE
+	if (irsp->ulpStatus) {
+		stat.un.lsRjtError = be32_to_cpu(irsp->un.ulpWord[4]);
+
+		/* did is alive but can't be authenticated */
+		if (stat.un.b.lsRjtRsnCode == LSRJT_UNABLE_TPC ||
+			stat.un.b.lsRjtRsnCode == LSRJT_CMD_UNSUPPORTED) {
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
+	} else if (!lpfc_check_adisc(vport,
+				ndlp, &ap->nodeName, &ap->portName)) {
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
+
+#else
 	if ((irsp->ulpStatus) ||
 	    (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName))) {
 		/* 1 sec timeout */
@@ -1340,6 +1415,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		lpfc_unreg_rpi(vport, ndlp);
 		return ndlp->nlp_state;
 	}
+#endif
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		rc = lpfc_sli4_resume_rpi(ndlp, NULL, NULL);
@@ -1553,9 +1629,22 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 
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
@@ -1678,6 +1767,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vp
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
+#ifdef LPFC_TARGET_MODE
+	ndlp->nlp_flag &= ~NLP_NEED_PRLI;
+#endif
 	npr = (PRLI *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
 
 	irsp = &rspiocb->iocb;
@@ -1807,6 +1899,9 @@ lpfc_device_recov_prli_issue(struct lpfc
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
+#ifdef LPFC_TARGET_MODE
+	ndlp->nlp_flag |= NLP_NEED_PRLI;
+#endif
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
 }
@@ -2098,7 +2193,16 @@ lpfc_rcv_prli_npr_node(struct lpfc_vport
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
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_scsi.c 4.0-rc7/drivers/scsi/lpfc/lpfc_scsi.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_scsi.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_scsi.c	2015-04-12 10:32:24.718179769 +0200
@@ -40,6 +40,10 @@
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
+#ifdef LPFC_TARGET_MODE
+#include "lpfc_target_api.h"
+#include "lpfc_target_api_base.h"
+#endif
 #include "lpfc_disc.h"
 #include "lpfc.h"
 #include "lpfc_scsi.h"
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_sli.c 4.0-rc7/drivers/scsi/lpfc/lpfc_sli.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_sli.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_sli.c	2015-04-12 11:41:52.766137480 +0200
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
@@ -55,6 +59,9 @@ typedef enum _lpfc_iocb_type {
 	LPFC_ABORT_IOCB
 } lpfc_iocb_type;
 
+#ifdef LPFC_TARGET_MODE
+void lpfc_tm_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp);
+#endif
 
 /* Provide function prototypes local to this module. */
 static int lpfc_sli_issue_mbox_s4(struct lpfc_hba *, LPFC_MBOXQ_t *,
@@ -1221,6 +1228,9 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_IOCB_RCV_ELS64_CX:
 	case CMD_IOCB_RCV_CONT64_CX:
 	case CMD_IOCB_RET_XRI64_CX:
+#ifdef LPFC_TARGET_MODE
+	case CMD_IOCB_RET_HBQE64_CN:
+#endif
 		type = LPFC_UNSOL_IOCB;
 		break;
 	case CMD_IOCB_XMIT_MSEQ64_CR:
@@ -1229,7 +1239,9 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_IOCB_RCV_ELS_LIST64_CX:
 	case CMD_IOCB_CLOSE_EXTENDED_CN:
 	case CMD_IOCB_ABORT_EXTENDED_CN:
+#ifndef LPFC_TARGET_MODE
 	case CMD_IOCB_RET_HBQE64_CN:
+#endif
 	case CMD_IOCB_FCP_IBIDIR64_CR:
 	case CMD_IOCB_FCP_IBIDIR64_CX:
 	case CMD_IOCB_FCP_ITASKMGT64_CX:
@@ -1712,8 +1724,13 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
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
@@ -1820,7 +1837,7 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_
 /* HBQ for ELS and CT traffic. */
 static struct lpfc_hbq_init lpfc_els_hbq = {
 	.rn = 1,
-	.entry_count = 256,
+	.entry_count = 200,     /* 12 bits max size */
 	.mask_count = 0,
 	.profile = 0,
 	.ring_mask = (1 << LPFC_ELS_RING),
@@ -1857,7 +1874,7 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] =
  * given HBQ. The function returns the number of HBQ buffers successfully
  * posted.
  **/
-static int
+int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
 	uint32_t i, posted = 0;
@@ -1887,8 +1904,14 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 	while (!list_empty(&hbq_buf_list)) {
 		list_remove_head(&hbq_buf_list, hbq_buffer, struct hbq_dmabuf,
 				 dbuf.list);
+#ifdef LPFC_TARGET_MODE
+		/* convert app tag to base driver hbq tag */
+		i = phba->hbqs[hbqno].buffer_count;
+		hbq_buffer->tag = lpfc_build_hbq_tag(hbqno, i, hbq_buffer->tag);
+#else
 		hbq_buffer->tag = (phba->hbqs[hbqno].buffer_count |
 				      (hbqno << 16));
+#endif
 		if (!lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
 			phba->hbqs[hbqno].buffer_count++;
 			posted++;
@@ -1976,31 +1999,45 @@ lpfc_sli_hbqbuf_get(struct list_head *rb
  * it returns NULL.
  **/
 static struct hbq_dmabuf *
-lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
+__lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 {
 	struct lpfc_dmabuf *d_buf;
 	struct hbq_dmabuf *hbq_buf;
 	uint32_t hbqno;
 
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
@@ -2016,7 +2053,11 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba,
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
@@ -2345,6 +2386,55 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 	return 0;
 }
 
+#ifdef LPFC_TARGET_MODE
+static struct lpfc_dmabuf *
+lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
+{
+	struct hbq_dmabuf *hbq_entry, *new_hbq_entry;
+	uint32_t hbqno, hbqidx, new_tag;
+	void *virt;             /* virtual address ptr */
+	dma_addr_t phys;        /* mapped address */
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
+	hbqidx = lpfc_hbq_idx_get(tag);
+	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
+	if (new_hbq_entry == NULL) {
+		list_add_tail(&hbq_entry->dbuf.list, &phba->rb_pend_list);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return &hbq_entry->dbuf;
+	}
+	new_tag = lpfc_build_hbq_tag(hbqno, hbqidx, new_hbq_entry->tag);
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
+#endif
+
 /**
  * lpfc_sli_get_buff - Get the buffer associated with the buffer tag
  * @phba: Pointer to HBA context object.
@@ -2362,14 +2452,20 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 		  struct lpfc_sli_ring *pring,
 		  uint32_t tag)
 {
+#ifndef LPFC_TARGET_MODE
 	struct hbq_dmabuf *hbq_entry;
+#endif
 
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
@@ -2435,9 +2531,20 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	uint32_t           Rctl, Type;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_dmabuf *dmzbuf;
+#ifdef LPFC_TARGET_MODE
+	uint32_t           i, tag;
+	struct hbq_dmabuf *hbq_entry;
+#endif
 
 	irsp = &(saveq->iocb);
 
+	if (unlikely(irsp->ulpStatus == IOSTAT_NEED_BUFFER)) {
+#ifdef LPFC_TARGET_MODE
+		if (pring->ringno == LPFC_EXTRA_RING)
+			lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_EXTRA_HBQ);
+#endif
+		return 1;
+	}
 	if (irsp->ulpCommand == CMD_ASYNC_STATUS) {
 		if (pring->lpfc_sli_rcv_async_status)
 			pring->lpfc_sli_rcv_async_status(phba, pring, saveq);
@@ -2453,6 +2560,18 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		return 1;
 	}
 
+#ifdef LPFC_TARGET_MODE
+	/* Forward XRI ABORTED async response to target driver */
+	if ((saveq->iocb.ulpCommand == CMD_XRI_ABORTED_CX) &&
+		  (pring->ringno == LPFC_EXTRA_RING)) {
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event) {
+			(pring->prt[0].lpfc_sli_rcv_unsol_event)
+					(phba, pring, saveq);
+		}
+		return 1;
+	}
+#endif
+
 	if ((irsp->ulpCommand == CMD_IOCB_RET_XRI64_CX) &&
 		(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)) {
 		if (irsp->ulpBdeCount > 0) {
@@ -2476,6 +2595,37 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		return 1;
 	}
 
+	if ((irsp->ulpCommand == CMD_IOCB_RET_HBQE64_CN) &&
+		(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)) {
+#ifdef LPFC_TARGET_MODE
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
+#endif
+		return 1;
+	}
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		if (irsp->ulpBdeCount != 0) {
 			saveq->context2 = lpfc_sli_get_buff(phba, pring,
@@ -2928,6 +3078,9 @@ lpfc_sli_handle_fast_ring_event(struct l
 	lpfc_iocb_type type;
 	unsigned long iflag;
 	uint32_t rsp_cmpl = 0;
+#ifdef LPFC_TARGET_MODE
+	int rsp_cnt = 0;
+#endif
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	pring->stats.iocb_event++;
@@ -2986,7 +3139,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 			}
 
 			/* Rsp ring <ringno> error: IOCB */
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+			if (irsp->ulpStatus != IOSTAT_NEED_BUFFER) {
+				lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 					"0336 Rsp Ring %d error: IOCB Data: "
 					"x%x x%x x%x x%x x%x x%x x%x x%x\n",
 					pring->ringno,
@@ -2998,6 +3152,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 					irsp->un.ulpWord[5],
 					*(uint32_t *)&irsp->un1,
 					*((uint32_t *)&irsp->un1 + 1));
+			}
 		}
 
 		switch (type) {
@@ -3008,6 +3163,18 @@ lpfc_sli_handle_fast_ring_event(struct l
 			 * resources need to be recovered.
 			 */
 			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
+#ifdef LPFC_TARGET_MODE
+			/* If target mode port */
+			/* send XRI_ABORTED to target driver */
+			if ((pring->ringno == LPFC_EXTRA_RING) &&
+				 (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)) {
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				lpfc_sli_process_unsol_iocb
+					(phba, pring, &rspiocbq);
+				spin_lock_irqsave(&phba->hbalock, iflag);
+				break;
+			}
+#endif
 				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 						"0333 IOCB cmd 0x%x"
 						" processed. Skipping"
@@ -3067,6 +3234,13 @@ lpfc_sli_handle_fast_ring_event(struct l
 
 		if (pring->sli.sli3.rspidx == portRspPut)
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
@@ -7911,9 +8085,10 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba
 
 	/*
 	 * Check to see if we are blocking IOCB processing because of a
-	 * outstanding event.
+	 * outstanding event. IOCBs like CMD_QUE_RING_BUF* (without a cmpl)
+	 * should be allowed through.
 	 */
-	if (unlikely(pring->flag & LPFC_STOP_IOCB_EVENT))
+	if (unlikely(pring->flag & LPFC_STOP_IOCB_EVENT) && piocb->iocb_cmpl)
 		goto iocb_busy;
 
 	if (unlikely(phba->link_state == LPFC_LINK_DOWN)) {
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_sli.h 4.0-rc7/drivers/scsi/lpfc/lpfc_sli.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_sli.h	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_sli.h	2015-04-12 10:32:24.742179769 +0200
@@ -320,6 +320,37 @@ struct lpfc_sli {
 	struct lpfc_lnk_stat lnk_stat_offsets;
 };
 
+/*
+ * Functions to build or extract fields for HBQ buffer tags.
+ * The applications tag is in bits 30:16, the hbqno in 15:12,
+ * the hbq entry index is in bits 11:0 The high order bit (31)
+ * is reserved for non-hbq buffer use.
+ */
+static inline uint32_t
+lpfc_build_hbq_tag(uint16_t hbqno, uint16_t hbqidx, uint16_t app_tag)
+{
+	return ((app_tag & 0x7fff) << 16) |
+		((hbqno & 0xf) << 12) | (hbqidx & 0xfff);
+}
+
+static inline uint16_t
+lpfc_hbq_app_tag_get(uint32_t tag)
+{
+	return (tag >> 16) & 0x7fff;
+}
+
+static inline uint16_t
+lpfc_hbq_idx_get(uint32_t tag)
+{
+	return tag & 0xfff;
+}
+
+static inline uint16_t
+lpfc_hbqno_get(uint32_t tag)
+{
+	return (tag >> 12) & 0xf;
+}
+
 /* Timeout for normal outstanding mbox command (Seconds) */
 #define LPFC_MBOX_TMO				30
 /* Timeout for non-flash-based outstanding sli_config mbox command (Seconds) */
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_version.h 4.0-rc7/drivers/scsi/lpfc/lpfc_version.h
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_version.h	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_version.h	2015-04-12 10:32:24.750179769 +0200
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "10.4.8000.0."
+#define LPFC_DRIVER_VERSION "10.4.8000.0_tm_10.0.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
diff -uNrp 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_vport.c 4.0-rc7/drivers/scsi/lpfc/lpfc_vport.c
--- 4.0-rc7.orig/drivers/scsi/lpfc/lpfc_vport.c	2015-04-07 00:39:45.000000000 +0200
+++ 4.0-rc7/drivers/scsi/lpfc/lpfc_vport.c	2015-04-12 10:32:24.754179769 +0200
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
@@ -419,6 +426,11 @@ lpfc_vport_create(struct fc_vport *fc_vp
 		goto out;
 	}
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		lpfc_target_new_tgtport(vport);
+#endif
+
 	if ((phba->link_state < LPFC_LINK_UP) ||
 	    (pport->port_state < LPFC_FABRIC_CFG_LINK) ||
 	    (phba->fc_topology == LPFC_TOPOLOGY_LOOP)) {
@@ -777,6 +789,11 @@ skip_logo:
 	} else
 		scsi_host_put(shost);
 
+#ifdef LPFC_TARGET_MODE
+	if (phba->cfg_fcp_mode & LPFC_FCP_MODE_TARGET)
+		lpfc_target_rm_tgtport(vport);
+#endif
+
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;
 	spin_lock_irq(&phba->hbalock);
