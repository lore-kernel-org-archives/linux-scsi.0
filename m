Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F43D3012
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451706; cv=none; b=p3BtfCOsDxXGmUkFNFRLpqWw/FYcWXpYch2UYS2Cg1VCpQAUwe9wYFJICQ56jpqECo/4OGF+XgK9KCuk5ISh43Ieaju6okUt7A8ITKEHpo2bk6xM/zdbx2ejJGnRAZOzD/alp52YeCBJyn3PfAnHIChnhcv7ehh+c9+eC9zMdKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451706; c=relaxed/simple;
	bh=NyAM3STxT0XBr/vOMCjiAWre6k9oQjeVL1U+3kPfLKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=julm78IPG3PvcgqW+M/bCi2X+1nGEJaK0g5aT9XyTqv+Am+EUOZlDpBLPXsCCU0ShofkKD/RgSOZvwgtgOiMXB25bPhLXAuds7GjaANdHZprU9FWkiKxqpHIqRQpYE6BJ1//Y82IMD8iJEKvRz2bapZUnoEi8Hwdh/OyXwA/utQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JOk+kgfb; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JOk+kgfb"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49g6BqBz1XM6Jk;
	Thu, 30 Jul 2026 22:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451686; x=1788043687; bh=V4CTO
	lIYp1WHmqaL6yBAzssghJLcc2+Q7+j3K8qwAto=; b=JOk+kgfbGy2yXZ3mJkJDo
	I+RGtYd8DDL7oPqmE09jRV9FGR9O2k2mji81uHxQS2yAKU+VVBaX8AfkDuIt64C3
	MMHEtGZ6EDQUbJ0s8v9FytfCEBUmMvN6HV2fnjtGm6NbindTBl+9iI20Sy2uRDMX
	bwwxnoBJcQqpjqTAK5z0wJ4tg05iYhcoClz6BeT4AJJmzPDd74daEn9AkayJr/G/
	T2+WBk97oqlD9Fvh3QhzBPsHNnwzZ7ergpHGL7mAFM5GsoK0fYmZiMZMhcIpmVcz
	17elbngpDZpjpdIqMBTu0MVXdlAIursJ2zwio1i+U7TaDpVwBX8sNFZbiNyc24+j
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ebDbKCDpNfKJ; Thu, 30 Jul 2026 22:48:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49J29Vyz1XM30k;
	Thu, 30 Jul 2026 22:48:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 26/57] scsi: fnic: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:09 -0700
Message-ID: <d10f7eaef0e297d1b78d1ba484b05686e185d8c7.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold(). Suppress complaints
about conditional locking in fnic_device_reset() with __acquire() and
__release().

Acked-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/Makefile    |  3 ++
 drivers/scsi/fnic/fdls_disc.c | 52 +++++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fip.c       |  2 ++
 drivers/scsi/fnic/fnic_fcs.c  |  6 ++++
 drivers/scsi/fnic/fnic_scsi.c |  4 +++
 5 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
index 48c5e0cb8ca6..22a463380dee 100644
--- a/drivers/scsi/fnic/Makefile
+++ b/drivers/scsi/fnic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_FCOE_FNIC) +=3D fnic.o
=20
 fnic-y	:=3D \
diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
index 8cb40466872f..e64fe1097e37 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -417,6 +417,7 @@ static void fdls_reset_oxid_pool(struct fnic_iport_s =
*iport)
 }
=20
 void fnic_del_fabric_timer_sync(struct fnic *fnic)
+	__must_hold(&fnic->fnic_lock)
 {
 	fnic->iport.fabric.del_timer_inprogress =3D 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -425,8 +426,8 @@ void fnic_del_fabric_timer_sync(struct fnic *fnic)
 	fnic->iport.fabric.del_timer_inprogress =3D 0;
 }
=20
-void fnic_del_tport_timer_sync(struct fnic *fnic,
-						struct fnic_tport_s *tport)
+void fnic_del_tport_timer_sync(struct fnic *fnic, struct fnic_tport_s *t=
port)
+	__must_hold(&fnic->fnic_lock)
 {
 	tport->del_timer_inprogress =3D 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -437,6 +438,7 @@ void fnic_del_tport_timer_sync(struct fnic *fnic,
=20
 static void
 fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -462,6 +464,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, i=
nt timeout)
 static void
 fdls_start_tport_timer(struct fnic_iport_s *iport,
 					   struct fnic_tport_s *tport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -717,6 +720,7 @@ int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	uint8_t s_id[3];
@@ -760,7 +764,9 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout =
*/
 	fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
 }
+
 static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	uint8_t s_id[3];
@@ -932,6 +938,7 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *=
iport)
 }
