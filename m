Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CFE3BD225
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 21:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225728; cv=none; b=rhpntXYw0j3+mvOQrEAQc0dLHi+MsEoJQ8SfGVFJZ7HnDD3Lyl+A2jSCm5up6qIBfhBPNvx/JPslFO4HkxXpnbgL37aFyGAyYkkqOPuNst/SMzK8948RbGAtaqChNDyfuECoSA23jZ5PWY872xOeYX/XeeRA6RIkEWcphKeqhuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225728; c=relaxed/simple;
	bh=vBpyUloOpwAKuJehRB66QvT1XcZzF44bodcazCfiX+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdQAXCWg+dLJ2pyzCWlVMIq1SwHIGmcXY2Z43o4qgGzQ7BBRuUajGpLEnBErBioTT14BWoUpUy5nnV2aPwzf53oZ08MRQxPUn3TR9Q3p8LZE3br4gsuCmbSaewRRNOLtF/Zjryj5OHQORMFlEFJzEkCLKwpFiT9jnlRWLFAlPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OsHx4uVn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OsHx4uVn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gKngL4ys9zlgwMq;
	Tue, 19 May 2026 21:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1779225722; x=1781817723; bh=eU3r3
	pApy5/+GmWmwkShU+UTuNM3choA691IU9B3GMc=; b=OsHx4uVnSwxjea2B7YA0g
	L6y336E9EFzcY2m6NKkOrS0tt66OQA3Q7yfsoKP5VZiH98b6X01orWkTuqZsQ+Wj
	4bYtiUlajMAQhLIBWySCnxI25lH+N8IQG3PPoCaLshCRpZuPsdN5peZVED4PDzjk
	BPeL/HPz4xeaQGl3CVFrCtVB06BZNsFkRieunpbo9beHj9o3HrTsmsqRNnFpISR+
	by2V5CaWoTnT+vHtPqxvlrVCszeU8HpKjYwWHqiPlU5HdIg7UXEyo6piS5fqndla
	/uHZyzqrUWZmyn5YEW/QTI+d7mDTa46HFPmEn7Uuf6ox3KBhq/bjOALl2/Xd7xfu
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uSJmatZfXVYM; Tue, 19 May 2026 21:22:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gKngC2RNhzlgtd2;
	Tue, 19 May 2026 21:21:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Date: Tue, 19 May 2026 14:21:29 -0700
Message-ID: <20260519212135.3130556-4-bvanassche@acm.org>
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

Use cached values in ufshcd_add_uic_command_trace() instead of calling
readl() when tracing command submission (UFS_CMD_SEND).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cfb362fe9784..c1a0a79e386d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -460,20 +460,24 @@ static void ufshcd_add_uic_command_trace(struct ufs=
_hba *hba,
 					 const struct uic_command *ucmd,
 					 enum ufs_trace_str_t str_t)
 {
-	u32 cmd;
+	u32 cmd, arg1, arg2, arg3;
=20
 	if (!trace_ufshcd_uic_command_enabled())
 		return;
=20
-	if (str_t =3D=3D UFS_CMD_SEND)
+	if (str_t =3D=3D UFS_CMD_SEND) {
 		cmd =3D ucmd->command;
-	else
+		arg1 =3D ucmd->argument1;
+		arg2 =3D ucmd->argument2;
+		arg3 =3D ucmd->argument3;
+	} else {
 		cmd =3D ufshcd_readl(hba, REG_UIC_COMMAND);
+		arg1 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1);
+		arg2 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2);
+		arg3 =3D ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
+	}
=20
-	trace_ufshcd_uic_command(hba, str_t, cmd,
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
+	trace_ufshcd_uic_command(hba, str_t, cmd, arg1, arg2, arg3);
 }
=20
 static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cm=
nd *cmd,
