Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB8338B132
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350279; cv=none; b=dHCKEDt1vSaGFwFV/Sgfk51vjT4Oie7fRerZmG9FSZvMIWlCYJLWUdms1PjHWsvinaRHsAJGJrsK3Y8SL9Kek9TPrLutegZRMZC6VlotrHFNBBqlX3/duFQXSkWULIy5JP5cyX8Jpl5698s2d1IbXexBJF6x86wZau0Lkvhsz2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350279; c=relaxed/simple;
	bh=mYawg9BzYgKkBcsN/B4WAu1p4qMqAW7Apit63o8z++Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj+Ysd/xqLPg0dMjbOzdT9aW8Cg0y5SSOPbRLnyJ+auMohNLqLPYdbax+Nngh3dIhI5zQpcOt3Rj10qABd356UcYH1+J6s74wTcYLR2+/WM7CreoqmaKEjc/c38QO9xZ7RV9GaM88sUlgAwFJWIc9PgCwxW8v3n4YrF139g0g+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=r/XtKZ6w; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="r/XtKZ6w"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nx6hX1zlfl5h;
	Thu, 12 Mar 2026 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350273; x=1775942274; bh=ImHHA
	eoHNfJSt6Ep0mp8FXi/xMCm5Ti3sF9875si6AA=; b=r/XtKZ6wJrnT2/0Y2RVHx
	1D4P/ZZR/jMhBm1KtSS/ykpoGXNR1vydD/un/8OXrybz0pJnd3mDMGa/o0tii0AQ
	cmHZL0MeiDZfDMlddwsO1oqJqE0xPmc2ulQCEMU83zNHAcToYWZG8dUY5z/YTBfr
	7TtrpWySVp5xCzO5Sl/g8iaSf0MkM1yjPuPXzt64K711tA2vBiNhYp1fKfzM7/QX
	gNs/gOvPDHGNvzpqagSRfUC16cx+qtqWGfnGMXfxPHc+YBS4AZ1t6FDQlFrx1mRA
	98cWcKzq1VKzrgm/sJ62/MVwY4897/9joramIWrg/GLKiP2VR1OdUXJ8fEFNISFt
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id spSD055catGw; Thu, 12 Mar 2026 21:17:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0np0SWgzlfl7l;
	Thu, 12 Mar 2026 21:17:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 21/36] scsi: libfc: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:32 -0700
Message-ID: <20260312211636.3245119-22-bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libfc/fc_disc.c | 6 +++++-
 drivers/scsi/libfc/fc_exch.c | 6 ++++++
 drivers/scsi/libfc/fc_fcp.c  | 4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 7792724d5b97..e2fd076ee15b 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -37,7 +37,7 @@
 #define FC_DISC_RETRY_LIMIT	3	/* max retries */
 #define FC_DISC_RETRY_DELAY	500UL	/* (msecs) delay */
=20
-static void fc_disc_gpn_ft_req(struct fc_disc *);
+static void fc_disc_gpn_ft_req(struct fc_disc *disc) __must_hold(disc->d=
isc_mutex);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void=
 *);
 static void fc_disc_done(struct fc_disc *, enum fc_disc_event);
 static void fc_disc_timeout(struct work_struct *);
@@ -200,6 +200,7 @@ static void fc_disc_recv_req(struct fc_lport *lport, =
struct fc_frame *fp)
  * @disc: The discovery object to be restarted
  */
 static void fc_disc_restart(struct fc_disc *disc)
+	__must_hold(disc->disc_mutex)
 {
 	lockdep_assert_held(&disc->disc_mutex);
=20
@@ -250,6 +251,7 @@ static void fc_disc_start(void (*disc_callback)(struc=
t fc_lport *,
  * @event: The discovery completion status
  */
 static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
+	__must_hold(disc->disc_mutex)
 {
 	struct fc_lport *lport =3D fc_disc_lport(disc);
 	struct fc_rport_priv *rdata;
@@ -294,6 +296,7 @@ static void fc_disc_done(struct fc_disc *disc, enum f=
c_disc_event event)
  * @fp:	  The error code encoded as a frame pointer
  */
 static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
+	__must_hold(disc->disc_mutex)
 {
 	struct fc_lport *lport =3D fc_disc_lport(disc);
 	unsigned long delay =3D 0;
@@ -374,6 +377,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
  * Goes through the list of IDs and names resulting from a request.
  */
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t =
len)
+	__must_hold(disc->disc_mutex)
 {
 	struct fc_lport *lport;
 	struct fc_gpn_ft_resp *np;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9183a0e9568a..56196f51422e 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -811,6 +811,7 @@ static void fc_exch_timeout(struct work_struct *work)
  */
 static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 					struct fc_exch_mgr *mp)
+	__no_context_analysis /* conditionally acquires &_res->ex_lock */
 {
 	struct fc_exch *ep;
 	unsigned int cpu;
@@ -904,6 +905,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lpo=
rt *lport,
  */
 static struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
 				     struct fc_frame *fp)
+	__no_context_analysis /* conditionally acquires &_res->ex_lock */
 {
 	struct fc_exch_mgr_anchor *ema;
 	struct fc_exch *ep;
@@ -996,6 +998,8 @@ static struct fc_exch *fc_exch_resp(struct fc_lport *=
lport,
=20
 	ep =3D fc_exch_alloc(lport, fp);
 	if (ep) {
+		/* Acquired by fc_exch_alloc(). */
+		__acquire(&ep->ex_lock);
 		ep->class =3D fc_frame_class(fp);
=20
 		/*
@@ -2191,6 +2195,8 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lp=
ort,
 		fc_frame_free(fp);
 		return NULL;
 	}
+	/* Acquired by fc_exch_alloc(). */
+	__acquire(&ep->ex_lock);
 	ep->esb_stat |=3D ESB_ST_SEQ_INIT;
 	fh =3D fc_frame_header_get(fp);
 	fc_exch_set_addr(ep, ntoh24(fh->fh_s_id), ntoh24(fh->fh_d_id));
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a5139e43ca4c..9ba31a8a5250 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -207,6 +207,7 @@ static void fc_fcp_pkt_destroy(struct fc_seq *seq, vo=
id *fsp)
  * needed.
  */
 static inline int fc_fcp_lock_pkt(struct fc_fcp_pkt *fsp)
+	__cond_acquires(0, &fsp->scsi_pkt_lock)
 {
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	if (fsp->state & FC_SRB_COMPL) {
@@ -224,6 +225,7 @@ static inline int fc_fcp_lock_pkt(struct fc_fcp_pkt *=
fsp)
  * @fsp: The FCP packet to be unlocked and decremented
  */
 static inline void fc_fcp_unlock_pkt(struct fc_fcp_pkt *fsp)
+	__releases(&fsp->scsi_pkt_lock)
 {
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 	fc_fcp_pkt_release(fsp);
@@ -1242,6 +1244,7 @@ static void fc_fcp_error(struct fc_fcp_pkt *fsp, st=
ruct fc_frame *fp)
  * Called to send an abort and then wait for abort completion
  */
 static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	int rc =3D FAILED;
 	unsigned long ticks_left;
@@ -1950,6 +1953,7 @@ EXPORT_SYMBOL(fc_queuecommand);
  * The fcp packet lock must be held when calling.
  */
 static void fc_io_compl(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_fcp_internal *si;
 	struct scsi_cmnd *sc_cmd;
