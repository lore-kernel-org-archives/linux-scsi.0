Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798151D0492;
	Sat, 14 Sep 2024 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726330446; cv=none; b=sSdRsCuZ+2uNq5ktnlyQb9NTJZqiVsRNN8Pkvzvn3eZ3U0/F6KuuzZ+za4FYUitVlO9tM1vMBqkwZNk60yvnzZu2TKNuYlNtWuOa8e0HP219AAj90PgxBuWG8hez0IYydPN4jDRib1+M9VelKk+yNl7t48PPKu0G8krKA1Dqtgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726330446; c=relaxed/simple;
	bh=jIr2YQ+Z3fnuhX48pp6i/fQEJqiBrCDPJT+nV4erRtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1Ol26UJHmlx1SFix+UBBLzk+pBnb/fxIcQQO6qAPfbn1HaojNS048Heoxmv1fN5LqpK534iBdEZd9PRnZqLwALu8W8WUkhI1MPX6vVFOHrFijrGEMa1jGU2Et0927CgJ/pA1iOne4fcobU31fEtQML998Jc2QZdDpwpY0gUH0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UQR5Ec7W; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UQR5Ec7W"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X5bpH2VfWz6ClSq5;
	Sat, 14 Sep 2024 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726330432; x=1728922433; bh=jIr2YQ+Z3fnuhX48pp6i/fQE
	JqiBrCDPJT+nV4erRtE=; b=UQR5Ec7W0uh9BO6WmwwVbx1oD6MEFeyWqVJ7FE4m
	UkZV/K/isyv3jZFd5o5lWP+jrpC/RtUnlVF9PfMp6ZhvnFyTSbIvOSZZwqSBErij
	xGlD1IeWLHpu37cGvZmTZCtOMRTEQB9ycd0BwHEPoNOe7moQIpVE5xErge7CLUZ6
	qU2D97W8hcPPEezA6Yb/aWmcxI+02GcFWDjFqYlv/OMNAQeQAvwW4rKDDOcOzeBU
	TkbrMJgZUARrArBGyByLS8SyI45dd1MiUQPG8Qq8XcNf0RtChC5/Ut6Ab1Z7k8UI
	tEhLO2fJHAiRlJeUnNUdja9gnW7NiYFoo6cK2snTRqqIXg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4NfNGd6eRWrA; Sat, 14 Sep 2024 16:13:52 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X5bp443s3z6CmM5x;
	Sat, 14 Sep 2024 16:13:48 +0000 (UTC)
Message-ID: <9ed20622-c228-499f-80d9-23760e79af1c@acm.org>
Date: Sat, 14 Sep 2024 09:13:46 -0700
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
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/24 11:03 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This statement is not quite accurate becasue in UFSHIC2.1, SDB mode
> specification already have OCS: ABORTED (0x6) define.

I think I found why that status code is defined in the UFSHCI 2.1
standard. From the UFS 2.0 standard: "TASK ABORTED - This status shall
be returned when a command is aborted by a command or task management
function on another I_T nexus and the Control mode page TAS bit is set
to one. Since in UFS there is only one I_T nexus and TAS bit is zero
TASK ABORTED status codes will never occur."

Bart.

