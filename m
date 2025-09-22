Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40DF1DE3AC
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 19:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569236; cv=none; b=BAPVkoFlvszVH6/hcAP3Ws/Avx7jWYm3uyPPqEOFqsWRoa8gNcLExjzj9r58WPQYWD1g7CvRq7sGbv6J6nKtYEfVLm4sNPzYH4MfDBaVdQ4pASlxVzPvbSlmIoRJznpXv+8rOaXxMCUBkApBb8PLe9qxUEjcyrXGtSvAOXZdBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569236; c=relaxed/simple;
	bh=d2kVQfb6wu/wUSLlJkW+C+DHBxKYPw4MCx5i/++uLmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rgl2Amid8hNQTZympr7iXvUfIaFzCAh/uddLqmEpFyVlcy9NgfwmZxhCHNPPaiIg6ayM7XwMyq9J8DyUQlwdPt7zaCX+/OPWj+saZoCAMG5xU9aozMbJLXEPCVuHSCbqoKL2rLqAVNFWe7zWEj3sMdBQWcpdEIZozDCQwHcX7zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jJZ6NM1F; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jJZ6NM1F"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cVtR444lszlgqVk;
	Mon, 22 Sep 2025 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758569229; x=1761161230; bh=3KozXruKm7lFqaqzgkvNBpdg
	0ovKEsne8HGqAmEpHiE=; b=jJZ6NM1FVliKCUvGf9CDHYwI77y0hhKgMUXVuxiX
	s78bFRIMvXS01r3z/leQ3Tx7rNbJdSjxSyHoOtLMKC66Zlq5i5fcEeeGhzoBcUHA
	pKNU/Ro89AmSP2QPVAOjbjqmI61G7eOejg5n4/Qq4aWKVhbd06VbF218PIpEEi7Y
	8uQqUYhBNS5eHwEpwdjQtskWQQ02P8G7HM/zbOqkUlMIeZgNtxzSGt9yJaxI7B6r
	sL8rIbcb/eqK9qIFF+Yzd57sTeEmSiPIODZAV97XX+jp/pYpVwRS7rUDkDdaO1Fh
	D8i9Nm5YUczFhI7m3tD8IA1J7+qOGtek0J45GtP+igqK+g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ytCXrncB2Man; Mon, 22 Sep 2025 19:27:09 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cVtQp3gJjzlgqTp;
	Mon, 22 Sep 2025 19:26:57 +0000 (UTC)
Message-ID: <f60146c1-e0bf-40dd-adb1-95fe8884c550@acm.org>
Date: Mon, 22 Sep 2025 12:26:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
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
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-7-peter.wang@mediatek.com>
 <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
 <beda693842394d162c95d5523eb90373fd975d3c.camel@mediatek.com>
 <3d2a98e0-03d3-4b7b-816c-581d77551598@acm.org>
 <9b09e799df468f2fe33bd9acab6d2487d0539e7e.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9b09e799df468f2fe33bd9acab6d2487d0539e7e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/22/25 1:41 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> So, maybe re-enabling MCQ IRQs the same way as legacy IRQs
> in ufshcd_make_hba_operational would be better.
> What do you think? like below patch
>=20
> @@ -355,9 +355,15 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_cqe_lock);
>   void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
>   {
>          struct ufs_hw_queue *hwq;
> +       u32 intrs;
>          u16 qsize;
>          int i;
>=20
> +       intrs =3D UFSHCD_ENABLE_MCQ_INTRS;
> +       if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_INTR)
> +               intrs &=3D ~MCQ_CQ_EVENT_STATUS;
> +       ufshcd_enable_intr(hba, intrs);
> +
>          for (i =3D 0; i < hba->nr_hw_queues; i++) {

Thanks, this looks better to me.

If an ufshcd_enable_intr() call is added in=20
ufshcd_mcq_make_queues_operational(), shouldn't the ufshcd_enable_intr()
call be removed from ufshcd_config_mcq()?

Thanks,

Bart.
