Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193B6336895
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350278; cv=none; b=oQtxzGI/RtrmgU8Dp5O+5zI+L709/4mA/JlDbeQp0hyt3mveK0QOTeGTxe0xyYQa5ZPAstASjIlwwNxybKLOGcFT5X7gQbJ2K2jqk2V1axChemK1P7V0lOANL87JrZO6OMBfX4hYi6kKmTJOPTs2Go+tRoo/+Y5O8e4twcly6Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350278; c=relaxed/simple;
	bh=pTf5sl9idN4m+8GYmDfwFk709pYBv9ihQO6OLrMda+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tInYpemYogvq+roHuoMQdolKdvftso/dLewQn1ROq6o4JDaC52mk84vLZBZ1Megh0vPw5UmpQWO6LY46/qbHFmtk/WnqLsHD2nCdg9Ggr51pSCxNPrsOIiPXhE7vTeHxQYVbHF4Qj5Og8ThNT/o4mFRaxC0cQkj1qy4Y1ApJaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PJonqPcC; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PJonqPcC"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nw6QlVzlfl5V;
	Thu, 12 Mar 2026 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350263; x=1775942264; bh=FwGND
	/JQHNORezOGsynSxmq2ejX3zTfDCOGQBUXJS0w=; b=PJonqPcCjSq7Y9ZaYjqqV
	yqMiu995JLhOTT3X7LIUS0AnVuFIgslZNADtN6TdFwJI7mmByZnlFSI4e17eNUTT
	gapOkD0seNonmL/Vjj3flNXy3Br8hHkZabI9Vum6aFQ1MNO/iQFygj5X+lUhGvRr
	BBKxJmCHk3GJkqPfgwbaM4zoTSRPLKPSy9ScOJ88KVjg3ooFYxH8PQf7VUqf1BTG
	ZoI9VFE8ZaFluK6kCZ2nhLd48Gm1BY7j97OLG4wKnjQv8rMwLlSEEJn8CAfv8WX3
	6u8ZVJz1PZjzYZSXsTDT+m/2zdIxoWXKcX+ZdUS5HtfxQ5gee1jyyr38FyDYMf+s
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wbdIOgvIAIq1; Thu, 12 Mar 2026 21:17:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nf013pzlfl8L;
	Thu, 12 Mar 2026 21:17:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 16/36] scsi: fnic: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:27 -0700
Message-ID: <20260312211636.3245119-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fdls_disc.c | 52 +++++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fip.c       |  2 ++
 drivers/scsi/fnic/fnic_fcs.c  |  6 ++++
 drivers/scsi/fnic/fnic_scsi.c |  4 +++
 4 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
index 554dea767885..0ac12edb7df1 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -391,6 +391,7 @@ static void fdls_reset_oxid_pool(struct fnic_iport_s =
*iport)
 }
=20
 void fnic_del_fabric_timer_sync(struct fnic *fnic)
+	__must_hold(&fnic->fnic_lock)
 {
 	fnic->iport.fabric.del_timer_inprogress =3D 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -399,8 +400,8 @@ void fnic_del_fabric_timer_sync(struct fnic *fnic)
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
@@ -411,6 +412,7 @@ void fnic_del_tport_timer_sync(struct fnic *fnic,
=20
 static void
 fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -436,6 +438,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, i=
nt timeout)
 static void
 fdls_start_tport_timer(struct fnic_iport_s *iport,
 					   struct fnic_tport_s *tport, int timeout)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	u64 fabric_tov;
 	struct fnic *fnic =3D iport->fnic;
@@ -631,6 +634,7 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	uint8_t s_id[3];
@@ -674,7 +678,9 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
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
@@ -846,6 +852,7 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *=
iport)
 }
=20
 static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pflogi;
@@ -906,6 +913,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport_=
s *iport)
 }
=20
 static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -998,6 +1006,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_s=
 *iport)
 }
=20
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rpn_id *prpn_id;
@@ -1057,6 +1066,7 @@ static void fdls_send_rpn_id(struct fnic_iport_s *i=
port)
 }
=20
 static void fdls_send_scr(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_scr *pscr;
@@ -1112,6 +1122,7 @@ static void fdls_send_scr(struct fnic_iport_s *ipor=
t)
 }
