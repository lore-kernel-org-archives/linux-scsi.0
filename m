Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D616205E0F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957219; cv=none; b=l+87CuDeiIqIEGHPHCfg/v5DFCSQncuO6W75NE4t7jze8FN7lRNROxLPefq54xpq1McuPhf1K3xm1Yu1HeC1X1x8R7BTD7KHqwD6kffSZBrJireisQu1sDocdmYdDmn0aYSoPAh62gyIF/1dNPdVrBOiTtwJBv7Nx5mUpDRDe2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957219; c=relaxed/simple;
	bh=7nGf1avZ8XzYh4Jo/5xXziYrWN4ZpJANrQpBr0PjxYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nve1su+GzZTA2RSwbHJmhT112VZG3661ldUtfdyaHSb3ED6u2CDbUkwBqF130ObKXr6PUtRiCwA3Lg8U6Gy6OK7h+R2l5tXfsUmML8e3553l3rwbGREriaQPMB2PMdz31BQr01ZQS0rPmoYyp+S8NU6+mDNY7/QyRUUSyN4LyoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v/5woxAV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v/5woxAV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrK6jhSzlnRKl;
	Tue,  2 Jul 2024 21:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957215; x=1722549216; bh=FvyvV
	epn9Ef318j/BW4eY2hkqG5sJ6CUqIzNn60Mg04=; b=v/5woxAVuutbpYQc8fUiZ
	6lAjABPJhC0PR75InpGPbpxjyORSqNacaahk4oPi9cZcCq1BTOR2p3Ld+jvm5esL
	iMWt8v1E2uzDAqjbt5NDGjZvGiJ93L7uxWh5+u/82CLtmipKW6Gvb4r5Hmk1yelQ
	QdHzIdao0GcmtKjIAcfa72uXDBzgJlRIodnlg4ZAjLNyErOsXqnbchMaBHYH3MkA
	IB0BEuN19muBSIiOu9yWJBfbjA4ZP+Jgvxnys4uVLmhDOAdola1IRrhjEgtOYqo2
	UmAe2lYO/Wn300d9CEmpHUOpqeTH4b7dpsJ+a44UezddCKol8HN6WuriKu+Qvz1u
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NS10ZYbS2yAr; Tue,  2 Jul 2024 21:53:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrF5KJ7zlnQkr;
	Tue,  2 Jul 2024 21:53:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 13/18] scsi: qedi: Simplify an alloc_workqueue() invocation
Date: Tue,  2 Jul 2024 14:52:00 -0700
Message-ID: <20240702215228.2743420-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c
index 319c1da549f7..c5aec26019d6 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2776,9 +2776,9 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
 			goto free_cid_que;
 		}
=20
-		sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
-		qedi->offload_thread =3D
-			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+		qedi->offload_thread =3D alloc_workqueue("qedi_ofld%d",
+						       WQ_MEM_RECLAIM,
+						       1, qedi->shost->host_no);
 		if (!qedi->offload_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
