Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A918C923
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 23:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923553; cv=none; b=i94p8hZcyOyzMqbGooorW9Yo1IkD3do1xwMGSg9uQzTIaX8iPsKOAj8omG5fCNeNfvnwSMCGWLemVQERn6oviffpDi4bMxnul/2Cqisz/Zt6i8FM4MNckyxppsUaItyVdCd0A+7Xa4o95733upASGzOAZzqk6l5nhlZk4vtT32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923553; c=relaxed/simple;
	bh=YuV+NBhRWZ0+Ju05pPKOKvV4OPwHU+oS4simsOP6uh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AufBPYc2nQIso52j996ew3+FIu7VitBbbzz06ockDzpQbZSBk62UTEuRb/iVY2wd9InpIPSbSnJnm2Y7gUNZyhv5x3zOrCG43t6yzIWOfxl5/Y17H8BJ3km2a4iQMY4lg9L/e/FVrL46nAaqGb5Xf0xeju7+t07y9sYLlTd5h1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0YS1rubo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0YS1rubo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2jKV37H9z6ClY8r;
	Mon,  9 Sep 2024 23:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725923539; x=1728515540; bh=xDxE2
	jiqdBmZDnXQVLEd0lngtHNP+7y0ubPOaeXCuP8=; b=0YS1rubofzzybduVfVS3p
	OEAOAe/RTUxgpyzLLGh3dkDGVQREruGNLndcm7U9P0kct7wJ5FYf3iAxGgfJI4UM
	UM7ZXdwB5u0+BAGYX3nDdmbBuzAc/N+Ca6OkXWg0GBm1LINPkVobZJRg9OqLnJmQ
	DGXD8QvcySs5/69wC9OWIp1WNI/URF4sA7NOu1orYjKTp2ruy0cUbLPLJiDkA3PD
	01As9+fYUfnuUKNMQHzHDRgUmkTfaxxJkOfVaZtV1f8NsZfFycnG5QGwVZBApiPg
	K3pXpCDpj1HIBE/kBnYbC0P1ecuJcEYOhjBNFitfoONxtct4uT8dAkaWxB0SWLll
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EGicCzSQkOOi; Mon,  9 Sep 2024 23:12:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2jKD1CsVz6ClbFf;
	Mon,  9 Sep 2024 23:12:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v2 4/4] scsi: ufs: core: Change the approach for power change UIC commands
Date: Mon,  9 Sep 2024 16:11:22 -0700
Message-ID: <20240909231139.2367576-5-bvanassche@acm.org>
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

For some host controllers it is required that UIC completion interrupts a=
re
disabled while a power control command is submitted while for other host
controllers it is required that UIC completion interrupts remain enabled.
Hence introduce a quirk for preserving the current behavior and leave UIC
completion interrupts enabled if that quirk has not been set. Although it
has not yet been observed that the UIC completion interrupt is reported
after the power mode change interrupt, handle this case by adding a
wait_for_completion_timeout() call on uic_cmd::done.

Note: the code for toggling the UIC completion interrupt was introduced
by commit d75f7fe495cf ("scsi: ufs: reduce the interrupts for power mode
change requests").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c       | 15 ++++++++++++++-
 drivers/ufs/host/ufs-mediatek.c |  1 +
 drivers/ufs/host/ufs-qcom.c     |  2 ++
 include/ufs/ufshcd.h            |  6 ++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 063fb66c6719..23cd6f4a6ca2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4257,7 +4257,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
 		goto out_unlock;
 	}
 	hba->uic_async_done =3D &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
+	if (hba->quirks & UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS &&
+	    ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
 		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
 		/*
 		 * Make sure UIC command completion interrupt is disabled before
@@ -4275,6 +4276,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
 		goto out;
 	}
=20
+	/* Wait for power mode change interrupt. */
 	if (!wait_for_completion_timeout(hba->uic_async_done,
 					 msecs_to_jiffies(uic_cmd_timeout))) {
 		dev_err(hba->dev,
@@ -4291,6 +4293,17 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba=
, struct uic_command *cmd)
 		goto out;
 	}
=20
+	if (!reenable_intr) {
+		/* Wait for UIC completion interrupt. */
+		ret =3D wait_for_completion_timeout(&cmd->done,
+					  msecs_to_jiffies(uic_cmd_timeout));
+		WARN_ON_ONCE(ret < 0);
+		if (ret =3D=3D 0)
+			dev_err(hba->dev, "UIC command %#x timed out\n",
+				cmd->command);
+		ret =3D 0;
+	}
+
 check_upmcrs:
 	status =3D ufshcd_get_upmcrs(hba);
 	if (status !=3D PWR_LOCAL) {
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index 02c9064284e1..4e18ecc54f9f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1021,6 +1021,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	hba->quirks |=3D UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 	hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_INTR;
 	hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_RTC;
+	hba->quirks |=3D UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS;
 	hba->vps->wb_flush_threshold =3D UFS_WB_BUF_REMAIN_PERCENT(80);
=20
 	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 810e637047d0..07a62de80d2e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -852,6 +852,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba =
*hba)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
=20
+	hba->quirks |=3D UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS;
+
 	if (host->hw_ver.major =3D=3D 0x2)
 		hba->quirks |=3D UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 85933775c9f3..787c44a341a7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -676,6 +676,12 @@ enum ufshcd_quirks {
 	 * the standard best practice for managing keys).
 	 */
 	UFSHCD_QUIRK_KEYS_IN_PRDT			=3D 1 << 24,
+
+	/*
+	 * Disable the UIC interrupt before submitting any power mode change
+	 * commands.
+	 */
+	UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS	=3D 1 << 25,
 };
=20
 enum ufshcd_caps {
