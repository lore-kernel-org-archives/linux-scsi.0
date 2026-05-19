Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C22262A6
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 21:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225720; cv=none; b=r5Ic2uKceDAwz7sTmdZ7kA3pi9ekQaXd1wFb2HEx382WDoaLgkUUvI10x3U66Xmr7BBu097yZHWtfJqVEpXyKGrp6rBzWDg2+GHYINTYCPhSO4F4CDX6t9CXNTmLuf36Top0sMXkQVIATVfTn2bI8cFyUsf6ZjggVR6hGb/tzjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225720; c=relaxed/simple;
	bh=3C/e91R5WgHQ6kvaxyf0CVX9uDE/uqrLGG81ezUOgMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv5SaEBnc5e20odrmy7eO1CdwBfAdEVbdYL21ZzosmEh5jidaWdXBAdM6bRbP6eyyRWt4MY2gE6u5LXonEgfJTYWObToPFRC3/1lAVWGRCk+93H0M5KM4FmW7rCxy796zzb1T9S9FhFinZnlKmXn0x7p4Cy0ydkqUx5hCwMYJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N8HQPWfJ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N8HQPWfJ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gKngB0Y9Mzlh2fp;
	Tue, 19 May 2026 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1779225711; x=1781817712; bh=tXfum
	yvaEC7tKKYEPbpaFEfkPD89RMGX/Q4gcUCZLoA=; b=N8HQPWfJpTaWKms42yqgR
	0lPpZHh9MeHkQw04TuZcvEgyreW6IdGg6nsVSlxx4kS+zgGEq6E9MSX0KcFoIgNo
	TZmYr9ZccHsXNrZ2zy/Cs7yTsmPqwyqejJjo2dS4za09gkedQzjuTdMFF20+7ekV
	iLTuJ4YYtz41CheuaarvR9BoG9FXnqp5wvYulMXhn0smFWe2JLhu49BWUlsrjYsX
	o0RkNsibU1Ud3QZM9Ixsr7DkV0mSqC5GWbFecZTv/uEfkHvYRui0YSfkvpo1PMiY
	pDoIATBt0DjODN15/rMeNbOchzG/iq9RZwrfRe4/BkKOrOlXtXSXaZtqSSsRZ8oy
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f9MjNOKJoVQs; Tue, 19 May 2026 21:21:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gKng02hXpzlgtd3;
	Tue, 19 May 2026 21:21:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 1/3] ufs: core: Inline two functions related to UIC commands
Date: Tue, 19 May 2026 14:21:27 -0700
Message-ID: <20260519212135.3130556-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
In-Reply-To: <20260519212135.3130556-1-bvanassche@acm.org>
References: <20260519212135.3130556-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The implementation of the two functions ufshcd_get_uic_cmd_result() and
ufshcd_get_dme_attr_val() is very short. Additionally, both functions
only have one caller. Inline both functions to make the code shorter.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 37 ++++++++-----------------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1aad1c03c3fc..f3e226e47c90 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -912,33 +912,6 @@ static inline int ufshcd_get_lists_status(u32 reg)
 	return !((reg & UFSHCD_STATUS_READY) =3D=3D UFSHCD_STATUS_READY);
 }
=20
-/**
- * ufshcd_get_uic_cmd_result - Get the UIC command result
- * @hba: Pointer to adapter instance
- *
- * This function gets the result of UIC command completion
- *
- * Return: 0 on success; non-zero value on error.
- */
-static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
-{
-	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
-	       MASK_UIC_COMMAND_RESULT;
-}
-
-/**
- * ufshcd_get_dme_attr_val - Get the value of attribute returned by UIC =
command
- * @hba: Pointer to adapter instance
- *
- * This function gets UIC command argument3
- *
- * Return: 0 on success; non-zero value on error.
- */
-static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
-{
-	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
-}
-
 /**
  * ufshcd_get_req_rsp - returns the TR response transaction type
  * @ucd_rsp_ptr: pointer to response UPIU
@@ -5810,8 +5783,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs=
_hba *hba, u32 intr_status)
 		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
=20
 	if (intr_status & UIC_COMMAND_COMPL) {
-		cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
-		cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
+		/*
+		 * Store the UIC command result in the lowest byte of
+		 * cmd->argument2.
+		 */
+		cmd->argument2 |=3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
+				  MASK_UIC_COMMAND_RESULT;
+		/* Store the DME attribute value in cmd->argument3. */
+		cmd->argument3 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
 		if (!hba->uic_async_done)
 			cmd->cmd_active =3D false;
 		complete(&cmd->done);
