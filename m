Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D711A4F26
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867140; cv=none; b=NpbDZSiKc9qC+IWjLzxNMYvP/Deg02N8WBHYf1c6dqbSf34e3bKsJheuV1dNDa3exSggPFO/IHQsWz9BbLiPsmWGc98HU/543haPAr8zhSjIFyByQjKa4b1EJABW7UQ4tKYiAhjNWjPHFxUoqRKQHAUkckMRlTDfCV0m7ChM7cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867140; c=relaxed/simple;
	bh=JwgLAbh0CXa9VFbSK45ttSt7pIf891i6+N8hP+S0yO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATMqTKWJ2rdmeT6srUTKq0g8mWNqSjVoItRso0Q0sf2SXU4KJk6L0werfdUV/q/4Rv+KGwj0wwOijVbLUnGwdcVT+0l+eAXqyYbaOpx0EEH53XtNlrGiV7UtLwr6RELLD8Bs9LczIpBMSTvwt/s8DtWN5IhTjkl/qt743fSFEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WAOC5qew; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WAOC5qew"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBdt72FMzlgVXv;
	Wed, 28 Aug 2024 17:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724867135; x=1727459136; bh=SGOj2
	C6y7d9EyGb8Y8nbwDSTaDDhSYhLuvUtCkXYJ14=; b=WAOC5qeweYqcQfs1uhCgK
	7QT+hKJ9rjPQcLfP/xL2yDbu6hmSVSXaAGCVNORy7wxcBbwRGhzUH5sgY+TGACUG
	devx+wN2/Vcv8qtBzFGRLnpKcqfIQuW850ZSn7/Lg9uJTiLq4V8WLI40EcbHSrmw
	7Y30MCUtA44VQ4NeZ2hqcP+dwkCYle5wZXweydoTKV/dfOzIRppTxLgWMWGvZ5Wt
	HP6a4/VTK9KpbZN+6bJWvavdSSK7/15Dv6p7Kgd7BXYUJxL2Ngv1fujejoil9JFI
	FfbSLRQ5BbEH6QnCV0/kjKoJyAYa3FrQXTDu9RHvHHSsnfr7venZVVSNIfzH3ISl
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UfO5sVJBTuUY; Wed, 28 Aug 2024 17:45:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBdp3QQjzlgTGW;
	Wed, 28 Aug 2024 17:45:34 +0000 (UTC)
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
Subject: [PATCH v3 8/9] ufs: core: Move the MCQ scsi_add_host() call
Date: Wed, 28 Aug 2024 10:44:00 -0700
Message-ID: <20240828174435.2469498-9-bvanassche@acm.org>
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

Whether or not MCQ is used, call scsi_add_host from ufshcd_add_scsi_host(=
).
For MCQ this patch swaps the order of the scsi_add_host() and
ufshcd_post_device_init() calls. This patch also prepares for moving
both scsi_add_host() calls into ufshcd_add_scsi_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index eb2cc1521b66..16638974b34f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10397,15 +10397,27 @@ static int ufshcd_add_scsi_host(struct ufs_hba =
*hba)
 {
 	int err;
=20
-	if (!is_mcq_supported(hba)) {
-		err =3D scsi_add_host(hba->host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			return err;
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		err =3D ufshcd_alloc_mcq(hba);
+		if (!err) {
+			ufshcd_config_mcq(hba);
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				err);
 		}
-		hba->scsi_host_added =3D true;
 	}
=20
+	err =3D scsi_add_host(hba->host, hba->dev);
+	if (err) {
+		dev_err(hba->dev, "scsi_add_host failed\n");
+		return err;
+	}
+	hba->scsi_host_added =3D true;
+
 	hba->tmf_tag_set =3D (struct blk_mq_tag_set) {
 		.nr_hw_queues	=3D 1,
 		.queue_depth	=3D hba->nutmrs,
@@ -10641,25 +10653,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	err =3D ufshcd_device_params_init(hba);
 	if (err)
 		goto out_disable;
-	if (is_mcq_supported(hba)) {
-		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba);
-		if (!err) {
-			ufshcd_config_mcq(hba);
-		} else {
-			/* Continue with SDB mode */
-			ufshcd_mcq_disable(hba);
-			use_mcq_mode =3D false;
-			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-				err);
-		}
-		err =3D scsi_add_host(host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			goto out_disable;
-		}
-		hba->scsi_host_added =3D true;
-	}
=20
 	err =3D ufshcd_post_device_init(hba);
 	if (err)
