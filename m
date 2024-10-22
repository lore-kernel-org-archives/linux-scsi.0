Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A217C98
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625580; cv=none; b=BT0e/cv9SWsQxbbyrIlt1qJBnFL65+RHDQFoW/zcgRxhRh/txJGk7TWDocSvZkpp1RE/jFlam8qpmbK+pw4cMVc1P9491VEH8ValX9O/6ylmd+iVasmxnRvHRb9ahQTePlSSBMxJcZp3oHtVS3hFU61cOtlnrcq9qiexUD2x1kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625580; c=relaxed/simple;
	bh=iFhDpadDTq1M/fi5LZpwWwjxPq0/WLAFbYD+GnYMDmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC5CWAgGoD887AZ1OzgvIqkJf55DxUr/QHVjb1wDTozeg74k2hfg0f1/7oqneEmWxG1n6h6KZ21sSp0xa+fZQUQldzxo0rFnTbhOnkIJ+60PH01al2BNst2rQAnj9TJAxbzAz8KFW6pAhXuZyF2vZMuW4UAH/xOykLep7B5S7rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ggtXw2p8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ggtXw2p8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2QL6vqwzlgTWP;
	Tue, 22 Oct 2024 19:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729625574; x=1732217575; bh=w2uiL
	xtKaJLX55oab5tZy0PTkoSS/6+EcUjV+abbHrY=; b=ggtXw2p8OZ+QOhgLiXgYe
	X16w1vY5eTDp95MXJK9lT9Q27iRYl9FfH4jWncbm0G1bcUj1W4OSH+KjmhBlHGWs
	a8+Mful54bW5E9kt2Pk16Cq5q8bOxb/qKEyNV4KEpW0VEf4hzlglluQhqJwwV2Xi
	AxuqfjNlNJwPXxGNzswCoNA2YsQHGXkRsF0rC18hWDmy5DV/hpuhvlAE4RqetM6A
	KPo+wjRxZlQgj56Lz5UMZCrsqusgK0oq6mati+FmZVKHzwJn+uCf/ifPrCsXgsHT
	pY4aJzq2+7hDITNNoJKkVa9QSIoUWobP+AwzQZHQ6uNN6cpMHyvUb7cN1dN5Pm6W
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VPl9yyWj-_Dz; Tue, 22 Oct 2024 19:32:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2QB1wqZzlgTWQ;
	Tue, 22 Oct 2024 19:32:49 +0000 (UTC)
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
Subject: [PATCH v2 6/6] scsi: ufs: core: Improve ufshcd_mcq_sq_cleanup()
Date: Tue, 22 Oct 2024 12:31:02 -0700
Message-ID: <20241022193130.2733293-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufs-mcq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 57ced1729b73..988400500560 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -572,14 +572,18 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int =
task_tag)
 	/* SQRTCy.ICU =3D 1 */
 	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
=20
-	/* Poll SQRTSy.CUS =3D 1. Return result from SQRTSy.RTC */
+	/* Wait until SQRTSy.CUS =3D 1. Report SQRTSy.RTC. */
 	reg =3D opr_sqd_base + REG_SQRTS;
 	err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20,
 				MCQ_POLL_US, false, reg);
 	if (err)
-		dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%ld\n",
-			__func__, id, task_tag,
-			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
+		dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%d\n",
+			__func__, id, task_tag, err);
+	else
+		dev_info(hba->dev,
+			 "%s, hwq %d: cleanup return code (RTC) %ld\n",
+			 __func__, id,
+			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
=20
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err =3D -ETIMEDOUT;
