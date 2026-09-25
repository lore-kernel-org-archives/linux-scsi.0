Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD82D63E5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361083; cv=none; b=nxA78zw7fnqNXz7wffi3RjG3mLIDjojgQOXg9pgiJWWX19X22gV/9SiFMVH5DTwGVD6CFoYOppl2/VuGOjFJQgOsLYEmuWsCO7FFRuVpqWQMrLbCYpp+zevsxufNp185oOyGLE/Mfx7V1jY19BCoCxMFIF6475q1Bgdypytm2K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361083; c=relaxed/simple;
	bh=2om6jKff0Y+lXsdkFN+e6BYIucyJVYELMZwMI8v5pL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIqH5OBgIWDreCmPsA6ApUtCPjoNyBPZ/uTWeDG0tF+Eiya42oSp6a/5jYs31In7rtl+uH48sA7aXDqDXGVW2j810EsRbMmU0poL84DRWO4rfRvldyCBPYTBfcrIOCDY9FdMFXAz3zD7bW9t0+B9oVztm0+VZtuu7f52w51Pnqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qSQnoVKM; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qSQnoVKM"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmp0xPTz1XM4Sx;
	Fri, 25 Sep 2026 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361072; x=1792953073; bh=eugcc
	x3oNusKK6Oe/fIiadfAu0t7Q9+pI5TANtO59Ng=; b=qSQnoVKMotvAQwYYNbvPp
	5J1m8ju+4s3H5laRWHca+JxaQzn0sl8EOm4yNXkM8PdrPMaMrVqN9+6ov2ZnzbwJ
	ED15/TRyTSaiBSqtqs8S+Jl9zWBfSfBTVH3nQyPDgSPXbA7uCS0cZAtA+rKTG/jj
	60qyIaDPzGNPmfSyS/V+2ch3O9bD3Vw5t6OqeH70fPUtYR4RsjEDQOLo0ljVa9Wa
	NGxzITP4py9WHqlbu3qlDG2wrLKldtyXim8WE9Yn/buH55fyqOtoOdjJmFh6iZEK
	xo3f+jbEggr/Tq8z5iGPmucLG/hwLGVLrRQA88hW1XAlZQrLJMtV7x3LV1SoeWh6
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p7NHAGofK8vu; Fri, 25 Sep 2026 18:31:12 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmZ58LHz1XM5kY;
	Fri, 25 Sep 2026 18:31:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 24/54] scsi: fcoe: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:02 -0700
Message-ID: <61dba0e839bc3522ff74224278159dcfe4e6488c.1790360262.git.bvanassche@acm.org>
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

Pass the FCoE controller pointer to all functions that are called with on=
e or
more locks held. Document locking requirements by adding __must_hold()
annotations. Enable lock context analysis in the Makefile.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/Makefile    |  3 +++
 drivers/scsi/fcoe/fcoe_ctlr.c | 50 +++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 1183e80a09e7..5e7121231801 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_FCOE) +=3D fcoe.o
 obj-$(CONFIG_LIBFCOE) +=3D libfcoe.o
=20
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.=
c
index 496ddd45f74d..bf92293a0ef0 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -42,7 +42,8 @@ static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
 static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *);
=20
-static void fcoe_ctlr_vn_start(struct fcoe_ctlr *);
+static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex);
 static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
 static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *);
 static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *, u32, u8 *);
@@ -154,13 +155,14 @@ EXPORT_SYMBOL(fcoe_ctlr_init);
=20
 /**
  * fcoe_sysfs_fcf_add() - Add a fcoe_fcf{,_device} to a fcoe_ctlr{,_devi=
ce}
+ * @fip: The FCoE controller
  * @new: The newly discovered FCF
  *
  * Called with fip->ctlr_mutex held
  */
