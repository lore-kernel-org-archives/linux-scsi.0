Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0AC1C2BF;
	Fri, 13 Sep 2024 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726249303; cv=none; b=AQcUh1b0h63pD4NHhnN3L20w1VJoARTSY1UyiB8za7p7JJd97R+Wnafv26WpKegfANAwyaXvdhLT+uQ3ds2cbJmV6YY6aZsJPVzxTmhZLsz12Dw/pRbeYPJZloZowdPYw325OfpOYkrSl/Pw4/w/QQmXyMQsraobeZUcbt1jUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726249303; c=relaxed/simple;
	bh=QtHJbwu5/epgl2p5n2RdNELTRjuNZo/XSz1tUF1eHjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mx4FUOVhRle1Q+cz3pgTNJpoB8t8NEhbkH4BVaHNjCJzCsxpndJ8/VO6fJnpbsw/BuzDp1aG2g9RecqFC6xffljITgZW4IG3TNNQkUd7tevt5bBymX6AAWB/IxGNHuW+Ey4f9hxnXGfUdfmJxjZLzNbIek2IsymlPS03O8mbOGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AatjiUj2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AatjiUj2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X51nx1CHfz6ClY9v;
	Fri, 13 Sep 2024 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726249292; x=1728841293; bh=xqyDQIoqZjQ2fEbsTKhOiFFn
	qZZY5hTOfZg9GgG1tyQ=; b=AatjiUj2NlM3NO69WMmWLryosaRyL6sPhQIFWG6n
	RMFdM6KJA2CbWS0o3qda86OPVmNHcFWrW7fd8iLaB1WoiDOIgTWnSWT1GlkLW36e
	YcRNonztC87ZocwB8RFYXUE+xwhViBd+nOlVFGK9Or2nKC6sNggVSqhzgdjzWFnn
	2SSABOPCCOVFYLl1P+WMrQl/jChUAHk2iZy9U4ajc02Jte6dTsdcWUo7+mJ0Mrdy
	NDIrXqpuEN5ShhHB/VVRa0OXszpdmiQ5PXaAUkOYrU61cIXV7Dw3YGE2KvzezpA/
	dKbdQ1IkDjog0PaQjJ2Q1VG/QU7yrbRW/pYa3bK/s612dw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lhkbSclY8FRY; Fri, 13 Sep 2024 17:41:32 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X51nh3RLbz6ClY9t;
	Fri, 13 Sep 2024 17:41:28 +0000 (UTC)
Message-ID: <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
Date: Fri, 13 Sep 2024 10:41:27 -0700
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
 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/13/24 12:10 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Because the MediaTek UFS controller uses UTRLCLR to clear
> commands and fills OCS with ABORTED.
>=20
> Regarding the specification of UTRCS:
> This bit is set to '1' by the host controller upon one of the
> following:
> 	Overall command Status (OCS) of the completed command is not
> 	equal to 'SUCCESS' even if its UTRD Interrupt bit set to '0'
>=20
> So, MediaTek host controller will send interrupt in this case.

Hi Peter,

Thank you for having shared this information. Please consider
introducing a quirk for ignoring completions triggered by clearing
a command, e.g. as follows (there may be better approaches):
* In ufshcd_clear_cmd(), before a command is cleared, initialize
   the completion that will be used for waiting for the completion
   interrupt. After a command has been cleared, call
   wait_for_completion_timeout().
* In ufshcd_compl_one_cqe(), check whether the completion is the
   result of a command being cleared. If so, call complete() instead
   of executing the regular completion code.

Thanks,

Bart.
