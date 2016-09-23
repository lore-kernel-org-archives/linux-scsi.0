From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] [SCSI] bfa: mark symbols static where possible
Date: Fri, 23 Sep 2016 21:50:43 +0800
Message-ID: <1474638643-12657-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get a few warnings when building kernel with W=1:
drivers/scsi/bfa/bfad.c:1502:1: warning: no previous prototype for 'restart_bfa' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_attr.c:447:1: warning: no previous prototype for 'bfad_im_issue_fc_host_lip' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_attr.c:575:1: warning: no previous prototype for 'bfad_im_vport_set_symbolic_name' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:27:1: warning: no previous prototype for 'bfad_iocmd_ioc_enable' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:50:1: warning: no previous prototype for 'bfad_iocmd_ioc_disable' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:148:1: warning: no previous prototype for 'bfad_iocmd_ioc_get_stats' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:158:1: warning: no previous prototype for 'bfad_iocmd_ioc_get_fwstats' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:188:1: warning: no previous prototype for 'bfad_iocmd_ioc_reset_stats' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:206:1: warning: no previous prototype for 'bfad_iocmd_ioc_set_name' [-Wmissing-prototypes]
drivers/scsi/bfa/bfad_bsg.c:220:1: warning: no previous prototype for 'bfad_iocmd_iocfc_get_attr' [-Wmissing-prototypes]
....

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/bfa/bfa_core.c      |   2 +-
 drivers/scsi/bfa/bfa_fcpim.c     |   4 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |   2 +-
 drivers/scsi/bfa/bfa_ioc.c       |   6 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |   4 +-
 drivers/scsi/bfa/bfa_port.c      |   4 +-
 drivers/scsi/bfa/bfa_svc.c       |   4 +-
 drivers/scsi/bfa/bfad.c          |   2 +-
 drivers/scsi/bfa/bfad_attr.c     |   4 +-
 drivers/scsi/bfa/bfad_bsg.c      | 224 +++++++++++++++++++--------------------
 10 files changed, 128 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 7209afa..a09b786 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -732,7 +732,7 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 	}
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_isr_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 20982e7..36c2984 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -445,7 +445,7 @@ bfa_fcpim_port_iostats(struct bfa_s *bfa,
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_latency_s *io_lat =
@@ -462,7 +462,7 @@ bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 	io_lat->avg[idx] += val;
 }
 
-void
+static void
 bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 {
 	ioim->start_time = jiffies;
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4ddda72..c76b4a3 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1280,7 +1280,7 @@ bfa_fcs_lport_n2n_offline(struct bfa_fcs_lport_s *port)
 	n2n_port->reply_oxid = 0;
 }
 
