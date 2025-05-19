Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82EB4B1E76
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2025 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747623316; cv=none; b=e4thmvb7YS9guXdRGff5DxxnJmDm+UYeJQ5A9myFurnb68InAUVAlSbmqYqqBsT1EJsDQ/dB4djKrhiuAb3CrlCjHqIx6JOCsvrxF8lkRpETTg36FScQT4NIvpYHhbN9j63KfGkWt+9TcII9Yd72CJWvu7iwPCiSFU7apqOEYoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747623316; c=relaxed/simple;
	bh=dAJUqFlUiU7t/FY5+basqnTiCVZGegoSbGuO7Nvscnc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=OE1ZvlzBqsbK0LCY6wwlRopVRNFqfe3BPGBZiHdeNIp4K6tj0JO0JkW3DI+arBM6OLnSVrlu0ryheyj/xqcdlsVnSMVYE2o9599/wWA/4iw39uHya+DCRGedZ2eVVzKhP+Y3vHWrb+YGorww0Z1irlas2Ha7erU5oPdlmJC9v+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RzuMq3oH; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RzuMq3oH"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250519025510epoutp013db2e59292083d4870b6e9d86acfe0f3~AziRIvZbe1179511795epoutp015
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2025 02:55:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250519025510epoutp013db2e59292083d4870b6e9d86acfe0f3~AziRIvZbe1179511795epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747623310;
	bh=ChUFgxAEw7CGR5BqcUfKWMh9hVPhBwi/jH40Uw0p4mo=;
	h=From:To:Subject:Date:References:From;
	b=RzuMq3oHpJcO1bmvRBYX/LRjLUfMSIFe+Izkn2m6qi0a2zW1opdXRgiHdkxqWJAZx
	 T8jvCvOZc2srT2fUi5u52B3VHGoNPunJBws+Ca66z61wPvSmFT4FYiR9S4aL2rzKMk
	 OQBrppbsORhxbO9k/Vm/sc0aUrU6GV7+rCCXpZCw=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250519025510epcas5p16f160fe564496ed3b780a0a9efc906f3~AziQnyOBH1845818458epcas5p1d;
	Mon, 19 May 2025 02:55:10 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4b12NZ0CCwz6B9m6; Mon, 19 May
	2025 02:55:10 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250519025509epcas5p2bdc884392dafa224289b337c1232daf3~AziQCMQxB0852108521epcas5p2n;
	Mon, 19 May 2025 02:55:09 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250519025509epsmtrp2f8e521a4b3e6c7929b6f100d99e0a5ff~AziQA6CHA0363803638epsmtrp22;
	Mon, 19 May 2025 02:55:09 +0000 (GMT)
X-AuditID: b6c32a2a-d63ff70000002265-9f-682a9d8d6c93
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.B2.08805.D8D9A286; Mon, 19 May 2025 11:55:09 +0900 (KST)
Received: from hzsscr.. (unknown [109.120.22.104]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250519025508epsmtip22234b35ee80c7eded73a8b77ebbcfab3~AziPDPQID0352803528epsmtip2a;
	Mon, 19 May 2025 02:55:08 +0000 (GMT)
From: "ping.gao" <ping.gao@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, minwoo.im@samsung.com,
	manivannan.sadhasivam@linaro.org, chenyuan0y@gmail.com,
	ping.gao@samsung.com, cw9316.lee@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Date: Mon, 19 May 2025 10:55:59 +0800
Message-Id: <20250519025559.1263821-1-ping.gao@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSvG7vXK0MgymtQhYP5m1js3j58yqb
	xbQPP5ktXs5Yymwx41Qbq8XGfg6Ly7vmsFl0X9/BZnG3pZPVYvnxf0wWz04fYLbY+uk3q8Xn
	pwuYHHg9Ll/x9tg56y67x7RJp9g87lzbw+bRcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAGcU
	l01Kak5mWWqRvl0CV8aB22eYCqbxVkzb85SpgfEpVxcjJ4eEgInEpOuXWLoYuTiEBHYzStxe
	vJgFIiEh8bnzDyuELSyx8t9zdoiip4wSr69eYAZJsAmoS/y5fpcVJCEi8J5J4ui9VrBuYYFg
	iT2PjrCD2CwCqhJndi4Hm8QrYC3xeMNpNoip8hL7D55lhogLSpyc+QSslxko3rx1NvMERt5Z
	SFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDngtrR2Me1Z90DvEyMTB
	eIhRgoNZSYR31WaNDCHelMTKqtSi/Pii0pzU4kOM0hwsSuK83173pggJpCeWpGanphakFsFk
	mTg4pRqY7PuybBl5zhbXqSs84GK+qx/xPJvlWeUNu/SFTGpTW8vu1T57H/DzoY/TfLtoHxnx
	tad/XVf38P0adeDk/LQUhUjtkByb67rFtx+3H/6quSdrD5dKluX0qG69FfE3fEWWHziQuVLL
	4fyXMr+bMx/5s8rIRz+47MGnO5PxmLDDTj4Ly5/LzTJMtGt63e2is3UNNykGCbMcXbuwdsJH
	q5R9i6My5l3OKt66o8RL6/eymRN5HjPemLF63R/+PS+f+TycXfGN4+aphW6L9uqbpxX909vy
	rXnXreV7+FYXb43/EWTHPyG2pylVdJvcieMTNdnPlrxkN9/iVPNjetra8zvW6x0wfnq4RH2W
	vff+uxtElViKMxINtZiLihMB6NIrwucCAAA=
X-CMS-MailID: 20250519025509epcas5p2bdc884392dafa224289b337c1232daf3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20250519025509epcas5p2bdc884392dafa224289b337c1232daf3
References: <CGME20250519025509epcas5p2bdc884392dafa224289b337c1232daf3@epcas5p2.samsung.com>

after ufs UFS_ABORT_TASK process successfully , host will generate
mcq irq for abort tag with response OCS_ABORTED
ufshcd_compl_one_cqe ->
    ufshcd_release_scsi_cmd

But in ufshcd_mcq_abort already do ufshcd_release_scsi_cmd, this means
 __ufshcd_release will be done twice.

This means hba->clk_gating.active_reqs also will be decrease twice, it
will be negtive, so delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
function.

static void __ufshcd_release(struct ufs_hba *hba)
{
    if (!ufshcd_is_clkgating_allowed(hba))
        return;

    hba->clk_gating.active_reqs--;

    if (hba->clk_gating.active_reqs < 0) {
        panic("ufs abnormal active_reqs!!!!!!");
    }

    ...
}

Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Signed-off-by: ping.gao <ping.gao@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index f1294c29f484..1e50675772fe 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -674,7 +674,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 	int err;
 
 	/* Skip task abort in case previous aborts failed and report failure */
@@ -713,10 +712,5 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	spin_lock_irqsave(&hwq->cq_lock, flags);
-	if (ufshcd_cmd_inflight(lrbp->cmd))
-		ufshcd_release_scsi_cmd(hba, lrbp);
-	spin_unlock_irqrestore(&hwq->cq_lock, flags);
-
 	return SUCCESS;
 }
-- 
2.25.1

