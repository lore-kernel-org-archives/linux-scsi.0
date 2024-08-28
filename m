Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E616E1A76DD
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867146; cv=none; b=Smt591oueDSybB0sjtYr0pnnY2+nEDESO6EFzSmhFvXnTqIimKkNLrxKaymLxOgWpiSwZLZHg3cokCQFUSIIu0AWfNVlcHorSTydaSsgEHRq2wO2d+jJqZoGzmz89ELsp+MXGFmu9KT3xkS4N+2jjmHUOR33mkO8qRJtg03sODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867146; c=relaxed/simple;
	bh=JDYyNmU8c0iOubICsxNNsOtAjdn2TfR4H5+dm7pVXWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+NSQj2uAu9X8sDPnFredycU9pRyJg417ar3uByYTYAds3lb88oxFmthff+Ou52nKqBVM2p2LSWZ+ZpLKlmxIh4QfwVzujsJ58idjkwTP/xIarZZq4e1yAkJt6pxYELf0KWtwN8bCk4c2nCTW7+Y6pbqb92pzonHVe6bANvWvSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ghFK8dm+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ghFK8dm+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBf03Mn7zlgVXv;
	Wed, 28 Aug 2024 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867139; x=1727459140; bh=sFlTR
	OTiLIwTILzMA1TwDe91+GeAPCtNN+QFgSjLIeo=; b=ghFK8dm+eJpVPlIzeYoxg
	WdJf0vptTEl4PiFFmlelC52vKQ/DaEL4IXsr1jyP/7ryKEyUm5/KzTXppe249rkm
	Zz7G2ZXlhUZWI/kF/ZMPlSr3zFYjKLPDjg3LgD82YdILHzWz+qVaLhss4qgjvchJ
	LFqdy2OS8PySn8U5fgk8/+s++LQ8BlBDJ93rnPCDn84IYd4IB5ul9vDpq3trF0Rb
	mYYH7+fr+cK07vsjAIXKEsOU5fvPP0LXQqyRC+p05FGHJI+aPpZq+CAgKAe4ddlm
	CEgf6tjziu5cNnXw2/qyD8BUfCQkJw7uzDajHXbBAImvQnmrQQtQgY6gIKysCrIU
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XSMHT5QHopl3; Wed, 28 Aug 2024 17:45:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdv1HCRzlgTGW;
	Wed, 28 Aug 2024 17:45:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 9/9] ufs: core: Remove the second argument of ufshcd_device_init()
Date: Wed, 28 Aug 2024 10:44:01 -0700
Message-ID: <20240828174435.2469498-10-bvanassche@acm.org>
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

Both ufshcd_device_init() callers pass 'false' as second argument. Hence,
remove that second argument.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++----------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 16638974b34f..5239caf3fc65 100644
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
@@ -7713,7 +7713,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
=20
 	/* Establish the link again and restore the device */
 	if (!err) {
-		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		err =3D ufshcd_device_init(hba);
 		if (!err)
 			err =3D ufshcd_probe_hba(hba);
 	}
@@ -8788,9 +8788,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
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
@@ -8798,7 +8797,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		return ret;
=20
 	/* Reconfigure MCQ upon reset */
-	if (hba->mcq_enabled && !init_dev_params) {
+	if (hba->mcq_enabled) {
 		ufshcd_config_mcq(hba);
 		ufshcd_mcq_enable(hba);
 	}
@@ -8813,39 +8812,6 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
@@ -8879,7 +8845,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		ret =3D ufshcd_device_init(hba);
 		if (ret)
 			goto out;
 	}
