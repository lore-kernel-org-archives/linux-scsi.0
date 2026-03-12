Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1372E38B122
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350250; cv=none; b=pu1qTwevXKMNVzkBu2KvKKSywJCVwachoY9rbuedEN33be620Eda/jWq+RPN81BcffSoUdPziWDO8zcrFsyjHzWXgh22Wu6hD62/99ytT9JcQOl5wBICvBFTjocr3JQ8KOX9v787tR/6gLsEuKwdKvritqfkzAXVmj4jd6TvRP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350250; c=relaxed/simple;
	bh=YvQPTSLZjjNqI6F27JJxdl2tqRIp855nNJ5VkINyXTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5J1OEouFA5aCXrpFioOsJwXbvYLG6vKCQ7NZBBrYyN/AT6yVrNP6679dqnNBIBaqA82mU09E136qtowUEcf9Arb6oem+9blxL4+5Pt7ukm0WKcYVKqzFKQFHxLZnsv+od7ztvvCjnzGjP9107LK3gRwiXsoNhdVzoPw3TqEHNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mf49jUtU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mf49jUtU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nN4ltNzlfl7l;
	Thu, 12 Mar 2026 21:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350246; x=1775942247; bh=U7WZA
	po3QESKqo3zxWmTXd1ulz3fP6GnxNJ/T/f3j/U=; b=mf49jUtUnQQrNawBr0TUC
	qlfpFljzIFAMEBpd5Cq5tLpPU/kmUZeB8QwisnClQ90gdz3Spm3B1hW18AyCMsvv
	UmNsKtxj+b8s34+VBdY5EO5MjUSvB0FxJD5u7m0i5kZ/H1XCQVdT4i9xsjfURqJZ
	8aARS5RGZOL6M3S3ppHi66A1mrLi8swJW9MlGNkQ+ZTRCG4rp5eetuhJq2Elx/om
	2g/OLUgmKf6ibQEqb8CD2RJqbEEINOP+dhnLbg+HhiT4Qxfcf5lt94rPyGh4dSxm
	vusbcphJriHG8wwQmhq22iBDdiIGo8q5XkVDFbO0AAoXBD8A+UG9Y75NRHHT0Ql0
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WIpuDuxTmbP8; Thu, 12 Mar 2026 21:17:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nK2VRQzlfl5W;
	Thu, 12 Mar 2026 21:17:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/36] scsi: be2iscsi: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:22 -0700
Message-ID: <20260312211636.3245119-12-bvanassche@acm.org>
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
 drivers/scsi/be2iscsi/be_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
index fd18d4d3d219..289d9d18482c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1185,6 +1185,7 @@ static void
 be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 		    struct iscsi_task *task,
 		    struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_logout_rsp *hdr;
 	struct beiscsi_io_task *io_task =3D task->dd_data;
@@ -1212,6 +1213,7 @@ static void
 be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 		 struct iscsi_task *task,
 		 struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_tm_rsp *hdr;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;
@@ -1268,6 +1270,7 @@ static void
 be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 			struct iscsi_task *task,
 			struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_nopin *hdr;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;
@@ -1423,6 +1426,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *b=
eiscsi_conn,
 static unsigned int
 beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_conn,
 		struct pdu_base *phdr, void *pdata, unsigned int dlen)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct beiscsi_hba *phba =3D beiscsi_conn->phba;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;
