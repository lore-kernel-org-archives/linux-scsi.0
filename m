Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48C33E3C4F
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451689; cv=none; b=MZEeGkq8IGBAD99GtnwuLxZtvieE4GscZpp3Dn42WRHHMHWhp3KREn6SYUPU5Qb/rqRBL3x/OwyTGxXICKAwqyTytPhDfJM/29Lrwbu1j2JmZkjlI9nMxzC0gh3EOV00a/dUbRiTWgbbRR6e/5mJxmGzUsmdzBwUXQPRiaEEhdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451689; c=relaxed/simple;
	bh=nIa/WoGJIRglcei7T+Vw1Kii6f5LnYnWAWw3lsDHShs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a79ttmE9HeIwkkrrLpu2TUwP65dAUtWex4csi4JNIGINs6oYIeuRhTdx3l97zVviiBWZYsA+73qq1zMKC4kwk3oNVQO3OxUkA0SMtX3+VAGAkVrhngy73HjTXi2yYyFXjBuiGevkffBkPvV15Zdh+V9Y2X76XoxzlGUx9fBxlWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NjuY5s7f; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NjuY5s7f"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49M2cRBz1XM6Jm;
	Thu, 30 Jul 2026 22:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451677; x=1788043678; bh=NI4Pu
	OkEkod14lyLshx6gbiQLc0A14YvTuDBrF6GIYA=; b=NjuY5s7fMAAVsuja8pBts
	tjzrkHc3Q7pHaAhjFAnwI/Q83vg5Dnx4X5mu46vY9UW6pi6HkTcYv82n4FPFUQY9
	Gae5oy9EWU37VEj4hwgarm/YeYb24mhuHW8fzw5Nwy+omF70Tg/R7xv6Anc7f//n
	068WCBOtvtNrK9J1RwGofnVQ4vO1TtM+EAcw+Na4J9fM0d6zuefWE8klqeszR0gj
	sjEpmqQzrApftABDCT5bj6LMY0jGncUtZJTSM0e0qaGhoaMAeubCjoKCSpfjrGyC
	eJok6/dlMVHn5G8XsVjtFG3LyMiqgIRrLSKriap590avsu2zw137Lmt9pNTdPlQW
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xybyPmbdfg35; Thu, 30 Jul 2026 22:47:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49761L8z1XM4TB;
	Thu, 30 Jul 2026 22:47:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH v3 22/57] scsi: csiostor: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:05 -0700
Message-ID: <b277d54df1ff40479d78f95edbd9450f6dfefb7c.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document lock context requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/Makefile     |  2 ++
 drivers/scsi/csiostor/csio_hw.c    | 12 ++++++++++++
 drivers/scsi/csiostor/csio_lnode.c |  3 +++
 drivers/scsi/csiostor/csio_rnode.c |  6 ++++++
 drivers/scsi/csiostor/csio_scsi.c  |  6 ++++++
 5 files changed, 29 insertions(+)

diff --git a/drivers/scsi/csiostor/Makefile b/drivers/scsi/csiostor/Makef=
ile
index d047e22eac0d..a19031efa7c4 100644
--- a/drivers/scsi/csiostor/Makefile
+++ b/drivers/scsi/csiostor/Makefile
@@ -4,6 +4,8 @@
 #
 ##
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
=20
 obj-$(CONFIG_SCSI_CHELSIO_FCOE) +=3D csiostor.o
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio=
_hw.c
index df9f81f29950..4b4d3c42667f 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -914,6 +914,7 @@ csio_hw_dev_ready(struct csio_hw *hw)
  */
 static int
 csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp;
 	int	rv =3D 0;
@@ -2050,6 +2051,7 @@ csio_hw_flash_config(struct csio_hw *hw, u32 *fw_cf=
g_param, char *path)
  */
 static int
 csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp =3D NULL;
 	struct fw_caps_config_cmd *caps_cmd;
