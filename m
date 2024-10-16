Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969F1C2324
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109620; cv=none; b=XphDXbP+2qwdz/yqe/Z+M4+pXCzJKsjND0qHUHelxjwnqdzGiwSrwdTJice0mL+jV7RiQXfRFH5DyHvNGqTf8EVMWcMczzwQXz39hMuk56h/CDZyDTvSV/Gbey+8H2gXs27nNVyQPrCtEIjrppzc8FMw0/RoEArvfU+35U++jHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109620; c=relaxed/simple;
	bh=EV1mThDHg3lhvc0UfT4b8qrlwqYJEfT2XkdhZoOSfl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntxqSbS42lpQcM8y4j7sWhncoR1/dzqag0PooZQwtC1ZkmbeImzKZ/n7Yn99XAyNna1Vd6JtZAvTaD9R6o0/GEnI0YWG+fh0qt6evrUkag5B4gRwRRHnVpDd2u7ygjmHMl6aq/xv6ONsI/pFPc+NpmJOz+1UOGtX+mAB/W1VJaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jQwfQx5p; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jQwfQx5p"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMc26cSZz6ClY9l;
	Wed, 16 Oct 2024 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109612; x=1731701613; bh=zKOcL
	UillfXPGor6+AekdXVkp0FA9d5rnrgS1sSO1vI=; b=jQwfQx5pa6LcKq1uY/bbF
	VQjEwFP7cRfuQcydNOeEsPARpKSZKP59m9YJ03exXrP+++Y/yNhet++7ptEg+oql
	AFEPuRYvwB6uWfhA8PYqoyLQWpH3gDEIIGGLJqDMVoVhF22M+7E3uez2YVaiPtbQ
	0bB+XP8uG991VadM9MMqKd2PKAJghsA1Pre9il64vEjV22xJNX6jWyDGKpBCp5rn
	sl+u2iINeKl9gGEAqmBnrNz1uGQdT0n+wmTYHBSh2GGTWBa+9tw1nvBElOEWTQ/c
	3vynV2fSFF+xDFGwo3W+ae5LBhCVyQnQjJWog+HUjAhVHZsjagMCE5lY6U9u36dh
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Oof8NVUeSQyw; Wed, 16 Oct 2024 20:13:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbv2fhyz6Cnk9T;
	Wed, 16 Oct 2024 20:13:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 06/11] scsi: ufs: core: Move the ufshcd_device_init() calls
Date: Wed, 16 Oct 2024 13:12:02 -0700
Message-ID: <20241016201249.2256266-7-bvanassche@acm.org>
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

Move the ufshcd_device_init() and ufshcd_process_hba_result() calls to
the ufshcd_probe_hba() callers. This change refactors the code without
modifying the behavior of the UFSHCI driver. This change prepares for
moving one ufshcd_device_init() call into ufshcd_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7b8eaf2b9ce2..8803031f1694 100644
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
@@ -7736,8 +7737,14 @@ static int ufshcd_host_reset_and_restore(struct uf=
s_hba *hba)
 	err =3D ufshcd_hba_enable(hba);
=20
 	/* Establish the link again and restore the device */
-	if (!err)
-		err =3D ufshcd_probe_hba(hba, false);
+	if (!err) {
+		ktime_t probe_start =3D ktime_get();
+
+		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		if (!err)
+			err =3D ufshcd_probe_hba(hba, false);
+		ufshcd_process_probe_result(hba, probe_start, err);
+	}
=20
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -8873,13 +8880,8 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
@@ -8892,13 +8894,13 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, =
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
@@ -8918,9 +8920,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		ufshcd_write_ee_control(hba);
 	ufshcd_configure_auto_hibern8(hba);
=20
-out:
-	ufshcd_process_probe_result(hba, start, ret);
-	return ret;
+	return 0;
 }
=20
 /**
@@ -8931,11 +8931,16 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, =
bool init_dev_params)
 static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba =3D (struct ufs_hba *)data;
+	ktime_t probe_start;
 	int ret;
=20
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
-	ret =3D ufshcd_probe_hba(hba, true);
+	probe_start =3D ktime_get();
+	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (ret =3D=3D 0)
+		ret =3D ufshcd_probe_hba(hba, true);
+	ufshcd_process_probe_result(hba, probe_start, ret);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
