Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C721CF8F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952893; cv=none; b=MmwCmpN7DajUk2pXTPX0hJJe5zRHIOvtl7owxdv12Fssa7NXq4Ok0rEWU7ZMpYTnQDlLvOr9p7MUIwzUVJMHtFMP+16A8q28isi+gNFa2417Fv5EKxAN88ojw8RJBewaKN0VfCcCb24nOsV1B2+xijuBpwGcVtrRhztOt8cfRqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952893; c=relaxed/simple;
	bh=iIelxTrUEyCu9m2YbccZUhxOKRIC2Q0+5C60rs2R+S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXmntPe0fkASPpEgFaHKq3f3J1WJEmRHC4cdCs4vJJmKwn4kgiX9+V4hbuZW7ZPHlimIlHrQWiX+JoPYz91bQP14UNP223kIrg1l86MJeVjN/TllVFogHOvmRZHGeW7CIZmuNAixyO1m9UTl39wJyacXT3Mm8cW/hYAZT35xSSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c8Gw72Ts; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c8Gw72Ts"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFF64rT6z6CmQyM;
	Tue,  2 Jul 2024 20:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952884; x=1722544885; bh=iejQk
	SU/hIQcf0C3EA4NXqSVrmp7WFjlGQtyV9AAy1w=; b=c8Gw72Ts0GYF9VbLGUGeV
	Aoqcs4P7Xp5XmuZPPa/1fvDlD9/SmpxWmX0U5ApY3d9imv3SiYEgsLpUAmDJFXgt
	kR0yGt3ufvhOJRb/tXBhrq3eE9NiAILsCeB6GjD9qBIjjiuPqDh/HFuk6XDDu6oq
	rCc5W1GhsRf/GPC+K1q3wBNFrmBg2Pf3r5oJvEXD6P4PJ01//YbL40EmxHQ2/gwl
	Xu+APlAKPm34RsTWydFcwvtQ2kmKnyH2oxRgpSQYUAWLHUjQtbcuuJsbQb/VHYK9
	X2x3A4BdeI3XvC2GLIXQMfD79hNnBxKfTbEc2vE79Y2WpCDwOMK98KeGrs/MybnC
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KfEnlreOec-H; Tue,  2 Jul 2024 20:41:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFDz5MZ5z6Cnk98;
	Tue,  2 Jul 2024 20:41:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v4 4/9] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
Date: Tue,  2 Jul 2024 13:39:12 -0700
Message-ID: <20240702204020.2489324-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
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
