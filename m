Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62AA1EB27
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721991024; cv=none; b=CNWMaE1SuGa0eM5iubUH8OHqvtsnV5oRqZi/TNND4K5+J8GNjbMHnV+9Crig2qzOP/KEwq335CEAyA7UNb740ON1GJRxqUWaqAuwyIawxu0OkvUQbjNfQtNHD6T0phse+t+3NEV8IezilnkBWCYFpjeJ5gNv/Qnjz/iOUsFHulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721991024; c=relaxed/simple;
	bh=jGPRczautyuMMj4CcPFfYRBIAc/wsQuQSJqJruFd9Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Nv9cRrsyWBnkN3AlXsgF/s7TQC9zZZaTwl+Z/72MZrhLRR552ls3LD7RJsSv1e39HxGjN9kJ8+YYmXejcVdNWUFtWfv6JpmVUes4zKiMFyHe8wCAc447/mkCcvUzcFeJkOy9EGxk8hj3wJaF5AjttlLSIKQMtLD2qdq1dsDpj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QkEunvA1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QkEunvA1"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240726105012epoutp0271ae4319889206949353a81c07f7ef18~lvbPkvt7S0850608506epoutp02K
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 10:50:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240726105012epoutp0271ae4319889206949353a81c07f7ef18~lvbPkvt7S0850608506epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721991012;
	bh=H5uMvEvG4y3d8iyedbenWXf5zTg9mXTk6BN4CXr3xA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QkEunvA1zUX9/9PDaRCLdQfPTpM0+8OKz+lOMe73ONQKqfp3Q56NyM6SzLAPxEZHF
	 vIme5s3cVwJqhqC1YQO1p8IEMptrsLPvvxM4hvHveeZ1+m1BNV7Gi2YoaVhRTjH6HH
	 VYCycIx60gu61EfuFZVstHABgR5lLJoI3VdBpuR8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240726105012epcas5p3b4e4e6a7078b76fd5636fa607ef3ef25~lvbO_6kpi2185221852epcas5p3j;
	Fri, 26 Jul 2024 10:50:12 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WVkzl06Vxz4x9Py; Fri, 26 Jul
	2024 10:50:11 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	78.99.09640.26F73A66; Fri, 26 Jul 2024 19:50:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240726102916epcas5p10f8e5c7b97ed95887bda7de79a30781d~lvI9FbL2e2814828148epcas5p1F;
	Fri, 26 Jul 2024 10:29:16 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240726102916epsmtrp1996ac98a173fd383a314f7bd61ea24bc~lvI9EvW3-0866008660epsmtrp1s;
	Fri, 26 Jul 2024 10:29:16 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-83-66a37f62c2a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	50.2E.19367.B7A73A66; Fri, 26 Jul 2024 19:29:15 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240726102914epsmtip1e230faaf6160f35cc915b564bec04fe4~lvI8D_rFM1720917209epsmtip1w;
	Fri, 26 Jul 2024 10:29:14 +0000 (GMT)
Date: Fri, 26 Jul 2024 15:51:56 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi
	<joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240726102156.GA17572@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240709071604.GB18993@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmhm5S/eI0g+eLzCxWrj7KZHH0/1s2
	i723tC3mL3vKbtF9fQebxfLj/5gc2Dw2L6n32H2zgc3j49NbLB59W1YxenzeJBfAGpVtk5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0X0mhLDGnFCgU
	kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQndHzWaKg
	XaFi/orKBsZDUl2MnBwSAiYSy558Ye9i5OIQEtjNKLFy0VsmCOcTo8SmBy8Z4Zz5Z/8BlXGA
	teyaEwYR38ko8fv/EhYI5xlQx4mlbCBzWQRUJZZ9ncEOYrMJqEsced7KCGKLCChJPH11Fmwq
	s8B2RokZTeeYQBLCAioS22fcAmvmFdCVmLTuHhOELShxcuYTFhCbU0BHYunfD6wgtqiAssSB
	bcfBbpUQ+Mgu0d1ymAXiIxeJp9//sEHYwhKvjm9hh7ClJF72t0HZ6RI/Lj9lgrALJJqP7WOE
	sO0lWk/1M4PYzAIZEsu2fIeql5WYemodE0ScT6L39xOoXl6JHfNgbCWJ9pVzoGwJib3nGqBs
	D4k7s2cxQ4LoAqPEiUd3mSYwys9C8twsJPsgbB2JBbs/sc0CBjezgLTE8n8cEKamxPpd+gsY
	WVcxSqYWFOempxabFhjmpZbDIzw5P3cTIzh5annuYLz74IPeIUYmDsZDjBIczEoivMvuL0wT
	4k1JrKxKLcqPLyrNSS0+xGgKjK2JzFKiyfnA9J1XEm9oYmlgYmZmZmJpbGaoJM77unVuipBA
	emJJanZqakFqEUwfEwenVAOTKvudZPELRRZM2qtfGt3g6Kz6/OtK/eZFbUf0/07LLclYeimC
	84rols+CvWYxnDUbe99fi1mh/9Ogf9Vuv2lv5LtUxQ8xcpyfkfP2n3BeSx73i+2rk9J7JDfM
	WahmmpE4nY2Vh51d+uHOY6ZG8yRSGCav/nBkntGil0tSd2RMYT+vrLXCm/HAtb1r1/79ui02
	bP8poZ1LNj4L9Fm80P2nx8Xn0+pub71xUcM/NUvstMyWe708GepenUcr1No+Nzet+lC/4d6E
	EhODHcd1gqZy3ncxsXWQPjZHUWLhA2mv/xt7dfs3bihlr685k3JO8ENTmEJmHGf2pNiAmP5K
	MSfLtmO2D1qnMSYJfGMtqnBTYinOSDTUYi4qTgQAtyxLQicEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnG511eI0gzWXLCxWrj7KZHH0/1s2
	i723tC3mL3vKbtF9fQebxfLj/5gc2Dw2L6n32H2zgc3j49NbLB59W1YxenzeJBfAGsVlk5Ka
	k1mWWqRvl8CV0X3hMXPBcdmK51fCGhhnS3QxcnBICJhI7JoT1sXIxSEksJ1R4u/ChcxdjJxA
	cQmJUy+XMULYwhIr/z1nhyh6wijx8d9mNpAEi4CqxLKvM9hBbDYBdYkjz1vBGkQElCSevjrL
	CNLADDL1Y8c0sCJhARWJ7TNugTXzCuhKTFp3jwli6gVGiTnfXrFDJAQlTs58wgJiMwtoSdz4
	95IJ5FRmAWmJ5f84QMKcAjoSS/9+YAWxRQWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUomlpQ
	nJuem1xgqFecmFtcmpeul5yfu4kRHOxaQTsYl63/q3eIkYmD8RCjBAezkgjvsvsL04R4UxIr
	q1KL8uOLSnNSiw8xSnOwKInzKud0pggJpCeWpGanphakFsFkmTg4pRqYDM1jk22VeTvqHgR0
	TOfSXcF8vLAp732jT7t9Z3LY9U8GF8o3vYu0urixdkaFH6eO7l7hyZtXCii1BSfbb7HVZN0s
	/E529cU9Z3fObzvg5F+wlqvq/r/dah21t286hKucbTb7PFNQ/PvWLr8LfUGe0vmHts21+rrZ
	Z3ff7R9LauQrNnBFd7jWT9RX87uXpxHYJZ947KGLLN+q9lDVc63h4ufZZBuMlBk27btsUNAx
	0+Sg+5mZv+/sFVyyhWtpQEz+3OMvBbkfmotsnP2L71SAlUahcukRefYVx4TXqURtfnBrSt80
	Qf17kSe27/714E6F7quJHYrxJ1Pauav2XvVp2rgv5q9lksmGRLfolG4lluKMREMt5qLiRAB2
	JQxw5QIAAA==
