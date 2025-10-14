Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EADEACD
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760416524; cv=none; b=LOcQO2VnswQDpRHLBEo2MAR6v7fhT6PYmPeItfbVW0lpce4x1hKjDgl8RqqpZ3xuKPLotcDTyClfmeDJS5d6X/AXAq7veOyqefrwnTumZ9Jscw5PHDF83g+F6LHFJFgdjtfUwzeiAoOjZF6I31hLWODBIAZM0vWueneXwAOueTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760416524; c=relaxed/simple;
	bh=uAwl1GNK6MVfiRj2npv6hyUGtVFuuhpcPe1Xltm/3To=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=T1kE35UkzM4XgX23S2ByoMYfZ2TohLrk2ZkQkO7M/pkpyTDv61EnQGCms5vRpA62V+lfki48GA+F5MKQ5veRnFawRUdqpeCuLYH5DI/gOjBk4ERDp0z2CXjhyo3VQmZTALuPAQsHrfQ4/zU5KJLS0hK82KfLlbuHliiPbY5p2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CyunqR9C; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CyunqR9C"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251014043513epoutp044d2be4699de1ab790cde90534de128b5~uQX3jTUxt0881608816epoutp04I
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 04:35:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251014043513epoutp044d2be4699de1ab790cde90534de128b5~uQX3jTUxt0881608816epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760416513;
	bh=KIHDVhuZ6TYpVfog+kFYWQMy8WRowbJlE3bnFZPEiMM=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=CyunqR9CuItd6hS9QXgYIvGu1+1Jc6sxnmog4KbWtHVaS92TUyUv9c9WdvFb83Hk/
	 J8LumzsBTqdM0Nmmcy1sg7Z0myLgWkLZ3N08CNCW++JXjj+Tg93bmdoaA7qTN/pWDv
	 gzMbC39XlhCWZlaPiV4YSaIzgmlwm6isDgsLKykg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20251014043512epcas1p1fda50efe0632504b562c17695cded6cc~uQX29KIV42282522825epcas1p1D;
	Tue, 14 Oct 2025 04:35:12 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.119]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cm1bh2t5Lz6B9m6; Tue, 14 Oct
	2025 04:35:12 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014043511epcas1p37bffc5c998bff21f27aba426deb77e95~uQX2K9LcL2696626966epcas1p3X;
	Tue, 14 Oct 2025 04:35:11 +0000 (GMT)
Received: from wkonkim01 (unknown [10.253.100.198]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251014043511epsmtip1954ec39f6a83fdc63043a6899695cd0e~uQX2IOiWL2405624056epsmtip1s;
	Tue, 14 Oct 2025 04:35:11 +0000 (GMT)
From: "Wonkon Kim" <wkon.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <f90010b2-7db1-412c-8526-47339bf4aa6b@acm.org>
Subject: RE: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
Date: Tue, 14 Oct 2025 13:35:11 +0900
Message-ID: <065101dc3cc3$eda735c0$c8f5a140$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFhT2clGfJ4dWcII9qWXyagEihcgwJWi3eIAdcMmwEC1X995AKKjmFatWp7pXA=
Content-Language: ko
X-CMS-MailID: 20251014043511epcas1p37bffc5c998bff21f27aba426deb77e95
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
	<20251002070027.228638-1-wkon.kim@samsung.com>
	<4c894d68-7d0e-49a0-b582-477bcc7f351d@acm.org>
	<000001dc3c1a$33e23030$9ba69090$@samsung.com>
	<f90010b2-7db1-412c-8526-47339bf4aa6b@acm.org>

> On 10/13/25 1:20 AM, Wonkon Kim wrote:
> >> On 10/2/25 12:00 AM, Wonkon Kim wrote:
> >>>    static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
> >>>    {
> >>>    	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
> >>> -	u32 mode;
> >>> +	u32 mode = 0;
> >>>
> >>>    	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
> >>
> >> Since there is more code that passes a pointer to an uninitialized
> >> variable to ufshcd_dme_get(), the untested patch below may be a
> >> better
> >> solution:
> >>
> >> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> >> index 127b691402f9..5226fbca29ec 100644
> >> --- a/drivers/ufs/core/ufshcd.c
> >> +++ b/drivers/ufs/core/ufshcd.c
> >> @@ -4277,8 +4277,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba,
> >> u32 attr_sel,
> >>    			get, UIC_GET_ATTR_ID(attr_sel),
> >>    			UFS_UIC_COMMAND_RETRIES - retries);
> >>
> >> -	if (mib_val && !ret)
> >> -		*mib_val = uic_cmd.argument3;
> >> +	if (mib_val)
> >> +		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
> >>
> >>    	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
> >>    	    && pwr_mode_change)
> >>
> >>
> >
> > There are some attributes to use 0 as valid value.
> > e.g. PA_MAXRXHSGEAR is set to 0 for NO_HS=0 If it has 0 for valid
> > value, most of value 0 are regarded as FALSE, unsupported or minimum.
> > And these cases seems to check ret for command success/fail in code.
> > However, is it ok to set 0 for ufshcd_send_uic_cmd() fail?
> >
> > If it can't, it needs to initialize mode.
> > Value 0 for PA_PWRMODE is invalid.
> 
> Hi Wonkon,
> 
> Modifying ufshcd_dme_get_attr() doesn't exclude checking the return value
> of ufshcd_dme_get_attr(). I propose to modify
> ufshcd_dme_get_attr() such that it always initializes *mib_val and also to
> check the ufshcd_dme_get_attr() return value wherever appropriate.
> 
> Thanks,
> 
> Bart.

Hi Bart,
I got it. I'll update it.


Thanks,
Wonkon Kim.