=20
 static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pflogi;
@@ -992,6 +999,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport_=
s *iport)
 }
=20
 static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -1084,6 +1092,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_=
s *iport)
 }
=20
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rpn_id *prpn_id;
@@ -1143,6 +1152,7 @@ static void fdls_send_rpn_id(struct fnic_iport_s *i=
port)
 }
=20
 static void fdls_send_scr(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_scr *pscr;
@@ -1198,6 +1208,7 @@ static void fdls_send_scr(struct fnic_iport_s *ipor=
t)
 }
=20
 static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_gpn_ft *pgpn_ft;
@@ -1257,6 +1268,7 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *i=
port, int fdls_state)
=20
 static void
 fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_adisc *padisc;
@@ -1322,6 +1334,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
 }
=20
 bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *=
tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_event_s *tport_del_evt;
 	struct fnic *fnic =3D iport->fnic;
@@ -1387,6 +1400,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
=20
 static void
 fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -1455,6 +1469,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
 }
=20
 static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rft_id *prft_id;
@@ -1522,6 +1537,7 @@ static void fdls_send_register_fc4_types(struct fni=
c_iport_s *iport)
 }
=20
 static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rff_id *prff_id;
@@ -1581,6 +1597,7 @@ static void fdls_send_register_fc4_features(struct =
fnic_iport_s *iport)
=20
 static void
 fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tpor=
t)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_prli *pprli;
@@ -1662,6 +1679,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, stru=
ct fnic_tport_s *tport)
  * Currently this assumes to be called with fnic lock held.
  */
 void fdls_send_fabric_logo(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_logo *plogo;
@@ -1761,6 +1779,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport, st=
ruct fnic_tport_s *tport)
 }
=20
 static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	u32 old_link_down_cnt =3D iport->fnic->link_down_cnt;
@@ -1811,6 +1830,7 @@ static void fdls_tgt_discovery_start(struct fnic_ip=
ort_s *iport)
  * pointing to it will be freed later
  */
 static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
+	__must_hold(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_lock)
 {
 	struct fnic_iport_s *iport =3D tport->iport;
 	struct fnic_tport_s *new_tport =3D NULL;
@@ -2617,6 +2637,7 @@ static void fdls_tport_timer_callback(struct timer_=
list *t)
 }
=20
 static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_flogi(iport);
@@ -2625,6 +2646,7 @@ static void fnic_fdls_start_flogi(struct fnic_iport=
_s *iport)
 }
=20
 static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_plogi(iport);
@@ -2643,6 +2665,7 @@ static void fnic_fdls_start_plogi(struct fnic_iport=
_s *iport)
 static void
 fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2733,6 +2756,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *ipo=
rt,
 static void
 fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2767,6 +2791,8 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ipo=
rt,
 	if (tport->state !=3D FDLS_TGT_STATE_PLOGI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			     "PLOGI rsp recvd in wrong state. Drop the frame and restart nexu=
s");
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fdls_target_restart_nexus(tport);
 		return;
 	}
@@ -2854,9 +2880,11 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ip=
ort,
 	fdls_set_tport_state(tport, FDLS_TGT_STATE_PRLI);
 	fdls_send_tgt_prli(iport, tport);
 }
+
 static void
 fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2893,6 +2921,8 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 	if (tport->state !=3D FDLS_TGT_STATE_PRLI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			     "PRLI rsp recvd in wrong state. Drop frame. Restarting nexus");
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fdls_target_restart_nexus(tport);
 		return;
 	}
@@ -3025,6 +3055,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 static void
 fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -3098,6 +3129,7 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rft_id *rft_rsp =3D (struct fc_std_rft_id *) fchdr;
@@ -3173,6 +3205,7 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rpn_id *rpn_rsp =3D (struct fc_std_rpn_id *) fchdr;
@@ -3243,6 +3276,7 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_scr_rsp(struct fnic_iport_s *iport,
 		     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_scr *scr_rsp =3D (struct fc_std_scr *) fchdr;
@@ -3315,6 +3349,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_gpn_ft_rsp_iu *gpn_ft_tgt;
 	struct fnic_tport_s *tport, *next;
@@ -3413,6 +3448,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
 static void
 fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_gpn_ft *gpn_ft_rsp =3D (struct fc_std_gpn_ft *) fchdr;
@@ -3549,6 +3585,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *flogo_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -3602,6 +3639,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *i=
port,
 static void
 fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		       struct fc_frame_header *fchdr, void *rx_frame)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fabric =3D &iport->fabric;
 	struct fc_std_flogi *flogi_rsp =3D (struct fc_std_flogi *) fchdr;
