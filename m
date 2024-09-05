Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF77F15532A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573766; cv=none; b=rkaBN3Z+mbCjvWXR4lFaGJIoBzX5naMDSNL0L331NGyVsQ1a+RQ5VIwlECkIIVpaTd0yXiUYKweNbdnMNTAzZMc6kIl8BtL0gyP4AFyvP0WAiUt9p7FyPfpdMLFRsp3X/Jo7wJLvi+U97LY1F/Tb9mU45ODk7KDc4V/fB+g758U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573766; c=relaxed/simple;
	bh=Y8h0p1VIW05/oj6rm1hd2eyj8F9k94ol2MTF/wnnXeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLa+NxbEpgbBMC9ODHecEI1+m4iiL7q0l6b81UcpRWQn7lFuHSDLiyeEkd9xCTXEuglZc6CREuA1eUwlsD3SnMvOgEPKqWhduPT5WbOGpwNKvnu5WTF5z1T+3yIskxLPD+E69Kj9boGoR/KRFLgbhNO08rSsq3foDzVsKBtegdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ct9EccVx; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ct9EccVx"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cyr2hklz6ClY8x;
	Thu,  5 Sep 2024 22:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573760; x=1728165761; bh=zW7dx
	286Gkb9lhuBYiFuiaZzA2lPOFmNf/CG3iIDeJQ=; b=ct9EccVxavM1lndqRI6Kp
	wMM7agmGHMkc4iakZjNfePoP/TeHmom5sC7DtsWGW6DGPl1g1Ji5JPSxAvLSq5Fg
	+xuXTP1HEYtUZ8+JDur7Q6hedQv4oOAkHLee9q9SVJpsclKs03ksEJvpJMddZ6Cg
	H+zZJkPAiqlsIbiAPTfBiZa6Y3ui2EubPCCCcD6cc6DH828RwTIHQ6R52FKhHQE4
	9E3qFE46HMBj066gUQCM/GpA6l0GEfRCSw6S9W7r4ex738QSLoRtcnonZC3eVODm
	vWqDlZFA+0IY6XMmdMEX+rRWDvlUoK62nM+P8GRf2AArx0De6cKLVX+ckquuTY08
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id De0Z9CjpXFlR; Thu,  5 Sep 2024 22:02:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cyl1sXTz6Cnk98;
	Thu,  5 Sep 2024 22:02:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v4 04/10] scsi: ufs: core: Call ufshcd_add_scsi_host() later
Date: Thu,  5 Sep 2024 15:01:30 -0700
Message-ID: <20240905220214.738506-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() after host controller initialization has
completed. This is possible because no code between the old and new
ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 916da4c054be..e2137bcf3de7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10558,10 +10558,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 		hba->is_irq_enabled =3D true;
 	}
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
=20
@@ -10573,7 +10569,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto free_tmf_queue;
+		goto out_disable;
 	}
=20
 	/*
@@ -10608,6 +10604,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20
@@ -10615,12 +10615,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
=20
-free_tmf_queue:
-	blk_mq_destroy_queue(hba->tmf_queue);
-	blk_put_queue(hba->tmf_queue);
-	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	if (hba->scsi_host_added)
-		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled =3D false;
 	ufshcd_hba_exit(hba);
