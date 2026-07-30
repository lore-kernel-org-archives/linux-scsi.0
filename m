Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E923D5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451670; cv=none; b=aoy82aoXhRtbe4xqvw6RXs3j27r5gIPXN11N3eR0gCR8PSSs5lhXubkbEbuLprmXzlopRlqJ/VP5P8vLsNeaHSOoN2A8Fd1XxrfdJsjs6D1j0d5Ig/I3c47pzMySng9ZWorf6/FWgbvkSqDZH9J7EYGQ/t0w7A9uqDDLWn8mtwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451670; c=relaxed/simple;
	bh=KeZTp2O1AsE8PDcJN04ve8v4bzfeg5o1XKJfOdK2kjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrhEy3r/8Aqxs5LT/Qb34H0BiiFRCvkeN4mQYEfhX5KrFqeCMm+IFTDljGOcYr5gCeudm+tW4Xkcvidq7Kwb/wMq0CfzFKyLzJ7tQbbX3XngumOYJpa9O09RwMKe28hOOK0HYzTs2Wgsipc7uyouUXS3Eu/zKgx6UVBKuWkgtr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hW9hS4xO; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hW9hS4xO"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4904yPHz1XM6Jm;
	Thu, 30 Jul 2026 22:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451664; x=1788043665; bh=K33jv
	ZuiGhmssFpBQ2JG3o3pDqkv1UifTF0bCYPES0A=; b=hW9hS4xOwqKL0HwPiA085
	hzL6yWPGuO2v+znerueZoQNEWq2OSILBOEvzmA03KhYKudnKoHbfUZnYX2wkcMEU
	ABtLgPD71+JlHu6oqe83le1RwWXseg1Nm+h70QotBRczXxbMn9wNai4abyYMbjje
	45NrGZjKjorNS48K/t7acxLyfwYbCZNafGSUXdfEg6eiww4oZTPIK11D0oc9pxso
	pfn0a9bsgHMybi3ks35sKiDAe5N3Fw5R6tGSA+9at0blFkbWZENTGUhu3hBCGils
	/Z1R+GYKw3wQwO68Cc7GXg4zGhlz1FEgqum4tg88SxRdz1nIwVcFw+IparjIIC/7
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Bs-g5SdJ95cV; Thu, 30 Jul 2026 22:47:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48t0sLTz1XM4TB;
	Thu, 30 Jul 2026 22:47:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 20/57] scsi: bnx2i: Introduce a local variable
Date: Thu, 30 Jul 2026 15:45:03 -0700
Message-ID: <3a60f53e2a4dbd6edcd4f8960b9454b68983b271.1785451174.git.bvanassche@acm.org>
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

Prepare for adding a new statement that will use the new local variable
'conn'. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
index d24cc2c795d6..4fb68ec8e9b0 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1741,6 +1741,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 				     struct bnx2i_conn *bnx2i_conn,
 				     struct cqe *cqe)
 {
+	struct iscsi_conn *conn =3D bnx2i_conn->cls_conn->dd_data;
 	struct bnx2i_async_msg *async_cqe;
 	struct iscsi_async *resp_hdr;
 	u8 async_event;
@@ -1751,7 +1752,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	async_event =3D async_cqe->async_event;
=20
 	if (async_event =3D=3D ISCSI_ASYNC_MSG_SCSI_EVENT) {
-		iscsi_conn_printk(KERN_ALERT, bnx2i_conn->cls_conn->dd_data,
+		iscsi_conn_printk(KERN_ALERT, conn,
 				  "async: scsi events not supported\n");
 		return;
 	}
@@ -1773,8 +1774,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	resp_hdr->param2 =3D cpu_to_be16(async_cqe->param2);
 	resp_hdr->param3 =3D cpu_to_be16(async_cqe->param3);
=20
-	__iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
-			     (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 	spin_unlock(&session->back_lock);
 }
=20