@@ -3741,6 +3779,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 			      struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *plogi_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fc_std_els_rjt_rsp *els_rjt =3D (struct fc_std_els_rjt_rsp *) fc=
hdr;
@@ -4002,6 +4041,7 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_=
iport_s *iport,
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fc_std_abts_ba_acc *ba_acc =3D (struct fc_std_abts_ba_acc *)fchd=
r;
@@ -4359,6 +4399,7 @@ fdls_process_els_req(struct fnic_iport_s *iport, st=
ruct fc_frame_header *fchdr,
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fnic_tport_s *tport;
@@ -4548,6 +4589,7 @@ fdls_process_plogi_req(struct fnic_iport_s *iport,
=20
 static void
 fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header=
 *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_logo *logo =3D (struct fc_std_logo *)fchdr;
 	uint32_t nport_id;
@@ -4588,6 +4630,8 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
 		FNIC_FCS_DBG(KERN_ERR, fnic,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fnic_del_tport_timer_sync(fnic, tport);
 		tport->timer_pending =3D 0;
 	}
@@ -4625,6 +4669,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
=20
 static void
 fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fc=
hdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_rscn *rscn;
 	struct fc_els_rscn_page *rscn_port =3D NULL;
@@ -4758,6 +4803,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struc=
t fc_frame_header *fchdr)
 }
=20
 void fnic_fdls_disc_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
=20
@@ -5102,6 +5148,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_i=
port_s *iport,
=20
 void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 						  int len, int fchdr_offset)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_frame_header *fchdr;
 	uint32_t s_id =3D 0;
@@ -5223,6 +5270,7 @@ void fnic_fdls_disc_init(struct fnic_iport_s *iport=
)
 }
=20
 void fnic_fdls_link_down(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	struct fnic *fnic =3D iport->fnic;
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 21d08a710f0d..6bca0dd89ee1 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -602,6 +602,7 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
  * and clean up and restart the vlan discovery.
  */
 void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header *fiph)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct fnic_iport_s *iport =3D &fnic->iport;
 	struct fip_cvl *cvl_msg =3D (struct fip_cvl *)fiph;
@@ -678,6 +679,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct =
fip_header *fiph)
  * @frame: Received ethernet frame
  */
 int fdls_fip_recv_frame(struct fnic *fnic, void *frame)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct ethhdr *eth =3D (struct ethhdr *)frame;
 	struct fip_header *fiph;
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index b00672ef8b00..d1d860275b60 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -944,6 +944,7 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic=
_wq_buf *buf)
 void
 fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt,
 					unsigned long flags)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct fc_rport *rport;
@@ -983,6 +984,7 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struc=
t fnic_tport_s *tport,
 void
 fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 					   struct fnic_tport_s *tport, unsigned long flags)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct rport_dd_data_s *rdd_data;
@@ -1032,6 +1034,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	/* Tell the compiler that fnic->iport.fnic =3D=3D fnic. */
+	__assume_ctx_lock(&fnic->iport.fnic->fnic_lock);
 	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "removing fcp rport fcid: 0x%x", tport->fcid);
@@ -1059,6 +1063,8 @@ void fnic_tport_event_handler(struct work_struct *w=
ork)
 	struct fnic_tport_s *tport;
=20
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	/* Tell the compiler that fnic->iport.fnic =3D=3D fnic. */
+	__assume_ctx_lock(&fnic->iport.fnic->fnic_lock);
 	list_for_each_entry_safe(cur_evt, next, &fnic->tport_event_list, links)=
 {
 		tport =3D cur_evt->arg1;
 		switch (cur_evt->event) {
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
index 9607684bc610..afd6bf03b02d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2641,6 +2641,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		 * allocated by mid layer.
 		 */
 		mutex_lock(&fnic->sgreset_mutex);
+		/* Fake __release() to keep the lock context analyzer happy. */
+		__release(&fnic->sgreset_mutex);
 		mqtag =3D fnic->fnic_max_tag_id;
 		new_sc =3D 1;
 	}  else {
@@ -2826,6 +2828,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
=20
 	if (new_sc) {
 		fnic->sgreset_sc =3D NULL;
+		/* Fake __acquire() to keep the lock context analyzer happy. */
+		__acquire(&fnic->sgreset_mutex);
 		mutex_unlock(&fnic->sgreset_mutex);
 	}
=20
