Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF2912E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109597; cv=none; b=hXUxEX+lJKugR33SB2NPpWQzKO6zzXWJovOItursjQrUnZW/wHhycb+i/feWvnbVzcO3lU4Lvf04CWTJLbxB8dFx/+DretW4a9wKiQOXG16a3q2NzWE4ht1qGehOHkQBNbZT84Rmhd5IIh2jOJHQ16AC/Jt+Q2DpARhdVwloWko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109597; c=relaxed/simple;
	bh=wXRP63UqwTiWOhTtBpP2JaKHGS6kVr2G7L9rhqX80Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUU1bHIp3xrDr1aDcO5tq+KIqTFfxXLC8PI10wUurQXnEyvympoSbGftUK0xi5mX7czZgQ3N8OYtemUMIUj+fr9sLWphGzm855eMeMDwaAMshxuFfA3N7KdEo1N8ldTOi7IOvYwr1yxv5Fco9loSEZXejmnWLSwHsal5S2pgY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fffyvqjk; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fffyvqjk"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbb5dM8z6ClY9l;
	Wed, 16 Oct 2024 20:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109589; x=1731701590; bh=pquFk
	9TI0O7CiEdHrqHuxbcIDkqw6Lygfnrgo1oOLCs=; b=fffyvqjkz1Rz59G7/e/al
	2kPe8w65GLHtYTMtG3Iu2JGwCBG0HMJGLk8s1Xjco9kuaweaXcjN31nJxqPvGg/x
	Ti0g73/gcXZ1NqIWIgovXaOEfQIOuxUHIuVHibZQ+pB+PQEqPqjqz0Cef6jRCocn
	V0UfQWTNhDxWcVw6scwCtFyvUgsxkbbpQUFMd7VUqK+0eC2IVHNNnx7CVJfN1o3F
	4io8gEpAH4r5TcWZr3suAOBa7VefgDVxNxO/4iHN6AazYtln/03jljaxRqUT3ctT
	Bn5NuHUBBuLAUDEMLsz/CnqcHJPUgFPVpNzPzCam7G/Cn1MvvPcmAL2Yst3f3wJp
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vHk8GNzeukTe; Wed, 16 Oct 2024 20:13:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbR5Xhgz6ClY9d;
	Wed, 16 Oct 2024 20:13:07 +0000 (UTC)
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
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 02/11] scsi: ufs: core: Introduce ufshcd_post_device_init()
Date: Wed, 16 Oct 2024 13:11:58 -0700
Message-ID: <20241016201249.2256266-3-bvanassche@acm.org>
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
index 959509d9445e..17c22e880cef 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8732,6 +8732,40 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
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
@@ -8801,33 +8835,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
