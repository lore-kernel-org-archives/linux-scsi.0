From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/8] bfa: bfa changes part 2
Date: Sun, 29 Nov 2009 17:39:53 -0800
Message-ID: <1259545193-4605-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:36875 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZK3Bjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:39:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Changes to bfa part 2:
 - Changes related to port structure renaming.
 - Check for IOC down condition when issuing getstats/clearstats.
 - Added new portlog entries for events (FLOGI/FDISC/LOGO)
 - Added a FCS function to be called during driver init to set the FDMI Driver
   parameter.
 - Fixed the issue of CPE queue full interrupt not being acknowleged and the
   issue in queue full condition check.
 - Fixed the issue of vport not being removed after FIP Clear Virtual Links
   command received for the vport.
 - Changes to provide separate functions to do attach time FCS initialization
   and initialization after IOC is up for better firmware upgrade handling.
 - IOC auto recovery fixes.
 - Fixed IOC type and mode when FCOE chip is operating in FC mode.
 - Split ASIC specific initialization routines, bfa_ioc_cb.c for FC and
   bfa_ioc_ct for FCOE.
 - Changed max vport for FCOE from 191 to 190
 - Changes to remove ioc_attr local variable from stack.
 - Misc style and formatting changes.
 
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cee.c        |  171 ++++++++-------
 drivers/scsi/bfa/bfa_core.c       |   21 ++
 drivers/scsi/bfa/bfa_fcs.c        |   92 ++++++---
 drivers/scsi/bfa/bfa_fcs_lport.c  |  251 +++++++++++-----------
 drivers/scsi/bfa/bfa_fcs_port.c   |   10 +-
 drivers/scsi/bfa/bfa_fcs_uf.c     |   15 +-
 drivers/scsi/bfa/bfa_fcxp.c       |   13 +-
 drivers/scsi/bfa/bfa_hw_cb.c      |   15 ++-
 drivers/scsi/bfa/bfa_hw_ct.c      |   11 +-
 drivers/scsi/bfa/bfa_intr.c       |  119 ++++++++---
 drivers/scsi/bfa/bfa_ioc_cb.c     |  281 ++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_ioc_ct.c     |  425 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_iocfc.c      |  131 +++++++-----
 drivers/scsi/bfa/bfa_ioim.c       |   58 +++---
 drivers/scsi/bfa/bfa_itnim.c      |   36 ++--
 drivers/scsi/bfa/bfa_log.c        |    3 +-
 drivers/scsi/bfa/bfa_log_module.c |   76 +++++++-
 drivers/scsi/bfa/bfa_lps.c        |  165 +++++++++++++--
 drivers/scsi/bfa/bfa_module.c     |    4 +-
 drivers/scsi/bfa/bfa_port.c       |  108 +++++-----
 drivers/scsi/bfa/bfa_rport.c      |   40 ++--
 drivers/scsi/bfa/bfa_tskim.c      |   20 +-
 22 files changed, 1554 insertions(+), 511 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfa_ioc_cb.c
 create mode 100644 drivers/scsi/bfa/bfa_ioc_ct.c

diff --git a/drivers/scsi/bfa/bfa_cee.c b/drivers/scsi/bfa/bfa_cee.c
index 2b91779..3ec09ee 100644
--- a/drivers/scsi/bfa/bfa_cee.c
+++ b/drivers/scsi/bfa/bfa_cee.c
@@ -30,14 +30,13 @@ BFA_TRC_FILE(CNA, CEE);
 #define bfa_ioc_portid(__ioc) ((__ioc)->port_id)
 #define bfa_lpuid(__arg) bfa_ioc_portid(&(__arg)->ioc)
 
-static void     bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg);
-static void     bfa_cee_format_dcbcx_stats(struct bfa_cee_dcbx_stats_s
-					   *dcbcx_stats);
-static void     bfa_cee_format_lldp_stats(struct bfa_cee_lldp_stats_s
-					  *lldp_stats);
-static void     bfa_cee_format_cfg_stats(struct bfa_cee_cfg_stats_s *cfg_stats);
-static void     bfa_cee_format_cee_cfg(void *buffer);
-static void     bfa_cee_format_cee_stats(void *buffer);
+static void bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg);
+static void
+bfa_cee_format_dcbcx_stats(struct bfa_cee_dcbx_stats_s *dcbcx_stats);
+static void bfa_cee_format_lldp_stats(struct bfa_cee_lldp_stats_s *lldp_stats);
+static void bfa_cee_format_cfg_stats(struct bfa_cee_cfg_stats_s *cfg_stats);
+static void bfa_cee_format_cee_cfg(void *buffer);
+static void bfa_cee_format_cee_stats(void *buffer);
 
 static void
 bfa_cee_format_cee_stats(void *buffer)
@@ -55,57 +54,72 @@ bfa_cee_format_cee_cfg(void *buffer)
 	bfa_cee_format_lldp_cfg(&cee_cfg->lldp_remote);
 }
 
+
 static void
 bfa_cee_format_dcbcx_stats(struct bfa_cee_dcbx_stats_s *dcbcx_stats)
 {
-	dcbcx_stats->subtlvs_unrecognized =
-		bfa_os_ntohl(dcbcx_stats->subtlvs_unrecognized);
+	dcbcx_stats->subtlvs_unrecognized  =
+			bfa_os_ntohl(dcbcx_stats->subtlvs_unrecognized);
 	dcbcx_stats->negotiation_failed =
-		bfa_os_ntohl(dcbcx_stats->negotiation_failed);
+			bfa_os_ntohl(dcbcx_stats->negotiation_failed);
 	dcbcx_stats->remote_cfg_changed =
-		bfa_os_ntohl(dcbcx_stats->remote_cfg_changed);
-	dcbcx_stats->tlvs_received = bfa_os_ntohl(dcbcx_stats->tlvs_received);
-	dcbcx_stats->tlvs_invalid = bfa_os_ntohl(dcbcx_stats->tlvs_invalid);
-	dcbcx_stats->seqno = bfa_os_ntohl(dcbcx_stats->seqno);
-	dcbcx_stats->ackno = bfa_os_ntohl(dcbcx_stats->ackno);
-	dcbcx_stats->recvd_seqno = bfa_os_ntohl(dcbcx_stats->recvd_seqno);
-	dcbcx_stats->recvd_ackno = bfa_os_ntohl(dcbcx_stats->recvd_ackno);
+			bfa_os_ntohl(dcbcx_stats->remote_cfg_changed);
+	dcbcx_stats->tlvs_received =
+			bfa_os_ntohl(dcbcx_stats->tlvs_received);
+	dcbcx_stats->tlvs_invalid =
+			bfa_os_ntohl(dcbcx_stats->tlvs_invalid);
+	dcbcx_stats->seqno =
+			bfa_os_ntohl(dcbcx_stats->seqno);
+	dcbcx_stats->ackno =
+			bfa_os_ntohl(dcbcx_stats->ackno);
+	dcbcx_stats->recvd_seqno =
+			bfa_os_ntohl(dcbcx_stats->recvd_seqno);
+	dcbcx_stats->recvd_ackno =
+			bfa_os_ntohl(dcbcx_stats->recvd_ackno);
 }
 
 static void
 bfa_cee_format_lldp_stats(struct bfa_cee_lldp_stats_s *lldp_stats)
 {
 	lldp_stats->frames_transmitted =
-		bfa_os_ntohl(lldp_stats->frames_transmitted);
-	lldp_stats->frames_aged_out = bfa_os_ntohl(lldp_stats->frames_aged_out);
-	lldp_stats->frames_discarded =
-		bfa_os_ntohl(lldp_stats->frames_discarded);
-	lldp_stats->frames_in_error = bfa_os_ntohl(lldp_stats->frames_in_error);
-	lldp_stats->frames_rcvd = bfa_os_ntohl(lldp_stats->frames_rcvd);
-	lldp_stats->tlvs_discarded = bfa_os_ntohl(lldp_stats->tlvs_discarded);
-	lldp_stats->tlvs_unrecognized =
-		bfa_os_ntohl(lldp_stats->tlvs_unrecognized);
+			bfa_os_ntohl(lldp_stats->frames_transmitted);
+	lldp_stats->frames_aged_out    =
+			bfa_os_ntohl(lldp_stats->frames_aged_out);
+	lldp_stats->frames_discarded   =
+			bfa_os_ntohl(lldp_stats->frames_discarded);
+	lldp_stats->frames_in_error    =
+			bfa_os_ntohl(lldp_stats->frames_in_error);
+	lldp_stats->frames_rcvd        =
+			bfa_os_ntohl(lldp_stats->frames_rcvd);
+	lldp_stats->tlvs_discarded     =
+			bfa_os_ntohl(lldp_stats->tlvs_discarded);
+	lldp_stats->tlvs_unrecognized  =
+			bfa_os_ntohl(lldp_stats->tlvs_unrecognized);
 }
 
 static void
 bfa_cee_format_cfg_stats(struct bfa_cee_cfg_stats_s *cfg_stats)
 {
-	cfg_stats->cee_status_down = bfa_os_ntohl(cfg_stats->cee_status_down);
-	cfg_stats->cee_status_up = bfa_os_ntohl(cfg_stats->cee_status_up);
-	cfg_stats->cee_hw_cfg_changed =
-		bfa_os_ntohl(cfg_stats->cee_hw_cfg_changed);
-	cfg_stats->recvd_invalid_cfg =
-		bfa_os_ntohl(cfg_stats->recvd_invalid_cfg);
+	cfg_stats->cee_status_down         =
+			bfa_os_ntohl(cfg_stats->cee_status_down);
+	cfg_stats->cee_status_up           =
+			bfa_os_ntohl(cfg_stats->cee_status_up);
+	cfg_stats->cee_hw_cfg_changed      =
+			bfa_os_ntohl(cfg_stats->cee_hw_cfg_changed);
+	cfg_stats->recvd_invalid_cfg      =
+			bfa_os_ntohl(cfg_stats->recvd_invalid_cfg);
 }
 
 static void
 bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg)
 {
-	lldp_cfg->time_to_interval = bfa_os_ntohs(lldp_cfg->time_to_interval);
+	lldp_cfg->time_to_interval =
+			bfa_os_ntohs(lldp_cfg->time_to_interval);
 	lldp_cfg->enabled_system_cap =
-		bfa_os_ntohs(lldp_cfg->enabled_system_cap);
+			bfa_os_ntohs(lldp_cfg->enabled_system_cap);
 }
 
+
 /**
  * bfa_cee_attr_meminfo()
  *
@@ -114,12 +128,11 @@ bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg)
  *
  * @return Size of DMA region
  */
-static          u32
+static u32
 bfa_cee_attr_meminfo(void)
 {
 	return BFA_ROUNDUP(sizeof(struct bfa_cee_attr_s), BFA_DMA_ALIGN_SZ);
 }
-
 /**
  * bfa_cee_stats_meminfo()
  *
@@ -128,7 +141,7 @@ bfa_cee_attr_meminfo(void)
  *
  * @return Size of DMA region
  */
-static          u32
+static u32
 bfa_cee_stats_meminfo(void)
 {
 	return BFA_ROUNDUP(sizeof(struct bfa_cee_stats_s), BFA_DMA_ALIGN_SZ);
@@ -150,12 +163,11 @@ bfa_cee_get_attr_isr(struct bfa_cee_s *cee, bfa_status_t status)
 	bfa_trc(cee, 0);
 	if (status == BFA_STATUS_OK) {
 		bfa_trc(cee, 0);
-		/*
-		 * The requested data has been copied to the DMA area, *process
-		 * it.
+		/* The requested data has been copied to the DMA area,
+		 * process it.
 		 */
 		memcpy(cee->attr, cee->attr_dma.kva,
-		       sizeof(struct bfa_cee_attr_s));
+		    sizeof(struct bfa_cee_attr_s));
 		bfa_cee_format_cee_cfg(cee->attr);
 	}
 	cee->get_attr_pending = BFA_FALSE;
@@ -182,12 +194,11 @@ bfa_cee_get_stats_isr(struct bfa_cee_s *cee, bfa_status_t status)
 	bfa_trc(cee, 0);
 	if (status == BFA_STATUS_OK) {
 		bfa_trc(cee, 0);
-		/*
-		 * The requested data has been copied to the DMA area, process
-		 * it.
+		/* The requested data has been copied to the DMA area,
+		 * process it.
 		 */
 		memcpy(cee->stats, cee->stats_dma.kva,
-		       sizeof(struct bfa_cee_stats_s));
+					sizeof(struct bfa_cee_stats_s));
 		bfa_cee_format_cee_stats(cee->stats);
 	}
 	cee->get_stats_pending = BFA_FALSE;
@@ -216,7 +227,6 @@ bfa_cee_reset_stats_isr(struct bfa_cee_s *cee, bfa_status_t status)
 	if (cee->cbfn.reset_stats_cbfn)
 		cee->cbfn.reset_stats_cbfn(cee->cbfn.reset_stats_cbarg, status);
 }
-
 /**
  * bfa_cee_meminfo()
  *
@@ -236,8 +246,8 @@ bfa_cee_meminfo(void)
  *
  *
  * @param[in] cee CEE module pointer
- * 	      dma_kva Kernel Virtual Address of CEE DMA Memory
- * 	      dma_pa  Physical Address of CEE DMA Memory
+ *	      dma_kva Kernel Virtual Address of CEE DMA Memory
+ *	      dma_pa  Physical Address of CEE DMA Memory
  *
  * @return void
  */
@@ -248,9 +258,9 @@ bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva, u64 dma_pa)
 	cee->attr_dma.pa = dma_pa;
 	cee->stats_dma.kva = dma_kva + bfa_cee_attr_meminfo();
 	cee->stats_dma.pa = dma_pa + bfa_cee_attr_meminfo();
-	cee->attr = (struct bfa_cee_attr_s *)dma_kva;
+	cee->attr = (struct bfa_cee_attr_s *) dma_kva;
 	cee->stats =
