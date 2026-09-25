Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261343672A8
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361132; cv=none; b=ZvVGPAx1ZFuM1Xtksl1zBImb/gKOxRMIiwQ3P+tvJMhQAsdX29fKxjC3QcFG+NnBzM9d1z941Xwr24d4+wQeGgfPAYPkmNjp/aaPanBeFr1fo+9GNI6d99Zeim6sIkbO10lSFIotP3LRue7Tg9ZKvp3SsevJKHUvNsJbZDfkFwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361132; c=relaxed/simple;
	bh=ueRYqGW1TP3fVMMmoGFn2nJ7qcLuLRi+58DpddM75XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqdNwThjDQ+DRQ25QPvf+UteQshELo5inK38yNxr613F3+eHhjBVOEWmtQH3P23UXFKHVRIeKEGX9XClcvyv+dQCOyKnKjQYKzcj8oHNLgXkffRfaNAE4P4msNr+XhRRpM9ov5PqrCxBXisVFRdnez7C7Eqmtb3SQM46pgnkV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NTjItQkX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NTjItQkX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznk4dVPz1XM5kt;
	Fri, 25 Sep 2026 18:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361121; x=1792953122; bh=fW1ep
	PtHn7ruA2tuQe6hOx/8qJt+GjchVorZIpQkwkw=; b=NTjItQkXRIptoCKGrK8S8
	ThY++prG/mG14eNRoLY+hNkPMyCqKRCjbFgLGWukAeJFuFxOb4FaMqsYtKRDp5Pr
	14t0nPZQjIOGP6xiljMmWzwZLZbp3Oz5r4la/1UTPCB6Vw4M0Rw4fwien6ftxOUY
	p+O23+KEqzp8HaIbc4WbZlqKqWNjLbot+3O5Cls+Qw0MUy5/e6IakH4waOy3zkQx
	49TJYmDIN+qJtuIDJ7FzpXdwc91aSz4qnnqiTpcE5r2bKXTRkW5gx3ueWwaaLFyG
	W/mt8fn1YASclZNdqvfz38Xh+dRtZ3ebec/f3knprdT7tjb/qbJyCbYxa5jNqs4K
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N8BkdXNHJG3w; Fri, 25 Sep 2026 18:32:01 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznW0z06z1XM4Sx;
	Fri, 25 Sep 2026 18:31:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 36/54] scsi: libfc: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:14 -0700
Message-ID: <21a39d6277c0f296d0d5188bcdcb0ffcfda7a192.1790360262.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libfc/Makefile  |  2 ++
 drivers/scsi/libfc/fc_disc.c |  7 ++++++-
 drivers/scsi/libfc/fc_exch.c |  6 ++++++
 drivers/scsi/libfc/fc_fcp.c  | 17 ++++++++++++++++-
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/Makefile b/drivers/scsi/libfc/Makefile
index 65396f86c307..b265cf2a84a2 100644
--- a/drivers/scsi/libfc/Makefile
+++ b/drivers/scsi/libfc/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # $Id: Makefile
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_LIBFC) +=3D libfc.o
=20
 libfc-objs :=3D \
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 7792724d5b97..ce230a67a082 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -37,7 +37,7 @@
 #define FC_DISC_RETRY_LIMIT	3	/* max retries */
 #define FC_DISC_RETRY_DELAY	500UL	/* (msecs) delay */
=20
-static void fc_disc_gpn_ft_req(struct fc_disc *);
+static void fc_disc_gpn_ft_req(struct fc_disc *disc) __must_hold(&disc->=
disc_mutex);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void=
 *);
 static void fc_disc_done(struct fc_disc *, enum fc_disc_event);
 static void fc_disc_timeout(struct work_struct *);
