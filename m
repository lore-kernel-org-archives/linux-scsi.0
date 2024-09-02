Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794A1152196
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725250687; cv=none; b=hZQLw0AwhnDdRUJq/M9XaVFnGfb5L9kcMBg4Hb8oErkiq4NnY7HRjUO56jIXW78DVtrv9w8SKVtEp563KXeRVgEnfmQM7ySWUuZ93lNgixQWJ+QmVWBrhx0I7iyLQzmH861miEQyEBmoga8U07Lk2tKGehrR3fZxRCuJJauf3jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725250687; c=relaxed/simple;
	bh=SLB2/n/nVuA46cQ/nrPKgQvFJHJlg0ae/1y9NyFE3iw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=U0by5gtglKwlPdZjgIkXxFcdPhJmq5A8UXKdBaIEi/2hRdxtnLJGABoTFKWBnh1d0yHGtNQRBXyJTLE7ovIORHXk2fgjdpkcVso9UXmReQAglTN+2doOQqBIyMBHaS0Rm77L7c5pdn4rYiwkI6Y7Bpq6vqjoi4Vu/Rz8u84FP78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uBf89/N1; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uBf89/N1"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240902041757epoutp039a02d8a74d6bd9036c732071cf0b51dc~xUlmkjeI73259432594epoutp03r
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:17:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240902041757epoutp039a02d8a74d6bd9036c732071cf0b51dc~xUlmkjeI73259432594epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725250677;
	bh=hMJFpPWKRoBweCzBGULW99EK+8CPtkTfrp94G07YkkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBf89/N1ltAY8pPogo+hUjU0G/MIMLVkrfpCXoM4t6B6lkfJZ4xx81PaMz27rHJG0
	 aIITyDjUgUrXj3U6mLjennFeS2wIR4o+fmn3LQLStAZ3pLDRtQbFMb5Xbfoepwhuk4
	 MoFx5Q267zSVpvvF+sqPr4cN7cxfIrMt3diDlzlA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240902041756epcas2p4e71476f86676f29e36fee9fefdae0f49~xUll4y_a21563615636epcas2p4U;
	Mon,  2 Sep 2024 04:17:56 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.97]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WxwTb4J4gz4x9Pt; Mon,  2 Sep
	2024 04:17:55 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	38.F3.10012.37C35D66; Mon,  2 Sep 2024 13:17:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240902041755epcas2p316730258dc0c2ed2b3f9744722dcde9c~xUlkr4rhU2654126541epcas2p3_;
	Mon,  2 Sep 2024 04:17:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902041755epsmtrp1e7332b7fc1c06f731afdfbd31444c98a~xUlkrDQdu3022030220epsmtrp1G;
	Mon,  2 Sep 2024 04:17:55 +0000 (GMT)
X-AuditID: b6c32a47-c43ff7000000271c-e6-66d53c73f451
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.F8.08964.37C35D66; Mon,  2 Sep 2024 13:17:55 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902041754epsmtip29d650fc9aaca8e738d509d634954021c~xUlkfQGxK0320303203epsmtip2Q;
	Mon,  2 Sep 2024 04:17:54 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
	bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
	beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com,
	hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v2 2/2] scsi: ufs: ufs-exynos: implement
 override_cqe_ocs
