Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458561591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107912; cv=none; b=GQonN9SUYcdsjm8kG7l+QnQqdcDlLJbvFvqIylpZzrpIn+IcbQWjFmSFHeyDajiJF/RRJ7EtnPUasqcGhDgyYWJKGlnWa46jCsKIABmOaew9Gp4ptOj+K30vxodZZ3e40mZ9RpXLvd2OrI+X0JxyVAK3zGXbt9GuKm3ChLOlWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107912; c=relaxed/simple;
	bh=S+Zf4jtaP0LCQgOMoD6AvCADQT3bjnDNxZXg6DY+OfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5azwlMTsFMD4VBvMdW6vSDKkPxFEPMeNIpKa8JaxVkAKGZnfUYPzxvmjQCHdlYTj9c91AGLolFSD18qdrUJVvyR99B/ALo9Yiy2q3z30TN5XFjb5b7f7XfpfWWNZnpNa+fHsANR3xC82+efLDrmIdoXcCHK/oI4rVkoU4B5fxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bXkAxzYU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bXkAxzYU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnnsL5HPmz6ClY8q;
	Mon, 19 Aug 2024 22:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107905; x=1726699906; bh=820TQ
	LE+LKsy+aLlUV/sxa17laJsfWAU3hQj+0uNu44=; b=bXkAxzYUS9tSNL6mE/oQE
	KrOaL+IlqjfPoirkaSTRib8pCuIaog8tmP33yHNoBcm3zGrO2OJEoMYV2OPnQoa3
	mwAT/ekIhAnsHigLCKs5dyBh+ja6wM1UfZcpwOOJt3q4x3LJPbmQH4XmSSpEb9ZC
	32Lt0iB592PQLSOU/GQK0XugWJ0jGNy6pStmg4Xjg+T2UKvSv4hskQlSN6JuvJlA
	ok8IPhCvQVDq050Vo40q4moRyIUMzebtpQ1rW80CgDpddhRIs0kNlw42jeXCTyrr
	1CWG2J7hUA8r5iMHKqqAjIwp3AcW1IDR28YyHXWNcOyDV7LF4ioeAtTKapTtbmYW
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IwjPU3cuPkO0; Mon, 19 Aug 2024 22:51:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnnsD39NWz6ClY8r;
	Mon, 19 Aug 2024 22:51:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 5/9] ufs: core: Move the ufshcd_device_init() call
Date: Mon, 19 Aug 2024 15:50:22 -0700
Message-ID: <20240819225102.2437307-6-bvanassche@acm.org>
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

Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
remove the 'init_dev_params' argument of ufshcd_probe_hba().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 502d0f5a95c0..86deea546b44 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -298,7 +298,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *h=
ba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
+static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)=
;
+static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
@@ -7717,8 +7718,11 @@ static int ufshcd_host_reset_and_restore(struct uf=
s_hba *hba)
 	err =3D ufshcd_hba_enable(hba);
=20
 	/* Establish the link again and restore the device */
-	if (!err)
-		err =3D ufshcd_probe_hba(hba, false);
+	if (!err) {
+		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		if (!err)
+			err =3D ufshcd_probe_hba(hba);
+	}
=20
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -8853,22 +8857,17 @@ static int ufshcd_device_init(struct ufs_hba *hba=
, bool init_dev_params)
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize it
  * @hba: per-adapter instance
- * @init_dev_params: whether or not to call ufshcd_device_params_init().
  *
  * Execute link-startup and verify device initialization
  *
  * Return: 0 upon success; < 0 upon failure.
  */
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
+static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
 	ktime_t start =3D ktime_get();
 	unsigned long flags;
 	int ret;
=20
-	ret =3D ufshcd_device_init(hba, init_dev_params);
-	if (ret)
-		goto out;
-
 	if (!hba->pm_op_in_progress &&
 	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
@@ -8885,7 +8884,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, init_dev_params);
+		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
 		if (ret)
 			goto out;
 	}
@@ -8933,7 +8932,9 @@ static void ufshcd_async_scan(void *data, async_coo=
kie_t cookie)
=20
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
-	ret =3D ufshcd_probe_hba(hba, true);
+	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (ret =3D=3D 0)
+		ret =3D ufshcd_probe_hba(hba);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
