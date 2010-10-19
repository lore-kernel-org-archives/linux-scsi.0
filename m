From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/6] bfa: fix comments for header files
Date: Mon, 18 Oct 2010 17:15:55 -0700
Message-ID: <1287447355-31414-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43885 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab0JSAQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:16:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch addresses the comments from Randy Dunlap (Randy.Dunlap@oracle.com)
regarding comment blocks that begining with "/**". bfa driver comments
currently do not follow kernel-doc convention, we hence replace all 
/** with /* and **/ with */. 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h          |   28 +++++++-------
 drivers/scsi/bfa/bfa_cb_ioim.h  |   20 +++++-----
 drivers/scsi/bfa/bfa_cs.h       |   24 ++++++------
 drivers/scsi/bfa/bfa_defs.h     |   54 +++++++++++++-------------
 drivers/scsi/bfa/bfa_defs_fcs.h |   46 +++++++++++-----------
 drivers/scsi/bfa/bfa_defs_svc.h |   82 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfa_fc.h       |   30 +++++++-------
 drivers/scsi/bfa/bfa_fcpim.h    |   18 ++++----
 drivers/scsi/bfa/bfa_fcs.h      |   30 +++++++-------
 drivers/scsi/bfa/bfa_ioc.h      |   38 +++++++++---------
 drivers/scsi/bfa/bfa_modules.h  |    6 +-
 drivers/scsi/bfa/bfa_os_inc.h   |    4 +-
 drivers/scsi/bfa/bfa_svc.h      |   41 +++++++++----------
 drivers/scsi/bfa/bfad_drv.h     |    4 +-
 drivers/scsi/bfa/bfi.h          |   58 ++++++++++++++--------------
 drivers/scsi/bfa/bfi_ms.h       |   50 ++++++++++++------------
 16 files changed, 266 insertions(+), 267 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index c3981df..ff2bd07 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -29,13 +29,13 @@ struct bfa_s;
 typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
 typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
 
-/**
+/*
  * Interrupt message handlers
  */
 void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
 void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 
-/**
+/*
  * Request and response queue related defines
  */
 #define BFA_REQQ_NELEMS_MIN	(4)
@@ -58,8 +58,8 @@ void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 #define bfa_reqq_produce(__bfa, __reqq)	do {				\
 		(__bfa)->iocfc.req_cq_pi[__reqq]++;			\
 		(__bfa)->iocfc.req_cq_pi[__reqq] &=			\
-			((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1);      \
-		writel((__bfa)->iocfc.req_cq_pi[__reqq], 		\
+			((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1); \
+		writel((__bfa)->iocfc.req_cq_pi[__reqq],		\
 			(__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq]);	\
 		mmiowb();      \
 	} while (0)
@@ -76,7 +76,7 @@ void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 	(__index) &= ((__size) - 1);			\
 } while (0)
 
-/**
+/*
  * Queue element to wait for room in request queue. FIFO order is
  * maintained when fullfilling requests.
  */
@@ -86,7 +86,7 @@ struct bfa_reqq_wait_s {
 	void		*cbarg;
 };
 
-/**
+/*
  * Circular queue usage assignments
  */
 enum {
@@ -113,7 +113,7 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
 
 #define bfa_reqq(__bfa, __reqq)	(&(__bfa)->reqq_waitq[__reqq])
 
-/**
+/*
  * static inline void
  * bfa_reqq_wait(struct bfa_s *bfa, int reqq, struct bfa_reqq_wait_s *wqe)
  */
@@ -130,7 +130,7 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
 #define bfa_reqq_wcancel(__wqe)	list_del(&(__wqe)->qe)
 
 
-/**
+/*
  * Generic BFA callback element.
  */
 struct bfa_cb_qe_s {
@@ -163,7 +163,7 @@ struct bfa_cb_qe_s {
 	} while (0)
 
 
-/**
+/*
  * PCI devices supported by the current BFA
  */
 struct bfa_pciid_s {
@@ -173,7 +173,7 @@ struct bfa_pciid_s {
 
 extern char     bfa_version[];
 
-/**
+/*
  * BFA memory resources
  */
 enum bfa_mem_type {
@@ -203,7 +203,7 @@ struct bfa_meminfo_s {
 
 struct bfa_iocfc_regs_s {
 	void __iomem	*intr_status;
-	void __iomem 	*intr_mask;
+	void __iomem	*intr_mask;
 	void __iomem	*cpe_q_pi[BFI_IOC_MAX_CQS];
 	void __iomem	*cpe_q_ci[BFI_IOC_MAX_CQS];
 	void __iomem	*cpe_q_depth[BFI_IOC_MAX_CQS];
@@ -214,7 +214,7 @@ struct bfa_iocfc_regs_s {
 	void __iomem	*rme_q_ctrl[BFI_IOC_MAX_CQS];
 };
 
-/**
+/*
  * MSIX vector handlers
  */
 #define BFA_MSIX_MAX_VECTORS	22
@@ -224,7 +224,7 @@ struct bfa_msix_s {
 	bfa_msix_handler_t handler[BFA_MSIX_MAX_VECTORS];
 };
 
-/**
+/*
  * Chip specific interfaces
  */
 struct bfa_hwif_s {
@@ -343,7 +343,7 @@ int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
 				struct bfi_pbc_vport_s *pbc_vport);
 
 
-/**
+/*
  *----------------------------------------------------------------------
  *		BFA public interfaces
  *----------------------------------------------------------------------
diff --git a/drivers/scsi/bfa/bfa_cb_ioim.h b/drivers/scsi/bfa/bfa_cb_ioim.h
index 78c5ba2..6f02101 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim.h
@@ -42,13 +42,13 @@ bfad_int_to_lun(u32 luno)
 	return lun.bfa_lun;
 }
 
-/**
+/*
  * Get LUN for the I/O request
  */
 #define bfa_cb_ioim_get_lun(__dio)	\
 	bfad_int_to_lun(((struct scsi_cmnd *)__dio)->device->lun)
 
-/**
+/*
  * Get CDB for the I/O request
  */
 static inline u8 *
@@ -59,7 +59,7 @@ bfa_cb_ioim_get_cdb(struct bfad_ioim_s *dio)
 	return (u8 *) cmnd->cmnd;
 }
 
-/**
+/*
  * Get I/O direction (read/write) for the I/O request
  */
 static inline enum fcp_iodir
@@ -77,7 +77,7 @@ bfa_cb_ioim_get_iodir(struct bfad_ioim_s *dio)
 		return FCP_IODIR_NONE;
 }
 
-/**
+/*
  * Get IO size in bytes for the I/O request
  */
 static inline u32
@@ -88,7 +88,7 @@ bfa_cb_ioim_get_size(struct bfad_ioim_s *dio)
 	return scsi_bufflen(cmnd);
 }
 
-/**
+/*
  * Get timeout for the I/O request
  */
 static inline u8
@@ -104,7 +104,7 @@ bfa_cb_ioim_get_timeout(struct bfad_ioim_s *dio)
 	return 0;
 }
 
-/**
+/*
  * Get Command Reference Number for the I/O request. 0 if none.
  */
 static inline u8
@@ -113,7 +113,7 @@ bfa_cb_ioim_get_crn(struct bfad_ioim_s *dio)
 	return 0;
 }
 
-/**
+/*
  * Get SAM-3 priority for the I/O request. 0 is default.
  */
 static inline u8
@@ -122,7 +122,7 @@ bfa_cb_ioim_get_priority(struct bfad_ioim_s *dio)
 	return 0;
 }
 
-/**
+/*
  * Get task attributes for the I/O request. Default is FCP_TASK_ATTR_SIMPLE(0).
  */
 static inline u8
@@ -148,7 +148,7 @@ bfa_cb_ioim_get_taskattr(struct bfad_ioim_s *dio)
 	return task_attr;
 }
 
-/**
+/*
  * Get CDB length in bytes for the I/O request. Default is FCP_CMND_CDB_LEN(16).
  */
 static inline u8
@@ -159,7 +159,7 @@ bfa_cb_ioim_get_cdblen(struct bfad_ioim_s *dio)
 	return cmnd->cmd_len;
 }
 
-/**
+/*
  * Assign queue to be used for the I/O request. This value depends on whether
  * the driver wants to use the queues via any specific algorithm. Currently,
  * this is not supported.
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 7260c74..99f242b 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfa_cs.h BFA common services
  */
 
@@ -24,7 +24,7 @@
 
 #include "bfa_os_inc.h"
 
-/**
+/*
  * BFA TRC
  */
 
