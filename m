Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620371C57B6
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845442; cv=none; b=gbRS9k+zFRHBJrKlVCR3EvF6Zo7nJ1J3Jo5YC79jwuwkrDupUpeVT2HBd+Xxgv6hBuOx1MyHW2MGpba/dvvGKJvO6TvFTMTkXQXoVevrn1gmLg4vFgYU2bc0eUwZztFlzGKB6DJZMp0gcCSp+onto2p5gN9jw7QtJGzFVXbPglo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845442; c=relaxed/simple;
	bh=8+hON0yNC5I7sgukoiEA2pQJrHHeDGpqEURbxX46D08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkV3znlLLrfOush4Sb9gODHjC7yLy9qn+VeQ6AHfyYEi3rrAomj6k4Tgfb4dfMMfVj9XDTzO7B/1ZqLAzJiblhy5TGp95AfvybTuAi+hl6PGT7pBeJUmEd5jmjNngtka4d+zNEMF+dBznQcl6xxYUrBzpuY+Exijm4QAYkO+G0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hiUqfAMu; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hiUqfAMu"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wlwns0sFyz6ClY99;
	Fri, 16 Aug 2024 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845436; x=1726437437; bh=0nDtl
	uR9I0iIkxoLzfN5XZuoIZjqcm2Qs9w34CmLQ7I=; b=hiUqfAMudKOhxwzGcFiS1
	lJfmCdaHs3no9GmYpeuFN6JxeaB2nUZFwiZvz1vPIBmbBVmMP+jKZrnk43g5l6m6
	5ffflaR2y7sq6F+dZrrgqagaTq3/ZaB8Lf45yG1yPQEGXRHGJ3rZNXO3+wEhACL/
	T1yJoiRvcgbL/iGqeYut49D3wk/he2d+t6cPK2d0jv/n02E2+NJklHpFQqG/7+PY
	h1wmU/VoDGg1rWps+/XSNw45qVxtO/wRcLWarIeJhLBFHkFHAM2/DPL0co8ZNqZp
	+xpeJ/dZPeE28hxvW6xKS8ZwmoMOQHur9AKcXU9OhpjsbdZOJwzjZVgns72PbKXB
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QtAoVcrL0Yl1; Fri, 16 Aug 2024 21:57:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwnj5bctz6ClY9C;
	Fri, 16 Aug 2024 21:57:13 +0000 (UTC)
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
Subject: [PATCH v2 17/18] scsi: ufs: Simplify alloc*_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:40 -0700
Message-ID: <20240816215605.36240-18-bvanassche@acm.org>
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

Let alloc*_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 22d5e27485c5..ee68e911741c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1785,8 +1785,6 @@ static void ufshcd_remove_clk_scaling_sysfs(struct =
ufs_hba *hba)
=20
 static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clkscaling_00")];
-
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
=20
@@ -1798,10 +1796,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba=
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
@@ -2125,8 +2121,6 @@ static void ufshcd_remove_clk_gating_sysfs(struct u=
fs_hba *hba)
=20
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clk_gating_00")];
-
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
=20
@@ -2136,10 +2130,9 @@ static void ufshcd_init_clk_gating(struct ufs_hba =
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
@@ -10392,7 +10385,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host =3D hba->host;
 	struct device *dev =3D hba->dev;
-	char eh_wq_name[sizeof("ufs_eh_wq_00")];
=20
 	/*
 	 * dev_set_drvdata() must be called before any callbacks are registered
@@ -10459,9 +10451,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
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
