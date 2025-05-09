Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFEA238D49
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746810728; cv=none; b=fnxM4PxJbuT4IzIaL61th/+h6mlXDaNgwt74SkXK0T4oYYttyxDSjw9GsaVKiGS/sVA/QPBxhiS0+X3UBjB4dlH9oF5X+WDcmfopk97WxGKB+2/FiQmGSg9Z3/RL83Wu6cHimIdWNmq48dv9TofP7l8mxravib4naraZUIXTLyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746810728; c=relaxed/simple;
	bh=ldL7b81Phg6WD3JorNI5nzK3Myk4EQ4CIaDc6kAidBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpSkJvWLhFYW4Qx7TaQM4Hktlhge0RxZGOR4I512HeZJZ1J0GdFfVhI++R+AbELohl7kDiELhMrmy9w364XeDGOT+RQkQLfltFPbmlQlliyo0Fr+5/c7Lk5UPRkXqgzQMiEm1J7Jg3URz/6MwxrZ57HdQ/y0vJzOV3KxV0kw0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2izYZXnk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2izYZXnk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZvFsx41xbzltQLV;
	Fri,  9 May 2025 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746810722; x=1749402723; bh=ldL7b81Phg6WD3JorNI5nzK3
	Myk4EQ4CIaDc6kAidBs=; b=2izYZXnkpQ9whLB5pb2pTUzdnOt7GhX8um0Cqa7S
	pzKFsjFTKUmmWeL+NpyNOhXsBfKdTNtqDvuT6RUSVxZ6fumPhA8RnfDYylJo0TxP
	hBOyd0J9eE19euHh5Tj6uPV3Y95Z+5uGoLHQK2kVQ0TsqhZBPNbvCP7hPaIfMl+C
	O+4q9oPt4/rLn3Jb/IE2imVQF0yU/iYnBsZ075v1DQ85RNZBhLtdDteaxXZeCFc1
	x3iZYsBk0lUkLrXujnYdDZ5A9F3S6Uu1qicpP6naN/zDSrIBzfe50xkXgs3NJFe6
	FtlId6b70q6yjve2XUCKBxzhBt/4Py20GLpt24QmHE9SVQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wwVKx8GkcS57; Fri,  9 May 2025 17:12:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZvFsb4yXKzltQLv;
	Fri,  9 May 2025 17:11:46 +0000 (UTC)
Message-ID: <bcf87e8b-a994-4168-821e-9c1c4d4771b0@acm.org>
Date: Fri, 9 May 2025 10:11:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: support updating device command timeout
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
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
References: <20250509071029.446697-1-peter.wang@mediatek.com>
 <946d62cd-b1a1-4ddb-8411-2060362f7d33@acm.org>
 <8b56be3dee19dd210ceaac46a30f29f34b31a83c.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8b56be3dee19dd210ceaac46a30f29f34b31a83c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/9/25 9:11 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Do you have a recommended number? Would min value 1 ms be acceptable?

That sounds good to me.

Thanks,

Bart.
