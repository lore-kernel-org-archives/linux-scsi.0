Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DDC201246
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952897; cv=none; b=X421leHrbzb/jcNhYUBsGgkPSEGJUzJdPWFXKaXaANtyMCSTFBQ4msJ0kXHAA6ZFhjxAdBLYkFI2gDyc0q8Bx/SEvxLCzPpG5uEco5bnMGZ1QtfheU9Y3cWXFjYNlgwLhl7ZnXNra2EhOeaP3Pok0oqImYdEws6pyq7UcX2FuLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952897; c=relaxed/simple;
	bh=YjQbZqUwcCLmfbhkyRd0rH3X9WO7x+lPm3CeHYqHzF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTVLXAO1bG6cHg9ORGz0fspn4w4GoRiX/Z0o1+RGwVxvXpDVXjd7TST8NzL05Q325hIX8gGpLwZ+jTcOGVYUvTkox7+dWHVhbF2dZHcPLsl24voNkaPH44sLLaqxLh2Zl6RUChF6LOr0iYKLubT68vAGC25mtyY/hRr7DdM6h3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w+9O4YM2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w+9O4YM2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFFC248jz6Cnk98;
	Tue,  2 Jul 2024 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952890; x=1722544891; bh=A2j8G
	UDqyaNQ0NQMKq5c00lJtMK/+ICJoy3fvc35Au0=; b=w+9O4YM2g5TN0IQkKhClp
	CIEBWAUl27iewRf1rlBbWjUerEKjHv9zHQl/mWqRIEW9/o8PWIIwG+7xKgiMEQ64
	MmRqruYVHTTZZZz/h06lxj7FUvx1ybX44rvKO6RQzNvRk0NlAlaapDTq1j0jdWf4
	G77ynehYbQAi5BpZbYVbBKLNLkVxzhZdDevPT7kYYuUtBrkzcy/3lvT1tMOa7JBB
	w+NYGtJx9+TEugYFfk6n2p7IloIm4U0orOSK8TtZEc1jzWt3/KJVd7Z6Ct2fcyhf
	19ILqIhQj18FdLEtaE+6rmxthVGo6kk9VWiIa0sSduobCinLGwuv9az3FrAbfVC0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YBovGD3id51x; Tue,  2 Jul 2024 20:41:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFF50fL2z6Cnk9V;
	Tue,  2 Jul 2024 20:41:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 5/9] scsi: ufs: Initialize hba->reserved_slot earlier
Date: Tue,  2 Jul 2024 13:39:13 -0700
Message-ID: <20240702204020.2489324-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the hba->reserved_slot and the host->can_queue assignments from
ufshcd_config_mcq() into ufshcd_alloc_mcq(). The advantages of this
change are as follows:
- It becomes easier to verify that these two parameters are updated
  if hba->nutrs is updated.
- It prevents unnecessary assignments to these two parameters. While
  ufshcd_config_mcq() is called during host reset, ufshcd_alloc_mcq()
  is not.

Cc: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2cbd0f91953b..178b0abaeb30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8678,6 +8678,9 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	if (ret)
 		goto err;
=20
+	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+
 	return 0;
 err:
 	hba->nutrs =3D old_nutrs;
@@ -8699,9 +8702,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
-	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-
 	ufshcd_mcq_enable(hba);
 	hba->mcq_enabled =3D true;
=20