-		(struct bfa_cee_stats_s *)(dma_kva + bfa_cee_attr_meminfo());
+		(struct bfa_cee_stats_s *) (dma_kva + bfa_cee_attr_meminfo());
 }
 
 /**
@@ -265,7 +275,7 @@ bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva, u64 dma_pa)
 
 bfa_status_t
 bfa_cee_get_attr(struct bfa_cee_s *cee, struct bfa_cee_attr_s *attr,
-		 bfa_cee_get_attr_cbfn_t cbfn, void *cbarg)
+		     bfa_cee_get_attr_cbfn_t cbfn, void *cbarg)
 {
 	struct bfi_cee_get_req_s *cmd;
 
@@ -277,15 +287,15 @@ bfa_cee_get_attr(struct bfa_cee_s *cee, struct bfa_cee_attr_s *attr,
 	}
 	if (cee->get_attr_pending == BFA_TRUE) {
 		bfa_trc(cee, 0);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 	cee->get_attr_pending = BFA_TRUE;
-	cmd = (struct bfi_cee_get_req_s *)cee->get_cfg_mb.msg;
+	cmd = (struct bfi_cee_get_req_s *) cee->get_cfg_mb.msg;
 	cee->attr = attr;
 	cee->cbfn.get_attr_cbfn = cbfn;
 	cee->cbfn.get_attr_cbarg = cbarg;
 	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_GET_CFG_REQ,
-		    bfa_ioc_portid(cee->ioc));
+	    bfa_ioc_portid(cee->ioc));
 	bfa_dma_be_addr_set(cmd->dma_addr, cee->attr_dma.pa);
 	bfa_ioc_mbox_queue(cee->ioc, &cee->get_cfg_mb);
 	bfa_trc(cee, 0);
@@ -305,7 +315,7 @@ bfa_cee_get_attr(struct bfa_cee_s *cee, struct bfa_cee_attr_s *attr,
 
 bfa_status_t
 bfa_cee_get_stats(struct bfa_cee_s *cee, struct bfa_cee_stats_s *stats,
-		  bfa_cee_get_stats_cbfn_t cbfn, void *cbarg)
+		      bfa_cee_get_stats_cbfn_t cbfn, void *cbarg)
 {
 	struct bfi_cee_get_req_s *cmd;
 
@@ -317,15 +327,15 @@ bfa_cee_get_stats(struct bfa_cee_s *cee, struct bfa_cee_stats_s *stats,
 	}
 	if (cee->get_stats_pending == BFA_TRUE) {
 		bfa_trc(cee, 0);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 	cee->get_stats_pending = BFA_TRUE;
-	cmd = (struct bfi_cee_get_req_s *)cee->get_stats_mb.msg;
+	cmd = (struct bfi_cee_get_req_s *) cee->get_stats_mb.msg;
 	cee->stats = stats;
 	cee->cbfn.get_stats_cbfn = cbfn;
 	cee->cbfn.get_stats_cbarg = cbarg;
 	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_GET_STATS_REQ,
-		    bfa_ioc_portid(cee->ioc));
+	    bfa_ioc_portid(cee->ioc));
 	bfa_dma_be_addr_set(cmd->dma_addr, cee->stats_dma.pa);
 	bfa_ioc_mbox_queue(cee->ioc, &cee->get_stats_mb);
 	bfa_trc(cee, 0);
@@ -344,7 +354,7 @@ bfa_cee_get_stats(struct bfa_cee_s *cee, struct bfa_cee_stats_s *stats,
 
 bfa_status_t
 bfa_cee_reset_stats(struct bfa_cee_s *cee, bfa_cee_reset_stats_cbfn_t cbfn,
-		    void *cbarg)
+			void *cbarg)
 {
 	struct bfi_cee_reset_stats_s *cmd;
 
@@ -355,19 +365,20 @@ bfa_cee_reset_stats(struct bfa_cee_s *cee, bfa_cee_reset_stats_cbfn_t cbfn,
 	}
 	if (cee->reset_stats_pending == BFA_TRUE) {
 		bfa_trc(cee, 0);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 	cee->reset_stats_pending = BFA_TRUE;
-	cmd = (struct bfi_cee_reset_stats_s *)cee->reset_stats_mb.msg;
+	cmd = (struct bfi_cee_reset_stats_s *) cee->reset_stats_mb.msg;
 	cee->cbfn.reset_stats_cbfn = cbfn;
 	cee->cbfn.reset_stats_cbarg = cbarg;
 	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_RESET_STATS,
-		    bfa_ioc_portid(cee->ioc));
+	    bfa_ioc_portid(cee->ioc));
 	bfa_ioc_mbox_queue(cee->ioc, &cee->reset_stats_mb);
 	bfa_trc(cee, 0);
 	return BFA_STATUS_OK;
 }
 
+
 /**
  * bfa_cee_isrs()
  *
@@ -382,9 +393,9 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
 	union bfi_cee_i2h_msg_u *msg;
 	struct bfi_cee_get_rsp_s *get_rsp;
-	struct bfa_cee_s *cee = (struct bfa_cee_s *)cbarg;
-	msg = (union bfi_cee_i2h_msg_u *)m;
-	get_rsp = (struct bfi_cee_get_rsp_s *)m;
+	struct bfa_cee_s *cee = (struct bfa_cee_s *) cbarg;
+	msg = (union bfi_cee_i2h_msg_u *) m;
+	get_rsp = (struct bfi_cee_get_rsp_s *) m;
 	bfa_trc(cee, msg->mh.msg_id);
 	switch (msg->mh.msg_id) {
 	case BFI_CEE_I2H_GET_CFG_RSP:
@@ -415,30 +426,30 @@ void
 bfa_cee_hbfail(void *arg)
 {
 	struct bfa_cee_s *cee;
-	cee = (struct bfa_cee_s *)arg;
+	cee = (struct bfa_cee_s *) arg;
 
 	if (cee->get_attr_pending == BFA_TRUE) {
 		cee->get_attr_status = BFA_STATUS_FAILED;
-		cee->get_attr_pending = BFA_FALSE;
+		cee->get_attr_pending  = BFA_FALSE;
 		if (cee->cbfn.get_attr_cbfn) {
 			cee->cbfn.get_attr_cbfn(cee->cbfn.get_attr_cbarg,
-						BFA_STATUS_FAILED);
+			    BFA_STATUS_FAILED);
 		}
 	}
 	if (cee->get_stats_pending == BFA_TRUE) {
 		cee->get_stats_status = BFA_STATUS_FAILED;
-		cee->get_stats_pending = BFA_FALSE;
+		cee->get_stats_pending  = BFA_FALSE;
 		if (cee->cbfn.get_stats_cbfn) {
 			cee->cbfn.get_stats_cbfn(cee->cbfn.get_stats_cbarg,
-						 BFA_STATUS_FAILED);
+			    BFA_STATUS_FAILED);
 		}
 	}
 	if (cee->reset_stats_pending == BFA_TRUE) {
 		cee->reset_stats_status = BFA_STATUS_FAILED;
-		cee->reset_stats_pending = BFA_FALSE;
+		cee->reset_stats_pending  = BFA_FALSE;
 		if (cee->cbfn.reset_stats_cbfn) {
 			cee->cbfn.reset_stats_cbfn(cee->cbfn.reset_stats_cbarg,
-						   BFA_STATUS_FAILED);
+			    BFA_STATUS_FAILED);
 		}
 	}
 }
@@ -458,8 +469,10 @@ bfa_cee_hbfail(void *arg)
  * @return void
  */
 void
-bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
-	       struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod)
+bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc,
+		void *dev,
+		struct bfa_trc_mod_s *trcmod,
+		struct bfa_log_mod_s *logmod)
 {
 	bfa_assert(cee != NULL);
 	cee->dev = dev;
@@ -484,9 +497,7 @@ bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
 void
 bfa_cee_detach(struct bfa_cee_s *cee)
 {
-	/*
-	 * For now, just check if there is some ioctl pending and mark that as
-	 * failed?
-	 */
-	/* bfa_cee_hbfail(cee); */
+	/*For now, just check if there is some ioctl pending
+	 *and mark that as failed?*/
+	 /* bfa_cee_hbfail(cee); */
 }
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 44e2d11..08409f7 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -385,6 +385,15 @@ bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
 }
 
 /**
+ * Clear the saved firmware trace information of an IOC.
+ */
+void
+bfa_debug_fwsave_clear(struct bfa_s *bfa)
+{
+	bfa_ioc_debug_fwsave_clear(&bfa->ioc);
+}
+
+/**
  * 		Fetch firmware trace data.
  *
  * @param[in]		bfa			BFA instance
@@ -399,4 +408,16 @@ bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
 {
 	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
 }
+
+/**
+ * Reset hw semaphore & usage cnt regs and initialize.
+ */
+void
+bfa_chip_reset(struct bfa_s *bfa)
+{
+	bfa_ioc_ownership_reset(&bfa->ioc);
+	bfa_ioc_pll_init(&bfa->ioc);
+}
+
 #endif
+
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 7cb39a3..9635204 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -36,19 +36,18 @@
  * FCS sub-modules
  */
 struct bfa_fcs_mod_s {
-	void            (*modinit) (struct bfa_fcs_s *fcs);
-	void            (*modexit) (struct bfa_fcs_s *fcs);
+	void		(*attach) (struct bfa_fcs_s *fcs);
+	void		(*modinit) (struct bfa_fcs_s *fcs);
+	void		(*modexit) (struct bfa_fcs_s *fcs);
 };
 
 #define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
 
 static struct bfa_fcs_mod_s fcs_modules[] = {
-	BFA_FCS_MODULE(bfa_fcs_pport),
-	BFA_FCS_MODULE(bfa_fcs_uf),
-	BFA_FCS_MODULE(bfa_fcs_fabric),
-	BFA_FCS_MODULE(bfa_fcs_vport),
-	BFA_FCS_MODULE(bfa_fcs_rport),
-	BFA_FCS_MODULE(bfa_fcs_fcpim),
+	{ bfa_fcs_pport_attach, NULL, NULL },
+	{ bfa_fcs_uf_attach, NULL, NULL },
+	{ bfa_fcs_fabric_attach, bfa_fcs_fabric_modinit,
+	  bfa_fcs_fabric_modexit },
 };
 
 /**
@@ -58,7 +57,7 @@ static struct bfa_fcs_mod_s fcs_modules[] = {
 static void
 bfa_fcs_exit_comp(void *fcs_cbarg)
 {
-	struct bfa_fcs_s *fcs = fcs_cbarg;
+	struct bfa_fcs_s      *fcs = fcs_cbarg;
 	struct bfad_s *bfad = fcs->bfad;
 
 	complete(&bfad->comp);
@@ -71,19 +70,13 @@ bfa_fcs_exit_comp(void *fcs_cbarg)
  */
 
 /**
- * 		FCS instance initialization.
- *
- * 	param[in]		fcs		FCS instance
- * 	param[in]		bfa		BFA instance
- * 	param[in]		bfad		BFA driver instance
- *
- * 	return None
+ * fcs attach -- called once to initialize data structures at driver attach time
  */
 void
-bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
-			bfa_boolean_t min_cfg)
+bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+	       bfa_boolean_t min_cfg)
 {
-	int             i;
+	int		i;
 	struct bfa_fcs_mod_s  *mod;
 
 	fcs->bfa = bfa;
@@ -95,7 +88,24 @@ bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 
 	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
 		mod = &fcs_modules[i];
-		mod->modinit(fcs);
+		if (mod->attach)
+			mod->attach(fcs);
+	}
+}
+
+/**
+ * fcs initialization, called once after bfa initialization is complete
+ */
+void
+bfa_fcs_init(struct bfa_fcs_s *fcs)
+{
+	int		i;
+	struct bfa_fcs_mod_s  *mod;
+
+	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+		mod = &fcs_modules[i];
+		if (mod->modinit)
+			mod->modinit(fcs);
 	}
 }
 
@@ -109,16 +119,17 @@ bfa_fcs_start(struct bfa_fcs_s *fcs)
 }
 
 /**
- * 		FCS driver details initialization.
+ *	brief
+ *		FCS driver details initialization.
  *
- * 	param[in]		fcs		FCS instance
- * 	param[in]		driver_info	Driver Details
+ *	param[in]		fcs		FCS instance
+ *	param[in]		driver_info	Driver Details
  *
- * 	return None
+ *	return None
  */
 void
 bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
-			struct bfa_fcs_driver_info_s *driver_info)
+				struct bfa_fcs_driver_info_s *driver_info)
 {
 
 	fcs->driver_info = *driver_info;
@@ -127,26 +138,45 @@ bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 }
 
 /**
- * 		FCS instance cleanup and exit.
+ *	brief
+ *		FCS FDMI Driver Parameter Initialization
+ *
+ *	param[in]		fcs		FCS instance
+ *	param[in]		fdmi_enable	TRUE/FALSE
+ *
+ *	return None
+ */
+void
+bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable)
+{
+
+	fcs->fdmi_enabled = fdmi_enable;
+
+}
+/**
+ *	brief
+ *		FCS instance cleanup and exit.
  *
- * 	param[in]		fcs			FCS instance
- * 	return None
+ *	param[in]		fcs			FCS instance
+ *	return None
  */
 void
 bfa_fcs_exit(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_mod_s  *mod;
-	int             nmods, i;
+	int		nmods, i;
 
 	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
 
 	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
 
 	for (i = 0; i < nmods; i++) {
-		bfa_wc_up(&fcs->wc);
 
 		mod = &fcs_modules[i];
-		mod->modexit(fcs);
+		if (mod->modexit) {
+			bfa_wc_up(&fcs->wc);
+			mod->modexit(fcs);
+		}
 	}
 
 	bfa_wc_wait(&fcs->wc);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index c7ab257..4cb6202 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -43,11 +43,11 @@ BFA_TRC_FILE(FCS, PORT);
 static void     bfa_fcs_port_aen_post(struct bfa_fcs_port_s *port,
 				      enum bfa_lport_aen_event event);
 static void     bfa_fcs_port_send_ls_rjt(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs, u8 reason_code,
-			u8 reason_code_expl);
+					 struct fchs_s *rx_fchs, u8 reason_code,
+					 u8 reason_code_expl);
 static void     bfa_fcs_port_plogi(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs,
-			struct fc_logi_s *plogi);
+				struct fchs_s *rx_fchs,
+				   struct fc_logi_s *plogi);
 static void     bfa_fcs_port_online_actions(struct bfa_fcs_port_s *port);
 static void     bfa_fcs_port_offline_actions(struct bfa_fcs_port_s *port);
 static void     bfa_fcs_port_unknown_init(struct bfa_fcs_port_s *port);
