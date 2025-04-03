Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956474059
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715382; cv=none; b=cpbXxk5wbC0V6KelRZ9/AdvG5OC7xU6+Mzr8E4AjaoC63wFV9iK7RHoEj1FGlfrTqUeH7Mte0gn9fsHJPm//rqAd8tUDT9O5Ix4n8lnfDAN3K0b7UwZz0LJQNmwlqSg01r18uAiZmTNPDg9sl6UkzenCLfCLc4cJxP+2bySqIq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715382; c=relaxed/simple;
	bh=zu1FvnR6P5ZBJyFJPzfgmfkfWXANFxP/BWxNUS7G6NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZa5sCXmNS3xLbl8W3+B4TYdTP0KapL4b5YJeNUGvsDMHApvFmQ9xlwPecSDNtr8UaZab3e7yPLg00siHDlEmxjBdRYzufqn2ycmQvAQ/w70Fx65XOjzwiYa/oy8jZgwPDyWdBMyAPmaO7yDiCn2mUG5ZSaMKUiz4+/UtMhX6+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z0wbx5Gd; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z0wbx5Gd"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF8375mSzm0yVW;
	Thu,  3 Apr 2025 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715378; x=1746307379; bh=IwQBF
	xg8Ao9Pa5XLYay7x8+pfNsCjzqqbX/beR6cU0g=; b=z0wbx5GdkT99mbBMYtV9e
	AyYNbOyA09x9LH9npyJFA/DfZ5pZ++Mhlq644+tDvpH7rrowxgFwfgcYw/gsubsl
	FTaqnZQRrfQ613Rp6pwRpEJj+x+2a4KuR+yfYcEKN0E63R548tVTXtKSqWZJwGqn
	2HKT8NTN/bou0650TC+x/eSRIqObgO7Atsfq3Sf777OenlOwEsuj7U6x2vAdF6Qd
	kJijXHsEWM92uGhWro/c7Pks3YvJnsZtSQ2DJh/TPtQoZ0MBmT/I66QPjV9Hbigt
	IylKjVJcfZY13dv38UD7x9lTurseuGS1g2aedOT92QNPwaJaB9liDF1cT9yPQ6rC
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N5bsGMBKEoVg; Thu,  3 Apr 2025 21:22:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF7w166Fzm0yQB;
	Thu,  3 Apr 2025 21:22:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 18/24] scsi: ufs: core: Allocate the SCSI host earlier
Date: Thu,  3 Apr 2025 14:18:02 -0700
Message-ID: <20250403211937.2225615-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() before any UPIU commands are sent to the UFS
device. This patch prepares for letting ufshcd_add_scsi_host() allocate
memory for both SCSI and UPIU commands.

Initially, allocate 32 commands (SCSI + reserved). In ufshcd_alloc_mcq(),
increase the SCSI host queue depth if necessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6dcac4143f4f..7cbc7a3cf2db 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8941,6 +8941,32 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
 	ktime_t probe_start;
 	int ret;
=20
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		ret =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
+		if (ret =3D=3D 0) {
+			pr_info("%s: hba->nutrs =3D %d\n", __func__, hba->nutrs);
+			ufshcd_config_mcq(hba);
+			ret =3D scsi_host_update_can_queue(
+				hba->host, hba->nutrs - UFSHCD_NUM_RESERVED);
+			if (ret)
+				goto out;
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				ret);
+		}
+	}
+	if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
+		dev_err(hba->dev,
+			"%s: failed to initialize (legacy doorbell mode not supported)\n",
+			__func__);
+		ret =3D -EINVAL;
+		goto out;
+	}
+
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
 	probe_start =3D ktime_get();
@@ -10427,9 +10453,12 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
 {
 	int err;
=20
+	WARN_ON_ONCE(!hba->host->can_queue);
+	WARN_ON_ONCE(!hba->host->cmd_per_lun);
+
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
+		err =3D ufshcd_alloc_mcq(hba, 32);
 		if (!err) {
 			ufshcd_config_mcq(hba);
 		} else {
@@ -10667,6 +10696,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
=20
@@ -10717,10 +10750,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20
