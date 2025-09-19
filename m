Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C6535942
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 21:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758316273; cv=none; b=u5WzLIXgaDsn2NR6WCjtL+hXzzzlZqIOgNGwMRYcjmQlpILfT5uDB7U85w+Vn0E4Ti4wYOKQpnwWs2GTrxBDryhmhMk5lEIn9BBXmJq2lk3EZs1v/hd/4L/yXMZo7f3qCmT+pIPtL10peA/OzHdGpy+XcdsRomy8cbOXq+zSyUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758316273; c=relaxed/simple;
	bh=ZJnkRVItrHYeZT5j+XOWub8vQDdOE/cSEXzXQKdsjVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n28RYO4e3d4zAx1qkyGiKMiPk0k+DVHa+XEqk+wHoJ5eldWiyIYjIJBxZ29crsuZ3RLyf3Oc3AsX4dt2I9O0BsUe3f93t03verRHXiDXev0Po0RvRlZquCtlgPYQD6fx4Q+ZQgMdoHpMvO35opuJeBnESaXJN4lg6Bq5t9fsPE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fSuxF7zU; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fSuxF7zU"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cT4tQ20Xhzm0ysv;
	Fri, 19 Sep 2025 21:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758316267; x=1760908268; bh=ZJnkRVItrHYeZT5j+XOWub8v
	QDdOE/cSEXzXQKdsjVQ=; b=fSuxF7zU3h9Juow5YX1LA/fUzFegc3iiyjon3CW0
	vQs2JhiD1vS/590D6kWfzKJijEAdkq+i+wjcgLWpPn8XRPhukV+DilGDpuGthlO3
	KvxsuaJ5LKW9pqnyaZtPXH3pK0S0N0DqW4Omlle6BKxc7iIIazN9rfyESrpxLwaF
	PEAbHiI6kv4W2s8YfMjJRRL7jevAVCTrWmS4FVOm5F7gEuSb6XtwP95v+fAoagEA
	zKaE7RY2RD9UEI0uU2g2H5iSj+xW/yCb5vxFcz4uKO5E2hbl4k3Mar3qn2yAfFpf
	j3UTcwmhzIm7PbLUtjm57R/DwCcHS0WN+p1RnJFtFEZhWQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iLi1iDk2A3mY; Fri, 19 Sep 2025 21:11:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cT4t540Kczm1748;
	Fri, 19 Sep 2025 21:10:52 +0000 (UTC)
Message-ID: <b9eb48b1-f6fd-4b32-8e0b-b7434f17b0ee@acm.org>
Date: Fri, 19 Sep 2025 14:10:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/10] ufs: host: mediatek: Fix shutdown/suspend race
 condition
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
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-8-peter.wang@mediatek.com>
 <6f4f954d-64fe-461e-9c65-6630b0409710@acm.org>
 <e91b0fc0894eb249b853e149f2f889668c3d2e9f.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e91b0fc0894eb249b853e149f2f889668c3d2e9f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/19/25 1:15 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> By the way, could I know the reason why you want to
> remove ufshcd_is_user_access_allowed?

The name of that function is longer than its implementation.
Hence, code readability will probably improve if calls to that
function are replaced with the body of that function.

Thanks,

Bart.
