Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0014C1591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107893; cv=none; b=KBWBTtz7xYaU/tH/LW743kHh4Y4Cw9dCfkPLGmLBGVvUSGE0Bk8rwvDutKFFxb1DpB7icT/S7REf9fgWAQ2siEFI5hfviTMPsLVqlA+ckYgc75qcAKK0VEXZ8VgGpYxE2Qdq2OeZURtUBuqgF5GRkEYSEboowVFYFI45VrRM8FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107893; c=relaxed/simple;
	bh=nTypzgEjksi3jcwKnR0tyfT3fWHf6lw6I3DfZjucD0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8wGDvPMDdzqLlyb/KaZsjS5VW40a+jaaz5YRd9uQOWkLXk7AI9kyE8nvhNJX7q03gMEJ6sW2K8MMeXgpO26/MPfIi8Bx+SmwJhJAePQsKnjdGEC+ZT5fdy+bXvrRBwSFMlaCSJ5l4q4V1MfE/4WRf2+KE2SLF9waht7FptrQlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RdYhIFG3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RdYhIFG3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnnrz2FQ9z6ClY8s;
	Mon, 19 Aug 2024 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107885; x=1726699886; bh=u2/WG
	8iVe04Ig/1vNTkhyEqdtFiTGRq9qrsGuIQaj9c=; b=RdYhIFG3sRPFSp695H5qZ
	sl7k2g8pdMaAiyJ9AnMtxVT1YYJ+P3lT3LTgM9riv9TbbSjwbpuEWee0hIqUq1kP
	i4T47i1lIUjF3bctkn3bt9HkBPxmQksZY4cLETuAibDwXL6Iyp4103uITkvviuGg
	wzVKgTwTu67sQLnmjSSxq9ChzJPZ0y8kqTVM+Hm3CG0dRaDidSwSoTvzCUCf+m/R
	QotOom+jaPquQFMbpuL9XeRWwM/7AIo6EXVLMLiGigjJ3+ZZ4Ura5kPAi5Fx0snb
	q+sN3ei8qhtUZdY56nXyk1pcuv1kQfnxW79I/niV8LGkog+ld8kbTyMTgUz/ztWn
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0QmHnZrd00iO; Mon, 19 Aug 2024 22:51:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnnrr4Mjtz6Cnk9X;
	Mon, 19 Aug 2024 22:51:24 +0000 (UTC)
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
Subject: [PATCH 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Date: Mon, 19 Aug 2024 15:50:18 -0700
Message-ID: <20240819225102.2437307-2-bvanassche@acm.org>
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
