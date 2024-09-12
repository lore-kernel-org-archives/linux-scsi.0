Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9DC2C80
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726180250; cv=none; b=LoET4dBfzO0Xh65ugRmugs+5L3PChA+AeOeptt4ffMvXJZMlcfxJGtAOLD5uuKtSjt+GlQ8zOAl4d0kHp0zv5BrZb4S0PSFmR7pfxWaQJqAJ8scnDpvV9/FBEIQAaaDGyRe1RIgNejkQdOvpa2uoW+TPj+dGuREW4/4TyZahCYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726180250; c=relaxed/simple;
	bh=vsAg+Zfo4QasgB3bQ181rEygWHkDaCVIGF2Y5YBKUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLz2yiwATAs/sbcnyREKRmNxfT3l9piQiLMgbS+aA6EJMO+K3lLZn8ZicvfQUAQ0DR/gNZ8TZztoaccETUkUZZEtJJjvycMY95WBOK69GmAdabiMx3nijscL+yqR6VGYCJJdE8kC4OU8Qqk9AGwSQLlMI+JvdyH7Rf2BwUEgahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i7sde+EM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i7sde+EM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X4XG01drSz6ClY9f;
	Thu, 12 Sep 2024 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726180242; x=1728772243; bh=W6wt9
	R1r1etqtJ7sorREhqWApOiurio2eN+3bU/Y6AU=; b=i7sde+EMOu3wgGn/aRS/q
	WY4W6fNTbmMBIoYrSM2GcvYRe8EETHUZnoftamw6KgxPeNtw0c4tvg9GCJDy947K
	CG4yNXmoe4bAIzQ5x+vhA0LFGKMVMCcD4smXba9u92ecErRMH1ZLL0/bI17d7qq7
	alwBu85qmMOuFN7CfoXuLzbDbwgkFb0XblmlMu/qlGOZ2qfcKpoIadw7e5/zh3Pd
	xsrTQLWxsWPXYvIjxP3QCdY0iP5RiU9FNniBYL/KIM3qLzgR8XFpZqXv/+s/g9WC
	A5ckNOFcWUQ20OyL6xALWqXXALFH5MwfUKPM16rYIVPkKOzRUrJvyRqhbTHui5UW
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id at4R4Wq3abrT; Thu, 12 Sep 2024 22:30:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X4XFs1Jnsz6ClY9d;
	Thu, 12 Sep 2024 22:30:41 +0000 (UTC)
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
Subject: [PATCH v4 2/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
Date: Thu, 12 Sep 2024 15:30:03 -0700
Message-ID: <20240912223019.3510966-3-bvanassche@acm.org>
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
