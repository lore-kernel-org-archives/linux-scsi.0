Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD2D13AA4E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356836; cv=none; b=Thrmb5cIPA8fwzCw9Cl/bfOXf3cnjVWqgIVZn6jB6Dkq/BdcF/sgcSexNg4MSZGIfl7O+3jaIfdVZ4to30o9Nij4gcnwZeo9YFB77TyWZdKo/ITRAd2CMdd/31BonFPiP7Mve1xoGSXn0IVEoYYAjVq3wq9I+tjllxOeuyGmkqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356836; c=relaxed/simple;
	bh=OXtnHsx14vrlA8yUoDAw4bvMVRD349ZIRskqcSnCkew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0xzvEC8nhBVgFu/WmvWLrIh9NMBla34K+H4NUWBzHMWSRXOczbjErIdeuSs2yajgC7wD0cfwyvHpxTTe4Hpamx/3W42TpeM5D2Z9GmFJ9Lxpd9fEOqptcRLXgMGDoSw4NeynzQjLXoid8faclW/WWgAznhQfo0slzo4yUKV4AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dgx6N/EC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dgx6N/EC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYwL56Qgz6ClY9K;
	Thu, 22 Aug 2024 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356828; x=1726948829; bh=WtPiN
	dwGiioFIODzHvIxB4aENqsjb99zdQo7b/4Ezfc=; b=dgx6N/ECAolaJU0sZuxQ+
	aKySr4jQhbdzZyj5EYnFkWlMhp8+/9wJT526s3llzhT50hjXSgE4BPWXDzn+J7f0
	iF9ZWkio2eLogY3hKC0W8L0csgsN79zrOeE++9gqVe4CPj3EmMAiqD9d3AnNVRHq
	y9bKZic1gikBwHnA0rwmXZrCds6uMh8LAZPbmiy0iair2CmxHIwfW49Yafwmcs/K
	HzEv8cJAFQBlq9jsDMYBhCtkysyZtq/D4DvDh0E6ISp+Mk5gVOdbjJhIn1Tkfmj2
	bwuKl1fGAy26BEB3zXTo2dX553Ll/rAiwdHucz7XSyRjnDSkrGyGjWfbdjWeWSW6
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M2JMgyjlr1qY; Thu, 22 Aug 2024 20:00:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYwC1nZvz6ClY9P;
	Thu, 22 Aug 2024 20:00:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 17/18] scsi: ufs: Simplify alloc*_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:21 -0700
Message-ID: <20240822195944.654691-18-bvanassche@acm.org>
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

Let alloc*_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bc00603a6837..f3a50517d691 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1804,8 +1804,6 @@ static void ufshcd_remove_clk_scaling_sysfs(struct =
ufs_hba *hba)
=20
 static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clkscaling_00")];
-
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
=20
@@ -1817,10 +1815,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba=
 *hba)
 	INIT_WORK(&hba->clk_scaling.resume_work,
 		  ufshcd_clk_scaling_resume_work);
=20
-	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
-		 hba->host->host_no);
-	hba->clk_scaling.workq =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, wq_name);
+	hba->clk_scaling.workq =3D alloc_ordered_workqueue(
+		"ufs_clkscaling_%d", WQ_MEM_RECLAIM, hba->host->host_no);
=20
 	hba->clk_scaling.is_initialized =3D true;
 }
@@ -2144,8 +2140,6 @@ static void ufshcd_remove_clk_gating_sysfs(struct u=
fs_hba *hba)
=20
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clk_gating_00")];
-
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
=20
@@ -2155,10 +2149,9 @@ static void ufshcd_init_clk_gating(struct ufs_hba =
*hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
=20
-	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
-		 hba->host->host_no);
-	hba->clk_gating.clk_gating_workq =3D alloc_ordered_workqueue(wq_name,
-					WQ_MEM_RECLAIM | WQ_HIGHPRI);
+	hba->clk_gating.clk_gating_workq =3D alloc_ordered_workqueue(
+		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
+		hba->host->host_no);
=20
 	ufshcd_init_clk_gating_sysfs(hba);
=20
@@ -10395,7 +10388,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host =3D hba->host;
 	struct device *dev =3D hba->dev;
-	char eh_wq_name[sizeof("ufs_eh_wq_00")];
=20
 	/*
 	 * dev_set_drvdata() must be called before any callbacks are registered
@@ -10462,9 +10454,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	hba->max_pwr_info.is_valid =3D false;
=20
 	/* Initialize work queues */
-	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
-		 hba->host->host_no);
-	hba->eh_wq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, eh_wq_name=
);
+	hba->eh_wq =3D alloc_ordered_workqueue("ufs_eh_wq_%d", WQ_MEM_RECLAIM,
+					     hba->host->host_no);
 	if (!hba->eh_wq) {
 		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
 			__func__);
