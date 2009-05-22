From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/17] lpfc 8.3.2 : Addition of SLI4 Interface - Base
	Support - Part 2 of 6
Date: Fri, 22 May 2009 14:51:49 -0400
Message-ID: <1243018309.7729.47.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41991 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZEVSvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:51:51 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIprqO029711
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:51:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Base Support - Part 2 of 6

Adds new hardware and interface definitions.

Adds new interface routines - utilizing the reorganized layout of the
driver. Adds SLI-4 specific functions for attachment, initialization,
teardown, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |   49 ++++-
 lpfc_attr.c      |   83 +++++++--
 lpfc_crtn.h      |   59 +++++-
 lpfc_ct.c        |    2 
 lpfc_debugfs.c   |    2 
 lpfc_els.c       |    4 
 lpfc_hbadisc.c   |   34 +++
 lpfc_hw.h        |  140 ++++++++++-----
 lpfc_mbox.c      |    2 
 lpfc_mem.c       |  204 +++++++++++++++++-----
 lpfc_nportdisc.c |    2 
 lpfc_scsi.c      |  492 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 951 insertions(+), 122 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 13:16:24.000000000 -0400
@@ -30,8 +30,10 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -828,18 +830,37 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		return 0;
 	}
 
-	if (mrpi)
-		*mrpi = pmb->un.varRdConfig.max_rpi;
-	if (arpi)
-		*arpi = pmb->un.varRdConfig.avail_rpi;
-	if (mxri)
-		*mxri = pmb->un.varRdConfig.max_xri;
-	if (axri)
-		*axri = pmb->un.varRdConfig.avail_xri;
-	if (mvpi)
-		*mvpi = pmb->un.varRdConfig.max_vpi;
-	if (avpi)
-		*avpi = pmb->un.varRdConfig.avail_vpi;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		rd_config = &pmboxq->u.mqe.un.rd_config;
+		if (mrpi)
+			*mrpi = bf_get(lpfc_mbx_rd_conf_rpi_count, rd_config);
+		if (arpi)
+			*arpi = bf_get(lpfc_mbx_rd_conf_rpi_count, rd_config) -
+					phba->sli4_hba.max_cfg_param.rpi_used;
+		if (mxri)
+			*mxri = bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
+		if (axri)
+			*axri = bf_get(lpfc_mbx_rd_conf_xri_count, rd_config) -
+					phba->sli4_hba.max_cfg_param.xri_used;
+		if (mvpi)
+			*mvpi = bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config);
+		if (avpi)
+			*avpi = bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) -
+					phba->sli4_hba.max_cfg_param.vpi_used;
+	} else {
+		if (mrpi)
+			*mrpi = pmb->un.varRdConfig.max_rpi;
+		if (arpi)
+			*arpi = pmb->un.varRdConfig.avail_rpi;
+		if (mxri)
+			*mxri = pmb->un.varRdConfig.max_xri;
+		if (axri)
+			*axri = pmb->un.varRdConfig.avail_xri;
+		if (mvpi)
+			*mvpi = pmb->un.varRdConfig.max_vpi;
+		if (avpi)
+			*avpi = pmb->un.varRdConfig.avail_vpi;
+	}
 
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 	return 1;
@@ -2844,15 +2865,39 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 /*
 # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
 #		support this feature
-#       0  = MSI disabled
+#       0  = MSI disabled (default)
 #       1  = MSI enabled
-#       2  = MSI-X enabled (default)
-# Value range is [0,2]. Default value is 2.
+#       2  = MSI-X enabled
+# Value range is [0,2]. Default value is 0.
 */
-LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
+LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
+# lpfc_fcp_imax: Set the maximum number of fast-path FCP interrupts per second
+#
+# Value range is [636,651042]. Default value is 10000.
+*/
+LPFC_ATTR_R(fcp_imax, LPFC_FP_DEF_IMAX, LPFC_MIM_IMAX, LPFC_DMULT_CONST,
+	    "Set the maximum number of fast-path FCP interrupts per second");
+
+/*
+# lpfc_fcp_wq_count: Set the number of fast-path FCP work queues
+#
+# Value range is [1,31]. Default value is 4.
+*/
+LPFC_ATTR_R(fcp_wq_count, LPFC_FP_WQN_DEF, LPFC_FP_WQN_MIN, LPFC_FP_WQN_MAX,
+	    "Set the number of fast-path FCP work queues, if possible");
+
+/*
+# lpfc_fcp_eq_count: Set the number of fast-path FCP event queues
+#
+# Value range is [1,7]. Default value is 1.
+*/
+LPFC_ATTR_R(fcp_eq_count, LPFC_FP_EQN_DEF, LPFC_FP_EQN_MIN, LPFC_FP_EQN_MAX,
+	    "Set the number of fast-path FCP event queues, if possible");
+
+/*
 # lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
 #       0  = HBA resets disabled
 #       1  = HBA resets enabled (default)
@@ -2969,6 +3014,9 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_poll,
 	&dev_attr_lpfc_poll_tmo,
 	&dev_attr_lpfc_use_msi,
+	&dev_attr_lpfc_fcp_imax,
+	&dev_attr_lpfc_fcp_wq_count,
+	&dev_attr_lpfc_fcp_eq_count,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
@@ -4105,6 +4153,9 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
 	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
+	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
+	lpfc_fcp_wq_count_init(phba, lpfc_fcp_wq_count);
+	lpfc_fcp_eq_count_init(phba, lpfc_fcp_eq_count);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
 	lpfc_enable_bg_init(phba, lpfc_enable_bg);
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-22 13:16:24.000000000 -0400
@@ -35,17 +35,19 @@ int lpfc_config_msi(struct lpfc_hba *, L
 int lpfc_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *, int);
 void lpfc_read_config(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_reg_login(struct lpfc_hba *, uint16_t, uint32_t, uint8_t *,
-		   LPFC_MBOXQ_t *, uint32_t);
+int lpfc_reg_rpi(struct lpfc_hba *, uint16_t, uint32_t, uint8_t *,
+		 LPFC_MBOXQ_t *, uint32_t);
 void lpfc_unreg_login(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_unreg_did(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
-void lpfc_reg_vpi(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
+void lpfc_reg_vpi(struct lpfc_vport *, LPFC_MBOXQ_t *);
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
+void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
 
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rpis(struct lpfc_vport *, int);
 int lpfc_linkdown(struct lpfc_hba *);
+void lpfc_linkdown_port(struct lpfc_vport *);
 void lpfc_port_link_failure(struct lpfc_vport *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
@@ -54,6 +56,7 @@ void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_nodelist *lpfc_enable_node(struct lpfc_vport *,
@@ -149,15 +152,19 @@ int lpfc_online(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
 void lpfc_offline_prep(struct lpfc_hba *);
 void lpfc_offline(struct lpfc_hba *);
+void lpfc_reset_hba(struct lpfc_hba *);
 
 int lpfc_sli_setup(struct lpfc_hba *);
 int lpfc_sli_queue_setup(struct lpfc_hba *);
 
 void lpfc_handle_eratt(struct lpfc_hba *);
 void lpfc_handle_latt(struct lpfc_hba *);
-irqreturn_t lpfc_intr_handler(int, void *);
-irqreturn_t lpfc_sp_intr_handler(int, void *);
-irqreturn_t lpfc_fp_intr_handler(int, void *);
+irqreturn_t lpfc_sli_intr_handler(int, void *);
+irqreturn_t lpfc_sli_sp_intr_handler(int, void *);
+irqreturn_t lpfc_sli_fp_intr_handler(int, void *);
+irqreturn_t lpfc_sli4_intr_handler(int, void *);
+irqreturn_t lpfc_sli4_sp_intr_handler(int, void *);
+irqreturn_t lpfc_sli4_fp_intr_handler(int, void *);
 
 void lpfc_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_ring(struct lpfc_hba *, int, LPFC_MBOXQ_t *);
@@ -165,16 +172,32 @@ void lpfc_config_port(struct lpfc_hba *,
 void lpfc_kill_board(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbox_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_hba *);
+void __lpfc_mbox_cmpl_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbox_cmpl_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_mbox_cmd_check(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_mbox_dev_check(struct lpfc_hba *);
 int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
+void lpfc_init_vfi(struct lpfcMboxq *, struct lpfc_vport *);
+void lpfc_reg_vfi(struct lpfcMboxq *, struct lpfc_vport *, dma_addr_t);
+void lpfc_init_vpi(struct lpfcMboxq *, uint16_t);
+void lpfc_unreg_vfi(struct lpfcMboxq *, uint16_t);
+void lpfc_reg_fcfi(struct lpfc_hba *, struct lpfcMboxq *);
+void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
+void lpfc_resume_rpi(struct lpfcMboxq *, struct lpfc_nodelist *);
 
 void lpfc_config_hbq(struct lpfc_hba *, uint32_t, struct lpfc_hbq_init *,
 	uint32_t , LPFC_MBOXQ_t *);
 struct hbq_dmabuf *lpfc_els_hbq_alloc(struct lpfc_hba *);
 void lpfc_els_hbq_free(struct lpfc_hba *, struct hbq_dmabuf *);
+struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
+void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
+void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
+			uint16_t);
+void lpfc_unregister_unused_fcf(struct lpfc_hba *);
 
-int lpfc_mem_alloc(struct lpfc_hba *);
+int lpfc_mem_alloc(struct lpfc_hba *, int align);
 void lpfc_mem_free(struct lpfc_hba *);
+void lpfc_mem_free_all(struct lpfc_hba *);
 void lpfc_stop_vport_timers(struct lpfc_vport *);
 
 void lpfc_poll_timeout(unsigned long ptr);
@@ -198,12 +221,13 @@ int lpfc_sli_host_down(struct lpfc_vport
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 int lpfc_sli_handle_mb_event(struct lpfc_hba *);
-int lpfc_sli_flush_mbox_queue(struct lpfc_hba *);
+void lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *);
 int lpfc_sli_check_eratt(struct lpfc_hba *);
-int lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
+void lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
+int lpfc_sli4_handle_received_buffer(struct lpfc_hba *);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_sli_issue_iocb(struct lpfc_hba *, struct lpfc_sli_ring *,
+int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
@@ -237,7 +261,7 @@ struct lpfc_nodelist *lpfc_findnode_wwpn
 
 int lpfc_sli_issue_mbox_wait(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
-int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, struct lpfc_sli_ring *,
+int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, uint32_t,
 			     struct lpfc_iocbq *, struct lpfc_iocbq *,
 			     uint32_t);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
@@ -254,6 +278,12 @@ void lpfc_in_buf_free(struct lpfc_hba *,
 const char* lpfc_info(struct Scsi_Host *);
 int lpfc_scan_finished(struct Scsi_Host *, unsigned long);
 
+int lpfc_init_api_table_setup(struct lpfc_hba *, uint8_t);
+int lpfc_sli_api_table_setup(struct lpfc_hba *, uint8_t);
+int lpfc_scsi_api_table_setup(struct lpfc_hba *, uint8_t);
+int lpfc_mbox_api_table_setup(struct lpfc_hba *, uint8_t);
+int lpfc_api_table_setup(struct lpfc_hba *, uint8_t);
+
 void lpfc_get_cfgparam(struct lpfc_hba *);
 void lpfc_get_vport_cfgparam(struct lpfc_vport *);
 int lpfc_alloc_sysfs_attr(struct lpfc_vport *);
@@ -314,8 +344,15 @@ lpfc_send_els_failure_event(struct lpfc_
 				struct lpfc_iocbq *);
 struct lpfc_fast_path_event *lpfc_alloc_fast_evt(struct lpfc_hba *);
 void lpfc_free_fast_evt(struct lpfc_hba *, struct lpfc_fast_path_event *);
+void lpfc_create_static_vport(struct lpfc_hba *);
+void lpfc_stop_hba_timers(struct lpfc_hba *);
+void lpfc_stop_port(struct lpfc_hba *);
+void lpfc_parse_fcoe_conf(struct lpfc_hba *, uint8_t *, uint32_t);
+int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
+void lpfc_start_fdiscs(struct lpfc_hba *phba);
 
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
 #define HBA_EVENT_LINK_UP                2
 #define HBA_EVENT_LINK_DOWN              3
+
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2009-05-22 13:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2009-05-22 13:16:24.000000000 -0400
@@ -32,8 +32,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2009-05-22 13:14:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2009-05-22 13:16:24.000000000 -0400
@@ -33,8 +33,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:16:24.000000000 -0400
@@ -28,8 +28,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -220,7 +222,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		icmd->un.elsreq64.myID = vport->fc_myDID;
 
 		/* For ELS_REQUEST64_CR, use the VPI by default */
