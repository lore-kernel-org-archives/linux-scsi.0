Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E168C1591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107906; cv=none; b=Q4ILmVZQx8urtNvE5zGAp9HWoFivUm/YHLCeJuMrqSf0OXsPhARgMR3+Z/aV3NHSI3V9v7ufyXMh9c8NQEIhtdMhk/UTb6VoY9LeZ/BhSQAsxValWT6XE26vPB85tX8rGCIhRJN1bPZWerqVoQxXkIHHkmTSPnTeNF9am5Xiwis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107906; c=relaxed/simple;
	bh=URNmhsBxRqcgMDe8eZq301KX1pzszfHIQi5xnBoJnng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKtWqSrBD0mx4Joo4rN984u3uqXjtYG0oxouF7i3KyX+CTtC/Ao8mNvJOHROhKZ16TrCRBGtLIucTINIkMLzpG+elLrSgDLRrh0DtNy2sW+cL+o8k2GlEO+TJEZMmvK61bO2r8uUofG1aRGdSMmbLmUdeLEFpLD/DzQL/l1s+FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pwoJaa7O; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pwoJaa7O"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnnsD2pK8z6Cnk9X;
	Mon, 19 Aug 2024 22:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107900; x=1726699901; bh=k1Dqb
	1RHZ7CNjuttDn+c+kREstvvrJTrc3hZh6i7u+k=; b=pwoJaa7OCoGwk7J8RPoCb
	9AIaU5RQS/91HjjFK3KgQitpwt/5ncmwnhUbmTIKt/9/fgl6D/nrMUkT32KnA9oj
	E7DrDznqADTg7Ven3yW9ABqAP+WeR+038yMrMtscxJInspLB0AM9HWk9mOucMgb8
	twR6ufUvAAh4i6+PdDSxm1vjw9620qj21n1Rhl1Z1XKAdMcj940cMqD30906QI4O
	TdvM92tKl4mCD1BXW/zz+rYg5UZh5yWa41PBWpfkczRVn46Aeh/kc1AYtneg/+Z6
	rZYz1iRqWpbwS0N/z3/fOuAWC5y1uRYYykmP/OJ9bkvwii+0eRSC2egQ8x6Qh81T
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w-Ze9NSTtWkw; Mon, 19 Aug 2024 22:51:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnns73cbvz6ClY8s;
	Mon, 19 Aug 2024 22:51:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 4/9] ufs: core: Call ufshcd_add_scsi_host() later
Date: Mon, 19 Aug 2024 15:50:21 -0700
Message-ID: <20240819225102.2437307-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819225102.2437307-1-bvanassche@acm.org>
References: <20240819225102.2437307-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e64b08eaa5e..502d0f5a95c0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10583,10 +10583,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10598,7 +10594,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto free_tmf_queue;
+		goto out_disable;
 	}
=20
 	/*
@@ -10633,6 +10629,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10640,12 +10640,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
