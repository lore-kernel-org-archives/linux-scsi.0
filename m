Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C33074AC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 04:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760416857; cv=none; b=WhRe/PH7O6GQcPvCkL8eTYAGOXhFYTT5Y8ldMTMa+y5VRsdU9UgZvTd2lpX6RMHHJ1PtLk/zCWEeTtJnEaB9Kzgp85xXtxKps50I8o9BrVKWtRHx6i4KKFTclyDm7KZOsodzwoa1XT34CwtGcCIHd/HWvD2gGGPMLil+khC5488=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760416857; c=relaxed/simple;
	bh=KUxW6iAxc6H7/nCAR7ECOt0zB4dKihg1Q3xgWUAUT/k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=VEjF6TG3Xxup1+3CfQbZKagFHWGQEMwyNbyw7KOb9WlD5Z7QYD9TBziyLhOM6iEvt2IWGOV9qMKvo66AUTeF5/vfSmYq6E+YFGr1rUAE8G0qAAY6Zon0FLpA3SDZmgnSDnen3UAfLS+kPtpX4AExCahgxhZ1i3LU2w5uampP67w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RquUvabK; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RquUvabK"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251014044052epoutp04bf36c4eafc3a068f9f77d933b792ceaf~uQczW4SEj1495514955epoutp04d
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 04:40:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251014044052epoutp04bf36c4eafc3a068f9f77d933b792ceaf~uQczW4SEj1495514955epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760416852;
	bh=2MR/8dxpB2IhRZ4n8hezSuVVh7SAOSL0lQTXjlIHnzU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=RquUvabK+S/WspXtm8tteotYeAGETa8flAGUQQcsC4IlQYwaFZNGCqBQq2GIxdA4u
	 QwYH/homRXjmnXI5sED6YLMe0IsNp1yYmNHT8lY7QrevXk2LHIjZ9Zdg9a334wBMAu
	 akz1IXknOmApvfNmssuXkdNfmt26i0QUdDAzFWds=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014044051epcas1p2ab96c914b58ada43ae851f3f55d28b09~uQcyxqMx31110611106epcas1p2r;
	Tue, 14 Oct 2025 04:40:51 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.190]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cm1kC3gGZz3hhTL; Tue, 14 Oct
	2025 04:40:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca~uQcyDY-t-3052130521epcas1p3d;
	Tue, 14 Oct 2025 04:40:50 +0000 (GMT)
Received: from wkk-400TFA-400SFA.. (unknown [10.253.99.106]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251014044050epsmtip2be8db9a228e5b9f38031acaf1a521548~uQcx_hsCo2356223562epsmtip2U;
	Tue, 14 Oct 2025 04:40:50 +0000 (GMT)
From: Wonkon Kim <wkon.kim@samsung.com>
To: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, peter.wang@mediatek.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wkon.kim@samsung.com
Subject: [PATCH v2] ufs: core: Initialize a value of an attribute as
 returned by uic cmd
Date: Tue, 14 Oct 2025 13:40:46 +0900
Message-Id: <20251014044046.84046-1-wkon.kim@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca
References: <CGME20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca@epcas1p3.samsung.com>

From: wkon-kim <wkon.kim@samsung.com>

If ufshcd_send_cmd() fails, *mib_val has a garbage value.
A value of an attribute can have an unintended result.
ufshcd_dme_get_attr() always initializes *mib_val.

Signed-off-by: Wonkon Kim <wkon.kim@samsung.com>
---
v2:
It is better to check ufshcd_dme_get() return rather than
to initialize argument.
And ufshcd_dme_get_attr() always initializes *mib_val.

 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9a43102b2b21..6858f005cc8b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4273,8 +4273,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			get, UIC_GET_ATTR_ID(attr_sel),
 			UFS_UIC_COMMAND_RETRIES - retries);
 
-	if (mib_val && !ret)
-		*mib_val = uic_cmd.argument3;
+	if (mib_val)
+		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
@@ -4990,7 +4990,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
 {
-	int tx_lanes = 0, i, err = 0;
+	int tx_lanes, i, err = 0;
 
 	if (!peer)
 		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
-- 
2.34.1