-		icmd->ulpContext = vport->vpi;
+		icmd->ulpContext = vport->vpi + phba->vpi_base;
 		icmd->ulpCt_h = 0;
 		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
 		if (elscmd == ELS_CMD_ECHO)
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-05-22 13:14:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2009-05-22 13:16:24.000000000 -0400
@@ -105,9 +105,11 @@ struct lpfc_dma_pool {
 };
 
 struct hbq_dmabuf {
+	struct lpfc_dmabuf hbuf;
 	struct lpfc_dmabuf dbuf;
 	uint32_t size;
 	uint32_t tag;
+	struct lpfc_rcqe rcqe;
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -141,7 +143,10 @@ typedef struct lpfc_vpd {
 	} rev;
 	struct {
 #ifdef __BIG_ENDIAN_BITFIELD
-		uint32_t rsvd2  :24;  /* Reserved                             */
+		uint32_t rsvd3  :19;  /* Reserved                             */
+		uint32_t cdss	: 1;  /* Configure Data Security SLI          */
+		uint32_t rsvd2	: 3;  /* Reserved                             */
+		uint32_t cbg	: 1;  /* Configure BlockGuard                 */
 		uint32_t cmv	: 1;  /* Configure Max VPIs                   */
 		uint32_t ccrp   : 1;  /* Config Command Ring Polling          */
 		uint32_t csah   : 1;  /* Configure Synchronous Abort Handling */
@@ -159,7 +164,10 @@ typedef struct lpfc_vpd {
 		uint32_t csah   : 1;  /* Configure Synchronous Abort Handling */
 		uint32_t ccrp   : 1;  /* Config Command Ring Polling          */
 		uint32_t cmv	: 1;  /* Configure Max VPIs                   */
-		uint32_t rsvd2  :24;  /* Reserved                             */
+		uint32_t cbg	: 1;  /* Configure BlockGuard                 */
+		uint32_t rsvd2	: 3;  /* Reserved                             */
+		uint32_t cdss	: 1;  /* Configure Data Security SLI          */
+		uint32_t rsvd3  :19;  /* Reserved                             */
 #endif
 	} sli3Feat;
 } lpfc_vpd_t;
@@ -280,6 +288,9 @@ struct lpfc_vport {
 	enum discovery_state port_state;
 
 	uint16_t vpi;
+	uint16_t vfi;
+	uint8_t vfi_state;
+#define LPFC_VFI_REGISTERED	0x1
 
 	uint32_t fc_flag;	/* FC flags */
 /* Several of these flags are HBA centric and should be moved to
@@ -392,6 +403,9 @@ struct lpfc_vport {
 #endif
 	uint8_t stat_data_enabled;
 	uint8_t stat_data_blocked;
+	struct list_head rcv_buffer_list;
+	uint32_t vport_flag;
+#define STATIC_VPORT	1
 };
 
 struct hbq_s {
@@ -494,6 +508,7 @@ struct lpfc_hba {
 #define LPFC_SLI3_CRP_ENABLED		0x08
 #define LPFC_SLI3_INB_ENABLED		0x10
 #define LPFC_SLI3_BG_ENABLED		0x20
+#define LPFC_SLI3_DSS_ENABLED		0x40
 	uint32_t iocb_cmd_size;
 	uint32_t iocb_rsp_size;
 
@@ -507,8 +522,13 @@ struct lpfc_hba {
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
-
-#define DEFER_ERATT		0x4 /* Deferred error attention in progress */
+#define DEFER_ERATT		0x2 /* Deferred error attention in progress */
+#define HBA_FCOE_SUPPORT	0x4 /* HBA function supports FCOE */
+#define HBA_RECEIVE_BUFFER	0x8 /* Rcv buffer posted to worker thread */
+#define HBA_POST_RECEIVE_BUFFER 0x10 /* Rcv buffers need to be posted */
+#define FCP_XRI_ABORT_EVENT	0x20
+#define ELS_XRI_ABORT_EVENT	0x40
+#define ASYNC_EVENT		0x80
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -567,6 +587,9 @@ struct lpfc_hba {
 	uint32_t cfg_poll;
 	uint32_t cfg_poll_tmo;
 	uint32_t cfg_use_msi;
+	uint32_t cfg_fcp_imax;
+	uint32_t cfg_fcp_wq_count;
+	uint32_t cfg_fcp_eq_count;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_prot_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
@@ -576,6 +599,8 @@ struct lpfc_hba {
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
 	uint32_t cfg_enable_bg;
+	uint32_t cfg_enable_fip;
+	uint32_t cfg_log_verbose;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
@@ -659,7 +684,8 @@ struct lpfc_hba {
 	/* pci_mem_pools */
 	struct pci_pool *lpfc_scsi_dma_buf_pool;
 	struct pci_pool *lpfc_mbuf_pool;
-	struct pci_pool *lpfc_hbq_pool;
+	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
+	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
 	mempool_t *mbox_mem_pool;
@@ -675,6 +701,14 @@ struct lpfc_hba {
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
 	uint16_t max_vpi;		/* Maximum virtual nports */
 #define LPFC_MAX_VPI 0xFFFF		/* Max number of VPI supported */
+	uint16_t max_vports;            /*
+					 * For IOV HBAs max_vpi can change
+					 * after a reset. max_vports is max
+					 * number of vports present. This can
+					 * be greater than max_vpi.
+					 */
+	uint16_t vpi_base;
+	uint16_t vfi_base;
 	unsigned long *vpi_bmask;	/* vpi allocation table */
 
 	/* Data structure used by fabric iocb scheduler */
@@ -733,6 +767,11 @@ struct lpfc_hba {
 /* Maximum number of events that can be outstanding at any time*/
 #define LPFC_MAX_EVT_COUNT 512
 	atomic_t fast_event_count;
+	struct lpfc_fcf fcf;
+	uint8_t fc_map[3];
+	uint8_t valid_vlan;
+	uint16_t vlan_id;
+	struct list_head fcf_conn_rec_list;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:14:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:16:24.000000000 -0400
@@ -29,10 +29,12 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
@@ -491,6 +493,10 @@ lpfc_work_done(struct lpfc_hba *phba)
 	phba->work_ha = 0;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* First, try to post the next mailbox command to SLI4 device */
+	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+		lpfc_sli4_post_async_mbox(phba);
+
 	if (ha_copy & HA_ERATT)
 		/* Handle the error attention event */
 		lpfc_handle_eratt(phba);
@@ -501,9 +507,27 @@ lpfc_work_done(struct lpfc_hba *phba)
 	if (ha_copy & HA_LATT)
 		lpfc_handle_latt(phba);
 
+	/* Process SLI4 events */
+	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+		if (phba->hba_flag & FCP_XRI_ABORT_EVENT)
+			lpfc_sli4_fcp_xri_abort_event_proc(phba);
+		if (phba->hba_flag & ELS_XRI_ABORT_EVENT)
+			lpfc_sli4_els_xri_abort_event_proc(phba);
+		if (phba->hba_flag & ASYNC_EVENT)
+			lpfc_sli4_async_event_proc(phba);
+		if (phba->hba_flag & HBA_POST_RECEIVE_BUFFER) {
+			spin_lock_irq(&phba->hbalock);
+			phba->hba_flag &= ~HBA_POST_RECEIVE_BUFFER;
+			spin_unlock_irq(&phba->hbalock);
+			lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
+		}
+		if (phba->hba_flag & HBA_RECEIVE_BUFFER)
+			lpfc_sli4_handle_received_buffer(phba);
+	}
+
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi; i++) {
+		for (i = 0; i <= phba->max_vports; i++) {
 			/*
 			 * We could have no vports in array if unloading, so if
 			 * this happens then just use the pport
@@ -2556,7 +2580,8 @@ lpfc_issue_clear_la(struct lpfc_hba *phb
 	 * clear_la then don't send it.
 	 */
 	if ((phba->link_state >= LPFC_CLEAR_LA) ||
-	    (vport->port_type != LPFC_PHYSICAL_PORT))
+	    (vport->port_type != LPFC_PHYSICAL_PORT) ||
+		(phba->sli_rev == LPFC_SLI_REV4))
 		return;
 
 			/* Link up discovery */
@@ -2585,7 +2610,7 @@ lpfc_issue_reg_vpi(struct lpfc_hba *phba
 
 	regvpimbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (regvpimbox) {
-		lpfc_reg_vpi(phba, vport->vpi, vport->fc_myDID, regvpimbox);
+		lpfc_reg_vpi(vport, regvpimbox);
 		regvpimbox->mbox_cmpl = lpfc_mbx_cmpl_reg_vpi;
 		regvpimbox->vport = vport;
 		if (lpfc_sli_issue_mbox(phba, regvpimbox, MBX_NOWAIT)
@@ -2645,7 +2670,8 @@ lpfc_disc_start(struct lpfc_vport *vport
 	 */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 	    !(vport->fc_flag & FC_PT2PT) &&
-	    !(vport->fc_flag & FC_RSCN_MODE)) {
+	    !(vport->fc_flag & FC_RSCN_MODE) &&
+	    (phba->sli_rev < LPFC_SLI_REV4)) {
 		lpfc_issue_reg_vpi(phba, vport);
 		return;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2009-05-22 13:16:24.000000000 -0400
@@ -471,6 +471,35 @@ struct serv_parm {	/* Structure is in Bi
 };
 
 /*
+ * Virtual Fabric Tagging Header
+ */
+struct fc_vft_header {
+	 uint32_t word0;
+#define fc_vft_hdr_r_ctl_SHIFT		24
+#define fc_vft_hdr_r_ctl_MASK		0xFF
+#define fc_vft_hdr_r_ctl_WORD		word0
+#define fc_vft_hdr_ver_SHIFT		22
+#define fc_vft_hdr_ver_MASK		0x3
+#define fc_vft_hdr_ver_WORD		word0
+#define fc_vft_hdr_type_SHIFT		18
+#define fc_vft_hdr_type_MASK		0xF
+#define fc_vft_hdr_type_WORD		word0
+#define fc_vft_hdr_e_SHIFT		16
+#define fc_vft_hdr_e_MASK		0x1
+#define fc_vft_hdr_e_WORD		word0
+#define fc_vft_hdr_priority_SHIFT	13
+#define fc_vft_hdr_priority_MASK	0x7
+#define fc_vft_hdr_priority_WORD	word0
+#define fc_vft_hdr_vf_id_SHIFT		1
+#define fc_vft_hdr_vf_id_MASK		0xFFF
+#define fc_vft_hdr_vf_id_WORD		word0
+	uint32_t word1;
+#define fc_vft_hdr_hopct_SHIFT		24
+#define fc_vft_hdr_hopct_MASK		0xFF
+#define fc_vft_hdr_hopct_WORD		word1
+};
+
+/*
  *  Extended Link Service LS_COMMAND codes (Payload Word 0)
  */
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -1152,6 +1181,9 @@ typedef struct {
 #define PCI_DEVICE_ID_HORNET        0xfe05
 #define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
+#define PCI_VENDOR_ID_SERVERENGINE  0x19a2
+#define PCI_DEVICE_ID_TIGERSHARK    0x0704
+#define PCI_DEVICE_ID_TIGERSHARK_S  0x0705
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
@@ -1342,15 +1374,21 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_READ_LA64       0x95
 #define MBX_REG_VPI	    0x96
 #define MBX_UNREG_VPI	    0x97
-#define MBX_REG_VNPID	    0x96
-#define MBX_UNREG_VNPID	    0x97
 
 #define MBX_WRITE_WWN       0x98
 #define MBX_SET_DEBUG       0x99
 #define MBX_LOAD_EXP_ROM    0x9C
-
-#define MBX_MAX_CMDS        0x9D
+#define MBX_SLI4_CONFIG	    0x9B
+#define MBX_SLI4_REQ_FTRS   0x9D
+#define MBX_MAX_CMDS        0x9E
+#define MBX_RESUME_RPI      0x9E
 #define MBX_SLI2_CMD_MASK   0x80
+#define MBX_REG_VFI         0x9F
+#define MBX_REG_FCFI        0xA0
+#define MBX_UNREG_VFI       0xA1
+#define MBX_UNREG_FCFI	    0xA2
+#define MBX_INIT_VFI        0xA3
+#define MBX_INIT_VPI        0xA4
 
 /* IOCB Commands */
 
@@ -1440,6 +1478,16 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_IOCB_LOGENTRY_CN		0x94
 #define CMD_IOCB_LOGENTRY_ASYNC_CN	0x96
 
+/* Unhandled Data Security SLI Commands */
+#define DSSCMD_IWRITE64_CR 		0xD8
+#define DSSCMD_IWRITE64_CX		0xD9
+#define DSSCMD_IREAD64_CR		0xDA
+#define DSSCMD_IREAD64_CX		0xDB
+#define DSSCMD_INVALIDATE_DEK		0xDC
+#define DSSCMD_SET_KEK			0xDD
+#define DSSCMD_GET_KEK_ID		0xDE
+#define DSSCMD_GEN_XFER			0xDF
+
 #define CMD_MAX_IOCB_CMD        0xE6
 #define CMD_IOCB_MASK           0xff
 
@@ -1466,6 +1514,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBXERR_BAD_RCV_LENGTH       14
 #define MBXERR_DMA_ERROR            15
 #define MBXERR_ERROR                16
+#define MBXERR_LINK_DOWN            0x33
 #define MBX_NOT_FINISHED           255
 
 #define MBX_BUSY                   0xffffff /* Attempted cmd to busy Mailbox */
@@ -1504,32 +1553,6 @@ struct ulp_bde {
 #endif
 };
 
-struct ulp_bde64 {	/* SLI-2 */
-	union ULP_BDE_TUS {
-		uint32_t w;
-		struct {
-#ifdef __BIG_ENDIAN_BITFIELD
-			uint32_t bdeFlags:8;	/* BDE Flags 0 IS A SUPPORTED
-						   VALUE !! */
-			uint32_t bdeSize:24;	/* Size of buffer (in bytes) */
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-			uint32_t bdeSize:24;	/* Size of buffer (in bytes) */
-			uint32_t bdeFlags:8;	/* BDE Flags 0 IS A SUPPORTED
-						   VALUE !! */
-#endif
-#define BUFF_TYPE_BDE_64    0x00	/* BDE (Host_resident) */
-#define BUFF_TYPE_BDE_IMMED 0x01	/* Immediate Data BDE */
-#define BUFF_TYPE_BDE_64P   0x02	/* BDE (Port-resident) */
-#define BUFF_TYPE_BDE_64I   0x08	/* Input BDE (Host-resident) */
-#define BUFF_TYPE_BDE_64IP  0x0A	/* Input BDE (Port-resident) */
-#define BUFF_TYPE_BLP_64    0x40	/* BLP (Host-resident) */
-#define BUFF_TYPE_BLP_64P   0x42	/* BLP (Port-resident) */
-		} f;
-	} tus;
-	uint32_t addrLow;
-	uint32_t addrHigh;
-};
-
 typedef struct ULP_BDL {	/* SLI-2 */
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t bdeFlags:8;	/* BDL Flags */
@@ -2287,7 +2310,7 @@ typedef struct {
 	uint32_t rsvd3;
 	uint32_t rsvd4;
 	uint32_t rsvd5;
-	uint16_t rsvd6;
+	uint16_t vfi;
 	uint16_t vpi;
 #else	/*  __LITTLE_ENDIAN */
 	uint32_t rsvd1;
@@ -2297,7 +2320,7 @@ typedef struct {
 	uint32_t rsvd4;
 	uint32_t rsvd5;
 	uint16_t vpi;
-	uint16_t rsvd6;
+	uint16_t vfi;
 #endif
 } REG_VPI_VAR;
 
@@ -2457,7 +2480,7 @@ typedef struct {
 	uint32_t entry_index:16;
 #endif
 
-	uint32_t rsvd1;
+	uint32_t sli4_length;
 	uint32_t word_cnt;
 	uint32_t resp_offset;
 } DUMP_VAR;
@@ -2470,9 +2493,32 @@ typedef struct {
 #define  DMP_RSP_OFFSET          0x14   /* word 5 contains first word of rsp */
 #define  DMP_RSP_SIZE            0x6C   /* maximum of 27 words of rsp data */
 
+#define  DMP_REGION_VPORT	 0x16   /* VPort info region */
+#define  DMP_VPORT_REGION_SIZE	 0x200
+#define  DMP_MBOX_OFFSET_WORD	 0x5
+
+#define  DMP_REGION_FCOEPARAM	 0x17   /* fcoe param region */
+#define  DMP_FCOEPARAM_RGN_SIZE	 0x400
+
 #define  WAKE_UP_PARMS_REGION_ID    4
 #define  WAKE_UP_PARMS_WORD_SIZE   15
 
+struct vport_rec {
+	uint8_t wwpn[8];
+	uint8_t wwnn[8];
+};
+
+#define VPORT_INFO_SIG 0x32324752
+#define VPORT_INFO_REV_MASK 0xff
+#define VPORT_INFO_REV 0x1
+#define MAX_STATIC_VPORT_COUNT 16
+struct static_vport_info {
+	uint32_t 		signature;
+	uint32_t		rev;
+	struct vport_rec 	vport_list[MAX_STATIC_VPORT_COUNT];
+	uint32_t		resvd[66];
+};
+
 /* Option rom version structure */
 struct prog_id {
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -2697,7 +2743,9 @@ typedef struct {
 #endif
 
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd1     : 23;  /* Reserved                             */
+	uint32_t rsvd1     : 19;  /* Reserved                             */
+	uint32_t cdss      :  1;  /* Configure Data Security SLI          */
+	uint32_t rsvd2     :  3;  /* Reserved                             */
 	uint32_t cbg       :  1;  /* Configure BlockGuard                 */
 	uint32_t cmv       :  1;  /* Configure Max VPIs                   */
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
@@ -2717,10 +2765,14 @@ typedef struct {
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
 	uint32_t cmv	   :  1;  /* Configure Max VPIs                   */
 	uint32_t cbg       :  1;  /* Configure BlockGuard                 */
-	uint32_t rsvd1     : 23;  /* Reserved                             */
+	uint32_t rsvd2     :  3;  /* Reserved                             */
+	uint32_t cdss      :  1;  /* Configure Data Security SLI          */
+	uint32_t rsvd1     : 19;  /* Reserved                             */
 #endif
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd2     : 23;  /* Reserved                             */
+	uint32_t rsvd3     : 19;  /* Reserved                             */
+	uint32_t gdss      :  1;  /* Configure Data Security SLI          */
+	uint32_t rsvd4     :  3;  /* Reserved                             */
 	uint32_t gbg       :  1;  /* Grant BlockGuard                     */
 	uint32_t gmv	   :  1;  /* Grant Max VPIs                       */
 	uint32_t gcrp	   :  1;  /* Grant Command Ring Polling           */
@@ -2740,7 +2792,9 @@ typedef struct {
 	uint32_t gcrp	   :  1;  /* Grant Command Ring Polling           */
 	uint32_t gmv	   :  1;  /* Grant Max VPIs                       */
 	uint32_t gbg       :  1;  /* Grant BlockGuard                     */
-	uint32_t rsvd2     : 23;  /* Reserved                             */
+	uint32_t rsvd4     :  3;  /* Reserved                             */
+	uint32_t gdss      :  1;  /* Configure Data Security SLI          */
+	uint32_t rsvd3     : 19;  /* Reserved                             */
 #endif
 
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -2753,20 +2807,20 @@ typedef struct {
 
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t max_hbq   : 16;  /* Max HBQs Host expect to configure    */
-	uint32_t rsvd3     : 16;  /* Max HBQs Host expect to configure    */
+	uint32_t rsvd5     : 16;  /* Max HBQs Host expect to configure    */
 #else	/*  __LITTLE_ENDIAN */
-	uint32_t rsvd3     : 16;  /* Max HBQs Host expect to configure    */
+	uint32_t rsvd5     : 16;  /* Max HBQs Host expect to configure    */
 	uint32_t max_hbq   : 16;  /* Max HBQs Host expect to configure    */
 #endif
 
-	uint32_t rsvd4;           /* Reserved                             */
+	uint32_t rsvd6;           /* Reserved                             */
 
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd5      : 16;  /* Reserved                             */
+	uint32_t rsvd7      : 16;  /* Reserved                             */
 	uint32_t max_vpi    : 16;  /* Max number of virt N-Ports           */
 #else	/*  __LITTLE_ENDIAN */
 	uint32_t max_vpi    : 16;  /* Max number of virt N-Ports           */
-	uint32_t rsvd5      : 16;  /* Reserved                             */
+	uint32_t rsvd7      : 16;  /* Reserved                             */
 #endif
 
 } CONFIG_PORT_VAR;
@@ -3666,3 +3720,5 @@ lpfc_error_lost_link(IOCB_t *iocbp)
 #define MENLO_TIMEOUT 30
 #define SETVAR_MLOMNT 0x103107
 #define SETVAR_MLORST 0x103007
+
+#define BPL_ALIGN_SZ 8 /* 8 byte alignment for bpl and mbufs */
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-22 13:16:24.000000000 -0400
@@ -28,8 +28,10 @@
 
 #include <scsi/scsi.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2009-05-22 13:16:24.000000000 -0400
@@ -28,8 +28,10 @@
 
 #include <scsi/scsi.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -45,7 +47,7 @@
  * @phba: HBA to allocate pools for
  *
  * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
- * lpfc_mbuf_pool, lpfc_hbq_pool.  Creates and allocates kmalloc-backed mempools
+ * lpfc_mbuf_pool, lpfc_hrb_pool.  Creates and allocates kmalloc-backed mempools
  * for LPFC_MBOXQ_t and lpfc_nodelist.  Also allocates the VPI bitmask.
  *
  * Notes: Not interrupt-safe.  Must be called with no locks held.  If any
@@ -56,19 +58,30 @@
  *   -ENOMEM on failure (if any memory allocations fail)
  **/
 int
-lpfc_mem_alloc(struct lpfc_hba * phba)
+lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 {
 	struct lpfc_dma_pool *pool = &phba->lpfc_mbuf_safety_pool;
 	int longs;
 	int i;
 
-	phba->lpfc_scsi_dma_buf_pool = pci_pool_create("lpfc_scsi_dma_buf_pool",
-				phba->pcidev, phba->cfg_sg_dma_buf_size, 8, 0);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		phba->lpfc_scsi_dma_buf_pool =
+			pci_pool_create("lpfc_scsi_dma_buf_pool",
+				phba->pcidev,
+				phba->cfg_sg_dma_buf_size,
+				phba->cfg_sg_dma_buf_size,
+				0);
+	else
+		phba->lpfc_scsi_dma_buf_pool =
+			pci_pool_create("lpfc_scsi_dma_buf_pool",
+				phba->pcidev, phba->cfg_sg_dma_buf_size,
+				align, 0);
 	if (!phba->lpfc_scsi_dma_buf_pool)
 		goto fail;
 
 	phba->lpfc_mbuf_pool = pci_pool_create("lpfc_mbuf_pool", phba->pcidev,
-							LPFC_BPL_SIZE, 8,0);
+							LPFC_BPL_SIZE,
+							align, 0);
 	if (!phba->lpfc_mbuf_pool)
 		goto fail_free_dma_buf_pool;
 
@@ -97,23 +110,31 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 						sizeof(struct lpfc_nodelist));
 	if (!phba->nlp_mem_pool)
 		goto fail_free_mbox_pool;
-
-	phba->lpfc_hbq_pool = pci_pool_create("lpfc_hbq_pool",phba->pcidev,
-					      LPFC_BPL_SIZE, 8, 0);
-	if (!phba->lpfc_hbq_pool)
+	phba->lpfc_hrb_pool = pci_pool_create("lpfc_hrb_pool",
+					      phba->pcidev,
+					      LPFC_HDR_BUF_SIZE, align, 0);
+	if (!phba->lpfc_hrb_pool)
 		goto fail_free_nlp_mem_pool;
+	phba->lpfc_drb_pool = pci_pool_create("lpfc_drb_pool",
+					      phba->pcidev,
+					      LPFC_DATA_BUF_SIZE, align, 0);
+	if (!phba->lpfc_drb_pool)
+		goto fail_free_hbq_pool;
 
 	/* vpi zero is reserved for the physical port so add 1 to max */
 	longs = ((phba->max_vpi + 1) + BITS_PER_LONG - 1) / BITS_PER_LONG;
 	phba->vpi_bmask = kzalloc(longs * sizeof(unsigned long), GFP_KERNEL);
 	if (!phba->vpi_bmask)
-		goto fail_free_hbq_pool;
+		goto fail_free_dbq_pool;
 
 	return 0;
 
+ fail_free_dbq_pool:
+	pci_pool_destroy(phba->lpfc_drb_pool);
+	phba->lpfc_drb_pool = NULL;
  fail_free_hbq_pool:
-	lpfc_sli_hbqbuf_free_all(phba);
-	pci_pool_destroy(phba->lpfc_hbq_pool);
+	pci_pool_destroy(phba->lpfc_hrb_pool);
+	phba->lpfc_hrb_pool = NULL;
  fail_free_nlp_mem_pool:
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
@@ -136,27 +157,73 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mem_free - Frees all PCI and memory allocated by lpfc_mem_alloc
+ * lpfc_mem_free - Frees memory allocated by lpfc_mem_alloc
  * @phba: HBA to free memory for
  *
- * Description: Frees PCI pools lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool,
- * lpfc_hbq_pool.  Frees kmalloc-backed mempools for LPFC_MBOXQ_t and
- * lpfc_nodelist.  Also frees the VPI bitmask
+ * Description: Free the memory allocated by lpfc_mem_alloc routine. This
+ * routine is a the counterpart of lpfc_mem_alloc.
  *
  * Returns: None
  **/
 void
-lpfc_mem_free(struct lpfc_hba * phba)
+lpfc_mem_free(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_dma_pool *pool = &phba->lpfc_mbuf_safety_pool;
-	LPFC_MBOXQ_t *mbox, *next_mbox;
-	struct lpfc_dmabuf   *mp;
 	int i;
+	struct lpfc_dma_pool *pool = &phba->lpfc_mbuf_safety_pool;
 
+	/* Free VPI bitmask memory */
 	kfree(phba->vpi_bmask);
+
+	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
+	pci_pool_destroy(phba->lpfc_drb_pool);
+	phba->lpfc_drb_pool = NULL;
+	pci_pool_destroy(phba->lpfc_hrb_pool);
+	phba->lpfc_hrb_pool = NULL;
+
+	/* Free NLP memory pool */
+	mempool_destroy(phba->nlp_mem_pool);
+	phba->nlp_mem_pool = NULL;
+
+	/* Free mbox memory pool */
+	mempool_destroy(phba->mbox_mem_pool);
+	phba->mbox_mem_pool = NULL;
+
+	/* Free MBUF memory pool */
+	for (i = 0; i < pool->current_count; i++)
+		pci_pool_free(phba->lpfc_mbuf_pool, pool->elements[i].virt,
+			      pool->elements[i].phys);
+	kfree(pool->elements);
+
+	pci_pool_destroy(phba->lpfc_mbuf_pool);
+	phba->lpfc_mbuf_pool = NULL;
 
+	/* Free DMA buffer memory pool */
+	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
+	phba->lpfc_scsi_dma_buf_pool = NULL;
+
+	return;
+}
+
+/**
+ * lpfc_mem_free_all - Frees all PCI and driver memory
+ * @phba: HBA to free memory for
+ *
+ * Description: Free memory from PCI and driver memory pools and also those
+ * used : lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool, lpfc_hrb_pool. Frees
+ * kmalloc-backed mempools for LPFC_MBOXQ_t and lpfc_nodelist. Also frees
+ * the VPI bitmask.
+ *
+ * Returns: None
+ **/
+void
+lpfc_mem_free_all(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	LPFC_MBOXQ_t *mbox, *next_mbox;
+	struct lpfc_dmabuf   *mp;
+
+	/* Free memory used in mailbox queue back to mailbox memory pool */
 	list_for_each_entry_safe(mbox, next_mbox, &psli->mboxq, list) {
 		mp = (struct lpfc_dmabuf *) (mbox->context1);
 		if (mp) {
@@ -166,6 +233,7 @@ lpfc_mem_free(struct lpfc_hba * phba)
 		list_del(&mbox->list);
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
+	/* Free memory used in mailbox cmpl list back to mailbox memory pool */
 	list_for_each_entry_safe(mbox, next_mbox, &psli->mboxq_cmpl, list) {
 		mp = (struct lpfc_dmabuf *) (mbox->context1);
 		if (mp) {
@@ -175,8 +243,10 @@ lpfc_mem_free(struct lpfc_hba * phba)
 		list_del(&mbox->list);
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
-
+	/* Free the active mailbox command back to the mailbox memory pool */
+	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
 	if (psli->mbox_active) {
 		mbox = psli->mbox_active;
 		mp = (struct lpfc_dmabuf *) (mbox->context1);
@@ -188,27 +258,14 @@ lpfc_mem_free(struct lpfc_hba * phba)
 		psli->mbox_active = NULL;
 	}
 
-	for (i = 0; i < pool->current_count; i++)
-		pci_pool_free(phba->lpfc_mbuf_pool, pool->elements[i].virt,
-						 pool->elements[i].phys);
-	kfree(pool->elements);
-
-	pci_pool_destroy(phba->lpfc_hbq_pool);
-	mempool_destroy(phba->nlp_mem_pool);
-	mempool_destroy(phba->mbox_mem_pool);
-
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
-	pci_pool_destroy(phba->lpfc_mbuf_pool);
-
-	phba->lpfc_hbq_pool = NULL;
-	phba->nlp_mem_pool = NULL;
-	phba->mbox_mem_pool = NULL;
-	phba->lpfc_scsi_dma_buf_pool = NULL;
-	phba->lpfc_mbuf_pool = NULL;
+	/* Free and destroy all the allocated memory pools */
+	lpfc_mem_free(phba);
 
 	/* Free the iocb lookup array */
 	kfree(psli->iocbq_lookup);
 	psli->iocbq_lookup = NULL;
+
+	return;
 }
 
 /**
@@ -305,7 +362,7 @@ lpfc_mbuf_free(struct lpfc_hba * phba, v
  * lpfc_els_hbq_alloc - Allocate an HBQ buffer
  * @phba: HBA to allocate HBQ buffer for
  *
- * Description: Allocates a DMA-mapped HBQ buffer from the lpfc_hbq_pool PCI
+ * Description: Allocates a DMA-mapped HBQ buffer from the lpfc_hrb_pool PCI
  * pool along a non-DMA-mapped container for it.
  *
  * Notes: Not interrupt-safe.  Must be called with no locks held.
@@ -323,7 +380,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba
 	if (!hbqbp)
 		return NULL;
 
-	hbqbp->dbuf.virt = pci_pool_alloc(phba->lpfc_hbq_pool, GFP_KERNEL,
+	hbqbp->dbuf.virt = pci_pool_alloc(phba->lpfc_hrb_pool, GFP_KERNEL,
 					  &hbqbp->dbuf.phys);
 	if (!hbqbp->dbuf.virt) {
 		kfree(hbqbp);
@@ -334,7 +391,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_mem_hbq_free - Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
+ * lpfc_els_hbq_free - Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
  * @phba: HBA buffer was allocated for
  * @hbqbp: HBQ container returned by lpfc_els_hbq_alloc
  *
@@ -348,12 +405,73 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba
 void
 lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 {
-	pci_pool_free(phba->lpfc_hbq_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
+	pci_pool_free(phba->lpfc_hrb_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
 	kfree(hbqbp);
 	return;
 }
 
 /**
+ * lpfc_sli4_rb_alloc - Allocate an SLI4 Receive buffer
+ * @phba: HBA to allocate a receive buffer for
+ *
+ * Description: Allocates a DMA-mapped receive buffer from the lpfc_hrb_pool PCI
+ * pool along a non-DMA-mapped container for it.
+ *
+ * Notes: Not interrupt-safe.  Must be called with no locks held.
+ *
+ * Returns:
+ *   pointer to HBQ on success
+ *   NULL on failure
+ **/
+struct hbq_dmabuf *
+lpfc_sli4_rb_alloc(struct lpfc_hba *phba)
+{
+	struct hbq_dmabuf *dma_buf;
+
+	dma_buf = kmalloc(sizeof(struct hbq_dmabuf), GFP_KERNEL);
+	if (!dma_buf)
+		return NULL;
+
+	dma_buf->hbuf.virt = pci_pool_alloc(phba->lpfc_hrb_pool, GFP_KERNEL,
+					    &dma_buf->hbuf.phys);
+	if (!dma_buf->hbuf.virt) {
+		kfree(dma_buf);
+		return NULL;
+	}
+	dma_buf->dbuf.virt = pci_pool_alloc(phba->lpfc_drb_pool, GFP_KERNEL,
+					    &dma_buf->dbuf.phys);
+	if (!dma_buf->dbuf.virt) {
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		return NULL;
+	}
+	dma_buf->size = LPFC_BPL_SIZE;
+	return dma_buf;
+}
+
+/**
+ * lpfc_sli4_rb_free - Frees a receive buffer
+ * @phba: HBA buffer was allocated for
+ * @dmab: DMA Buffer container returned by lpfc_sli4_hbq_alloc
+ *
+ * Description: Frees both the container and the DMA-mapped buffers returned by
+ * lpfc_sli4_rb_alloc.
+ *
+ * Notes: Can be called with or without locks held.
+ *
+ * Returns: None
+ **/
+void
+lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
+{
+	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
+	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
+	kfree(dmab);
+	return;
+}
+
+/**
  * lpfc_in_buf_free - Free a DMA buffer
  * @phba: HBA buffer is associated with
  * @mp: Buffer to free
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-22 13:16:24.000000000 -0400
@@ -28,8 +28,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 13:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 13:16:24.000000000 -0400
@@ -31,8 +31,10 @@
 #include <scsi/scsi_transport_fc.h>
 
 #include "lpfc_version.h"
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -57,6 +59,8 @@ static char *dif_op_str[] = {
 	"SCSI_PROT_READ_CONVERT",
 	"SCSI_PROT_WRITE_CONVERT"
 };
+static void
+lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
 
 static void
 lpfc_debug_save_data(struct scsi_cmnd *cmnd)
@@ -565,6 +569,8 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *
 		}
 		iocb->ulpClass = CLASS3;
 		psb->status = IOSTAT_SUCCESS;
+		/* Put it back into the SCSI buffer list */
+		lpfc_release_scsi_buf_s4(phba, psb);
 
 	}
 
@@ -572,6 +578,271 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *
 }
 
 /**
+ * lpfc_sli4_fcp_xri_aborted - Fast-path process of fcp xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the fcp xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * FCP aborted xri.
+ **/
+void
+lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
+			  struct sli4_wcqe_xri_aborted *axri)
+{
+	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	struct lpfc_scsi_buf *psb, *next_psb;
+	unsigned long iflag = 0;
+
+	spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock, iflag);
+	list_for_each_entry_safe(psb, next_psb,
+		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
+		if (psb->cur_iocbq.sli4_xritag == xri) {
+			list_del(&psb->list);
+			psb->status = IOSTAT_SUCCESS;
+			spin_unlock_irqrestore(
+				&phba->sli4_hba.abts_scsi_buf_list_lock,
+				iflag);
+			lpfc_release_scsi_buf_s4(phba, psb);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&phba->sli4_hba.abts_scsi_buf_list_lock,
+				iflag);
+}
+
+/**
+ * lpfc_sli4_repost_scsi_sgl_list - Repsot the Scsi buffers sgl pages as block
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine walks the list of scsi buffers that have been allocated and
+ * repost them to the HBA by using SGL block post. This is needed after a
+ * pci_function_reset/warm_start or start. The lpfc_hba_down_post_s4 routine
+ * is responsible for moving all scsi buffers on the lpfc_abts_scsi_sgl_list
+ * to the lpfc_scsi_buf_list. If the repost fails, reject all scsi buffers.
+ *
+ * Returns: 0 = success, non-zero failure.
+ **/
+int
+lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *phba)
+{
+	struct lpfc_scsi_buf *psb;
+	int index, status, bcnt = 0, rcnt = 0, rc = 0;
+	LIST_HEAD(sblist);
+
+	for (index = 0; index < phba->sli4_hba.scsi_xri_cnt; index++) {
+		psb = phba->sli4_hba.lpfc_scsi_psb_array[index];
+		if (psb) {
+			/* Remove from SCSI buffer list */
+			list_del(&psb->list);
+			/* Add it to a local SCSI buffer list */
+			list_add_tail(&psb->list, &sblist);
+			if (++rcnt == LPFC_NEMBED_MBOX_SGL_CNT) {
+				bcnt = rcnt;
+				rcnt = 0;
+			}
+		} else
+			/* A hole present in the XRI array, need to skip */
+			bcnt = rcnt;
+
+		if (index == phba->sli4_hba.scsi_xri_cnt - 1)
+			/* End of XRI array for SCSI buffer, complete */
+			bcnt = rcnt;
+
+		/* Continue until collect up to a nembed page worth of sgls */
+		if (bcnt == 0)
+			continue;
+		/* Now, post the SCSI buffer list sgls as a block */
+		status = lpfc_sli4_post_scsi_sgl_block(phba, &sblist, bcnt);
+		/* Reset SCSI buffer count for next round of posting */
+		bcnt = 0;
+		while (!list_empty(&sblist)) {
+			list_remove_head(&sblist, psb, struct lpfc_scsi_buf,
+					 list);
+			if (status) {
+				/* Put this back on the abort scsi list */
+				psb->status = IOSTAT_LOCAL_REJECT;
+				psb->result = IOERR_ABORT_REQUESTED;
+				rc++;
+			} else
+				psb->status = IOSTAT_SUCCESS;
+			/* Put it back into the SCSI buffer list */
+			lpfc_release_scsi_buf_s4(phba, psb);
+		}
+	}
+	return rc;
+}
+
+/**
+ * lpfc_new_scsi_buf_s4 - Scsi buffer allocator for HBA with SLI4 IF spec
+ * @vport: The virtual port for which this call being executed.
+ * @num_to_allocate: The requested number of buffers to allocate.
+ *
+ * This routine allocates a scsi buffer for device with SLI-4 interface spec,
+ * the scsi buffer contains all the necessary information needed to initiate
+ * a SCSI I/O.
+ *
+ * Return codes:
+ *   int - number of scsi buffers that were allocated.
+ *   0 = failure, less than num_to_alloc is a partial failure.
+ **/
+static int
+lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_scsi_buf *psb;
+	struct sli4_sge *sgl;
+	IOCB_t *iocb;
+	dma_addr_t pdma_phys_fcp_cmd;
+	dma_addr_t pdma_phys_fcp_rsp;
+	dma_addr_t pdma_phys_bpl, pdma_phys_bpl1;
+	uint16_t iotag, last_xritag = NO_XRI;
+	int status = 0, index;
+	int bcnt;
+	int non_sequential_xri = 0;
+	int rc = 0;
+	LIST_HEAD(sblist);
+
+	for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
+		psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+		if (!psb)
+			break;
+
+		/*
+		 * Get memory from the pci pool to map the virt space to pci bus
+		 * space for an I/O.  The DMA buffer includes space for the
+		 * struct fcp_cmnd, struct fcp_rsp and the number of bde's
+		 * necessary to support the sg_tablesize.
+		 */
+		psb->data = pci_pool_alloc(phba->lpfc_scsi_dma_buf_pool,
+						GFP_KERNEL, &psb->dma_handle);
+		if (!psb->data) {
+			kfree(psb);
+			break;
+		}
+
+		/* Initialize virtual ptrs to dma_buf region. */
+		memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
+
+		/* Allocate iotag for psb->cur_iocbq. */
+		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
+		if (iotag == 0) {
+			kfree(psb);
+			break;
+		}
+
+		psb->cur_iocbq.sli4_xritag = lpfc_sli4_next_xritag(phba);
+		if (psb->cur_iocbq.sli4_xritag == NO_XRI) {
+			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+			      psb->data, psb->dma_handle);
+			kfree(psb);
+			break;
+		}
+		if (last_xritag != NO_XRI
+			&& psb->cur_iocbq.sli4_xritag != (last_xritag+1)) {
+			non_sequential_xri = 1;
+		} else
+			list_add_tail(&psb->list, &sblist);
+		last_xritag = psb->cur_iocbq.sli4_xritag;
+
+		index = phba->sli4_hba.scsi_xri_cnt++;
+		psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
+
+		psb->fcp_bpl = psb->data;
+		psb->fcp_cmnd = (psb->data + phba->cfg_sg_dma_buf_size)
+			- (sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
+		psb->fcp_rsp = (struct fcp_rsp *)((uint8_t *)psb->fcp_cmnd +
+					sizeof(struct fcp_cmnd));
+
+		/* Initialize local short-hand pointers. */
+		sgl = (struct sli4_sge *)psb->fcp_bpl;
+		pdma_phys_bpl = psb->dma_handle;
+		pdma_phys_fcp_cmd =
+			(psb->dma_handle + phba->cfg_sg_dma_buf_size)
+			 - (sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
+		pdma_phys_fcp_rsp = pdma_phys_fcp_cmd + sizeof(struct fcp_cmnd);
+
+		/*
+		 * The first two bdes are the FCP_CMD and FCP_RSP.  The balance
+		 * are sg list bdes.  Initialize the first two and leave the
+		 * rest for queuecommand.
+		 */
+		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_cmd));
+		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_cmd));
+		bf_set(lpfc_sli4_sge_len, sgl, sizeof(struct fcp_cmnd));
+		bf_set(lpfc_sli4_sge_last, sgl, 0);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->word3 = cpu_to_le32(sgl->word3);
+		sgl++;
+
+		/* Setup the physical region for the FCP RSP */
+		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_rsp));
+		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_rsp));
+		bf_set(lpfc_sli4_sge_len, sgl, sizeof(struct fcp_rsp));
+		bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->word3 = cpu_to_le32(sgl->word3);
+
+		/*
+		 * Since the IOCB for the FCP I/O is built into this
+		 * lpfc_scsi_buf, initialize it with all known data now.
+		 */
+		iocb = &psb->cur_iocbq.iocb;
+		iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
+		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_64;
+		/* setting the BLP size to 2 * sizeof BDE may not be correct.
+		 * We are setting the bpl to point to out sgl. An sgl's
+		 * entries are 16 bytes, a bpl entries are 12 bytes.
+		 */
+		iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
+		iocb->un.fcpi64.bdl.addrLow = putPaddrLow(pdma_phys_fcp_cmd);
+		iocb->un.fcpi64.bdl.addrHigh = putPaddrHigh(pdma_phys_fcp_cmd);
+		iocb->ulpBdeCount = 1;
+		iocb->ulpLe = 1;
+		iocb->ulpClass = CLASS3;
+		if (phba->cfg_sg_dma_buf_size > SGL_PAGE_SIZE)
+			pdma_phys_bpl1 = pdma_phys_bpl + SGL_PAGE_SIZE;
+		else
+			pdma_phys_bpl1 = 0;
+		psb->dma_phys_bpl = pdma_phys_bpl;
+		phba->sli4_hba.lpfc_scsi_psb_array[index] = psb;
+		if (non_sequential_xri) {
+			status = lpfc_sli4_post_sgl(phba, pdma_phys_bpl,
+						pdma_phys_bpl1,
+						psb->cur_iocbq.sli4_xritag);
+			if (status) {
+				/* Put this back on the abort scsi list */
+				psb->status = IOSTAT_LOCAL_REJECT;
+				psb->result = IOERR_ABORT_REQUESTED;
+				rc++;
+			} else
+				psb->status = IOSTAT_SUCCESS;
+			/* Put it back into the SCSI buffer list */
+			lpfc_release_scsi_buf_s4(phba, psb);
+			break;
+		}
+	}
+	if (bcnt) {
+		status = lpfc_sli4_post_scsi_sgl_block(phba, &sblist, bcnt);
+		/* Reset SCSI buffer count for next round of posting */
+		while (!list_empty(&sblist)) {
+			list_remove_head(&sblist, psb, struct lpfc_scsi_buf,
+				 list);
+			if (status) {
+				/* Put this back on the abort scsi list */
+				psb->status = IOSTAT_LOCAL_REJECT;
+				psb->result = IOERR_ABORT_REQUESTED;
+				rc++;
+			} else
+				psb->status = IOSTAT_SUCCESS;
+			/* Put it back into the SCSI buffer list */
+			lpfc_release_scsi_buf_s4(phba, psb);
+		}
+	}
+
+	return bcnt + non_sequential_xri - rc;
+}
+
+/**
  * lpfc_new_scsi_buf - Wrapper funciton for scsi buffer allocator
  * @vport: The virtual port for which this call being executed.
  * @num_to_allocate: The requested number of buffers to allocate.
@@ -638,6 +909,39 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba
 }
 
 /**
+ * lpfc_release_scsi_buf_s4: Return a scsi buffer back to hba scsi buf list.
+ * @phba: The Hba for which this call is being executed.
+ * @psb: The scsi buffer which is being released.
+ *
+ * This routine releases @psb scsi buffer by adding it to tail of @phba
+ * lpfc_scsi_buf_list list. For SLI4 XRI's are tied to the scsi buffer
+ * and cannot be reused for at least RA_TOV amount of time if it was
+ * aborted.
+ **/
+static void
+lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+{
+	unsigned long iflag = 0;
+
+	if (psb->status == IOSTAT_LOCAL_REJECT
+		&& psb->result == IOERR_ABORT_REQUESTED) {
+		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
+					iflag);
+		psb->pCmd = NULL;
+		list_add_tail(&psb->list,
+			&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_scsi_buf_list_lock,
+					iflag);
+	} else {
+
+		spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
+		psb->pCmd = NULL;
+		list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list);
+		spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	}
+}
+
+/**
  * lpfc_release_scsi_buf: Return a scsi buffer back to hba scsi buf list.
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is being released.
@@ -1455,6 +1759,115 @@ out:
 }
 
 /**
+ * lpfc_scsi_prep_dma_buf_s4 - DMA mapping for scsi buffer to SLI4 IF spec
+ * @phba: The Hba for which this call is being executed.
+ * @lpfc_cmd: The scsi buffer which is going to be mapped.
+ *
+ * This routine does the pci dma mapping for scatter-gather list of scsi cmnd
+ * field of @lpfc_cmd for device with SLI-4 interface spec.
+ *
+ * Return codes:
+ * 	1 - Error
+ * 	0 - Success
+ **/
+static int
+lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct scatterlist *sgel = NULL;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	dma_addr_t physaddr;
+	uint32_t num_bde = 0;
+	uint32_t dma_len;
+	uint32_t dma_offset = 0;
+	int nseg;
+
+	/*
+	 * There are three possibilities here - use scatter-gather segment, use
+	 * the single mapping, or neither.  Start the lpfc command prep by
+	 * bumping the bpl beyond the fcp_cmnd and fcp_rsp regions to the first
+	 * data bde entry.
+	 */
+	if (scsi_sg_count(scsi_cmnd)) {
+		/*
+		 * The driver stores the segment count returned from pci_map_sg
+		 * because this a count of dma-mappings used to map the use_sg
+		 * pages.  They are not guaranteed to be the same for those
+		 * architectures that implement an IOMMU.
+		 */
+
+		nseg = scsi_dma_map(scsi_cmnd);
+		if (unlikely(!nseg))
+			return 1;
+		sgl += 1;
+		/* clear the last flag in the fcp_rsp map entry */
+		sgl->word2 = le32_to_cpu(sgl->word2);
+		bf_set(lpfc_sli4_sge_last, sgl, 0);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl += 1;
+
+		lpfc_cmd->seg_cnt = nseg;
+		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
+			printk(KERN_ERR "%s: Too many sg segments from "
+			       "dma_map_sg.  Config %d, seg_cnt %d\n",
+			       __func__, phba->cfg_sg_seg_cnt,
+			       lpfc_cmd->seg_cnt);
+			scsi_dma_unmap(scsi_cmnd);
+			return 1;
+		}
+
+		/*
+		 * The driver established a maximum scatter-gather segment count
+		 * during probe that limits the number of sg elements in any
+		 * single scsi command.  Just run through the seg_cnt and format
+		 * the sge's.
+		 * When using SLI-3 the driver will try to fit all the BDEs into
+		 * the IOCB. If it can't then the BDEs get added to a BPL as it
+		 * does for SLI-2 mode.
+		 */
+		scsi_for_each_sg(scsi_cmnd, sgel, nseg, num_bde) {
+			physaddr = sg_dma_address(sgel);
+			dma_len = sg_dma_len(sgel);
+			bf_set(lpfc_sli4_sge_len, sgl, sg_dma_len(sgel));
+			sgl->addr_lo = cpu_to_le32(putPaddrLow(physaddr));
+			sgl->addr_hi = cpu_to_le32(putPaddrHigh(physaddr));
+			if ((num_bde + 1) == nseg)
+				bf_set(lpfc_sli4_sge_last, sgl, 1);
+			else
+				bf_set(lpfc_sli4_sge_last, sgl, 0);
+			bf_set(lpfc_sli4_sge_offset, sgl, dma_offset);
+			sgl->word2 = cpu_to_le32(sgl->word2);
+			sgl->word3 = cpu_to_le32(sgl->word3);
+			dma_offset += dma_len;
+			sgl++;
+		}
+	} else {
+		sgl += 1;
+		/* clear the last flag in the fcp_rsp map entry */
+		sgl->word2 = le32_to_cpu(sgl->word2);
+		bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+	}
+
+	/*
+	 * Finish initializing those IOCB fields that are dependent on the
+	 * scsi_cmnd request_buffer.  Note that for SLI-2 the bdeSize is
+	 * explicitly reinitialized.
+	 * all iocb memory resources are reused.
+	 */
+	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
+
+	/*
+	 * Due to difference in data length between DIF/non-DIF paths,
+	 * we need to set word 4 of IOCB here
+	 */
+	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
+	return 0;
+}
+
+/**
  * lpfc_scsi_prep_dma_buf - Wrapper function for DMA mapping of scsi buffer
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
@@ -1590,6 +2003,22 @@ lpfc_scsi_unprep_dma_buf_s3(struct lpfc_
 }
 
 /**
+ * lpfc_scsi_unprep_dma_buf_s4 - Un-map DMA mapping of SG-list for SLI4 dev
+ * @phba: The Hba for which this call is being executed.
+ * @psb: The scsi buffer which is going to be un-mapped.
+ *
+ * This routine does DMA un-mapping of scatter gather list of scsi command
+ * field of @lpfc_cmd for device with SLI-4 interface spec. If we have to
+ * remove the sgl for this scsi buffer then we will do it here. For now
+ * we should be able to just call the sli3 unprep routine.
+ **/
+static void
+lpfc_scsi_unprep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+{
+	lpfc_scsi_unprep_dma_buf_s3(phba, psb);
+}
+
+/**
  * lpfc_scsi_unprep_dma_buf - Wrapper function for unmap DMA mapping of SG-list
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is going to be un-mapped.
@@ -2129,6 +2558,29 @@ lpfc_scsi_prep_cmnd_s3(struct lpfc_vport
 }
 
 /**
+ * lpfc_scsi_prep_cmnd_s4 - Convert scsi cmnd to FCP infor unit for SLI4 dev
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: The scsi command which needs to send.
+ * @pnode: Pointer to lpfc_nodelist.
+ *
+ * This routine initializes fcp_cmnd and iocb data structure from scsi command
+ * to transfer for device with SLI4 interface spec.
+ **/
+static void
+lpfc_scsi_prep_cmnd_s4(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+		       struct lpfc_nodelist *pnode)
+{
+	/*
+	 * The prep cmnd routines do not touch the sgl or its
+	 * entries. We may not have to do anything different.
+	 * I will leave this function in place until we can
+	 * run some IO through the driver and determine if changes
+	 * are needed.
+	 */
+	return lpfc_scsi_prep_cmnd_s3(vport, lpfc_cmd, pnode);
+}
+
+/**
  * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
@@ -2209,6 +2661,37 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct l
 }
 
 /**
+ * lpfc_scsi_prep_task_mgmt_cmnd_s4 - Convert SLI4 scsi TM cmd to FCP info unit
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
+ * @lun: Logical unit number.
+ * @task_mgmt_cmd: SCSI task management command.
+ *
+ * This routine creates FCP information unit corresponding to @task_mgmt_cmd
+ * for device with SLI-4 interface spec.
+ *
+ * Return codes:
+ * 	0 - Error
+ * 	1 - Success
+ **/
+static int
+lpfc_scsi_prep_task_mgmt_cmd_s4(struct lpfc_vport *vport,
+				struct lpfc_scsi_buf *lpfc_cmd,
+				unsigned int lun,
+				uint8_t task_mgmt_cmd)
+{
+	/*
+	 * The prep cmnd routines do not touch the sgl or its
+	 * entries. We may not have to do anything different.
+	 * I will leave this function in place until we can
+	 * run some IO through the driver and determine if changes
+	 * are needed.
+	 */
+	return lpfc_scsi_prep_task_mgmt_cmd_s3(vport, lpfc_cmd, lun,
+						task_mgmt_cmd);
+}
+
+/**
  * lpfc_scsi_prep_task_mgmt_cmnd - Wrapper func convert scsi TM cmd to FCP info
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
@@ -2257,6 +2740,15 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 					lpfc_scsi_prep_task_mgmt_cmd_s3;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
 		break;
+	case LPFC_PCI_DEV_OC:
+		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s4;
+		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
+		phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd_s4;
+		phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf_s4;
+		phba->lpfc_scsi_prep_task_mgmt_cmd =
+					lpfc_scsi_prep_task_mgmt_cmd_s4;
+		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1418 Invalid HBA PCI-device group: 0x%x\n",