-static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
+static int fcoe_sysfs_fcf_add(struct fcoe_ctlr *fip, struct fcoe_fcf *ne=
w)
+	__must_hold(&fip->ctlr_mutex)
 {
-	struct fcoe_ctlr *fip =3D new->fip;
 	struct fcoe_ctlr_device *ctlr_dev;
 	struct fcoe_fcf_device *temp, *fcf_dev;
 	int rc =3D -ENOMEM;
@@ -227,13 +229,14 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
=20
 /**
  * fcoe_sysfs_fcf_del() - Remove a fcoe_fcf{,_device} to a fcoe_ctlr{,_d=
evice}
+ * @fip: The FCoE controller
  * @new: The FCF to be removed
  *
  * Called with fip->ctlr_mutex held
  */
-static void fcoe_sysfs_fcf_del(struct fcoe_fcf *new)
+static void fcoe_sysfs_fcf_del(struct fcoe_ctlr *fip, struct fcoe_fcf *n=
ew)
+	__must_hold(&fip->ctlr_mutex)
 {
-	struct fcoe_ctlr *fip =3D new->fip;
 	struct fcoe_ctlr_device *cdev;
 	struct fcoe_fcf_device *fcf_dev;
=20
@@ -268,13 +271,14 @@ static void fcoe_sysfs_fcf_del(struct fcoe_fcf *new=
)
  * Called with &fcoe_ctlr lock held.
  */
 static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
=20
 	fip->sel_fcf =3D NULL;
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
-		fcoe_sysfs_fcf_del(fcf);
+		fcoe_sysfs_fcf_del(fip, fcf);
 	}
 	WARN_ON(fip->fcf_count);
=20
@@ -316,6 +320,8 @@ EXPORT_SYMBOL(fcoe_ctlr_destroy);
  * Called with neither ctlr_mutex nor ctlr_lock held.
  */
 static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
+	__must_not_hold(&fip->ctlr_mutex)
+	__must_not_hold(&fip->ctlr_lock)
 {
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
@@ -476,6 +482,7 @@ EXPORT_SYMBOL(fcoe_ctlr_link_up);
  * @fip:       The FCoE controller to reset
  */
 static void fcoe_ctlr_reset(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	fcoe_ctlr_reset_fcfs(fip);
 	timer_delete(&fip->timer);
@@ -817,6 +824,7 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  * Returns the time in jiffies for the next call.
  */
 static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
@@ -866,7 +874,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_c=
tlr *fip)
=20
 	list_for_each_entry_safe(fcf, next, &del_list, list) {
 		/* Removes fcf from current list */
-		fcoe_sysfs_fcf_del(fcf);
+		fcoe_sysfs_fcf_del(fip, fcf);
 	}
=20
 	if (sel_time && !fip->sel_fcf && !fip->sel_time) {
@@ -1049,7 +1057,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fi=
p, struct sk_buff *skb)
=20
 		memcpy(fcf, &new, sizeof(new));
 		fcf->fip =3D fip;
-		rc =3D fcoe_sysfs_fcf_add(fcf);
+		rc =3D fcoe_sysfs_fcf_add(fip, fcf);
 		if (rc) {
 			printk(KERN_ERR "Failed to allocate sysfs instance "
 			       "for FCF, fab %16.16llx mac %pM\n",
@@ -1612,6 +1620,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr =
*fip, struct sk_buff *skb)
  * Called with lock held.
  */
 static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best =3D fip->sel_fcf;
@@ -1664,6 +1673,8 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fco=
e_ctlr *fip)
  * Caller must verify that fip->sel_fcf is not NULL.
  */
 static int fcoe_ctlr_flogi_send_locked(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
+	__must_hold(&fip->ctlr_lock)
 {
 	struct sk_buff *skb;
 	struct sk_buff *skb_orig;
@@ -1733,6 +1744,7 @@ static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *=
fip)
  * Called with ctlr_mutex held.  The caller must not hold ctlr_lock.
  */
 static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fcoe_fcf *fcf;
=20
@@ -2012,6 +2024,7 @@ static inline struct fcoe_rport *fcoe_ctlr_rport(st=
ruct fc_rport_priv *rdata)
 static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
 			      enum fip_vn2vn_subcode sub,
 			      const u8 *dest, size_t min_len)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct sk_buff *skb;
 	struct fip_vn2vn_probe_frame {
@@ -2152,11 +2165,14 @@ static struct fc_rport_operations fcoe_ctlr_vn_rp=
ort_ops =3D {
=20
 /**
  * fcoe_ctlr_disc_stop_locked() - stop discovery in VN2VN mode
+ * @fip: The FCoE controller
  * @lport: The local port
  *
  * Called with ctlr_mutex held.
  */
-static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
+static void fcoe_ctlr_disc_stop_locked(struct fcoe_ctlr *fip,
+				       struct fc_lport *lport)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fc_rport_priv *rdata;
=20
@@ -2183,7 +2199,7 @@ static void fcoe_ctlr_disc_stop(struct fc_lport *lp=
ort)
 	struct fcoe_ctlr *fip =3D lport->disc.priv;
=20
 	mutex_lock(&fip->ctlr_mutex);
-	fcoe_ctlr_disc_stop_locked(lport);
+	fcoe_ctlr_disc_stop_locked(fip, lport);
 	mutex_unlock(&fip->ctlr_mutex);
 }
=20
@@ -2208,11 +2224,12 @@ static void fcoe_ctlr_disc_stop_final(struct fc_l=
port *lport)
  * Called with fcoe_ctlr lock held.
  */
 static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	unsigned long wait;
 	u32 port_id;
=20
-	fcoe_ctlr_disc_stop_locked(fip->lp);
+	fcoe_ctlr_disc_stop_locked(fip, fip->lp);
=20
 	/*
 	 * Get proposed port ID.
@@ -2246,6 +2263,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *=
fip)
  * Called with fcoe_ctlr lock held.
  */
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	fip->probe_tries =3D 0;
 	prandom_seed_state(&fip->rnd_state, fip->lp->wwpn);
@@ -2387,6 +2405,7 @@ static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip=
,
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_send_claim(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_NOTIFY, fcoe_all_vn2vn, 0);
 	fip->sol_time =3D jiffies;
@@ -2401,6 +2420,7 @@ static void fcoe_ctlr_vn_send_claim(struct fcoe_ctl=
r *fip)
  */
 static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
 				   struct fcoe_rport *frport)
+	__must_hold(&fip->ctlr_mutex)
 {
 	if (frport->rdata.ids.port_id !=3D fip->port_id)
 		return;
@@ -2452,6 +2472,7 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr=
 *fip,
  */
 static void fcoe_ctlr_vn_probe_reply(struct fcoe_ctlr *fip,
 				     struct fcoe_rport *frport)
+	__must_hold(&fip->ctlr_mutex)
 {
 	if (frport->rdata.ids.port_id !=3D fip->port_id)
 		return;
@@ -2481,6 +2502,7 @@ static void fcoe_ctlr_vn_probe_reply(struct fcoe_ct=
lr *fip,
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fcoe_rport *n=
ew)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fc_lport *lport =3D fip->lp;
 	struct fc_rport_priv *rdata;
@@ -2564,6 +2586,7 @@ static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fi=
p, u32 port_id, u8 *mac)
  */
 static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 				      struct fcoe_rport *new)
+	__must_hold(&fip->ctlr_mutex)
 {
 	if (new->flags & FIP_FL_REC_OR_P2P) {
 		LIBFCOE_FIP_DBG(fip, "send probe req for P2P/REC\n");
@@ -2619,6 +2642,7 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_c=
tlr *fip,
  */
 static void fcoe_ctlr_vn_claim_resp(struct fcoe_ctlr *fip,
 				    struct fcoe_rport *new)
+	__must_hold(&fip->ctlr_mutex)
 {
 	LIBFCOE_FIP_DBG(fip, "claim resp from from rport %x - state %s\n",
 			new->rdata.ids.port_id, fcoe_ctlr_state(fip->state));
@@ -2635,6 +2659,7 @@ static void fcoe_ctlr_vn_claim_resp(struct fcoe_ctl=
r *fip,
  */
 static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 				struct fcoe_rport *new)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fc_lport *lport =3D fip->lp;
 	struct fc_rport_priv *rdata;
@@ -2688,6 +2713,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *f=
ip,
  * Returns the soonest time for next age-out or a time far in the future=
.
  */
 static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct fc_lport *lport =3D fip->lp;
 	struct fc_rport_priv *rdata;
@@ -2890,6 +2916,7 @@ static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *f=
ip,
 static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
 			      enum fip_vlan_subcode sub,
 			      const u8 *dest)
+	__must_hold(&fip->ctlr_mutex)
 {
 	struct sk_buff *skb;
 	struct fip_vlan_notify_frame {
@@ -2951,6 +2978,7 @@ static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *f=
ip,
  */
 static void fcoe_ctlr_vlan_disc_reply(struct fcoe_ctlr *fip,
 				      struct fcoe_rport *frport)
+	__must_hold(&fip->ctlr_mutex)
 {
 	enum fip_vlan_subcode sub =3D FIP_SC_VL_NOTE;
=20
