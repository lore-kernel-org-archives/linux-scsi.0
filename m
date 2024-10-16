Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437D1D279F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113178; cv=none; b=reoSp2WqzhS78K+DTs1JYHmEDxGGFOF/WCbgnEkFVPE7gy0TIWaqNMV6PsidTa5RdChE/aDB7r5LY9Ds8HyMGPf5CmmRc1bRIjpFS8pfSwc9SnSNO/NZUV96Dh7bGYYdPBXvObVXoib/tCyMjQmGXUh8Kz+srLlMfgJNV3dxTI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113178; c=relaxed/simple;
	bh=4Z01ptLYSzWaPXOr6l+W4/ZeDoalwg/aNw3tgGvRGfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjbuyNH7tR0Wje7tK+zjxBne2FZAcgzJRi+P9OZoI0gXz/ol0t4gWYERqS+rKzw8V51Y5GafE0OyHBN8y2mOtLpZWVbjpOnmbyQJv+yz5Eo4M+ppjKVr6C9T1D0MN9w7MtFygy2Vv6uLTHLSpSNmfSmHz1AJYnK+j20tEDkC37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x5W612Ff; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x5W612Ff"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNwS0CrJzlgTWP;
	Wed, 16 Oct 2024 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113171; x=1731705172; bh=FEZsY
	5uU9ZoiQOPqT0Ib37TqckLwQNK+AYTabt0KI7Y=; b=x5W612FfMWgJks/MUNeUa
	Bmyps7Rb890n7TUB5xnqqZwTpKWmNDsguGqxJ0RZZdfSITdq7eGKQtcSvAuuQz7j
	p8QPjIxhfw7HfVaw1ZIagH7KY8ULiVFD7BIue+eFvKVv284IctZFnlaG8KCgwYLc
	QHvliW2wdxPZTqzkGsiMI+hKRCocFGHw4uQtgn377x22b168Y0pXMSl7pdzgALtz
	915ZbaXVFdiT72aqeWKX+PkCXzDkYWfvp8JmFghOJhssL2TBlcHm4YW+fgGaA9qn
	h8lNh4Q7VtJQQ/4ozDpQIFEsQthILSe4PKLY09M95HhkUH3hcULH6cV5ZMaT1WwD
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dszaMM2oJAlI; Wed, 16 Oct 2024 21:12:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNwJ5mglzlgMVr;
	Wed, 16 Oct 2024 21:12:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>
Subject: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Date: Wed, 16 Oct 2024 14:11:17 -0700
Message-ID: <20241016211154.2425403-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016211154.2425403-1-bvanassche@acm.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From the UFSHCI specification: "CleanUp Command Return Code (RTC): host
controller sets this return code to provide more details of the cleanup
process. It is valid only when CUS is 1." Hence, do not read RTC if the
CUS bitfield is zero.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ ab=
ort")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 57ced1729b73..bef4c53f9c06 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -538,7 +538,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
 	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	struct ufs_hw_queue *hwq;
-	void __iomem *reg, *opr_sqd_base;
+	void __iomem *opr_sqd_base;
 	u32 nexus, id, val;
 	int err;
=20
@@ -572,14 +572,12 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int =
task_tag)
 	/* SQRTCy.ICU =3D 1 */
 	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
=20
-	/* Poll SQRTSy.CUS =3D 1. Return result from SQRTSy.RTC */
-	reg =3D opr_sqd_base + REG_SQRTS;
-	err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20,
-				MCQ_POLL_US, false, reg);
+	/* Wait until SQRTSy.CUS =3D 1. */
+	err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20, MCQ_POLL_US,
+				false, opr_sqd_base + REG_SQRTS);
 	if (err)
-		dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%ld\n",
-			__func__, id, task_tag,
-			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
+		dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%d\n",
+			__func__, id, task_tag, err);
=20
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err =3D -ETIMEDOUT;
