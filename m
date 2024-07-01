Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F93BBF5
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719857097; cv=none; b=jd+qAFIaFvtq6vXw9wUAAz+xO3WQjrPI8u/zbly+kEvAAbrs8KwmHFSolyVhMQjASlxl++ncKcbaOGSA8BvymoJrVhxnY0qgpQCgBGYm0KF/t/FIR0oW74CWgr8i2oUILbA+HnwIp2UemGAP6JrVuGtVGnNbzMzNnxRRJZA3zTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719857097; c=relaxed/simple;
	bh=OgIeVabUMDuPt0iUW7YeN3R0YtW106gGUffenvD5/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwuLo3KcubAOMsip9MPYBkagYrmmdNFXw77dHIaAgSE8jwrUc8NnM+shB2eBrPhIfdKpjwootus3g5Uu2Ynw2lPACEH/HLSR1FN2fB557m1G3jBksGVs+GAXqBtUD7Idwj0wJChrmby5SbmeV01vll8b8E0aiOkPN13sK1HR56s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LKm9SLJO; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LKm9SLJO"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCYpv6r1Pzlffm0;
	Mon,  1 Jul 2024 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719857092; x=1722449093; bh=nEIW5
	4z3HJ8mnYvQg/ltIEcS9Uayyo0dvbu4ds/IGUw=; b=LKm9SLJO8LIoou5Dh0xbh
	WExw73kk4KIszfwVZ1E00yX2X9pT7/ewGPEtVEFPNa90eT/t9pFhCmfVCpOQ3wpT
	tHlgtVSHa/1pw0VdLZ/b78/LHaZZWPMFNQF+WYpxypE5Q08QV353xxdmXwufSmT+
	Gb3n9j8e6Gf0a1zg11uXv0iUR0wIGuDsEwghbgcn9Qd3Kke1GgyDVrJyXjM1FftG
	SpfwJOCdNFLByA0DXhItY3WdQonFouQb/7TZ1t77KgRVsV78MZ/10NxYLWsiLAcK
	zNylA9L/Bje/K9gCYHSCpMPsBczQV1MHW/KKbot8WZQe24BwY5997h69SmfielHN
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fTSK2T2x89cp; Mon,  1 Jul 2024 18:04:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCYpr0rSPzllCSD;
	Mon,  1 Jul 2024 18:04:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v3 4/7] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
Date: Mon,  1 Jul 2024 11:03:32 -0700
Message-ID: <20240701180419.1028844-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240701180419.1028844-1-bvanassche@acm.org>
References: <20240701180419.1028844-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Rename this constant to prepare for the introduction of the
MASK_TRANSFER_REQUESTS_SLOTS_MCQ constant. The acronym "SDB" stands for
"single doorbell" (mode).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 include/ufs/ufshci.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9a0697556953..2cbd0f91953b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2401,7 +2401,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 		hba->capabilities &=3D ~MASK_64_ADDRESSING_SUPPORT;
=20
 	/* nutrs and nutmrs are 0 based values */
-	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
+	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
 	hba->nutmrs =3D
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
 	hba->reserved_slot =3D hba->nutrs - 1;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index c50f92bf2e1d..8d0cc73537c6 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -67,7 +67,7 @@ enum {
=20
 /* Controller capability masks */
 enum {
-	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS_SDB	=3D 0x0000001F,
 	MASK_NUMBER_OUTSTANDING_RTT		=3D 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
