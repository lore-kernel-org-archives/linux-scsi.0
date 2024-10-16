Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541DA12E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109594; cv=none; b=IXvS6ZjUuyPMHVlqalS+LLk9yw7wFBJ/JiWh5+pEB56KmeTpXAcHcGY2RLvPK22LVa+/82c5Golrx54mIaFXC/yF3zuiQWTnIhmh7iyBEtrcsLf2qbJsi0iL/dnWlHmj/7UqHwfNBqgiYFFifRqR9hNbGwf2rHa9jKVrnhfWDbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109594; c=relaxed/simple;
	bh=bpMReAwJswMYvGeC7UoXFo4kmL9Jddce1tjz4YVsCEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxc9OyCvyky0Ma+Bb2dvzS9gTiyoI9cZWviaJ5H2yng7t5wX3S9R037s2YeW7lZEp9eMSd1gEjO/5ZljRcSddJgEGkid40caF8EVkejA6+8L4YCk0nhNCj/SpJM8VOuZMaYmkmWO39Y60n9WJIthKeBypjmrMF1RdcWFA2cb9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u3HiBNEM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u3HiBNEM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbX4qBJz6ClY9l;
	Wed, 16 Oct 2024 20:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109583; x=1731701584; bh=8B4U8
	k/O/uJHBPZe7ncHwFShjwIJYlJwBtC/aQZKr6Y=; b=u3HiBNEMRchziUDSeokZk
	3NL+fiPzcfVOKlHLto0jyrmaGVih8bAWZl2eZ8p/qbEr6zhUdVmSJFpAzSO9D9ko
	Xx0qJGdNelQHBEvtPXlH0HBReR9znOWlCRIfQR/OmLm7eZPd3htzT9MCUfnaytNt
	VC0Wu4nYHxuCIDWU8/jDmvHpQY4S4lRQOOCrCc+bdRyctSKONG724nfZOk9P1iTH
	7Sjcd6G8UjmWPlOQl/0/Uw/6kxsbQvduVIG5z7RthyglfbnQ1iw1YDl+osnnlVAG
	c1shf6MXD9oRoIf/wuh8uuc3UczAsRfRl30vqRbCRIPvpl+2L23EN/fUo8XqUYhw
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7aLnhjcA6_i2; Wed, 16 Oct 2024 20:13:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbK4D33z6Cnk9T;
	Wed, 16 Oct 2024 20:13:01 +0000 (UTC)
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
	Andrew Halaney <ahalaney@redhat.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 01/11] scsi: ufs: core: Introduce ufshcd_add_scsi_host()
Date: Wed, 16 Oct 2024 13:11:57 -0700
Message-ID: <20241016201249.2256266-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 96 ++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..959509d9445e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10377,6 +10377,62 @@ static const struct blk_mq_ops ufshcd_tmf_ops =3D=
 {
 	.queue_rq =3D ufshcd_queue_tmf,
 };
=20
+static int ufshcd_add_scsi_host(struct ufs_hba *hba)
+{
+	int err;
+
+	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev,
+				"%s: failed to initialize (legacy doorbell mode not supported)\n",
+				__func__);
+			return -EINVAL;
+		}
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
@@ -10508,41 +10564,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 		hba->is_irq_enabled =3D true;
 	}
=20
-	if (!is_mcq_supported(hba)) {
-		if (!hba->lsdb_sup) {
-			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not=
 supported)\n",
-				__func__);
-			err =3D -EINVAL;
-			goto out_disable;
-		}
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
