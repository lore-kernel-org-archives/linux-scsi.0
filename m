Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A741C6883
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845426; cv=none; b=t0uWXHvLtA65ebeMyWvPUOqqDIu3Ot20uvVY94oEUgRruFnQtfADYb2IjfaJMAAxpMg3FQRYqYbtTbSB7HqSbGQVWt1moFXCfXxWQaZSBymMxXjHG3rvBSOoI2Fu+fI8dXJTpPEKvMvg20OGCmCjF7U9z2MClnm7wYE97bGPLF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845426; c=relaxed/simple;
	bh=QAQmSHyA1htKOCOTLofJhDkKV1bLR1ebEZ2/7d1S45s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDWD/YyPWt0txcw76wNfA5miNZiBJ7axlLohhRRwpGk/MwrDWAgheZQyGy23HH3Y0/rx5oLz1Uv5K2nFZXePX6BXhpB0oAdoYAc2o+7hcS6mFdlmjW/s/aE8BS5fbES1SMStzvt5pcZ5Var9T86wLnGfsM8rCD3CpE2Aza552ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wRF49qSC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wRF49qSC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnX6Svxz6ClY9G;
	Fri, 16 Aug 2024 21:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845421; x=1726437422; bh=0UxNS
	A4jrVK2mhDYHg/pl/5CjI4bZK3kZt5XmoH7sWc=; b=wRF49qSCilOpABcNqMFmj
	dXkQZpDLV64xTF2J51ZoAS5RAuyTwbTjyphYPSRWmFO2e+7LPVYeVOjnWJCnE7vB
	dZ9BSDPgf7VQ3i8vFpInceFcp+4IShNpUmLDh7YwOUUq/1rFH01+42e5Ikm9gOTW
	He2ZWGrnC/XTc1i8Rf3jRDKEp+Wg9e25l1bu6KtHy8rFKeNnGCM8KUflGOha/inY
	3wM6qUwGg9+7/tm2NkKNYxbm4wKTPbMV9qYudh/VHuUEe6E+f7BD/1N9vQJfEKYa
	a+hMPofIpKo5mzBozGtybLLBYVdGtQNJZj8G1kF4Dg6AcbJ7lD+MC+b1yhYZGbm9
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1_jovN9syaXp; Fri, 16 Aug 2024 21:57:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnR4fKPz6ClY98;
	Fri, 16 Aug 2024 21:56:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 12/18] scsi: qedf: Simplify alloc_workqueue() invocations
Date: Fri, 16 Aug 2024 14:55:35 -0700
Message-ID: <20240816215605.36240-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
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
