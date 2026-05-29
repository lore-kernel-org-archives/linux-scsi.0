Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B913F3A5435
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 06:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035317; cv=none; b=MNfjwvuZiTOnvmDr89cxR/ewwoa5tjL7h+g7sUq9J2sjLtX9q1Ytvjew3IsqYR03byVqD2gciuu/Iwy0RvDK/jvN4XbB4R9yDNr+aoj53GURjxflXSzkIiu0I0xCniqIN3Vp4TpoLCkygoGu2SNIkWa8qfhRY+xibaPKQVK9CPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035317; c=relaxed/simple;
	bh=bEPmgqr1UhfNeylnfnEM6LJMNEmzKcgdZUv2nud8qRw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=cgrHsshXIQrpRL+1UvkGNgH3iLwwse420y97Z5z0lkRZExKqmNzNpxqLWAuM34/j7US2Ks1/MCIxOvJyQhGSGHCHgTSBCoCyjantKf+P64vYtQGwys6a3vySL35PI/tF8ZG5XcihhGUnJ7KmRYOAl74GFNfain2FWLhDwpxCnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DI4Yyj4J; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DI4Yyj4J"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260529061507epoutp0457ab06ec5b6264f3e0c8c2da47f09a47~z9K5i9KHA1930719307epoutp04R
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 06:15:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260529061507epoutp0457ab06ec5b6264f3e0c8c2da47f09a47~z9K5i9KHA1930719307epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1780035307;
	bh=QwvcALVIYPDg4tBjb8yo/huYuwjyv8VST+84b2T6+eU=;
	h=From:To:Subject:Date:References:From;
	b=DI4Yyj4JCYIDKnCFyQBwKZkZ1NdEuWDSXJDzZv0+OzkP3syP62sHfVCNHdreauI0A
	 dxPR1J3+WE/pTBlJTjeqHg0o7cKxGP7oni4UPKWLp+M8iJ3aUC8aDlF1r/iK61InDY
	 X/srrvD+t6YfpHQmLq1GTkGLysOk+z0XEsKa3tyM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20260529061507epcas1p3b47540a1cc6243ebb50aa575d3b35ca0~z9K5FzLuw1356913569epcas1p36;
	Fri, 29 May 2026 06:15:07 +0000 (GMT)
Received: from epcas1p2.samsung.com (unknown [182.195.38.193]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gRY4B63x7z6B9mD; Fri, 29 May
	2026 06:15:06 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf~z9K4QqiNi2861428614epcas1p2x;
	Fri, 29 May 2026 06:15:06 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260529061506epsmtip26e4f74a4e1c12724a6ca4d3967bf5d67~z9K4KD2K_0967509675epsmtip2X;
	Fri, 29 May 2026 06:15:06 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean Huo
	<beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, "Rafael J.
	Wysocki" <rafael.j.wysocki@intel.com>, vamshi gajjela
 <vamshigajjela@google.com>, Chanwoo Lee <cw9316.lee@samsung.com>,
 linux-scsi@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST
 CONTROLLER DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Remove unnecessary return in void vops wrappers
Date: Fri, 29 May 2026 15:15:00 +0900
Message-ID: <20260529061503.301182-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf
References: <CGME20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf@epcas1p2.samsung.com>

ufshcd_vops_exit(), ufshcd_vops_setup_task_mgmt(), and
ufshcd_vops_hibern8_notify() use 'return hba->vops->xxx()'
while other void vops wrappers call without return.
Remove the unnecessary return keywords for consistency.

Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 70f90d97f217..e55c2a02c1f5 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -132,7 +132,7 @@ static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 static inline void ufshcd_vops_exit(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->exit)
-		return hba->vops->exit(hba);
+		hba->vops->exit(hba);
 }
 
 static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
@@ -211,7 +211,7 @@ static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
 	if (hba->vops && hba->vops->setup_task_mgmt)
-		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
+		hba->vops->setup_task_mgmt(hba, tag, tm_function);
 }
 
 static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
@@ -219,7 +219,7 @@ static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
 	if (hba->vops && hba->vops->hibern8_notify)
-		return hba->vops->hibern8_notify(hba, cmd, status);
+		hba->vops->hibern8_notify(hba, cmd, status);
 }
 
 static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
-- 
2.43.0