@@ -2475,6 +2477,7 @@ static int csio_hw_check_fwver(struct csio_hw *hw)
  */
 static void
 csio_hw_configure(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	int reset =3D 1;
 	int rv;
@@ -2604,6 +2607,7 @@ csio_hw_configure(struct csio_hw *hw)
  */
 static void
 csio_hw_initialize(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp;
 	enum fw_retval retval;
@@ -2778,6 +2782,7 @@ csio_hw_fatal_err(struct csio_hw *hw)
  */
 static void
 csio_hws_uninit(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -2803,6 +2808,7 @@ csio_hws_uninit(struct csio_hw *hw, enum csio_hw_ev=
 evt)
  */
 static void
 csio_hws_configuring(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -2988,6 +2994,7 @@ csio_hws_quiescing(struct csio_hw *hw, enum csio_hw=
_ev evt)
  */
 static void
 csio_hws_quiesced(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3013,6 +3020,7 @@ csio_hws_quiesced(struct csio_hw *hw, enum csio_hw_=
ev evt)
  */
 static void
 csio_hws_resetting(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3074,6 +3082,7 @@ csio_hws_removing(struct csio_hw *hw, enum csio_hw_=
ev evt)
  */
 static void
 csio_hws_pcierr(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3763,6 +3772,7 @@ csio_hw_mb_timer(struct timer_list *t)
  */
 static void
 csio_hw_mbm_cleanup(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	LIST_HEAD(cbfn_q);
=20
@@ -3883,6 +3893,7 @@ csio_free_evt(struct csio_hw *hw, struct csio_evt_m=
sg *evt_entry)
=20
 void
 csio_evtq_flush(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	uint32_t count;
 	count =3D 30;
@@ -4142,6 +4153,7 @@ csio_mgmt_tmo_handler(struct timer_list *t)
=20
 static void
 csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
+	__must_hold(&mgmtm->hw->lock)
 {
 	struct csio_hw *hw =3D mgmtm->hw;
 	struct csio_ioreq *io_req;
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/c=
sio_lnode.c
index 78d5ecd14f65..161973957976 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -872,6 +872,7 @@ csio_ln_read_fcf_entry(struct csio_lnode *ln,
 static void
 csio_handle_link_up(struct csio_hw *hw, uint8_t portid, uint32_t fcfi,
 		    uint32_t vnpi)
+	__must_hold(&hw->lock)
 {
 	struct csio_lnode *ln =3D NULL;
=20
@@ -1165,6 +1166,7 @@ csio_lns_uninit(struct csio_lnode *ln, enum csio_ln=
_ev evt)
  */
 static void
 csio_lns_online(struct csio_lnode *ln, enum csio_ln_ev evt)
+	__must_hold(&csio_lnode_to_hw(ln)->lock)
 {
 	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
=20
@@ -1216,6 +1218,7 @@ csio_lns_online(struct csio_lnode *ln, enum csio_ln=
_ev evt)
  */
 static void
 csio_lns_ready(struct csio_lnode *ln, enum csio_ln_ev evt)
+	__must_hold(&csio_lnode_to_hw(ln)->lock)
 {
 	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
=20
diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/c=
sio_rnode.c
index 713e13adf4dc..74ef1e858cf3 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -546,6 +546,7 @@ csio_rn_verify_rparams(struct csio_lnode *ln, struct =
csio_rnode *rn,
=20
 static void
 __csio_reg_rnode(struct csio_rnode *rn)
+	__must_hold(&csio_lnode_to_hw(csio_rnode_to_lnode(rn))->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
@@ -563,6 +564,7 @@ __csio_reg_rnode(struct csio_rnode *rn)
=20
 static void
 __csio_unreg_rnode(struct csio_rnode *rn)
+	__must_hold(&csio_lnode_to_hw(csio_rnode_to_lnode(rn))->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
@@ -602,6 +604,7 @@ __csio_unreg_rnode(struct csio_rnode *rn)
  */
 static void
 csio_rns_uninit(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -642,6 +645,7 @@ csio_rns_uninit(struct csio_rnode *rn, enum csio_rn_e=
v evt)
  */
 static void
 csio_rns_ready(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -727,6 +731,7 @@ csio_rns_ready(struct csio_rnode *rn, enum csio_rn_ev=
 evt)
  */
 static void
 csio_rns_offline(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -786,6 +791,7 @@ csio_rns_offline(struct csio_rnode *rn, enum csio_rn_=
ev evt)
  */
 static void
 csio_rns_disappeared(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
index b1de615cf316..b74fed463640 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1157,6 +1157,7 @@ csio_scsi_cmpl_handler(struct csio_hw *hw, void *wr=
, uint32_t len,
  */
 void
 csio_scsi_cleanup_io_q(struct csio_scsim *scm, struct list_head *q)
+	__must_hold(&scm->hw->lock)
 {
 	struct csio_hw *hw =3D scm->hw;
 	struct csio_ioreq *ioreq;
@@ -1231,6 +1232,7 @@ csio_abrt_cls(struct csio_ioreq *ioreq, struct scsi=
_cmnd *scmnd)
  */
 static int
 csio_scsi_abort_io_q(struct csio_scsim *scm, struct list_head *q, uint32=
_t tmo)
+	__must_hold(&scm->hw->lock)
 {
 	struct csio_hw *hw =3D scm->hw;
 	struct list_head *tmp, *next;
@@ -1271,6 +1273,7 @@ csio_scsi_abort_io_q(struct csio_scsim *scm, struct=
 list_head *q, uint32_t tmo)
  */
 int
 csio_scsim_cleanup_io(struct csio_scsim *scm, bool abort)
+	__must_hold(&scm->hw->lock)
 {
 	struct csio_hw *hw =3D scm->hw;
 	int rv =3D 0;
@@ -1316,6 +1319,7 @@ csio_scsim_cleanup_io(struct csio_scsim *scm, bool =
abort)
  */
 int
 csio_scsim_cleanup_io_lnode(struct csio_scsim *scm, struct csio_lnode *l=
n)
+	__must_hold(&scm->hw->lock)
 {
 	struct csio_hw *hw =3D scm->hw;
 	struct csio_scsi_level_data sld;
@@ -2192,6 +2196,8 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	 * completes, we gather pending I/Os after the LUN reset.
 	 */
 	spin_lock_irq(&hw->lock);
+	/* Tell the compiler that scsim->hw =3D=3D hw. */
+	__assume_ctx_lock(&scsim->hw->lock);
 	csio_scsi_gather_active_ios(scsim, &sld, &local_q);
=20
 	retval =3D csio_scsi_abort_io_q(scsim, &local_q, 30000);
