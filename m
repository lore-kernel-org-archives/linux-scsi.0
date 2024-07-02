Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F0F205E05
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957217; cv=none; b=N+6ru/q+rx4IRuuq1RzaPNkc3SPpBUPNCNPlRoRqpb6sMcCsXRl1jXcUsFSKhyijW+MHefxKh+yisKQ3/nqIpjNRdZt1AQtgD5SYcdOPRMpSMweRNGp3lhx2H+gX0qk8XIp6BM5u/ur+YTTDQFUmhoXuIrSk4bhRI38mTfecbdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957217; c=relaxed/simple;
	bh=Q0g8XJrFx52OCVdALMXl6S/sIMa/FQ/BUQ71i2dlIy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVo/Vg14FWlxNAflzbEuuctB4fakjk/6/aus9UogJzw/UPBzq5TRaRYKb04z79sFeYeBLhfzrCfFLB3yB6JJviJr136udbehnj+/Y4yyL9gRPOciM2h571QvBVd6Hed9ONlyc5saKlYetcQL0AbCqZt1ST4cscyq1UZg/qj3vRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kz3PDRlG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kz3PDRlG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrH75MRzlnRRD;
	Tue,  2 Jul 2024 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957213; x=1722549214; bh=XC2gP
	qTJhYtdATzOgNtSj4poMunMDAgR/U+kwxdWVcQ=; b=kz3PDRlGSXLn7AhjaKrx3
	1t3euQTGYwFoUFVCGEV0pT2RnvhQfFkBeYhrRA56+hSm+xKpAmnp1m4VhuE4ikAR
	tapl3FRc49fX/wYaco4kuwN8nYkUSrTWVHSgzqGj+rrPvXhcURxPJ0VQWJkq1ELg
	9N3PGfHgjJJF5i6coruxwwCs26i5KerbMkqFcHzpXPSQD8DDhVIZWk3mouHhSe20
	U0oZatZRIp6tqMoCiCtzJzEFnK6FAzvHjz3/yblQ8B5wPyJjHTrKhmezvHMyvbhd
	ZJoBXXtW67Cirawlwig82QMc0DatMeipTJsPPro97FYJxCCxM4cTRovO0J5tAkq3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id imSfkqH6ZZZ1; Tue,  2 Jul 2024 21:53:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrC3zfHzlnQkq;
	Tue,  2 Jul 2024 21:53:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 12/18] scsi: qedf: Simplify alloc_workqueue() invocations
Date: Tue,  2 Jul 2024 14:51:59 -0700
Message-ID: <20240702215228.2743420-13-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
index fb161b2bb959..309f809d7f6f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3362,10 +3362,8 @@ static int __qedf_probe(struct pci_dev *pdev, int =
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
@@ -3574,8 +3572,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
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
@@ -3616,9 +3614,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
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
