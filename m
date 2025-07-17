Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F92D63E8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766784; cv=none; b=NBv8HTN2aB9U9T54pkAAMKp8EK5DA0pw1xnyfWDwt8FVSj89Zd8JonLHfV5tVDKDCuQSekTTfP3RzZ+m/lcwe9QSM2E1w8uNbE6vOEFvMWmNsP86IS3uR7h+PBoZCrJPqjhWbvUYtRrdLf48TDwJ91Bgk8LKvz0siitX7lZEOM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766784; c=relaxed/simple;
	bh=HplzPwWU10JoGw3qjp6VwHGceUCH163ka0Sx0GfFyUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9ntQv0JPSEg/TrzZpO1EGQrcRgrcbPr9aBmaTuNcKQOBIHGPwS1EfJ7oFOPQYCSjV5v9lZrLsjvg1goXMQXLXLjAPyX/geA5GJarUe1tcVep1vdHXVzcb15nTxeOBjE3duWrO0qGWjJPnkksPQilwyBTCRPUrwxesh1X39JUMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F2LuUvA9; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F2LuUvA9"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjcYT3T5lzm1747;
	Thu, 17 Jul 2025 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752766778; x=1755358779; bh=HplzPwWU10JoGw3qjp6VwHGc
	eUCH163ka0Sx0GfFyUI=; b=F2LuUvA9d6YXxyMbanxsq9G+4bLSjy5nhKkbQr2V
	r6Z6EV/fb5tlj8CQOw/dNmnGybpsghZqUzyS4oFCIYh9QUFOyop6m//0Vc7eFxSr
	RSg3ga/cw0YANuObsYsF0s3YzlQbybPwIWxN0I/XfhVgNJpQTvNzNNO+yhpgw0hm
	3CUeWO8i2AIB/DXPLKeLDiXFzYbdwntTA2JaEwxxbqUpY/maj4Xnx96xWw5+Dwup
	F5dsihTchXBg2ERq2vr/8R2oNTrNevvcA1Tg0BW5Mb0DnzVeNxKE+jfk+0sarclP
	BtulegVSe5zLdZ+0tlegFSTpfu+H7itvGI6Ut3sGaeSTsw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id X3mBwEfRxMCA; Thu, 17 Jul 2025 15:39:38 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjcXy0gw0zm174q;
	Thu, 17 Jul 2025 15:39:12 +0000 (UTC)
Message-ID: <e736dd60-377a-49b6-9ea3-efb1ca5ea787@acm.org>
Date: Thu, 17 Jul 2025 08:39:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Set IRQ affinity policy for
 MCQ mode
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
 <Chun-hung.Wu@mediatek.com>, =?UTF-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
 <Yi-fan.Peng@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
 <20250716062830.3712487-7-peter.wang@mediatek.com>
 <9de567ee-f908-41a3-bcb7-7f54ebb17f55@acm.org>
 <32415970794cf74750d8e10383f738208ec7d91a.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <32415970794cf74750d8e10383f738208ec7d91a.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 7/16/25 11:54 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> As far as I understand, This depends on the situation. By default,
> Linux automatically distributes IRQs across CPUs, which is
> sufficient for most systems. However, in certain high-performance or
> special-use cases (such as for network cards or storage devices),
> manually setting IRQ affinity can improve performance or reduce
> latency.

Hi Peter,

It would be great if it could be explained in the patch description why
the IRQ affinity changes happen from kernel space instead of from user
space.

Thanks,

Bart.
