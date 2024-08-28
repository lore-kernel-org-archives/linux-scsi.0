Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B47C149C53
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867127; cv=none; b=ovhSVqSxbYSQcKNU0KXw8QCOx1aUPxbrtzKXVpwM83wg0tjKVmWBHkVlXm23aDUVHC/EfO3RLLGma9o6UdsCGphP8B9clngBQhGdA1BxKYw0uBr+4a+Y/gVSMuhOgFbeLUVbocm+Jh/ssUOo1upvFPwc3sTZHuQmJJXrnITVgUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867127; c=relaxed/simple;
	bh=9/H3ngvvJ3LzJi039HZgCnl3JtdffiqVh5V7yM5qoSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYiI3Xa8MN07ZfF5pPv4dGHE+ICF0gdCaODuM216hDtXuT5a1CkZ+gcoKjcAyFkn/YxwkUGcGLS4BE+3UbwLd59+c/cAqQznrae+yT+t21oihb4S5XDNyATAgdFMvkxtkI/XYgbWagpiZjdd1kzLVSsGfgLd+x/RrRPGoD6E5uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X+343Z/E; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X+343Z/E"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdd64xwzlgVnN;
	Wed, 28 Aug 2024 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867121; x=1727459122; bh=b8vZt
	5oazZLWBAQIjbwsd+uatf5Y9nhoo9DTaXSBXM0=; b=X+343Z/E1V8IDedXCiFgO
	qCh68nHuIHnudpCdLrLesH49o/QWq5mBO43SvrAV2VJF1voD19WXJEu6p9wOaN6/
	2ReKIJpZrTBqTAZB8HMPKfG8P121NaiRBdt2sHNHVVIioBdVKMhI3Y/XJ0MoHf+J
	ll4bDyPWbK39yfsbbhwwE5ismjLSA2ehd5BXhXdVIWtUVumT2LjWozDQrQ3VHTZM
	yMz+CKBW7gCyei71/X4zSSb9CFjphplZc11YttlWgB1ey0Tdd0cZtKXN7LKyrmhe
	nq5wbH2MPuBFU6xY/DgG7ZSMYwCvKzlhEE90+Xy/XIYhxwYk1A2KkwKU9C19BgID
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Db6gjGPQkLb6; Wed, 28 Aug 2024 17:45:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdX4GDDzlgVXv;
	Wed, 28 Aug 2024 17:45:20 +0000 (UTC)
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
Subject: [PATCH v3 5/9] ufs: core: Move the ufshcd_device_init() call
Date: Wed, 28 Aug 2024 10:43:57 -0700
Message-ID: <20240828174435.2469498-6-bvanassche@acm.org>
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

Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
remove the 'init_dev_params' argument of ufshcd_probe_hba(). This change
refactors the code without modifying the behavior of the UFSHCI driver.
This change prepares for moving one ufshcd_device_init() call into
ufshcd_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 20e00ec5fda8..f62fff878980 100644
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
@@ -7711,8 +7712,11 @@ static int ufshcd_host_reset_and_restore(struct uf=
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
@@ -8848,21 +8852,16 @@ static int ufshcd_device_init(struct ufs_hba *hba=
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
@@ -8880,7 +8879,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, init_dev_params);
+		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
 		if (ret)
 			goto out;
 	}
@@ -8928,7 +8927,9 @@ static void ufshcd_async_scan(void *data, async_coo=
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
