Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F4F31ED93
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361080; cv=none; b=hjlGOLVYpjjXQWaTjjORl56Css3cwpvOgLoY8sSZvITe+b1QagheYVzdNABVZcru9y5yq4TFj9b0TSL28PC0sov6ZU5N/wJDiuw5Qh+gq0GGECrHB0X7NfE3GwCUjbyUdTWVpxzWvN0HU9932n8cROJJe9a/asaD3XgEUud/t4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361080; c=relaxed/simple;
	bh=MBEz+k+F8Itc7CZ4vnq4BAddJdoN4bF4v0+cjerQv38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWo27IEzw53sqjVzM1fwl5+Pa7eq4B2VpShVr4GoTT/+x1vrlKhFfozS0y2v4Gygrbuu91su2W1+myAB6jyWRmrP53kLMqV0NFBuVBKLnluDkKGaMkY7+VDflEnAq+H/pavUTkqtfrTAZyUQiAqGXVomurQATXNxKXtU0v8+A8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RCTGvN5Y; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RCTGvN5Y"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmk2rPNz1XM30j;
	Fri, 25 Sep 2026 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361065; x=1792953066; bh=utvUC
	UIG08rCTk7heeeWz9XWcVrA2aAMmiBT3+Nql1o=; b=RCTGvN5YmcpTj7FkrJoTV
	SryOd81S6bJN0KUkCMtAigoNQm7sZgTL7uoBAWbjx5s34EyBJFivJlzLbxmCozWP
	exLbLI+YSmkq4x42wFwqIOf1EB8untJMrw0c9sbYrdplF5sYmKGtwwvdv4uVnIH2
	4UBxjGFzS4a/4tHPixLN47mwTeyA1sQgNgbgzOTAoAqki4SLr9t/PzoEjtwpzALi
	WIzmNUj5IMSmqgGy0uog1OeKUGmEnWzh/xFkgb7JvJRvLYLPnTGgUAjGtAoMEPV/
	AMHvZ7jPDtNFPXgB1TEAxCusxnA5VIhlgf0yOkuX/uG2hZboJ35f38EGGX4vTO4S
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id puOmzYBksO8f; Fri, 25 Sep 2026 18:31:05 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmQ0WPwz1XM5kW;
	Fri, 25 Sep 2026 18:31:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v4 21/54] scsi: csiostor: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:59 -0700