=20
 static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_gpn_ft *pgpn_ft;
@@ -1171,6 +1182,7 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *i=
port, int fdls_state)
=20
 static void
 fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_adisc *padisc;
@@ -1236,6 +1248,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
 }
=20
 bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *=
tport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_event_s *tport_del_evt;
 	struct fnic *fnic =3D iport->fnic;
@@ -1293,6 +1306,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
=20
 static void
 fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_flogi *pplogi;
@@ -1361,6 +1375,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
 }
=20
 static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rft_id *prft_id;
@@ -1421,6 +1436,7 @@ static void fdls_send_register_fc4_types(struct fni=
c_iport_s *iport)
 }
=20
 static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_rff_id *prff_id;
@@ -1480,6 +1496,7 @@ static void fdls_send_register_fc4_features(struct =
fnic_iport_s *iport)
=20
 static void
 fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tpor=
t)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_els_prli *pprli;
@@ -1553,6 +1570,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, stru=
ct fnic_tport_s *tport)
  * Currently this assumes to be called with fnic lock held.
  */
 void fdls_send_fabric_logo(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *frame;
 	struct fc_std_logo *plogo;
@@ -1652,6 +1670,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport, st=
ruct fnic_tport_s *tport)
 }
=20
 static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	u32 old_link_down_cnt =3D iport->fnic->link_down_cnt;
@@ -1702,6 +1721,7 @@ static void fdls_tgt_discovery_start(struct fnic_ip=
ort_s *iport)
  * pointing to it will be freed later
  */
 static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
+	__must_hold(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_lock)
 {
 	struct fnic_iport_s *iport =3D tport->iport;
 	struct fnic_tport_s *new_tport =3D NULL;
@@ -2482,6 +2502,7 @@ static void fdls_tport_timer_callback(struct timer_=
list *t)
 }
=20
 static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_flogi(iport);
@@ -2490,6 +2511,7 @@ static void fnic_fdls_start_flogi(struct fnic_iport=
_s *iport)
 }
=20
 static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	iport->fabric.retry_counter =3D 0;
 	fdls_send_fabric_plogi(iport);
@@ -2508,6 +2530,7 @@ static void fnic_fdls_start_plogi(struct fnic_iport=
_s *iport)
 static void
 fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2598,6 +2621,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *ipo=
rt,
 static void
 fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 			   struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tgt_fcid;
 	struct fnic_tport_s *tport;
@@ -2632,6 +2656,8 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ipo=
rt,
 	if (tport->state !=3D FDLS_TGT_STATE_PLOGI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "PLOGI rsp recvd in wrong state. Drop the frame and restart nexu=
s");
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fdls_target_restart_nexus(tport);
 		return;
 	}
@@ -2719,9 +2745,11 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ip=
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
@@ -2758,6 +2786,8 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 	if (tport->state !=3D FDLS_TGT_STATE_PRLI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "PRLI rsp recvd in wrong state. Drop frame. Restarting nexus");
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fdls_target_restart_nexus(tport);
 		return;
 	}
@@ -2872,6 +2902,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 static void
 fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -2945,6 +2976,7 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rft_id *rft_rsp =3D (struct fc_std_rft_id *) fchdr;
@@ -3020,6 +3052,7 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_rpn_id *rpn_rsp =3D (struct fc_std_rpn_id *) fchdr;
@@ -3090,6 +3123,7 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_scr_rsp(struct fnic_iport_s *iport,
 		     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_scr *scr_rsp =3D (struct fc_std_scr *) fchdr;
@@ -3162,6 +3196,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_gpn_ft_rsp_iu *gpn_ft_tgt;
 	struct fnic_tport_s *tport, *next;
@@ -3260,6 +3295,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
 static void
 fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
 	struct fc_std_gpn_ft *gpn_ft_rsp =3D (struct fc_std_gpn_ft *) fchdr;
@@ -3396,6 +3432,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *flogo_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
@@ -3449,6 +3486,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *i=
port,
 static void
 fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		       struct fc_frame_header *fchdr, void *rx_frame)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_fdls_fabric_s *fabric =3D &iport->fabric;
 	struct fc_std_flogi *flogi_rsp =3D (struct fc_std_flogi *) fchdr;
