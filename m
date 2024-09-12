Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263612570
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 00:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101086; cv=none; b=VgbeovXg+W6ebPN5ZoBqWHA2x/acA/5IRs6uKJoIHeGBpBSwumwkMJBKyaazrrFeTi0La/Zpz9qBXDULoY42ozC4zb6r+Q9lDLUK6m8ZyroCJKkajKo9A9rIh3aY38voyoqm4w+7yNtKrZsJgfgKfB0Paj38I48kxrj5/I1dVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101086; c=relaxed/simple;
	bh=vsAg+Zfo4QasgB3bQ181rEygWHkDaCVIGF2Y5YBKUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdcufDlwwgz7igj7UWfAa3xfZjGAP8N3sdI3gX6dIVwGrP0g8G7vuux3XGU+AhkfCwe5QgbP1fadqXeS+n8JsaKgP3oDkAEgW5H+lgggWgIxkhLDn08TT/pQKkZD3zkht+VRTBtrkGyocEPz0QUpTfsPjaQsZcIHrx2k+TBp0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=C+uk6FG9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="C+uk6FG9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3yzc4GCJz6ClY9R;
	Thu, 12 Sep 2024 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726101078; x=1728693079; bh=W6wt9
	R1r1etqtJ7sorREhqWApOiurio2eN+3bU/Y6AU=; b=C+uk6FG9YQQnh4sObSOnr
	bdPoKy3AMqYzOs1gjt8ta7FKdLAkvrO2QsgipdbnxQodf/VX1nmStz/1Wtk74FT8
	/AtpH8mazbAmpDTktWO4hJVraHFiAHNRrx8mpMcxX5lvfLEUtyIrW877H/XNiOCy
	S1kf4WCXLY1Z5CSvHUxMGn3SNODJov4DjiuIZHrSGA9Z8sTJfClrgbpA7hoZX0Q/
	cmB2pJQVQFSAxIV/cZrmgWXY8zwRsGLdMBMA6SLLkkUK1I4d7XRlmZvxN16REh8n
	G99Z+1lj0lP+MQBOn6KzbBFuKQSG2kT/V1xgoJL5qz6V4nc59McfqFOX5VMFeUlM
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ifql6Rdpi4iX; Thu, 12 Sep 2024 00:31:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3yzT51rfz6ClY9P;
	Thu, 12 Sep 2024 00:31:17 +0000 (UTC)
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
Subject: [PATCH v3 2/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
Date: Wed, 11 Sep 2024 17:30:47 -0700
Message-ID: <20240912003102.3110110-3-bvanassche@acm.org>
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
