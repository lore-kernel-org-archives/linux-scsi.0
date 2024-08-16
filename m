Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E091C68A2
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845408; cv=none; b=VnaTdLfKJId39xkANU4aalriArSdUsMzQP/7pcm8UX15viXEOYEJ4aqLhKEoK7QKLRk8Gl4vfqLPsy3yUo6tzEUdBwHQGGdKPJ/WqvdV5hq9WqZF4ZaZcSxmtGqWgeMyStQ5XPC1re443a/FwfqelJDaxoP+9gIC0JbhJNeZgRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845408; c=relaxed/simple;
	bh=cgtOvADPeSF14nGQHjloqhw+5tHnH3QyTV7vyu1OuiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM9DnpbVPSQGWYL1FUCnDubI6X+0a3o1/vgjsV0yqjyKER/Toovxe815ng+/FNi6z/lf/tLsgZXvY4EIBheU9fU9VapGRTrn/r0Fp6rPTORzr9i/Wbtc85LOTnTbZdpvrZ+bOb+kLDc8Bf3g6dpkSobuZ2/HEFT9wJAo0dQXNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tbIbulSC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tbIbulSC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnB1ST8z6ClY98;
	Fri, 16 Aug 2024 21:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845404; x=1726437405; bh=fqvIk
	ghVilRYJVAJ2j3innOMRcrBOb5gndIaWzePiOA=; b=tbIbulSCdK91p6lLNSSaA
	75o+QRgTcy5y7ShqvjKXp2sUL6w9pNp46J0NmL9YhzrOz4eyVjGORFb/6RMwyr49
	OLqotmxWf+5dJ1wJOaSvaRpn1RU3D+hsDFVuhkcVlzd/i7waSwtfBQ1uw4UHbf1C
	sbzNEpOE+Lz0F+tq14Q7Bg0CjJhCMwZh1PCL98CvHwp6jnKCsVyS4756UuAFaE6+
	TW/bY8H+8jqnvzOdxQ8Q4GKF+LZ9She8/nwDKAFIjSGbcWMxnNfY2pBm/YKdxEeY
	F1Y1yiQoKhjqhbiIUKhxLIMPE7BQgNS2ybHL13v/MHfVhhPQc81KVi3Ud6RRv+Vp
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YOs6mXLEYnrU; Fri, 16 Aug 2024 21:56:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwn45Zd5z6ClY9B;
	Fri, 16 Aug 2024 21:56:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 03/18] scsi: be2iscsi: Simplify an alloc_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:26 -0700
Message-ID: <20240816215605.36240-4-bvanassche@acm.org>
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
 drivers/scsi/be2iscsi/be_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
index 06acb5ff609e..76a1e373386e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5528,7 +5528,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev=
,
 	struct beiscsi_hba *phba =3D NULL;
 	struct be_eq_obj *pbe_eq;
 	unsigned int s_handle;
-	char wq_name[20];
 	int ret, i;
=20
 	ret =3D beiscsi_enable_pci(pcidev);
@@ -5634,9 +5633,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev=
,
=20
 	phba->ctrl.mcc_alloc_index =3D phba->ctrl.mcc_free_index =3D 0;
=20
-	snprintf(wq_name, sizeof(wq_name), "beiscsi_%02x_wq",
-		 phba->shost->host_no);
-	phba->wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, wq_name);
+	phba->wq =3D alloc_workqueue("beiscsi_%02x_wq", WQ_MEM_RECLAIM, 1,
+				   phba->shost->host_no);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
