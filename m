Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F1B1A706A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867118; cv=none; b=UU8gFys4fPugBxogI/o4uUvJigGlIsmZYFG4Q8yKo5EKHey1/sfqs8/+ovxOvqScXGnREt2HxtC70lQWNFvHMG0DzIL4pF+dV1snJhuptTrvcZyxsxyCLSdpE/UmvyB9++/3i7w2XmoJ2BErnVfsdUbqEaFpnBNks74GeUx1uiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867118; c=relaxed/simple;
	bh=/KE/k6Cb5aqLg5P914tYx4I/lFhdr9sTzFwP3gzEpko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1/Vk8ZrQjy3Py8gyFmYzXDi2hDzKXkNfdChYgIYL/te60zo4+HzAwNQ30z6jg0lJZ8UJe02eceT6kBCUCpvrZCWRP6lON4EVm+u7QqZb47xpjbHKWt1im8EEapTVX+PMR+bMVBw4KhTJj12BbJzRE0oaKW77KytJ2IcdxLKJiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZNkrHsSD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZNkrHsSD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdS040wzlgVnN;
	Wed, 28 Aug 2024 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867112; x=1727459113; bh=G+h1K
	XEQtdvCm9wSoYEiSGFSlKUcWGTrENP64ws5SPM=; b=ZNkrHsSDhJlRfDBpKLVGo
	QwnfLpvGdNzkMA+qz+rOYgnlzM9QkHjU/iel8bmvpoB8p113rYooghRXQ6a42z7Q
	TcR8ioU3cTIkScHCY6fjgWWPDayP5qVKJ1tVotfWQXNcYV6+WV3lRcMoKV4YrsiZ
	/hwPc20inPErpB5WqSj+VbiFBpwqt/DlHVPZ8OGGj5sSRWbOHOvHnzws6mIN2PTW
	DzNlLKv8BxSJuIlA1n2w6N6NmlyVrRhJErYe650tGP/n6aHUuM7jNV0V59ul9khB
	JQoV+uR+7QS8qkNXvtI7v7gUNr7gf/Ywi8tJ1WF1OXx4g8bo7AB+y9XMSmMJ2eGZ
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0sSoMX44JHvD; Wed, 28 Aug 2024 17:45:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdM1mryzlgTGW;
	Wed, 28 Aug 2024 17:45:11 +0000 (UTC)
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
Subject: [PATCH v3 3/9] ufs: core: Introduce ufshcd_post_device_init()
Date: Wed, 28 Aug 2024 10:43:55 -0700
Message-ID: <20240828174435.2469498-4-bvanassche@acm.org>
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

Prepare for introducing a second caller by moving more code from
ufshcd_device_init() into a new function.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 63 ++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6dbc01b47ff6..1b69b370991d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8749,6 +8749,41 @@ static int ufshcd_activate_link(struct ufs_hba *hb=
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
@@ -8807,33 +8842,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
