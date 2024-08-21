Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EBF1B3B10
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 18:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264985; cv=none; b=rymsgdKT09Xlv/HzHRiw7g2umYHu/FwIvonfd1TTb4pGNAsBqk71W2G3EHwLtn9gicJuVEwE2as+J7HrFMq1mEG1lClnNefOFgXkPxjdGe0Wgho5DCM6u5G2hZ9/bbMY8z1hJEb+IrszVZ+LwnnPzTDol9Qlr7y/bls68L15loA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264985; c=relaxed/simple;
	bh=sQ2QsS3Nzg4gb17wWRIKd0KwKFR1mIXcIuIEWF7qRec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmWbB9oXrSd4J/VT9ReU3hqCf3FfBTNhI82Kw8OncRH9wkND82Ope3i9gkUVs6JSYB9NfGnBBiT1PZqnWr08UWWqvn9ZsEGC9ea5+OzBz9v6qCDvvtyc/QltfUvSAYqhH+D1cRzshPh0wx9i//jBGe6+NbD+fLHpBdqJu0n/t20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2n/y45pd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2n/y45pd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wpvxz5ck3zlgVnK;
	Wed, 21 Aug 2024 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724264979; x=1726856980; bh=MNJdt
	1XGQSLXIDPuyhL3BcWBOGqKZaQgRiCmpFCql64=; b=2n/y45pdvp0ucDccO5ggC
	XwN1QjuIM79UZvtj5UOXqSrA/mWXFQEo3GcOKgpPUhdFj+4peQp6bXtlNWOq+eKL
	tymiEcKcsZovbTSvA+82cK/9tDvC3AU0aMRbY07Xtg8BUg2gvLtiH4igIwVUiy/O
	6aVOtJOrSMbCz+FfL6FSUet9egwHf/vv/y/hfL7x4ebjJKtRX/MxHTuEEmTlBTXH
	0YmFbKNTzEFJXltNfGcrq0iQiFSKuXFgZ9F8t/7QY8IjPkVno+vw5BH3FhWa+FEY
	gwuBnIG9u2onuTnCoy6t8ZpU3UQi+SUD1RQGgZ4hK4nr5DVsQfZF3UJ4HU5ULi9j
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id U28__ih_uXHc; Wed, 21 Aug 2024 18:29:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wpvxv1hbBzlgVnF;
	Wed, 21 Aug 2024 18:29:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
Date: Wed, 21 Aug 2024 11:29:11 -0700
Message-ID: <20240821182923.145631-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240821182923.145631-1-bvanassche@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Introduce a local variable for the expression hba->active_uic_cmd.
Remove superfluous parentheses.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd26059f5d7..d0ae6e50becc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5464,31 +5464,30 @@ static bool ufshcd_is_auto_hibern8_error(struct u=
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
