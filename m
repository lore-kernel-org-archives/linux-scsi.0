Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549251E47A5
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766572; cv=none; b=c5gdynJtJadgx17NEfaURP13hNRiVVfPIHq35j1AhDNPO/2OanAt57IaGEC0rJ/Wt0nzU6wSjRtWXKWeHfIjOrOM13ze+nip6QXkaoFoL6+whY3ohCgXWHKCNFMg7642LmWUc/+3IFOitcOY4BSWCaYN+ewXrr9zTTMCQbMckaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766572; c=relaxed/simple;
	bh=81N1PUV291vvj+MO7dmGD1k0lnguDaB3fIl3SdntRhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UdSOzRQhWulyJ/6pQCFseRIn25K2+d5wpsTvw09Wg0YuNbZ5HztAbIgcZE0AxzCesSbQatzk50WYKnNT35s8nk1uIaOWZwIE2TlJxpIhqlDar1lWCTKmwYmdgSciBZYXoZirHrbdbRSEM72bRLlHc5A2o2L264iodvhwFk8Ijr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Es9hyuBk; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Es9hyuBk"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjcTN6rZDzm174b;
	Thu, 17 Jul 2025 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752766565; x=1755358566; bh=81N1PUV291vvj+MO7dmGD1k0
	lnguDaB3fIl3SdntRhU=; b=Es9hyuBk4aPHyw/qMCw4yweSzmKucgk0jvZzl0sC
	mgwoVJ0sPlALlvOmWiDA4UPsLU+M9lcUFN9z7f0ubRGDEEo25ud8NbZs0brmTVr4
	2eF6TNRX/kt1sEKu1/iC3gnzjuS8OzCbFXeTNTJEF8CWO9aK3xTKzSM4Gsg0hrkf
	9RDo7RdMHLUYMMFlLdDNt5D+PXeJqgO2M7NTf4A5yTipHKdOpb8Xr2QS58td+zwj
	8CdaxBEypd/CCsGjyeVicj1gE7uUEL+8piQE3fBwMd2GdciwdlFPoHLVviagGdSh
	sA6Zn/Bqes2J4SA7VYro93VkYm1tQP+2nPe0TU3YIfvy9A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0ocfl1ONZf6O; Thu, 17 Jul 2025 15:36:05 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjcT32V6Mzm1744;
	Thu, 17 Jul 2025 15:35:50 +0000 (UTC)
Message-ID: <3a0d5a4f-f689-44e8-9f01-f6eb8187805c@acm.org>
Date: Thu, 17 Jul 2025 08:35:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Change return type to bool
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
 <20250716062830.3712487-2-peter.wang@mediatek.com>
 <f3679ca4-9c77-43cb-a0eb-a4915f0f2c3d@acm.org>
 <c82877e4d1c1f8f7bb39d0ad7dccd4cbec0c91bd.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c82877e4d1c1f8f7bb39d0ad7dccd4cbec0c91bd.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/16/25 11:37 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Or do you suggest removing all the previous usages instead?

That would be appreciated!

Thanks,

Bart.
