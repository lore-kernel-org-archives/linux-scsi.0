Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55D9285C8E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756775386; cv=none; b=QVbD87YaOdN31oppHfnHBaoIlYEYcqDRxAMT7EWnbaRgV7CtCPHeZ0ucJXP88b/lKcg2qABjAboahei69fPAezN/TY8jLFGlH1cYK5fWVhne1hXoWK0FVLHx2bUOByJGUufL1o3GKsoZRLj/X+BhTKRVbsDOO3NzlLWtMeoBubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756775386; c=relaxed/simple;
	bh=28lIoBNkTDCxPNEm4BrzkouEj/x9/gTOUR7NfDnv/I8=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=GdsYyb2XuRrnwbwKy7PFvXO0CBt9IsglYtkuEUPR+2FMsJuF+X/28JYOCyUxtBpGdLBnqCT+uFowKcQC1mFih4gQyiM1D1ufpgA90aLY6gPlb7BdhLXLQLk81thG6FggaXbmie5sgn9RZh/R4ndOo6GODULTPxAG96GqofP9ItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n+sCHdj2; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n+sCHdj2"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250902010941epoutp03b56ddc61cb732290933cccf50dbf919a~hUeba2B7C2359023590epoutp03p
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 01:09:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250902010941epoutp03b56ddc61cb732290933cccf50dbf919a~hUeba2B7C2359023590epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756775381;
	bh=1/UtzH7xsaHxgW2UhoJ9KKV96kB1hG4FdJjnjA+butU=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=n+sCHdj2Uoz1xZmm+WzFctNCQzHwrXG13DPurgudX0PV7L27Hnm264tqN9zenc0QF
	 gKIdvciPoJBYwKfGBWhS2hBPJSqTZNhtidLJG2QxFrrgC612ek7nphPR+UhtHM7Dfh
	 q2hol1c2C5QGvjFPxqv1szYXuzhbepnKKVf+DP0I=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250902010940epcas1p4e2e6b8972c8388e1e51aa08d6474359b~hUeaklFJt0117601176epcas1p4k;
	Tue,  2 Sep 2025 01:09:40 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.243]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cG71w2Vdmz6B9mD; Tue,  2 Sep
	2025 01:09:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250902010939epcas1p1f732e3259ca818e4d4aa2e00fcb30f72~hUeZrWmt02602526025epcas1p1B;
	Tue,  2 Sep 2025 01:09:39 +0000 (GMT)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250902010939epsmtip10f38c99a3f1fb8993da62ec03bc8e774~hUeZkAScT0137501375epsmtip1S;
	Tue,  2 Sep 2025 01:09:39 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <27882582-58b8-4ac2-9596-3602098e7c1d@acm.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs
 cmd error
Date: Tue, 2 Sep 2025 10:09:39 +0900
Message-ID: <17db01dc1ba6$41d37350$c57a59f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEmYeTjtFjYRI1QNWxgWL0Y7ybfIwITLn2gAaoUPAICiJScSgGs7ud4AZvu8PK1nhF6oA==
Content-Language: ko
X-CMS-MailID: 20250902010939epcas1p1f732e3259ca818e4d4aa2e00fcb30f72
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
	<20250417023405.6954-2-dh0421.hwang@samsung.com>
	<239ea120-841f-478d-b6b4-9627aa453795@acm.org>
	<093601dc1ae0$2389c460$6a9d4d20$@samsung.com>
	<27882582-58b8-4ac2-9596-3602098e7c1d@acm.org>

On 9/1/25 7:4 AM, Bart Van Assche wrote:
> On 8/31/25 6:31 PM, DooHyun Hwang wrote:
> > UFS_CMD_ERR stands for "completion error".
> 
> No it doesn't. In the UFS driver and also in many other driver "cmd"
> stands for "command" and not for "completion". Please change the
> "UFS_CMD_ERR" enum label.
> 
> Bart.

I'm sorry. There was a misunderstanding in my previous comment.

The UFS_CMD_ERR stands for "command completion error."
I wanted to make it consistent with the other enums.
For example, query errors are defined as UFS_QUERY_ERR,
and Task Management errors are defined as UFS_TM_ERR.

I hope to use UFS_CMD_ERR for the same classification purposes
as UFS_CMD_SEND or UFS_CMD_COMP.
Therefore, UFS_CMD_ERR can be used for logging SCSI or UIC commands.

Thank you.
DooHyun Hwang.

