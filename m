Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF71925B3
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573795; cv=none; b=hTaGzr/ENQvbycrcQKkKaZbIR1d0bG5Y2HnuhjR1NusSOfVjuO2T3OY6ENp2IsFsvlN0r2gEoWtnTvYTpn0KoDpNBGa6tz38x6ehDi6h+3GvU5J5SDGDi8RPFR7/JvdLKtz9v70CLpf0joTu0pr6cI4GFVP3FEWZZ2RAJ5syHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573795; c=relaxed/simple;
	bh=bXelcrPT7VxI6TbKa94HGEIMVI/JlKNEwRQC3flsi1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edBTznuj3Vk/Hh22yJvEkaXzZfrjHm72ktPzIORI1NvsR3i65DuHPPcznlelW9K0MZA/jS2TDQO6SlzHWAt2WImgVk3l7DL9RKBG8wER9Fb5uIc0dE9/3EZkB1J5XkCg3n8SBuJ8E/G9whdVgh936MGcyl3BMgpeuQjwwBDJmsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hL0IjTEU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hL0IjTEU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0CzP5G6Pz6Cnk98;
	Thu,  5 Sep 2024 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573788; x=1728165789; bh=hfxF5
	/pbCNCifAV31cdhWFOh26GgCfcj81PXfUiKy7c=; b=hL0IjTEUYKypzeWzA76g0
	xEHYq+AeeCZ/tayRAacyTooRulP6Zn9mmK/IcNvFdRBKVJ22mCBskiazUFgxFU49
	6KpKKldnHAAAbUI7Ls7tP1LjaN+XmLSYAzFQ7Ll7orYAwMh1JJJ1GVdxM0Vhafbv
	vukzdLr1Pm8hyccusI8wVTle/HPtUncN9jgUHsWUaLvEcIgL/3KQDyKqg2C7n3Hb
	ahHdg+Z3BeI2h9nTSr0I223BLVvDuobXkcUdITpVTLVmxr7HvuNd2sOYpBT/7Xtw
	RkM7Y0Mtl4SZ+Fmg2FPTj4Ity69FniUHvxptPqZZmD0Sv2fjV7+OV8q/EuahawjW
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GnV8v6ML2VjW; Thu,  5 Sep 2024 22:03:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0CzH2qBdz6ClY8w;
	Thu,  5 Sep 2024 22:03:07 +0000 (UTC)
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
Subject: [PATCH v4 10/10] scsi: ufs: core: Remove the second argument of ufshcd_device_init()
Date: Thu,  5 Sep 2024 15:01:36 -0700
Message-ID: <20240905220214.738506-11-bvanassche@acm.org>
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

Both ufshcd_device_init() callers pass 'false' as second argument. Hence,
remove that second argument.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++----------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 17615b56e83e..779a0c7559b2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -298,7 +298,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *h=
ba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)=
;
+static int ufshcd_device_init(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -7695,7 +7695,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
=20
 	/* Establish the link again and restore the device */
 	if (!err) {
-		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		err =3D ufshcd_device_init(hba);
 		if (!err)
 			err =3D ufshcd_probe_hba(hba);
 	}
@@ -8770,9 +8770,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
hba)
 	return 0;
 }
=20
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+static int ufshcd_device_init(struct ufs_hba *hba)
 {
-	struct Scsi_Host *host =3D hba->host;
 	int ret;
=20
 	ret =3D ufshcd_activate_link(hba);
@@ -8780,7 +8779,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		return ret;
=20
 	/* Reconfigure MCQ upon reset */
-	if (hba->mcq_enabled && !init_dev_params) {
+	if (hba->mcq_enabled) {
 		ufshcd_config_mcq(hba);
 		ufshcd_mcq_enable(hba);
 	}
@@ -8795,39 +8794,6 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 	if (ret)
 		return ret;
=20
-	/*
-	 * Initialize UFS device parameters used by driver, these
-	 * parameters are associated with UFS descriptors.
-	 */
-	if (init_dev_params) {
-		ret =3D ufshcd_device_params_init(hba);
-		if (ret)
-			return ret;
-		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
-			ufshcd_mcq_enable(hba);
-			ret =3D ufshcd_alloc_mcq(hba);
-			if (!ret) {
-				ufshcd_config_mcq(hba);
-			} else {
-				/* Continue with SDB mode */
-				ufshcd_mcq_disable(hba);
-				use_mcq_mode =3D false;
-				dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-					 ret);
-			}
-			ret =3D scsi_add_host(host, hba->dev);
-			if (ret) {
-				dev_err(hba->dev, "scsi_add_host failed\n");
-				return ret;
-			}
-			hba->scsi_host_added =3D true;
-		} else if (is_mcq_supported(hba)) {
-			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
-			ufshcd_config_mcq(hba);
-			ufshcd_mcq_enable(hba);
-		}
-	}
-
 	return ufshcd_post_device_init(hba);
 }
=20
@@ -8861,7 +8827,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		ret =3D ufshcd_device_init(hba);
 		if (ret)
 			goto out;
 	}