@@ -55,13 +55,14 @@ static void     bfa_fcs_port_unknown_online(struct bfa_fcs_port_s *port);
 static void     bfa_fcs_port_unknown_offline(struct bfa_fcs_port_s *port);
 static void     bfa_fcs_port_deleted(struct bfa_fcs_port_s *port);
 static void     bfa_fcs_port_echo(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs,
-			struct fc_echo_s *echo, u16 len);
+					struct fchs_s *rx_fchs,
+				  struct fc_echo_s *echo, u16 len);
 static void     bfa_fcs_port_rnid(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs,
-			struct fc_rnid_cmd_s *rnid, u16 len);
+					struct fchs_s *rx_fchs,
+				  struct fc_rnid_cmd_s *rnid, u16 len);
 static void     bfa_fs_port_get_gen_topo_data(struct bfa_fcs_port_s *port,
-			struct fc_rnid_general_topology_data_s *gen_topo_data);
+			struct fc_rnid_general_topology_data_s *
+					      gen_topo_data);
 
 static struct {
 	void            (*init) (struct bfa_fcs_port_s *port);
@@ -75,7 +76,7 @@ static struct {
 			bfa_fcs_port_fab_offline}, {
 	bfa_fcs_port_loop_init, bfa_fcs_port_loop_online,
 			bfa_fcs_port_loop_offline}, {
-bfa_fcs_port_n2n_init, bfa_fcs_port_n2n_online,
+	bfa_fcs_port_n2n_init, bfa_fcs_port_n2n_online,
 			bfa_fcs_port_n2n_offline},};
 
 /**
@@ -114,12 +115,13 @@ bfa_fcs_port_sm_uninit(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
-bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port, enum bfa_fcs_port_event event)
+bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port,
+			enum bfa_fcs_port_event event)
 {
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 	bfa_trc(port->fcs, event);
@@ -136,16 +138,16 @@ bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port, enum bfa_fcs_port_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
-			enum bfa_fcs_port_event event)
+				enum bfa_fcs_port_event event)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe, *qen;
+	struct list_head        *qe, *qen;
 
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 	bfa_trc(port->fcs, event);
@@ -166,7 +168,7 @@ bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
 		} else {
 			bfa_sm_set_state(port, bfa_fcs_port_sm_deleting);
 			list_for_each_safe(qe, qen, &port->rport_q) {
-				rport = (struct bfa_fcs_rport_s *)qe;
+				rport = (struct bfa_fcs_rport_s *) qe;
 				bfa_fcs_rport_delete(rport);
 			}
 		}
@@ -176,7 +178,7 @@ bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -185,7 +187,7 @@ bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
 			enum bfa_fcs_port_event event)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe, *qen;
+	struct list_head        *qe, *qen;
 
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 	bfa_trc(port->fcs, event);
@@ -203,7 +205,7 @@ bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
 		} else {
 			bfa_sm_set_state(port, bfa_fcs_port_sm_deleting);
 			list_for_each_safe(qe, qen, &port->rport_q) {
-				rport = (struct bfa_fcs_rport_s *)qe;
+				rport = (struct bfa_fcs_rport_s *) qe;
 				bfa_fcs_rport_delete(rport);
 			}
 		}
@@ -214,13 +216,13 @@ bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
-			 enum bfa_fcs_port_event event)
+			enum bfa_fcs_port_event event)
 {
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 	bfa_trc(port->fcs, event);
@@ -234,7 +236,7 @@ bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -249,49 +251,26 @@ bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
  */
 static void
 bfa_fcs_port_aen_post(struct bfa_fcs_port_s *port,
-		      enum bfa_lport_aen_event event)
+			enum bfa_lport_aen_event event)
 {
-	union bfa_aen_data_u aen_data;
+	union bfa_aen_data_u  aen_data;
 	struct bfa_log_mod_s *logmod = port->fcs->logm;
 	enum bfa_port_role role = port->port_cfg.roles;
-	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(port);
-	char            lpwwn_ptr[BFA_STRING_32];
-	char           *role_str[BFA_PORT_ROLE_FCP_MAX / 2 + 1] =
-		{ "Initiator", "Target", "IPFC" };
+	wwn_t		lpwwn = bfa_fcs_port_get_pwwn(port);
+	char		lpwwn_ptr[BFA_STRING_32];
+	char		*role_str[BFA_PORT_ROLE_FCP_MAX/2 + 1] =
+				{"Initiator", "Target", "IPFC"};
 
 	wwn2str(lpwwn_ptr, lpwwn);
 
 	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
-
-	switch (event) {
-	case BFA_LPORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_LPORT_ONLINE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_LPORT_OFFLINE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NEW:
-		bfa_log(logmod, BFA_AEN_LPORT_NEW, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_DELETE:
-		bfa_log(logmod, BFA_AEN_LPORT_DELETE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_LPORT_DISCONNECT, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, event), lpwwn_ptr,
+			role_str[role/2]);
 
 	aen_data.lport.vf_id = port->fabric->vf_id;
 	aen_data.lport.roles = role;
 	aen_data.lport.ppwwn =
-		bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(port->fcs));
+			bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(port->fcs));
 	aen_data.lport.lpwwn = lpwwn;
 }
 
@@ -313,13 +292,13 @@ bfa_fcs_port_send_ls_rjt(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 	if (!fcxp)
 		return;
 
-	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
-			      reason_code, reason_code_expl);
+	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+			      rx_fchs->ox_id, reason_code, reason_code_expl);
 
 	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
-		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
-		      FC_MAX_PDUSZ, 0);
+			  BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+			  FC_MAX_PDUSZ, 0);
 }
 
 /**
@@ -354,23 +333,19 @@ bfa_fcs_port_plogi(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 	}
 
 	/**
-* Direct Attach P2P mode : verify address assigned by the r-port.
+	 * Direct Attach P2P mode : verify address assigned by the r-port.
 	 */
-	if ((!bfa_fcs_fabric_is_switched(port->fabric))
-	    &&
-	    (memcmp
-	     ((void *)&bfa_fcs_port_get_pwwn(port), (void *)&plogi->port_name,
-	      sizeof(wwn_t)) < 0)) {
+	if ((!bfa_fcs_fabric_is_switched(port->fabric)) &&
+			(memcmp((void *)&bfa_fcs_port_get_pwwn(port),
+			   (void *)&plogi->port_name, sizeof(wwn_t)) < 0)) {
 		if (BFA_FCS_PID_IS_WKA(rx_fchs->d_id)) {
-			/*
-			 * Address assigned to us cannot be a WKA
-			 */
+			/* Address assigned to us cannot be a WKA */
 			bfa_fcs_port_send_ls_rjt(port, rx_fchs,
 					FC_LS_RJT_RSN_PROTOCOL_ERROR,
 					FC_LS_RJT_EXP_INVALID_NPORT_ID);
 			return;
 		}
-		port->pid = rx_fchs->d_id;
+		port->pid  = rx_fchs->d_id;
 	}
 
 	/**
@@ -379,15 +354,13 @@ bfa_fcs_port_plogi(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 	rport = bfa_fcs_port_get_rport_by_pwwn(port, plogi->port_name);
 	if (rport) {
 		/**
-		 * Direct Attach P2P mode: handle address assigned by the rport.
+		 * Direct Attach P2P mode : handle address assigned by the r-port.
 		 */
-		if ((!bfa_fcs_fabric_is_switched(port->fabric))
-		    &&
-		    (memcmp
-		     ((void *)&bfa_fcs_port_get_pwwn(port),
-		      (void *)&plogi->port_name, sizeof(wwn_t)) < 0)) {
-			port->pid = rx_fchs->d_id;
-			rport->pid = rx_fchs->s_id;
+		if ((!bfa_fcs_fabric_is_switched(port->fabric)) &&
+			(memcmp((void *)&bfa_fcs_port_get_pwwn(port),
+			(void *)&plogi->port_name, sizeof(wwn_t)) < 0)) {
+				port->pid  = rx_fchs->d_id;
+				rport->pid = rx_fchs->s_id;
 		}
 		bfa_fcs_rport_plogi(rport, rx_fchs, plogi);
 		return;
@@ -436,7 +409,7 @@ bfa_fcs_port_plogi(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
  */
 static void
 bfa_fcs_port_echo(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
-			struct fc_echo_s *echo, u16 rx_len)
+		struct fc_echo_s *echo, u16 rx_len)
 {
 	struct fchs_s          fchs;
 	struct bfa_fcxp_s *fcxp;
@@ -451,8 +424,9 @@ bfa_fcs_port_echo(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 	if (!fcxp)
 		return;
 
-	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id);
+	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+			      rx_fchs->ox_id);
 
 	/*
 	 * Copy the payload (if any) from the echo frame
@@ -466,8 +440,8 @@ bfa_fcs_port_echo(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 		       (pyld_len - sizeof(struct fc_echo_s)));
 
 	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
-		      BFA_FALSE, FC_CLASS_3, pyld_len, &fchs, NULL, NULL,
-		      FC_MAX_PDUSZ, 0);
+			  BFA_FALSE, FC_CLASS_3, pyld_len, &fchs, NULL, NULL,
+			  FC_MAX_PDUSZ, 0);
 }
 
 /*
@@ -517,13 +491,14 @@ bfa_fcs_port_rnid(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
 	common_id_data.port_name = bfa_fcs_port_get_pwwn(port);
 	common_id_data.node_name = bfa_fcs_port_get_nwwn(port);
 
-	len = fc_rnid_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
-				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
-				data_format, &common_id_data, &gen_topo_data);
+	len = fc_rnid_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				rx_fchs->s_id, bfa_fcs_port_get_fcid(port),
+				rx_fchs->ox_id, data_format, &common_id_data,
+				&gen_topo_data);
 
 	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
-		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
-		      FC_MAX_PDUSZ, 0);
+			  BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+			  FC_MAX_PDUSZ, 0);
 
 	return;
 }
@@ -533,7 +508,7 @@ bfa_fcs_port_rnid(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
  */
 static void
 bfa_fs_port_get_gen_topo_data(struct bfa_fcs_port_s *port,
-			struct fc_rnid_general_topology_data_s *gen_topo_data)
+	struct fc_rnid_general_topology_data_s *gen_topo_data)
 {
 
 	bfa_os_memset(gen_topo_data, 0,
@@ -554,14 +529,15 @@ bfa_fcs_port_online_actions(struct bfa_fcs_port_s *port)
 
 	bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_ONLINE);
 	bfa_fcb_port_online(port->fcs->bfad, port->port_cfg.roles,
-			port->fabric->vf_drv, (port->vport == NULL) ?
-			NULL : port->vport->vport_drv);
+			    port->fabric->vf_drv,
+			    (port->vport == NULL) ?
+				 NULL : port->vport->vport_drv);
 }
 
 static void
 bfa_fcs_port_offline_actions(struct bfa_fcs_port_s *port)
 {
-	struct list_head *qe, *qen;
+	struct list_head        *qe, *qen;
 	struct bfa_fcs_rport_s *rport;
 
 	bfa_trc(port->fcs, port->fabric->oper_type);
@@ -572,12 +548,14 @@ bfa_fcs_port_offline_actions(struct bfa_fcs_port_s *port)
 		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_DISCONNECT);
 	else
 		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_OFFLINE);
+
 	bfa_fcb_port_offline(port->fcs->bfad, port->port_cfg.roles,
-			port->fabric->vf_drv,
-			(port->vport == NULL) ? NULL : port->vport->vport_drv);
+			     port->fabric->vf_drv,
+			     (port->vport == NULL) ?
+				 NULL : port->vport->vport_drv);
 
 	list_for_each_safe(qe, qen, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		bfa_fcs_rport_offline(rport);
 	}
 }
@@ -605,16 +583,14 @@ bfa_fcs_port_deleted(struct bfa_fcs_port_s *port)
 {
 	bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_DELETE);
 
-	/*
-	 * Base port will be deleted by the OS driver
-	 */
+	/* Base port will be deleted by the OS driver */
 	if (port->vport) {
 		bfa_fcb_port_delete(port->fcs->bfad, port->port_cfg.roles,
-			port->fabric->vf_drv,
-			port->vport ? port->vport->vport_drv : NULL);
+				port->fabric->vf_drv,
+				port->vport ? port->vport->vport_drv : NULL);
 		bfa_fcs_vport_delete_comp(port->vport);
 	} else {
-		bfa_fcs_fabric_port_delete_comp(port->fabric);
+		 bfa_fcs_fabric_port_delete_comp(port->fabric);
 	}
 }
 
@@ -646,7 +622,7 @@ bfa_fcs_port_modexit(struct bfa_fcs_s *fcs)
  */
 void
 bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
-			u16 len)
+				u16 len)
 {
 	u32        pid = fchs->s_id;
 	struct bfa_fcs_rport_s *rport = NULL;
@@ -676,7 +652,7 @@ bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
 	 */
 	if ((fchs->type == FC_TYPE_ELS) && (els_cmd->els_code == FC_ELS_ECHO)) {
 		bfa_fcs_port_echo(lport, fchs,
-			(struct fc_echo_s *) els_cmd, len);
+					(struct fc_echo_s *) els_cmd, len);
 		return;
 	}
 
@@ -685,7 +661,7 @@ bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
 	 */
 	if ((fchs->type == FC_TYPE_ELS) && (els_cmd->els_code == FC_ELS_RNID)) {
 		bfa_fcs_port_rnid(lport, fchs,
-			(struct fc_rnid_cmd_s *) els_cmd, len);
+					(struct fc_rnid_cmd_s *) els_cmd, len);
 		return;
 	}
 
@@ -748,10 +724,10 @@ struct bfa_fcs_rport_s *
 bfa_fcs_port_get_rport_by_pid(struct bfa_fcs_port_s *port, u32 pid)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe;
+	struct list_head        *qe;
 
 	list_for_each(qe, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		if (rport->pid == pid)
 			return rport;
 	}
@@ -767,10 +743,10 @@ struct bfa_fcs_rport_s *
 bfa_fcs_port_get_rport_by_pwwn(struct bfa_fcs_port_s *port, wwn_t pwwn)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe;
+	struct list_head        *qe;
 
 	list_for_each(qe, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		if (wwn_is_equal(rport->pwwn, pwwn))
 			return rport;
 	}
@@ -786,10 +762,10 @@ struct bfa_fcs_rport_s *
 bfa_fcs_port_get_rport_by_nwwn(struct bfa_fcs_port_s *port, wwn_t nwwn)
 {
 	struct bfa_fcs_rport_s *rport;
-	struct list_head *qe;
+	struct list_head        *qe;
 
 	list_for_each(qe, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		if (wwn_is_equal(rport->nwwn, nwwn))
 			return rport;
 	}
@@ -803,7 +779,7 @@ bfa_fcs_port_get_rport_by_nwwn(struct bfa_fcs_port_s *port, wwn_t nwwn)
  */
 void
 bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
-		       struct bfa_fcs_rport_s *rport)
+			struct bfa_fcs_rport_s *rport)
 {
 	list_add_tail(&rport->qe, &port->rport_q);
 	port->num_rports++;
@@ -814,7 +790,7 @@ bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
  */
 void
 bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
-		       struct bfa_fcs_rport_s *rport)
+			struct bfa_fcs_rport_s *rport)
 {
 	bfa_assert(bfa_q_is_on_q(&port->rport_q, rport));
 	list_del(&rport->qe);
@@ -873,28 +849,41 @@ bfa_fcs_port_is_online(struct bfa_fcs_port_s *port)
 }
 
 /**
- * Logical port initialization of base or virtual port.
- * Called by fabric for base port or by vport for virtual ports.
+  * Attach time initialization of logical ports.
  */
 void
-bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
-		   u16 vf_id, struct bfa_port_cfg_s *port_cfg,
-		   struct bfa_fcs_vport_s *vport)
+bfa_fcs_lport_attach(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+		   u16 vf_id, struct bfa_fcs_vport_s *vport)
 {
 	lport->fcs = fcs;
 	lport->fabric = bfa_fcs_vf_lookup(fcs, vf_id);
-	bfa_os_assign(lport->port_cfg, *port_cfg);
 	lport->vport = vport;
 	lport->lp_tag = (vport) ? bfa_lps_get_tag(vport->lps) :
-			 bfa_lps_get_tag(lport->fabric->lps);
+				  bfa_lps_get_tag(lport->fabric->lps);
 
 	INIT_LIST_HEAD(&lport->rport_q);
 	lport->num_rports = 0;
+}
+
+/**
+ * Logical port initialization of base or virtual port.
+ * Called by fabric for base port or by vport for virtual ports.
+ */
+
+void
+bfa_fcs_lport_init(struct bfa_fcs_port_s *lport,
+					struct bfa_port_cfg_s *port_cfg)
+{
+
+	struct bfa_fcs_vport_s *vport = lport->vport;
+
+	bfa_os_assign(lport->port_cfg, *port_cfg);
+
+	lport->bfad_port = bfa_fcb_port_new(lport->fcs->bfad, lport,
+					lport->port_cfg.roles,
+					lport->fabric->vf_drv,
+					vport ? vport->vport_drv : NULL);
 
-	lport->bfad_port =
-		bfa_fcb_port_new(fcs->bfad, lport, lport->port_cfg.roles,
-				lport->fabric->vf_drv,
-				vport ? vport->vport_drv : NULL);
 	bfa_fcs_port_aen_post(lport, BFA_LPORT_AEN_NEW);
 
 	bfa_sm_set_state(lport, bfa_fcs_port_sm_uninit);
@@ -909,7 +898,7 @@ bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
 
 void
 bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
-		      struct bfa_port_attr_s *port_attr)
+			struct bfa_port_attr_s *port_attr)
 {
 	if (bfa_sm_cmp_state(port, bfa_fcs_port_sm_online))
 		port_attr->pid = port->pid;
@@ -921,19 +910,25 @@ bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
 	if (port->fabric) {
 		port_attr->port_type = bfa_fcs_fabric_port_type(port->fabric);
 		port_attr->loopback = bfa_fcs_fabric_is_loopback(port->fabric);
-		port_attr->fabric_name = bfa_fcs_port_get_fabric_name(port);
+		port_attr->authfail =
+				bfa_fcs_fabric_is_auth_failed(port->fabric);
+		port_attr->fabric_name  = bfa_fcs_port_get_fabric_name(port);
 		memcpy(port_attr->fabric_ip_addr,
-		       bfa_fcs_port_get_fabric_ipaddr(port),
-		       BFA_FCS_FABRIC_IPADDR_SZ);
+			bfa_fcs_port_get_fabric_ipaddr(port),
+			BFA_FCS_FABRIC_IPADDR_SZ);
 
-		if (port->vport != NULL)
+		if (port->vport != NULL) {
 			port_attr->port_type = BFA_PPORT_TYPE_VPORT;
+			port_attr->fpma_mac =
+				bfa_lps_get_lp_mac(port->vport->lps);
+		} else
+			port_attr->fpma_mac =
+				bfa_lps_get_lp_mac(port->fabric->lps);
 
 	} else {
 		port_attr->port_type = BFA_PPORT_TYPE_UNKNOWN;
 		port_attr->state = BFA_PORT_UNINIT;
 	}
-
 }
 
 
diff --git a/drivers/scsi/bfa/bfa_fcs_port.c b/drivers/scsi/bfa/bfa_fcs_port.c
index 9c4b24e..6d2850d 100644
--- a/drivers/scsi/bfa/bfa_fcs_port.c
+++ b/drivers/scsi/bfa/bfa_fcs_port.c
@@ -55,14 +55,8 @@ bfa_fcs_pport_event_handler(void *cbarg, bfa_pport_event_t event)
 }
 
 void
-bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_pport_attach(struct bfa_fcs_s *fcs)
 {
-	bfa_pport_event_register(fcs->bfa, bfa_fcs_pport_event_handler,
-				     fcs);
+	bfa_fcport_event_register(fcs->bfa, bfa_fcs_pport_event_handler, fcs);
 }
 
-void
-bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
diff --git a/drivers/scsi/bfa/bfa_fcs_uf.c b/drivers/scsi/bfa/bfa_fcs_uf.c
index ad01db6..120694a 100644
--- a/drivers/scsi/bfa/bfa_fcs_uf.c
+++ b/drivers/scsi/bfa/bfa_fcs_uf.c
@@ -30,7 +30,7 @@
 BFA_TRC_FILE(FCS, UF);
 
 /**
- * 		BFA callback for unsolicited frame receive handler.
+ *		BFA callback for unsolicited frame receive handler.
  *
  * @param[in]		cbarg		callback arg for receive handler
  * @param[in]		uf		unsolicited frame descriptor
@@ -41,8 +41,8 @@ static void
 bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 {
 	struct bfa_fcs_s      *fcs = (struct bfa_fcs_s *) cbarg;
-	struct fchs_s         *fchs = bfa_uf_get_frmbuf(uf);
-	u16        len = bfa_uf_get_frmlen(uf);
+	struct fchs_s	       *fchs = bfa_uf_get_frmbuf(uf);
+	u16	len = bfa_uf_get_frmlen(uf);
 	struct fc_vft_s       *vft;
 	struct bfa_fcs_fabric_s *fabric;
 
@@ -50,7 +50,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 	 * check for VFT header
 	 */
 	if (fchs->routing == FC_RTG_EXT_HDR &&
-		fchs->cat_info == FC_CAT_VFT_HDR) {
+	    fchs->cat_info == FC_CAT_VFT_HDR) {
 		bfa_stats(fcs, uf.tagged);
 		vft = bfa_uf_get_frmbuf(uf);
 		if (fcs->port_vfid == vft->vf_id)
@@ -93,13 +93,8 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 }
 
 void
-bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_uf_attach(struct bfa_fcs_s *fcs)
 {
 	bfa_uf_recv_register(fcs->bfa, bfa_fcs_uf_recv, fcs);
 }
 
-void
-bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
diff --git a/drivers/scsi/bfa/bfa_fcxp.c b/drivers/scsi/bfa/bfa_fcxp.c
index cf0ad67..b1cc74e 100644
--- a/drivers/scsi/bfa/bfa_fcxp.c
+++ b/drivers/scsi/bfa/bfa_fcxp.c
@@ -324,12 +324,15 @@ hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen, struct bfa_fcxp_s *fcxp,
 				*((u32 *) BFA_FCXP_REQ_PLD(fcxp));
 
 			bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_FCXP,
-				BFA_PL_EID_TX,
-				reqlen + sizeof(struct fchs_s), fchs, pld_w0);
+					      BFA_PL_EID_TX,
+					      reqlen + sizeof(struct fchs_s),
+						fchs,
+					      pld_w0);
 		} else {
 			bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP,
-				BFA_PL_EID_TX, reqlen + sizeof(struct fchs_s),
-				fchs);
+				       BFA_PL_EID_TX,
+					reqlen + sizeof(struct fchs_s),
+				       fchs);
 		}
 	} else {
 		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP, BFA_PL_EID_TX,
@@ -386,7 +389,7 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 	struct bfa_s      		*bfa = fcxp->fcxp_mod->bfa;
 	struct bfa_fcxp_req_info_s	*reqi = &fcxp->req_info;
 	struct bfa_fcxp_rsp_info_s	*rspi = &fcxp->rsp_info;
-	struct bfa_rport_s		*rport = reqi->bfa_rport;
+	struct bfa_rport_s			*rport = reqi->bfa_rport;
 
 	bfi_h2i_set(send_req->mh, BFI_MC_FCXP, BFI_FCXP_H2I_SEND_REQ,
 			bfa_lpuid(bfa));
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index ede1438..4905c0e 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -23,7 +23,7 @@ bfa_hwcb_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
 	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
-	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
 		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
@@ -53,6 +53,18 @@ bfa_hwcb_reginit(struct bfa_s *bfa)
 }
 
 void
+bfa_hwcb_reqq_ack(struct bfa_s *bfa, int reqq)
+{
+}
+
+static void
+bfa_hwcb_reqq_ack_msix(struct bfa_s *bfa, int reqq)
+{
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+		__HFN_INT_CPE_Q0 << CPE_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), reqq));
+}
+
+void
 bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq)
 {
 }
@@ -136,6 +148,7 @@ bfa_hwcb_msix_uninstall(struct bfa_s *bfa)
 void
 bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
 {
+	bfa->iocfc.hwif.hw_reqq_ack = bfa_hwcb_reqq_ack_msix;
 	bfa->iocfc.hwif.hw_rspq_ack = bfa_hwcb_rspq_ack_msix;
 }
 
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 51ae574..4582525 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -53,7 +53,7 @@ bfa_hwct_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
 	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
-	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
 		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
@@ -85,6 +85,15 @@ bfa_hwct_reginit(struct bfa_s *bfa)
 }
 
 void
+bfa_hwct_reqq_ack(struct bfa_s *bfa, int reqq)
+{
+	u32	r32;
+
+	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
+	bfa_reg_write(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq], r32);
+}
+
+void
 bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq)
 {
 	u32	r32;
diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index b36540e..ca9ae7e 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 #include <bfa.h>
-#include <bfi/bfi_cbreg.h>
+#include <bfi/bfi_ctreg.h>
 #include <bfa_port_priv.h>
 #include <bfa_intr_priv.h>
 #include <cs/bfa_debug.h>
@@ -34,6 +34,26 @@ bfa_msix_lpu(struct bfa_s *bfa)
 	bfa_ioc_mbox_isr(&bfa->ioc);
 }
 
