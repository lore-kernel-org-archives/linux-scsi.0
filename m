Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEF64D37BD
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361000; cv=none; b=G7r9TxIEPoPDKzl4zfN7axZujFf0nW4yRxQh6Zr3btOhfmhV1B6kRWQNkpkNhiPo2DfiCZitGG2UsROuUr5RuGGWWqG1oUCnhBG9qgX5fl7THXPd60K3lyS+tQL7S9/hJRJjZvy5hmF35iztIccBdm8AHnfvbny+7PvCkca+/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361000; c=relaxed/simple;
	bh=x6dWmfLpGURNm7tOoU1n1AgYVog1ZG9wTea2Pg7jMv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Znn1LK4TlC+YfWmAep2yoGS9fUxT4YFB0xek1IGqbPOI6EMCQLV8fr/UDRhAXzIudrSyqcZ3R+pWgpYu+Lw7EBQ1O8zb6ACpQ7vfNMBut54g8FK+AFemivfQoB70SbUjI8Q1edsgJtY3VRB6m2p2UCKywRFymchn00wybxegvoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hubl/78Z; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hubl/78Z"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzlB2Kklz1XM4Tl;
	Fri, 25 Sep 2026 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360988; x=1792952989; bh=2GRdD
	HwY/piZEeWYH/F8IgDpf5iEx/cBrtdW1/5MmsM=; b=hubl/78ZlnDaTUNMAIFRF
	CbbDwtDbwrBcOxR/lCXa0Eyl/+BQdndQ4l3Uq2VUPg8qHOq4POkpI7kPta1OOP8H
	94xIxZMn0mWshK7fg5Lv3phyKaNwxKIm75JPc4OGOjDA8PiCgNnljZc8L5aKgUev
	Qjo6ww0GvI/kGPtm5RPVFtj7TleZN3kOHn8FtQ9F9AFb2NtNgyF5VInRWO4438Ok
	FQ/fesCq6Yyct6FIB6mnAS/433Mvh3Nhxu5GXd9U2X9vMhJQf5RjH4n5YmUDq4PI
	J3JwM78HrEjmWc1GIJljE7X0v9v9zFBye5g1rRMbnrjc5pbv7zQIvLByN1/ss/rv
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lEX10GLRnp8q; Fri, 25 Sep 2026 18:29:48 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzky0ZKyz1XM5kW;
	Fri, 25 Sep 2026 18:29:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 13/54] scsi: libiscsi: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:51 -0700
Message-ID: <7097a65b503cbf8d3a49c26f87293dd871080ea6.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/libiscsi.c | 21 +++++++++++++++++++++
 include/scsi/libiscsi.h | 15 ++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 179de08ca515..34d4125417db 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -454,6 +454,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task =
*task)
  */
 static void iscsi_free_task(struct iscsi_session *session,
 			    struct iscsi_task *task)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	struct scsi_cmnd *sc =3D task->sc;