@@ -68,6 +68,7 @@ static void fc_disc_stop_rports(struct fc_disc *disc)
  * @fp:	   The RSCN frame
  */
 static void fc_disc_recv_rscn_req(struct fc_disc *disc, struct fc_frame =
*fp)
+	__must_hold(&disc->disc_mutex)
 {
 	struct fc_lport *lport;
 	struct fc_els_rscn *rp;
@@ -200,6 +201,7 @@ static void fc_disc_recv_req(struct fc_lport *lport, =
struct fc_frame *fp)
  * @disc: The discovery object to be restarted
  */
 static void fc_disc_restart(struct fc_disc *disc)
+	__must_hold(&disc->disc_mutex)
 {
 	lockdep_assert_held(&disc->disc_mutex);
=20
@@ -250,6 +252,7 @@ static void fc_disc_start(void (*disc_callback)(struc=
t fc_lport *,
  * @event: The discovery completion status
  */
 static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
+	__must_hold(&disc->disc_mutex)
 {
 	struct fc_lport *lport =3D fc_disc_lport(disc);
 	struct fc_rport_priv *rdata;
@@ -294,6 +297,7 @@ static void fc_disc_done(struct fc_disc *disc, enum f=
c_disc_event event)
  * @fp:	  The error code encoded as a frame pointer
  */
 static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
+	__must_hold(&disc->disc_mutex)
 {
 	struct fc_lport *lport =3D fc_disc_lport(disc);
 	unsigned long delay =3D 0;
@@ -374,6 +378,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
  * Goes through the list of IDs and names resulting from a request.
  */
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t =
len)
+	__must_hold(&disc->disc_mutex)
 {
 	struct fc_lport *lport;
 	struct fc_gpn_ft_resp *np;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9183a0e9568a..ba2530386f97 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -811,6 +811,7 @@ static void fc_exch_timeout(struct work_struct *work)
  */
 static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 					struct fc_exch_mgr *mp)
+	__context_unsafe(/*conditionally acquires &_res->ex_lock*/)
 {
 	struct fc_exch *ep;
 	unsigned int cpu;
@@ -904,6 +905,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lpo=
rt *lport,
  */
 static struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
 				     struct fc_frame *fp)
+	__context_unsafe(/*conditionally acquires &_res->ex_lock*/)
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
index 60a675aa5a99..dbd5673e2885 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -77,7 +77,8 @@ struct fc_fcp_internal {
 static void fc_fcp_recv_data(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_recv(struct fc_seq *, struct fc_frame *, void *);
 static void fc_fcp_resp(struct fc_fcp_pkt *, struct fc_frame *);
-static void fc_fcp_complete_locked(struct fc_fcp_pkt *);
+static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock);
 static void fc_tm_done(struct fc_seq *, struct fc_frame *, void *);
 static void fc_fcp_error(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_recovery(struct fc_fcp_pkt *, u8 code);
@@ -207,6 +208,7 @@ static void fc_fcp_pkt_destroy(struct fc_seq *seq, vo=
id *fsp)
  * needed.
  */
 static inline int fc_fcp_lock_pkt(struct fc_fcp_pkt *fsp)
+	__cond_acquires(0, &fsp->scsi_pkt_lock)
 {
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	if (fsp->state & FC_SRB_COMPL) {
@@ -224,6 +226,7 @@ static inline int fc_fcp_lock_pkt(struct fc_fcp_pkt *=
fsp)
  * @fsp: The FCP packet to be unlocked and decremented
  */
 static inline void fc_fcp_unlock_pkt(struct fc_fcp_pkt *fsp)
+	__releases(&fsp->scsi_pkt_lock)
 {
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 	fc_fcp_pkt_release(fsp);
@@ -243,6 +246,7 @@ static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, =
unsigned long delay)
 }
=20
 static void fc_fcp_abort_done(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	fsp->state |=3D FC_SRB_ABORTED;
 	fsp->state &=3D ~FC_SRB_ABORT_PENDING;
@@ -259,6 +263,7 @@ static void fc_fcp_abort_done(struct fc_fcp_pkt *fsp)
  * @fsp: The FCP packet to abort exchanges on
  */
 static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	int rc;
=20
@@ -296,6 +301,7 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
  * The SCSI-ml will retry the command.
  */
 static void fc_fcp_retry_cmd(struct fc_fcp_pkt *fsp, int status_code)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	if (fsp->seq_ptr) {
 		fc_exch_done(fsp->seq_ptr);
@@ -470,6 +476,7 @@ static inline unsigned int get_fsp_rec_tov(struct fc_=
fcp_pkt *fsp)
  * @fp:	 The data frame
  */
 static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp=
)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct scsi_cmnd *sc =3D fsp->cmd;
 	struct fc_lport *lport =3D fsp->lp;
@@ -588,6 +595,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, =
struct fc_frame *fp)
  */
 static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 			    size_t offset, size_t seq_blen)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_exch *ep;
 	struct scsi_cmnd *sc;
@@ -734,6 +742,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, s=
truct fc_seq *seq,
  * @fp:	 The response frame
  */
 static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp=
)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	int ba_done =3D 1;
 	struct fc_ba_rjt *brp;
@@ -846,6 +855,7 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc=
_frame *fp, void *arg)
  * @fp:	 The response frame
  */
 static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_frame_header *fh;
 	struct fcp_resp *fc_rp;
@@ -1242,6 +1252,7 @@ static void fc_fcp_error(struct fc_fcp_pkt *fsp, st=
ruct fc_frame *fp)
  * Called to send an abort and then wait for abort completion
  */
 static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	int rc =3D FAILED;
 	unsigned long ticks_left;
@@ -1453,6 +1464,7 @@ static void fc_fcp_timeout(struct timer_list *t)
  * @fsp: The FCP packet to send the REC request on
  */
 static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_lport *lport;
 	struct fc_frame *fp;
@@ -1690,6 +1702,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp=
, struct fc_frame *fp)
  * @code: The FCP status code to set
  */
 static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	FC_FCP_DBG(fsp, "start recovery code %x\n", code);
 	fsp->status_code =3D code;
@@ -1712,6 +1725,7 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp,=
 u8 code)
  * when expecting status but the request has timed out.
  */
 static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 o=
ffset)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_lport *lport =3D fsp->lp;
 	struct fc_rport *rport;
@@ -1950,6 +1964,7 @@ EXPORT_SYMBOL(fc_queuecommand);
  * The fcp packet lock must be held when calling.
  */
 static void fc_io_compl(struct fc_fcp_pkt *fsp)
+	__must_hold(&fsp->scsi_pkt_lock)
 {
 	struct fc_fcp_internal *si;
 	struct scsi_cmnd *sc_cmd;
