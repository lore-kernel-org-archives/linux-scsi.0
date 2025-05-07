Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACA4A11
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2025 02:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746583650; cv=none; b=DIobVtRHKPRpVUr7B7QBTbVar/y6/DA+MRvdXuDSD84FyzeLLNg0uz1SLkW+T6WYd0zVSoTMqZjVMBPvqzEnxHcNIVeOaJiw8gs8wRGQ5RHLi11tJsruMVDqHjexiVbcpLdben9WiJw/5UcVMO4vqB6ly5eKVI2w2MMUe+tjUfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746583650; c=relaxed/simple;
	bh=BOl1Hjbmg6sfv+e8b7AdM2sJt3n7EOZ+HP8cM6weGGY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=ghVkDLVrCgAkOLnbFRvIdoYvUFRHVKWPsdPxKkZREZrqke/tbzjQVfePYWb+lfnOrCSXcTgtf0uJC8AJLHBfdqNEXOOUOVC7+U6R4vU24fb7uayb8WbDRUq6+yrCOEYbq+mel7oRRdWeXois0tWbtKG+k9VUZMPd88i74bot9Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Pb3cEynk; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Pb3cEynk"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250507020724epoutp03aefc73be5316cde3132a315adc7c53ec~9HJIpzZq_2539525395epoutp03M
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2025 02:07:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250507020724epoutp03aefc73be5316cde3132a315adc7c53ec~9HJIpzZq_2539525395epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746583644;
	bh=vh1sjlzdmhCkJFjPMX98BXTIFWJ0pn9mK1R1KkIvKng=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Pb3cEynk6F8WoAo0cJo8eN35U7puwDzSpLG1/9UW7aFNG7hSJejLqqmg126pTPHNy
	 juPkqNGjZkPZ5VnF1sWMztrKtNL+JmT1mSPNSKdRBJ6FhCO1k06SxZZ1tI03QloTYL
	 OBAiFsQonW3lx3Tppdg8ZQMBKuwNAAkVzkVZs+4A=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20250507020724epcas1p3619785b5d0f5987100eee9ded9f925bc~9HJIWdcCe1697116971epcas1p3n;
	Wed,  7 May 2025 02:07:24 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.36.226]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4Zsdtz6H9yz2SSKf; Wed,  7 May
	2025 02:07:23 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250507020722epcas1p1171c5e96ef474d587a1a35af8d6931bf~9HJHJU48N2947929479epcas1p1p;
	Wed,  7 May 2025 02:07:22 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250507020722epsmtrp274642db3c1aaac5cb6471feff3b7bd6a~9HJHIpGAQ0063700637epsmtrp2D;
	Wed,  7 May 2025 02:07:22 +0000 (GMT)
X-AuditID: b6c32a52-40bff70000004c16-3f-681ac05aa7c4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.A0.19478.A50CA186; Wed,  7 May 2025 11:07:22 +0900 (KST)
Received: from wkk-400TFA-400SFA.. (unknown [10.253.99.106]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250507020722epsmtip101809ac449763400cd7224bd757d3da2~9HJG_O8Fa0522205222epsmtip1O;
	Wed,  7 May 2025 02:07:22 +0000 (GMT)
From: wkon-kim <wkon.kim@samsung.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wkon.kim@samsung.com
Subject: [PATCH] ufs: core: Print error value as hex format on
 ufshcd_err_handler()
Date: Wed,  7 May 2025 11:07:18 +0900
Message-Id: <20250507020718.7446-1-wkon.kim@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsWy7bCSnG7UAakMg4UPzSw29nNYXN41h82i
	+/oONovlx/8xWWy+9I3FgdVj2qRTbB4fn95i8ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	7ZP+shRs46y4vGAWSwPjN/YuRk4OCQETiUsvHrF0MXJxCAlsZ5R4PvMZUIIDKCEhseVLNoQp
	LHH4cDFIuZDAe0aJe9tCQGw2AVWJ3w0HGEFaRQRaGSWe3roI1soM1Hrgli1IjbBAsMSPeQ9Z
	QMIsQPVnLsaChHkFLCR+H7/CDHGBvMT+g2eZIeKCEidnPmEBsZmB4s1bZzNPYOSbhSQ1C0lq
	ASPTKkbR1ILi3PTc5AJDveLE3OLSvHS95PzcTYzgsNMK2sG4bP1fvUOMTByMhxglOJiVRHjv
	35fMEOJNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamASXv5F
	cVq05inTT79DjsoaWjzPvme1r19QOif9RcROpUO3ln3yKFgerlZ7sGyz37vkxTO77VsnFaRM
	X7+AtXyDscgu7oWaa6fNrHf/euTe3nqLooqdW7fxTDtWeDfz9JbFt++cO/3srwSTsdyB7lfL
	j3dyvHv5av6f39MPVP9p6Iidstq5LPD33FfOF56+ODFB2czhcurHpbJTj6XsZVDyllw62/xc
	n0er9wGvrQctTH7yKB+acWSD2PxS7c4tTXudvX8LMN5aWLT+o8j5ixt4bgrNZ5A6JJOle31t
	y05nnq+XnG+vVdooELBzyrF/sZFyZ3zu8rM/XBs6YUvGiU06vQ2O/9yfm0z+JmJi6tWdd0mJ
	pTgj0VCLuag4EQB2hhOjqgIAAA==
X-CMS-MailID: 20250507020722epcas1p1171c5e96ef474d587a1a35af8d6931bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250507020722epcas1p1171c5e96ef474d587a1a35af8d6931bf
References: <CGME20250507020722epcas1p1171c5e96ef474d587a1a35af8d6931bf@epcas1p1.samsung.com>

It is better to print saved_err and saved_uic_err in hex format.
Integer format is hard to spot.

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