+static void
+bfa_reqq_resume(struct bfa_s *bfa, int qid)
+{
+	struct list_head *waitq, *qe, *qen;
+	struct bfa_reqq_wait_s *wqe;
+
+	waitq = bfa_reqq(bfa, qid);
+	list_for_each_safe(qe, qen, waitq) {
+		/**
+		 * Callback only as long as there is room in request queue
+		 */
+		if (bfa_reqq_full(bfa, qid))
+			break;
+
+		list_del(qe);
+		wqe = (struct bfa_reqq_wait_s *) qe;
+		wqe->qresume(wqe->cbarg);
+	}
+}
+
 void
 bfa_msix_all(struct bfa_s *bfa, int vec)
 {
@@ -46,8 +66,8 @@ bfa_msix_all(struct bfa_s *bfa, int vec)
 bfa_boolean_t
 bfa_intx(struct bfa_s *bfa)
 {
-	u32        intr, qintr;
-	int             queue;
+	u32 intr, qintr;
+	int queue;
 
 	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
 	if (!intr)
@@ -89,14 +109,15 @@ bfa_intx(struct bfa_s *bfa)
 void
 bfa_isr_enable(struct bfa_s *bfa)
 {
-	u32        intr_unmask;
-	int             pci_func = bfa_ioc_pcifn(&bfa->ioc);
+	u32 intr_unmask;
+	int pci_func = bfa_ioc_pcifn(&bfa->ioc);
 
 	bfa_trc(bfa, pci_func);
 
 	bfa_msix_install(bfa);
 	intr_unmask = (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
-		       __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+		       __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS |
+		       __HFN_INT_LL_HALT);
 
 	if (pci_func == 0)
 		intr_unmask |= (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
@@ -127,23 +148,18 @@ bfa_isr_disable(struct bfa_s *bfa)
 void
 bfa_msix_reqq(struct bfa_s *bfa, int qid)
 {
-	struct list_head 		*waitq, *qe, *qen;
-	struct bfa_reqq_wait_s	*wqe;
+	struct list_head *waitq;
 
 	qid &= (BFI_IOC_MAX_CQS - 1);
 
-	waitq = bfa_reqq(bfa, qid);
-	list_for_each_safe(qe, qen, waitq) {
-		/**
-		 * Callback only as long as there is room in request queue
-		 */
-		if (bfa_reqq_full(bfa, qid))
-			break;
+	bfa->iocfc.hwif.hw_reqq_ack(bfa, qid);
 
-		list_del(qe);
-		wqe = (struct bfa_reqq_wait_s *) qe;
-		wqe->qresume(wqe->cbarg);
-	}
+	/**
+	 * Resume any pending requests in the corresponding reqq.
+	 */
+	waitq = bfa_reqq(bfa, qid);
+	if (!list_empty(waitq))
+		bfa_reqq_resume(bfa, qid);
 }
 
 void
@@ -157,26 +173,27 @@ bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
 }
 
 void
-bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
+bfa_msix_rspq(struct bfa_s *bfa, int qid)
 {
-	struct bfi_msg_s      *m;
-	u32        pi, ci;
+	struct bfi_msg_s *m;
+	u32 pi, ci;
+	struct list_head *waitq;
 
-	bfa_trc_fp(bfa, rsp_qid);
+	bfa_trc_fp(bfa, qid);
 
-	rsp_qid &= (BFI_IOC_MAX_CQS - 1);
+	qid &= (BFI_IOC_MAX_CQS - 1);
 
-	bfa->iocfc.hwif.hw_rspq_ack(bfa, rsp_qid);
+	bfa->iocfc.hwif.hw_rspq_ack(bfa, qid);
 
-	ci = bfa_rspq_ci(bfa, rsp_qid);
-	pi = bfa_rspq_pi(bfa, rsp_qid);
+	ci = bfa_rspq_ci(bfa, qid);
+	pi = bfa_rspq_pi(bfa, qid);
 
 	bfa_trc_fp(bfa, ci);
 	bfa_trc_fp(bfa, pi);
 
 	if (bfa->rme_process) {
 		while (ci != pi) {
-			m = bfa_rspq_elem(bfa, rsp_qid, ci);
+			m = bfa_rspq_elem(bfa, qid, ci);
 			bfa_assert_fp(m->mhdr.msg_class < BFI_MC_MAX);
 
 			bfa_isrs[m->mhdr.msg_class] (bfa, m);
@@ -188,25 +205,59 @@ bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
 	/**
 	 * update CI
 	 */
-	bfa_rspq_ci(bfa, rsp_qid) = pi;
-	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[rsp_qid], pi);
+	bfa_rspq_ci(bfa, qid) = pi;
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[qid], pi);
 	bfa_os_mmiowb();
+
+	/**
+	 * Resume any pending requests in the corresponding reqq.
+	 */
+	waitq = bfa_reqq(bfa, qid);
+	if (!list_empty(waitq))
+		bfa_reqq_resume(bfa, qid);
 }
 
 void
 bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 {
-	u32 intr;
+	u32 intr, curr_value;
 
 	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
 
 	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
 		bfa_msix_lpu(bfa);
 
-	if (intr & (__HFN_INT_ERR_EMC |
-		    __HFN_INT_ERR_LPU0 | __HFN_INT_ERR_LPU1 |
-		    __HFN_INT_ERR_PSS))
+	intr &= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+		__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT);
+
+	if (intr) {
+		if (intr & __HFN_INT_LL_HALT) {
+			/**
+			 * If LL_HALT bit is set then FW Init Halt LL Port
+			 * Register needs to be cleared as well so Interrupt
+			 * Status Register will be cleared.
+			 */
+			curr_value = bfa_reg_read(bfa->ioc.ioc_regs.ll_halt);
+			curr_value &= ~__FW_INIT_HALT_P;
+			bfa_reg_write(bfa->ioc.ioc_regs.ll_halt, curr_value);
+		}
+
+		if (intr & __HFN_INT_ERR_PSS) {
+			/**
+			 * ERR_PSS bit needs to be cleared as well in case
+			 * interrups are shared so driver's interrupt handler is
+			 * still called eventhough it is already masked out.
+			 */
+			curr_value = bfa_reg_read(
+					bfa->ioc.ioc_regs.pss_err_status_reg);
+			curr_value &= __PSS_ERR_STATUS_SET;
+			bfa_reg_write(bfa->ioc.ioc_regs.pss_err_status_reg,
+					curr_value);
+		}
+
+		bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr);
 		bfa_msix_errint(bfa, intr);
+	}
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
new file mode 100644
index 0000000..8a1c115
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -0,0 +1,281 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <cna/bfa_cna_trcmod.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_cbreg.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(CNA, IOC_CB);
+
+/*
+ * forward declarations
+ */
+static bfa_status_t bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc);
+static u32  *bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc,
+						u32 off);
+static u32 bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
+static void bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
+
+static struct bfa_ioc_hwif_s hwif_cb = {
+	bfa_ioc_cb_pll_init,
+	bfa_ioc_cb_firmware_lock,
+	bfa_ioc_cb_firmware_unlock,
+	bfa_ioc_cb_fwimg_get_chunk,
+	bfa_ioc_cb_fwimg_get_size,
+	bfa_ioc_cb_reg_init,
+	bfa_ioc_cb_map_port,
+	bfa_ioc_cb_isr_mode_set,
+	bfa_ioc_cb_notify_hbfail,
+	bfa_ioc_cb_ownership_reset,
+};
+
+/**
+ * Called from bfa_ioc_attach() to map asic specific calls.
+ */
+void
+bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
+{
+	ioc->ioc_hwif = &hwif_cb;
+}
+
+static u32 *
+bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
+{
+	return bfi_image_cb_get_chunk(off);
+}
+
+static u32
+bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc)
+{
+	return bfi_image_cb_size;
+}
+
+/**
+ * Return true if firmware of current driver matches the running firmware.
+ */
+static bfa_boolean_t
+bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc)
+{
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc)
+{
+}
+
+/**
+ * Notify other functions on HB failure.
+ */
+static void
+bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
+{
+
+	bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
+	bfa_reg_read(ioc->ioc_regs.err_set);
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
+	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers
+ */
+static struct { u32 hfn, lpu; } iocreg_mbcmd[] = {
+
+	{ HOSTFN0_LPU0_CMD_STAT, LPU0_HOSTFN0_CMD_STAT },
+	{ HOSTFN1_LPU1_CMD_STAT, LPU1_HOSTFN1_CMD_STAT }
+};
+
+static void
+bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb;
+	int		pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+	}
+
+	/**
+	 * Host <-> LPU mailbox command/status registers
+	 */
+	ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd[pcifn].hfn;
+	ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd[pcifn].lpu;
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.pss_err_status_reg = (rb + PSS_ERR_STATUS_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_400_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_212_CTL_REG);
+
+	/*
+	 * IOC semaphore registers and serialization
+	 */
+	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
+
+	/*
+	 * err set reg : for notification of hb failure
+	 */
+	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+
+static void
+bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
+{
+	/**
+	 * For crossbow, port id is same as pci function.
+	 */
+	ioc->port_id = bfa_ioc_pcifn(ioc);
+
+	bfa_trc(ioc, ioc->port_id);
+}
+
+/**
+ * Set interrupt mode for a function: INTX or MSIX
+ */
+static void
+bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
+{
+}
+
+static bfa_status_t
+bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	u32	pll_sclk, pll_fclk;
+
+	/*
+	 *  Hold semaphore so that nobody can access the chip during init.
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+
+	pll_sclk = __APP_PLL_212_ENABLE | __APP_PLL_212_LRESETN |
+		__APP_PLL_212_P0_1(3U) |
+		__APP_PLL_212_JITLMT0_1(3U) |
+		__APP_PLL_212_CNTLMT0_1(3U);
+	pll_fclk = __APP_PLL_400_ENABLE | __APP_PLL_400_LRESETN |
+		__APP_PLL_400_RSEL200500 | __APP_PLL_400_P0_1(3U) |
+		__APP_PLL_400_JITLMT0_1(3U) |
+		__APP_PLL_400_CNTLMT0_1(3U);
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_212_BYPASS |
+		      __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_400_BYPASS |
+		      __APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_os_udelay(2);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_400_LOGIC_SOFT_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
+{
+
+	/*
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
+	 */
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
+
+
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
new file mode 100644
index 0000000..76c4f75
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -0,0 +1,425 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <cna/bfa_cna_trcmod.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_ctreg.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(CNA, IOC_CT);
+
+/*
+ * forward declarations
+ */
+static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
+static u32 *bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
+						u32 off);
+static u32 bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
+static void bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
+
+static struct bfa_ioc_hwif_s hwif_ct = {
+	bfa_ioc_ct_pll_init,
+	bfa_ioc_ct_firmware_lock,
+	bfa_ioc_ct_firmware_unlock,
+	bfa_ioc_ct_fwimg_get_chunk,
+	bfa_ioc_ct_fwimg_get_size,
+	bfa_ioc_ct_reg_init,
+	bfa_ioc_ct_map_port,
+	bfa_ioc_ct_isr_mode_set,
+	bfa_ioc_ct_notify_hbfail,
+	bfa_ioc_ct_ownership_reset,
+};
+
+/**
+ * Called from bfa_ioc_attach() to map asic specific calls.
+ */
+void
+bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
+{
+	ioc->ioc_hwif = &hwif_ct;
+}
+
+static u32 *
+bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
+{
+	return bfi_image_ct_get_chunk(off);
+}
+
+static u32
+bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc)
+{
+	return bfi_image_ct_size;
+}
+
+/**
+ * Return true if firmware of current driver matches the running firmware.
+ */
+static bfa_boolean_t
+bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
+{
+	enum bfi_ioc_state ioc_fwstate;
+	u32 usecnt;
+	struct bfi_ioc_image_hdr_s fwhdr;
+
+	/**
+	 * Firmware match check is relevant only for CNA.
+	 */
+	if (!ioc->cna)
+		return BFA_TRUE;
+
+	/**
+	 * If bios boot (flash based) -- do not increment usage count
+	 */
+	if (bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return BFA_TRUE;
+
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+
+	/**
+	 * If usage count is 0, always return TRUE.
+	 */
+	if (usecnt == 0) {
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_trc(ioc, usecnt);
+		return BFA_TRUE;
+	}
+
+	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	bfa_trc(ioc, ioc_fwstate);
+
+	/**
+	 * Use count cannot be non-zero and chip in uninitialized state.
+	 */
+	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
+
+	/**
+	 * Check if another driver with a different firmware is active
+	 */
+	bfa_ioc_fwver_get(ioc, &fwhdr);
+	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_trc(ioc, usecnt);
+		return BFA_FALSE;
+	}
+
+	/**
+	 * Same firmware version. Increment the reference count.
+	 */
+	usecnt++;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	bfa_trc(ioc, usecnt);
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
+{
+	u32 usecnt;
+
+	/**
+	 * Firmware lock is relevant only for CNA.
+	 * If bios boot (flash based) -- do not decrement usage count
+	 */
+	if (!ioc->cna || bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return;
+
+	/**
+	 * decrement usage count
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+	bfa_assert(usecnt > 0);
+
+	usecnt--;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_trc(ioc, usecnt);
+
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+}
+
+/**
+ * Notify other functions on HB failure.
+ */
+static void
+bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
+{
+	if (ioc->cna) {
+		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
+		/* Wait for halt to take effect */
+		bfa_reg_read(ioc->ioc_regs.ll_halt);
+	} else {
+		bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
+		bfa_reg_read(ioc->ioc_regs.err_set);
+	}
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
+	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 },
+	{ HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2 },
+	{ HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3 }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 0
+ */
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p0[] = {
+	{ HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 1
+ */
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p1[] = {
+	{ HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+static void
+bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb;
+	int		pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
+	}
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.pss_err_status_reg = (rb + PSS_ERR_STATUS_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
+
+	/*
+	 * IOC semaphore registers and serialization
+	 */
+	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
+	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
+	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
+
+	/*
+	 * err set reg : for notification of hb failure in fcmode
+	 */
+	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+
+#define FNC_PERS_FN_SHIFT(__fn)	((__fn) * 8)
+static void
+bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	u32	r32;
+
+	/**
+	 * For catapult, base port id on personality register and IOC type
+	 */
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
+	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
+
+	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
+	bfa_trc(ioc, ioc->port_id);
+}
+
+/**
+ * Set interrupt mode for a function: INTX or MSIX
+ */
+static void
+bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	u32	r32, mode;
+
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	bfa_trc(ioc, r32);
+
+	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
+		__F0_INTX_STATUS;
+
+	/**
+	 * If already in desired mode, do not change anything
+	 */
+	if (!msix && mode)
+		return;
+
+	if (msix)
+		mode = __F0_INTX_STATUS_MSIX;
+	else
+		mode = __F0_INTX_STATUS_INTA;
+
+	r32 &= ~(__F0_INTX_STATUS << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	bfa_trc(ioc, r32);
+
+	bfa_reg_write(rb + FNC_PERS_REG, r32);
+}
+
+static bfa_status_t
+bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	u32	pll_sclk, pll_fclk, r32;
+
+	/*
+	 *  Hold semaphore so that nobody can access the chip during init.
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+
+	pll_sclk = __APP_PLL_312_LRESETN | __APP_PLL_312_ENARST |
+		__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(3U) |
+		__APP_PLL_312_JITLMT0_1(3U) |
+		__APP_PLL_312_CNTLMT0_1(1U);
+	pll_fclk = __APP_PLL_425_LRESETN | __APP_PLL_425_ENARST |
+		__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
+		__APP_PLL_425_JITLMT0_1(3U) |
+		__APP_PLL_425_CNTLMT0_1(1U);
+
+	/**
+	 *	For catapult, choose operational mode FC/FCoE
+	 */
+	if (ioc->fcmode) {
+		bfa_reg_write((rb + OP_MODE), 0);
+		bfa_reg_write((rb + ETH_MAC_SER_REG),
+			      __APP_EMS_CMLCKSEL |
+			      __APP_EMS_REFCKBUFEN2 |
+			      __APP_EMS_CHANNEL_SEL);
+	} else {
+		ioc->pllinit = BFA_TRUE;
+		bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
+		bfa_reg_write((rb + ETH_MAC_SER_REG),
+			      __APP_EMS_REFCKBUFEN1);
+	}
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_LOGIC_SOFT_RESET | __APP_PLL_312_ENABLE);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_reg_read(rb + HOSTFN0_INT_MSK);
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_ENABLE);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_ENABLE);
+
+	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
+	bfa_os_udelay(1000);
+	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
+	bfa_trc(ioc, r32);
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
+{
+
+	if (ioc->cna) {
+		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 0);
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	}
+
+	/*
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
+	 */
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
+
+
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index d7ab792..d3d0d65 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -49,7 +49,7 @@ static void bfa_iocfc_hbfail_cbfn(void *bfa_arg);
 static void bfa_iocfc_reset_cbfn(void *bfa_arg);
 static void bfa_iocfc_stats_clear(void *bfa_arg);
 static void bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d,
-			struct bfa_fw_stats_s *s);
+				 struct bfa_fw_stats_s *s);
 static void bfa_iocfc_stats_clr_cb(void *bfa_arg, bfa_boolean_t complete);
 static void bfa_iocfc_stats_clr_timeout(void *bfa_arg);
 static void bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete);
@@ -64,12 +64,12 @@ static struct bfa_ioc_cbfn_s bfa_iocfc_cbfn;
 static void
 bfa_iocfc_cqs_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
 {
-	int             i, per_reqq_sz, per_rspq_sz;
+	int		i, per_reqq_sz, per_rspq_sz;
 
 	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
-							BFA_DMA_ALIGN_SZ);
+				  BFA_DMA_ALIGN_SZ);
 	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
-							BFA_DMA_ALIGN_SZ);
+				  BFA_DMA_ALIGN_SZ);
 
 	/*
 	 * Calculate CQ size
@@ -107,8 +107,8 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
 	struct bfi_iocfc_cfg_req_s cfg_req;
 	struct bfi_iocfc_cfg_s *cfg_info = iocfc->cfginfo;
-	struct bfa_iocfc_cfg_s  *cfg = &iocfc->cfg;
-	int             i;
+	struct bfa_iocfc_cfg_s	*cfg = &iocfc->cfg;
+	int		i;
 
 	bfa_assert(cfg->fwcfg.num_cqs <= BFI_IOC_MAX_CQS);
 	bfa_trc(bfa, cfg->fwcfg.num_cqs);
@@ -130,16 +130,16 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	 */
 	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
 		bfa_dma_be_addr_set(cfg_info->req_cq_ba[i],
-				       iocfc->req_cq_ba[i].pa);
+				    iocfc->req_cq_ba[i].pa);
 		bfa_dma_be_addr_set(cfg_info->req_shadow_ci[i],
-				       iocfc->req_cq_shadow_ci[i].pa);
+				    iocfc->req_cq_shadow_ci[i].pa);
 		cfg_info->req_cq_elems[i] =
 			bfa_os_htons(cfg->drvcfg.num_reqq_elems);
 
 		bfa_dma_be_addr_set(cfg_info->rsp_cq_ba[i],
-				       iocfc->rsp_cq_ba[i].pa);
+				    iocfc->rsp_cq_ba[i].pa);
 		bfa_dma_be_addr_set(cfg_info->rsp_shadow_pi[i],
-				       iocfc->rsp_cq_shadow_pi[i].pa);
+				    iocfc->rsp_cq_shadow_pi[i].pa);
 		cfg_info->rsp_cq_elems[i] =
 			bfa_os_htons(cfg->drvcfg.num_rspq_elems);
 	}
@@ -148,16 +148,16 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	 * dma map IOC configuration itself
 	 */
 	bfi_h2i_set(cfg_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CFG_REQ,
-			bfa_lpuid(bfa));
+		    bfa_lpuid(bfa));
 	bfa_dma_be_addr_set(cfg_req.ioc_cfg_dma_addr, iocfc->cfg_info.pa);
 
 	bfa_ioc_mbox_send(&bfa->ioc, &cfg_req,
-			sizeof(struct bfi_iocfc_cfg_req_s));
+			  sizeof(struct bfi_iocfc_cfg_req_s));
 }
 
 static void
 bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		    struct bfa_pcidev_s *pcidev)
