Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA451591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107902; cv=none; b=qkDOeKY2U+GcbGCiMwI8Wjq9uAlfjdCOcMEJtuTNguD5yVz8ZtVdET4KdtfI+Q1Y5tL7BWOQTJv1HXWdMQ8IeZIcC282aSrMnsFfv4tJe+ro+coa3xgq7PpMKWLxorfjGBBq/dGZ8ipq+SLBx93Boup4fFHlYRYGvTnRJRpCxiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107902; c=relaxed/simple;
	bh=Q07rvdW44L6LorH8aE2KjkOCg/r6W5HowZAFG5nMs1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEsI4DZdM57Jp7rXR1NVqJzbSQ+1r3I6dDbxOy1Fm0br9irvX888wpKKLi5vUShUuFPkEEXmp7HrR87WaQwzQmzjc7uChSqi3l7EJsQ8bo5zAHME49bx7m1+6/K3NIZBVEVnhgIv3xZEOz5RlCEGVLQVX6AcDdsllB7J8YzYklU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=j4O+TPix; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="j4O+TPix"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnns819Lyz6ClY8w;
	Mon, 19 Aug 2024 22:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107895; x=1726699896; bh=mx77B
	b5LfMc+BogO7LDupc79kW0Hh/qGo0zGGVHVuDk=; b=j4O+TPixM0vZgr007MloP
	r82AJJ+AMkFt/R4D5l9vYhZTzopIjZEM7Kyhd0my6C/hOtKeHP7gRr0xaLX9dLLr
	tFkc5ET7dCKoTPzEx/29MS9MtmvmkhINuaYrvy7Pz8rBDKI3Rqvl3mcBD5Or1+QL
	GqeYUFWudxaDIOOQN7PfeDfEHChQSCHYCQLuJUBrGQuVzt+YzRvP8uB4tW4Q7aQs
	D+sqWiF3RVl/TAPEe40MqiU97LJHH6eK9RFX7xdmmBJSMkOWOzDASE+1NPWRvvkI
	1XC5JCbW4CAT4lCIqO1D2mKWEK+/OwP57dYIPcDdzU740kxqNBsW4ZZyvpKArpG6
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7gG35OGhV42D; Mon, 19 Aug 2024 22:51:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnns23pBBz6ClY8r;
	Mon, 19 Aug 2024 22:51:34 +0000 (UTC)
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
Subject: [PATCH 3/9] ufs: core: Introduce ufshcd_post_device_init()
Date: Mon, 19 Aug 2024 15:50:20 -0700
Message-ID: <20240819225102.2437307-4-bvanassche@acm.org>
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

Prepare for introducing a second caller by moving more code from
ufshcd_device_init() into a new function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 04d94bf5cc2d..9e64b08eaa5e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8755,6 +8755,40 @@ static int ufshcd_activate_link(struct ufs_hba *hb=
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
+	/* Gear up to HS gear if supported */
+	if (hba->max_pwr_info.is_valid) {
+		/*
+		 * Set the right value to bRefClkFreq before attempting to
+		 * switch to HS gears.
+		 */
+		if (hba->dev_ref_clk_freq !=3D REF_CLK_FREQ_INVAL)
+			ufshcd_set_dev_ref_clk(hba);
+		ret =3D ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+		if (ret) {
+			dev_err(hba->dev,
+				"%s: Failed setting power mode, err =3D %d\n",
+				__func__, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 {
 	struct Scsi_Host *host =3D hba->host;
@@ -8813,33 +8847,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
