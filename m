Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD4129BDB4
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754927279; cv=none; b=hdP9d6TbIn5YxHWnmmL+mJMmdqH0TwGE4JryYFD3yU26Qh36/sHbvb0nittLPCq3y10oSLf6hhAEcVekBR06esCgwKMw2xzVNSyew4i8lDrT6zOJuigJ1QTV9nahneO4jsS4Jza3vKsxDbfAnC9WnTnzPT1ohP38O7m04UmIneI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754927279; c=relaxed/simple;
	bh=n3sq1Ebk2rpvgCHzlRFtrWKV2tGYh/cAH8bm5XKiNto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOkE6MHlo0oBkqRDSLcNSNsmoPMTuQxvp6N0V1XpBSLet2mt4z+++f6Mw1jxCb2qTyF1PuKXWDaFxP3033AngOW6PgKlMArnEAuBEcssPT4XRLMcewSFRV5CJCoa3jPtxQyot/30j4gPS7G8QNddLN8iJDJESu//ZNCWMXZoBt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F1EMAtrh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F1EMAtrh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c0zYT2vsvzlgqV2;
	Mon, 11 Aug 2025 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754927275; x=1757519276; bh=SAYmY
	9phqOyCqzoT8V7SMKuLRV8PPIES6pqNNLxjYuQ=; b=F1EMAtrhb8O3SxkqmncwF
	RlxY6huHemZN6HxKokJeC+6ciOOCC9Rsy4uQBgEhinVOQIZZ1RIiQ3qYl9MCHn2k
	l5z6FOeSfMAS/T29kot7eUOwpSG/VblC3aFXkJRETZthmfJoCHpJaofVv7g1FTdz
	jiWrxpIPQ7UB/CbdQUT9No5EUl21QRD0eQvTUaA7x6fair83IdApZcPMyHaDxHfV
	kkU3sywOCo2w1J2EKuSkJp8c5ZSqq/us5oyBCI6Hh8XmHZf10YBs8aUjaJtShHZ/
	6vqa0dvL83AB/9mK2Z3B3svy+GblpFaAyggihv7c+nfDxxZBDmzHufwdmAJEYWLE
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0U_sX8ssz3pO; Mon, 11 Aug 2025 15:47:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c0zYH2WtKzlmm8s;
	Mon, 11 Aug 2025 15:47:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/4] ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
Date: Mon, 11 Aug 2025 08:46:56 -0700
Message-ID: <20250811154711.394297-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
In-Reply-To: <20250811154711.394297-1-bvanassche@acm.org>
References: <20250811154711.394297-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The UIC completion interrupt may be disabled while an UIC command is
being processed. When the UIC completion interrupt is reenabled, an
UIC interrupt is triggered and the WARN_ON_ONCE(!cmd) statement is hit.
Hence this patch that removes this kernel warning.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier=
 to analyze")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3e94364f45d5..12af4e0824ce 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5561,7 +5561,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
=20
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
-	if (WARN_ON_ONCE(!cmd))
+	if (!cmd)
 		goto unlock;
=20
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