Date: Mon,  2 Sep 2024 13:26:46 +0900
Message-Id: <041c7204703ed2ee7563344e935921dffa34ccfb.1725251103.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1725251103.git.kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmmW6xzdU0g5YXchYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxc0tR1ks
	Lu+aw2bRfX0Hm8Xy4/+YLJb+e8tisfnSNxYHQY/LV7w9ds66y+6xeM9LJo8Jiw4wenxf38Hm
	8fHpLRaPvi2rGD0+b5LzaD/QzRTAGZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxA
	rzgxt7g0L10vL7XEytDAwMgUqDAhO2PPpXVMBee5KpruL2drYHzP0cXIySEhYCJxeN0bJhBb
	SGAHo8Szd95djFxA9idGiXVbjjFBON8YJTq332WD6fh2/QEjRMdeRomNN/Mgin4AdRw+DTaK
	TUBT4unNqWDdIgItzBIXNv0C62YWUJfYNeEEWJGwQJBE56n57CA2i4CqxO/r61hBbF6BaInm
	u8eZIbbJSyxq+A1WzylgKbH32leoGkGJkzOfsEDMlJdo3jqbGWSZhMAVDokTE9YwQTS7SLzo
	OMoOYQtLvDq+BcqWknjZ3wZlF0us3XGVCaK5gVFi9avTUAljiVnP2oH+5ADaoCmxfpc+iCkh
	oCxx5BbUXj6JjsN/2SHCvBIdbUIQjcoSvyZNZoSwJSVm3rwDNdBD4siy6dAQ7WGUOL3sKPME
	RoVZSN6ZheSdWQiLFzAyr2IUSy0ozk1PLTYqMIbHcHJ+7iZGcNrWct/BOOPtB71DjEwcjIcY
	JTiYlUR4l+65mCbEm5JYWZValB9fVJqTWnyI0RQY2BOZpUST84GZI68k3tDE0sDEzMzQ3MjU
	wFxJnPde69wUIYH0xJLU7NTUgtQimD4mDk6pBibumYfzzh/7u9asdk/Ak3SZ2IeVrmej3f1O
	uqU37l7F67p2mkKSmNYryZXzzumkt7a19uiUH0vxPZr1t7WtMkMiPm1t06lEjbhfirUP5v5/
	N8Xsx6ppuvPOJx/ILRBPOsfM1h++n3+zzFLBxBOH781d/DSjLqXO1sR0ac5JLZc/4VF7dx09
	+dDTvHWjcc7lry2Rb+9ftWeffZNh/ocr6v3+nasELzy9+D25NZffcG6s311bJgllzmThD0sd
	flpNjDx7SefTbf/tixRsOU4JsOxo3WRwfOuJwzXV17gdGC11lfzLnRNez7lnw1o1Ve+HXJ8S
	Y9pdLRuulexnRa/7/i48wZPd2LI18KvqapZwJSWW4oxEQy3mouJEAGIe1nFkBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXrfY5mqawcLF7BYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxc0tR1ks
	Lu+aw2bRfX0Hm8Xy4/+YLJb+e8tisfnSNxYHQY/LV7w9ds66y+6xeM9LJo8Jiw4wenxf38Hm
	8fHpLRaPvi2rGD0+b5LzaD/QzRTAGcVlk5Kak1mWWqRvl8CVsefSOqaC81wVTfeXszUwvufo
	YuTkkBAwkfh2/QFjFyMXh5DAbkaJEzfus0MkJCVO7HzOCGELS9xvOcIKUfSNUWLHmyVgRWwC
	mhJPb05lAkmICMxglmjo3MoMkmAWUJfYNeEEE4gtLBAgMfdIPwuIzSKgKvH7+jpWEJtXIFqi
	+e5xZogN8hKLGn6D1XMKWErsvfYVrEZIwELiROd3doh6QYmTM5+wQMyXl2jeOpt5AqPALCSp
	WUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeYluYOxu2rPugdYmTiYDzE
	KMHBrCTCu3TPxTQh3pTEyqrUovz4otKc1OJDjNIcLErivOIvelOEBNITS1KzU1MLUotgskwc
	nFINTF4h2xZ8NT+4apKO7/xtrSvm//WIzNh1fb3S4vlL7zZ52K8quMzjkP1tqq5Plbao+LJ5
	MtGP5pscEJxisONL5LV9c6dcZLnPWjm7QyHsaeUTzfv22owr/mfWbpuwX6/o9An32w7L2i+9
	n3l1h8s13v5LF9V/zrx5Y7KOzqX//sbTdnf+3dzkXvNfbFvdxdxS9ajny9ve9dRu1RYuzfvh
	z/vq67IFL7zKAi/o73+5wlOs1jkpJ+HA/+UFU0VmSrs7zijq2toy4Wl+RLzvp8ztv9bHRNze
	v/Xe+UOvr5wRv39m7cXL7T19sg/eKlZ08K1I/BETfD4q93DGV/2pXH7hS5ZwN3zp6ErJTDFr
	/3cxnKNOiaU4I9FQi7moOBEAmXHcTSADAAA=
X-CMS-MailID: 20240902041755epcas2p316730258dc0c2ed2b3f9744722dcde9c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902041755epcas2p316730258dc0c2ed2b3f9744722dcde9c
References: <cover.1725251103.git.kwmad.kim@samsung.com>
	<CGME20240902041755epcas2p316730258dc0c2ed2b3f9744722dcde9c@epcas2p3.samsung.com>

Exynos host reports OCS_ABORT when a command is nullifed
or cleaned up with MCQ enabled. I think the command in those
situations should be issued again, rather than fail, because
when some conditions that caused the nullification or cleaning up
disppears after recovery, the command could be processed.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 16ad3528d80b..7ff0e84adaab 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1376,6 +1376,13 @@ static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
 
 #endif /* !CONFIG_SCSI_UFS_CRYPTO */
 
+static enum utp_ocs exynos_ufs_override_cqe_ocs(enum utp_ocs ocs)
+{
+	if (ocs == OCS_ABORTED)
+		ocs = OCS_INVALID_COMMAND_STATUS;
+	return ocs;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -1926,6 +1933,7 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
 	.fill_crypto_prdt		= exynos_ufs_fmp_fill_prdt,
+	.override_cqe_ocs		= exynos_ufs_override_cqe_ocs,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
-- 
2.26.0