@@ -499,6 +500,7 @@ EXPORT_SYMBOL_GPL(iscsi_get_task);
  * The back_lock must be held when calling in case it frees the task.
  */
 void __iscsi_put_task(struct iscsi_session *session, struct iscsi_task *=
task)
+	__must_hold(&session->back_lock)
 {
 	if (refcount_dec_and_test(&task->refcount))
 		iscsi_free_task(session, task);
@@ -527,6 +529,7 @@ EXPORT_SYMBOL_GPL(iscsi_put_task);
  */
 static void iscsi_complete_task(struct iscsi_session *session,
 				struct iscsi_task *task, int state)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
=20
@@ -562,6 +565,7 @@ static void iscsi_complete_task(struct iscsi_session =
*session,
 void iscsi_complete_scsi_task(struct iscsi_session *session,
 			      struct iscsi_task *task,
 			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
=20
@@ -578,6 +582,8 @@ EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
  */
 static bool cleanup_queued_task(struct iscsi_session *session,
 				struct iscsi_task *task)
+	__must_hold(&session->frwd_lock)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	bool early_complete =3D false;
@@ -620,6 +626,8 @@ static bool cleanup_queued_task(struct iscsi_session =
*session,
  */
 static void __fail_scsi_task(struct iscsi_session *session,
 			     struct iscsi_task *task, int err)
+	__must_hold(&session->frwd_lock)
+	__must_hold(&session->back_lock)
 {
 	struct scsi_cmnd *sc;
 	int state;
@@ -648,6 +656,7 @@ static void __fail_scsi_task(struct iscsi_session *se=
ssion,
=20
 static void fail_scsi_task(struct iscsi_session *session,
 			   struct iscsi_task *task, int err)
+	__must_hold(&session->frwd_lock)
 {
 	spin_lock_bh(&session->back_lock);
 	__fail_scsi_task(session, task, err);
@@ -876,6 +885,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_session *=
session,
 			       struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       struct iscsi_task *task, char *data,
 			       int datalen)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_scsi_rsp *rhdr =3D (struct iscsi_scsi_rsp *)hdr;
 	struct scsi_cmnd *sc =3D task->sc;
@@ -972,6 +982,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_session *=
session,
 static void
 iscsi_data_in_rsp(struct iscsi_session *session, struct iscsi_conn *conn=
,
 		  struct iscsi_hdr *hdr, struct iscsi_task *task)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_data_rsp *rhdr =3D (struct iscsi_data_rsp *)hdr;
 	struct scsi_cmnd *sc =3D task->sc;
@@ -1078,6 +1089,7 @@ static int iscsi_send_nopout(struct iscsi_conn *con=
n, struct iscsi_nopin *rhdr)
 static int iscsi_nop_out_rsp(struct iscsi_session *session,
 			     struct iscsi_task *task,
 			     struct iscsi_nopin *nop, char *data, int datalen)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	int rc =3D 0;
@@ -1099,6 +1111,7 @@ static int iscsi_nop_out_rsp(struct iscsi_session *=
session,
 static int iscsi_handle_reject(struct iscsi_session *session,
 			       struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       char *data, int datalen)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_reject *reject =3D (struct iscsi_reject *)hdr;
 	struct iscsi_hdr rejected_pdu;
@@ -1194,6 +1207,7 @@ static int iscsi_handle_reject(struct iscsi_session=
 *session,
  */
 struct iscsi_task *iscsi_itt_to_task(struct iscsi_session *session,
 				     struct iscsi_conn *conn, itt_t itt)
+	__must_hold(&session->back_lock)
 {
 	int i;
=20
@@ -1225,6 +1239,7 @@ EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
  */
 int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_con=
n *conn,
 			 struct iscsi_hdr *hdr, char *data, int datalen)
+	__must_hold(&session->back_lock)
 {
 	int opcode =3D hdr->opcode & ISCSI_OPCODE_MASK, rc =3D 0;
 	struct iscsi_task *task;
@@ -1420,6 +1435,7 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
  */
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
 				      struct iscsi_conn *conn, itt_t itt)
+	__must_hold(&session->back_lock)
 {
 	struct iscsi_task *task;
=20
@@ -1499,6 +1515,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_failure);
=20
 static int iscsi_check_cmdsn_window_closed(struct iscsi_session *session=
,
 					   struct iscsi_conn *conn)
+	__must_hold(&session->frwd_lock)
 {
 	/*
 	 * Check for iSCSI window and take care of CmdSN wrap-around
@@ -1515,6 +1532,7 @@ static int iscsi_check_cmdsn_window_closed(struct i=
scsi_session *session,
=20
 static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_c=
onn *conn,
 			   struct iscsi_task *task, bool was_requeue)
+	__must_hold(&session->frwd_lock)
 {
 	int rc;
=20
@@ -1932,6 +1950,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_ses=
sion *session,
 				   struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
+	__must_hold(&session->eh_mutex)
 	__must_hold(&session->frwd_lock)
 {
 	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
@@ -1978,6 +1997,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_ses=
sion *session,
  */
 static void fail_scsi_tasks(struct iscsi_session *session, struct iscsi_=
conn *conn,
 			    u64 lun, int error)
+	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_task *task;
 	int i;
@@ -3372,6 +3392,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_start);
=20
 static void
 fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
+	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_task *task;
 	int i, state;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index f79b46798edf..e4ac4ec0ac3e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -476,19 +476,24 @@ extern int iscsi_complete_pdu(struct iscsi_conn *, =
struct iscsi_hdr *,
 			      char *, int);
 extern int __iscsi_complete_pdu(struct iscsi_session *session,
 				struct iscsi_conn *conn, struct iscsi_hdr *,
-				char *, int);
+				char *, int)
+	__must_hold(&session->back_lock);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
-				      struct iscsi_conn *, itt_t);
+				      struct iscsi_conn *conn, itt_t itt)
+	__must_hold(&session->back_lock);
 struct iscsi_task *iscsi_itt_to_task(struct iscsi_session *session,
-				     struct iscsi_conn *, itt_t);
+				     struct iscsi_conn *conn, itt_t itt)
+	__must_hold(&session->back_lock);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
-void __iscsi_put_task(struct iscsi_session *session, struct iscsi_task *=
task);
+void __iscsi_put_task(struct iscsi_session *session, struct iscsi_task *=
task)
+	__must_hold(&session->back_lock);
 extern bool iscsi_get_task(struct iscsi_task *task);
 void iscsi_complete_scsi_task(struct iscsi_session *session,
 			      struct iscsi_task *task,
-			      uint32_t exp_cmdsn, uint32_t max_cmdsn);
+			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
+	__must_hold(&session->back_lock);
=20
 /*
  * generic helpers
