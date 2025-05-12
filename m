Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F4C1411DE
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 02:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747018346; cv=none; b=uIHBcyqtAsnPxfOaIrTeIh//kwzonzLwQuga0FvJj5N/EdMGzJ9Bkghek0+COiwyN2pn/vss+Dr5eE04TEap3Nt8dLDzh+WSrZ7zZqZLntDcVB2wFHYPGJZVn3ZVF8LSck39V/kgIIKhtd4CQM2KfB9IM03mWNqm/ZiCHlm/3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747018346; c=relaxed/simple;
	bh=utyiP6vyElN81PyIMsK+us/AfakfjIQqniyhKu7KeNE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=ZDEqI6llGig9FZkuyYGH1oQhKOyqiRAG3aRia3wQACCr27uIjNzTbVWYI74aBDk7d9ZG0vNSdxncLzAR2FpIbdjN4ZZ1W/7J9OQpA9Cd5waYELYPq6Q7AV8eqNNwztBg98Izb6whIaCRgGjgK9XO7mUvP9/ywh9ePglJ4IBOnyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ToRRi0V0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ToRRi0V0"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250512025216epoutp04c2654249ac42125bbc7168f616c8b740~_p_upKX1V0438404384epoutp04N
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 02:52:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250512025216epoutp04c2654249ac42125bbc7168f616c8b740~_p_upKX1V0438404384epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747018336;
	bh=q00Vv5B7I79wSH/4FeoH2FPbsZ9uHubVAqD5eC+PSk8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ToRRi0V0YSsEFNCvYiKnQU1fni4nD9QAJY2AjSw0xgPeel4IGQhgU8CR5q3fEnP9P
	 89uu1s4qjspIKC4cyE4X31uuBOaZvihuExyZ1sqV1S+j/RaoxQfPJE73DwF/8m0/sC
	 6NwR5mpA9E2wd2qHcwBfeHems/LHexeOsX3sflyo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20250512025215epcas1p1b45c0174b33b0282646bf8691b1f8b5b~_p_uVPfZ50051300513epcas1p1q;
	Mon, 12 May 2025 02:52:15 +0000 (GMT)
Received: from epcas1p2.samsung.com (unknown [182.195.36.227]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZwkfR2hkgz6B9m4; Mon, 12 May
	2025 02:52:15 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250512025214epcas1p273986e3b3bb3451e4039094d21611e86~_p_tXTPQD0738207382epcas1p2a;
	Mon, 12 May 2025 02:52:14 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250512025214epsmtrp25fcc27bc53954952a5831efcc4ee8ddd~_p_tWp8PT0535705357epsmtrp2m;
	Mon, 12 May 2025 02:52:14 +0000 (GMT)
X-AuditID: b6c32a28-46cef70000001e8a-f7-6821625e5444
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F2.1C.07818.E5261286; Mon, 12 May 2025 11:52:14 +0900 (KST)
Received: from wkk-400TFA-400SFA.. (unknown [10.253.99.106]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250512025214epsmtip21fa6e92cdcf182e958a8801c79f2ff27~_p_tKzLMC2663626636epsmtip2a;
	Mon, 12 May 2025 02:52:14 +0000 (GMT)
From: Wonkon Kim <wkon.kim@samsung.com>
To: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: wkon.kim@samsung.com
Subject: [PATCH] ufs: core: Print error value as hex format on
 ufshcd_err_handler()
Date: Mon, 12 May 2025 11:52:10 +0900
Message-Id: <20250512025210.5802-1-wkon.kim@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvG5ckmKGwaVNqhbTPvxkttjYz2Fx
	edccNovu6zvYLJYf/8dksfnSNxYHNo/LV7w9pk06xebx8ektFo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DK6Jmym6ngIWfFm60tTA2Mszm6GDk4JARMJN59juli5OIQEtjNKLF4SzcjRFxC
	YsuXbAhTWOLw4WKIkveMEh/mv2fuYuTkYBNQl1j87iI7SEJEYDajRFv7XbBeZqDeA7dsQWqE
	BYIlfsx7yAJiswioSnxs+c8OYvMKWEj8WtgLFpcQkJfYf/AsM0RcUOLkzCdgcWagePPW2cwT
	GPlmIUnNQpJawMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjOCS1NHYwvvvWpH+I
	kYmD8RCjBAezkgjvVAb5DCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Kw0j0oUE0hNLUrNTUwtS
	i2CyTBycUg1MXoHv1znM830TteJK2YV5F/e/vZ261uagca/zT4tNHflfPZVD73qcXX316Ikf
	pTUZL5b9cVCZdjWK+Z6lha7ecwVVs5NTZ2h+1Jj16HDV04/pjfIPkl5zMKz5sz0n0Fkx9KJo
	/n6G00f/3TsTMVXwCKPdtO98uVXVprY+989nes9vmVDfIfh626OqGjWn3HVf3e61+U7apXoz
	nTNEgG/vJsO3O3dwNTTsOn8+bK3qbdlJAb39FQdXNdvYz+ybe+bvJ+fr6iHC/k9W2X308pBs
	EnrVmPlWsvHrdEZVC9m255Ey5lM4j3260Thx+3ytqIMFi2L27T6y+nfApmPf2DNjOPxfz9mt
	5nmz9u1296UlL5VYijMSDbWYi4oTAa8w4s+4AgAA
X-CMS-MailID: 20250512025214epcas1p273986e3b3bb3451e4039094d21611e86
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250512025214epcas1p273986e3b3bb3451e4039094d21611e86
References: <CGME20250512025214epcas1p273986e3b3bb3451e4039094d21611e86@epcas1p2.samsung.com>

From: wkon-kim <wkon.kim@samsung.com>

It is better to print saved_err and saved_uic_err in hex format.
Integer format is hard to decode.

[ 1024.485428] [2: kworker/u20:13:28211] exynos-ufs 17100000.ufs: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 131072; saved_uic_err = 0; force_reset = 0; link is broken

Signed-off-by: Wonkon Kim <wkon.kim@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5cb6132b8147..eb0ce35a7a9c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6572,7 +6572,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	hba = container_of(work, struct ufs_hba, eh_work);
 
 	dev_info(hba->dev,
-		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
+		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = 0x%x; saved_uic_err = 0x%x; force_reset = %d%s\n",
 		 __func__, ufshcd_state_name[hba->ufshcd_state],
 		 hba->is_powered, hba->shutting_down, hba->saved_err,
 		 hba->saved_uic_err, hba->force_reset,
-- 
2.34.1

