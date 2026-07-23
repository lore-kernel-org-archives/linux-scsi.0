Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C2E42AF87
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816559; cv=none; b=ksH6gpYerEkBqPTMSnRMhOepQmR0+SKtmfyzIytMrp7+NnpR7ZvRstD4ngS2nnIG6Z4ZbI1nzRnLy13q7nEowF1L4nIG4lgeuHZJ1bgPDCYbz3A1KLyUc66Rh4YWO4ZsvbY9HARFnWdCM12accQ29FFTmN6cgtlXTp5pBZdG1nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816559; c=relaxed/simple;
	bh=PXN3K+MYU21n60Sohci3QQIUfd/gt9ruHuXuSk6NvYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jrm3G4gKBAlusUDDCpcwAp2bQqIlvGIDhURypwZbzAdpSRtzU8y/GZNBi8Rey+l4ggCXfHBWgR18RXxR2x5hXBo7HUMxKT4Jhs6mEVOr5A1OBe470kXCFCzJ7JCZut5FQzHh26zV/9v9UmkkYM4PAeOCS2lkQ5YDI2Zz5Yzl0sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306C11F000E9;
	Thu, 23 Jul 2026 14:22:29 +0000 (UTC)
Date: Thu, 23 Jul 2026 16:22:25 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc: "shengchao.guo@oss.qualcomm.com" <shengchao.guo@oss.qualcomm.com>, 
	CC Chou =?utf-8?B?KOWRqOW/l+adsCk=?= <cc.chou@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, 
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	Eddie Huang =?utf-8?B?KOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>, 
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, 
	Chaotian Jing =?utf-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	Naomi Chu =?utf-8?B?KOacseipoOeUsCk=?= <Naomi.Chu@mediatek.com>, 
	Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= <Alice.Chao@mediatek.com>, Ed Tsai =?utf-8?B?KOiUoeWul+i7kik=?= <Ed.Tsai@mediatek.com>, 
	wsd_upstream <wsd_upstream@mediatek.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	Chun-Hung Wu =?utf-8?B?KOW3q+mnv+Wujyk=?= <Chun-hung.Wu@mediatek.com>, Tun-yu Yu =?utf-8?B?KOa4uOaVpuiBvyk=?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Message-ID: <l22o4flil6pumsqbuxas37e2vn5rtmljrnp2elz7ucqffzxmus@wrvez3ufip45>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
 <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
 <29b5f4368a63847b84b87e36a1e358f5991b694c.camel@mediatek.com>
 <amAqHFOgPQQY-3rI@QCOM-aGQu4IUr3Y>
 <yyocxatyi7bitvehm2fgltxpayomt3d6r5zyr2ugbehkvsowcz@cg4if4zdqgbu>
 <7c55a405dcc3a0a80931263bf1807c815e78efea.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c55a405dcc3a0a80931263bf1807c815e78efea.camel@mediatek.com>

On Thu, Jul 23, 2026 at 01:22:57PM +0000, Peter Wang (王信友) wrote:
> On Thu, 2026-07-23 at 14:39 +0200, Manivannan Sadhasivam wrote:
> > Qcom Host Controllers doesn't support scaling clocks when the traffic
> > is
> > ongoing. So this patch certainly cannot work on our platforms.
> > 
> > If you want to pursue, you should limit this change to MediaTek
> > platforms. But
> > nevertheless, this patch should be reverted as it breaks UFS on all
> > Qcom
> > platforms.
> > 
> > - Mani
> > 
> 
> Hi Mani,
> 
> This patch is based on the JEDEC specification. As all SoCs 
> should follow this spec, I have not applied it solely to 
> MediaTek's platform. However, I think reverting it is okay. 
> I will consider how to revise it later.
> 

JEDEC spec mandates that the power mode changes (gear, lane, etc...) can
happen while the traffic is on-going. But clock scaling done by the ufshcd
driver involves not just power mode change, but also scaling the vendor HCI
clocks as well. And that is what causing issues on Qcom platforms, as our UFS
controller doesn't support scaling HCI clocks during live traffic. I'm not sure
about other vendors here.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
