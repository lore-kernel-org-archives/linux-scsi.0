Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCD9201251
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957232; cv=none; b=EwWTTghx05xegIhwBDroPNYaDUfHOvG78HvkjSYvQ1yOsO9EZU2dzAvjnMrgZHqybwN5U4p9Vxf2BsFbxhQBPpAh8FIOIZJIg+evhjTlS7aUkHYDAe6pbUfFKnnrs1SyfQMqz/gLOA5iswB/7i3HMdHCUdi1HamVcLrIWLSx49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957232; c=relaxed/simple;
	bh=hcR4ZQD3K4bqfHWbJAjPIBLy0QOL0qEX0+szvfFU78c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGRySdjHegQZVP/E6lAvLmBNWPMWtJ6pazxVqkBcOxGOOnpat8N9rdTAMMr9laaDM/kG/RJvkcU6BONSC+d6lNIBDCinnVpiTdBzcm389p3V8rrWdetFDhZlvfRaD9VR68cVia3qTHhhtT4onPk60o2x+fljQjVrWtnp86QDSSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G5JtrOOi; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G5JtrOOi"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrb1kxfzlnQkq;
	Tue,  2 Jul 2024 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957227; x=1722549228; bh=+S0tD
	K0Gcs2DmPBZAIK60cIIER5EgsFitASsU0+X0DU=; b=G5JtrOOinz/Bhh6STUASP
	IoLBHw22Mv1/q9ndySPrk7qPFwmFQIPLAKNJz/YF90NwiysMMAVXn8AgjS8UefrG
	0/GSllyzSs2DLqHGcdWKrpSUAWTa6lw0Jmh8b5UAg5Ee2r6jmt5P51rOb0inifHK
	K0zTzhr7C6Gqn1RFQPbwsaVQVOEaKq3qcV3Kj7unAD8Dg/Mu6hcS4AO3QCPi2rKQ
	2toeyBLo1uoTkNmhGH85RiSTg0ToU+nYNG31xcivZ1IsSqfT55P4JXxI3IYSLJ02
	G8flGmeD0cgfn03gON7kl8YFQiV+zkdNgaYub0L7cFwuBomZhecHDH5umIyC3Y+R
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jHDJy-MMXKyp; Tue,  2 Jul 2024 21:53:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrT1DP7zlnQkm;
	Tue,  2 Jul 2024 21:53:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 17/18] scsi: ufs: Simplify alloc*_workqueue() invocation
Date: Tue,  2 Jul 2024 14:52:04 -0700
Message-ID: <20240702215228.2743420-18-bvanassche@acm.org>
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

Let alloc*_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ac62476313af..c4fe6890e431 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1786,8 +1786,6 @@ static void ufshcd_remove_clk_scaling_sysfs(struct =
ufs_hba *hba)
=20
 static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clkscaling_00")];
-
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
=20
@@ -1799,10 +1797,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba=
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
@@ -2126,8 +2122,6 @@ static void ufshcd_remove_clk_gating_sysfs(struct u=
fs_hba *hba)
=20
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clk_gating_00")];
-
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
=20
@@ -2137,10 +2131,9 @@ static void ufshcd_init_clk_gating(struct ufs_hba =
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
@@ -10369,7 +10362,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host =3D hba->host;
 	struct device *dev =3D hba->dev;
-	char eh_wq_name[sizeof("ufs_eh_wq_00")];
=20
 	/*
 	 * dev_set_drvdata() must be called before any callbacks are registered
@@ -10436,9 +10428,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
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
