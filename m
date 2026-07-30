Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A647C3B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451715; cv=none; b=Kaj6JX/rSn2ImZ1RqOauM0oecbvRvLRTHUzte6+0NSH88c2dyCAbriZgq0DfoFtIanqppfWkrLZRdPOC+OYf2/dVZoh02AVrh03UdIAVGym6Di4e11mlB1Wd6csFrY6NVwYp7w0S815RWXmbj/hFQiF3OWcCz0EeOntw7epYdk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451715; c=relaxed/simple;
	bh=wLrYca+IP3dnpHTqjbsVpO8B4KJgrNpOn04Ei+Aq0GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwPQxYbWrHWNys4Mu84ImE3XCbe1YVzOcNdvdSyCUwSIcnf2Lsr1R6kttk/LVNkb/o5PoSDmwPFsiC+j08vLnMpmcWe1vL8IhSa9dr3EawSNcDy76rmFR+tVFExBVu+zUVkzt99AQtr1zmNWDkjNGCfiXUKefv/e75HoiC7F9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xnCyepFb; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xnCyepFb"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49s2mpgz1XM4TB;
	Thu, 30 Jul 2026 22:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451706; x=1788043707; bh=cSi0x
	9eLu2WWxDIk0hUKpzQrr7L+/mH2Sb4kAlyQRkU=; b=xnCyepFbGj/zH18BfKenZ
	8jY/nhapfi6rOm+rRYO9Ipjq+PRIFLQ1ceQsqsEA0WRIW72VUM6tSpInMGpivQzF
	7bWHokv/dJpsbM7tmrZdOMdF6PWCVT1VU/nH9WuihyGh+q9n5lb/jE8pNhOUGzMf
	avFKhlPIK3yZhsbYfdTTt+5Snoy7concxEUKqCj6ud7veFNbPtDwKW+Wpt8zYaJY
	Wmc9fD0i4SJjTrOu/rka0c+mURQItJMifzVLP/k2+vhczJNpDhfD3RiwNUxLHU5W
	CBIRVJtm21ZLuGxXVRwJvNIXLYoKIGIDgKn9iQRcSxolc+8vyAirejMZ4KG+W+nU
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PM87zJQAhkqH; Thu, 30 Jul 2026 22:48:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49g6W80z1XM30k;
	Thu, 30 Jul 2026 22:48:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 35/57] scsi: libiscsi: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:18 -0700
Message-ID: <1af31b1ec29305661d2254a81c1839a4948bcd38.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c | 19 ++++++++++++++++++-
 include/scsi/libiscsi.h |  5 +++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 160f02f2f51d..c6abaeb79d9c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1088,6 +1088,7 @@ static int iscsi_nop_out_rsp(struct iscsi_task *tas=
k,
=20
 static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr=
 *hdr,
 			       char *data, int datalen)
+	__must_hold(&conn->session->back_lock)
 {
 	struct iscsi_reject *reject =3D (struct iscsi_reject *)hdr;
 	struct iscsi_hdr rejected_pdu;
@@ -1500,6 +1501,7 @@ static int iscsi_check_cmdsn_window_closed(struct i=
scsi_conn *conn)
=20
 static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *t=
ask,
 			   bool was_requeue)
+	__must_hold(&conn->session->frwd_lock)
 {
 	int rc;
=20
@@ -1915,7 +1917,8 @@ static void iscsi_tmf_timedout(struct timer_list *t=
)
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
-	__must_hold(&session->frwd_lock)
+	__must_hold(&conn->session->frwd_lock)
+	__must_hold(&conn->session->eh_mutex)
 {
 	struct iscsi_session *session =3D conn->session;
=20
@@ -1962,6 +1965,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_con=
n *conn,
  * Fail commands. session frwd lock held and xmit thread flushed.
  */
 static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+	__must_hold(&conn->session->frwd_lock)
 {
 	struct iscsi_session *session =3D conn->session;
 	struct iscsi_task *task;
@@ -2408,6 +2412,9 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
=20
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	conn =3D session->leadconn;
+	/* Tell the compiler that conn->session =3D=3D session. */
+	__assume_ctx_lock(&conn->session->eh_mutex);
+	__assume_ctx_lock(&conn->session->frwd_lock);
 	iscsi_get_conn(conn->cls_conn);
 	conn->eh_abort_cnt++;
 	age =3D session->age;
@@ -2531,6 +2538,9 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	if (!session->leadconn || session->state !=3D ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn =3D session->leadconn;
+	/* Tell the compiler that conn->session =3D=3D session. */
+	__assume_ctx_lock(&conn->session->frwd_lock);
+	__assume_ctx_lock(&conn->session->eh_mutex);
=20
 	/* only have one tmf outstanding at a time */
 	if (session->tmf_state !=3D TMF_INITIAL)
@@ -2564,6 +2574,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	iscsi_suspend_tx(conn);
=20
 	spin_lock_bh(&session->frwd_lock);
+	/* Tell the compiler that conn->session =3D=3D session. */
+	__assume_ctx_lock(&conn->session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
 	session->tmf_state =3D TMF_INITIAL;
@@ -2693,6 +2705,9 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *=
sc)
 	if (!session->leadconn || session->state !=3D ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn =3D session->leadconn;
+	/* Tell the compiler that conn->session =3D=3D session. */
+	__assume_ctx_lock(&conn->session->eh_mutex);
+	__assume_ctx_lock(&conn->session->frwd_lock);
=20
 	/* only have one tmf outstanding at a time */
 	if (session->tmf_state !=3D TMF_INITIAL)
@@ -2726,6 +2741,8 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *=
sc)
 	iscsi_suspend_tx(conn);
=20
 	spin_lock_bh(&session->frwd_lock);
+	/* Tell the compiler that conn->session =3D=3D session. */
+	__assume_ctx_lock(&conn->session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
 	session->tmf_state =3D TMF_INITIAL;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 3d765c77bcd9..d39b5b268e6f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -474,8 +474,9 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_conn =
*, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
-extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
-				char *, int);
+extern int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hd=
r *,
+				char *, int)
+		__must_hold(&conn->session->back_lock);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
 extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t)=
;
 extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
