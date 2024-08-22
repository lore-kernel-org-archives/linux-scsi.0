Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B28EA933
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362621; cv=none; b=C2EWgcjLt8yXy+qUnCP/m4MfimLuzKxuRH65VV/U/fn07UmI+TV/V0yu6Q3sb+2smnB0R9XeNFJUMrC8QBqqvrD9Me8CBgIAazqisf3VBX3mCfP6DseSuEs3Erflmom/9GOYj85yW6mBiL+83bDRhUHhrEaHbuuqQKgBKCL8nvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362621; c=relaxed/simple;
	bh=nTypzgEjksi3jcwKnR0tyfT3fWHf6lw6I3DfZjucD0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r29CAy9g0ARrLq+KKE8ZEtp66HHr2jxqlbGMAk4sbl0MX5WJKwDmMcUMdRYHfpSj76vSuVqIghCygpHyjxt3xZwDDqpAT1tIEOTlsMm4hD9nG0Up2DX7bs4a3xo/QCwsyNjoB5edEupoyfiz1CfML+X1uutj7QYcG9mNknNItU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c3Xmhzmu; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c3Xmhzmu"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3b4s9czlgT1K;
	Thu, 22 Aug 2024 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362615; x=1726954616; bh=u2/WG
	8iVe04Ig/1vNTkhyEqdtFiTGRq9qrsGuIQaj9c=; b=c3XmhzmuTPAAGgbU0L540
	GnQgBRmn6kx6UIzXUPs/uQDODP7SYuJXZmUH0Gw02A/JooDp+RUTZcZ6cddGb0Yz
	rWVrqRiVLjVfBCLfnx7jJVFK+bxyJxp8Ft9FR2hLG/Mx1PdQJoCWmsiclJ7QCVgy
	qxwigzBGx1tIa3P5Oo5/mMNFEhtalBEiKEXWsCYAOW1HrW9Od41fuDQcEO+jh1PL
	OR3R2SUAd9bLbMLMOIcygokDGlPK42MXm1u2jPcPG6Q9MWz/LMecHJ0D0opIK1aw
	YdSVlZa8kd3zL1Y21gH3z/2dIBvDHwleEkZHZFlG8U06yELyGszSF4K/6qg8+iFr
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id azMw9IYG9gxl; Thu, 22 Aug 2024 21:36:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3V2sXczlgVnK;
	Thu, 22 Aug 2024 21:36:54 +0000 (UTC)
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
Subject: [PATCH v2 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Date: Thu, 22 Aug 2024 14:36:02 -0700
Message-ID: <20240822213645.1125016-2-bvanassche@acm.org>
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

Move the code for adding a SCSI host and also the code for managing
TMF tags from ufshcd_init() into a new function called
ufshcd_add_scsi_host(). No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd26059f5d7..d29e469c3873 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10381,6 +10381,56 @@ static const struct blk_mq_ops ufshcd_tmf_ops =3D=
 {
 	.queue_rq =3D ufshcd_queue_tmf,
 };
=20
+static int ufshcd_add_scsi_host(struct ufs_hba *hba)
+{
+	int err;
+
+	if (!is_mcq_supported(hba)) {
+		err =3D scsi_add_host(hba->host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			return err;
+		}
+		hba->scsi_host_added =3D true;
+	}
+
+	hba->tmf_tag_set =3D (struct blk_mq_tag_set) {
+		.nr_hw_queues	=3D 1,
+		.queue_depth	=3D hba->nutmrs,
+		.ops		=3D &ufshcd_tmf_ops,
+		.flags		=3D BLK_MQ_F_NO_SCHED,
+	};
+	err =3D blk_mq_alloc_tag_set(&hba->tmf_tag_set);
+	if (err < 0)
+		goto remove_scsi_host;
+	hba->tmf_queue =3D blk_mq_alloc_queue(&hba->tmf_tag_set, NULL, NULL);
+	if (IS_ERR(hba->tmf_queue)) {
+		err =3D PTR_ERR(hba->tmf_queue);
+		goto free_tmf_tag_set;
+	}
+	hba->tmf_rqs =3D devm_kcalloc(hba->dev, hba->nutmrs,
+				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
+	if (!hba->tmf_rqs) {
+		err =3D -ENOMEM;
+		goto free_tmf_queue;
+	}
+
+	return 0;
+
+free_tmf_queue:
+	blk_mq_destroy_queue(hba->tmf_queue);
+	blk_put_queue(hba->tmf_queue);
+
+free_tmf_tag_set:
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
+
+remove_scsi_host:
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
+
+	return err;
+}
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -10514,35 +10564,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 		hba->is_irq_enabled =3D true;
 	}
=20
-	if (!is_mcq_supported(hba)) {
-		err =3D scsi_add_host(host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			goto out_disable;
-		}
-		hba->scsi_host_added =3D true;
-	}
-
-	hba->tmf_tag_set =3D (struct blk_mq_tag_set) {
-		.nr_hw_queues	=3D 1,
-		.queue_depth	=3D hba->nutmrs,
-		.ops		=3D &ufshcd_tmf_ops,
-		.flags		=3D BLK_MQ_F_NO_SCHED,
-	};
-	err =3D blk_mq_alloc_tag_set(&hba->tmf_tag_set);
-	if (err < 0)
-		goto out_remove_scsi_host;
-	hba->tmf_queue =3D blk_mq_alloc_queue(&hba->tmf_tag_set, NULL, NULL);
-	if (IS_ERR(hba->tmf_queue)) {
-		err =3D PTR_ERR(hba->tmf_queue);
-		goto free_tmf_tag_set;
-	}
-	hba->tmf_rqs =3D devm_kcalloc(hba->dev, hba->nutmrs,
-				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
-	if (!hba->tmf_rqs) {
-		err =3D -ENOMEM;
-		goto free_tmf_queue;
-	}
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
=20
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
@@ -10600,9 +10624,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
-free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-out_remove_scsi_host:
 	if (hba->scsi_host_added)
 		scsi_remove_host(hba->host);
 out_disable:
