Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C697462
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101096; cv=none; b=eoGhszzQo7Tddk0uWzJ7akLpHRRCDGMOqrm5WhkQdIT4CSXOX30hMNenfx6DonNt8CssSuGklmqSC8X1orYN95xWvihfoF/W+rbXVIa1PsZNex/B5SjhB8JU1KzSbiN9K+bOly2jOQoGUhOMV3tasH3ORssTqDqlPVHw/VcTf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101096; c=relaxed/simple;
	bh=iL10mvZ/hPyQAlt4pagDqx7HlwgXXZoSyRrQ9qzqgaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaG6MdlZMvM8BkMTtU88jENIUV7aVXLguImPTrTJfmSAegEqz5z47I4D8ItHl3npHtIG0KnM1yh3M56VkEteR/7J/BcjJTnAOpdbCsRCvhoL5eCX32fW1fNRnlUrZrD3p76LN1X72rDeMPt/kKpn4HagaY/hoN+RP+N6aimLk+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pyuIiUOA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pyuIiUOA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3yzp0B5dz6ClY9K;
	Thu, 12 Sep 2024 00:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726101088; x=1728693089; bh=hKyxm
	mcs8Df3jZ3u5AaT4nWNnxZMoPbKHs1qlSggf2c=; b=pyuIiUOAFWuZvJeGmOa/f
	w2xMOWDl48Mg5UmmDiJxszPnJbgXk42E5fCbzdIwk3mFiy76iqwzwlFwCHeH3Fzs
	xsAFA7axoDYrB37E1KZWvrfxVCl3NZQQ4kGuA6xoFPjW10Qyk1QblIVRgs8r13LA
	0eVDRT/YRpgpTQAj0laJ+EiYvGxB4WMrp5YYnHiLRJbW6+7Pl+6LKH/ifgjLMsM4
	72NaumwLDmCu4n367kQ+QnCxJB+ufjZBM6xVl6fO4otOm54Jr6G1vjqr9RxQ+bRe
	M2tYLopqIs/cl7e4JE2kBFnkbe/N4U4BsUSA6QmA88wBct54uk6xlWtf0NweMwaF
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pzQHYN-L2Nea; Thu, 12 Sep 2024 00:31:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3yzg1NVsz6ClY9P;
	Thu, 12 Sep 2024 00:31:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v3 4/4] scsi: ufs: core: Always initialize the UIC done completion
Date: Wed, 11 Sep 2024 17:30:49 -0700
Message-ID: <20240912003102.3110110-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240912003102.3110110-1-bvanassche@acm.org>
References: <20240912003102.3110110-1-bvanassche@acm.org>
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

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bd4ce3395972..753480a1c74e 100644
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
