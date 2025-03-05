Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B91F5836
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160477; cv=none; b=qqfVUirD/0hn+0qBJAEtdxh8FB6j4q7owI4lmxVGcKETLCkjcOaZs1Ltk7MchlY6FXXg2ptsJ98ETlOVUD/rv8kgPI4PjXd7pO/O2CZLSKMsaj6+tQs3fLnibACMPJDfVIld+DA6c7crEXef+Vn1vFcCkPJkDvYve+NUKlHxNAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160477; c=relaxed/simple;
	bh=c1jF8VgdgkfHTLPxodOdP2vobseecovl+ipLVNFikMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=aGL9aQqXO/zUs5yYWJkmogzlJGvu5wh9Tdc9HCOnDEmNWK9XN0eR1frMIdKe74Q3Bnoifn3yF6s11HX8OBgbkFVfs9wVMg7p6CHIMsG4VKJgQH5jDtiDmOQFIaEdgmKISlDAwNMeT+YOc9XQ1nZwX1/GJ6BFnjbJFiat2E+vqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qBt5Xg4l; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qBt5Xg4l"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250305074112epoutp021a808b39847d9df9366d513ea3c49693~p2Dl110nv1951419514epoutp02h
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 07:41:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250305074112epoutp021a808b39847d9df9366d513ea3c49693~p2Dl110nv1951419514epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741160472;
	bh=pCo8WDBEk53gpMdz9UuHxhWVBEhTC2PLq5nlEZFZMis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBt5Xg4lavrQY9EsVbfmvrtg8vUk4W5RIEAobgqyBAIeBvgyOR5slQhHDSdTuTY6H
	 oBxck9YIGJx3fx1By1Xa56aE6v9prP8qnjwV1oOZYyLxPhYm0L1R3hVNxTXyHmel+m
	 D4DLXUrwiQNzcIPyLtfR2nD6GbJN6B1T90NqIAWs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250305074111epcas5p1e5edf83318ac28cadb6cd6f4c90ffaac~p2DlYBT0j1133011330epcas5p16;
	Wed,  5 Mar 2025 07:41:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z74H9742Bz4x9QF; Wed,  5 Mar
	2025 07:41:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1E.F4.19956.51008C76; Wed,  5 Mar 2025 16:41:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250305063902epcas5p25cc1df91006f1bb35ea782ec430b6d4b~p1NT8vb7v2012220122epcas5p2P;
	Wed,  5 Mar 2025 06:39:02 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250305063902epsmtrp186bab5405ccc7260f85ac3c2a461a3a7~p1NT7a_fz2258822588epsmtrp1u;
	Wed,  5 Mar 2025 06:39:02 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-11-67c80015e871
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.22.18949.681F7C76; Wed,  5 Mar 2025 15:39:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250305063900epsmtip1582c8740aa78aebb0515aa22178dde26~p1NSeAAn01091010910epsmtip1F;
	Wed,  5 Mar 2025 06:39:00 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v3 1/2] block: ensure correct integrity capability
 propagation in stacked devices