+		   struct bfa_pcidev_s *pcidev)
 {
 	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
 
@@ -172,6 +172,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	 */
 	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT) {
 		iocfc->hwif.hw_reginit = bfa_hwct_reginit;
+		iocfc->hwif.hw_reqq_ack = bfa_hwct_reqq_ack;
 		iocfc->hwif.hw_rspq_ack = bfa_hwct_rspq_ack;
 		iocfc->hwif.hw_msix_init = bfa_hwct_msix_init;
 		iocfc->hwif.hw_msix_install = bfa_hwct_msix_install;
@@ -180,6 +181,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		iocfc->hwif.hw_msix_getvecs = bfa_hwct_msix_getvecs;
 	} else {
 		iocfc->hwif.hw_reginit = bfa_hwcb_reginit;
+		iocfc->hwif.hw_reqq_ack = bfa_hwcb_reqq_ack;
 		iocfc->hwif.hw_rspq_ack = bfa_hwcb_rspq_ack;
 		iocfc->hwif.hw_msix_init = bfa_hwcb_msix_init;
 		iocfc->hwif.hw_msix_install = bfa_hwcb_msix_install;
@@ -194,11 +196,11 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 static void
 bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
-		      struct bfa_meminfo_s *meminfo)
+		    struct bfa_meminfo_s *meminfo)
 {
-	u8        *dm_kva;
-	u64        dm_pa;
-	int             i, per_reqq_sz, per_rspq_sz;
+	u8	       *dm_kva;
+	u64	dm_pa;
+	int		i, per_reqq_sz, per_rspq_sz;
 	struct bfa_iocfc_s  *iocfc = &bfa->iocfc;
 	int		dbgsz;
 
@@ -217,9 +219,9 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	 * ci/pi registers
 	 */
 	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
-							BFA_DMA_ALIGN_SZ);
+				  BFA_DMA_ALIGN_SZ);
 	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
-							BFA_DMA_ALIGN_SZ);
+				  BFA_DMA_ALIGN_SZ);
 
 	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
 		iocfc->req_cq_ba[i].kva = dm_kva;
@@ -294,7 +296,7 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 static void
 bfa_iocfc_initdone_submod(struct bfa_s *bfa)
 {
-	int             i;
+	int		i;
 
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->initdone(bfa);
@@ -306,7 +308,7 @@ bfa_iocfc_initdone_submod(struct bfa_s *bfa)
 static void
 bfa_iocfc_start_submod(struct bfa_s *bfa)
 {
-	int             i;
+	int		i;
 
 	bfa->rme_process = BFA_TRUE;
 
@@ -320,7 +322,7 @@ bfa_iocfc_start_submod(struct bfa_s *bfa)
 static void
 bfa_iocfc_disable_submod(struct bfa_s *bfa)
 {
-	int             i;
+	int		i;
 
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->iocdisable(bfa);
@@ -336,8 +338,10 @@ bfa_iocfc_init_cb(void *bfa_arg, bfa_boolean_t complete)
 			bfa_cb_init(bfa->bfad, BFA_STATUS_OK);
 		else
 			bfa_cb_init(bfa->bfad, BFA_STATUS_FAILED);
-	} else
-		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+	} else {
+		if (bfa->iocfc.cfgdone)
+			bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+	}
 }
 
 static void
@@ -348,7 +352,6 @@ bfa_iocfc_stop_cb(void *bfa_arg, bfa_boolean_t compl)
 
 	if (compl)
 		complete(&bfad->comp);
-
 	else
 		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
 }
@@ -370,11 +373,11 @@ static void
 bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
-	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
-	struct bfa_iocfc_fwcfg_s	*fwcfg   = &cfgrsp->fwcfg;
-	struct bfi_iocfc_cfg_s 		*cfginfo = iocfc->cfginfo;
+	struct bfi_iocfc_cfgrsp_s	*cfgrsp	 = iocfc->cfgrsp;
+	struct bfa_iocfc_fwcfg_s	*fwcfg	 = &cfgrsp->fwcfg;
+	struct bfi_iocfc_cfg_s		*cfginfo = iocfc->cfginfo;
 
-	fwcfg->num_cqs        = fwcfg->num_cqs;
+	fwcfg->num_cqs	      = fwcfg->num_cqs;
 	fwcfg->num_ioim_reqs  = bfa_os_ntohs(fwcfg->num_ioim_reqs);
 	fwcfg->num_tskim_reqs = bfa_os_ntohs(fwcfg->num_tskim_reqs);
 	fwcfg->num_fcxp_reqs  = bfa_os_ntohs(fwcfg->num_fcxp_reqs);
@@ -404,21 +407,21 @@ bfa_iocfc_stats_clear(void *bfa_arg)
 	struct bfi_iocfc_stats_req_s stats_req;
 
 	bfa_timer_start(bfa, &iocfc->stats_timer,
-			    bfa_iocfc_stats_clr_timeout, bfa,
-			    BFA_IOCFC_TOV);
+			bfa_iocfc_stats_clr_timeout, bfa,
+			BFA_IOCFC_TOV);
 
 	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CLEAR_STATS_REQ,
-		bfa_lpuid(bfa));
+		    bfa_lpuid(bfa));
 	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
-		sizeof(struct bfi_iocfc_stats_req_s));
+			  sizeof(struct bfi_iocfc_stats_req_s));
 }
 
 static void
 bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d, struct bfa_fw_stats_s *s)
 {
-	u32       *dip = (u32 *) d;
-	u32       *sip = (u32 *) s;
-	int             i;
+	u32 *dip = (u32 *) d;
+	u32 *sip = (u32 *) s;
+	int i;
 
 	for (i = 0; i < (sizeof(struct bfa_fw_stats_s) / sizeof(u32)); i++)
 		dip[i] = bfa_os_ntohl(sip[i]);
@@ -460,9 +463,9 @@ bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete)
 	if (complete) {
 		if (iocfc->stats_status == BFA_STATUS_OK) {
 			bfa_os_memset(iocfc->stats_ret, 0,
-				sizeof(*iocfc->stats_ret));
+				      sizeof(*iocfc->stats_ret));
 			bfa_iocfc_stats_swap(&iocfc->stats_ret->fw_stats,
-				iocfc->fw_stats);
+					     iocfc->fw_stats);
 		}
 		iocfc->stats_cbfn(iocfc->stats_cbarg, iocfc->stats_status);
 	} else {
@@ -490,18 +493,18 @@ bfa_iocfc_stats_query(struct bfa_s *bfa)
 	struct bfi_iocfc_stats_req_s stats_req;
 
 	bfa_timer_start(bfa, &iocfc->stats_timer,
-			    bfa_iocfc_stats_timeout, bfa, BFA_IOCFC_TOV);
+			bfa_iocfc_stats_timeout, bfa, BFA_IOCFC_TOV);
 
 	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_GET_STATS_REQ,
-			bfa_lpuid(bfa));
+		    bfa_lpuid(bfa));
 	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
-		sizeof(struct bfi_iocfc_stats_req_s));
+			  sizeof(struct bfi_iocfc_stats_req_s));
 }
 
 void
 bfa_iocfc_reset_queues(struct bfa_s *bfa)
 {
-	int             q;
+	int		q;
 
 	for (q = 0; q < BFI_IOC_MAX_CQS; q++) {
 		bfa_reqq_ci(bfa, q) = 0;
@@ -593,7 +596,7 @@ bfa_iocfc_reset_cbfn(void *bfa_arg)
  */
 void
 bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
-		u32 *dm_len)
+		  u32 *dm_len)
 {
 	/* dma memory for IOC */
 	*dm_len += bfa_ioc_meminfo();
@@ -608,9 +611,9 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
  */
 void
 bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		   struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+		 struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
 {
-	int             i;
+	int		i;
 
 	bfa_iocfc_cbfn.enable_cbfn = bfa_iocfc_enable_cbfn;
 	bfa_iocfc_cbfn.disable_cbfn = bfa_iocfc_disable_cbfn;
@@ -618,9 +621,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_iocfc_cbfn.reset_cbfn = bfa_iocfc_reset_cbfn;
 
 	bfa_ioc_attach(&bfa->ioc, bfa, &bfa_iocfc_cbfn, &bfa->timer_mod,
-		bfa->trcmod, bfa->aen, bfa->logm);
-	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
-	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
+		       bfa->trcmod, bfa->aen, bfa->logm);
 
 	/**
 	 * Choose FC (ssid: 0x1C) v/s FCoE (ssid: 0x14) mode.
@@ -628,6 +629,9 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	if (0)
 		bfa_ioc_set_fcmode(&bfa->ioc);
 
+	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
+	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
+
 	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
 	bfa_iocfc_mem_claim(bfa, cfg, meminfo);
 	bfa_timer_init(&bfa->timer_mod);
@@ -654,7 +658,6 @@ bfa_iocfc_init(struct bfa_s *bfa)
 {
 	bfa->iocfc.action = BFA_IOCFC_ACT_INIT;
 	bfa_ioc_enable(&bfa->ioc);
-	bfa_msix_install(bfa);
 }
 
 /**
@@ -698,27 +701,27 @@ bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
 		break;
 
 	case BFI_IOCFC_I2H_GET_STATS_RSP:
-		if (iocfc->stats_busy == BFA_FALSE
-		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+		if (iocfc->stats_busy == BFA_FALSE ||
+		    iocfc->stats_status == BFA_STATUS_ETIMER)
 			break;
 
 		bfa_timer_stop(&iocfc->stats_timer);
 		iocfc->stats_status = BFA_STATUS_OK;
 		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_cb,
-			      bfa);
+			     bfa);
 		break;
 	case BFI_IOCFC_I2H_CLEAR_STATS_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
-		if (iocfc->stats_busy == BFA_FALSE
-		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+		if (iocfc->stats_busy == BFA_FALSE ||
+		    iocfc->stats_status == BFA_STATUS_ETIMER)
 			break;
 
 		bfa_timer_stop(&iocfc->stats_timer);
 		iocfc->stats_status = BFA_STATUS_OK;
 		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe,
-			      bfa_iocfc_stats_clr_cb, bfa);
+			     bfa_iocfc_stats_clr_cb, bfa);
 		break;
 	case BFI_IOCFC_I2H_UPDATEQ_RSP:
 		iocfc->updateq_cbfn(iocfc->updateq_cbarg, BFA_STATUS_OK);
@@ -765,7 +768,7 @@ bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
 		return BFA_STATUS_DEVBUSY;
 
 	bfi_h2i_set(m->mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_SET_INTR_REQ,
-			bfa_lpuid(bfa));
+		    bfa_lpuid(bfa));
 	m->coalesce = attr->coalesce;
 	m->delay    = bfa_os_htons(attr->delay);
 	m->latency  = bfa_os_htons(attr->latency);
@@ -780,7 +783,7 @@ bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
 void
 bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa)
 {
-	struct bfa_iocfc_s      *iocfc = &bfa->iocfc;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
 
 	iocfc->cfginfo->sense_buf_len = (BFI_IOIM_SNSLEN - 1);
 	bfa_dma_be_addr_set(iocfc->cfginfo->ioim_snsbase, snsbase_pa);
@@ -788,7 +791,7 @@ bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa)
 
 bfa_status_t
 bfa_iocfc_get_stats(struct bfa_s *bfa, struct bfa_iocfc_stats_s *stats,
-		      bfa_cb_ioc_t cbfn, void *cbarg)
+		    bfa_cb_ioc_t cbfn, void *cbarg)
 {
 	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
 
@@ -797,6 +800,11 @@ bfa_iocfc_get_stats(struct bfa_s *bfa, struct bfa_iocfc_stats_s *stats,
 		return BFA_STATUS_DEVBUSY;
 	}
 
+	if (!bfa_iocfc_is_operational(bfa)) {
+		bfa_trc(bfa, 0);
+		return BFA_STATUS_IOC_NON_OP;
+	}
+
 	iocfc->stats_busy = BFA_TRUE;
 	iocfc->stats_ret = stats;
 	iocfc->stats_cbfn = cbfn;
@@ -817,6 +825,11 @@ bfa_iocfc_clear_stats(struct bfa_s *bfa, bfa_cb_ioc_t cbfn, void *cbarg)
 		return BFA_STATUS_DEVBUSY;
 	}
 
+	if (!bfa_iocfc_is_operational(bfa)) {
+		bfa_trc(bfa, 0);
+		return BFA_STATUS_IOC_NON_OP;
+	}
+
 	iocfc->stats_busy = BFA_TRUE;
 	iocfc->stats_cbfn = cbfn;
 	iocfc->stats_cbarg = cbarg;
@@ -861,7 +874,7 @@ void
 bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns)
 {
 	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
-	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
+	struct bfi_iocfc_cfgrsp_s	*cfgrsp	 = iocfc->cfgrsp;
 
 	*nwwns = cfgrsp->bootwwns.nwwns;
 	*wwns = cfgrsp->bootwwns.wwn;
diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index f81d359..ab8ef8c 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -43,24 +43,24 @@ static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
  * IO state machine events
  */
 enum bfa_ioim_event {
-	BFA_IOIM_SM_START = 1,		/*  io start request from host */
-	BFA_IOIM_SM_COMP_GOOD = 2,	/*  io good comp, resource free */
-	BFA_IOIM_SM_COMP = 3,		/*  io comp, resource is free */
-	BFA_IOIM_SM_COMP_UTAG = 4,	/*  io comp, resource is free */
-	BFA_IOIM_SM_DONE = 5,		/*  io comp, resource not free */
-	BFA_IOIM_SM_FREE = 6,		/*  io resource is freed */
-	BFA_IOIM_SM_ABORT = 7,		/*  abort request from scsi stack */
+	BFA_IOIM_SM_START	   = 1,	/*  io start request from host */
+	BFA_IOIM_SM_COMP_GOOD  = 2,	/*  io good comp, resource free */
+	BFA_IOIM_SM_COMP	   = 3,	/*  io comp, resource is free */
+	BFA_IOIM_SM_COMP_UTAG  = 4,	/*  io comp, resource is free */
+	BFA_IOIM_SM_DONE	   = 5,	/*  io comp, resource not free */
+	BFA_IOIM_SM_FREE	   = 6,	/*  io resource is freed */
+	BFA_IOIM_SM_ABORT	   = 7,	/*  abort request from scsi stack */
 	BFA_IOIM_SM_ABORT_COMP = 8,	/*  abort from f/w */
 	BFA_IOIM_SM_ABORT_DONE = 9,	/*  abort completion from f/w */
-	BFA_IOIM_SM_QRESUME = 10,	/*  CQ space available to queue IO */
-	BFA_IOIM_SM_SGALLOCED = 11,	/*  SG page allocation successful */
-	BFA_IOIM_SM_SQRETRY = 12,	/*  sequence recovery retry */
-	BFA_IOIM_SM_HCB	= 13,		/*  bfa callback complete */
-	BFA_IOIM_SM_CLEANUP = 14,	/*  IO cleanup from itnim */
-	BFA_IOIM_SM_TMSTART = 15,	/*  IO cleanup from tskim */
-	BFA_IOIM_SM_TMDONE = 16,	/*  IO cleanup from tskim */
-	BFA_IOIM_SM_HWFAIL = 17,	/*  IOC h/w failure event */
-	BFA_IOIM_SM_IOTOV = 18,		/*  ITN offline TOV       */
+	BFA_IOIM_SM_QRESUME	   = 10,/*  CQ space available to queue IO */
+	BFA_IOIM_SM_SGALLOCED  = 11,/*  SG page allocation successful */
+	BFA_IOIM_SM_SQRETRY	   = 12,/*  sequence recovery retry */
+	BFA_IOIM_SM_HCB	   = 13,/*  bfa callback complete */
+	BFA_IOIM_SM_CLEANUP	   = 14,/*  IO cleanup from itnim */
+	BFA_IOIM_SM_TMSTART	   = 15,/*  IO cleanup from tskim */
+	BFA_IOIM_SM_TMDONE	   = 16,/*  IO cleanup from tskim */
+	BFA_IOIM_SM_HWFAIL	   = 17,/*  IOC h/w failure event */
+	BFA_IOIM_SM_IOTOV	   = 18,/*  ITN offline TOV       */
 };
 
 /*
@@ -144,12 +144,12 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		 */
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_assert(bfa_q_is_on_q(&ioim->itnim->pending_q, ioim));
-		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
-				ioim);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+				__bfa_cb_ioim_abort, ioim);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -194,7 +194,7 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -259,7 +259,7 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -317,7 +317,7 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -377,7 +377,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -419,7 +419,7 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -467,7 +467,7 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -516,7 +516,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -544,7 +544,7 @@ bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -577,7 +577,7 @@ bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -605,7 +605,7 @@ bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_itnim.c b/drivers/scsi/bfa/bfa_itnim.c
index eabf7d3..108ccde 100644
--- a/drivers/scsi/bfa/bfa_itnim.c
+++ b/drivers/scsi/bfa/bfa_itnim.c
@@ -144,7 +144,7 @@ bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -175,7 +175,7 @@ bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -212,13 +212,13 @@ bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
 static void
 bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
