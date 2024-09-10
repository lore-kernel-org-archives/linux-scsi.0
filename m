Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B831ABEC9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005151; cv=none; b=gEd+DYsABKl8ZVEHaiOMJiMxV6wGcdTRy7WO0JL7Kpd/tqZov1tNC4CBSYCzt4OI36b9S0lZsGTsPDceMzhuSIXxphChMhOeFRBjGNU0o9omZkN+18OeOD0i+uNPVcDfJowLtPfIIgpYAbupVkm9DaT8vPvRoYKG4xMMJ3yFpVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005151; c=relaxed/simple;
	bh=2+HawifvlU7XBJ7sgcZaVrH1ZB48wCIRIHuaLViGXbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qINupNTbqyMbsYk+qJhML5WiwtFhQvxDLaTgOeg7IOyB6cdYCySMuw/OOTefQ0W7Xegr0oWw/dCmDKNFwKByyH0UncfAVxugrYDDcryU1Oo8vXRaoOo+75LxKx0fqG4rJb42XSzE8GydJ2UXqAFzsRnUEqsmHddI/XZHS5N7lB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vKdRE8k3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vKdRE8k3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVj3YYjz6ClY9K;
	Tue, 10 Sep 2024 21:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005144; x=1728597145; bh=Jc6/G
	r2+hoHWK0YP5X1QMpHQtO+syZEWlLFMWzMyDI8=; b=vKdRE8k3bfihwX1M9X1nC
	/9iQ9tveECW+34mkaIP7DerbShB28Aw+hWaU6K0YWkUm3OtBlwswvjpl7qC0oUBX
	k6qV3AFniGxycauV5vJjSeK4N7+jQUDjTXke1BvtXQE/Y25Q+nPF8UpnJDTtJisy
	XVdeU6YAeBW4NJpcCb8eFebk1yF0DU6070xfTRzDpX4hik+wf24AmuFhKgMEQBv2
	HPStOAjZRXY/Hlr8dGml54zu2yCivmkpH3NNGRrSvy/rbDiuKgSqu4eYg+JpH/2T
	chXdcnZ51QX2d6nb4FoPt5sOWnfqH60pbTIrBMfYYifQpx1OAhFdfVVv38xD+TK9
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5hu-mxjFFTbq; Tue, 10 Sep 2024 21:52:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVZ1VyWz6ClY9H;
	Tue, 10 Sep 2024 21:52:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v5 03/10] scsi: ufs: core: Call ufshcd_add_scsi_host() later
Date: Tue, 10 Sep 2024 14:50:51 -0700
Message-ID: <20240910215139.3352387-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240910215139.3352387-1-bvanassche@acm.org>
References: <20240910215139.3352387-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() after host controller initialization has
completed. This is safe because no code between the old and new
ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0ca20f069cbd..6ebafd08ad6e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10546,10 +10546,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10561,7 +10557,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto free_tmf_queue;
+		goto out_disable;
 	}
=20
 	/*
@@ -10596,6 +10592,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10603,12 +10603,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