Message-ID: <214dee25ec4dab987380b8bd9d296303f9399691.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements across the csiostor driver by annotating
functions in csio_hw.c, csio_lnode.c, csio_rnode.c, and csio_scsi.c with
__must_hold(). Enable lock context analysis by setting CONTEXT_ANALYSIS
in the Makefile.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/Makefile     |  2 ++
 drivers/scsi/csiostor/csio_hw.c    | 14 +++++++++++++-
 drivers/scsi/csiostor/csio_lnode.c |  3 +++
 drivers/scsi/csiostor/csio_rnode.c |  6 ++++++
 drivers/scsi/csiostor/csio_scsi.c  |  4 ++++
 5 files changed, 28 insertions(+), 1 deletion(-)

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
index d8ed326dc602..b5a36615a22b 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -92,7 +92,7 @@ static void csio_hw_mbm_cleanup(struct csio_hw *);
 static void csio_hws_uninit(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_configuring(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_initializing(struct csio_hw *, enum csio_hw_ev);
-static void csio_hws_ready(struct csio_hw *, enum csio_hw_ev)
+static void csio_hws_ready(struct csio_hw *hw, enum csio_hw_ev)
 	__must_hold(&hw->lock);
 static void csio_hws_quiescing(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_quiesced(struct csio_hw *, enum csio_hw_ev);
@@ -915,6 +915,7 @@ csio_hw_dev_ready(struct csio_hw *hw)
  */
 static int
 csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp;
 	int	rv =3D 0;
@@ -2051,6 +2052,7 @@ csio_hw_flash_config(struct csio_hw *hw, u32 *fw_cf=
g_param, char *path)
  */
 static int
 csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp =3D NULL;
 	struct fw_caps_config_cmd *caps_cmd;
@@ -2476,6 +2478,7 @@ static int csio_hw_check_fwver(struct csio_hw *hw)
  */
 static void
 csio_hw_configure(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	int reset =3D 1;
 	int rv;
@@ -2605,6 +2608,7 @@ csio_hw_configure(struct csio_hw *hw)
  */
 static void
 csio_hw_initialize(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	struct csio_mb	*mbp;
 	enum fw_retval retval;
@@ -2779,6 +2783,7 @@ csio_hw_fatal_err(struct csio_hw *hw)
  */
 static void
 csio_hws_uninit(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -2804,6 +2809,7 @@ csio_hws_uninit(struct csio_hw *hw, enum csio_hw_ev=
 evt)
  */
 static void
 csio_hws_configuring(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -2990,6 +2996,7 @@ csio_hws_quiescing(struct csio_hw *hw, enum csio_hw=
_ev evt)
  */
 static void
 csio_hws_quiesced(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3015,6 +3022,7 @@ csio_hws_quiesced(struct csio_hw *hw, enum csio_hw_=
ev evt)
  */
 static void
 csio_hws_resetting(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3076,6 +3084,7 @@ csio_hws_removing(struct csio_hw *hw, enum csio_hw_=
ev evt)
  */
 static void
 csio_hws_pcierr(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	hw->prev_evt =3D hw->cur_evt;
 	hw->cur_evt =3D evt;
@@ -3765,6 +3774,7 @@ csio_hw_mb_timer(struct timer_list *t)
  */
 static void
 csio_hw_mbm_cleanup(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	LIST_HEAD(cbfn_q);
=20
@@ -3885,6 +3895,7 @@ csio_free_evt(struct csio_hw *hw, struct csio_evt_m=
sg *evt_entry)
=20
 void
 csio_evtq_flush(struct csio_hw *hw)
+	__must_hold(&hw->lock)
 {
 	uint32_t count;
 	count =3D 30;
@@ -4144,6 +4155,7 @@ csio_mgmt_tmo_handler(struct timer_list *t)
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
index 46d82802a5d4..fe985836c15c 100644
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
@@ -601,6 +603,7 @@ __csio_unreg_rnode(struct csio_rnode *rn)
  */
 static void
 csio_rns_uninit(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -641,6 +644,7 @@ csio_rns_uninit(struct csio_rnode *rn, enum csio_rn_e=
v evt)
  */
 static void
 csio_rns_ready(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -726,6 +730,7 @@ csio_rns_ready(struct csio_rnode *rn, enum csio_rn_ev=
 evt)
  */
 static void
 csio_rns_offline(struct csio_rnode *rn, enum csio_rn_ev evt)
+	__must_hold(&csio_rnode_to_lnode(rn)->hwp->lock)
 {
 	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
 	int ret =3D 0;
@@ -785,6 +790,7 @@ csio_rns_offline(struct csio_rnode *rn, enum csio_rn_=
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
index b1473e1f514f..d81d10603fcc 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1156,6 +1156,7 @@ csio_scsi_cmpl_handler(struct csio_hw *hw, void *wr=
, uint32_t len,
  * Called with lock held. Has to exit with lock held.
  */
 void csio_scsi_cleanup_io_q(struct csio_hw *hw, struct list_head *q)
+	__must_hold(&hw->lock)
 {
 	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	struct csio_ioreq *ioreq;
@@ -1230,6 +1231,7 @@ csio_abrt_cls(struct csio_ioreq *ioreq, struct scsi=
_cmnd *scmnd)
  */
 static int csio_scsi_abort_io_q(struct csio_hw *hw, struct list_head *q,
 				uint32_t tmo)
+	__must_hold(&hw->lock)
 {
 	struct list_head *tmp, *next;
 	int count =3D DIV_ROUND_UP(tmo, CSIO_SCSI_ABORT_Q_POLL_MS);
@@ -1268,6 +1270,7 @@ static int csio_scsi_abort_io_q(struct csio_hw *hw,=
 struct list_head *q,
  * Can sleep when waiting for I/Os to complete.
  */
 int csio_scsim_cleanup_io(struct csio_hw *hw, bool abort)
+	__must_hold(&hw->lock)
 {
 	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	int rv =3D 0;
@@ -1312,6 +1315,7 @@ int csio_scsim_cleanup_io(struct csio_hw *hw, bool =
abort)
  * Can sleep (with dropped lock) when waiting for I/Os to complete.
  */
 int csio_scsim_cleanup_io_lnode(struct csio_hw *hw, struct csio_lnode *l=
n)
+	__must_hold(&hw->lock)
 {
 	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	struct csio_scsi_level_data sld;
