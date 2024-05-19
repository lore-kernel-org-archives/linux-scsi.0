Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F773183
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716157574; cv=none; b=LzVBswUaBvHP9ZUEox6UJJLqZTqqYlNG3pxVAgLQVjQa3X6X99udd3pOe0hfCGCSNX55uI5f8hOYKfrAgWpRwIOuDosh3CqtUBEOdg+OHHnlXQoC5W7ovH8Rg/a+Q4az4NG9S3mpEovFnOj17nP03wzprx0Rr6Cx3Vx1nfC4V1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716157574; c=relaxed/simple;
	bh=THb6U/IAXgN0Rni/3oOcLepiryatnwll2o0cHzTm1j0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RHkkenkx6Olt/NEy/u0s+MLudfQgRsCbam/g+Rsn5ZQEdkSLyCuWDTn6ApTewgc8li3+N1o0fCwaAQUUwbL0XXr8EytIdVus7EPHUc/o1kUIQQMQcWOteGt1yo419xN4jds8jyUGna/UBkL0lCu8XznZnS5yVnWhT0Ui6O5L4Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JZXx5QLb; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JZXx5QLb"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240519222609epoutp040a7a0e9381fc42831c3ea149e1f6a913~RBDdw1RqS2393223932epoutp048
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240519222609epoutp040a7a0e9381fc42831c3ea149e1f6a913~RBDdw1RqS2393223932epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716157569;
	bh=XmhBrod8ZQ9l7o6s6kdW19cgXeZ702NdvMq541eOD4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZXx5QLbzBWGYuh9ZYtwZ74XcuIk+EpGSgQ0zJqQrC+fqOiO0DyKtfjcdNvAo8qhb
	 9XHIh5Oy/fb7XD4kIMqvRNhs1NG0nKA3bqj2rfSMvjq8dIUnSvGiKRZQ//97sUt557
	 nr/Z7Ho6e6dwr2kVCmkInsUQmQb6FHmxP4c+Rq5k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240519222608epcas2p35ce9b746575deda673655539d3d1963c~RBDc8bL_V1101011010epcas2p3i;
	Sun, 19 May 2024 22:26:08 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.100]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VjFf73yhDz4x9Pp; Sun, 19 May
	2024 22:26:07 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	42.40.09673.F7C7A466; Mon, 20 May 2024 07:26:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240519222606epcas2p45c250e92bacb3aa0b00f7430ee69884d~RBDbu5ih12320323203epcas2p4G;
	Sun, 19 May 2024 22:26:06 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240519222606epsmtrp219946c2a51082b4f384bcfb86b9e0886~RBDbuI1Wb2869528695epsmtrp2D;
	Sun, 19 May 2024 22:26:06 +0000 (GMT)
X-AuditID: b6c32a45-a89fa700000025c9-71-664a7c7fc8b3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C2.87.09238.E7C7A466; Mon, 20 May 2024 07:26:06 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240519222606epsmtip29dc4334510d7f840828e0f5f939b321c~RBDbfliN40469104691epsmtip2G;
	Sun, 19 May 2024 22:26:06 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche  <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joel Granados
	<j.granados@samsung.com>, gost.dev@samsung.com, Minwoo Im
	<minwoo.im@samsung.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 1/2] ufs: mcq: Fix missing argument 'hba' in
 MCQ_OPR_OFFSET_n
