Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8E3548E0;
	Thu, 12 Sep 2024 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726175862; cv=none; b=NQZfe6BBkHoAwPJcgRs8GjCvfwoFdju0Pxj7WNsY9B5btEIUIk2/gG+6jjIKZ8rjrVTj7NOJxvSWU6NADWe1nJfLlz3UIC6a1TxCq/1lQ/cxRRa1vP6FMeWrz61KCyViARi+2/45raqebHr+F39mmtdVBpJHFjRgxCyvTXQnbEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726175862; c=relaxed/simple;
	bh=gd1MI7WTJ66whWz3mg6E+ps2Eh2nuq7DBF84NU2PKh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnKZ/oJQvOSguorKYRBqTTXl8tv7wIZn/jLuIPuN+rAfkqHYatoYB9NiJreTSynhV9hqn+23cbCugOCRtKNIcfZZDVtMeRnrnPkNNsKXPu0Lf2E7fXaT6fvgQkDx5IFyoT9yZjVIXHMgZkdUXFwUMb5Mq0FOeEINzJ+BaotD3dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PJldVbjD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PJldVbjD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X4Vdb4hVtz6ClSq1;
	Thu, 12 Sep 2024 21:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726175852; x=1728767853; bh=gd1MI7WTJ66whWz3mg6E+ps2
	Eh2nuq7DBF84NU2PKh4=; b=PJldVbjDQxc+uDgTOfw+V2OCBlqnhICvwRkEBzj9
	JbFOq8YrWcDqYjBgB83NgO10d7l7YDhCxrXXaZ5vVvvrFb/wEYc8b2kyj+vjzk1r
	vky7Lc6L8SJNvB27aVNS/b/qy5E1RIezmNXk5o3iTaVS7cIVMTU0OpG5fUWVGMHA
	qlyV9xDiRW2wcqxOpgwWo4vjyvFkbcunZvHSvtAIzVU/agwofE6lt68h2MUJobpW
	iJp/tu3Ny7+LBUNdwwsVPE2UM0uh+m0UISJ6c7W3x9hK2tFGa6PotU2wP8K/2Z6t
	mwrwsPwK5MBNBczzHI0rIvoGn4TvTCtw3/f2LS3UGQgkRw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NodNbSD3M-yS; Thu, 12 Sep 2024 21:17:32 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X4VdN4NT7z6ClSpy;
	Thu, 12 Sep 2024 21:17:28 +0000 (UTC)
Message-ID: <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
Date: Thu, 12 Sep 2024 14:17:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
 <20240910073035.25974-3-peter.wang@mediatek.com>
 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/12/24 6:31 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> in SDB mode:
> ufshcd_utrl_clear set UTRLC, Mediatek host controller
> (may not all host controller) will post response with OCS ABORTED.
>=20
> In both cases, we have an interrupt sent to the host, and there
> may be a race condition before we set this flag for requeue.
> So I need to set this flag before ufshcd_clear_cmd.

If a completion interrupt is sent to the host if a command has been
cleared in SDB mode (I doubt this is what happens), I think that's a
severe controller bug. A UFSHCI controller is not allowed to send a
completion interrupt to the host if a command is cleared by writing into
the UTRLCLR register.

Thanks,

Bart.
