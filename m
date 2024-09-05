Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B289B1B12CA
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573762; cv=none; b=sc4zQFOgp0sqvWOWQ0cAzLKCUl0HOhua7RC3rqzd+i2ND1gRpzRQxrD+YfYuPj6DFM+Hbbx9Aqm0c85ChlZw+nxo+Dh1mHlvPkI9KR+FRQUr6vABZx/fbp+OTF2HBAe9jNB1bjQGdd/GWiT2zlgpP8rtWZlAIgW/Iudzjd9+Jz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573762; c=relaxed/simple;
	bh=BE1uL7eMYfQ6UYMZI/SPaFGrlVEe4iLM4MAk78614Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej/6Ms44PG7NCe0tvRsGzvHJJ12iX8chCXzCkAs8Ju60br/kLx2bLkPoT3HlMeSx8680bTIFpU8ROY8GJBBbXEWm3ddOicnM6KfKgvDUccx6lyMKQxyPrs3x5LZUHmqz8v1Fcs5RkYstPWKayB+WWNtNv/whHn/ivuQTVEDNLX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NbngpEUQ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NbngpEUQ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cym1YXdz6ClY8x;
	Thu,  5 Sep 2024 22:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573755; x=1728165756; bh=xfMH2
	4IquzGoqShpch38Gy8uJsMsbw2Sq0NtFpwk2kY=; b=NbngpEUQTjy3IkEsYN0kG
	tgVOipvP5pcvqrpGIX5oW0lS9E6uKWUjUDZ7+BZRZFyt1sxsuPlB5MU9iK9sApgj
	YdSDyGJSt71H8ADq0dxHbwLKVuZV57yPA8cJAndMnMrd27lS39ZkAIbatPLKYocj
	DvkWaSYfDB8JTAruuD/HIFUlNK1BNeo0NW1dXHhx3HDVNNu/xw7XLQLpJc9YqWlx
	/VhIFJAI9Cjxe4NBxMW32Fm50y4MLuKWlj2zYxu/If/MUV9oRt9hV0tDNnrreoNH
	vQAdJcSQX7hUeWfz83Xu4cwuXetvVveGHCSxONPMZ1CfKB78JYjAbrmL9qq5RMGT
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A3K05IIMcLQ9; Thu,  5 Sep 2024 22:02:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cyf3dLLz6ClY8w;
	Thu,  5 Sep 2024 22:02:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 03/10] scsi: ufs: core: Introduce ufshcd_post_device_init()
Date: Thu,  5 Sep 2024 15:01:29 -0700
Message-ID: <20240905220214.738506-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for introducing a second caller by moving more code from
ufshcd_device_init() into a new function.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 63 ++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4cfa8dd5500a..916da4c054be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8731,6 +8731,41 @@ static int ufshcd_activate_link(struct ufs_hba *hb=
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
+	/*
+	 * Set the right value to bRefClkFreq before attempting to
+	 * switch to HS gears.
+	 */
+	if (hba->dev_ref_clk_freq !=3D REF_CLK_FREQ_INVAL)
+		ufshcd_set_dev_ref_clk(hba);
+	/* Gear up to HS gear. */
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
@@ -8789,33 +8824,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
