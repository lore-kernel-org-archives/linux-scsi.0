Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5DB65F
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 03:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715829967; cv=none; b=WD+L2hu4YoFTp6mzBjWuATcHHLycVUCfddiXwBqB7UvbBmQwVz2Jovx36FStoxKtOkQfYOkogPOy+SB7BxoeCbSDXCdlWjJrGiv4JOTNMGdnR9OfimZPJNzjB+x/6xHKxxr6H72AwQQZM943X+Ua6ZpY4VXTgfSjfhsp1w5Y8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715829967; c=relaxed/simple;
	bh=Fj9DFQbUIHz++fbxS9Gb93DcDizppZYPSDVmzUo6mYs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=bKwwpOreJHAE+4qLk4yewONgJzGr1PrSTIhe4N2/20szJ5SOkg6UuLrdTPABmrL1pKPUGc/PG7LPDZ3j+0+luvZEQFwiKpMyEGkqsE9LEriTzwiLvxBPLs/Ox+2GrCtlpscJXMWLh01UTNqxzpwi4+tJjgsmKFxEUxljuwoP8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BHmfPTvS; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BHmfPTvS"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240516032555epoutp03909b8b5cbc7238110da2fb79cecf7143~P2kDkgcP21782617826epoutp036
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 03:25:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240516032555epoutp03909b8b5cbc7238110da2fb79cecf7143~P2kDkgcP21782617826epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715829955;
	bh=RVQ/+Lsjjx2p15g745Qf4Umsx247PWwm8nk3ogxPp2I=;
	h=From:To:Cc:Subject:Date:References:From;
	b=BHmfPTvSadGgoo+ZzSbakfy7RaQKO+qhbLPKmwnikcYBYHyGL5NdODRQSXZXzUtSv
	 5CJGSsegsfQK6/6IRsAalCgZzFktSA6cCtvG/zuI78GcL8h+0a+asWXpbfg+54v27d
	 z3opoOb4Y6oWuOUPnMRgBMYt+MOG174a9p4dsya8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240516032554epcas2p2d86e41d5685adb5bbf161c56cdec7939~P2kDGcvG50494604946epcas2p2b;
	Thu, 16 May 2024 03:25:54 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VfwTt0GNKz4x9Q0; Thu, 16 May
	2024 03:25:54 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0A.31.09673.1CC75466; Thu, 16 May 2024 12:25:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356~P2kBzKd970613006130epcas2p3N;
	Thu, 16 May 2024 03:25:53 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240516032553epsmtrp20d14534e6924a6ada1f43016c58e5e92~P2kBxuSeZ0411704117epsmtrp25;
	Thu, 16 May 2024 03:25:53 +0000 (GMT)
X-AuditID: b6c32a45-a89fa700000025c9-79-66457cc1670d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B3.B6.09238.1CC75466; Thu, 16 May 2024 12:25:53 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240516032553epsmtip2a5cc07a4ec700d70fc0eb8cf97e19007~P2kBhReN12157021570epsmtip2Y;
	Thu, 16 May 2024 03:25:53 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joel Granados
	<j.granados@samsung.com>, gost.dev@samsung.com, Minwoo Im
	<minwoo.im@samsung.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH] ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n
