Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3110013C8E8
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867135; cv=none; b=fOkrIqNI6SQgsvSq+mh37wJyYgHKe3HL5P97+fES3Z6B2HPB19OvL5k5TwiHwvaCsJ+a23H0tOS9Na9fvwBdrs3k+GwSsjEY4NtvhNooePnGirLVjvyrIMMFM8Qv+LJLneA30GTtHRsYTXIl2mbgZbDIkYwmcQp4Gsy4a6Arc1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867135; c=relaxed/simple;
	bh=1bZiUcS/X8173YYKLyL0jH3AJGvic3rdPBj3iGDCpNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfuVYA7HuxLxeRb7HMUdmTy2fSXmCTl4GBvh1Q3UMvvCYlVzkcvKLXPXG7uXQkc70uKuIY/xiIbrAA+b7cQFTDBxBZCXT6q3BwSAanQbnPXr2GMCR6cdT7kXNBq+O1IR0wYYW81DAjjR4HQL6IQMdiv1o1DTqL19ettlHT1fQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VU5oa+MP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VU5oa+MP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdn6tmfzlgVXv;
	Wed, 28 Aug 2024 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867130; x=1727459131; bh=4cvGE
	mf3RrSXDGecNOPayhZQIy/Q3jCqp1ik6Ctdt6w=; b=VU5oa+MPLqvpHMsmUmIVJ
	pFBmBYaiwq9nSG6v+DcDIeZo6DxePabeV2szh8oHhGKWBkmiU51PzVGdL8qwTPC8
	kHzMpLjb+nvl7f2bLlxiuLDGEwFaNOXdzmc7nExc+IcM3OP6YxV6ifYE3m7hlzJK
	Q2Iud8DoYsyx4GN4BoH3yUqP/7132ksIeLA3EP697ZtkXHur/pK5HegEWTS8Bw/z
	2VvVQ90gX2qIAHvmlrzEn5X6WsnQJvhT5FFESAu8ZjxXr9lvVTP/hx+CC5cPzFV2
	89HsCrgmbv6lSrx8ymFFH9Ub01f6fHwh34c9xZ9/qtrF6QZeUN1TJtX8lB9WZfs7
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XM1yjve478Ib; Wed, 28 Aug 2024 17:45:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdj607JzlgTGW;
	Wed, 28 Aug 2024 17:45:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 7/9] ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Wed, 28 Aug 2024 10:43:59 -0700
Message-ID: <20240828174435.2469498-8-bvanassche@acm.org>
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

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false. This change prepares for combini=
ng
the two scsi_add_host() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 33e5dfd794a4..eb2cc1521b66 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10620,7 +10620,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	err =3D ufshcd_activate_link(hba);
+	if (err)
+		goto out_disable;
+
+	/* Verify device initialization by sending NOP OUT UPIU. */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization and waiting for completion. */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/*
+	 * Initialize UFS device parameters used by driver, these
+	 * parameters are associated with UFS descriptors.
+	 */
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
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
 	if (err)
 		goto out_disable;
=20
