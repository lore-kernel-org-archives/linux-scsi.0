Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A72442B07
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810433; cv=none; b=efZLSS7U2+ZjYWHgqRP5nWwiCeMfNAQwOhFARGA66T+2CsCrsH4K9oF3GOQEGIGdCQKjdWH0WgE9o5oW9ysA+AFzC/0eCC+GwjKEdONiQlDUbszYmtPOCBAB1lgip8elwuefAouDHbbEdRS4Tc/doatjOhfWnJ8ZS47vv6C7lTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810433; c=relaxed/simple;
	bh=FYBf4yf/omxzHHzXZ3XBqqe0GFGxDT+yoSBz5oPkcxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLKEt3+97nu4NW/D5ZUqILsk1jt4xHQqS8fUisq4enU3+FbO865XLaouPDS+NrD5WkuWEC1nnXTHco7754M7Stb3hfIj3HT6mzJ8TxeOS347gQHbcl7MPzbZagC7BXjCFqgzE/kak02qrayPRWvEcyKuiw8Mzq5hWxdVzfditQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9VzRCZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9VzRCZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B31C1F000E9;
	Thu, 23 Jul 2026 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784810431;
	bh=ggIEOu1YQaNTl8uHeapYlP/thX98yYCtXe9fkfUpAZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l9VzRCZBqQAiRTicGOddbAZqMM7Gqlj0/NyLy20NVEGpyg+U9O2/Lq8C7TSHyrV/o
	 ToqbMXYxrOGH2fiwFDJ79uODVKqEyU9F/iHLf4w7dlehVe8zFmHcZt0gOOfJw+WbHc
	 ZCD9I9oUrU5zEbzIIg4UpxdWRPp0Ynglc5pl+zBQu8/EJJoF2JP32+74DRZWZH9yW7
	 h0G9jcIRytXNUALF35AJ2MVPPSdr269a/giz4AMyXfqZtghb39nNUkw6HaVIm7qdBz
	 0+AaD0xhDo83MU0lWtHwZD5mJIeZfDlEWfXDmrJWNueq+tXun8hax0ePzfbdF4+AqP
	 DsBkjhVmuMy5g==
Date: Thu, 23 Jul 2026 14:39:58 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>, 
	CC Chou =?utf-8?B?KOWRqOW/l+adsCk=?= <cc.chou@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, 
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	Eddie Huang =?utf-8?B?KOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>, 
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, 
	Chaotian Jing =?utf-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	Naomi Chu =?utf-8?B?KOacseipoOeUsCk=?= <Naomi.Chu@mediatek.com>, 
	Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= <Alice.Chao@mediatek.com>, Ed Tsai =?utf-8?B?KOiUoeWul+i7kik=?= <Ed.Tsai@mediatek.com>, 
	wsd_upstream <wsd_upstream@mediatek.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, Tun-yu Yu =?utf-8?B?KOa4uOaVpuiBvyk=?= <Tun-yu.Yu@mediatek.com>, 
	Chun-Hung Wu =?utf-8?B?KOW3q+mnv+Wujyk=?= <Chun-hung.Wu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Message-ID: <yyocxatyi7bitvehm2fgltxpayomt3d6r5zyr2ugbehkvsowcz@cg4if4zdqgbu>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
 <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
 <29b5f4368a63847b84b87e36a1e358f5991b694c.camel@mediatek.com>
 <amAqHFOgPQQY-3rI@QCOM-aGQu4IUr3Y>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amAqHFOgPQQY-3rI@QCOM-aGQu4IUr3Y>

On Wed, Jul 22, 2026 at 10:25:32AM +0800, Shawn Guo wrote:
> On Tue, Jul 21, 2026 at 12:54:01PM +0000, Peter Wang (王信友) wrote:
> > On Tue, 2026-07-21 at 14:58 +0800, Shawn Guo wrote:
> > > A revert of commit 85b2b9662854 ("scsi: ufs: core: Remove unnecessary
> > > block I/O quiesce for clock scaling") fixes the regression for me.
> > > 
> > > Shawn
> > 
> > Hi Shawn,
> 
> Hi Peter,
> 
> > What is the probability of this issue occurring?
> 
> It seems 100% per my testing.
>

Whenever clk scaling gets triggered. So this affects all Qcom UFS platforms.
 
> > Is this a design limitation of the Qualcomm platform or?
> 

Qcom Host Controllers doesn't support scaling clocks when the traffic is
ongoing. So this patch certainly cannot work on our platforms.

If you want to pursue, you should limit this change to MediaTek platforms. But
nevertheless, this patch should be reverted as it breaks UFS on all Qcom
platforms.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
