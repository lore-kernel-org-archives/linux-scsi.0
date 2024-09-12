Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44FE1C32F6
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 22:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726180260; cv=none; b=Zb6TUJUcA8ddhTI4q94Rnlq6ckGIxbO5+ASLsQQzxqSkrIgJCP4HaGZB7RV1eQonppXFmRytj2Ij+7OzEVEsmwy+5wvl1KvpSZblrZHCLzupT+GjEbmoQo66Y35xbrSv94sZ+QGNjnAQbfqFWDIb/dXddGfc+K6ekGf+FQqtyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726180260; c=relaxed/simple;
	bh=w0F/ftf3Jy9Gs018n15688G9I3Ojz0lu5reFJjUG+Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NieSNwCuk5f/kiptkZ6E6im85dyvnt3j6npAELnQ74wi13afTTMBJZoOt7lWnUW7cqPcUQeLE1JUEVadG1hVC6Vh6EESNvpGw8idnnaRswEexBetNvayjCKGkUuv2E9Ge635FYSEKtbD/dgWNwVudjJUHvMdtmZVtBlc9F6e9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ANy5ssWo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ANy5ssWo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X4XGB427yz6ClY9R;
	Thu, 12 Sep 2024 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726180252; x=1728772253; bh=dUcVo
	4cb2xd/osncIq37Cm+daGKwijYh3GhGVQSwEAg=; b=ANy5ssWoROyNcBE+YVdt8
	oPkYPzulCPjcTeU5FcfWu1bGYWRRbyc9Lwq6ctWGcym0A6d2JvM3l0rT1HkKsAWp
	pOBg2ec458z3Qqe00efZex287JS3bQ1/I8lo2grxmfTwYSUhqORBUUbJQB7YSywy
	R9kzpa+e94F4HhPwxnC+vNsWDxqM0TCdET/HS/bktA2M+oBsqiQDw8BJMIstMK32
	YaRJZ3i6bv9ulm0PldJUapAf2TC7OgtyfrslPNFV6M8zIkNLS4WfmhwKYROlNB19
	FYYoxKSpxa9fsxRwqFhVCSpknAOZI9WpZyMIFp1mA+zTHNbYFlp0B7xBHt0WeIgB
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tw4K8Ldns7vM; Thu, 12 Sep 2024 22:30:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X4XG32VgSz6ClY9d;
	Thu, 12 Sep 2024 22:30:51 +0000 (UTC)
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
Subject: [PATCH v4 4/4] scsi: ufs: core: Always initialize the UIC done completion
Date: Thu, 12 Sep 2024 15:30:05 -0700
Message-ID: <20240912223019.3510966-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
In-Reply-To: <20240912223019.3510966-1-bvanassche@acm.org>
References: <20240912223019.3510966-1-bvanassche@acm.org>
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
index d047ccba8b84..c881d1fea968 100644
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
