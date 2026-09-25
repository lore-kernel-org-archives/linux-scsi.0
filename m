Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C604CDA2D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361099; cv=none; b=F+XFDMn/A3fHPw3yUBnZc7D9a/A5BEzyE9i/1UPH0qK0tkqK+KfJvn8PxLnXq779KtUQ/HMBi2mihozhqu9GZX5X6uUY74M61fMzUkW8h8BrF6BhrTmQoGdkt20+37fS62j27bgQh6JCrHt53qjGCeieQ0CPgnbhTJpdKiIxy90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361099; c=relaxed/simple;
	bh=zmFEMywwJeHmxccqNlBWdN2IbLYSLNEEeIp/yjvLwFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci1YCmeyo33TeS1xcluuLHjMGSspw3/758AfWLjtmW60JQZ8wgr87YAnNMmA3gmus+tej7qzpdQQIbSAxbdmGVLzqp526DAT20BrDoDx8MENELN2AFjCeY+1+aiD5X1uwt6FC8dd20jZkh9Xk1nfyzWmV8VQkLK61lWxtb6nnXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uAdarB3f; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uAdarB3f"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzn51wvSz1XM5kt;
	Fri, 25 Sep 2026 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361079; x=1792953080; bh=b4hxb
	K7VuzvI/9fyZtwIKKjvPULcvaYL7yK6rSIjaXk=; b=uAdarB3fsrni3TrIPNLiZ
	EUnB1qffjQmrG4qaWNrgmIFZa/vt8B4Wb02Bepd55HZsgG+OBGnnlCARSs6/kXLW
	dt0JeZWVq8VBljv1jb8N4ucWQLRX1pmN5TH4Riqo2MeayYmL91Tc1Nc5tCMwqIOY
	Ra+XlEtmzZynfGs/dLsgykdq6cSAjWvmatWnIALR/YE9D9CJTU0nTjbQEGmCgjbG
	KDlyck+Mwn8bQiG6+4f8A6Zpc3Ww/r3TU5rdPfFurlpu31XxpChkAdTIYyVKQZWa
	9y2TK1aY3HyTWvfVXHN7JzkBHAJ3UKHzjdQsHKlBF3WdcDRvh4C8izlu5pBRVavD
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xI3pTSYdd63I; Fri, 25 Sep 2026 18:31:19 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmj0vg0z1XM30h;
	Fri, 25 Sep 2026 18:31:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 26/54] scsi: fnic: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:04 -0700
Message-ID: <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold(). Suppress complaints
about conditional locking in fnic_device_reset() with __acquire() and
__release().

Cc: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/Makefile    |  3 +++
 drivers/scsi/fnic/fdls_disc.c | 46 +++++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fip.c       |  2 ++
 drivers/scsi/fnic/fnic_fcs.c  |  2 ++
 drivers/scsi/fnic/fnic_scsi.c |  4 +++
 5 files changed, 55 insertions(+), 2 deletions(-)

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
index 7a33ec703391..b04bb9a5dfa8 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -418,6 +418,7 @@ static void fdls_reset_oxid_pool(struct fnic_iport_s =
*iport)
 }
=20
 void fnic_del_fabric_timer_sync(struct fnic *fnic)
+	__must_hold(&fnic->fnic_lock)
 {
 	fnic->iport.fabric.del_timer_inprogress =3D 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -426,8 +427,8 @@ void fnic_del_fabric_timer_sync(struct fnic *fnic)
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
@@ -438,6 +439,7 @@ void fnic_del_tport_timer_sync(struct fnic *fnic,
=20
 static void
 fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -463,6 +465,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, i=
nt timeout)
 static void
 fdls_start_tport_timer(struct fnic_iport_s *iport,
 					   struct fnic_tport_s *tport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -718,6 +721,7 @@ int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	uint8_t s_id[3];
@@ -761,7 +765,9 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
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
@@ -933,6 +939,7 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *=
iport)
 }
=20
 static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pflogi;
@@ -993,6 +1000,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport=
_s *iport)
 }
=20
 static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -1085,6 +1093,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_=
s *iport)
 }
=20
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rpn_id *prpn_id;
@@ -1144,6 +1153,7 @@ static void fdls_send_rpn_id(struct fnic_iport_s *i=
port)
 }
=20
 static void fdls_send_scr(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_scr *pscr;
@@ -1199,6 +1209,7 @@ static void fdls_send_scr(struct fnic_iport_s *ipor=
t)
 }
=20
 static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_gpn_ft *pgpn_ft;
@@ -1258,6 +1269,7 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *i=
port, int fdls_state)
=20
 static void
 fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_adisc *padisc;
@@ -1323,6 +1335,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
 }
=20
 bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *=
tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_event_s *tport_del_evt;
 	struct fnic *fnic =3D iport->fnic;
@@ -1388,6 +1401,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
=20
 static void
 fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -1456,6 +1470,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
 }
=20
 static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rft_id *prft_id;
@@ -1523,6 +1538,7 @@ static void fdls_send_register_fc4_types(struct fni=
c_iport_s *iport)
 }
