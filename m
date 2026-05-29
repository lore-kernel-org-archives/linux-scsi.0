Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C6332EC5
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 06:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035453; cv=none; b=B7gVK1Jv9xp+AKZemg8KHZ2RvQF1S5fHdtvNLDHaf9GVyVCHlfuT4XrWv3QKivEAwSwfLR7fSloAPZcf3XybNpykXt41p+0MrM3YjBs7m4rt75tSuUzYRCX+WW+HgdXwe1h0M2/6pS6kGxX7lA4z34QbOH3bdHfWOKpr1Z2TvHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035453; c=relaxed/simple;
	bh=QWQiD8LTImqG5J7/blEhvK+w/NATUAjYvLdvRvgY1kU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=DN3r6/on9aQmlb1G7n25+jqWwjfytct3mINg1sorE/rCT8skSIX0H3ZHjK7nlOU+X15Boo+2+eA+3Xtu2nThz7M9LLjGbSi4Dh0+Ij/5yH7SSAmMaDzCZxggbrkdo53ofzN3FMT0g+TFTjZYU04BUKW43mb+8qVWRC6wj9EIidM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RCO06W82; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RCO06W82"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260529061728epoutp03dc96429a7ae6df4963bfedfa57d0d1f4~z9M9KmPxw2905329053epoutp033
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 06:17:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260529061728epoutp03dc96429a7ae6df4963bfedfa57d0d1f4~z9M9KmPxw2905329053epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1780035448;
	bh=jR4aOUXsEh6K83Cy5vBmii4eVqAjU4Kc+M1kAKPWjLc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=RCO06W82bn+g/1yfBbTMKh0ovWLHKlbi69G4CJWy6JM5HHCQklcuTJShLkvYftE5f
	 E+Xo4bmdRDTsDpExov4e1HWmZMtbSKErGKvx5sLPFPOtrOJF9cRjz0MAkcRUh9zwpl
	 BkCcN+EmLsyIIi+b8IoMe3iuHUD4gkBmwGvB7nxI=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20260529061728epcas1p2beed06c0c0c0b017ac4e38910fd2207f~z9M8nwmIB0993609936epcas1p2r;
	Fri, 29 May 2026 06:17:28 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.118]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gRY6w0dDMz6B9mH; Fri, 29 May
	2026 06:17:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20260529061727epcas1p495c499c91420790a225e66263f3fff52~z9M77OILn1984819848epcas1p4-;
	Fri, 29 May 2026 06:17:27 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260529061727epsmtip197c988501edbe7df1a81f9a9f3a8e234~z9M73usyc0186201862epsmtip1U;
	Fri, 29 May 2026 06:17:27 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean Huo
	<beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, Adrian Hunter
	<adrian.hunter@intel.com>, linux-scsi@vger.kernel.org (open list:UNIVERSAL
	FLASH STORAGE HOST CONTROLLER DRIVER), linux-kernel@vger.kernel.org (open
	list)
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: Remove redundant vops NULL check and trivial
 wrapper
Date: Fri, 29 May 2026 15:16:19 +0900
Message-ID: <20260529061623.301291-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260529061727epcas1p495c499c91420790a225e66263f3fff52
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260529061727epcas1p495c499c91420790a225e66263f3fff52
References: <CGME20260529061727epcas1p495c499c91420790a225e66263f3fff52@epcas1p4.samsung.com>

ufshcd_variant_hba_init/exit() check 'if (!hba->vops)' before
calling vops wrappers, but the wrappers already do NULL check
internally. Remove the redundant checks. Also remove
ufshcd_variant_hba_exit() entirely since it only wraps
ufshcd_vops_exit() with no added value.

Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7481c71c71b8..1f914d095adb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9870,28 +9870,15 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 
 static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 {
-	int err = 0;
-
-	if (!hba->vops)
-		goto out;
+	int err = ufshcd_vops_init(hba);
 
-	err = ufshcd_vops_init(hba);
 	if (err)
 		dev_err_probe(hba->dev, err,
 			      "%s: variant %s init failed with err %d\n",
 			      __func__, ufshcd_get_var_name(hba), err);
-out:
 	return err;
 }
 
-static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
-{
-	if (!hba->vops)
-		return;
-
-	ufshcd_vops_exit(hba);
-}
-
 static int ufshcd_hba_init(struct ufs_hba *hba)
 {
 	int err;
@@ -9959,7 +9946,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		if (hba->eh_wq)
 			destroy_workqueue(hba->eh_wq);
 		ufs_debugfs_hba_exit(hba);
-		ufshcd_variant_hba_exit(hba);
+		ufshcd_vops_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
-- 
2.43.0

