Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36111A08CB
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005180; cv=none; b=ll1mHnrqosk1J0j838t+TlcYzbscfQsp59k5FFJYhg6iT0l7z9mRVTZzsMabd9JlKxi2wPYVK2AJJ6vzWhHCYvcf0vKTMZMMaSshiBYLYkXhbDBwPa4ulCgQ6stROIHYdsV4ThhmLnSO2Aw8QNRvkq6pIlYeUIi/u4tw1AHEmeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005180; c=relaxed/simple;
	bh=U/LhdQpxx1mptXdBPrKsngT2ltMETUJSab0NbNuN45E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O268KC8WRUotZUu6L8JITWDlpt8bUcBf/XTfz1QMmmpHXWBV0Ifxohz27AHYKWO8SJGZ8BOFYELBOsyLVVaWJs11A8bow3x4vg7aIGayuJ8P2B6goHoUR3sYoyqS3/zfrBaJ8yAIy/cs8757HiuJJkLsPgVXZwd9hingk2lw6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h7lqTVF3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h7lqTVF3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HWG5Fj3z6ClY9L;
	Tue, 10 Sep 2024 21:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005174; x=1728597175; bh=jvN9a
	7cN3llulZP15wCbi++ckwNhSMDxvsqgeNC6wM8=; b=h7lqTVF3LJcjeDoxdo0HJ
	ANi3HqAoh8fAoTao4YHnDM3qecmjCXEe1AH+9TFqWUORWAgtDUVvXH+Km45gB360
	kPItomPwy6eUOqYxiJfsP/8WFnDc6CZpZxLFAykmHT26WBYr6FzFL1+JqTf33i80
	N0e73g+tRS9sivekfFj5D3wrleZT6/CoWlDgGUBVgu1CjJCHrwOJCCxeAiEjf1Vu
	SuyTLHUwnr6SNwfwPFE6gvARhtU+AyMClNvwd8vJnja37Nj2X8qZSOBDqH+WhzTn
	Kezln6qx7lYFEDkWy8hZuL01Yqp/bf3eRRHtIdq1EeXYwcIAIM8oD342czvZ/mVv
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F8uCWi7qktvU; Tue, 10 Sep 2024 21:52:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HW76GQ7z6ClY9J;
	Tue, 10 Sep 2024 21:52:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 07/10] scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Tue, 10 Sep 2024 14:50:55 -0700
Message-ID: <20240910215139.3352387-8-bvanassche@acm.org>
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

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false. This change prepares for combini=
ng
the two scsi_add_host() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 55 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a3c5493ccc8f..efa9c177a80f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10608,7 +10608,60 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
=20
 	/* Initialize hba, detect and initialize UFS device */
 	hba->device_init_start =3D ktime_get();
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+
+	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
+
+	err =3D ufshcd_link_startup(hba);
+	if (err)
+		goto out_disable;
+
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto initialized;
+
+	/* Debug counters initialization */
+	ufshcd_clear_dbg_ufs_stats(hba);
+
+	/* UniPro link is active now */
+	ufshcd_set_link_active(hba);
+
+	/* Verify device initialization by sending NOP OUT UPIU */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization, and waiting until completion */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
+
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		err =3D ufshcd_alloc_mcq(hba);
+		if (!err) {
+			ufshcd_config_mcq(hba);
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				err);
+		}
+		err =3D scsi_add_host(host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			goto out_disable;
+		}
+		hba->scsi_host_added =3D true;
+	}
+
+	err =3D ufshcd_post_device_init(hba);
+
+initialized:
+	ufshcd_process_device_init_result(hba, hba->device_init_start, err);
 	if (err)
 		goto out_disable;
=20
