From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/4] bfa: fixed checkpatch errors for include files
Date: Fri, 25 Sep 2009 12:32:05 -0700
Message-ID: <200909251932.n8PJW5IX012598@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:51224 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZIYTcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 15:32:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch fixes checkpatch errors/warnings in include files.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 aen/bfa_aen.h        |    2 +-
 bfa.h                |   10 +++++-----
 bfa_svc.h            |    8 ++++----
 bfi/bfi.h            |   12 ++++++------
 bfi/bfi_ioc.h        |    2 +-
 bfi/bfi_lps.h        |    4 ++--
 bfi/bfi_rport.h      |    8 ++++----
 cs/bfa_checksum.h    |    6 +++---
 cs/bfa_sm.h          |    6 +++---
 cs/bfa_trc.h         |    2 +-
 fcs/bfa_fcs_fabric.h |    2 +-
 fcs/bfa_fcs_lport.h  |   17 +++++++++--------
 protocol/ct.h        |   10 +++++-----
 protocol/fc.h        |   22 +++++++++++-----------
 14 files changed, 56 insertions(+), 55 deletions(-)

diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen.h patch/drivers/scsi/bfa/include/aen/bfa_aen.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen.h	2009-09-24 23:41:16.000000000 -0700
@@ -54,7 +54,7 @@ bfa_aen_get_max_cfg_entry(void)
 static inline s32
 bfa_aen_get_meminfo(void)
 {
-	return (sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry());
+	return sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry();
 }
 
 static inline s32
diff -urpN orig/drivers/scsi/bfa/include/bfa.h patch/drivers/scsi/bfa/include/bfa.h
--- orig/drivers/scsi/bfa/include/bfa.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfa.h	2009-09-24 23:41:16.000000000 -0700
@@ -76,11 +76,11 @@ struct bfa_meminfo_s {
 	struct bfa_mem_elem_s meminfo[BFA_MEM_TYPE_MAX];
 };
 #define bfa_meminfo_kva(_m)	\
-	(_m)->meminfo[BFA_MEM_TYPE_KVA - 1].kva_curp
+	((_m)->meminfo[BFA_MEM_TYPE_KVA - 1].kva_curp)
 #define bfa_meminfo_dma_virt(_m)	\
-	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].kva_curp
+	((_m)->meminfo[BFA_MEM_TYPE_DMA - 1].kva_curp)
 #define bfa_meminfo_dma_phys(_m)	\
-	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp
+	((_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp)
 
 /**
  * Generic Scatter Gather Element used by driver
@@ -100,7 +100,7 @@ struct bfa_sge_s {
 /*
  * bfa stats interfaces
  */
-#define bfa_stats(_mod, _stats)	(_mod)->stats._stats ++
+#define bfa_stats(_mod, _stats)	((_mod)->stats._stats++)
 
 #define bfa_ioc_get_stats(__bfa, __ioc_stats)	\
 	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
@@ -136,7 +136,7 @@ void bfa_isr_enable(struct bfa_s *bfa);
 void bfa_isr_disable(struct bfa_s *bfa);
 void bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
 			u32 *num_vecs, u32 *max_vec_bit);
-#define bfa_msix(__bfa, __vec) (__bfa)->msix.handler[__vec](__bfa, __vec)
+#define bfa_msix(__bfa, __vec) ((__bfa)->msix.handler[__vec](__bfa, __vec))
 
 void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
 void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
