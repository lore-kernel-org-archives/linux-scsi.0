Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27B15532A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573772; cv=none; b=eMIHZcuI+sqxalF/JEJV29QME2dNo02HI7LLL9zLP5r2DyZURLR7jrqr/EozOVv8/p2f9Cgdq36gn7GYhHQMO3sXfpnhc9Ct7FTr4BfW+DHovzYQkPtBFLD6yVIZ3SlB4/StxyVOcNuinLBf8CEfetWP/WBXjSu84yyouliQBUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573772; c=relaxed/simple;
	bh=yaiEjDXaCGspBEv6pBjCdhxiwZFpKYpSP2JiONQXnTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhE4E596fcJf+7tb2I/w6cCOzKNgbjyLbDqkWh4CFU4usq05evn8w0tQKC7h3sK5t317fFH9ogFwh4BiU4qBZTa1KXGw2f5QPTwrGJjcCHSy51L+cph3COI/r9mNUzpyF033VuX0YYlGKSAs1T6YwvL1qsXGlepCPeEfTb09uws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M++y0Dj6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M++y0Dj6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cyy3K07z6ClY8x;
	Thu,  5 Sep 2024 22:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573764; x=1728165765; bh=238ED
	FcsWeAvzUXHT436aBiy5ZfGiIv7+fgB6GaIDTE=; b=M++y0Dj6O1aQ8OBAEcRIM
	Lj3RIUcdubf3flN1Kp8ongWaDTMwtsaD4PAEFvBnVGgo+DihlwfapxCDxNps0UBu
	4hQeXvplpuGrEAbuhBGE/4Kb17C1cGls1OBEg6e30b+UX2XUcGcqL8aFGOVSQWPO
	dtdnqwjOLMfMiGB1BDKG7hQuBPQkVIyjlRdh1fptj70fUL5OWpauPtzJI6PEdNDu
	Gy+OFRq43PegareqG+fnTjA0VIWP9u8R/E9AJnU5GKVo/kWCjB2O3Rwp7DLOckB6
	3TqxsjLQ0QVjuDJjieJoIL6wVYTIOYJQcQk09nh4Q01SZwxj1H3Peiy8L6Tq7aZ6
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2Ih3h0skY6I8; Thu,  5 Sep 2024 22:02:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cyq6sVYz6ClY8w;
	Thu,  5 Sep 2024 22:02:43 +0000 (UTC)
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
Subject: [PATCH v4 05/10] scsi: ufs: core: Move the ufshcd_device_init() call
Date: Thu,  5 Sep 2024 15:01:31 -0700
Message-ID: <20240905220214.738506-6-bvanassche@acm.org>
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
index e2137bcf3de7..6e3cffcdf9a6 100644
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
@@ -7693,8 +7694,11 @@ static int ufshcd_host_reset_and_restore(struct uf=
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
@@ -8830,21 +8834,16 @@ static int ufshcd_device_init(struct ufs_hba *hba=
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
@@ -8862,7 +8861,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol init_dev_params)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, init_dev_params);
+		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
 		if (ret)
 			goto out;
 	}
@@ -8910,7 +8909,9 @@ static void ufshcd_async_scan(void *data, async_coo=
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