@@ -3586,6 +3624,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 static void
 fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 			      struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_flogi *plogi_rsp =3D (struct fc_std_flogi *) fchdr;
 	struct fc_std_els_rjt_rsp *els_rjt =3D (struct fc_std_els_rjt_rsp *) fc=
hdr;
@@ -3847,6 +3886,7 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_=
iport_s *iport,
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fc_std_abts_ba_acc *ba_acc =3D (struct fc_std_abts_ba_acc *)fchd=
r;
@@ -4204,6 +4244,7 @@ fdls_process_els_req(struct fnic_iport_s *iport, st=
ruct fc_frame_header *fchdr,
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t s_id;
 	struct fnic_tport_s *tport;
@@ -4393,6 +4434,7 @@ fdls_process_plogi_req(struct fnic_iport_s *iport,
=20
 static void
 fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header=
 *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_logo *logo =3D (struct fc_std_logo *)fchdr;
 	uint32_t nport_id;
@@ -4433,6 +4475,8 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
 		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
+		/* Tell the compiler that tport->iport =3D=3D iport. */
+		__assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_l=
ock);
 		fnic_del_tport_timer_sync(fnic, tport);
 		tport->timer_pending =3D 0;
 	}
@@ -4470,6 +4514,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
=20
 static void
 fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fc=
hdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_std_rscn *rscn;
 	struct fc_els_rscn_page *rscn_port =3D NULL;
@@ -4603,6 +4648,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struc=
t fc_frame_header *fchdr)
 }
=20
 void fnic_fdls_disc_start(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
=20
@@ -4943,6 +4989,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_i=
port_s *iport,
=20
 void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 						  int len, int fchdr_offset)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fc_frame_header *fchdr;
 	uint32_t s_id =3D 0;
@@ -5061,6 +5108,7 @@ void fnic_fdls_disc_init(struct fnic_iport_s *iport=
)
 }
=20
 void fnic_fdls_link_down(struct fnic_iport_s *iport)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic_tport_s *tport, *next;
 	struct fnic *fnic =3D iport->fnic;
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 132f00512ee1..da8a8e9ffea4 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -610,6 +610,7 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
  * and clean up and restart the vlan discovery.
  */
 void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header *fiph)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct fnic_iport_s *iport =3D &fnic->iport;
 	struct fip_cvl *cvl_msg =3D (struct fip_cvl *)fiph;
@@ -687,6 +688,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct =
fip_header *fiph)
  * @frame: Received ethernet frame
  */
 int fdls_fip_recv_frame(struct fnic *fnic, void *frame)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct ethhdr *eth =3D (struct ethhdr *)frame;
 	struct fip_header *fiph;
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 063eb864a5cd..99f9fe13dfe4 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -925,6 +925,7 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic=
_wq_buf *buf)
 void
 fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt,
 					unsigned long flags)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct fc_rport *rport;
@@ -964,6 +965,7 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struc=
t fnic_tport_s *tport,
 void
 fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 					   struct fnic_tport_s *tport, unsigned long flags)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	struct rport_dd_data_s *rdd_data;
@@ -1013,6 +1015,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	/* Tell the compiler that fnic->iport.fnic =3D=3D fnic. */
+	__assume_ctx_lock(&fnic->iport.fnic->fnic_lock);
 	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "removing fcp rport fcid: 0x%x", tport->fcid);
@@ -1037,6 +1041,8 @@ void fnic_tport_event_handler(struct work_struct *w=
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
index 6ee3c559e129..a757b20756ad 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2617,6 +2617,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		 * allocated by mid layer.
 		 */
 		mutex_lock(&fnic->sgreset_mutex);
+		/* Fake __release() to keep the lock context analyzer happy. */
+		__release(&fnic->sgreset_mutex);
 		mqtag =3D fnic->fnic_max_tag_id;
 		new_sc =3D 1;
 	}  else {
@@ -2803,6 +2805,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
=20
 	if (new_sc) {
 		fnic->sgreset_sc =3D NULL;
+		/* Fake __acquire() to keep the lock context analyzer happy. */
+		__acquire(&fnic->sgreset_mutex);
 		mutex_unlock(&fnic->sgreset_mutex);
 	}
=20
