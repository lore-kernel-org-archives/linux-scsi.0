Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF327FD7D
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 09:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763372946; cv=none; b=olIgkeHYYOLk2O29cTunHahjUiHEzFwn2+0c3pAGQMBkbTR92ZnCiY5hc6gey1n/MyoYSxqWAljIZ27+//weuUz55sthez8L9O1Kvgf1ph/UaZOdBJXcGnVOrKqVLz8lTBXQQMFvuqV13DNzHzyBn5JS5YMXZSJDpDFO7BcSdU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763372946; c=relaxed/simple;
	bh=BQHOwBoF383gU5eDq2EBRIX1QvG/A4eG/wMI3B4bD4k=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=bGx5KeeF04NBvm2ugZXBzB+pnagu9Z/wqsuejFdTO5y5afDmUMQAezg3O+N8uJj1lP15vDn0pOZSzBUoPV0Cm8ic92Mr9rdTGUINCP6ZHvqTxRGSBWOIsBT3Xw3PPJOF1LVOTCdw157t47grFwZ9xMT0j1S+tzvf7nJfVaHaZFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HOFXMNtu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HOFXMNtu"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251117094901epoutp048a181b3ce6be3a3d32777394a66bb5e7~4wlj-SGG21997219972epoutp04K
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 09:49:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251117094901epoutp048a181b3ce6be3a3d32777394a66bb5e7~4wlj-SGG21997219972epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763372941;
	bh=wuI5BF6yQP8/E3X49U2wrfF1kzvm2P7C74r/E5pry5M=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=HOFXMNtulTxHsi/Kl4m+BPFlMeRe0GBkJOC/thl2MiHNFVCJpMcMWSxUdJP71HD96
	 6dX5uTxji/eYnAL18JlOQHDuH1RhfhEGyhH6MFGV+O8O31u7HXcmjLkhACN9+FZDeH
	 MedgK+4LjDjCt+RmqvfdbgRfJyglEl/3qYhBvrSA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20251117094900epcas1p3737e9cc1fa66c8e9a072bb71129da470~4wljB9JKN0139201392epcas1p3t;
	Mon, 17 Nov 2025 09:49:00 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.114]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4d92y42Mggz6B9m9; Mon, 17 Nov
	2025 09:49:00 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251117094859epcas1p32dbab9ff0bf86d7d9c4d533d2cb7c5f2~4wliXXPIL0139101391epcas1p3w;
	Mon, 17 Nov 2025 09:48:59 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251117094859epsmtip136d7918e189a722abba48ace16ff66b2~4wliTsTPv0882208822epsmtip13;
	Mon, 17 Nov 2025 09:48:59 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: =?utf-8?Q?'Peter_Wang_=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29'?=
	<peter.wang@mediatek.com>, <beanhuo@micron.com>, <avri.altman@wdc.com>,
	<storage.sec@samsung.com>, <linux-scsi@vger.kernel.org>,
	<bvanassche@acm.org>, <linux-kernel@vger.kernel.org>,
	<alim.akhtar@samsung.com>, <adrian.hunter@intel.com>,
	<martin.petersen@oracle.com>
In-Reply-To: <500022ecc5216afa01e7f606187f012294a76da3.camel@mediatek.com>
Subject: RE: [PATCH] UFS: Make TM command timeout configurable from host
 side
Date: Mon, 17 Nov 2025 18:48:59 +0900
Message-ID: <000001dc57a7$661a8040$324f80c0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKPfZmbwG70PGLKm/pFTS39UPXmNQJO/jelAdbalYUBDqcQiAEtGsS3ASfXEoMCIZ0ypQGwF+chApxwnbsCHHi4qACtcFv2swpFdnA=
Content-Language: ko
X-CMS-MailID: 20251117094859epcas1p32dbab9ff0bf86d7d9c4d533d2cb7c5f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	<20251106012654.4094-1-sh043.lee@samsung.com>
	<e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	<009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	<f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	<be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	<8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	<1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	<b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	<000001dc5791$5f2ea880$1d8bf980$@samsung.com>
	<500022ecc5216afa01e7f606187f012294a76da3.camel@mediatek.com>

> On Mon, 2025-11-17 at 16:11 +0900, Seunghui Lee wrote:
> > Hi Mr.Wang,
> >
> > I understand your concerns about considering the worst-case scenario.
> > What about directly modifying TM_CMD_TIMEOUT (100ms -> 300ms) and
> > reducing the TM retry count from 100 to 30?
> >
> > Please let me know your opinion.
> >
> 
> 
> Hi Seunghui,
> 
> Changing TM_CMD_TIMEOUT from 100ms to 300ms is okay for me.
> The adjustment of the TM retry count from 100 to 30 is not significant, so
> it does not matter whether this change is made or not. Overall, this patch
> looks good to me.
> 

Thank you for your opinion.
I'll update the revision.

> However, the other TM clear timeout of 1 second has a much greater impact:
> ufshcd_wait_for_register(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL,
>     mask, ~mask, 1000, 1000);
> Would you consider shortening this value as well?
> 
> Thanks
> Peter
> 

Thank you for your additional comment.
By the way, in my humble opinion, it's not about tm cmd timeout,
but about host register.

If it must be changed, how much time do you think for it?
I think that it's handled by different modification.

Thanks,
Seunghui Lee.

