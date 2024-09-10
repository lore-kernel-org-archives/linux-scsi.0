Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26231AB50A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005165; cv=none; b=c9VI/Zrad2vsgxw1qE3A1+fHmGAjIeX9+2vjI0syQI31FGt3cgsOp4osanFy9c3Aiw2RAvijswa/W7mpu/r4HXi+TSnCko/cW7M/6Cns3i5NPnI4bt9rwrgz+UzeiUb4GjpYK7SH1jMCcbDJ80yvWILMLu9vDc31Dp6I/2SgPys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005165; c=relaxed/simple;
	bh=eGViY3dYjO44fa9t6+teZD4Z5CreYMBn2BTH4wv8HxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYuK/b0CAzq0HV8GsixLlDyaIMdfWj86MnQk9d9aQc2iNc5XqqDnYha9rarExtW0g0RSsbpD60dvZz18RzEg9e7wWAwH2PVTp65Of74SYfOevWvHIX17SdzjrkkkAEzVUcT4e7/Wq6Q8q4l7Yf0m2q5koIFY9mmnp1bFjG8GKOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4BhhwosC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4BhhwosC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVz3zcjz6ClY9J;
	Tue, 10 Sep 2024 21:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005157; x=1728597158; bh=ypulb
	DRngynoqRqHIs0BdjJ63VAn26a6AKKaNCb/99M=; b=4BhhwosCuE4deDiaVsXh6
	I25BEDEZpZiJxJx1jKdYZsNGUL9B1iGFvSmtlEsLZNH4B7PV3mve8wFOOsX2xI0Q
	SS7mnJAhruyNAsBC7uLBKMStPDf9hXDnOAPUrez+aXz4ZO2mKIBNCDlhu9enMRPM
	2rXKZFfWMxEx31Dccnxh37Xe5g3sbqq/vK7cd/ER2XwlVXGtGULUAhP2AAk/to6R
	ViURiiHivU23ZuyZAMZ7Ln0u9AtjtAtozEj3jo6tCOA+2oj5EdbPdoZBQGMP5PDA
	1uuJTIsGzGwuit+qT2L+wv6bjfgJrdLVoOeYSRlxUZWMzMW51ARCZvNDYfkzxTTV
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5URS0F-BSpQF; Tue, 10 Sep 2024 21:52:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVq14ymz6ClY9H;
	Tue, 10 Sep 2024 21:52:34 +0000 (UTC)
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
Subject: [PATCH v5 05/10] scsi: ufs: core: Move the ufshcd_device_init() call
Date: Tue, 10 Sep 2024 14:50:53 -0700
Message-ID: <20240910215139.3352387-6-bvanassche@acm.org>
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

Move the ufshcd_device_init() and ufshcd_process_device_init_result() cal=
ls
to the ufshcd_probe_hba() callers. This change refactors the code without
modifying the behavior of the UFSHCI driver. This change prepares for
moving one ufshcd_device_init() call into ufshcd_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1094c1ba2212..f62d257a92da 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -298,6 +298,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *h=
ba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)=
;
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -7716,8 +7717,14 @@ static int ufshcd_host_reset_and_restore(struct uf=
s_hba *hba)
 	err =3D ufshcd_hba_enable(hba);
=20
 	/* Establish the link again and restore the device */
-	if (!err)
-		err =3D ufshcd_probe_hba(hba, false);
+	if (!err) {
+		ktime_t device_init_start =3D ktime_get();
+
+		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		if (!err)
+			err =3D ufshcd_probe_hba(hba, false);
+		ufshcd_process_device_init_result(hba, device_init_start, err);
+	}
=20
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -8849,13 +8856,8 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
  */
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
-	ktime_t start =3D ktime_get();
 	int ret;
=20
-	ret =3D ufshcd_device_init(hba, init_dev_params);
-	if (ret)
-		goto out;
-
 	if (!hba->pm_op_in_progress &&
 	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
@@ -8868,13 +8870,13 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, =
bool init_dev_params)
 			dev_err(hba->dev, "Host controller enable failed\n");
 			ufshcd_print_evt_hist(hba);
 			ufshcd_print_host_state(hba);
-			goto out;
+			return ret;
 		}
=20
 		/* Reinit the device */
 		ret =3D ufshcd_device_init(hba, init_dev_params);
 		if (ret)
-			goto out;
+			return ret;
 	}
=20
 	ufshcd_print_pwr_info(hba);
@@ -8894,9 +8896,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		ufshcd_write_ee_control(hba);
 	ufshcd_configure_auto_hibern8(hba);
=20
-out:
-	ufshcd_process_device_init_result(hba, start, ret);
-	return ret;
+	return 0;
 }
=20
 /**
@@ -8907,11 +8907,16 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, =
bool init_dev_params)
 static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba =3D (struct ufs_hba *)data;
+	ktime_t device_init_start;
 	int ret;
=20
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
-	ret =3D ufshcd_probe_hba(hba, true);
+	device_init_start =3D ktime_get();
+	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (ret =3D=3D 0)
+		ret =3D ufshcd_probe_hba(hba, true);
+	ufshcd_process_device_init_result(hba, device_init_start, ret);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
