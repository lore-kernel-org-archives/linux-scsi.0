Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3389844D688
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573378; cv=none; b=L9Bzr4xTl/lheYiQZXTsP4wEv1Rm4XnQj9bMJjmLhCAcUX6P8Y9Xuy+gGhyhSLcytNyKPBNiBiVZAUqsvjMFUTFOxY/Nl+jrK/X847PuYW0cNuMDmvGZqff0hX3Whq26q5ggtya2lYWPZsPChYj5fXAWVp1/zoHUb7W+q7ptPWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573378; c=relaxed/simple;
	bh=KeZTp2O1AsE8PDcJN04ve8v4bzfeg5o1XKJfOdK2kjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/JUpEPTDN4dAa80aeN7OvrhyvX4mma0w6CUt1p7x7zl0oFmb95Vd0aWD/rW2CwMqNg42xegQGaDbya5D3zpf4WTo0pZm7rzDG4WuySwQgN+u1s/HuO3kLX2Hgl6wc52Mp0WMZocCgPX5qXt5IufLxjSgT/8DU9up5cJGsB/KcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S9S82kBV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S9S82kBV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62bN71Y6zm1W0y;
	Thu, 30 Apr 2026 18:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573372; x=1780165373; bh=K33jv
	ZuiGhmssFpBQ2JG3o3pDqkv1UifTF0bCYPES0A=; b=S9S82kBV5GJJ7uBEo1ilx
	gb/htfP1+iSovOt+tKDY5SoO6UfHyGPQ0lYx4CuO2exIU4ZCM3LHau4iHIClMCl1
	1VrCq33JrDmHHyyw5w7JoRk+zBjoW1MwLxMrtKiXYn6og7GBuEpjITf7E8oE81qx
	zEJSxzePdcJR6vEKrnu9lGoa7u/2ZlRAUEIZm8IEuEZ4i5IGcJM7v1nlg9+r/9zL
	RP0xnuSThovOI4cIraRbX64MHQmnixh4E5WUmNs8JSJ3s+ExI2AQPYvjHgwa2Bvo
	2WRx5odtzdO5fYkdwzSl4hCgcx2k572x3uAPQ8oiMdccmv1nwhyEEKCQ039n3XOW
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rYMFDBawTx2U; Thu, 30 Apr 2026 18:22:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62bG4tfNzm1W16;
	Thu, 30 Apr 2026 18:22:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 20/56] scsi: bnx2i: Introduce a local variable
Date: Thu, 30 Apr 2026 11:19:50 -0700
Message-ID: <20260430182130.1978347-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
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
