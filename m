Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC428F5A
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923535; cv=none; b=FWfzOJzJu80ndVtBBXVQBILmyW6MP0NQroIRRaFu0QIBJ4QfV5Tu/E/24lF/JPdLSVIY29y71HjsBL76OpBWtiUDDOdJ1gOIczBoeu7kmdTMGS+FaXlc0WUFUZEnKmJsrr7EMvVEwh05UGDaB+gID9pfCW7WXv0kmqqcVJma2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923535; c=relaxed/simple;
	bh=/GrVkqcOQcEAjoDpUDF+HrT+4BRTLzWPBj7iNyrGyIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAXroLGVJnct9qgASlcpITlh4maxSCN9xbng21eKTgR6lSMFnjrXaYtB9OPYySkNmffE2zzHIIVD6+aPxhswqqyRmg5BTR75XBe85P0NSOa3pzBmHRD/NFU4B+1EcQXKhVeI7a9uTeVoSrGbJN0wVsY1rCT53L/wz1HSIOnlwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xY5CkCa7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xY5CkCa7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2jK94KyZz6ClbFf;
	Mon,  9 Sep 2024 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725923528; x=1728515529; bh=SvXMJ
	iPZBHoU6aPNCnj3gufXyHHgjWrutRYVZ73EKeE=; b=xY5CkCa7VSDpISQly4I5u
	lSN8WbDBvE9JoywRgkZMjvwb8L0ifjSiGxm0xiBRUV6ggGZG3vdy3XsjFyI0r6qK
	9O36uZAipm+MVBDUqUpyuj8XyK1VU/OAI6Hs7MJZPY6sGfcqL60a/mPgqsoq8Nk+
	+18v3iTd59N4nyKkLocFL/Wt+K6vXrnK8ppBWr3trrdlItp1nSseVbm2H2c7zxH4
	NWndL061jsom6p2qTqPsm1yZX8Y0qPeUehrLx3Au80QjUB6t7eSqXU1AU82aD3e+
	84Jc03RMhZ0mydQvrP3o9p1q6U06ksWgbfpiFxhaRQWWPxqKPn3i8jy3Lct/o8pH
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JfjwWVZUbmkg; Mon,  9 Sep 2024 23:12:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2jK23NGCz6ClY8r;
	Mon,  9 Sep 2024 23:12:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 3/4] scsi: ufs: core: Always initialize the UIC done completion
Date: Mon,  9 Sep 2024 16:11:21 -0700
Message-ID: <20240909231139.2367576-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240909231139.2367576-1-bvanassche@acm.org>
References: <20240909231139.2367576-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Simplify __ufshcd_send_uic_cmd() by always initializing the
uic_cmd::done completion. This is fine since the time required to
initialize a completion is small compared to the time required to
process an UIC command.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 134cba0ff512..063fb66c6719 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2537,13 +2537,11 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, stru=
ct uic_command *uic_cmd)
  * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
  * @hba: per adapter instance
  * @uic_cmd: UIC command
- * @completion: initialize the completion only if this is set to true
  *
  * Return: 0 only if success.
  */
 static int
-__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
-		      bool completion)
+__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	lockdep_assert_held(&hba->uic_cmd_mutex);
=20
@@ -2553,8 +2551,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct u=
ic_command *uic_cmd,
 		return -EIO;
 	}
=20
-	if (completion)
-		init_completion(&uic_cmd->done);
+	init_completion(&uic_cmd->done);
=20
 	uic_cmd->cmd_active =3D 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
@@ -2580,7 +2577,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct=
 uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
=20
-	ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd, true);
+	ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
 		ret =3D ufshcd_wait_for_uic_cmd(hba, uic_cmd);
=20
@@ -4270,7 +4267,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
 		reenable_intr =3D true;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ret =3D __ufshcd_send_uic_cmd(hba, cmd, false);
+	ret =3D __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
