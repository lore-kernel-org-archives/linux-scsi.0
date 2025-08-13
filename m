Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8C12857C1
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755102222; cv=none; b=aiSvRVLGobcGxSSN+lO2Qr7pIgPwGTM4KEc6C2mYBNY+K0nIqhWyMPv5/sSwZfLO4s8ZbxkpnM8dviet3jTSdgzdi66fKvITAGfBBDYTkK/xtLKQ7TDyQMKAcMjrioCr3ybN9rOUSSIvx2DPTlMcHP5YSU0dHu1eBw4qb1QJKq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755102222; c=relaxed/simple;
	bh=H6QgnX8fEUpZSKXBZXGlJoPjP0gAxYPVxBppU2wMHdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOLvqihUhhDe8dPMlunJ0Qh+xzgP8ceZFYmQ+4/3kFtCzOMuWgQDLJEH5eLfqSjELIapgy4eGiNjoGQsbX1YRdImfw7DRKCuOO1A2odxXaHWah0L4q7/dXL1K37Q+lby7ZtF0mieHyJc4x5V9Bq0Li234AiN9n/KTBkj/iphIbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WEcDezrl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WEcDezrl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2DFm17mHzm0yQt;
	Wed, 13 Aug 2025 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755102217; x=1757694218; bh=gRQB+
	pZhWzq0W9nf3Cr4qJnZ/Gr1jdVwrAcYYCYFTXY=; b=WEcDezrlxW9kvDXD8qqyX
	U/qE+uQaHxUhDokfP9Kvh9ooNjn8DyyYW2+3attYWgzbxoquHTnhsPqM7g5UNV4v
	qZRhlOSExw3Z9AUUUGD4q3Hbwz7KJ7hV97almmJa4P003tMLv9p4OrE2u0VvGTYB
	9gCMPfuXU1fobL6GOytUCQnuRmFO5/2ls1argObfh8G43TCDlxb+plvw06T/2qfV
	odmNXB67745BXj2KLp6LjFzL2HA1Jfc9h4PIm2/cq+q1CevushUUPgoUzhJz8CtK
	t/vY52dFmjkfwqp1ct2UwBx7hUN3EtL/uJaYrA43tYnMdDGlXPRPmT0k4hSlTKd0
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N8CNQFpFp1h9; Wed, 13 Aug 2025 16:23:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2DFY0x90zm0yR0;
	Wed, 13 Aug 2025 16:23:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 2/4] ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
Date: Wed, 13 Aug 2025 09:22:36 -0700
Message-ID: <20250813162253.3358851-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813162253.3358851-1-bvanassche@acm.org>
References: <20250813162253.3358851-1-bvanassche@acm.org>
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
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ec4e860f5c53..8ebacf5dd959 100644
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