Date: Wed,  5 Mar 2025 12:00:32 +0530
Message-Id: <20250305063033.1813-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250305063033.1813-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmuq4ow4l0g8U/zSw+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8XeW9oW85c9Zbfovr6DzWL58X9MFncvPmV24PLYOesuu8fls6Ue
	ExYdYPTYvKTe48XmmYweu282sHl8fHqLxaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ5yZtoml4JRoxdZ1s5gaGL8J
	djFyckgImEgc+LSaqYuRi0NIYDejxJS/31kgnE+MEh+PnmGEcL4xSmx938MK0/Ln51ZWiMRe
	RomZs+6xgCSEBD4zSpw4pgZiswmoSxx53grUzcEhImAt8f61OEg9s8BZRom/jf9ZQOLCAskS
	N5fpgpSzCKhKPJ79GGwMr4CFxI9FG1kgdslLzLz0nR3E5hSwlPi1dQYzRI2gxMmZT8BqmIFq
	mrfOZgaZLyEwk0Pi5fFrbBDNLhKbrx5ihLCFJV4d38IOYUtJvOxvg7LTJX5cfsoEYRdINB/b
	B1VvL9F6qp8Z5E5mAU2J9bv0IcKyElNPrWOC2Msn0fv7CVQrr8SOeTC2kkT7yjlQtoTE3nMN
	ULaHxOs9r6FB3cMocXdvA+MERoVZSP6ZheSfWQirFzAyr2KUTC0ozk1PLTYtMM5LLYdHcnJ+
	7iZGcMrV8t7B+OjBB71DjEwcjIcYJTiYlUR4X586ni7Em5JYWZValB9fVJqTWnyI0RQY4BOZ
	pUST84FJP68k3tDE0sDEzMzMxNLYzFBJnLd5Z0u6kEB6YklqdmpqQWoRTB8TB6dUA5OJLCfL
	vpu3zh8onNOSGKFRftdWWOru+88hJY99maLlJeckOLyR69o+SXuZ7tnEHt6cC1+enPf89fwm
	+6QD2ora/jypb8T45N9dT2TrvH/JKXjPnKcL4mbpZIX9CVf1+Wjw39nH5qvSs6MFBi9eMv7M
	nyj77d25x/Kzcrce+TF30V77P5tL/4tY9CsfvPvEUvOaY02JWfXMX4F/Qrl6u6yjeXfKnrr6
	yXOBJvepE9c3xuttfFt6oO5cqJ+NX7ZbalZG7IVH95/q7L4vlMtlYshlJftyavviLXNi045v
	mZ62bv5V28v9qye85UxYy/N9h2GziPuWe93aGdWJFpMKF2tn/A4xUHfeqJyuMfXJxm9KLMUZ
	iYZazEXFiQDSbB6kQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnG7bx+PpBhe+slp8/PqbxaJpwl9m
	i9V3+9ksFiyay2KxcvVRJou9t7Qt5i97ym7RfX0Hm8Xy4/+YLO5efMrswOWxc9Zddo/LZ0s9
	Jiw6wOixeUm9x4vNMxk9dt9sYPP4+PQWi0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBlnJm2
	iaXglGjF1nWzmBoYvwl2MXJySAiYSPz5uZW1i5GLQ0hgN6PExI8drBAJCYlTL5cxQtjCEiv/
	PWcHsYUEPjJKfNvHDWKzCahLHHneClTDwSEiYC9x70cFyBxmgcuMElNefWEFiQsLJEpsm2cG
	Us4ioCrxePZjFhCbV8BC4seijSwQ4+UlZl76DjaeU8BS4tfWGcwQqywk5qzYwQhRLyhxcuYT
	sHpmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnBM
	aGntYNyz6oPeIUYmDsZDjBIczEoivK9PHU8X4k1JrKxKLcqPLyrNSS0+xCjNwaIkzvvtdW+K
	kEB6YklqdmpqQWoRTJaJg1OqgWm/NO/r3PgTblVSZwujv2ReZU1bqpA7V/tnuN3ctX9vyC/f
	1/WBm3fyNvmHyQ5LzYtt79s3fn0b7xKf8v9r2p/XiXl5lRGTN6mc7y683pvVcC0+q9+s/3UD
	28QN3+5tOsbG3NIu+Hbpm5hexWvR1y+YfpWckM0rKc66VmKVxZwLBw8ybL2/uCZeYn3ZOfvm
	ujP7Z3qK3f/k8i53dt82xumsTtk2v9NdapVObkuL73n8NtAkfmqXQeOnWr3p65/scqxfFyDU
	UHMtMsOicVpt7gzuyjdbvpSIejcsrmrTb4z4Z+9VadnRtk83xe7nrxOR1T52BcbWkvl/9VYV
	t5bd4arj+z1hF2Nr5C0T3eu1SizFGYmGWsxFxYkA+zUGVvgCAAA=
X-CMS-MailID: 20250305063902epcas5p25cc1df91006f1bb35ea782ec430b6d4b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250305063902epcas5p25cc1df91006f1bb35ea782ec430b6d4b
References: <20250305063033.1813-1-anuj20.g@samsung.com>
	<CGME20250305063902epcas5p25cc1df91006f1bb35ea782ec430b6d4b@epcas5p2.samsung.com>

queue_limits_stack_integrity() incorrectly sets
BLK_INTEGRITY_DEVICE_CAPABLE for a DM device even when none of its
underlying devices support integrity. This happens because the flag is
inherited unconditionally. Ensure that integrity capabilities are
correctly propagated only when the underlying devices actually support
integrity.

Reported-by: M Nikhil <nikh1092@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-settings.c | 50 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..d0469a812734 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -859,36 +859,28 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
 		return true;
 
-	if (!ti->tuple_size) {
-		/* inherit the settings from the first underlying device */
-		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
-			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
-				(bi->flags & BLK_INTEGRITY_REF_TAG);
-			ti->csum_type = bi->csum_type;
-			ti->tuple_size = bi->tuple_size;
-			ti->pi_offset = bi->pi_offset;
-			ti->interval_exp = bi->interval_exp;
-			ti->tag_size = bi->tag_size;
-			goto done;
-		}
-		if (!bi->tuple_size)
-			goto done;
+	if (ti->flags & BLK_INTEGRITY_STACKED) {
+		if (ti->tuple_size != bi->tuple_size)
+			goto incompatible;
+		if (ti->interval_exp != bi->interval_exp)
+			goto incompatible;
+		if (ti->tag_size != bi->tag_size)
+			goto incompatible;
+		if (ti->csum_type != bi->csum_type)
+			goto incompatible;
+		if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
+		    (bi->flags & BLK_INTEGRITY_REF_TAG))
+			goto incompatible;
+	} else {
+		ti->flags = BLK_INTEGRITY_STACKED;
+		ti->flags |= (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE) |
+			     (bi->flags & BLK_INTEGRITY_REF_TAG);
+		ti->csum_type = bi->csum_type;
+		ti->tuple_size = bi->tuple_size;
+		ti->pi_offset = bi->pi_offset;
+		ti->interval_exp = bi->interval_exp;
+		ti->tag_size = bi->tag_size;
 	}
-
-	if (ti->tuple_size != bi->tuple_size)
-		goto incompatible;
-	if (ti->interval_exp != bi->interval_exp)
-		goto incompatible;
-	if (ti->tag_size != bi->tag_size)
-		goto incompatible;
-	if (ti->csum_type != bi->csum_type)
-		goto incompatible;
-	if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
-	    (bi->flags & BLK_INTEGRITY_REF_TAG))
-		goto incompatible;
-
-done:
-	ti->flags |= BLK_INTEGRITY_STACKED;
 	return true;
 
 incompatible:
-- 
2.25.1

