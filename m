Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE118EB1
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362659; cv=none; b=afUtAXiGiRgKC9CJdBmFtLOHPHEvxxdwI5qEcHAkJF8eiTwBhE5+5nhN+y2ST2ThW44xfm0UiYTK0qI9EQKb4HxC4Rqfpjxla3lrL67S9U1pMKRevsFJWt1e9p+TxTtIDbCii1+CKmkzbXWKQgCnvbaYTqe6FYtoj8s1lvkFlLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362659; c=relaxed/simple;
	bh=yAywN31zpxDe0MEAaUogKh5yD9SvBoWb/kxxEYFKsIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9YujLXYJyDOD/j82iP9jvuGV0CcazBKD6wnIGo1X+WAAt3YBz2UnzbRfTfP9iAsKpS4Lm+G90anMDNUh40uV5dYiyUXiIZRdYwFDOxV1+3tUvIgXSa/MQOUHNATEMpYdSvkhXOq7mT9ax+hllWHbEeNriN+8kAFtSzWKDbgJYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3YFo2Pu4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3YFo2Pu4"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc4L1yWqzlgVnK;
	Thu, 22 Aug 2024 21:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362654; x=1726954655; bh=L8Wq/
	KwOm2eZhxCd3abi3FuGwa0QfjD2YCD2mau1weg=; b=3YFo2Pu4bvRJfCjq+a4qJ
	C27XBxryhHnHfjz7btpL/z+OvrvIiSqbcXjw+ZbQplywOUMC+zEhpy/BQ0OdE/0r
	t8PaRf5yuCdsftXTlfdCSe71dYadCVkzbJODX6MJPddIX/VwxI5TfAzkWvOiCARb
	c3YcYV8Oqq60Mhf3OIwHAO9JNouGsG4BGAZrwH0n0tG4YVJt0nLRkC7DfS4kl7vr
	kOqKtkkmLLlEJnh/yEj7oD6zjChvX7GfKMr504fsBrmwP9+209/L3aF+iugFAmBD
	1BphQG3LBHNnoL+PccscB85dZaUZbYFK9tbM09v+Cq++tdaLHA1Duh1F3zf1RQEg
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o3IfjC6FSCkQ; Thu, 22 Aug 2024 21:37:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc4F26SvzlgVnf;
	Thu, 22 Aug 2024 21:37:33 +0000 (UTC)
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
Subject: [PATCH v2 9/9] ufs: core: Remove the second argument of ufshcd_device_init()
Date: Thu, 22 Aug 2024 14:36:10 -0700
Message-ID: <20240822213645.1125016-10-bvanassche@acm.org>
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

Both ufshcd_device_init() callers pass 'false' as second argument. Hence,
remove that second argument.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++----------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b9aaa3c55d17..9091e5939fac 100644
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
@@ -7719,7 +7719,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
=20
 	/* Establish the link again and restore the device */
 	if (!err) {
-		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		err =3D ufshcd_device_init(hba);
 		if (!err)
 			err =3D ufshcd_probe_hba(hba);
 	}
@@ -8795,9 +8795,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
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
@@ -8805,7 +8804,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		return ret;
=20
 	/* Reconfigure MCQ upon reset */
-	if (hba->mcq_enabled && !init_dev_params) {
+	if (hba->mcq_enabled) {
 		ufshcd_config_mcq(hba);
 		ufshcd_mcq_enable(hba);
 	}
@@ -8820,39 +8819,6 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
@@ -8886,7 +8852,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		ret =3D ufshcd_device_init(hba);
 		if (ret)
 			goto out;
 	}