=20
 static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rff_id *prff_id;
@@ -1582,6 +1598,7 @@ static void fdls_send_register_fc4_features(struct =
fnic_iport_s *iport)
=20
 static void
 fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tpor=
t)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_prli *pprli;
@@ -1663,6 +1680,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, stru=
ct fnic_tport_s *tport)
  * Currently this assumes to be called with fnic lock held.
  */
 void fdls_send_fabric_logo(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_logo *plogo;
@@ -1762,6 +1780,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport, st=
ruct fnic_tport_s *tport)
 }
=20
 static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	u32 old_link_down_cnt =3D iport->fnic->link_down_cnt;
@@ -1813,6 +1832,7 @@ static void fdls_tgt_discovery_start(struct fnic_ip=
ort_s *iport)
  */
 static void fdls_target_restart_nexus(struct fnic_iport_s *iport,
 				      struct fnic_tport_s *tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *new_tport =3D NULL;
 	uint32_t fcid;
@@ -2618,6 +2638,7 @@ static void fdls_tport_timer_callback(struct timer_=
list *t)
 }
=20
 static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_flogi(iport);
@@ -2626,6 +2647,7 @@ static void fnic_fdls_start_flogi(struct fnic_iport=
_s *iport)
 }
=20
 static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_plogi(iport);
@@ -2644,6 +2666,7 @@ static void fnic_fdls_start_plogi(struct fnic_iport=
_s *iport)
 static void
 fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2734,6 +2757,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *ipo=
rt,
 static void
 fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2855,9 +2879,11 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ip=
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
@@ -3026,6 +3052,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 static void
 fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -3099,6 +3126,7 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rft_id *rft_rsp =3D (struct fc_std_rft_id *) fchdr;
@@ -3174,6 +3202,7 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rpn_id *rpn_rsp =3D (struct fc_std_rpn_id *) fchdr;
@@ -3244,6 +3273,7 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_scr_rsp(struct fnic_iport_s *iport,
 		     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_scr *scr_rsp =3D (struct fc_std_scr *) fchdr;
@@ -3316,6 +3346,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_gpn_ft_rsp_iu *gpn_ft_tgt;
 	struct fnic_tport_s *tport, *next;
@@ -3414,6 +3445,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
 static void
 fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_gpn_ft *gpn_ft_rsp =3D (struct fc_std_gpn_ft *) fchdr;
@@ -3550,6 +3582,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *flogo_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -3603,6 +3636,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *i=
port,
 static void
 fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		       struct fc_frame_header *fchdr, void *rx_frame)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fabric =3D &iport->fabric;
 	struct fc_std_flogi *flogi_rsp =3D (struct fc_std_flogi *) fchdr;
@@ -3742,6 +3776,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 			      struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *plogi_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fc_std_els_rjt_rsp *els_rjt =3D (struct fc_std_els_rjt_rsp *) fc=
hdr;
@@ -4003,6 +4038,7 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_=
iport_s *iport,
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fc_std_abts_ba_acc *ba_acc =3D (struct fc_std_abts_ba_acc *)fchd=
r;
@@ -4360,6 +4396,7 @@ fdls_process_els_req(struct fnic_iport_s *iport, st=
ruct fc_frame_header *fchdr,
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fnic_tport_s *tport;
@@ -4549,6 +4586,7 @@ fdls_process_plogi_req(struct fnic_iport_s *iport,
=20
 static void
 fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header=
 *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_logo *logo =3D (struct fc_std_logo *)fchdr;
 	uint32_t nport_id;
@@ -4626,6 +4664,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
=20
 static void
 fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fc=
hdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_rscn *rscn;
 	struct fc_els_rscn_page *rscn_port =3D NULL;
@@ -4759,6 +4798,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struc=
t fc_frame_header *fchdr)
 }
=20
 void fnic_fdls_disc_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
=20
@@ -5103,6 +5143,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_i=
port_s *iport,
=20
 void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 						  int len, int fchdr_offset)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_frame_header *fchdr;
 	uint32_t s_id =3D 0;
@@ -5224,6 +5265,7 @@ void fnic_fdls_disc_init(struct fnic_iport_s *iport=
)
 }
=20
 void fnic_fdls_link_down(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	struct fnic *fnic =3D iport->fnic;
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 231dec180675..8f44abfc01a5 100644
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
index 0668770dfb5d..b5a6a2b99c4e 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -944,6 +944,7 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic=
_wq_buf *buf)
 void
 fnic_fdls_add_tport(struct fnic *fnic, struct fnic_tport_s *tport,
 		    unsigned long flags)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct fc_rport *rport;
 	struct fc_rport_identifiers ids;
@@ -982,6 +983,7 @@ fnic_fdls_add_tport(struct fnic *fnic, struct fnic_tp=
ort_s *tport,
 void
 fnic_fdls_remove_tport(struct fnic *fnic, struct fnic_tport_s *tport,
 		       unsigned long flags)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct rport_dd_data_s *rdd_data;
 	struct fc_rport *rport;
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