Date: Thu, 16 May 2024 12:14:05 +0900
Message-Id: <20240516031405.586706-1-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqe7BGtc0g00zrCwezNvGZvHy51U2
	i2kffjJb3Dywk8li6f6HjBYb+zksLu+aw2bRfX0Hm8Xy4/+YLJ6dPsBssbBjLosDt8flK94e
	0yadYvP4+PQWi8fEPXUefVtWMXp83iTn0X6gmymAPSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJ
	rVJqQUpOgXmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsaktm62gvVCFW93d7M0MC7i72Lk5JAQ
	MJGYt+krM4gtJLCDUeLtdYUuRi4g+xOjxOK3DxghnG+MEgsObmCF6fi05DozRGIvo8SmObOY
	IJzfjBILe94zgVSxCahLNEx9xQKSEBF4zyhx//ZTdhCHWeAUo8Tn++2MIFXCAp4Sj1vug21n
	EVCVmN2+gw3E5hWwlli0vYkFYp+8xP6DZ5kh4oISJ2c+AYszA8Wbt84Gu0NC4Cu7xNM365kh
	Glwk1q1ZwAZhC0u8Or6FHcKWkvj8bi9UvFzi55tJjBB2hcTBWbeB4hxAtr3EtecpICazgKbE
	+l36EFFliSO3oLbySXQc/ssOEeaV6GgTgpihLPHx0CGo/ZISyy+9htrjIXHxxGQ2SPDGSjx4
	e4l1AqP8LCS/zELyyyyEvQsYmVcxiqUWFOempxYbFRjCIzU5P3cTIziRarnuYJz89oPeIUYm
	DsZDjBIczEoivCJpzmlCvCmJlVWpRfnxRaU5qcWHGE2BoTuRWUo0OR+YyvNK4g1NLA1MzMwM
	zY1MDcyVxHnvtc5NERJITyxJzU5NLUgtgulj4uCUamCasfF/UMOJ+59indzPCx5+Zigfk2Px
	u/tU56F1ytcn28Wdk3+nNaNMSkZl14RzPbNr7y1s+XPpZrNc/CbWr1eblmfplez4ZOOpE8u/
	aGsh140UG4MsTet7E1pmNJdsSxNbbbju1JO2NmeH9hcbK7svnVC8s3/tu+USTG6z3nnkeisH
	njWpfnrw9/UzHvtep/+uzC16b51uIK0/6+Xkj1xOJyXufGj+x/XcwDjP4XDErJ3m069/nPTo
	/U7rKf+P7L5nE7oube573Re73ITqGfbbVlSeV5mlOocv3W71bf9c07O6Ok8vmkv61X9lYfl3
	MFvuSw8Pq+3muqQNJ8TjA/3dNMOjcpS7mZYnvj2p+fKSEktxRqKhFnNRcSIAltpcOC0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvO7BGtc0g8c9/BYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxdP9DRouN/RwWl3fNYbPovr6DzWL58X9MFs9OH2C2WNgxl8WB2+PyFW+P
	aZNOsXl8fHqLxWPinjqPvi2rGD0+b5LzaD/QzRTAHsVlk5Kak1mWWqRvl8CVMamtm61gvVDF
	293dLA2Mi/i7GDk5JARMJD4tuc7cxcjFISSwm1Hi9a+XLBAJSYl9p2+yQtjCEvdbjrBCFP1k
	lDh9dCpYEZuAukTD1FdgtojAR0aJpReKQYqYBS4wSsz59IkZJCEs4CnxuOU+mM0ioCoxu30H
	G4jNK2AtsWh7E9Q2eYn9B88yQ8QFJU7OfAIWZwaKN2+dzTyBkW8WktQsJKkFjEyrGCVTC4pz
	03OTDQsM81LL9YoTc4tL89L1kvNzNzGCw1tLYwfjvfn/9A4xMnEwHmKU4GBWEuEVSXNOE+JN
	SaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyWiYNTqoEp5HRZFcfmzclM
	mzc7hB08xZnpqbmNw37ViYpHZ5fMXmTslM1XO1Hl8ku2p8blD3YWz58otaiq6MYJkdVme9Ke
	HeRZZXl295eKfbNPWezmfJVWJ5X/T2XyntT/R38t/yA9mX1zm4WuBWfnbA7VBfws4ROVVha5
	PuFr99L9Uv36n53E5RMyc6a5F8/Zke/TpXjOgeHYu18Z1qfbcy7azVCV+L3vsvubw3fkbvcx
	zM/L3tC+ulP+/7o72czX+/enKCd2xuqZaQTcOX90Da/xyQ/aJwtYb8zUU3NI82CbI/vrSazY
	m9qu/08C5hkqBp8yioh2uK4bMX21/tRiH4HXqisjv6158EJkTaB+hOQelaJNSizFGYmGWsxF
	xYkAp+hCdN4CAAA=
X-CMS-MailID: 20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356
References: <CGME20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356@epcas2p3.samsung.com>

The MCQ_OPR_OFFSET_n macro has taken 'hba' on the caller context
without receiving 'hba' instance as an argument.  To prevent potential
bugs in future use cases, this patch added an argument 'hba'.

Fixes: 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and runtime interface")
Cc: Asutosh Das <quic_asutoshd@quicinc.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 768bf87cd80d..1cfdda9acb0a 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -231,7 +231,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 
 /* Operation and runtime registers configuration */
 #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
-#define MCQ_OPR_OFFSET_n(p, i) \
+#define MCQ_OPR_OFFSET_n(hba, p, i) \
 	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
 
 static void __iomem *mcq_opr_base(struct ufs_hba *hba,
@@ -343,10 +343,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->sqe_dma_addr),
 			      MCQ_CFG_n(REG_SQUBA, i));
 		/* Submission Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQD, i),
+		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(hba, OPR_SQD, i),
 			      MCQ_CFG_n(REG_SQDAO, i));
 		/* Submission Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQIS, i),
+		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(hba, OPR_SQIS, i),
 			      MCQ_CFG_n(REG_SQISAO, i));
 
 		/* Completion Queue Lower Base Address */
@@ -356,10 +356,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->cqe_dma_addr),
 			      MCQ_CFG_n(REG_CQUBA, i));
 		/* Completion Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQD, i),
+		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(hba, OPR_CQD, i),
 			      MCQ_CFG_n(REG_CQDAO, i));
 		/* Completion Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQIS, i),
+		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(hba, OPR_CQIS, i),
 			      MCQ_CFG_n(REG_CQISAO, i));
 
 		/* Save the base addresses for quicker access */
-- 
2.34.1

