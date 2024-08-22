Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF30C1D174A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362649; cv=none; b=u0MUxLA2anrSzs5+pXUR/DbYZ74Z0EHhsakO+RWt4Dtc6pbJpgFvwFG+hi7tQkt+t9ChgOse79biQQERXhkm8GwqoD0xgaX1SlECgYZXvyjY38hLKzvKWKJRw45gw/3w5+OCUIVshPJCgVNFOGRQ+O5edj5mE9FvgbEr1XrNTto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362649; c=relaxed/simple;
	bh=Pcyj7fQVV3nz554GsRrq2SpPP7hIzKuQiJGrX02bGZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/rnVpULdG5vNlrg6t5Erl0wL+38Bqb7a8WM3wZRPEt+Pty8y85WI2p6QhIy/XrVA4PAQq1pXwCHRI6HACDPY7dMI2imcsSS1Pn4oB7nTs0RhBUp/6u+IjxT6yzDRsNIliCOHB5WG5dSKdSXwZFXecbVCnUD8aJY/k3pctpdyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4rkFw6AM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4rkFw6AM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc474H5LzlgVnK;
	Thu, 22 Aug 2024 21:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362644; x=1726954645; bh=PN1Fo
	F6ET/Fi7afoMrP8ADAM3PYfwa1Ba1hrkrrzBP8=; b=4rkFw6AM8CMo2NS5qv3/g
	UXBXrrrbiwp/ZkcbjGCsDJum6r5LbkjUAz1jK3czKrxRDJdPyBEAu8r96LGEU6VM
	38uFyksgD0PqJnGuD2MFNhxBYTfiTDnHMdAMMMHWe5epONLQuGYI5Eq3ncbFkIf1
	Tg7X7Xuf+6JIXi9/X8OGZY7P8PHuv6FXLTF82XWlD25/ZM8hemdQaOgpzAeH3SOk
	HaxYaEw2/w7OblWDA0FYnd2u+m1UKLdn3C+6jL+ZyRmTzlHTtDoZaEwH4EU6+NBL
	ZTLudgki2yvYMpKh5bCeCS+VMk6rLq2H2o63GtfuOu1QROTjizQdeR8a9kXBwkOr
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9diblfe2ZE9u; Thu, 22 Aug 2024 21:37:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc434cZvzlgVnf;
	Thu, 22 Aug 2024 21:37:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 7/9] ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Thu, 22 Aug 2024 14:36:08 -0700
Message-ID: <20240822213645.1125016-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822213645.1125016-1-bvanassche@acm.org>
References: <20240822213645.1125016-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0fdf19889191..6a3873991d2a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10629,8 +10629,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
-	/* Initialize hba, detect and initialize UFS device */
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	err =3D ufshcd_activate_link(hba);
+	if (err)
+		goto out_disable;
+
+	/* Verify device initialization by sending NOP OUT UPIU. */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization and waiting for completion. */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/*
+	 * Initialize UFS device parameters used by driver, these
+	 * parameters are associated with UFS descriptors.
+	 */
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		err =3D ufshcd_alloc_mcq(hba);
+		if (!err) {
+			ufshcd_config_mcq(hba);
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				err);
+		}
+		err =3D scsi_add_host(host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			goto out_disable;
+		}
+		hba->scsi_host_added =3D true;
+	}
+
+	err =3D ufshcd_post_device_init(hba);
 	if (err)
 		goto out_disable;
=20
