Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED61A08CB
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005141; cv=none; b=Q7k8wEyd/47oLX/6zWpFNkod9mCrlIbxP/YUhsTNmi2y+sdkoLAtuaD1xD4BIBeE5jraQEAU4G71aoNMsj+90FJBuRHM5U52IvcuqWqobKfFgOdfu3SDOJ4DabwnLAnusNrJMLJQAr294/4ESM8OM2Z4g69bgHMlizrJXcZFdEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005141; c=relaxed/simple;
	bh=yocigBvgwUu3P0zecHtqv0kfecFnMXDWk64JbFoWS3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unoLSLUP0wBiKc5nkVzBq2LGqeAuqDAS7hR7oW26q8e7/0NRUrReUalyMe0DpN44/WkbKJhyUpCtzcwiVLdbPn0n3Jh6JKCzoJQ89ceb+SDVP6FHccgk2dnXqNEe+3wrYgSJABD72rw0vXnCnRcxMu33epnLSo9bHkxtP3Zjzb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pihovyif; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pihovyif"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVT6rxgz6ClY9K;
	Tue, 10 Sep 2024 21:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005131; x=1728597132; bh=3V5Cu
	9qDL8YOhVGr78U8Zr03SbPYsHSx1T1VdK5/T7Q=; b=PihovyifKy6Y8Qx0GNR0m
	Gjw+isxqnMZrTwQhRAjFoM/ocC2yfilvuGWhFT5Hb7avjVK90FEKZogT95dI9hCg
	QwiAIwvXRNYAM2Z0WpqTJD8dxhQpL/mR5ZubhBfCIhSNf1o2JhtaY6Qal9fz5i6T
	Zy6SjCL6hUv0QLrjerz/1tsAX5HQPn8FmaEITYqvCOjc7nZfMlT/rSaytpm7uDwE
	fXxtrFogPIT5ij2ZSdEwrV2l3VunidfJ+Mo+PFXBQSg2+ZgsG1N7CPn7SQPKry2I
	1bHre5sLsQN4y0L7TQNr3tiNZvnbsAob479HQO99ajtCH9IGCab90XOTmk1vcyef
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id COjkeRq2gV8c; Tue, 10 Sep 2024 21:52:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVJ73kfz6ClY9H;
	Tue, 10 Sep 2024 21:52:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v5 01/10] scsi: ufs: core: Introduce ufshcd_add_scsi_host()
Date: Tue, 10 Sep 2024 14:50:49 -0700
Message-ID: <20240910215139.3352387-2-bvanassche@acm.org>
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

Move the code for adding a SCSI host and also the code for managing
TMF tags from ufshcd_init() into a new function called
ufshcd_add_scsi_host(). This patch prepares for combining the two
scsi_add_host() calls into a single call. No functionality has been
changed.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..ecf6da2efed1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10357,6 +10357,56 @@ static const struct blk_mq_ops ufshcd_tmf_ops =3D=
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
@@ -10488,35 +10538,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10574,9 +10598,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
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
