Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E14503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473488; cv=none; b=AmLdpM1tc69KoboNTFSLDIMQ1P7UF02cBLyZMhhl9iU9zErFe4KRDzqSw40fp7KoBBDAVMTL+IEmFrwoALs2qGYEWiKyfA0V+zwwrnC1JERJDCTZj2cwQmt66yeURrq3xynLZ3uJIDDBwAZG7CtPYof0EMgtYul0Y3lS7Nod56M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473488; c=relaxed/simple;
	bh=wgFC41ALw28xbVLTqP+3Kg96PRcWR4GWO7lu3O1t9TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGFHu4hEdeYEcAuwvcx9BdTAjtYLs7vNxm04JTNuZRCYY+jFAkRK3VsSHXUH7/T24nBcFTo0LAmjs2SJ5JWHcP7NTADtA9cokVGU6ys3GuXlmXleFQLYxDIb4G8C9lJF8ToFZ63ib3CtRN4vQNKY1f34q9suOKon2rTYfEqWAXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bHnozcGY; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bHnozcGY"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxmZ6hGxz6CmM6L;
	Mon,  8 Jul 2024 21:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473482; x=1723065483; bh=RoWIf
	25Y+Ayp3le60uhgK98EibE0ad3TzuWPjx1Up8U=; b=bHnozcGYSR2tTXFIkJH/Q
	eC7La8qSd/CWQlpmdtqonKB5h/p2adlQlPK6cSO/yDXS4gswSxZHJF5DGvLcHJya
	P2ge3Rr5k3LQrRBxPk1CEueINZbuCKvi5znCQOhSxHMEUjfTtlOOW85gkeSbUkQT
	Qvnnule7LhNUeOHEyXwsEDSmZ0M1bLs6QSmJyqpJU07yI7y3Ort1yslchnCQ7NBM
	t1noT3wOp6vhjCGQSUKtH0JQ3XOLFjjX3UBcc85aAphwniLz24Jl3ZuMx9m4SyRn
	eAxSkdjykQMMpzLL68ZVFkfFJDQTGHZAN7RC+7sV6pnUZBK0/pNMQhZGbMig78uu
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id U0Fy_TPs1eDl; Mon,  8 Jul 2024 21:18:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxmR4sBYz6Cnk9N;
	Mon,  8 Jul 2024 21:17:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v5 04/10] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
Date: Mon,  8 Jul 2024 14:15:59 -0700
Message-ID: <20240708211716.2827751-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
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

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 include/ufs/ufshci.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b0445bb5b7a..a7b049deb943 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2402,7 +2402,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
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
