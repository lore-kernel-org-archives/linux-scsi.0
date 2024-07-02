Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C084F20127D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957200; cv=none; b=BZlm0/R7BNDoeGFDFtZiBf1xS9l7IDoqqVnqRkTjVqJwGOAfB4c7Ya2CPg0ZVzvanUfK2XMKi97QWgzkE3g7LaBFAqH4beefk39Q4ZD0vTV9yYXRFEanoukp9BDgdL91GjC6avfqY/uG3SWP5G7FKhj0fGfmAY8syNb1kHaFNK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957200; c=relaxed/simple;
	bh=cgtOvADPeSF14nGQHjloqhw+5tHnH3QyTV7vyu1OuiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R33V441KF47SGWDe+P4VrFhs1oPkPEjQ61XaaMwXC1YOTOcaq5iyYT47OOcnTyCY6f2hClILeQ1BH+hcyxoKPbkobVDpRXVzhEzXJ3+jWoaw85ZeIucwP//56hoK2g03sFnSHMUgWC7yjgOO3ykWbXp+hC90oFeBpYHw47wVHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Lsv6eBNp; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Lsv6eBNp"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGqy1qY3zlnRR9;
	Tue,  2 Jul 2024 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957196; x=1722549197; bh=fqvIk
	ghVilRYJVAJ2j3innOMRcrBOb5gndIaWzePiOA=; b=Lsv6eBNp4YJcyY5pQB5Kx
	aulhtwD57J1/rI9f2HWce+1J1bzdFPl2ysSF+DvPAaeyWZ2kXTHFy+/f6lU1Ec1G
	YpCsfe5lunGd8SrA1JzuRYyf6xwUoLUgegJ5oRtdeZX3XotMYHoCy5TK3P5jRj1i
	1E3qXPthvUrdC1JsOwpsXip8o36oDMM7YfIb8CJINykoe5UsSf9ILyWPXW1vzepO
	vQIasb4fQ4OiS0flrR34ITRwD6u/ERjoYdTHKib0i1LtsYPheL1Z7Py2bvrLu+lA
	Whyn8sCTtQPB8gHLlO5ZoffKAk058LwCKdeImXPhg8EPDefVwSerwX7xTuc42wUN
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NCtmtv6jTGcZ; Tue,  2 Jul 2024 21:53:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGqt0QFTzlnQkr;
	Tue,  2 Jul 2024 21:53:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/18] scsi: be2iscsi: Simplify an alloc_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:50 -0700
Message-ID: <20240702215228.2743420-4-bvanassche@acm.org>
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