diff -urpN orig/drivers/scsi/bfa/include/bfa_svc.h patch/drivers/scsi/bfa/include/bfa_svc.h
--- orig/drivers/scsi/bfa/include/bfa_svc.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfa_svc.h	2009-09-24 23:41:16.000000000 -0700
@@ -34,10 +34,10 @@ struct bfa_fcxp_s;
  */
 struct bfa_rport_info_s {
 	u16        max_frmsz;	/*  max rcv pdu size               */
-	u32        pid : 24,	/*  remote port ID                 */
-			lp_tag : 8;
-	u32        local_pid : 24,	/*  local port ID		    */
-			cisc : 8;	/*  CIRO supported		    */
+	u32        pid:24,		/*  remote port ID                 */
+			lp_tag:8;
+	u32        local_pid:24,	/*  local port ID		    */
+			cisc:8;		/*  CIRO supported		    */
 	u8         fc_class;	/*  supported FC classes. enum fc_cos */
 	u8         vf_en;		/*  virtual fabric enable          */
 	u16        vf_id;		/*  virtual fabric ID              */
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi.h patch/drivers/scsi/bfa/include/bfi/bfi.h
--- orig/drivers/scsi/bfa/include/bfi/bfi.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfi/bfi.h	2009-09-24 23:41:16.000000000 -0700
@@ -93,13 +93,13 @@ union bfi_addr_u {
  */
 struct bfi_sge_s {
 #ifdef __BIGENDIAN
-	u32        flags	: 2,
-			rsvd	: 2,
-			sg_len	: 28;
+	u32        flags:2,
+			rsvd:2,
+			sg_len:28;
 #else
-	u32        sg_len	: 28,
-			rsvd	: 2,
-			flags	: 2;
+	u32        sg_len:28,
+			rsvd:2,
+			flags:2;
 #endif
 	union bfi_addr_u sga;
 };
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h	2009-09-24 23:41:16.000000000 -0700
@@ -142,7 +142,7 @@ enum {
 	BFI_ADAPTER_UNSUPP    = 0x400000,	/*  unknown adapter type  */
 };
 
-#define BFI_ADAPTER_GETP(__prop,__adap_prop)          		\
+#define BFI_ADAPTER_GETP(__prop, __adap_prop)          		\
     (((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>         \
      BFI_ADAPTER_ ## __prop ## _SH)
 #define BFI_ADAPTER_SETP(__prop, __val)         		\
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lps.h patch/drivers/scsi/bfa/include/bfi/bfi_lps.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lps.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lps.h	2009-09-24 23:41:16.000000000 -0700
@@ -55,8 +55,8 @@ struct bfi_lps_login_rsp_s {
 	u16	bb_credit;
 	u8		f_port;
 	u8		npiv_en;
-	u32	lp_pid : 24;
-	u32	auth_req : 8;
+	u32	lp_pid:24;
+	u32	auth_req:8;
 	mac_t		lp_mac;
 	mac_t		fcf_mac;
 	u8		ext_status;
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_rport.h patch/drivers/scsi/bfa/include/bfi/bfi_rport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_rport.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/bfi/bfi_rport.h	2009-09-24 23:41:16.000000000 -0700
@@ -38,10 +38,10 @@ struct bfi_rport_create_req_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		*/
 	u16        bfa_handle;	/*  host rport handle		*/
 	u16        max_frmsz;	/*  max rcv pdu size		*/
-	u32        pid       : 24,	/*  remote port ID		*/
-			lp_tag    : 8;	/*  local port tag		*/
-	u32        local_pid : 24,	/*  local port ID		*/
-			cisc      : 8;
+	u32        pid:24,		/*  remote port ID		*/
+			lp_tag:8;	/*  local port tag		*/
+	u32        local_pid:24,	/*  local port ID		*/
+			cisc:8;
 	u8         fc_class;	/*  supported FC classes	*/
 	u8         vf_en;		/*  virtual fabric enable	*/
 	u16        vf_id;		/*  virtual fabric ID		*/
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_checksum.h patch/drivers/scsi/bfa/include/cs/bfa_checksum.h
--- orig/drivers/scsi/bfa/include/cs/bfa_checksum.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/cs/bfa_checksum.h	2009-09-24 23:41:16.000000000 -0700
@@ -31,7 +31,7 @@ bfa_checksum_u32(u32 *buf, int sz)
 	for (i = 0; i < m; i++)
 		sum ^= buf[i];
 
-	return (sum);
+	return sum;
 }
 
 static inline u16
@@ -43,7 +43,7 @@ bfa_checksum_u16(u16 *buf, int sz)
 	for (i = 0; i < m; i++)
 		sum ^= buf[i];
 
-	return (sum);
+	return sum;
 }
 
 static inline u8
@@ -55,6 +55,6 @@ bfa_checksum_u8(u8 *buf, int sz)
 	for (i = 0; i < sz; i++)
 		sum ^= buf[i];
 
-	return (sum);
+	return sum;
 }
 #endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_sm.h patch/drivers/scsi/bfa/include/cs/bfa_sm.h
--- orig/drivers/scsi/bfa/include/cs/bfa_sm.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/cs/bfa_sm.h	2009-09-24 23:41:16.000000000 -0700
@@ -24,8 +24,8 @@
 
 typedef void (*bfa_sm_t)(void *sm, int event);
 
-#define bfa_sm_set_state(_sm, _state)	(_sm)->sm = (bfa_sm_t)(_state)
-#define bfa_sm_send_event(_sm, _event)	(_sm)->sm((_sm), (_event))
+#define bfa_sm_set_state(_sm, _state)	((_sm)->sm = (bfa_sm_t)(_state))
+#define bfa_sm_send_event(_sm, _event)	((_sm)->sm((_sm), (_event)))
 #define bfa_sm_get_state(_sm)		((_sm)->sm)
 #define bfa_sm_cmp_state(_sm, _state)	((_sm)->sm == (bfa_sm_t)(_state))
 
@@ -62,7 +62,7 @@ typedef void (*bfa_fsm_t)(void *fsm, int
 } while (0)
 
 #define bfa_fsm_send_event(_fsm, _event)	\
-	(_fsm)->fsm((_fsm), (_event))
+	((_fsm)->fsm((_fsm), (_event)))
 #define bfa_fsm_cmp_state(_fsm, _state)		\
 	((_fsm)->fsm == (bfa_fsm_t)(_state))
 
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_trc.h patch/drivers/scsi/bfa/include/cs/bfa_trc.h
--- orig/drivers/scsi/bfa/include/cs/bfa_trc.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/cs/bfa_trc.h	2009-09-24 23:41:16.000000000 -0700
@@ -24,7 +24,7 @@
 #endif
 
 #ifndef BFA_TRC_TS
-#define BFA_TRC_TS(_trcm)	((_trcm)->ticks ++)
+#define BFA_TRC_TS(_trcm)	((_trcm)->ticks++)
 #endif
 
 struct bfa_trc_s {
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h	2009-09-24 23:41:16.000000000 -0700
@@ -75,7 +75,7 @@ struct bfa_fcs_fabric_s {
 							    */
 };
 
-#define bfa_fcs_fabric_npiv_capable(__f)    (__f)->is_npiv
+#define bfa_fcs_fabric_npiv_capable(__f)    ((__f)->is_npiv)
 #define bfa_fcs_fabric_is_switched(__f)			\
 	((__f)->fab_type == BFA_FCS_FABRIC_SWITCHED)
 
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	2009-09-24 23:41:16.000000000 -0700
@@ -125,12 +125,12 @@ union bfa_fcs_port_topo_u {
 struct bfa_fcs_port_s {
 	struct list_head         qe;	/*  used by port/vport */
 	bfa_sm_t               sm;	/*  state machine */
-	struct bfa_fcs_fabric_s *fabric;	/*  parent fabric */
-	struct bfa_port_cfg_s  port_cfg;	/*  port configuration */
+	struct bfa_fcs_fabric_s *fabric;/*  parent fabric */
+	struct bfa_port_cfg_s  port_cfg;/*  port configuration */
 	struct bfa_timer_s link_timer;	/*  timer for link offline */
-	u32        pid : 24;	/*  FC address */
-	u8         lp_tag;		/*  lport tag */
-	u16        num_rports;	/*  Num of r-ports */
+	u32 pid:24;	/*  FC address */
+	u8  lp_tag;	/*  lport tag */
+	u16 num_rports;	/*  Num of r-ports */
 	struct list_head rport_q;	/*  queue of discovered r-ports */
 	struct bfa_fcs_s *fcs;	/*  FCS instance */
 	union bfa_fcs_port_topo_u port_topo;	/*  fabric/loop/n2n details */
@@ -188,13 +188,14 @@ bfa_fcs_port_get_drvport(struct bfa_fcs_
 }
 
 
-#define bfa_fcs_port_get_opertype(_lport)	(_lport)->fabric->oper_type
+#define bfa_fcs_port_get_opertype(_lport)	((_lport)->fabric->oper_type)
 
 
-#define bfa_fcs_port_get_fabric_name(_lport)	(_lport)->fabric->fabric_name
+#define bfa_fcs_port_get_fabric_name(_lport)	((_lport)->fabric->fabric_name)
 
 
-#define bfa_fcs_port_get_fabric_ipaddr(_lport)	(_lport)->fabric->fabric_ip_addr
+#define bfa_fcs_port_get_fabric_ipaddr(_lport) \
+		((_lport)->fabric->fabric_ip_addr)
 
 /**
  * bfa fcs port public functions
diff -urpN orig/drivers/scsi/bfa/include/protocol/ct.h patch/drivers/scsi/bfa/include/protocol/ct.h
--- orig/drivers/scsi/bfa/include/protocol/ct.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/protocol/ct.h	2009-09-24 23:41:16.000000000 -0700
@@ -193,11 +193,11 @@ struct fcgs_rftid_req_s {
 #define FC_GS_FCP_FC4_FEATURE_TARGET	 0x01
 
 struct fcgs_rffid_req_s{
-    u32    rsvd          :8;
-    u32    dap        	  :24;		/* port identifier	*/
-    u32    rsvd1         :16;
-    u32    fc4ftr_bits   :8;		/* fc4 feature bits	*/
-    u32    fc4_type      :8;		/* corresponding FC4 Type */
+    u32    rsvd:8;
+    u32    dap:24;		/* port identifier	*/
+    u32    rsvd1:16;
+    u32    fc4ftr_bits:8;	/* fc4 feature bits	*/
+    u32    fc4_type:8;	/* corresponding FC4 Type */
 };
 
 /**
diff -urpN orig/drivers/scsi/bfa/include/protocol/fc.h patch/drivers/scsi/bfa/include/protocol/fc.h
--- orig/drivers/scsi/bfa/include/protocol/fc.h	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/include/protocol/fc.h	2009-09-24 23:41:16.000000000 -0700
@@ -486,14 +486,14 @@ struct fc_rsi_s {
  * see FC-PH-X table 113 & 115 for explanation also FCP table 8
  */
 struct fc_prli_params_s{
-	u32        reserved: 16;
+	u32        reserved:16;
 #ifdef __BIGENDIAN
-	u32        reserved1: 5;
-	u32        rec_support : 1;
-	u32        task_retry_id : 1;
-	u32        retry : 1;
+	u32        reserved1:5;
+	u32        rec_support:1;
+	u32        task_retry_id:1;
+	u32        retry:1;
 
-	u32        confirm : 1;
+	u32        confirm:1;
 	u32        doverlay:1;
 	u32        initiator:1;
 	u32        target:1;
@@ -502,10 +502,10 @@ struct fc_prli_params_s{
 	u32        rxrdisab:1;
 	u32        wxrdisab:1;
 #else
-	u32        retry : 1;
-	u32        task_retry_id : 1;
-	u32        rec_support : 1;
-	u32        reserved1: 5;
+	u32        retry:1;
+	u32        task_retry_id:1;
+	u32        rec_support:1;
+	u32        reserved1:5;
 
 	u32        wxrdisab:1;
 	u32        rxrdisab:1;
@@ -514,7 +514,7 @@ struct fc_prli_params_s{
 	u32        target:1;
 	u32        initiator:1;
 	u32        doverlay:1;
-	u32        confirm : 1;
+	u32        confirm:1;
 #endif
 };
 
