Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAE412FB3B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719478271; cv=none; b=MhISLgeW6R3bP/Ekg/xlAFfdoeGx42yQMyWB0828jsF9HvGtxtuC7MnS2VBODPWV3B2x/to+EFNno9m05pPQ/Zk9iKhvM8uNNIKHI/XJpZOl9jhCWQVOTkXvacGJMY6wdr5rjpS60gZfdyX/wS1IuluxVv/q+QvcIri/6v1HlLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719478271; c=relaxed/simple;
	bh=31MdeFt3NaD/DUlfUtyo68L0T5JiFj4zF4UHdp6NF6w=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=ApsI2d4bS037ca6qKPdF/cZ7Vn28DXjmf1c/MKJkRo68pVg2UKKuXrqfSAjKEj4PHO7gStF0JqxYBs8JhG8WJkp/to1vjNW+aYQEqvHpNWisXXRjCZFDzoEGWEvCv9MUDklApVavOe01zgfcpT0mjeMyCRyJPMy83FpcyRUp3Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FBI84Bdp; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FBI84Bdp"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240627085105epoutp023137c4f887443622b26ba38683773af5~c0F8w_5mp0163901639epoutp02m
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 08:51:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240627085105epoutp023137c4f887443622b26ba38683773af5~c0F8w_5mp0163901639epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719478265;
	bh=ADqanESsDlibWSwv/tm8/kU1E2ba6IJ0GdVOx+ZTTSo=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=FBI84BdpvE/HYrcK9ct6PfCeojs/31xjJDeojljy7WHa9UFSwBi9rOXigrLnR21Xw
	 /ed+sxiAp8LaqCAGODkmNGmXAt2/SpNIrdAllxcXOhN5ImC6uLe8VtMNTH5hgEoubY
	 D36HhTT5/jYQs9dyY7X7C+VWeR+TUlpLco/qjQ+E=
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.42.77]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240627085104epcas2p15fea5b3ea431397f6a436fca01e7019b~c0F8e-BAO0844408444epcas2p1L;
	Thu, 27 Jun 2024 08:51:04 +0000 (GMT)
X-AuditID: b6c32a4d-001ff700000262f0-e2-667d27f85197
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.F9.25328.8F72D766; Thu, 27 Jun 2024 17:51:04 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] ufs: core: Remove scsi host only if added
Reply-To: k831.kim@samsung.com
Sender: =?UTF-8?B?6rmA6rK966Wg?= <k831.kim@samsung.com>
From: =?UTF-8?B?6rmA6rK966Wg?= <k831.kim@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?UTF-8?B?6rmA6rK966Wg?= <k831.kim@samsung.com>, =?UTF-8?B?7J6E66+87Jqw?=
	<minwoo.im@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Date: Thu, 27 Jun 2024 17:51:04 +0900
X-CMS-MailID: 20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWy7bCmhe4P9do0g6+nlCw29nNYTNn0ldGi
	+/oONovlx/8xWTw7fYDZgdVj2qRTbB4fn95i8ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	i1P2shbM4q/YdfsDYwPja54uRk4OCQETiamdu9m6GLk4hAT2MEosXfeAtYuRg4NXQFDi7w5h
	kBphASuJfY9PM4HYQgJyEtfnd7NCxM0l/qzbwghSziZgKrF1oR7IGBGBSYwS/7+/ZAFxmAWW
	MEp0frrGCLGMV2JG+1MWCFtaYvvyrVBxDYkfy3qZIWxRiZur37LD2O+PzYeqEZFovXcWqkZQ
	4sHP3VBxKYm22b+ZIOxqickLFkH11kisfTsVyjaX+H1/N9jRvAK+Eos3nQc7mkVAVeL7Vi+I
	EheJS3fusYHYzALyEtvfzmEGKWEW0JRYv0sfxJQQUJY4cosFooJPouPwX3aYp3bMewJ1gJJE
	+7arrBC2hMSziRegDvaQuLRmJQskBAMlNp19xjaBUWEWIpxnIdk7C2HvAkbmVYxSqQXFuemp
	yUYFhrp5qeV6xYm5xaV56XrJ+bmbGMFJRMt3B+Pr9X/1DjEycTAeYpTgYFYS4Q0tqUoT4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkznuvdW6KkEB6YklqdmpqQWoRTJaJg1Oqgcl6Z7JfyEYbuYWT
	Ju0O/XRj5o+Ui9dua6ZmvmxqZqhKCXVMSbl/wcXxy0krpnnMTy1C2auUT+tkz7x4mT22uPDx
	4g+StZHr52TPahFyP+G+t/t8jJyA2YfPUsa6B0q/J5leiXz85tLr/uvMN2fZ86p23o7akObu
	fdtiF8vb1AMeIoYc7LuVwluf+q8ty6ye57p865LCTfM43cwz+FkuLUyalflbMVBwQ9Wiz+de
	it+b+Pd5pfHVCQ8zNpwoXsJ18qeqSXBM4/fzhU2PdjbfOGTE0ScXsHZi/H/GNVtl0vjnb/wZ
	s9bePsng8mGWTjd9B0PdWfenccm8qzJwYLWxNe+3rX9odej5Vou/zMJHBZVYijMSDbWYi4oT
	AUeFW+iRAwAA
X-CMS-RootMailID: 20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7
References: <CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>

If host tries to remove ufshcd driver from a ufs device, it would cause
a kernel panic if ufshcd_async_scan fails during ufshcd_probe_hba before
adding a scsi host with scsi_add_host and MCQ is enabled since scsi host
has been defered after MCQ configuration introduced by Commit
0cab4023ec7b ("scsi: ufs: core: Defer adding host to SCSI if MCQ is
supported").

To guarantee that scsi host is removed only if it's been added, set the
scsi_host_added flag to true after adding a scsi host and check whether
it's set or not before removing the scsi host.

Signed-off-by: Kyoungrul Kim <k831.kim@samsung.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a0f8e930167d..101aa08195ce 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10359,7 +10359,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -10638,6 +10639,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			dev_err(hba->dev, "scsi_add_host failed\n");
 			goto out_disable;
 		}
+		hba->scsi_host_added = true;
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
@@ -10720,7 +10722,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 out_remove_scsi_host:
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
