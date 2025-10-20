Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD1D2D6E67
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760941167; cv=none; b=WDDhjkrAZvI7UagCjJIcKuusUdkTXA1x9/dWdvLUafCkr1/ZKdPcIPTllp1EjGjowYxtD3F9fkw2g6NA2bMA3azbfjkjZXYcR3MNpb/tyZNQiz3Oej4jRWeQi3rBiMRaPdi/sE3dUyIF8cFxCl6Rja+FNrxAweyjYD2Y/uQchIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760941167; c=relaxed/simple;
	bh=l+meFdtgtAN8bjmpeYL0yYYPs5cpnCir2LWq3DL2PBc=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=nHsqzU5d9QkDeUejNujbAdb9kC4Jl7+2SFKivU/JHw1NVpbmGzaSnTQAcT62z7208xoIi+PcHnXANUG2WNVzh4ViHoFSq5Gcg9oORUdl2uCV8aYTxzlS43t4ZJFSdCc9GURej0ApZ5I9k01TBFQu4oZDdUerS4mXS8uDc0wuCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=iT7alFgV; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iT7alFgV"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251020061916epoutp0377ed1d394f5c41ebcd53ecfe342e7595~wHqb3fhDm2901629016epoutp034
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 06:19:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251020061916epoutp0377ed1d394f5c41ebcd53ecfe342e7595~wHqb3fhDm2901629016epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760941156;
	bh=IoC6cxPk+EVU4X5dumaa3IopImaiwdS8+Ozryi8aOKc=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=iT7alFgVHbUZmRVePu+8YZpvF1CxQctg7ZXpCPJDQ0jhEOoO+7viMc7iEMybcBA9g
	 hw15QdnLJrYDMFxm5/7//sGkZaWkWl4eRwrS+TWB5iHvJiDlYiR+b7neo5QPl3vvOd
	 rot8fFcOdT7ZW8lrsv0kdACFzt3Pq+nGxhdWX1YI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20251020061916epcas1p1b4d39bd4a86208fb8d10ee9bee788188~wHqbdqw-m2614526145epcas1p19;
	Mon, 20 Oct 2025 06:19:16 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.195]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cqld00wCMz3hhT8; Mon, 20 Oct
	2025 06:19:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251020061915epcas1p357374cbea0f699416b8678e426274485~wHqa2kxoM0694606946epcas1p3C;
	Mon, 20 Oct 2025 06:19:15 +0000 (GMT)
Received: from wkonkim01 (unknown [10.253.100.198]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251020061915epsmtip11478c2889fa5c0704b204bc460f07467~wHqaz6Bnr0817108171epsmtip1g;
	Mon, 20 Oct 2025 06:19:15 +0000 (GMT)
From: "Wonkon Kim" <wkon.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <5befc42a-9e00-4d03-a392-f2d823ffd872@acm.org>
Subject: RE: [PATCH v2] ufs: core: Initialize a value of an attribute as
 returned by uic cmd
Date: Mon, 20 Oct 2025 15:19:15 +0900
Message-ID: <323701dc4189$75c2fbf0$6148f3d0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQDv4UgPMqiJUZ3lL8b8FwZq3QhsIwLCHDWKAlqvTe+2emmD8A==
Content-Language: ko
X-CMS-MailID: 20251020061915epcas1p357374cbea0f699416b8678e426274485
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca
References: <CGME20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca@epcas1p3.samsung.com>
	<20251014044046.84046-1-wkon.kim@samsung.com>
	<5befc42a-9e00-4d03-a392-f2d823ffd872@acm.org>

> On 10/13/25 9:40 PM, Wonkon Kim wrote:
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 9a43102b2b21..6858f005cc8b 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -4273,8 +4273,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32
> attr_sel,
> >   			get, UIC_GET_ATTR_ID(attr_sel),
> >   			UFS_UIC_COMMAND_RETRIES - retries);
> >
> > -	if (mib_val && !ret)
> > -		*mib_val = uic_cmd.argument3;
> > +	if (mib_val)
> > +		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
> >
> >   	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
> >   	    && pwr_mode_change)
> > @@ -4990,7 +4990,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
> >
> >   static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
> >   {
> > -	int tx_lanes = 0, i, err = 0;
> > +	int tx_lanes, i, err = 0;
> >
> >   	if (!peer)
> >   		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> 
> Please split this patch into two patches: a first patch with the
> ufshcd_dme_get_attr() change and a second patch with the
> ufshcd_disable_tx_lcc() change. Please also add a Fixes: tag to the first
> patch. That will cause the first patch to be included automatically in
> stable kernels and also in Android kernels.
> 
> Thanks,
> 
> Bart.


Sure. I'll split and update it.

Thanks,
Wonkon Kim.