X-CMS-MailID: 20240726102916epcas5p10f8e5c7b97ed95887bda7de79a30781d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K_xth5sKcUEfCV0X9aU-k.Br-XWllh-4huxyB_iNSY1rR3o.=_1f5e4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240709071611epcas5p1c5f2b59325d562658522842f89a31861
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
	<CGME20240709071611epcas5p1c5f2b59325d562658522842f89a31861@epcas5p1.samsung.com>
	<20240709071604.GB18993@lst.de>

------K_xth5sKcUEfCV0X9aU-k.Br-XWllh-4huxyB_iNSY1rR3o.=_1f5e4_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Jul 09, 2024 at 09:16:04AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 08, 2024 at 11:35:13PM -0400, Martin K. Petersen wrote:
> > I don't like having the BIP_USER_CHECK_FOO flags exposed in the block
> > layer. The io_uring interface obviously needs to expose some flags in
> > the user API. But there should not be a separate set of BIP_USER_* flags
> > bolted onto the side of the existing kernel integrity flags.
> >
> > The bip flags should describe the contents of the integrity buffer and
> > how the hardware needs to interpret and check that information.
> 
> Yes, that was also my review comments.

Hi Christoph, Martin,

I was thinking something like below patch[*] could help us get rid of the
BIP_USER_CHECK_FOO flags, and also driver can now check flags passed by block
layer instead of checking if it's user passthrough data. Haven't plumbed the
scsi side of things, but do you think it can work with scsi? 

Subject: [PATCH] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the payload. The driver can now
just rely on block layer flags, and doesn't need to know the integrity
source. Submitter of PI chooses which tags to check. This would also
give us a unified interface for user and kernel generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 12 +++---------
 include/linux/bio-integrity.h |  3 +++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8d1fb38f745f..d179b0134e1d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -443,6 +443,11 @@ bool bio_integrity_prep(struct bio *bio)
 	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 		bip->bip_flags |= BIP_IP_CHECKSUM;
 
+	/* describe what tags to check in payload */
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len) {
 		printk(KERN_ERR "could not attach integrity payload\n");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 19917253ba7b..5991f048f394 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1001,19 +1001,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 				return BLK_STS_NOTSUPP;
 			control |= NVME_RW_PRINFO_PRACT;
 		}
-
-		switch (ns->head->pi_type) {
-		case NVME_NS_DPS_PI_TYPE3:
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_GUARD))
 			control |= NVME_RW_PRINFO_PRCHK_GUARD;
-			break;
-		case NVME_NS_DPS_PI_TYPE1:
-		case NVME_NS_DPS_PI_TYPE2:
-			control |= NVME_RW_PRINFO_PRCHK_GUARD |
-					NVME_RW_PRINFO_PRCHK_REF;
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_REFTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_REF;
 			if (op == nvme_cmd_zone_append)
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
-			break;
 		}
 	}
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dd831c269e99..a7e3dfc994b0 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -11,6 +11,9 @@ enum bip_flags {
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 6,
+	BIP_CHECK_REFTAG	= 1 << 7,
+	BIP_CHECK_APPTAG	= 1 << 8,
 };
 
 struct bio_integrity_payload {
-- 
2.25.1

------K_xth5sKcUEfCV0X9aU-k.Br-XWllh-4huxyB_iNSY1rR3o.=_1f5e4_
Content-Type: text/plain; charset="utf-8"


------K_xth5sKcUEfCV0X9aU-k.Br-XWllh-4huxyB_iNSY1rR3o.=_1f5e4_--
