Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9A3CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451654; cv=none; b=ZFfnMP1/i3p0UMbt/2OX+Nu9vwtds52sRG494ypz43TNR83jG8fMr8eSOdGzaOuwigHd+vSOeTiXMBpORzvMw4wUCnYbqG2NAFX3kbVZmECg9XQDKw2KXyA9YkhNlKisQhD/T2mOliKH/h+N66cY/JyGqAAYBD/po8wBsp+6hVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451654; c=relaxed/simple;
	bh=YvQPTSLZjjNqI6F27JJxdl2tqRIp855nNJ5VkINyXTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSInULtuvyPDnE06Yhtx0TYV1SURsOY/Iikw8LU3zjEHg2TPef2vzvb5LsilYKRDsCPjt573HlQOyUePPxDHddGnIb8TVnCELoTZvVRay9rT7Zxh11bHCvFpun0QCS6TanTGgPw9y+cgYkKJoxWCQiFtiKsRkvg8C3LL0zxA9pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TKb7TAA9; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TKb7TAA9"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48j12mKz1XM4TB;
	Thu, 30 Jul 2026 22:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451649; x=1788043650; bh=U7WZA
	po3QESKqo3zxWmTXd1ulz3fP6GnxNJ/T/f3j/U=; b=TKb7TAA94oV0Seh7PqdZT
	8mOkMd/MeRAoG2NJn1PMv+V/MPs6fiZpq+BP9dVNFJHvJeTo8XUX0dQu/W8nic5G
	aaRsTcFU7iUgwc/UjkCn/HOvfXUTzNQKlW/tzkHeUU9T1RbiC102y2KXDLE1HNCy
	ViDqRpQYsqqqWfXjf1IVW0iTKqjRYCf/hF+9l70mQrm0N7sXylJ8P1vgugvPyTQG
	qYLrwv5JVbX3OtCqm9beNkdlZoup8+FRpERTzOrc+ESbkB/6ERk/ZdkRfQXGQ01Y
	/wbAnRUsuSUAmjJ3fZrPMXBWeK7QZYkgFOvFyVveLP3IHBMoNx4IsFuSp9xMVCzg
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rOP64qHw3gM1; Thu, 30 Jul 2026 22:47:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48c12PGz1XM30r;
	Thu, 30 Jul 2026 22:47:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 15/57] scsi: be2iscsi: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:58 -0700
Message-ID: <4262a35feddb1851a77a1d3d8bf1da750a766e65.1785451174.git.bvanassche@acm.org>
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
