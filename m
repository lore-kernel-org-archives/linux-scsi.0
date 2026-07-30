Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3948B3B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451675; cv=none; b=VPgCYXxWsKlTnyDBtH5SbliPNtHMYkNL5vVu7lliE/iDyhVktTVbsqu3VKyZacd9FdcdoBNcMDmFVJbH8ceN0Nsf2O6eTYisYfOhkm0lE0E5BhaJDl8xSlwi8khmOH2AwSIP6+tRS5ZrEnfR1Yu3FznUBcNp9KajnYz/8dz9wn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451675; c=relaxed/simple;
	bh=mslioQaE3AJByjdYBZW5RxJsKlJYAnhanPoXE6CNM5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdx3xkN5rSt7j8p5vMWuuheYT1bEBzjaIOIf+vmX/sPG4WMd3WeWQt8EZAUCj4bl17CoIbiVCvV1Qw0lt5n+h6Pyr7d7aw5Mqq42weC129PiA3oci+BskgGG4Uk4ej5sJIfX2I2HcMrxoyhJRgSQLdLPOAzHyTSQgWJ2YXCb74o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gkWQlWhp; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gkWQlWhp"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4956y9Lz1XM4TB;
	Thu, 30 Jul 2026 22:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451667; x=1788043668; bh=M250r
	zK4u6iV292aiViLunRQ6US5oBZWVzdJIKPDUm4=; b=gkWQlWhpTSSkdT60E1qHi
	zGSxvI6fDOmWUueRbJtI7TvFFgCHa/cEY4pgYHLAQsAzU9YeAlBbtxwMcfIdcjqF
	J057dS4M/Gfy0YEH5doiM2n5n0VB5VD5NybMF5Ue97bYkl8aD3qa65H7o8s2y1VW
	swATH/4tM1I4yeAmWLc+0rtc/hsrPlNw9k3G67oHI1gq6DRkDfvtWvjagxh6q2Li
	V73cRgt49gR/07dFz8dPJ88GeFqKKgw8Wz8TvUo0j30zJNKIdup0jSl4S45xo5bM
	/Wcl4vgyMujwCwvy1hslO8kov6SeqK/gefEgEK+YHvFrG3CmbeBitAkf4MsU6vJj
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CawFYfv1sCUd; Thu, 30 Jul 2026 22:47:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48x1b7Hz1XM30r;
	Thu, 30 Jul 2026 22:47:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 21/57] scsi: bnx2i: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:04 -0700
Message-ID: <0198362bf861b804f2f02e3be6f3d5e16c6238e9.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold(). Use
__assume_ctx_lock() to inform the compiler about aliases for
synchronization objects.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2i/Makefile      | 3 +++
 drivers/scsi/bnx2i/bnx2i_hwi.c   | 8 ++++++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/bnx2i/Makefile b/drivers/scsi/bnx2i/Makefile
index 25378671bb1e..2d8e8f0fdd29 100644
--- a/drivers/scsi/bnx2i/Makefile
+++ b/drivers/scsi/bnx2i/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 bnx2i-y :=3D bnx2i_init.o bnx2i_hwi.o bnx2i_iscsi.o bnx2i_sysfs.o
=20
 obj-$(CONFIG_SCSI_BNX2_ISCSI) +=3D bnx2i.o
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
index 4fb68ec8e9b0..5d927880d297 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1347,6 +1347,7 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_sessio=
n *session,
=20
 	resp_cqe =3D (struct bnx2i_cmd_response *)cqe;
 	spin_lock_bh(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	task =3D iscsi_itt_to_task(conn,
 				 resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task)
@@ -1443,6 +1444,7 @@ static int bnx2i_process_login_resp(struct iscsi_se=
ssion *session,
=20
 	login =3D (struct bnx2i_login_response *) cqe;
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	task =3D iscsi_itt_to_task(conn,
 				 login->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
@@ -1511,6 +1513,7 @@ static int bnx2i_process_text_resp(struct iscsi_ses=
sion *session,
=20
 	text =3D (struct bnx2i_text_response *) cqe;
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	task =3D iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX=
);
 	if (!task)
 		goto done;
@@ -1570,6 +1573,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_sess=
ion *session,
=20
 	tmf_cqe =3D (struct bnx2i_tmf_response *)cqe;
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	task =3D iscsi_itt_to_task(conn,
 				 tmf_cqe->itt & ISCSI_TMF_RESPONSE_INDEX);
 	if (!task)
@@ -1609,6 +1613,7 @@ static int bnx2i_process_logout_resp(struct iscsi_s=
ession *session,
=20
 	logout =3D (struct bnx2i_logout_response *) cqe;
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	task =3D iscsi_itt_to_task(conn,
 				 logout->itt & ISCSI_LOGOUT_RESPONSE_INDEX);
 	if (!task)
@@ -1698,6 +1703,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_se=
ssion *session,
 	nop_in =3D (struct bnx2i_nop_in_msg *)cqe;
=20
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	hdr =3D (struct iscsi_nopin *)&bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode =3D nop_in->op_code;
@@ -1758,6 +1764,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	}
=20
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	resp_hdr =3D (struct iscsi_async *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr, 0, sizeof(struct iscsi_hdr));
 	resp_hdr->opcode =3D async_cqe->op_code;
@@ -1803,6 +1810,7 @@ static void bnx2i_process_reject_mesg(struct iscsi_=
session *session,
 		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
=20
 	spin_lock(&session->back_lock);
+	__assume_ctx_lock(&conn->session->back_lock);
 	hdr =3D (struct iscsi_reject *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode =3D reject->op_code;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_=
iscsi.c
index 6c80e5b514fd..c868eada72c3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1154,6 +1154,7 @@ static void bnx2i_cpy_scsi_cdb(struct scsi_cmnd *sc=
, struct bnx2i_cmd *cmd)
 }
=20
 static void bnx2i_cleanup_task(struct iscsi_task *task)
+	__must_hold(&task->conn->session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	struct bnx2i_conn *bnx2i_conn =3D conn->dd_data;
