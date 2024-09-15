Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989CC1C462B;
	Sun, 15 Sep 2024 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405011; cv=none; b=BDziI0TxOV6myT+8hxZ6QTRthRKCoLVZUMroWqaqsD7OqphIQowJdfXFV8YnGxpSFpZ/B68S4Fs6UkzpnlOA+JvwzYrljpEqRil9ZpgG4weVKZFM/OSM6CxCjkifeRX8McO4UWEhzCtFu5zfIl+aXww8zMAjJxmJ4xNotChADdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405011; c=relaxed/simple;
	bh=R6LLtkpeCIekJYe7LpuUj5EUIDPCti23nz/Zen8QbCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Ip8ZUvhCcU2Hjwj/x3lxJ9Q+bq6Hpb/I4/mJsOf5ZSN7LCPxONvF+//Hx5z8xN3OVt99i9CtqrIl5oEnPD09Sf2RlJ7kazNjLaWoLeSx8r2keccixWJUthUp0RnAfL1srD+Rt5UUCAK0GEnvD0pgWeVmTCu/zWXGb8ZSUFwgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=D1xiU8+k; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="D1xiU8+k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=U11YBv5hWlywnn9J/vJDIRjAVtWXaNjv8LpfoZ9wdAE=; b=D1xiU8+kdCJp0X58
	d2Lhf7X8iKZ0+cnyrIVmenM6iSAduBkt4t2EE6fIQD5xoitDOvsjnj4EverdIXGE6FDHy9h40j0dI
	fKEUaM8I9P8nBr5wG0//Sgbrl6HBI9hYFAYOYCoH/wA4BVYCyC4JAOtoLPUJZtm34S/f1Xms6Kgf0
	5ESdsDAbQK4LG48YIaOeNXbWH9hxapQVt+9emOl6djh4IRU1uKbWITVWW+xhOao0+TR0lbh7DCr0s
	FNvZywLP5s08ozmAd5LSOZ1qJ7LQLlVP/R/+O9u3+qmxy2lbR45PXlwgxM6dRD9UGW9akCdRKfcIx
	0lFMXu7FyBHAc4pCVw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1spoo0-005pGt-1i;
	Sun, 15 Sep 2024 12:56:44 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/5] scsi: bfa: Remove unused bfa_svc code
Date: Sun, 15 Sep 2024 13:56:30 +0100
Message-ID: <20240915125633.25036-3-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

These functions aren't called anywhere, remove them.

Build tested only.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_modules.h |  1 -
 drivers/scsi/bfa/bfa_svc.c     | 72 ----------------------------------
 drivers/scsi/bfa/bfa_svc.h     |  5 ---
 3 files changed, 78 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 578e7678b056..ed29ebda30da 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -113,7 +113,6 @@ void bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
 void bfa_sgpg_attach(struct bfa_s *, void *bfad, struct bfa_iocfc_cfg_s *,
 		struct bfa_pcidev_s *);
-void bfa_uf_iocdisable(struct bfa_s *);
 void bfa_uf_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
 void bfa_uf_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 9f33aa303b18..df33afaaa673 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -913,14 +913,6 @@ bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp)
 	return reqbuf;
 }
 
-u32
-bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp)
-{
-	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
-
-	return mod->req_pld_sz;
-}
-
 /*
  * Get the internal response buffer pointer
  *
@@ -1023,21 +1015,6 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 	bfa_fcxp_queue(fcxp, send_req);
 }
 
-/*
- * Abort a BFA FCXP
- *
- * @param[in]	fcxp	BFA fcxp pointer
- *
- * @return		void
- */
-bfa_status_t
-bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
-{
-	bfa_trc(fcxp->fcxp_mod->bfa, fcxp->fcxp_tag);
-	WARN_ON(1);
-	return BFA_STATUS_OK;
-}
-
 void
 bfa_fcxp_req_rsp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
 	       bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *alloc_cbarg,
@@ -3857,15 +3834,6 @@ bfa_fcport_clr_hardalpa(struct bfa_s *bfa)
 	return BFA_STATUS_OK;
 }
 
-bfa_boolean_t
-bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	*alpa = fcport->cfg.hardalpa;
-	return fcport->cfg.cfg_hardalpa;
-}
-
 u8
 bfa_fcport_get_myalpa(struct bfa_s *bfa)
 {
@@ -3923,17 +3891,6 @@ bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
 /*
  * Get port attributes.
  */
-
-wwn_t
-bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	if (node)
-		return fcport->nwwn;
-	else
-		return fcport->pwwn;
-}
-
 void
 bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 {
@@ -4105,18 +4062,6 @@ bfa_fcport_is_ratelim(struct bfa_s *bfa)
 
 }
 
-/*
- *	Enable/Disable FAA feature in port config
- */
-void
-bfa_fcport_cfg_faa(struct bfa_s *bfa, u8 state)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, state);
-	fcport->cfg.faa_state = state;
-}
-
 /*
  * Get default minimum ratelim speed
  */
@@ -5528,23 +5473,6 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 		bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
 }
 
-void
-bfa_uf_iocdisable(struct bfa_s *bfa)
-{
-	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
-	struct bfa_uf_s *uf;
-	struct list_head *qe, *qen;
-
-	/* Enqueue unused uf resources to free_q */
-	list_splice_tail_init(&ufm->uf_unused_q, &ufm->uf_free_q);
-
-	list_for_each_safe(qe, qen, &ufm->uf_posted_q) {
-		uf = (struct bfa_uf_s *) qe;
-		list_del(&uf->qe);
-		bfa_uf_put(ufm, uf);
-	}
-}
-
 void
 bfa_uf_start(struct bfa_s *bfa)
 {
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 26eeee82bedc..99a960a8a2db 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -587,14 +587,12 @@ bfa_status_t bfa_fcport_cfg_topology(struct bfa_s *bfa,
 enum bfa_port_topology bfa_fcport_get_topology(struct bfa_s *bfa);
 enum bfa_port_topology bfa_fcport_get_cfg_topology(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
-bfa_boolean_t bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
 u8 bfa_fcport_get_myalpa(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_clr_hardalpa(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
 u16 bfa_fcport_get_maxfrsize(struct bfa_s *bfa);
 u8 bfa_fcport_get_rx_bbcredit(struct bfa_s *bfa);
 void bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr);
-wwn_t bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
 void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			enum bfa_port_linkstate event), void *event_cbarg);
@@ -619,7 +617,6 @@ bfa_boolean_t bfa_fcport_is_trunk_enabled(struct bfa_s *bfa);
 void bfa_fcport_dportenable(struct bfa_s *bfa);
 void bfa_fcport_dportdisable(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_is_pbcdisabled(struct bfa_s *bfa);
-void bfa_fcport_cfg_faa(struct bfa_s *bfa, u8 state);
 bfa_status_t bfa_fcport_cfg_bbcr(struct bfa_s *bfa,
 			bfa_boolean_t on_off, u8 bb_scn);
 bfa_status_t bfa_fcport_get_bbcr_attr(struct bfa_s *bfa,
@@ -687,8 +684,6 @@ void bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 		   bfa_cb_fcxp_send_t cbfn,
 		   void *cbarg,
 		   u32 rsp_maxlen, u8 rsp_timeout);
-bfa_status_t bfa_fcxp_abort(struct bfa_fcxp_s *fcxp);
-u32 bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
 u32 bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
 void bfa_fcxp_res_recfg(struct bfa_s *bfa, u16 num_fcxp_fw);
 
-- 
2.46.0