-			enum bfa_itnim_event event)
+					enum bfa_itnim_event event)
 {
 	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
 	bfa_trc(itnim->bfa, event);
@@ -247,7 +247,7 @@ bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -275,7 +275,7 @@ bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -317,7 +317,7 @@ bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -348,7 +348,7 @@ bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -385,7 +385,7 @@ bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -413,7 +413,7 @@ bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -442,13 +442,13 @@ bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
 static void
 bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
-			enum bfa_itnim_event event)
+					enum bfa_itnim_event event)
 {
 	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
 	bfa_trc(itnim->bfa, event);
@@ -470,7 +470,7 @@ bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -502,7 +502,7 @@ bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -538,7 +538,7 @@ bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -559,13 +559,13 @@ bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
 static void
 bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
-			enum bfa_itnim_event event)
+					enum bfa_itnim_event event)
 {
 	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
 	bfa_trc(itnim->bfa, event);
@@ -583,7 +583,7 @@ bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_log.c b/drivers/scsi/bfa/bfa_log.c
index e751401..a07a0fa 100644
--- a/drivers/scsi/bfa/bfa_log.c
+++ b/drivers/scsi/bfa/bfa_log.c
@@ -321,8 +321,9 @@ bfa_log(struct bfa_log_mod_s *log_mod, u32 msg_id, ...)
 
 	log_level = log_mod ? log_mod->log_level[mod] : bfa_log_info[mod].level;
 	if ((BFA_LOG_GET_SEVERITY(msg) > log_level) &&
-			(msg->attributes != BFA_LOG_ATTR_NONE))
+			(msg->attributes != BFA_LOG_ATTR_NONE)) {
 		return 0;
+	}
 
 	va_start(ap, msg_id);
 	bfa_os_vsprintf(buf, BFA_LOG_GET_MSG_FMT_STRING(msg), ap);
diff --git a/drivers/scsi/bfa/bfa_log_module.c b/drivers/scsi/bfa/bfa_log_module.c
index 5c154d3..068aa31 100644
--- a/drivers/scsi/bfa/bfa_log_module.c
+++ b/drivers/scsi/bfa/bfa_log_module.c
@@ -14,7 +14,26 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
-
+/*
+ *  Copyright (c) 2008 by Brocade Communications Systems, Inc.
+ *  All rights reserved.
+ *
+ *  File Name:      bfa_log_module.c
+ *
+ *  PLEASE DO NOT EDIT THIS FILE. THIS FILE IS AUTO GENERATED!!
+ *
+ *  Description:
+ *
+ *  The log messages defined in each XML files will be converted to a C code
+ *  style message file. The message file will be named the same as XML file.
+ *
+ *  These coded instructions and statements contain unpublished trade
+ *  secrets and proprietary information.  They are protected by federal
+ *  copyright law and by trade secret law, and may not be disclosed to
+ *  third parties or used, copied, or duplicated in any form, in whole
+ *  or in part, without the prior written consent of Brocade Communications.
+ *
+ */
 #include <cs/bfa_log.h>
 #include <aen/bfa_aen_adapter.h>
 #include <aen/bfa_aen_audit.h>
@@ -347,6 +366,21 @@ struct bfa_log_msgdef_s bfa_log_msg_array[] = {
  ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
   (BFA_LOG_D << BFA_LOG_ARG2) | 0), 3},
 
+{BFA_LOG_HAL_DRIVER_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "HAL_DRIVER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_DRIVER_CONFIG_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "HAL_DRIVER_CONFIG_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_MBOX_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "HAL_MBOX_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
 
 
 
@@ -412,6 +446,46 @@ struct bfa_log_msgdef_s bfa_log_msg_array[] = {
  ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
   (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
 
+{BFA_LOG_LINUX_DRIVER_CONFIG_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_CONFIG_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_BNA_STATE_MACHINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_BNA_STATE_MACHINE",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_IOC_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_IOC_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_RESOURCE_ALLOC_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_RESOURCE_ALLOC_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_RING_BUFFER_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_RING_BUFFER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_DIAG, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_DIAG",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_AEN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_DRIVER_AEN",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
 
 
 
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index 9844b45..7da1513 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -18,6 +18,7 @@
 #include <bfa.h>
 #include <bfi/bfi_lps.h>
 #include <cs/bfa_debug.h>
+#include <defs/bfa_defs_pci.h>
 
 BFA_TRC_FILE(HAL, LPS);
 BFA_MODULE(lps);
@@ -25,6 +26,12 @@ BFA_MODULE(lps);
 #define BFA_LPS_MIN_LPORTS	(1)
 #define BFA_LPS_MAX_LPORTS	(256)
 
+/*
+ * Maximum Vports supported per physical port or vf.
+ */
+#define BFA_LPS_MAX_VPORTS_SUPP_CB  255
+#define BFA_LPS_MAX_VPORTS_SUPP_CT  190
+
 /**
  * forward declarations
  */
@@ -49,6 +56,7 @@ static void bfa_lps_send_login(struct bfa_lps_s *lps);
 static void bfa_lps_send_logout(struct bfa_lps_s *lps);
 static void bfa_lps_login_comp(struct bfa_lps_s *lps);
 static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
+static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
 
 
 /**
@@ -62,16 +70,17 @@ enum bfa_lps_event {
 	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
 	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
 	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
+	BFA_LPS_SM_RX_CVL	= 7, 	/* Rx clear virtual link	*/
 };
 
 static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
 static void bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event);
-static void bfa_lps_sm_loginwait(struct bfa_lps_s *lps,
-			enum bfa_lps_event event);
+static void bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event
+		event);
 static void bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event);
 static void bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event);
-static void bfa_lps_sm_logowait(struct bfa_lps_s *lps,
-			enum bfa_lps_event event);
+static void bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event
+		event);
 
 /**
  * Init state -- no login
@@ -91,6 +100,13 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			bfa_sm_set_state(lps, bfa_lps_sm_login);
 			bfa_lps_send_login(lps);
 		}
+
+		if (lps->fdisc)
+			bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0, "FDISC Request");
+		else
+			bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+				BFA_PL_EID_LOGIN, 0, "FLOGI Request");
 		break;
 
 	case BFA_LPS_SM_LOGOUT:
@@ -101,18 +117,20 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_lps_free(lps);
 		break;
 
+	case BFA_LPS_SM_RX_CVL:
 	case BFA_LPS_SM_OFFLINE:
 		break;
 
 	case BFA_LPS_SM_FWRSP:
-		/* Could happen when fabric detects loopback and discards
+		/*
+		 * Could happen when fabric detects loopback and discards
 		 * the lps request. Fw will eventually sent out the timeout
 		 * Just ignore
 		 */
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -127,10 +145,25 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 
 	switch (event) {
 	case BFA_LPS_SM_FWRSP:
-		if (lps->status == BFA_STATUS_OK)
+		if (lps->status == BFA_STATUS_OK) {
 			bfa_sm_set_state(lps, bfa_lps_sm_online);
-		else
+			if (lps->fdisc)
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+					BFA_PL_EID_LOGIN, 0, "FDISC Accept");
+			else
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+					BFA_PL_EID_LOGIN, 0, "FLOGI Accept");
+		} else {
 			bfa_sm_set_state(lps, bfa_lps_sm_init);
+			if (lps->fdisc)
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+					BFA_PL_EID_LOGIN, 0,
+					"FDISC Fail (RJT or timeout)");
+			else
+				bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+					BFA_PL_EID_LOGIN, 0,
+					"FLOGI Fail (RJT or timeout)");
+		}
 		bfa_lps_login_comp(lps);
 		break;
 
@@ -139,7 +172,7 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -162,8 +195,16 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_reqq_wcancel(&lps->wqe);
 		break;
 
+	case BFA_LPS_SM_RX_CVL:
+		/*
+		 * Login was not even sent out; so when getting out
+		 * of this state, it will appear like a login retry
+		 * after Clear virtual link
+		 */
+		break;
+
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -185,6 +226,17 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 			bfa_sm_set_state(lps, bfa_lps_sm_logout);
 			bfa_lps_send_logout(lps);
 		}
+		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_LOGO, 0, "Logout");
+		break;
+
+	case BFA_LPS_SM_RX_CVL:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+
+		/* Let the vport module know about this event */
+		bfa_lps_cvl_event(lps);
+		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
+			BFA_PL_EID_FIP_FCF_CVL, 0, "FCF Clear Virt. Link Rx");
 		break;
 
 	case BFA_LPS_SM_OFFLINE:
@@ -193,7 +245,7 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -217,7 +269,7 @@ bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -242,7 +294,7 @@ bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -256,7 +308,8 @@ bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
  * return memory requirement
  */
 static void
-bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
+bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+	u32 *dm_len)
 {
 	if (cfg->drvcfg.min_cfg)
 		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MIN_LPORTS;
@@ -269,7 +322,7 @@ bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
  */
 static void
 bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+	struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
 {
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
 	struct bfa_lps_s	*lps;
@@ -396,6 +449,20 @@ bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
 }
 
 /**
+ * Firmware received a Clear virtual link request (for FCoE)
+ */
+static void
+bfa_lps_rx_cvl_event(struct bfa_s *bfa, struct bfi_lps_cvl_event_s *cvl)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+
+	lps = BFA_LPS_FROM_TAG(mod, cvl->lp_tag);
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_RX_CVL);
+}
+
+/**
  * Space is available in request queue, resume queueing request to firmware.
  */
 static void
@@ -414,6 +481,7 @@ bfa_lps_free(struct bfa_lps_s *lps)
 {
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(lps->bfa);
 
+	lps->lp_pid = 0;
 	list_del(&lps->qe);
 	list_add_tail(&lps->qe, &mod->lps_free_q);
 }
@@ -430,7 +498,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 	bfa_assert(m);
 
 	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGIN_REQ,
-			bfa_lpuid(lps->bfa));
+		bfa_lpuid(lps->bfa));
 
 	m->lp_tag	= lps->lp_tag;
 	m->alpa		= lps->alpa;
@@ -455,7 +523,7 @@ bfa_lps_send_logout(struct bfa_lps_s *lps)
 	bfa_assert(m);
 
 	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGOUT_REQ,
-			bfa_lpuid(lps->bfa));
+		bfa_lpuid(lps->bfa));
 
 	m->lp_tag    = lps->lp_tag;
 	m->port_name = lps->pwwn;
@@ -486,8 +554,8 @@ static void
 bfa_lps_login_comp(struct bfa_lps_s *lps)
 {
 	if (!lps->bfa->fcs) {
-		bfa_cb_queue(lps->bfa, &lps->hcb_qe,
-				bfa_lps_login_comp_cb, lps);
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_login_comp_cb,
+			lps);
 		return;
 	}
 
@@ -521,8 +589,8 @@ static void
 bfa_lps_logout_comp(struct bfa_lps_s *lps)
 {
 	if (!lps->bfa->fcs) {
-		bfa_cb_queue(lps->bfa, &lps->hcb_qe,
-				bfa_lps_logout_comp_cb, lps);
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_logout_comp_cb,
+			lps);
 		return;
 	}
 	if (lps->fdisc)
@@ -531,12 +599,55 @@ bfa_lps_logout_comp(struct bfa_lps_s *lps)
 		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
 }
 
+/**
+ * Clear virtual link completion handler for non-fcs
+ */
+static void
+bfa_lps_cvl_event_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps	= arg;
+
+	if (!complete)
+		return;
+
+	/* Clear virtual link to base port will result in link down */
+	if (lps->fdisc)
+		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
+}
+
+/**
+ * Received Clear virtual link event --direct call for fcs,
+ * queue for others
+ */
+static void
+bfa_lps_cvl_event(struct bfa_lps_s *lps)
+{
+	if (!lps->bfa->fcs) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_cvl_event_cb,
+			lps);
+		return;
+	}
+
+	/* Clear virtual link to base port will result in link down */
+	if (lps->fdisc)
+		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
+}
+
 
 
 /**
  *  lps_public BFA LPS public functions
  */
 
+u32
+bfa_lps_get_max_vport(struct bfa_s *bfa)
+{
+	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT)
+		return BFA_LPS_MAX_VPORTS_SUPP_CT;
+	else
+		return BFA_LPS_MAX_VPORTS_SUPP_CB;
+}
+
 /**
  * Allocate a lport srvice tag.
  */
@@ -752,6 +863,14 @@ bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
 	return lps->lsrjt_expl;
 }
 