@@ -73,7 +73,7 @@ enum {
 #define BFA_TRC_MOD_SH	10
 #define BFA_TRC_MOD(__mod)	((BFA_TRC_ ## __mod) << BFA_TRC_MOD_SH)
 
-/**
+/*
  * Define a new tracing file (module). Module should match one defined above.
  */
 #define BFA_TRC_FILE(__mod, __submod)					\
@@ -155,7 +155,7 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
 #define bfa_trc_fp(_trcp, _data)
 #endif
 
-/**
+/*
  * @ BFA LOG interfaces
  */
 #define bfa_assert(__cond)	do {					\
@@ -249,13 +249,13 @@ bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe)
 #define bfa_q_is_on_q(_q, _qe)      \
 	bfa_q_is_on_q_func(_q, (struct list_head *)(_qe))
 
-/**
+/*
  * @ BFA state machine interfaces
  */
 
 typedef void (*bfa_sm_t)(void *sm, int event);
 
-/**
+/*
  * oc - object class eg. bfa_ioc
  * st - state, eg. reset
  * otype - object type, eg. struct bfa_ioc_s
@@ -269,7 +269,7 @@ typedef void (*bfa_sm_t)(void *sm, int event);
 #define bfa_sm_get_state(_sm)		((_sm)->sm)
 #define bfa_sm_cmp_state(_sm, _state)	((_sm)->sm == (bfa_sm_t)(_state))
 
-/**
+/*
  * For converting from state machine function to state encoding.
  */
 struct bfa_sm_table_s {
@@ -279,12 +279,12 @@ struct bfa_sm_table_s {
 };
 #define BFA_SM(_sm)	((bfa_sm_t)(_sm))
 
-/**
+/*
  * State machine with entry actions.
  */
 typedef void (*bfa_fsm_t)(void *fsm, int event);
 
-/**
+/*
  * oc - object class eg. bfa_ioc
  * st - state, eg. reset
  * otype - object type, eg. struct bfa_ioc_s
@@ -314,7 +314,7 @@ bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm)
 	return smt[i].state;
 }
 
-/**
+/*
  * @ Generic wait counter.
  */
 
@@ -340,7 +340,7 @@ bfa_wc_down(struct bfa_wc_s *wc)
 		wc->wc_resume(wc->wc_cbarg);
 }
 
-/**
+/*
  * Initialize a waiting counter.
  */
 static inline void
@@ -352,7 +352,7 @@ bfa_wc_init(struct bfa_wc_s *wc, bfa_wc_resume_t wc_resume, void *wc_cbarg)
 	bfa_wc_up(wc);
 }
 
-/**
+/*
  * Wait for counter to reach zero
  */
 static inline void
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index d49877f..4b5b9e3 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -24,7 +24,7 @@
 #define BFA_MFG_SERIALNUM_SIZE                  11
 #define STRSZ(_n)                               (((_n) + 4) & ~3)
 
