Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C5341D23A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815084; cv=none; b=DVKdHmlY1sUspdnT2exQkoBWMTcfURkUfZ0dcB0HQHcG/8jPgo9gZI6TFhNQZRek5p+4U3lhxdCErWAScxOCw4NJXzKX4KQQQqIwxjLqP6AtY1Vre1n30bJ/C1cE4X6ytv0Dlq1ij73gDYM322waJrkAmJ/R4iMHw2SUu5w9VuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815084; c=relaxed/simple;
	bh=gtp+H7zRLZHEzieR3qwJUmMCkXm4szZl/pXO6qCzzBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5ETS50atnTx0+tN5bobhnaBd9CXBJDEsBDfHJT5YB18XwZE/DoNMyK9hs5DshtL8PlzWm5C7D5wJj2UPPsnfzZLpPdzzwcQgnw5wpVWrjeLxTMZw71vXxciwWGLDYVZnY436oWc1t/FL7mT5BZctRRiDEMv1pp+66PffZ8JEic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6521F000E9;
	Thu, 23 Jul 2026 13:57:47 +0000 (UTC)
Date: Thu, 23 Jul 2026 15:57:42 +0200
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
Message-ID: <ddce244mxh7obbfh2td23ogm4rx36s2dr7jg7bc5pq5ae4373s@qgwr2f27dppn>
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

What you quoted in the commit message is true for power mode change (gear, lane
etc...), but clock scaling involves scaling up/down the HCI clock inputs as
well, which is not covered by the JEDEC spec and is vendor specific. And this is
where the discrepancy lives.

Qcom UFS HCI also allows power mode change with in-flight traffic, but scaling
the clocks is not supported. I'm not sure about other vendors here.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
