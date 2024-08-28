Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449DB1A4F35
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867109; cv=none; b=EoO38aSnnOj54vKFcK4xjIqX/iGeIrEWfUrquWWHPSBM9d5SsK1vAmTHCOI3VfpYNL0hWqiY+jp53hE755Zr8XMaXNh1WO8YEO7NeJ9BSbxvxbs39ElRYfWYoQdP8n7P8d6aLSR6aVWDetO4LBJjyDGYDWIw/gHNI2dFuX3qELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867109; c=relaxed/simple;
	bh=G1mh7doqNt0soSa5KXOLkj+Bb9aof6kYYeM0UYqp8AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp6RMrpnZbsFrhWrMkDXx2JB0BW/ap+ZThFKQVuCS9Aki7szXoPqw909+cFcaDL2+KNDT+EfBCRAdpERrlsruH92c+Zuqv/xQJ5QcVgFQhqWJrQ3S4MdFWHfgA4tsQ9MW1Stmr13qS44CTjkxO0OoxNVjtoK0WSNAodrbjJ3+aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1p6QOKN3; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1p6QOKN3"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdH4NXBzlgVnN;
	Wed, 28 Aug 2024 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867102; x=1727459103; bh=k66Gm
	c4RQgqClSPReQpW1JNIervQeYIltr84qndgRhs=; b=1p6QOKN3fjV9cL1DEyhtL
	sXxoUTMWPeBzQLjT9LOpcWn1kiSRzRtk62lKLZyitl85eE6/avxkR2PNcacBUW9R
	nBCfoqfv249FppwYc/JnVwp4jOOTMWP7u1rWUo9pSB6MjzOFxpdhgJM9+wU4fbUH
	l54VeqR/iMDNLB8ScioPkt2Rd/V6kllVDK3l/lYVp6sklc031JornLLXrm3BF6Z7
	Heh0kgOjdnee0Yn2kezAQu6nAK70nwSi1UTeG921z2BQVjJxKmKIiV9U0agm84ab
	KqxAIfe4M54gdqQELqn7mckpuEVne98o5ugXYLUfVFtZTfk1nwPyJ1IssYIqKU2R
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VrkPXHfLEba6; Wed, 28 Aug 2024 17:45:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBd96NWjzlgVXv;
	Wed, 28 Aug 2024 17:45:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Date: Wed, 28 Aug 2024 10:43:53 -0700
Message-ID: <20240828174435.2469498-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
In-Reply-To: <20240828174435.2469498-1-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e13b9ac145f6..70e9341a3043 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10375,6 +10375,56 @@ static const struct blk_mq_ops ufshcd_tmf_ops =3D=
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
@@ -10506,35 +10556,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
@@ -10592,9 +10616,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
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
