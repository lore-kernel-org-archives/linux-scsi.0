Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C81D0DF2
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356826; cv=none; b=qNwhYNl85z4DBvE539d+keTiwdcTY3xbHLukaBAmn9jgfK0zTt06zID4E6YKQMt4SHLiCpsF4CVxHk6i8AopmJA5D9O1EiF8kmfocCglqGe1fE1M4W/BC1aFBfn/I/IGhE5Juxg+1kja+sIMcAEbzhwI3ob/1+2rnBLPfYJnwnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356826; c=relaxed/simple;
	bh=QAQmSHyA1htKOCOTLofJhDkKV1bLR1ebEZ2/7d1S45s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyjef6YZQI9sFWI6oBkabsTcB26IJUljPOzNSCNO7d4Kdljq9lcCcSsvjmS5hyrtRqpGcyWtzn5botr/h1oVBAfFxuIjCUBL+oCwGvI7CZtxQEZZLK2GO+C9Ec4aml1NpkVxgec2SwsC7LxbOUxBYrdu1jncv/I9avanPz6GMdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2cHYql16; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2cHYql16"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw76s2Bz6ClY9V;
	Thu, 22 Aug 2024 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356820; x=1726948821; bh=0UxNS
	A4jrVK2mhDYHg/pl/5CjI4bZK3kZt5XmoH7sWc=; b=2cHYql16KovKz9cwsw3eV
	yCIMiCDgeQ+5y2HwnXPvo0ZkyPTbB0putbcqu8Gn7rVjq0sbBikuTBrXIPawq/c1
	zS0jT2OwDbCBTnDR3Tmi2Ko6qVPnwTEdKpYojBRmtPNvJ3G/yikS+RNZluMVJ7pC
	VJsazHcI3vcmS9GfJBBnKX88dRNHhdCAHpvTgooHrije8qmSFIasDXgycjCTa7tb
	WNiVjJ3UjvI+jL3xvH93L4u0z3zfS6GBehgk3QIOvYShSflXdeaFvSFyLJM+fdh0
	r49qS1okqQm+nB7SqmIPr0m+RV8aVxtfi7zT4qGbfwrJ7yea/n73d28dKhjDEga+
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cqEF-bqrj0FE; Thu, 22 Aug 2024 20:00:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw357blz6ClY9N;
	Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 12/18] scsi: qedf: Simplify alloc_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:16 -0700
Message-ID: <20240822195944.654691-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
index 119afcaf6e13..cf13148ba281 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3372,10 +3372,8 @@ static int __qedf_probe(struct pci_dev *pdev, int =
mode)
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO, "qedf->io_mempool=3D%p.\n",
 	    qedf->io_mempool);
=20
-	sprintf(host_buf, "qedf_%u_link",
-	    qedf->lport->host->host_no);
-	qedf->link_update_wq =3D
-		alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+	qedf->link_update_wq =3D alloc_workqueue("qedf_%u_link", WQ_MEM_RECLAIM=
,
+					       1, qedf->lport->host->host_no);
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
 	INIT_DELAYED_WORK(&qedf->grcdump_work, qedf_wq_grcdump);
@@ -3585,8 +3583,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
 	ether_addr_copy(params.ll2_mac_address, qedf->mac);
=20
 	/* Start LL2 processing thread */
-	snprintf(host_buf, 20, "qedf_%d_ll2", host->host_no);
-	qedf->ll2_recv_wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf=
);
+	qedf->ll2_recv_wq =3D alloc_workqueue("qedf_%d_ll2", WQ_MEM_RECLAIM, 1,
+					    host->host_no);
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
 		rc =3D -ENOMEM;
@@ -3627,9 +3625,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
 		}
 	}
=20
-	sprintf(host_buf, "qedf_%u_timer", qedf->lport->host->host_no);
-	qedf->timer_work_queue =3D
-		alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+	qedf->timer_work_queue =3D alloc_workqueue("qedf_%u_timer",
+				WQ_MEM_RECLAIM, 1, qedf->lport->host->host_no);
 	if (!qedf->timer_work_queue) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
