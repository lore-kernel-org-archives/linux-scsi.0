Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C053A933
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362630; cv=none; b=Ib1hzOYDulY0IYzgtvg/q3UsEXdPXszka+1infaUG6Cv0FrSM7GHopuDXELXVKJZQiZGT4zDFThuAqgUKqB7kiM9PUpGkKqkGNswvbNMNFZIZ9mgVjHT0sE9WZ6jkK4UjUsgnvrpo9FIGXydx/UN62i1aqJOiMi+k3Lrsd6eKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362630; c=relaxed/simple;
	bh=fwyu1hknNvAuljuuHR+27iLEm8RQ+sfqU90d539ygts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0AWgvJRVxXSbJ1iNziTTtedO32ZEgza0cV1AWdEk6ulSFGNluWd/W6GcVgM82hP4SMrKHPKWfhjYrRyaoMPfc8DmWi++GNAFEHKSXs+V63hZH6CtStdqGkJF8KBPa8fdNxHww1OmrCodq8FOYFEbgZJw8ExOxy2yiAUovwwGng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mt0OLA6c; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mt0OLA6c"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3m5hrrzlgVnK;
	Thu, 22 Aug 2024 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362624; x=1726954625; bh=KIbXD
	ef4LacrzposKu0PpYIjaZGGnm5G8d8NEvkCOw0=; b=Mt0OLA6cOgcxkgcLE+r1R
	YK951D0t7KpWoI+9v0GYe4LYhR/ZWZyOqMPDq2lU7qMRtPgQxzbE3ex/ruo3/RZr
	BXr30svXrOr73e/G4UyjLUkCThqaruD9hB2NIV//uIIuFGEOcmEBUq9Vxa5OL8Ha
	2PlLhXPnYH0qZ9PJT6wbuRjtYgOC42A5aWM10sjAs7x/bxBPB8jX/Br3RTU9TR8b
	f7vtCS1UnEI2pUuE91ns5qImj6idmE1cP0AbjrZgQepYm4Y1Hl555Skt2jPrZQRR
	qtVjg1C7Ena1NDn3qiWujGcT0xj90V/GThwLB4RAHYeWlSz6+/TB7wBcKBBpC2NY
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GDccsa3LI0AX; Thu, 22 Aug 2024 21:37:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3h0MFBzlgVnf;
	Thu, 22 Aug 2024 21:37:03 +0000 (UTC)
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
Subject: [PATCH v2 3/9] ufs: core: Introduce ufshcd_post_device_init()
Date: Thu, 22 Aug 2024 14:36:04 -0700
Message-ID: <20240822213645.1125016-4-bvanassche@acm.org>
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

Prepare for introducing a second caller by moving more code from
ufshcd_device_init() into a new function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 64 ++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 04d94bf5cc2d..dcc417d7e19c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8755,6 +8755,42 @@ static int ufshcd_activate_link(struct ufs_hba *hb=
a)
 	return 0;
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
+	/* Gear up to HS gear. */
+
+	/*
+	 * Set the right value to bRefClkFreq before attempting to
+	 * switch to HS gears.
+	 */
+	if (hba->dev_ref_clk_freq !=3D REF_CLK_FREQ_INVAL)
+		ufshcd_set_dev_ref_clk(hba);
+	ret =3D ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: Failed setting power mode, err =3D %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 {
 	struct Scsi_Host *host =3D hba->host;
@@ -8813,33 +8849,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