Date: Mon, 20 May 2024 07:14:56 +0900
Message-Id: <20240519221457.772346-2-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240519221457.772346-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmhW59jVeawa6D0hYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxdP9DRouN/RwWl3fNYbPovr6DzWL58X9MFs9OH2C2WNgxl8WB2+PyFW+P
	aZNOsXl8fHqLxWPinjqPvi2rGD0+b5LzaD/QzRTAHpVtk5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0oZJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jE
	Vim1ICWnwLxArzgxt7g0L10vL7XEytDAwMgUqDAhO+PUvlfsBZvEK97fXszSwLhfuIuRk0NC
	wETi36Hd7F2MXBxCAjsYJW482ckC4XxilJi+aAkzhPONUWLzzddsMC2/vz6CatnLKNF/ZysT
	hPObUeLygtVgVWwC6hINU1+xgNgiAh8YJTa9MQApYhY4xSjx+X47I0hCWCBI4k7XBFYQm0VA
	VeJ4wy92EJtXwFri0I4TLBDr5CX2HzzLDGJzCthITLt/nRmiRlDi5MwnYDXMQDXNW2eD3Soh
	MJFDYvKVQ8wQzS4SL3qaWCFsYYlXx7ewQ9hSEp/f7YX6p1zi55tJjBB2hcTBWbeB4hxAtr3E
	tecpICazgKbE+l36EFFliSO3oLbySXQc/ssOEeaV6GgTgpihLPHxEMx+SYnll2Dh5iFx4v5f
	aLj1M0p0/tvGNoFRYRaSZ2YheWYWwuIFjMyrGMVSC4pz01OLjQoM4TGcnJ+7iRGcYrVcdzBO
	fvtB7xAjEwfjIUYJDmYlEd5NWzzThHhTEiurUovy44tKc1KLDzGaAoN6IrOUaHI+MMnnlcQb
	mlgamJiZGZobmRqYK4nz3mudmyIkkJ5YkpqdmlqQWgTTx8TBKdXA5KkRMDvS55KjTp33g/Kp
	35ftaeL6f1M8raSzYv06S/2YozOtoth+ZWXpZh8Tu/G6ZLfDQW2ZrYH2d9hvMOxiWXz1sItq
	/D/eO5pnPPUYQ5zeaN6qMsjlEunV4mHtVP7HtH1JxZGuhVzrq7bUPl3DEzRvr9qx1oq1AbbO
	B/OFg9unGmnkVDMfmHZrUezqdW9d14le4m68a/CmY9/W7rn7bR1PnPr/7dUea4lJi5dyNmyO
	ymvZ1GqreTF4m6xmU+lzjsbjO5kO6/U+uCyz9XCMup8szyL+GzuPr59qsELu+O4b+yd2FnrG
	LXd7rSidH5y2sP/lnfwpizlqly/Y7ul8IzkvuivZ6MHezXaXnuXIK7EUZyQaajEXFScCAJHd
	09s6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSvG5djVeaQdtzY4sH87axWbz8eZXN
	YtqHn8wWNw/sZLJYuv8ho8XGfg6Ly7vmsFl0X9/BZrH8+D8mi2enDzBbLOyYy+LA7XH5irfH
	tEmn2Dw+Pr3F4jFxT51H35ZVjB6fN8l5tB/oZgpgj+KySUnNySxLLdK3S+DKOLXvFXvBJvGK
	97cXszQw7hfuYuTkkBAwkfj99RE7iC0ksJtRYnK3LkRcUmLf6ZusELawxP2WI0A2F1DNT0aJ
	ibNPsIEk2ATUJRqmvmIBSYgIfGKU2NTVAeYwC1xglJjz6RMzSJWwQIDEq5tPwVawCKhKHG/4
	BWbzClhLHNpxggVihbzE/oNnweo5BWwkpt2/zgxxkrXEj62XWSDqBSVOznwCZjMD1Tdvnc08
	gVFgFpLULCSpBYxMqxglUwuKc9Nzkw0LDPNSy/WKE3OLS/PS9ZLzczcxguNBS2MH4735//QO
	MTJxMB5ilOBgVhLh3bTFM02INyWxsiq1KD++qDQntfgQozQHi5I4r+GM2SlCAumJJanZqakF
	qUUwWSYOTqkGph2LMpLq7Fc59X9Prn/65PfV3TZmORpC3CbTA9o5l6/cEfKz51vR9yURR3dE
	FcnsrTirFNOsav5iX8KFl8dUJ8nvUxGtfr/jZuOq9feulOcaVd0QCV17/WVW4+WNJpPU9zrI
	He4uODpz5fTTq5SXPm+KLNXy2cvaI/42ov281oVb3ec7p2SlKtgkX98iXH3r8hSFQ9+ep3h4
	fDolwL6DT8lP8s2LeSc/Oy73XhjTtWOL+IJw6UnCvwKPZq4UlZ5kMC/4g2Sqx8eqF2f4c/xX
	J9+7tOBVg6MtZ8M69XKOWwkvXB8mn36w50HgPImD0qknNFzVWqRURGbsDRZ8fa977TpTn4SD
	5bxFW89Ihb6cpKHEUpyRaKjFXFScCABRBTbs9gIAAA==
X-CMS-MailID: 20240519222606epcas2p45c250e92bacb3aa0b00f7430ee69884d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240519222606epcas2p45c250e92bacb3aa0b00f7430ee69884d
References: <20240519221457.772346-1-minwoo.im@samsung.com>
	<CGME20240519222606epcas2p45c250e92bacb3aa0b00f7430ee69884d@epcas2p4.samsung.com>

The MCQ_OPR_OFFSET_n macro has taken 'hba' on the caller context
without receiving 'hba' instance as an argument.  To prevent potential
bugs in future use cases, this patch added an argument 'hba'.

Fixes: 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and runtime interface")
Cc: Asutosh Das <quic_asutoshd@quicinc.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 10 ++++------
 include/ufs/ufshcd.h       |  6 ++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 768bf87cd80d..b93ec147641c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -231,8 +231,6 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 
 /* Operation and runtime registers configuration */
 #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
-#define MCQ_OPR_OFFSET_n(p, i) \
-	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
 
 static void __iomem *mcq_opr_base(struct ufs_hba *hba,
 					 enum ufshcd_mcq_opr n, int i)
@@ -343,10 +341,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->sqe_dma_addr),
 			      MCQ_CFG_n(REG_SQUBA, i));
 		/* Submission Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQD, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQD, i),
 			      MCQ_CFG_n(REG_SQDAO, i));
 		/* Submission Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQIS, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQIS, i),
 			      MCQ_CFG_n(REG_SQISAO, i));
 
 		/* Completion Queue Lower Base Address */
@@ -356,10 +354,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->cqe_dma_addr),
 			      MCQ_CFG_n(REG_CQUBA, i));
 		/* Completion Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQD, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQD, i),
 			      MCQ_CFG_n(REG_CQDAO, i));
 		/* Completion Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQIS, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQIS, i),
 			      MCQ_CFG_n(REG_CQISAO, i));
 
 		/* Save the base addresses for quicker access */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a35e12f8e68b..eec7c97e3dbe 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1132,6 +1132,12 @@ static inline bool is_mcq_enabled(struct ufs_hba *hba)
 	return hba->mcq_enabled;
 }
 
+static inline unsigned int ufshcd_mcq_opr_offset(struct ufs_hba *hba,
+		enum ufshcd_mcq_opr opr, int idx)
+{
+	return hba->mcq_opr[opr].offset + hba->mcq_opr[opr].stride * idx;
+}
+
 #ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
 static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
 {
-- 
2.34.1