+/**
+ * Return fpma/spma MAC for lport
+ */
+struct mac_s
+bfa_lps_get_lp_mac(struct bfa_lps_s *lps)
+{
+	return lps->lp_mac;
+}
 
 /**
  * LPS firmware message class handler.
@@ -773,6 +892,10 @@ bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 		bfa_lps_logout_rsp(bfa, msg.logout_rsp);
 		break;
 
+	case BFI_LPS_H2I_CVL_EVENT:
+		bfa_lps_rx_cvl_event(bfa, msg.cvl_event);
+		break;
+
 	default:
 		bfa_trc(bfa, m->mhdr.msg_id);
 		bfa_assert(0);
diff --git a/drivers/scsi/bfa/bfa_module.c b/drivers/scsi/bfa/bfa_module.c
index 32eda8e..a7fcc80 100644
--- a/drivers/scsi/bfa/bfa_module.c
+++ b/drivers/scsi/bfa/bfa_module.c
@@ -24,7 +24,7 @@
  */
 struct bfa_module_s *hal_mods[] = {
 	&hal_mod_sgpg,
-	&hal_mod_pport,
+	&hal_mod_fcport,
 	&hal_mod_fcxp,
 	&hal_mod_lps,
 	&hal_mod_uf,
@@ -45,7 +45,7 @@ bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
 	bfa_isr_unhandled,	/* BFI_MC_DIAG */
 	bfa_isr_unhandled,	/* BFI_MC_FLASH */
 	bfa_isr_unhandled,	/* BFI_MC_CEE */
-	bfa_pport_isr,		/* BFI_MC_PORT */
+	bfa_fcport_isr,		/* BFI_MC_FCPORT */
 	bfa_isr_unhandled,	/* BFI_MC_IOCFC */
 	bfa_isr_unhandled,	/* BFI_MC_LL */
 	bfa_uf_isr,		/* BFI_MC_UF */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index cab1902..440ad27 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -14,6 +14,12 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+/*
+ *      Copyright (c) 2007-2009 Brocade Communications Systems, Inc.
+ *      All rights reserved.
+ *
+ *      @file bfa_port.c Port module source file.
+ */
 
 #include <defs/bfa_defs_port.h>
 #include <cs/bfa_trc.h>
@@ -33,12 +39,11 @@ BFA_TRC_FILE(CNA, PORT);
 static void
 bfa_port_stats_swap(struct bfa_port_s *port, union bfa_pport_stats_u *stats)
 {
-	u32       *dip = (u32 *) stats;
-	u32        t0, t1;
-	int             i;
+	u32    *dip = (u32 *) stats;
+	u32    t0, t1;
+	int         i;
 
-	for (i = 0; i < sizeof(union bfa_pport_stats_u) / sizeof(u32);
-	     i += 2) {
+	for (i = 0; i < sizeof(union bfa_pport_stats_u)/sizeof(u32); i += 2) {
 		t0 = dip[i];
 		t1 = dip[i + 1];
 #ifdef __BIGENDIAN
@@ -48,9 +53,9 @@ bfa_port_stats_swap(struct bfa_port_s *port, union bfa_pport_stats_u *stats)
 		dip[i] = bfa_os_ntohl(t1);
 		dip[i + 1] = bfa_os_ntohl(t0);
 #endif
-	}
+    }
 
-    /** todo
+    /** @todo
      * QoS stats r also swapped as 64bit; that structure also
      * has to use 64 bit counters
      */
@@ -103,7 +108,7 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 
 	if (status == BFA_STATUS_OK) {
 		memcpy(port->stats, port->stats_dma.kva,
-		       sizeof(union bfa_pport_stats_u));
+				sizeof(union bfa_pport_stats_u));
 		bfa_port_stats_swap(port, port->stats);
 	}
 
@@ -126,7 +131,7 @@ static void
 bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 {
 	port->stats_status = status;
-	port->stats_busy = BFA_FALSE;
+	port->stats_busy   = BFA_FALSE;
 
 	if (port->stats_cbfn) {
 		port->stats_cbfn(port->stats_cbarg, status);
@@ -145,10 +150,10 @@ bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 static void
 bfa_port_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
-	struct bfa_port_s *port = (struct bfa_port_s *)cbarg;
+	struct bfa_port_s *port = (struct bfa_port_s *) cbarg;
 	union bfi_port_i2h_msg_u *i2hmsg;
 
-	i2hmsg = (union bfi_port_i2h_msg_u *)m;
+	i2hmsg = (union bfi_port_i2h_msg_u *) m;
 	bfa_trc(port, m->mh.msg_id);
 
 	switch (m->mh.msg_id) {
@@ -165,9 +170,7 @@ bfa_port_isr(void *cbarg, struct bfi_mbmsg_s *m)
 		break;
 
 	case BFI_PORT_I2H_GET_STATS_RSP:
-		/*
-		 * Stats busy flag is still set? (may be cmd timed out)
-		 */
+		/* Stats busy flag is still set? (may be cmd timed out) */
 		if (port->stats_busy == BFA_FALSE)
 			break;
 		bfa_port_get_stats_isr(port, i2hmsg->getstats_rsp.status);
@@ -203,8 +206,8 @@ bfa_port_meminfo(void)
  *
  *
  * @param[in] port Port module pointer
- * 	      dma_kva Kernel Virtual Address of Port DMA Memory
- * 	      dma_pa  Physical Address of Port DMA Memory
+ *	      dma_kva Kernel Virtual Address of Port DMA Memory
+ *	      dma_pa  Physical Address of Port DMA Memory
  *
  * @return void
  */
@@ -212,7 +215,7 @@ void
 bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva, u64 dma_pa)
 {
 	port->stats_dma.kva = dma_kva;
-	port->stats_dma.pa = dma_pa;
+	port->stats_dma.pa  = dma_pa;
 }
 
 /**
@@ -226,11 +229,11 @@ bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva, u64 dma_pa)
  */
 bfa_status_t
 bfa_port_enable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
-		void *cbarg)
+		 void *cbarg)
 {
 	struct bfi_port_generic_req_s *m;
 
-	/** todo Not implemented */
+	/** @todo Not implemented */
 	bfa_assert(0);
 
 	if (!bfa_ioc_is_operational(port->ioc)) {
@@ -240,14 +243,14 @@ bfa_port_enable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
 
 	if (port->endis_pending) {
 		bfa_trc(port, BFA_STATUS_DEVBUSY);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 
-	m = (struct bfi_port_generic_req_s *)port->endis_mb.msg;
+	m = (struct bfi_port_generic_req_s *) port->endis_mb.msg;
 
 	port->msgtag++;
-	port->endis_cbfn = cbfn;
-	port->endis_cbarg = cbarg;
+	port->endis_cbfn    = cbfn;
+	port->endis_cbarg   = cbarg;
 	port->endis_pending = BFA_TRUE;
 
 	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_ENABLE_REQ,
@@ -268,11 +271,11 @@ bfa_port_enable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
  */
 bfa_status_t
 bfa_port_disable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
-		 void *cbarg)
+		  void *cbarg)
 {
 	struct bfi_port_generic_req_s *m;
 
-	/** todo Not implemented */
+	/** @todo Not implemented */
 	bfa_assert(0);
 
 	if (!bfa_ioc_is_operational(port->ioc)) {
@@ -282,14 +285,14 @@ bfa_port_disable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
 
 	if (port->endis_pending) {
 		bfa_trc(port, BFA_STATUS_DEVBUSY);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 
-	m = (struct bfi_port_generic_req_s *)port->endis_mb.msg;
+	m = (struct bfi_port_generic_req_s *) port->endis_mb.msg;
 
 	port->msgtag++;
-	port->endis_cbfn = cbfn;
-	port->endis_cbarg = cbarg;
+	port->endis_cbfn    = cbfn;
+	port->endis_cbarg   = cbarg;
 	port->endis_pending = BFA_TRUE;
 
 	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_DISABLE_REQ,
@@ -310,7 +313,7 @@ bfa_port_disable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
  */
 bfa_status_t
 bfa_port_get_stats(struct bfa_port_s *port, union bfa_pport_stats_u *stats,
-		   bfa_port_stats_cbfn_t cbfn, void *cbarg)
+		    bfa_port_stats_cbfn_t cbfn, void *cbarg)
 {
 	struct bfi_port_get_stats_req_s *m;
 
@@ -321,15 +324,15 @@ bfa_port_get_stats(struct bfa_port_s *port, union bfa_pport_stats_u *stats,
 
 	if (port->stats_busy) {
 		bfa_trc(port, BFA_STATUS_DEVBUSY);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 
-	m = (struct bfi_port_get_stats_req_s *)port->stats_mb.msg;
+	m = (struct bfi_port_get_stats_req_s *) port->stats_mb.msg;
 
-	port->stats = stats;
-	port->stats_cbfn = cbfn;
+	port->stats	  = stats;
+	port->stats_cbfn  = cbfn;
 	port->stats_cbarg = cbarg;
-	port->stats_busy = BFA_TRUE;
+	port->stats_busy  = BFA_TRUE;
 	bfa_dma_be_addr_set(m->dma_addr, port->stats_dma.pa);
 
 	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_GET_STATS_REQ,
@@ -349,7 +352,7 @@ bfa_port_get_stats(struct bfa_port_s *port, union bfa_pport_stats_u *stats,
  */
 bfa_status_t
 bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
-		     void *cbarg)
+		      void *cbarg)
 {
 	struct bfi_port_generic_req_s *m;
 
@@ -360,14 +363,14 @@ bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
 
 	if (port->stats_busy) {
 		bfa_trc(port, BFA_STATUS_DEVBUSY);
-		return BFA_STATUS_DEVBUSY;
+		return 	BFA_STATUS_DEVBUSY;
 	}
 
-	m = (struct bfi_port_generic_req_s *)port->stats_mb.msg;
+	m = (struct bfi_port_generic_req_s *) port->stats_mb.msg;
 
-	port->stats_cbfn = cbfn;
+	port->stats_cbfn  = cbfn;
 	port->stats_cbarg = cbarg;
-	port->stats_busy = BFA_TRUE;
+	port->stats_busy  = BFA_TRUE;
 
 	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_CLEAR_STATS_REQ,
 		    bfa_ioc_portid(port->ioc));
@@ -387,11 +390,9 @@ bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
 void
 bfa_port_hbfail(void *arg)
 {
-	struct bfa_port_s *port = (struct bfa_port_s *)arg;
+	struct bfa_port_s *port = (struct bfa_port_s *) arg;
 
-	/*
-	 * Fail any pending get_stats/clear_stats requests
-	 */
+	/* Fail any pending get_stats/clear_stats requests */
 	if (port->stats_busy) {
 		if (port->stats_cbfn)
 			port->stats_cbfn(port->dev, BFA_STATUS_FAILED);
@@ -399,9 +400,7 @@ bfa_port_hbfail(void *arg)
 		port->stats_busy = BFA_FALSE;
 	}
 
-	/*
-	 * Clear any enable/disable is pending
-	 */
+	/* Clear any enable/disable is pending */
 	if (port->endis_pending) {
 		if (port->endis_cbfn)
 			port->endis_cbfn(port->dev, BFA_STATUS_FAILED);
@@ -425,18 +424,21 @@ bfa_port_hbfail(void *arg)
  * @return void
  */
 void
-bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc, void *dev,
-		struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod)
+bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
+		 void *dev, struct bfa_trc_mod_s *trcmod,
+		 struct bfa_log_mod_s *logmod)
 {
 	bfa_assert(port);
 
-	port->dev = dev;
-	port->ioc = ioc;
+	port->dev    = dev;
+	port->ioc    = ioc;
 	port->trcmod = trcmod;
 	port->logmod = logmod;
 
-	port->stats_busy = port->endis_pending = BFA_FALSE;
-	port->stats_cbfn = port->endis_cbfn = NULL;
+	port->stats_busy =
+	port->endis_pending = BFA_FALSE;
+	port->stats_cbfn =
+	port->endis_cbfn = NULL;
 
 	bfa_ioc_mbox_regisr(port->ioc, BFI_MC_PORT, bfa_port_isr, port);
 	bfa_ioc_hbfail_init(&port->hbfail, bfa_port_hbfail, port);
diff --git a/drivers/scsi/bfa/bfa_rport.c b/drivers/scsi/bfa/bfa_rport.c
index 3e1990a..ebf2e5d 100644
--- a/drivers/scsi/bfa/bfa_rport.c
+++ b/drivers/scsi/bfa/bfa_rport.c
@@ -46,12 +46,14 @@ BFA_MODULE(rport);
  * forward declarations
  */
 static struct bfa_rport_s *bfa_rport_alloc(struct bfa_rport_mod_s *rp_mod);
-static void bfa_rport_free(struct bfa_rport_s *rport);
-static bfa_boolean_t bfa_rport_send_fwcreate(struct bfa_rport_s *rp);
-static bfa_boolean_t bfa_rport_send_fwdelete(struct bfa_rport_s *rp);
-static bfa_boolean_t bfa_rport_send_fwspeed(struct bfa_rport_s *rp);
-static void __bfa_cb_rport_online(void *cbarg, bfa_boolean_t complete);
-static void __bfa_cb_rport_offline(void *cbarg, bfa_boolean_t complete);
+static void		bfa_rport_free(struct bfa_rport_s *rport);
+static bfa_boolean_t 	bfa_rport_send_fwcreate(struct bfa_rport_s *rp);
+static bfa_boolean_t	bfa_rport_send_fwdelete(struct bfa_rport_s *rp);
+static bfa_boolean_t	bfa_rport_send_fwspeed(struct bfa_rport_s *rp);
+static void		__bfa_cb_rport_online(void *cbarg,
+							bfa_boolean_t complete);
+static void		__bfa_cb_rport_offline(void *cbarg,
+							bfa_boolean_t complete);
 
 /**
  *  bfa_rport_sm BFA rport state machine
@@ -114,7 +116,7 @@ bfa_rport_sm_uninit(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_un_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -146,7 +148,7 @@ bfa_rport_sm_created(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_cr_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -183,7 +185,7 @@ bfa_rport_sm_fwcreate(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwc_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -224,7 +226,7 @@ bfa_rport_sm_fwcreate_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwc_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -296,7 +298,7 @@ bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_on_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -329,7 +331,7 @@ bfa_rport_sm_fwdelete(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -359,7 +361,7 @@ bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -394,7 +396,7 @@ bfa_rport_sm_offline(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_off_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -421,7 +423,7 @@ bfa_rport_sm_deleting(struct bfa_rport_s *rp, enum bfa_rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -446,7 +448,7 @@ bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -477,7 +479,7 @@ bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
 
 	default:
 		bfa_stats(rp, sm_delp_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -512,7 +514,7 @@ bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
 
 	default:
 		bfa_stats(rp, sm_offp_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -550,7 +552,7 @@ bfa_rport_sm_iocdisable(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_iocd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_tskim.c b/drivers/scsi/bfa/bfa_tskim.c
index ff7a4dc..cca811a 100644
--- a/drivers/scsi/bfa/bfa_tskim.c
+++ b/drivers/scsi/bfa/bfa_tskim.c
@@ -25,12 +25,12 @@ BFA_TRC_FILE(HAL, TSKIM);
  */
 #define bfa_tskim_qcomp(__tskim, __cbfn) do {			\
 	bfa_cb_queue((__tskim)->bfa, &(__tskim)->hcb_qe,	\
-			 __cbfn, (__tskim));      \
+				__cbfn, (__tskim));      \
 	bfa_tskim_notify_comp(__tskim);      \
 } while (0)
 
-#define bfa_tskim_notify_comp(__tskim) do {			 \
-	if ((__tskim)->notify)					 \
+#define bfa_tskim_notify_comp(__tskim) do {			\
+	if ((__tskim)->notify)					\
 		bfa_itnim_tskdone((__tskim)->itnim);      \
 } while (0)
 
@@ -110,7 +110,7 @@ bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -146,7 +146,7 @@ bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -178,7 +178,7 @@ bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -207,7 +207,7 @@ bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -242,7 +242,7 @@ bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -277,7 +277,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -303,7 +303,7 @@ bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
-- 
1.6.5.2

