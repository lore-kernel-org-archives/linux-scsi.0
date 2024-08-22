Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193961D173C
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362640; cv=none; b=b9UxeyXtPYEHaV2R57yDj1s+RKjSIoRuCmlUauXzOiBONlXJ9E35RZXUcTGwZOKTjymlbowj43+6g+HA4E1a9ACO8FAeZAHrlXX2B8gJBEndyzihUp6DOBrTowI3hqOHOHRra4aAgElSKz5kr7qsoDUTLjv1POWicfT5U7OxtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362640; c=relaxed/simple;
	bh=MIsl1MVN0Nw2cJ6pbgLiAsJmRdVAsdfLUbBRgicc51c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqY50KC+cpL1Sx1X+O9VuJwVTN2/fXPB21r3dMn+KoMvt4Uq93Nkk3YBuBvX08mN93UlFie3Ni6ZIOTuPVBGyvPItoSVkrLWTGsjYcoLiOwzOBe4sqePTG34gio690+R3MA7KWeA8NPpR/CzV2ERQxMJYGBhE5xbroqMu4tb6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZzFMJxd4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZzFMJxd4"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3y41glzlgVnK;
	Thu, 22 Aug 2024 21:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362634; x=1726954635; bh=87V24
	8CQ2zOUcmVMauXV6EqkwPUWBy4EbMTXxqEQftU=; b=ZzFMJxd4jg7e2IdwE9NMw
	dNDqXUVbkCklVqeoUbUr7Bc5Ssl4OL7IFHn0cZHmJq2nkWQ3nBC8FvjOJ/gbRuYB
	uzRQfKzyQlWT7CD6rFpoQiUTho0E30EyQ0u27CEv3GPT4nrnzaTrxJosSs3CFkPX
	uJngR7tStB57Z3SL3b0ItQctkvQEuGPDgdvP0tLJg/gGrriKg9x29FQh8qlulUsq
	zEWVM/Qa7pSSc9xZir7ZWPsCN5jEaNwYAXU92gekFyA4QpsO+aYbolWjLjlOhu8e
	kRE3jJqHw6wMzDrTR7Vf0VW2cdSUxfeS2lVu5azAYKpR+BfAjplkCIFb3/WtvHlV
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DfwPVi5e-sKC; Thu, 22 Aug 2024 21:37:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3s4pVczlgVnf;
	Thu, 22 Aug 2024 21:37:13 +0000 (UTC)
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
Subject: [PATCH v2 5/9] ufs: core: Move the ufshcd_device_init() call
Date: Thu, 22 Aug 2024 14:36:06 -0700
Message-ID: <20240822213645.1125016-6-bvanassche@acm.org>
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

Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
remove the 'init_dev_params' argument of ufshcd_probe_hba(). This change
refactors the code without modifying the behavior of the UFSHCI driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b513ef46d848..5c8751672bc7 100644
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
@@ -8855,21 +8859,16 @@ static int ufshcd_device_init(struct ufs_hba *hba=
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
-	int ret;
-
-	ret =3D ufshcd_device_init(hba, init_dev_params);
-	if (ret)
-		goto out;
+	int ret =3D 0;
=20
 	if (!hba->pm_op_in_progress &&
 	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
@@ -8887,7 +8886,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, init_dev_params);
+		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
 		if (ret)
 			goto out;
 	}
@@ -8935,7 +8934,9 @@ static void ufshcd_async_scan(void *data, async_coo=
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
