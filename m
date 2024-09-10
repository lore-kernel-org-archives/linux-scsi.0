Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283851A08CB
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005186; cv=none; b=mZySnSE3+hc58iur4Pq4r6XIi5e/EL5BlUv5kcut9QDYUtlEsQbewS8hYvlGY2zkW6DhcKX9CYaDaloKNsKq+H8/gf4gY2v9HxmxmTuLIkByOwv3Saqj4tt7HoOxMq1LizQH3uCT02yGxUWcgT7WQPmw0dVO+zZrrSHppPA3GPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005186; c=relaxed/simple;
	bh=lByadXpuat5mMYq9fBixfko2QYJ97gaXHuXlj4yqNUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV67oBylhzZfnYUyXgrsfajdWGcZeIJOzX79+4wlyFEaeGcQ56HOnawGQaBLv+x8vvUQDz12BVdnKE97NaALA6YAyapya4Iw6/GdgrfX9mB8XhcOhBMhuX8j8iwXBssfLu6Z9xnThiyWMLWmRBRlNlCwbfZjxrz9ZEBIbbR+qjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uEQCDQ+L; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uEQCDQ+L"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HWN4Ng6z6ClY9K;
	Tue, 10 Sep 2024 21:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005180; x=1728597181; bh=bfktr
	atM+bUs3/t5PQVrWmxMwz98Z8IztApqHJVPOr4=; b=uEQCDQ+L6OJpfdUSwJ98b
	QyqtskJkg86PWEZNZ7s2vBHWtuarv5tzVMcokWF5I3KlHkYpuKD7b2GnciPgoGEi
	yixcOx0+2nqQlg22tUZJyPPj+0H8Lf5f+ynXx5ZZWrW+APmAKCeMLAkpsgiXlAmI
	FSIvzpogfMV834k4ysGOOhaW5DSYM1TXCf2Dsgu6Yd9Gzvf1uc3vcwbbeemrlZCk
	DOdWGhLLKfxq8BXjH3o+W5ipqlxbtcmRaGyAPJGrPtPb70moWA2E8y6UExwVLQtk
	tTlGTNR5O64LYp2iRI6V/IAQg1UUnpFwoaG8I79E7wArxLuVFCmjt9ioRI4V6Q9v
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fcb1h-rB5SnG; Tue, 10 Sep 2024 21:53:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HWG1wPfz6ClY9H;
	Tue, 10 Sep 2024 21:52:58 +0000 (UTC)
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
Subject: [PATCH v5 08/10] scsi: ufs: core: Remove code that is no longer needed
Date: Tue, 10 Sep 2024 14:50:56 -0700
Message-ID: <20240910215139.3352387-9-bvanassche@acm.org>
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

Previous changes guarantee that hba->scsi_host_added is true before
ufshcd_device_init() is called. Hence, remove the code from
ufshcd_device_init() that depends on hba->scsi_host_added being false.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index efa9c177a80f..ce4f9c8554c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8776,7 +8776,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
hba)
 static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 {
 	int ret;
-	struct Scsi_Host *host =3D hba->host;
+
+	WARN_ON_ONCE(!hba->scsi_host_added);
=20
 	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
=20
@@ -8817,25 +8818,7 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 		ret =3D ufshcd_device_params_init(hba);
 		if (ret)
 			return ret;
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
+		if (is_mcq_supported(hba)) {
 			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
 			ufshcd_config_mcq(hba);
 			ufshcd_mcq_enable(hba);
