Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2115575C
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715372; cv=none; b=fgnw9KvK6C+w5B/y0nWfXT3Jz+ewlb3G6aTtiR84UDP0qO/ir3ZNDVfmDvmU5l/zp3Cbm5esxLUyR7WKeq2mpIJR2J/2kYgg0tV6e1FpAqGJuKcGucevohOYZW2zXyb9h0db6NtIS8MRwk8BiaHw50PNKb4nQmPAEpV2X3dRwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715372; c=relaxed/simple;
	bh=CdiSyc3UJ/WhIY6m41JoKtF/D+07nIc3nBsyjhSvnPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIS3qVwG8LdHWGAgd05LzR6Rci9UBR1bMsa9tIHGj1c01vqC6CqmWHFOpIhyDmmEXaYh+rh26EPudripnB3Dae97YIggv35rSxxp+ygMWIak8l6dMc1dGoFEqqYZQ7Z9QMcXt46dUcUp1y4bnwaPcsMYiD5M3SqSvzuScmJ8y6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RR6DEH8/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RR6DEH8/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF7s4Vnbzm0yTx;
	Thu,  3 Apr 2025 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715368; x=1746307369; bh=fMrHI
	Q3ONQ+El6AsLrZd/WYp0ZRI7WCxz0rnFvRAn/I=; b=RR6DEH8/1u/Q5+y78s7Tn
	sWchUKs23W0ht2pSaBcJJjz7vA2BwlmHACD+LyWUOpfWddbxBwchcNrnISmT0jJA
	nv9Hv+CgimgdwI7XhJBrZCPGEj+/D4UMrYabqOzBUa1Rp3DJPA0LMKWSE12m9RCw
	fJ9JX25HcIrC8Dnn6Y+MOk/HpEKSkv10YYUjSZjS4Nf/lOuamotBRQN53eBZA9CP
	P6JW5QFzoYWTOob8sfGFLq48EdNtHTO/92GEY5lN3EELRFODD7B4z4eybF07yt/9
	mk0Y/2MJoqVHnZXRgZo5xFH4M4vxTcbbsq3Ef8non81vbt1NUU5Lr3Hi/FpAxXRJ
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ul2Sk8MT0t0g; Thu,  3 Apr 2025 21:22:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF7j58cPzm0ySc;
	Thu,  3 Apr 2025 21:22:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 17/24] scsi: ufs: core: Call ufshcd_mcq_init() once
Date: Thu,  3 Apr 2025 14:18:01 -0700
Message-ID: <20250403211937.2225615-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make sure that ufshcd_mcq_init() is called once even if ufshcd_alloc_mcq(=
)
is called twice.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index acbf173a3732..6dcac4143f4f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8733,9 +8733,16 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, u=
32 ufs_dev_qd)
 		return ret;
=20
 	hba->nutrs =3D ret;
-	ret =3D ufshcd_mcq_init(hba);
-	if (ret)
-		goto err;
+	if (hba->host->nr_hw_queues =3D=3D 0) {
+		/*
+		 * ufshcd_mcq_init() is independent of hba->nutrs. Hence, only
+		 * call ufshcd_mcq_init() the first time ufshcd_alloc_mcq() is
+		 * called.
+		 */
+		ret =3D ufshcd_mcq_init(hba);
+		if (ret)
+			goto err;
+	}
=20
 	/*
 	 * Previously allocated memory for nutrs may not be enough in MCQ mode.
