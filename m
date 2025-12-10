Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF222BEFE4
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348749; cv=none; b=aLfuXWDgHzxrqLWS7aD2cmWXYdwVoamSphBuSNmiB7jH98Bq3lLQwPo5c3IR9jK0o3kG2yfSP0ASZ5ZADBK4WDRy5Hcle4AKfF3QTJnZXFdA+88caB2VZABJkadEo8ts8jfzLuZ3HhfPd/E89UsSBuSbhiJmtieIwm2dkbgJG8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348749; c=relaxed/simple;
	bh=Kz859QFqaTjFiTHmrk3Yej0UWmo4u+H2a+DUHXEGifU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hGhNCPasiL4iVwMVOrRjSosqHnViTeMjq2y1gezxkf+8p2M6LOhU3Yhp4h+R1rv4AZFSXIMUo8NiKZa/nF0hCg1jSb/hRtkLlukiI8KoHD5cttWQJeJ9rqr7So0gwsXSK60gBI3ZJWMqYiMbwsUp3Izf1H0MpJ4lp2XWpmZlMjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lIF+U8II; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lIF+U8II"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251210063904epoutp0244c5c96bac9d00be69f2779cc2ad85c8~-x1RomV5Z2782527825epoutp02Y
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:39:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251210063904epoutp0244c5c96bac9d00be69f2779cc2ad85c8~-x1RomV5Z2782527825epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1765348744;
	bh=4UpQQu60XCHY8zQhF5/tqP6wgLjIJizjaVn9/DDpb9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIF+U8IIsbZxP12KcPQVCPvCPl5CUWlf+SRiJNFZ1MFr+kI+ZHyh5X9TdmptBUvwZ
	 V7oXtfHPq9KGvBPePDvahVouLFin9Z9QzUFt5e9E7IpUIIo63NfuGD1p6df3HVv4wX
	 TRy0NuTJsiH62rYjEHIRq5yPZUN9MllnVhIRMJjU=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20251210063903epcas1p233735f9f8f0947601800ce6ae7db9f24~-x1RLwUk02707827078epcas1p2J;
	Wed, 10 Dec 2025 06:39:03 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.196]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dR5fH3s3tz6B9mD; Wed, 10 Dec
	2025 06:39:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251210063902epcas1p3651acbf49d4f8c456d4f3419f4649371~-x1QVPOtZ1892418924epcas1p3u;
	Wed, 10 Dec 2025 06:39:02 +0000 (GMT)
Received: from baek-500TGA-500SGA.. (unknown [10.253.99.239]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251210063902epsmtip2b742042cd6b78dcf7a43a53a5eee0899~-x1QOqNuG0421904219epsmtip21;
	Wed, 10 Dec 2025 06:39:02 +0000 (GMT)
From: Seunghwan Baek <sh8267.baek@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, beanhuo@micron.com, adrian.hunter@intel.com,
	quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, sh8267.baek@samsung.com
Cc: stable@vger.kernel.org
Subject: [PATCH v1 1/1] scsi: ufs : core: Add ufshcd_update_evt_hist for ufs
 suspend error.
Date: Wed, 10 Dec 2025 15:38:54 +0900
Message-ID: <20251210063854.1483899-2-sh8267.baek@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251210063854.1483899-1-sh8267.baek@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251210063902epcas1p3651acbf49d4f8c456d4f3419f4649371
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251210063902epcas1p3651acbf49d4f8c456d4f3419f4649371
References: <20251210063854.1483899-1-sh8267.baek@samsung.com>
	<CGME20251210063902epcas1p3651acbf49d4f8c456d4f3419f4649371@epcas1p3.samsung.com>

If the ufs resume fails, the event history is updated in ufshcd_resume,
but there is no code anywhere to record ufs suspend. Therefore, add code
to record ufs suspend error event history.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Cc: stable@vger.kernel.org

Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 040a0ceb170a..6bb2781aefc7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10337,7 +10337,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	ret = ufshcd_setup_clocks(hba, false);
 	if (ret) {
 		ufshcd_enable_irq(hba);
-		return ret;
+		goto out;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
@@ -10349,6 +10349,9 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
 	ufshcd_pm_qos_update(hba, false);
+out:
+	if (ret)
+		ufshcd_update_evt_hist(hba, UFS_EVT_SUSPEND_ERR, (u32)ret);
 	return ret;
 }
 
-- 
2.43.0

