Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FD518C923
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 23:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923529; cv=none; b=qrGVDf3ylcbUpxxIUuWuN/cQZVbdOCUJ9ZfyN5lPFGqP3ki0Ss3mvm3hSOzc7UMYjzWgtKjn+3YFEUO+emA0jU/GOzLT64/uCDeFE4PZBegAa5DlJZVUlq84pVPXKhHiwBgEwtGDx9nppHMHJB4XY2l4X3vQYk1KaDsxCSeZpDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923529; c=relaxed/simple;
	bh=vsAg+Zfo4QasgB3bQ181rEygWHkDaCVIGF2Y5YBKUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5FSDuvYq/bPxHW7GCeLoQlw+44KwHgMX7mRmSxCjioKcnvb8O+m5JHC89rR/iw4Z8ouluIP67SLOGsOvg+AEUN66hAX72HSqbZtt7PSGePGeGlmFO6/FHbGnLN5O2KwPBy09+dr9Ne8cuTes3+nvpS0pNSqF+mtcTmxjZJPlTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hhfG3u6b; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hhfG3u6b"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2jK35sc7z6ClY8w;
	Mon,  9 Sep 2024 23:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725923522; x=1728515523; bh=W6wt9
	R1r1etqtJ7sorREhqWApOiurio2eN+3bU/Y6AU=; b=hhfG3u6btJZtymWybFq5J
	ULPHwtKdO3b9k0qRcOOOMDfqdf0ql5GFqj9N6Vnq6tIljVSL1unazFCZ6TXwSk4m
	nHmdSlMnpDE+wavHoMYeJhPmdBidaOleMyN4FW3A9MJUMeAlI11Sl4ZCuN2ht2Tg
	5jLXp2ejLSWElCWTIA3W5JHigU2yoJnKs3qAVv/8t8MfHycabxZt/LqfdS3vmr3o
	hSvgwb16Yqm7uAdCtkTWNjAeXHMEB3KRzzs5cSaqJRcgeLrKcdDPuQySyNsAgEFs
	rRMzlL++VBdM6kDrtHZ/EgzsZm1+V0GWmIeYVm6PrAE5Z52kCzKG/Fjl+EhTO2aD
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WRZ98tUmnQRL; Mon,  9 Sep 2024 23:12:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2jJv4R3hz6ClbFf;
	Mon,  9 Sep 2024 23:11:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 2/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
Date: Mon,  9 Sep 2024 16:11:20 -0700
Message-ID: <20240909231139.2367576-3-bvanassche@acm.org>
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

Introduce a local variable for the expression hba->active_uic_cmd.
Remove superfluous parentheses. No functionality has been changed.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..134cba0ff512 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5458,31 +5458,30 @@ static bool ufshcd_is_auto_hibern8_error(struct u=
fs_hba *hba,
 static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_st=
atus)
 {
 	irqreturn_t retval =3D IRQ_NONE;
+	struct uic_command *cmd;
=20
 	spin_lock(hba->host->host_lock);
+	cmd =3D hba->active_uic_cmd;
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
=20
-	if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
-		hba->active_uic_cmd->argument2 |=3D
-			ufshcd_get_uic_cmd_result(hba);
-		hba->active_uic_cmd->argument3 =3D
-			ufshcd_get_dme_attr_val(hba);
+	if (intr_status & UIC_COMMAND_COMPL && cmd) {
+		cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
+		cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
 		if (!hba->uic_async_done)
-			hba->active_uic_cmd->cmd_active =3D 0;
-		complete(&hba->active_uic_cmd->done);
+			cmd->cmd_active =3D 0;
+		complete(&cmd->done);
 		retval =3D IRQ_HANDLED;
 	}
=20
-	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
-		hba->active_uic_cmd->cmd_active =3D 0;
+	if (intr_status & UFSHCD_UIC_PWR_MASK && hba->uic_async_done) {
+		cmd->cmd_active =3D 0;
 		complete(hba->uic_async_done);
 		retval =3D IRQ_HANDLED;
 	}
=20
 	if (retval =3D=3D IRQ_HANDLED)
-		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
-					     UFS_CMD_COMP);
+		ufshcd_add_uic_command_trace(hba, cmd, UFS_CMD_COMP);
 	spin_unlock(hba->host->host_lock);
 	return retval;
 }