-/**
+/*
  * Manufacturing card type
  */
 enum {
@@ -45,7 +45,7 @@ enum {
 
 #pragma pack(1)
 
-/**
+/*
  * Check if Mezz card
  */
 #define bfa_mfg_is_mezz(type) (( \
@@ -55,7 +55,7 @@ enum {
 	(type) == BFA_MFG_TYPE_LIGHTNING_P0 || \
 	(type) == BFA_MFG_TYPE_LIGHTNING))
 
-/**
+/*
  * Check if the card having old wwn/mac handling
  */
 #define bfa_mfg_is_old_wwn_mac_model(type) (( \
@@ -78,12 +78,12 @@ do {                                                            \
 	(m)[2] = t & 0xFF;                                      \
 } while (0)
 
-/**
+/*
  * VPD data length
  */
 #define BFA_MFG_VPD_LEN                 512
 
-/**
+/*
  * VPD vendor tag
  */
 enum {
@@ -97,7 +97,7 @@ enum {
 	BFA_MFG_VPD_PCI_BRCD    = 0xf8,  /*  PCI VPD Brocade            */
 };
 
-/**
+/*
  * All numerical fields are in big-endian format.
  */
 struct bfa_mfg_vpd_s {
@@ -112,7 +112,7 @@ struct bfa_mfg_vpd_s {
 
 #pragma pack()
 
-/**
+/*
  * Status return values
  */
 enum bfa_status {
@@ -167,11 +167,11 @@ enum bfa_boolean {
 #define BFA_STRING_32	32
 #define BFA_VERSION_LEN 64
 
-/**
+/*
  * ---------------------- adapter definitions ------------
  */
 
-/**
+/*
  * BFA adapter level attributes.
  */
 enum {
@@ -215,7 +215,7 @@ struct bfa_adapter_attr_s {
 	u8		trunk_capable;
 };
 
-/**
+/*
  * ---------------------- IOC definitions ------------
  */
 
@@ -224,7 +224,7 @@ enum {
 	BFA_IOC_CHIP_REV_LEN	= 8,
 };
 
-/**
+/*
  * Driver and firmware versions.
  */
 struct bfa_ioc_driver_attr_s {
@@ -236,7 +236,7 @@ struct bfa_ioc_driver_attr_s {
 	char		ob_ver[BFA_VERSION_LEN];	/*  openboot version */
 };
 
-/**
+/*
  * IOC PCI device attributes
  */
 struct bfa_ioc_pci_attr_s {
@@ -249,7 +249,7 @@ struct bfa_ioc_pci_attr_s {
 	char		chip_rev[BFA_IOC_CHIP_REV_LEN];	 /*  chip revision */
 };
 
-/**
+/*
  * IOC states
  */
 enum bfa_ioc_state {
@@ -267,7 +267,7 @@ enum bfa_ioc_state {
 	BFA_IOC_ENABLING	= 12,	/*  IOC is being enabled */
 };
 
-/**
+/*
  * IOC firmware stats
  */
 struct bfa_fw_ioc_stats_s {
@@ -279,7 +279,7 @@ struct bfa_fw_ioc_stats_s {
 	u32	unknown_reqs;
 };
 
-/**
+/*
  * IOC driver stats
  */
 struct bfa_ioc_drv_stats_s {
@@ -296,7 +296,7 @@ struct bfa_ioc_drv_stats_s {
 	u32	enable_replies;
 };
 
-/**
+/*
  * IOC statistics
  */
 struct bfa_ioc_stats_s {
@@ -310,7 +310,7 @@ enum bfa_ioc_type_e {
 	BFA_IOC_TYPE_LL		= 3,
 };
 
-/**
+/*
  * IOC attributes returned in queries
  */
 struct bfa_ioc_attr_s {
@@ -323,11 +323,11 @@ struct bfa_ioc_attr_s {
 	u8				rsvd[7];	/*  64bit align    */
 };
 
-/**
+/*
  * ---------------------- mfg definitions ------------
  */
 
-/**
+/*
  * Checksum size
  */
 #define BFA_MFG_CHKSUM_SIZE			16
@@ -340,7 +340,7 @@ struct bfa_ioc_attr_s {
 
 #pragma pack(1)
 
-/**
+/*
  * All numerical fields are in big-endian format.
  */
 struct bfa_mfg_block_s {
@@ -373,11 +373,11 @@ struct bfa_mfg_block_s {
 
 #pragma pack()
 
-/**
+/*
  * ---------------------- pci definitions ------------
  */
 
-/**
+/*
  * PCI device and vendor ID information
  */
 enum {
@@ -392,14 +392,14 @@ enum {
 	((devid) == BFA_PCI_DEVICE_ID_CT ||	\
 	 (devid) == BFA_PCI_DEVICE_ID_CT_FC)
 
-/**
+/*
  * PCI sub-system device and vendor ID information
  */
 enum {
 	BFA_PCI_FCOE_SSDEVICE_ID	= 0x14,
 };
 
-/**
+/*
  * Maximum number of device address ranges mapped through different BAR(s)
  */
 #define BFA_PCI_ACCESS_RANGES 1
@@ -430,7 +430,7 @@ enum {
 #define BOOT_CFG_REV1   1
 #define BOOT_CFG_VLAN   1
 
-/**
+/*
  *      Boot options setting. Boot options setting determines from where
  *      to get the boot lun information
  */
@@ -442,7 +442,7 @@ enum bfa_boot_bootopt {
 };
 
 #pragma pack(1)
-/**
+/*
  * Boot lun information.
  */
 struct bfa_boot_bootlun_s {
@@ -451,7 +451,7 @@ struct bfa_boot_bootlun_s {
 };
 #pragma pack()
 
-/**
+/*
  * BOOT boot configuraton
  */
 struct bfa_boot_pbc_s {
diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index ae06258..191d34a 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -21,7 +21,7 @@
 #include "bfa_fc.h"
 #include "bfa_defs_svc.h"
 
-/**
+/*
  * VF states
  */
 enum bfa_vf_state {
@@ -35,7 +35,7 @@ enum bfa_vf_state {
 	BFA_VF_ISOLATED  = 7,	/*  port isolated due to vf_id mismatch */
 };
 
-/**
+/*
  * VF statistics
  */
 struct bfa_vf_stats_s {
@@ -55,7 +55,7 @@ struct bfa_vf_stats_s {
 	u32	resvd; /*  padding for 64 bit alignment */
 };
 
-/**
+/*
  * VF attributes returned in queries
  */
 struct bfa_vf_attr_s {
@@ -67,7 +67,7 @@ struct bfa_vf_attr_s {
 #define BFA_FCS_MAX_LPORTS 256
 #define BFA_FCS_FABRIC_IPADDR_SZ  16
 
-/**
+/*
  * symbolic names for base port/virtual port
  */
 #define BFA_SYMNAME_MAXLEN	128	/* 128 bytes */
@@ -75,7 +75,7 @@ struct bfa_lport_symname_s {
 	char	    symname[BFA_SYMNAME_MAXLEN];
 };
 
-/**
+/*
 * Roles of FCS port:
  *     - FCP IM and FCP TM roles cannot be enabled together for a FCS port
  *     - Create multiple ports if both IM and TM functions required.
@@ -86,7 +86,7 @@ enum bfa_lport_role {
 	BFA_LPORT_ROLE_FCP_MAX	= BFA_LPORT_ROLE_FCP_IM,
 };
 
-/**
+/*
  * FCS port configuration.
  */
 struct bfa_lport_cfg_s {
@@ -98,7 +98,7 @@ struct bfa_lport_cfg_s {
     u8	     tag[16];	/*  opaque tag from application */
 };
 
-/**
+/*
  * FCS port states
  */
 enum bfa_lport_state {
@@ -108,7 +108,7 @@ enum bfa_lport_state {
 	BFA_LPORT_OFFLINE = 3,	/*  No login to fabric */
 };
 
-/**
+/*
  * FCS port type.
  */
 enum bfa_lport_type {
@@ -116,7 +116,7 @@ enum bfa_lport_type {
 	BFA_LPORT_TYPE_VIRTUAL,
 };
 
-/**
+/*
  * FCS port offline reason.
  */
 enum bfa_lport_offline_reason {
@@ -128,7 +128,7 @@ enum bfa_lport_offline_reason {
 	BFA_LPORT_OFFLINE_FAB_LOGOUT,
 };
 
-/**
+/*
  * FCS lport info.
  */
 struct bfa_lport_info_s {
@@ -150,7 +150,7 @@ struct bfa_lport_info_s {
 
 };
 
-/**
+/*
  * FCS port statistics
  */
 struct bfa_lport_stats_s {
@@ -222,7 +222,7 @@ struct bfa_lport_stats_s {
 					    * (max retry of plogi) */
 };
 
-/**
+/*
  * BFA port attribute returned in queries
  */
 struct bfa_lport_attr_s {
@@ -239,7 +239,7 @@ struct bfa_lport_attr_s {
 };
 
 
-/**
+/*
  * VPORT states
  */
 enum bfa_vport_state {
@@ -258,7 +258,7 @@ enum bfa_vport_state {
 	BFA_FCS_VPORT_MAX_STATE,
 };
 
-/**
+/*
  * vport statistics
  */
 struct bfa_vport_stats_s {
@@ -296,7 +296,7 @@ struct bfa_vport_stats_s {
 	u32        rsvd;
 };
 
-/**
+/*
  * BFA vport attribute returned in queries
  */
 struct bfa_vport_attr_s {
@@ -305,7 +305,7 @@ struct bfa_vport_attr_s {
 	u32          rsvd;
 };
 
-/**
+/*
  * FCS remote port states
  */
 enum bfa_rport_state {
@@ -321,7 +321,7 @@ enum bfa_rport_state {
 	BFA_RPORT_NSDISC	= 9,	/*  re-discover rport */
 };
 
-/**
+/*
  *  Rport Scsi Function : Initiator/Target.
  */
 enum bfa_rport_function {
@@ -329,7 +329,7 @@ enum bfa_rport_function {
 	BFA_RPORT_TARGET	= 0x02,	/*  SCSI Target	*/
 };
 
-/**
+/*
  * port/node symbolic names for rport
  */
 #define BFA_RPORT_SYMNAME_MAXLEN	255
@@ -337,7 +337,7 @@ struct bfa_rport_symname_s {
 	char            symname[BFA_RPORT_SYMNAME_MAXLEN];
 };
 
-/**
+/*
  * FCS remote port statistics
  */
 struct bfa_rport_stats_s {
@@ -374,7 +374,7 @@ struct bfa_rport_stats_s {
 	struct bfa_rport_hal_stats_s	hal_stats;  /*  BFA rport stats    */
 };
 
-/**
+/*
  * FCS remote port attributes returned in queries
  */
 struct bfa_rport_attr_s {
@@ -411,7 +411,7 @@ struct bfa_rport_remote_link_stats_s {
 #define BFA_MAX_IO_INDEX 7
 #define BFA_NO_IO_INDEX 9
 
-/**
+/*
  * FCS itnim states
  */
 enum bfa_itnim_state {
@@ -425,7 +425,7 @@ enum bfa_itnim_state {
 	BFA_ITNIM_INITIATIOR	= 7,	/*  initiator */
 };
 
-/**
+/*
  * FCS remote port statistics
  */
 struct bfa_itnim_stats_s {
@@ -443,7 +443,7 @@ struct bfa_itnim_stats_s {
 	u32	rsvd;		/* padding for 64 bit alignment */
 };
 
-/**
+/*
  * FCS itnim attributes returned in queries
  */
 struct bfa_itnim_attr_s {
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 56226fc..e24e9f7 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -27,7 +27,7 @@
 #define BFA_IOCFCOE_INTR_DELAY	25
 #define BFA_IOCFCOE_INTR_LATENCY 5
 
-/**
+/*
  * Interrupt coalescing configuration.
  */
 #pragma pack(1)
@@ -38,7 +38,7 @@ struct bfa_iocfc_intr_attr_s {
 	u16	delay;		/*  delay in microseconds     */
 };
 
-/**
+/*
  * IOC firmware configuraton
  */
 struct bfa_iocfc_fwcfg_s {
@@ -71,7 +71,7 @@ struct bfa_iocfc_drvcfg_s {
 	u32		rsvd;
 };
 
-/**
+/*
  * IOC configuration
  */
 struct bfa_iocfc_cfg_s {
@@ -79,7 +79,7 @@ struct bfa_iocfc_cfg_s {
 	struct bfa_iocfc_drvcfg_s	drvcfg;	/*  driver side config	  */
 };
 
-/**
+/*
  * IOC firmware IO stats
  */
 struct bfa_fw_io_stats_s {
@@ -152,7 +152,7 @@ struct bfa_fw_io_stats_s {
 						 */
 };
 
-/**
+/*
  * IOC port firmware stats
  */
 
@@ -262,7 +262,7 @@ struct bfa_fw_fcoe_stats_s {
     u32    mac_invalids;       /*  Invalid mac assigned                */
 };
 
-/**
+/*
  * IOC firmware FCoE port stats
  */
 struct bfa_fw_fcoe_port_stats_s {
@@ -270,7 +270,7 @@ struct bfa_fw_fcoe_port_stats_s {
     struct bfa_fw_fip_stats_s   fip_stats;
 };
 
-/**
+/*
  * IOC firmware FC uport stats
  */
 struct bfa_fw_fc_uport_stats_s {
@@ -278,7 +278,7 @@ struct bfa_fw_fc_uport_stats_s {
 	struct bfa_fw_port_lksm_stats_s		lksm_stats;
 };
 
-/**
+/*
  * IOC firmware FC port stats
  */
 union bfa_fw_fc_port_stats_s {
@@ -286,7 +286,7 @@ union bfa_fw_fc_port_stats_s {
 	struct bfa_fw_fcoe_port_stats_s	fcoe_stats;
 };
 
-/**
+/*
  * IOC firmware port stats
  */
 struct bfa_fw_port_stats_s {
@@ -295,7 +295,7 @@ struct bfa_fw_port_stats_s {
 	union  bfa_fw_fc_port_stats_s		fc_port;
 };
 
-/**
+/*
  * fcxchg module statistics
  */
 struct bfa_fw_fcxchg_stats_s {
@@ -308,7 +308,7 @@ struct bfa_fw_lpsm_stats_s {
 	u32	cls_tx;
 };
 
-/**
+/*
  *  Trunk statistics
  */
 struct bfa_fw_trunk_stats_s {
@@ -334,7 +334,7 @@ struct bfa_fw_advsm_stats_s {
 	u32 elp_dropped;		/*  ELP dropped		*/
 };
 
-/**
+/*
  * IOCFC firmware stats
  */
 struct bfa_fw_iocfc_stats_s {
@@ -345,7 +345,7 @@ struct bfa_fw_iocfc_stats_s {
 	u32	set_intr_reqs;	/*  set interrupt reqs */
 };
 
-/**
+/*
  * IOC attributes returned in queries
  */
 struct bfa_iocfc_attr_s {
@@ -353,7 +353,7 @@ struct bfa_iocfc_attr_s {
 	struct bfa_iocfc_intr_attr_s	intr_attr;	/*  interrupt attr */
 };
 
-/**
+/*
  * Eth_sndrcv mod stats
  */
 struct bfa_fw_eth_sndrcv_stats_s {
@@ -361,7 +361,7 @@ struct bfa_fw_eth_sndrcv_stats_s {
 	u32	rsvd;		/*  64bit align    */
 };
 
-/**
+/*
  * CT MAC mod stats
  */
 struct bfa_fw_mac_mod_stats_s {
@@ -379,7 +379,7 @@ struct bfa_fw_mac_mod_stats_s {
 	u32	rsvd;		/*  64bit align    */
 };
 
-/**
+/*
  * CT MOD stats
  */
 struct bfa_fw_ct_mod_stats_s {
@@ -391,7 +391,7 @@ struct bfa_fw_ct_mod_stats_s {
 	u32	rsvd;		/*  64bit align    */
 };
 
-/**
+/*
  * IOC firmware stats
  */
 struct bfa_fw_stats_s {
@@ -412,7 +412,7 @@ struct bfa_fw_stats_s {
 #define BFA_IOCFC_PATHTOV_MAX	60
 #define BFA_IOCFC_QDEPTH_MAX	2000
 
-/**
+/*
  * QoS states
  */
 enum bfa_qos_state {
@@ -420,7 +420,7 @@ enum bfa_qos_state {
 	BFA_QOS_OFFLINE = 2,		/*  QoS is offline */
 };
 
-/**
+/*
  * QoS  Priority levels.
  */
 enum bfa_qos_priority {
@@ -430,7 +430,7 @@ enum bfa_qos_priority {
 	BFA_QOS_LOW  =  3,	/*  QoS Priority Level Low */
 };
 
-/**
+/*
  * QoS  bandwidth allocation for each priority level
  */
 enum bfa_qos_bw_alloc {
@@ -439,7 +439,7 @@ enum bfa_qos_bw_alloc {
 	BFA_QOS_BW_LOW  =  10,	/*  bandwidth allocation for Low */
 };
 #pragma pack(1)
-/**
+/*
  * QoS attribute returned in QoS Query
  */
 struct bfa_qos_attr_s {
@@ -448,7 +448,7 @@ struct bfa_qos_attr_s {
 	u32  total_bb_cr;		/*  Total BB Credits */
 };
 
-/**
+/*
  * These fields should be displayed only from the CLI.
  * There will be a separate BFAL API (get_qos_vc_attr ?)
  * to retrieve this.
@@ -471,7 +471,7 @@ struct bfa_qos_vc_attr_s {
 							    * total_vc_count */
 };
 
-/**
+/*
  * QoS statistics
  */
 struct bfa_qos_stats_s {
@@ -489,7 +489,7 @@ struct bfa_qos_stats_s {
 	u32	rsvd;		    /* padding for 64 bit alignment */
 };
 
-/**
+/*
  * FCoE statistics
  */
 struct bfa_fcoe_stats_s {
@@ -540,7 +540,7 @@ struct bfa_fcoe_stats_s {
 	u64	rxf_bcast_vlan;	/*  Rx FCoE broadcast vlan frames   */
 };
 
-/**
+/*
  * QoS or FCoE stats (fcport stats excluding physical FC port stats)
  */
 union bfa_fcport_stats_u {
@@ -639,7 +639,7 @@ enum bfa_port_states {
 	BFA_PORT_ST_MAX_STATE,
 };
 
-/**
+/*
  *	Port operational type (in sync with SNIA port type).
  */
 enum bfa_port_type {
@@ -651,7 +651,7 @@ enum bfa_port_type {
 	BFA_PORT_TYPE_VPORT	= 22,	/*  NPIV - virtual port */
 };
 
-/**
+/*
  *	Port topology setting. A port's topology and fabric login status
  *	determine its operational type.
  */
@@ -662,7 +662,7 @@ enum bfa_port_topology {
 	BFA_PORT_TOPOLOGY_AUTO = 3,	/*  auto topology selection */
 };
 
-/**
+/*
  *	Physical port loopback types.
  */
 enum bfa_port_opmode {
@@ -679,7 +679,7 @@ enum bfa_port_opmode {
 	(_mode == BFA_PORT_OPMODE_LB_SLW) ||		\
 	(_mode == BFA_PORT_OPMODE_LB_EXT))
 
-/**
+/*
  *	Port link state
  */
 enum bfa_port_linkstate {
@@ -687,7 +687,7 @@ enum bfa_port_linkstate {
 	BFA_PORT_LINKDOWN	= 2,	/*  Physical port/Trunk link down */
 };
 
-/**
+/*
  *	Port link state reason code
  */
 enum bfa_port_linkstate_rsn {
@@ -733,7 +733,7 @@ enum bfa_port_linkstate_rsn {
 	CEE_ISCSI_PRI_OVERLAP_FCOE_PRI		= 43
 };
 #pragma pack(1)
-/**
+/*
  *      Physical port configuration
  */
 struct bfa_port_cfg_s {
@@ -753,7 +753,7 @@ struct bfa_port_cfg_s {
 };
 #pragma pack()
 
-/**
+/*
  *	Port attribute values.
  */
 struct bfa_port_attr_s {
@@ -800,7 +800,7 @@ struct bfa_port_attr_s {
 	u8			rsvd1[6];
 };
 
-/**
+/*
  *	      Port FCP mappings.
  */
 struct bfa_port_fcpmap_s {
@@ -815,7 +815,7 @@ struct bfa_port_fcpmap_s {
 	char		luid[256];
 };
 
-/**
+/*
  *	      Port RNID info.
  */
 struct bfa_port_rnid_s {
@@ -848,7 +848,7 @@ struct bfa_fcport_fcf_s {
 	mac_t	   mac;	    /*  FCF mac		  */
 };
 
-/**
+/*
  *	Trunk states for BCU/BFAL
  */
 enum bfa_trunk_state {
@@ -857,7 +857,7 @@ enum bfa_trunk_state {
 	BFA_TRUNK_OFFLINE	= 2,	/*  Trunk is offline		*/
 };
 
-/**
+/*
  *	VC attributes for trunked link
  */
 struct bfa_trunk_vc_attr_s {
@@ -867,7 +867,7 @@ struct bfa_trunk_vc_attr_s {
 	u16 vc_credits[8];
 };
 
-/**
+/*
  *	Link state information
  */
 struct bfa_port_link_s {
@@ -959,7 +959,7 @@ struct bfa_rport_hal_stats_s {
 	u32        rsvd;
 };
 #pragma pack(1)
-/**
+/*
  *  Rport's QoS attributes
  */
 struct bfa_rport_qos_attr_s {
@@ -987,7 +987,7 @@ struct bfa_itnim_ioprofile_s {
 	struct bfa_itnim_latency_s io_latency;
 };
 
-/**
+/*
  * FC physical port statistics.
  */
 struct bfa_port_fc_stats_s {
@@ -1022,7 +1022,7 @@ struct bfa_port_fc_stats_s {
 	u64     err_enc;        /*  Encoding err frame_8b10b    */
 };
 
-/**
+/*
  * Eth Physical Port statistics.
  */
 struct bfa_port_eth_stats_s {
@@ -1070,7 +1070,7 @@ struct bfa_port_eth_stats_s {
 	u64     tx_iscsi_zero_pause; /*  Tx iSCSI zero pause    */
 };
 
-/**
+/*
  *              Port statistics.
  */
 union bfa_port_stats_u {
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 6eff705..e929d25 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -1029,7 +1029,7 @@ struct link_e2e_beacon_req_s {
 	struct link_e2e_beacon_param_s beacon_parm;
 };
 
-/**
+/*
  * If RPSC request is sent to the Domain Controller, the request is for
  * all the ports within that domain (TODO - I don't think FOS implements
  * this...).
@@ -1049,7 +1049,7 @@ struct fc_rpsc_acc_s {
 	struct fc_rpsc_speed_info_s speed_info[1];
 };
 
-/**
+/*
  * If RPSC2 request is sent to the Domain Controller,
  */
 #define FC_BRCD_TOKEN    0x42524344
@@ -1094,7 +1094,7 @@ struct fc_rpsc2_acc_s {
     struct fc_rpsc2_port_info_s port_info[1];    /* port information */
 };
 
-/**
+/*
  * bit fields so that multiple classes can be specified
  */
 enum fc_cos {
@@ -1131,7 +1131,7 @@ struct fc_alpabm_s {
 #define FC_VF_ID_MAX     0xEFF
 #define FC_VF_ID_CTL     0xFEF	/*  control VF_ID */
 
-/**
+/*
  * Virtual Fabric Tagging header format
  * @caution This is defined only in BIG ENDIAN format.
  */
@@ -1463,7 +1463,7 @@ struct fcgs_gidpn_resp_s {
 	u32	dap:24;	/* port identifier */
 };
 
-/**
+/*
  * RFT_ID
  */
 struct fcgs_rftid_req_s {
@@ -1472,7 +1472,7 @@ struct fcgs_rftid_req_s {
 	u32	fc4_type[8];	/* fc4 types */
 };
 
-/**
+/*
  * RFF_ID : Register FC4 features.
  */
 
@@ -1487,7 +1487,7 @@ struct fcgs_rffid_req_s {
     u32    fc4_type:8;		/* corresponding FC4 Type */
 };
 
-/**
+/*
  * GID_FT Request
  */
 struct fcgs_gidft_req_s {
@@ -1497,7 +1497,7 @@ struct fcgs_gidft_req_s {
 	u8	fc4_type;	/* FC_TYPE_FCP for SCSI devices */
 };		/* GID_FT Request */
 
-/**
+/*
  * GID_FT Response
  */
 struct fcgs_gidft_resp_s {
@@ -1506,7 +1506,7 @@ struct fcgs_gidft_resp_s {
 	u32	pid:24;	/* port identifier */
 };		/* GID_FT Response */
 
-/**
+/*
  * RSPN_ID
  */
 struct fcgs_rspnid_req_s {
@@ -1516,7 +1516,7 @@ struct fcgs_rspnid_req_s {
 	u8		spn[256];	/* symbolic port name */
 };
 
-/**
+/*
  * RPN_ID
  */
 struct fcgs_rpnid_req_s {
@@ -1525,7 +1525,7 @@ struct fcgs_rpnid_req_s {
 	wwn_t		port_name;
 };
 
-/**
+/*
  * RNN_ID
  */
 struct fcgs_rnnid_req_s {
@@ -1534,7 +1534,7 @@ struct fcgs_rnnid_req_s {
 	wwn_t		node_name;
 };
 
-/**
+/*
  * RCS_ID
  */
 struct fcgs_rcsid_req_s {
@@ -1543,7 +1543,7 @@ struct fcgs_rcsid_req_s {
 	u32	cos;
 };
 
-/**
+/*
  * RPT_ID
  */
 struct fcgs_rptid_req_s {
@@ -1553,7 +1553,7 @@ struct fcgs_rptid_req_s {
 	u32	rsvd1:24;
 };
 
-/**
+/*
  * GA_NXT Request
  */
 struct fcgs_ganxt_req_s {
@@ -1561,7 +1561,7 @@ struct fcgs_ganxt_req_s {
 	u32	port_id:24;
 };
 
-/**
+/*
  * GA_NXT Response
  */
 struct fcgs_ganxt_rsp_s {
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 3bf3431..db53717 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -104,7 +104,7 @@ struct bfa_fcpim_mod_s {
 	bfa_fcpim_profile_t     profile_start;
 };
 
-/**
+/*
  * BFA IO (initiator mode)
  */
 struct bfa_ioim_s {
@@ -137,7 +137,7 @@ struct bfa_ioim_sp_s {
 	struct bfa_tskim_s	*tskim;		/*  Relevant TM cmd	*/
 };
 
-/**
+/*
  * BFA Task management command (initiator mode)
  */
 struct bfa_tskim_s {
@@ -160,7 +160,7 @@ struct bfa_tskim_s {
 };
 
 
-/**
+/*
  * BFA i-t-n (initiator mode)
  */
 struct bfa_itnim_s {
@@ -303,7 +303,7 @@ bfa_status_t	bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
 		struct bfa_itnim_ioprofile_s *ioprofile);
 #define bfa_itnim_get_reqq(__ioim) (((struct bfa_ioim_s *)__ioim)->itnim->reqq)
 
-/**
+/*
  *	BFA completion callback for bfa_itnim_online().
  *
  * @param[in]		itnim		FCS or driver itnim instance
@@ -312,7 +312,7 @@ bfa_status_t	bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
  */
 void	bfa_cb_itnim_online(void *itnim);
 
-/**
+/*
  *	BFA completion callback for bfa_itnim_offline().
  *
  * @param[in]		itnim		FCS or driver itnim instance
@@ -323,7 +323,7 @@ void	bfa_cb_itnim_offline(void *itnim);
 void	bfa_cb_itnim_tov_begin(void *itnim);
 void	bfa_cb_itnim_tov(void *itnim);
 
-/**
+/*
  *	BFA notification to FCS/driver for second level error recovery.
  *
  * Atleast one I/O request has timedout and target is unresponsive to
@@ -351,7 +351,7 @@ void		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
 				      bfa_boolean_t iotov);
 
 
-/**
+/*
  *	I/O completion notification.
  *
  * @param[in]		dio			driver IO structure
@@ -368,7 +368,7 @@ void	bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
 				  u8 scsi_status, int sns_len,
 				  u8 *sns_info, s32 residue);
 
-/**
+/*
  *	I/O good completion notification.
  *
  * @param[in]		dio			driver IO structure
@@ -377,7 +377,7 @@ void	bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
  */
 void	bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
 
-/**
+/*
  *	I/O abort completion notification
  *
  * @param[in]		dio			driver IO that was aborted
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index e5ff919..9cb6a55 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -196,7 +196,7 @@ struct bfa_fcs_fabric_s {
 #define bfa_fcs_fabric_is_switched(__f)			\
 	((__f)->fab_type == BFA_FCS_FABRIC_SWITCHED)
 
-/**
+/*
  *   The design calls for a single implementation of base fabric and vf.
  */
 #define bfa_fcs_vf_t struct bfa_fcs_fabric_s
@@ -216,7 +216,7 @@ struct bfa_fcs_fabric_s;
 
 #define bfa_fcs_lport_t struct bfa_fcs_lport_s
 
-/**
+/*
  * Symbolic Name related defines
  *  Total bytes 255.
  *  Physical Port's symbolic name 128 bytes.
@@ -239,7 +239,7 @@ struct bfa_fcs_fabric_s;
 #define BFA_FCS_PORT_SYMBNAME_OSINFO_SZ			48
 #define BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ		16
 
-/**
+/*
  * Get FC port ID for a logical port.
  */
 #define bfa_fcs_lport_get_fcid(_lport)	((_lport)->pid)
@@ -262,7 +262,7 @@ bfa_fcs_lport_get_drvport(struct bfa_fcs_lport_s *port)
 #define bfa_fcs_lport_get_fabric_ipaddr(_lport)		\
 		((_lport)->fabric->fabric_ip_addr)
 
-/**
+/*
  * bfa fcs port public functions
  */
 
@@ -342,7 +342,7 @@ struct bfa_fcs_vport_s {
 #define bfa_fcs_vport_get_port(vport)			\
 	((struct bfa_fcs_lport_s  *)(&vport->port))
 
-/**
+/*
  * bfa fcs vport public functions
  */
 bfa_status_t bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport,
@@ -393,7 +393,7 @@ struct bfa_fcs_rpf_s {
 	enum bfa_port_speed	rpsc_speed;
 	/*  Current Speed from RPSC. O if RPSC fails */
 	enum bfa_port_speed	assigned_speed;
-	/**
+	/*
 	 * Speed assigned by the user.  will be used if RPSC is
 	 * not supported by the rport.
 	 */
@@ -434,7 +434,7 @@ bfa_fcs_rport_get_halrport(struct bfa_fcs_rport_s *rport)
 	return rport->bfa_rport;
 }
 
-/**
+/*
  * bfa fcs rport API functions
  */
 bfa_status_t bfa_fcs_rport_add(struct bfa_fcs_lport_s *port, wwn_t *pwwn,
@@ -573,7 +573,7 @@ bfa_fcs_itnim_get_halitn(struct bfa_fcs_itnim_s *itnim)
 	return itnim->bfa_itnim;
 }
 
-/**
+/*
  * bfa fcs FCP Initiator mode API functions
  */
 void bfa_fcs_itnim_get_attr(struct bfa_fcs_itnim_s *itnim,
@@ -677,7 +677,7 @@ void bfa_fcs_exit(struct bfa_fcs_s *fcs);
 void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
 void		bfa_fcs_start(struct bfa_fcs_s *fcs);
 
-/**
+/*
  * bfa fcs vf public functions
  */
 bfa_fcs_vf_t *bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id);
@@ -716,11 +716,11 @@ u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
 void bfa_fcs_port_attach(struct bfa_fcs_s *fcs);
 
-/**
+/*
  * BFA FCS callback interfaces
  */
 
-/**
+/*
  * fcb Main fcs callbacks
  */
 
@@ -729,7 +729,7 @@ struct bfad_vf_s;
 struct bfad_vport_s;
 struct bfad_rport_s;
 
-/**
+/*
  * lport callbacks
  */
 struct bfad_port_s *bfa_fcb_lport_new(struct bfad_s *bfad,
@@ -741,19 +741,19 @@ void bfa_fcb_lport_delete(struct bfad_s *bfad, enum bfa_lport_role roles,
 			  struct bfad_vf_s *vf_drv,
 			  struct bfad_vport_s *vp_drv);
 
-/**
+/*
  * vport callbacks
  */
 void bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s);
 
-/**
+/*
  * rport callbacks
  */
 bfa_status_t bfa_fcb_rport_alloc(struct bfad_s *bfad,
 				 struct bfa_fcs_rport_s **rport,
 				 struct bfad_rport_s **rport_drv);
 
-/**
+/*
  * itnim callbacks
  */
 void bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index d60e472..9c407a8 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -22,29 +22,29 @@
 #include "bfa_cs.h"
 #include "bfi.h"
 
-/**
+/*
  * BFA timer declarations
  */
 typedef void (*bfa_timer_cbfn_t)(void *);
 
-/**
+/*
  * BFA timer data structure
  */
 struct bfa_timer_s {
 	struct list_head	qe;
 	bfa_timer_cbfn_t timercb;
 	void		*arg;
-	int		timeout;	/**< in millisecs. */
+	int		timeout;	/* in millisecs */
 };
 
-/**
+/*
  * Timer module structure
  */
 struct bfa_timer_mod_s {
 	struct list_head timer_q;
 };
 
-#define BFA_TIMER_FREQ 200 /**< specified in millisecs */
+#define BFA_TIMER_FREQ 200 /* specified in millisecs */
 
 void bfa_timer_beat(struct bfa_timer_mod_s *mod);
 void bfa_timer_init(struct bfa_timer_mod_s *mod);
@@ -53,7 +53,7 @@ void bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
 			unsigned int timeout);
 void bfa_timer_stop(struct bfa_timer_s *timer);
 
-/**
+/*
  * Generic Scatter Gather Element used by driver
  */
 struct bfa_sge_s {
@@ -80,17 +80,17 @@ struct bfa_sge_s {
 #define bfa_sgaddr_le(_x)	(_x)
 #endif
 
-/**
+/*
  * PCI device information required by IOC
  */
 struct bfa_pcidev_s {
 	int		pci_slot;
 	u8		pci_func;
-	u16	device_id;
-	void __iomem 	*pci_bar_kva;
+	u16		device_id;
+	void __iomem	*pci_bar_kva;
 };
 
-/**
+/*
  * Structure used to remember the DMA-able memory block's KVA and Physical
  * Address
  */
@@ -102,7 +102,7 @@ struct bfa_dma_s {
 #define BFA_DMA_ALIGN_SZ	256
 #define BFA_ROUNDUP(_l, _s)	(((_l) + ((_s) - 1)) & ~((_s) - 1))
 
-/**
+/*
  * smem size for Crossbow and Catapult
  */
 #define BFI_SMEM_CB_SIZE	0x200000U	/* ! 2MB for crossbow	*/
@@ -156,7 +156,7 @@ struct bfa_ioc_regs_s {
 #define bfa_mem_read(_raddr, _off)	swab32(readl(((_raddr) + (_off))))
 #define bfa_mem_write(_raddr, _off, _val)	\
 			writel(swab32((_val)), ((_raddr) + (_off)))
-/**
+/*
  * IOC Mailbox structures
  */
 struct bfa_mbox_cmd_s {
@@ -164,7 +164,7 @@ struct bfa_mbox_cmd_s {
 	u32	msg[BFI_IOC_MSGSZ];
 };
 
-/**
+/*
  * IOC mailbox module
  */
 typedef void (*bfa_ioc_mbox_mcfunc_t)(void *cbarg, struct bfi_mbmsg_s *m);
@@ -177,7 +177,7 @@ struct bfa_ioc_mbox_mod_s {
 	} mbhdlr[BFI_MC_MAX];
 };
 
-/**
+/*
  * IOC callback function interfaces
  */
 typedef void (*bfa_ioc_enable_cbfn_t)(void *bfa, enum bfa_status status);
@@ -191,7 +191,7 @@ struct bfa_ioc_cbfn_s {
 	bfa_ioc_reset_cbfn_t	reset_cbfn;
 };
 
-/**
+/*
  * Heartbeat failure notification queue element.
  */
 struct bfa_ioc_hbfail_notify_s {
@@ -200,7 +200,7 @@ struct bfa_ioc_hbfail_notify_s {
 	void			*cbarg;
 };
 
-/**
+/*
  * Initialize a heartbeat failure notification structure
  */
 #define bfa_ioc_hbfail_init(__notify, __cbfn, __cbarg) do {	\
@@ -285,7 +285,7 @@ struct bfa_ioc_hwif_s {
 #define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)	(off % BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
-/**
+/*
  * IOC mailbox interface
  */
 void bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd);
@@ -297,7 +297,7 @@ void bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg);
 void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 		bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg);
 
-/**
+/*
  * IOC interfaces
  */
 
@@ -439,7 +439,7 @@ bfa_cb_image_get_size(int type)
 	}
 }
 
-/**
+/*
  * CNA TRCMOD declaration
  */
 /*
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 2cd5273..15407ab 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfa_modules.h BFA modules
  */
 
@@ -52,7 +52,7 @@ enum {
 };
 
 
-/**
+/*
  * Macro to define a new BFA module
  */
 #define BFA_MODULE(__mod)						\
@@ -80,7 +80,7 @@ enum {
 
 #define BFA_CACHELINE_SZ	(256)
 
-/**
+/*
  * Structure used to interact between different BFA sub modules
  *
  * Each sub module needs to implement only the entry points relevant to it (and
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index f9edc75..65df62e 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -90,13 +90,13 @@ do {									\
 	({						\
 		struct timeval tv;			\
 							\
-		do_gettimeofday(&tv);      		\
+		do_gettimeofday(&tv);			\
 		(tv.tv_sec*1000000+tv.tv_usec);		\
 	 })
 
 #define boolean_t int
 
-/**
+/*
  * For current time stamp, OS API will fill-in
  */
 struct bfa_timeval_s {
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 9921dad..e2349d5 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -22,12 +22,12 @@
 #include "bfi_ms.h"
 
 
-/**
+/*
  * Scatter-gather DMA related defines
  */
 #define BFA_SGPG_MIN	(16)
 
-/**
+/*
  * Alignment macro for SG page allocation
  */
 #define BFA_SGPG_ROUNDUP(_l) (((_l) + (sizeof(struct bfi_sgpg_s) - 1))	\
@@ -48,7 +48,7 @@ struct bfa_sgpg_s {
 	union bfi_addr_u sgpg_pa;	/*  pa of SG page		*/
 };
 
-/**
+/*
  * Given number of SG elements, BFA_SGPG_NPAGE() returns the number of
  * SG pages required.
  */
@@ -75,7 +75,7 @@ void bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpgs);
 void bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe);
 
 
-/**
+/*
  * FCXP related defines
  */
 #define BFA_FCXP_MIN		(1)
@@ -115,12 +115,12 @@ typedef void (*bfa_fcxp_alloc_cbfn_t) (void *cbarg, struct bfa_fcxp_s *fcxp);
 
 
 
-/**
+/*
  * Information needed for a FCXP request
  */
 struct bfa_fcxp_req_info_s {
 	struct bfa_rport_s *bfa_rport;
-					/** Pointer to the bfa rport that was
+					/* Pointer to the bfa rport that was
 					 * returned from bfa_rport_create().
 					 * This could be left NULL for WKA or
 					 * for FCXP interactions before the
@@ -137,11 +137,10 @@ struct bfa_fcxp_req_info_s {
 
 struct bfa_fcxp_rsp_info_s {
 	struct fchs_s	rsp_fchs;
-				/** !< Response frame's FC header will
+				/* Response frame's FC header will
 				 * be sent back in this field */
 	u8		rsp_timeout;
-				/** !< timeout in seconds, 0-no response
-				 */
+				/* timeout in seconds, 0-no response */
 	u8		rsvd2[3];
 	u32	rsp_maxlen;	/*  max response length expected */
 };
@@ -218,7 +217,7 @@ struct bfa_fcxp_wqe_s {
 void	bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 
 
-/**
+/*
  * RPORT related defines
  */
 #define BFA_RPORT_MIN	4
@@ -232,7 +231,7 @@ struct bfa_rport_mod_s {
 
 #define BFA_RPORT_MOD(__bfa)	(&(__bfa)->modules.rport_mod)
 
-/**
+/*
  * Convert rport tag to RPORT
  */
 #define BFA_RPORT_FROM_TAG(__bfa, _tag)				\
@@ -244,7 +243,7 @@ struct bfa_rport_mod_s {
  */
 void	bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 
-/**
+/*
  *	BFA rport information.
  */
 struct bfa_rport_info_s {
@@ -259,7 +258,7 @@ struct bfa_rport_info_s {
 	enum bfa_port_speed speed;	/*  Rport's current speed	    */
 };
 
-/**
+/*
  * BFA rport data structure
  */
 struct bfa_rport_s {
@@ -282,7 +281,7 @@ struct bfa_rport_s {
 #define BFA_RPORT_FC_COS(_rport)	((_rport)->rport_info.fc_class)
 
 
-/**
+/*
  * UF - unsolicited receive related defines
  */
 
@@ -305,7 +304,7 @@ struct bfa_uf_s {
 	struct bfa_sge_s sges[BFI_SGE_INLINE_MAX];
 };
 
-/**
+/*
  *      Callback prototype for unsolicited frame receive handler.
  *
  * @param[in]           cbarg           callback arg for receive handler
@@ -338,7 +337,7 @@ void	bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 
 #define BFA_UF_BUFSZ	(2 * 1024 + 256)
 
-/**
+/*
  * @todo private
  */
 struct bfa_uf_buf_s {
@@ -346,7 +345,7 @@ struct bfa_uf_buf_s {
 };
 
 
-/**
+/*
  * LPS - bfa lport login/logout service interface
  */
 struct bfa_lps_s {
@@ -397,14 +396,14 @@ struct bfa_lps_mod_s {
 void	bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 
 
-/**
+/*
  * FCPORT related defines
  */
 
 #define BFA_FCPORT(_bfa)	(&((_bfa)->modules.port))
 typedef void (*bfa_cb_port_t) (void *cbarg, enum bfa_status status);
 
-/**
+/*
  * Link notification data structure
  */
 struct bfa_fcport_ln_s {
@@ -418,7 +417,7 @@ struct bfa_fcport_trunk_s {
 	struct bfa_trunk_attr_s	attr;
 };
 
-/**
+/*
  * BFA FC port data structure
  */
 struct bfa_fcport_s {
@@ -613,7 +612,7 @@ void bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv,
 			  void *cbarg);
 void bfa_uf_free(struct bfa_uf_s *uf);
 
-/**
+/*
  * bfa lport service api
  */
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index a9045a8..97f9b6c 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -15,11 +15,11 @@
  * General Public License for more details.
  */
 
-/**
+/*
  * Contains base driver definitions.
  */
 
-/**
+/*
  *  bfa_drv.h Linux driver data structures.
  */
 
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 85f2224..58796d1 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -23,7 +23,7 @@
 
 #pragma pack(1)
 
-/**
+/*
  * BFI FW image type
  */
 #define	BFI_FLASH_CHUNK_SZ			256	/*  Flash chunk size */
@@ -35,7 +35,7 @@ enum {
 	BFI_IMAGE_MAX,
 };
 
-/**
+/*
  * Msg header common to all msgs
  */
 struct bfi_mhdr_s {
@@ -68,7 +68,7 @@ struct bfi_mhdr_s {
 #define BFI_I2H_OPCODE_BASE	128
 #define BFA_I2HM(_x)		((_x) + BFI_I2H_OPCODE_BASE)
 
-/**
+/*
  ****************************************************************************
  *
  * Scatter Gather Element and Page definition
@@ -79,7 +79,7 @@ struct bfi_mhdr_s {
 #define BFI_SGE_INLINE	1
 #define BFI_SGE_INLINE_MAX	(BFI_SGE_INLINE + 1)
 
-/**
+/*
  * SG Flags
  */
 enum {
@@ -90,7 +90,7 @@ enum {
 	BFI_SGE_PGDLEN		= 2,	/*  cumulative data length for page */
 };
 
-/**
+/*
  * DMA addresses
  */
 union bfi_addr_u {
@@ -100,7 +100,7 @@ union bfi_addr_u {
 	} a32;
 };
 
-/**
+/*
  * Scatter Gather Element
  */
 struct bfi_sge_s {
@@ -116,7 +116,7 @@ struct bfi_sge_s {
 	union bfi_addr_u sga;
 };
 
-/**
+/*
  * Scatter Gather Page
  */
 #define BFI_SGPG_DATA_SGES		7
@@ -139,7 +139,7 @@ struct bfi_msg_s {
 	u32	pl[BFI_LMSG_PL_WSZ];
 };
 
-/**
+/*
  * Mailbox message structure
  */
 #define BFI_MBMSG_SZ		7
@@ -148,7 +148,7 @@ struct bfi_mbmsg_s {
 	u32		pl[BFI_MBMSG_SZ];
 };
 
-/**
+/*
  * Message Classes
  */
 enum bfi_mclass {
@@ -186,7 +186,7 @@ enum bfi_mclass {
 #define BFI_BOOT_LOADER_BIOS		1
 #define BFI_BOOT_LOADER_UEFI		2
 
-/**
+/*
  *----------------------------------------------------------------------
  *				IOC
  *----------------------------------------------------------------------
@@ -208,7 +208,7 @@ enum bfi_ioc_i2h_msgs {
 	BFI_IOC_I2H_HBEAT		= BFA_I2HM(5),
 };
 
-/**
+/*
  * BFI_IOC_H2I_GETATTR_REQ message
  */
 struct bfi_ioc_getattr_req_s {
@@ -242,7 +242,7 @@ struct bfi_ioc_attr_s {
 	u32	card_type;	/*  card type			*/
 };
 
-/**
+/*
  * BFI_IOC_I2H_GETATTR_REPLY message
  */
 struct bfi_ioc_getattr_reply_s {
@@ -251,19 +251,19 @@ struct bfi_ioc_getattr_reply_s {
 	u8			rsvd[3];
 };
 
-/**
+/*
  * Firmware memory page offsets
  */
 #define BFI_IOC_SMEM_PG0_CB	(0x40)
 #define BFI_IOC_SMEM_PG0_CT	(0x180)
 
-/**
+/*
  * Firmware statistic offset
  */
 #define BFI_IOC_FWSTATS_OFF	(0x6B40)
 #define BFI_IOC_FWSTATS_SZ	(4096)
 
-/**
+/*
  * Firmware trace offset
  */
 #define BFI_IOC_TRC_OFF		(0x4b00)
@@ -280,7 +280,7 @@ struct bfi_ioc_image_hdr_s {
 	u32	md5sum[BFI_IOC_MD5SUM_SZ];
 };
 
-/**
+/*
  *  BFI_IOC_I2H_READY_EVENT message
  */
 struct bfi_ioc_rdy_event_s {
@@ -294,7 +294,7 @@ struct bfi_ioc_hbeat_s {
 	u32	   hb_count;	/*  current heart beat count	*/
 };
 
-/**
+/*
  * IOC hardware/firmware state
  */
 enum bfi_ioc_state {
@@ -340,7 +340,7 @@ enum {
 	((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |	\
 			BFI_ADAPTER_UNSUPP))
 
-/**
+/*
  * BFI_IOC_H2I_ENABLE_REQ & BFI_IOC_H2I_DISABLE_REQ messages
  */
 struct bfi_ioc_ctrl_req_s {
@@ -352,7 +352,7 @@ struct bfi_ioc_ctrl_req_s {
 #define bfi_ioc_enable_req_t struct bfi_ioc_ctrl_req_s;
 #define bfi_ioc_disable_req_t struct bfi_ioc_ctrl_req_s;
 
-/**
+/*
  * BFI_IOC_I2H_ENABLE_REPLY & BFI_IOC_I2H_DISABLE_REPLY messages
  */
 struct bfi_ioc_ctrl_reply_s {
@@ -364,7 +364,7 @@ struct bfi_ioc_ctrl_reply_s {
 #define bfi_ioc_disable_reply_t struct bfi_ioc_ctrl_reply_s;
 
 #define BFI_IOC_MSGSZ   8
-/**
+/*
  * H2I Messages
  */
 union bfi_ioc_h2i_msg_u {
@@ -375,7 +375,7 @@ union bfi_ioc_h2i_msg_u {
 	u32			mboxmsg[BFI_IOC_MSGSZ];
 };
 
-/**
+/*
  * I2H Messages
  */
 union bfi_ioc_i2h_msg_u {
@@ -385,7 +385,7 @@ union bfi_ioc_i2h_msg_u {
 };
 
 
-/**
+/*
  *----------------------------------------------------------------------
  *				PBC
  *----------------------------------------------------------------------
@@ -394,7 +394,7 @@ union bfi_ioc_i2h_msg_u {
 #define BFI_PBC_MAX_BLUNS	8
 #define BFI_PBC_MAX_VPORTS	16
 
-/**
+/*
  * PBC boot lun configuration
  */
 struct bfi_pbc_blun_s {
@@ -402,7 +402,7 @@ struct bfi_pbc_blun_s {
 	lun_t		tgt_lun;
 };
 
-/**
+/*
  * PBC virtual port configuration
  */
 struct bfi_pbc_vport_s {
@@ -410,7 +410,7 @@ struct bfi_pbc_vport_s {
 	wwn_t		vp_nwwn;
 };
 
-/**
+/*
  * BFI pre-boot configuration information
  */
 struct bfi_pbc_s {
@@ -427,7 +427,7 @@ struct bfi_pbc_s {
 	struct bfi_pbc_vport_s vport[BFI_PBC_MAX_VPORTS];
 };
 
-/**
+/*
  *----------------------------------------------------------------------
  *				MSGQ
  *----------------------------------------------------------------------
@@ -531,7 +531,7 @@ enum bfi_port_i2h {
 	BFI_PORT_I2H_CLEAR_STATS_RSP    = BFA_I2HM(4),
 };
 
-/**
+/*
  * Generic REQ type
  */
 struct bfi_port_generic_req_s {
@@ -540,7 +540,7 @@ struct bfi_port_generic_req_s {
 	u32     rsvd;
 };
 
-/**
+/*
  * Generic RSP type
  */
 struct bfi_port_generic_rsp_s {
@@ -550,7 +550,7 @@ struct bfi_port_generic_rsp_s {
 	u32     msgtag;         /*  msgtag for reply                */
 };
 
-/**
+/*
  * BFI_PORT_H2I_GET_STATS_REQ
  */
 struct bfi_port_get_stats_req_s {
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index 69ac85f..fa9f6fb 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -41,7 +41,7 @@ struct bfi_iocfc_cfg_s {
 	u16	rsvd_1;
 	u32	endian_sig;	/*  endian signature of host     */
 
-	/**
+	/*
 	 * Request and response circular queue base addresses, size and
 	 * shadow index pointers.
 	 */
@@ -58,7 +58,7 @@ struct bfi_iocfc_cfg_s {
 	struct bfa_iocfc_intr_attr_s intr_attr; /*  IOC interrupt attributes */
 };
 
-/**
+/*
  * Boot target wwn information for this port. This contains either the stored
  * or discovered boot target port wwns for the port.
  */
@@ -75,7 +75,7 @@ struct bfi_iocfc_cfgrsp_s {
 	struct bfi_pbc_s		pbc_cfg;
 };
 
-/**
+/*
  * BFI_IOCFC_H2I_CFG_REQ message
  */
 struct bfi_iocfc_cfg_req_s {
@@ -84,7 +84,7 @@ struct bfi_iocfc_cfg_req_s {
 };
 
 
-/**
+/*
  * BFI_IOCFC_I2H_CFG_REPLY message
  */
 struct bfi_iocfc_cfg_reply_s {
@@ -95,7 +95,7 @@ struct bfi_iocfc_cfg_reply_s {
 };
 
 
-/**
+/*
  * BFI_IOCFC_H2I_SET_INTR_REQ message
  */
 struct bfi_iocfc_set_intr_req_s {
@@ -107,7 +107,7 @@ struct bfi_iocfc_set_intr_req_s {
 };
 
 
-/**
+/*
  * BFI_IOCFC_H2I_UPDATEQ_REQ message
  */
 struct bfi_iocfc_updateq_req_s {
@@ -119,7 +119,7 @@ struct bfi_iocfc_updateq_req_s {
 };
 
 
-/**
+/*
  * BFI_IOCFC_I2H_UPDATEQ_RSP message
  */
 struct bfi_iocfc_updateq_rsp_s {
@@ -129,7 +129,7 @@ struct bfi_iocfc_updateq_rsp_s {
 };
 
 
-/**
+/*
  * H2I Messages
  */
 union bfi_iocfc_h2i_msg_u {
@@ -140,7 +140,7 @@ union bfi_iocfc_h2i_msg_u {
 };
 
 
-/**
+/*
  * I2H Messages
  */
 union bfi_iocfc_i2h_msg_u {
@@ -173,7 +173,7 @@ enum bfi_fcport_i2h {
 };
 
 
-/**
+/*
  * Generic REQ type
  */
 struct bfi_fcport_req_s {
@@ -181,7 +181,7 @@ struct bfi_fcport_req_s {
 	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
-/**
+/*
  * Generic RSP type
  */
 struct bfi_fcport_rsp_s {
@@ -191,7 +191,7 @@ struct bfi_fcport_rsp_s {
 	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
-/**
+/*
  * BFI_FCPORT_H2I_ENABLE_REQ
  */
 struct bfi_fcport_enable_req_s {
@@ -205,7 +205,7 @@ struct bfi_fcport_enable_req_s {
 	u32	   rsvd2;
 };
 
-/**
+/*
  * BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ
  */
 struct bfi_fcport_set_svc_params_req_s {
@@ -214,7 +214,7 @@ struct bfi_fcport_set_svc_params_req_s {
 	u16	   rsvd;
 };
 
-/**
+/*
  * BFI_FCPORT_I2H_EVENT
  */
 struct bfi_fcport_event_s {
@@ -222,7 +222,7 @@ struct bfi_fcport_event_s {
 	struct bfa_port_link_s	link_state;
 };
 
-/**
+/*
  * BFI_FCPORT_I2H_TRUNK_SCN
  */
 struct bfi_fcport_trunk_link_s {
@@ -243,7 +243,7 @@ struct bfi_fcport_trunk_scn_s {
 	struct bfi_fcport_trunk_link_s tlink[BFI_FCPORT_MAX_LINKS];
 };
 
-/**
+/*
  * fcport H2I message
  */
 union bfi_fcport_h2i_msg_u {
@@ -255,7 +255,7 @@ union bfi_fcport_h2i_msg_u {
 	struct bfi_fcport_req_s			*pstatsclear;
 };
 
-/**
+/*
  * fcport I2H message
  */
 union bfi_fcport_i2h_msg_u {
@@ -279,7 +279,7 @@ enum bfi_fcxp_i2h {
 
 #define BFA_FCXP_MAX_SGES	2
 
-/**
+/*
  * FCXP send request structure
  */
 struct bfi_fcxp_send_req_s {
@@ -299,7 +299,7 @@ struct bfi_fcxp_send_req_s {
 	struct bfi_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];	/*  response buf   */
 };
 
-/**
+/*
  * FCXP send response structure
  */
 struct bfi_fcxp_send_rsp_s {
@@ -565,14 +565,14 @@ enum bfi_ioim_i2h {
 	BFI_IOIM_I2H_IOABORT_RSP = BFA_I2HM(2),	/*  ABORT rsp	 */
 };
 
-/**
+/*
  * IO command DIF info
  */
 struct bfi_ioim_dif_s {
 	u32	dif_info[4];
 };
 
-/**
+/*
  * FCP IO messages overview
  *
  * @note
@@ -587,7 +587,7 @@ struct bfi_ioim_req_s {
 	u16	rport_hdl;	/*  itnim/rport firmware handle */
 	struct fcp_cmnd_s	cmnd;	/*  IO request info	*/
 
-	/**
+	/*
 	 * SG elements array within the IO request must be double word
 	 * aligned. This aligment is required to optimize SGM setup for the IO.
 	 */
@@ -598,7 +598,7 @@ struct bfi_ioim_req_s {
 	struct bfi_ioim_dif_s  dif;
 };
 
-/**
+/*
  *	This table shows various IO status codes from firmware and their
  *	meaning. Host driver can use these status codes to further process
  *	IO completions.
@@ -684,7 +684,7 @@ enum bfi_ioim_status {
 };
 
 #define BFI_IOIM_SNSLEN	(256)
-/**
+/*
  * I/O response message
  */
 struct bfi_ioim_rsp_s {
@@ -746,7 +746,7 @@ enum bfi_tskim_status {
 	BFI_TSKIM_STS_NOT_SUPP = 4,
 	BFI_TSKIM_STS_FAILED	= 5,
 
-	/**
+	/*
 	 * Defined by BFA
 	 */
 	BFI_TSKIM_STS_TIMEOUT  = 10,	/*  TM request timedout	*/
-- 
1.6.5.2