-void
+static void
 bfa_fcport_get_loop_attr(struct bfa_fcs_lport_s *port)
 {
 	int i = 0, j = 0, bit = 0, alpa_bit = 0;
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a1ada4a..7439ecf 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -5036,7 +5036,7 @@ diag_portbeacon_comp(struct bfa_diag_s *diag)
 /*
  *	Diag hmbox handler
  */
-void
+static void
 bfa_diag_intr(void *diagarg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_diag_s *diag = diagarg;
@@ -6999,7 +6999,7 @@ bfa_raw_sem_get(void __iomem *bar)
 
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_flash_sem_get(void __iomem *bar)
 {
 	u32 n = FLASH_BLOCKING_OP_MAX;
@@ -7012,7 +7012,7 @@ bfa_flash_sem_get(void __iomem *bar)
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_flash_sem_put(void __iomem *bar)
 {
 	writel(0, (bar + FLASH_SEM_LOCK_REG));
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 651a8fb..4e39d4a 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -372,7 +372,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	writel(r32, rb + FNC_PERS_REG);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_ct2_lpu_read_stat(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
@@ -752,7 +752,7 @@ bfa_ioc_ct2_mem_init(void __iomem *rb)
 	writel(0, (rb + CT2_MBIST_CTL_REG));
 }
 
-void
+static void
 bfa_ioc_ct2_mac_reset(void __iomem *rb)
 {
 	/* put port0, port1 MAC & AHB in reset */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index da1721e..6ec7cd4 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -773,7 +773,7 @@ bfa_cee_reset_stats(struct bfa_cee_s *cee,
  * @return void
  */
 
-void
+static void
 bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
 	union bfi_cee_i2h_msg_u *msg;
@@ -809,7 +809,7 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
  * @return void
  */
 
-void
+static void
 bfa_cee_notify(void *arg, enum bfa_ioc_event_e event)
 {
 	struct bfa_cee_s *cee = (struct bfa_cee_s *) arg;
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 12de292..f8c8d5a 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -4375,7 +4375,7 @@ bfa_fcport_dportdisable(struct bfa_s *bfa)
 	bfa_port_set_dportenabled(&bfa->modules.port, BFA_FALSE);
 }
 
-void
+static void
 bfa_fcport_ddportenable(struct bfa_s *bfa)
 {
 	/*
@@ -4384,7 +4384,7 @@ bfa_fcport_ddportenable(struct bfa_s *bfa)
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_DDPORTENABLE);
 }
 
-void
+static void
 bfa_fcport_ddportdisable(struct bfa_s *bfa)
 {
 	/*
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9d253cb..54d4c6d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1498,7 +1498,7 @@ bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	return ret;
 }
 
-int
+static int
 restart_bfa(struct bfad_s *bfad)
 {
 	unsigned long flags;
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 13db3b7..3668b02 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -443,7 +443,7 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	return status;
 }
 
-int
+static int
 bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
 {
 	struct bfad_im_port_s *im_port =
@@ -571,7 +571,7 @@ bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
-void
+static void
 bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 {
 	struct bfad_vport_s *vport = (struct bfad_vport_s *)fc_vport->dd_data;
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index d1ad020..44cf38b 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -23,7 +23,7 @@
 
 BFA_TRC_FILE(LDRV, BSG);
 
-int
+static int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -46,7 +46,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -144,7 +144,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ioc_stats_s *iocmd = (struct bfa_bsg_ioc_stats_s *)cmd;
@@ -154,7 +154,7 @@ bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -184,7 +184,7 @@ bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -202,7 +202,7 @@ bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_ioc_name_s *iocmd = (struct bfa_bsg_ioc_name_s *) cmd;
@@ -216,7 +216,7 @@ bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_attr_s *iocmd = (struct bfa_bsg_iocfc_attr_s *)cmd;
@@ -227,7 +227,7 @@ bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -239,7 +239,7 @@ bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_intr_s *iocmd = (struct bfa_bsg_iocfc_intr_s *)cmd;
@@ -252,7 +252,7 @@ bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -273,7 +273,7 @@ bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -323,7 +323,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -357,7 +357,7 @@ bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -378,7 +378,7 @@ bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_port_cfg_s *cmd = (struct bfa_bsg_port_cfg_s *)iocmd;
@@ -398,7 +398,7 @@ bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_maxfrsize_s *iocmd =
@@ -412,7 +412,7 @@ bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_bbcr_enable_s *iocmd =
@@ -435,7 +435,7 @@ bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_bbcr_attr(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_bbcr_attr_s *iocmd = (struct bfa_bsg_bbcr_attr_s *) pcmd;
@@ -473,7 +473,7 @@ bfad_iocmd_lport_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -497,7 +497,7 @@ bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -531,7 +531,7 @@ bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -556,7 +556,7 @@ bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -598,7 +598,7 @@ bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_attr_s *iocmd = (struct bfa_bsg_rport_attr_s *)cmd;
@@ -684,7 +684,7 @@ bfad_iocmd_rport_get_addr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_stats_s *iocmd =
@@ -725,7 +725,7 @@ bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_reset_stats_s *iocmd =
@@ -761,7 +761,7 @@ bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_set_speed_s *iocmd =
@@ -797,7 +797,7 @@ bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -820,7 +820,7 @@ bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -848,7 +848,7 @@ bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -915,7 +915,7 @@ bfad_iocmd_fabric_get_lports(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_qos_bw_s *iocmd = (struct bfa_bsg_qos_bw_s *)pcmd;
@@ -928,7 +928,7 @@ bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -957,7 +957,7 @@ bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_trl_speed_s *iocmd = (struct bfa_bsg_trl_speed_s *)pcmd;
@@ -986,7 +986,7 @@ bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_s *iocmd = (struct bfa_bsg_fcpim_s *)cmd;
@@ -999,7 +999,7 @@ bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstats_s *iocmd =
@@ -1021,7 +1021,7 @@ bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstatsclr_s *iocmd =
@@ -1043,7 +1043,7 @@ bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_del_itn_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_del_itn_stats_s *iocmd =
@@ -1168,7 +1168,7 @@ bfad_iocmd_itnim_get_itnstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1181,7 +1181,7 @@ bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1194,7 +1194,7 @@ bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_cfg_s *iocmd = (struct bfa_bsg_pcifn_cfg_s *)cmd;
@@ -1216,7 +1216,7 @@ bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1239,7 +1239,7 @@ bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1261,7 +1261,7 @@ bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1285,7 +1285,7 @@ bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_adapter_cfg_mode_s *iocmd =
@@ -1308,7 +1308,7 @@ bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_mode_s *iocmd =
@@ -1332,7 +1332,7 @@ bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1358,7 +1358,7 @@ bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_faa_attr_s *iocmd = (struct bfa_bsg_faa_attr_s *)cmd;
@@ -1381,7 +1381,7 @@ bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_cee_attr_s *iocmd =
@@ -1417,7 +1417,7 @@ bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1454,7 +1454,7 @@ bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1468,7 +1468,7 @@ bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_media_s *iocmd = (struct bfa_bsg_sfp_media_s *)cmd;
@@ -1490,7 +1490,7 @@ bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_speed_s *iocmd = (struct bfa_bsg_sfp_speed_s *)cmd;
@@ -1511,7 +1511,7 @@ bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_attr_s *iocmd =
@@ -1532,7 +1532,7 @@ bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_s *iocmd = (struct bfa_bsg_flash_s *)cmd;
@@ -1552,7 +1552,7 @@ bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1584,7 +1584,7 @@ bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1616,7 +1616,7 @@ bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_get_temp_s *iocmd =
@@ -1638,7 +1638,7 @@ bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_memtest_s *iocmd =
@@ -1661,7 +1661,7 @@ bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_loopback_s *iocmd =
@@ -1684,7 +1684,7 @@ bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_fwping_s *iocmd =
@@ -1708,7 +1708,7 @@ bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_qtest_s *iocmd = (struct bfa_bsg_diag_qtest_s *)cmd;
@@ -1729,7 +1729,7 @@ bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_show_s *iocmd =
@@ -1752,7 +1752,7 @@ bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_led_s *iocmd = (struct bfa_bsg_diag_led_s *)cmd;
@@ -1765,7 +1765,7 @@ bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_beacon_s *iocmd =
@@ -1780,7 +1780,7 @@ bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_lb_stat_s *iocmd =
@@ -1795,7 +1795,7 @@ bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1817,7 +1817,7 @@ bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1837,7 +1837,7 @@ bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1862,7 +1862,7 @@ bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_diag_dport_show_s *iocmd =
@@ -1877,7 +1877,7 @@ bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 }
 
 
-int
+static int
 bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_attr_s *iocmd =
@@ -1898,7 +1898,7 @@ bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_stats_s *iocmd =
@@ -1919,7 +1919,7 @@ bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -1951,7 +1951,7 @@ bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vhba_attr_s *iocmd =
@@ -1970,7 +1970,7 @@ bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -2000,7 +2000,7 @@ bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_debug_s *iocmd = (struct bfa_bsg_debug_s *)cmd;
@@ -2020,7 +2020,7 @@ bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 }
 
 #define BFA_DEBUG_FW_CORE_CHUNK_SZ	0x4000U /* 16K chunks for FW dump */
-int
+static int
 bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -2054,7 +2054,7 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2075,7 +2075,7 @@ bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_portlogctl_s *iocmd = (struct bfa_bsg_portlogctl_s *)cmd;
@@ -2089,7 +2089,7 @@ bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_profile(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_profile_s *iocmd =
@@ -2135,7 +2135,7 @@ bfad_iocmd_itnim_get_ioprofile(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2160,7 +2160,7 @@ bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2184,7 +2184,7 @@ bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2206,7 +2206,7 @@ bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2228,7 +2228,7 @@ bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_preboot_s *iocmd = (struct bfa_bsg_preboot_s *)cmd;
@@ -2247,7 +2247,7 @@ bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2270,7 +2270,7 @@ bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2293,7 +2293,7 @@ bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2333,7 +2333,7 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_trunk_attr_s *iocmd = (struct bfa_bsg_trunk_attr_s *)cmd;
@@ -2356,7 +2356,7 @@ bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2384,7 +2384,7 @@ bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_attr_s *iocmd = (struct bfa_bsg_qos_attr_s *)cmd;
@@ -2410,7 +2410,7 @@ bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_vc_attr_s *iocmd =
@@ -2442,7 +2442,7 @@ bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2474,7 +2474,7 @@ bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2505,7 +2505,7 @@ bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_stats_s *iocmd =
@@ -2528,7 +2528,7 @@ bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_reset_stats_s *iocmd =
@@ -2565,7 +2565,7 @@ bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad_s *bfad, int lunmask_cfg)
 		bfad_reset_sdev_bflags(vport->drv_port.im_port, lunmask_cfg);
 }
 
-int
+static int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -2588,7 +2588,7 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_query_s *iocmd =
@@ -2602,7 +2602,7 @@ bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_s *iocmd =
@@ -2621,7 +2621,7 @@ bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2636,7 +2636,7 @@ bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2651,7 +2651,7 @@ bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2673,7 +2673,7 @@ bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2695,7 +2695,7 @@ bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2717,7 +2717,7 @@ bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2739,7 +2739,7 @@ bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_get_max_size(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_max_size_s *iocmd =
@@ -3191,7 +3191,7 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 }
 
 /* FC passthru call backs */
-u64
+static u64
 bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3203,7 +3203,7 @@ bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3213,7 +3213,7 @@ bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-u64
+static u64
 bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3225,7 +3225,7 @@ bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3235,7 +3235,7 @@ bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-void
+static void
 bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 		bfa_status_t req_status, u32 rsp_len, u32 resid_len,
 		struct fchs_s *rsp_fchs)
@@ -3250,7 +3250,7 @@ bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 	complete(&drv_fcxp->comp);
 }
 
-struct bfad_buf_info *
+static struct bfad_buf_info *
 bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 		 uint32_t payload_len, uint32_t *num_sgles)
 {
@@ -3293,7 +3293,7 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 	return NULL;
 }
 
-void
+static void
 bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 		   uint32_t num_sgles)
 {
@@ -3311,7 +3311,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 	}
 }
 
-int
+static int
 bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
@@ -3351,7 +3351,7 @@ bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 	return BFA_STATUS_OK;
 }
 
-int
+static int
 bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
-- 
2.7.4
