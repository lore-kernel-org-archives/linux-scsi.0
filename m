Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2A1A08CB
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005145; cv=none; b=BX0THeKoptPgz5nvhB1qQdSn3W0txVK7+mTr2EcL+NSQpZL/pFTSKykgkTXElvywYUGcVM/kxgkK7s8SxIepzIsiuzH7JMp93D0ktJ9Z882aH1C9pTytSTAVZC0YD3js4A3QTf5hOij6gKJF7XIqxTh1pduy4SSeV85vNV6VELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005145; c=relaxed/simple;
	bh=01GpisYQQyfFxOYH3nSPjJZnCG5wvkM75ADlW42Ar7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTc1HLYq4L2prZPheKLmzSstBOZdK0ZlQeQdfeBt1H+tIFzXOdV2Oxxdr99ZxlB1cu8Z3LD4c33fFk/XAWSb3/7vRHD0ocxfyRc4UDNNEqUTd1RXrjkmtYZTbz4x3joo6O8pUEMIbAl1CsnohTRS8F46z01ftzMd/q80Aq1glx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D/dpSfxD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D/dpSfxD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVc05jJz6ClY9K;
	Tue, 10 Sep 2024 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005138; x=1728597139; bh=5sjXm
	ZRA9guOoc2FHLvHcUpvKIetH6Ut3NOdHuwzsAY=; b=D/dpSfxDZiETx4weeRa2T
	U9B1/eY7yYR1/DVsFaHeZkamj6KWyXl2IWB6rq2sMcOffKAFQq3KGxBHHYwE7CAn
	CaK1Qh2YKRn3RVzRDSGe6xNy4Xwk0Xits6IGmW8hYIh3OjKC3/Z92TU81jQ0+0GJ
	V0ZpXdLHba8bw2IVs/rhrIQXxygc2Okg6ed+3Ny1tJ4YaJ1s+MpEypAVoMkCRhVZ
	VIHiBK5Z7uEXzJkMOhXtapEmmt/CvpAT9i5Hkip+bNJTfyQCbuvxpgOgdIfbID+f
	ZPWq4dEUWGCu1M+i+azp6ZPXSFn7FXY/uk8IzJGXBuOuSpXYYPgx9RoWq1grkDGN
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ApAFcYGjixW6; Tue, 10 Sep 2024 21:52:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVR5Lwbz6ClY9J;
	Tue, 10 Sep 2024 21:52:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 02/10] scsi: ufs: core: Introduce ufshcd_post_device_init()
Date: Tue, 10 Sep 2024 14:50:50 -0700
Message-ID: <20240910215139.3352387-3-bvanassche@acm.org>
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

Prepare for inlining one ufshcd_device_init() call by introducing the new
function ufshcd_post_device_init(). No functionality has been changed.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ecf6da2efed1..0ca20f069cbd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8709,6 +8709,40 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 		 hba->nutrs);
 }
=20
+static int ufshcd_post_device_init(struct ufs_hba *hba)
+{
+	int ret;
+
+	ufshcd_tune_unipro_params(hba);
+
+	/* UFS device is also active now */
+	ufshcd_set_ufs_dev_active(hba);
+	ufshcd_force_reset_auto_bkops(hba);
+
+	ufshcd_set_timestamp_attr(hba);
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
+	if (!hba->max_pwr_info.is_valid)
+		return 0;
+
+	/*
+	 * Set the right value to bRefClkFreq before attempting to
+	 * switch to HS gears.
+	 */
+	if (hba->dev_ref_clk_freq !=3D REF_CLK_FREQ_INVAL)
+		ufshcd_set_dev_ref_clk(hba);
+	/* Gear up to HS gear. */
+	ret =3D ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed setting power mode, err =3D %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 {
 	int ret;
@@ -8778,33 +8812,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 		}
 	}
=20
-	ufshcd_tune_unipro_params(hba);
-
-	/* UFS device is also active now */
-	ufshcd_set_ufs_dev_active(hba);
-	ufshcd_force_reset_auto_bkops(hba);
-
-	ufshcd_set_timestamp_attr(hba);
-	schedule_delayed_work(&hba->ufs_rtc_update_work,
-			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
-
-	/* Gear up to HS gear if supported */
-	if (hba->max_pwr_info.is_valid) {
-		/*
-		 * Set the right value to bRefClkFreq before attempting to
-		 * switch to HS gears.
-		 */
-		if (hba->dev_ref_clk_freq !=3D REF_CLK_FREQ_INVAL)
-			ufshcd_set_dev_ref_clk(hba);
-		ret =3D ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
-		if (ret) {
-			dev_err(hba->dev, "%s: Failed setting power mode, err =3D %d\n",
-					__func__, ret);
-			return ret;
-		}
-	}
-
-	return 0;
+	return ufshcd_post_device_init(hba);
 }
=20
 /**
