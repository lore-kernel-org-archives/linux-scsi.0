Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C342836A4
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750697; cv=none; b=aNSRKDQUuVCvrFUzVqDywnyjqQFDwnOoCrWHe+PV94Vdd8Z1Q7AHCyKCX1jt2DRyyeZVcKd87hx007gU9SUvZPMozjasAe7SoGCTm7gvb6JlVgyDj2awU/SVXakgEYaeuWSzbBihu5oOFdccMmfOkhbKCTF1PAHSwV+K0hjOX3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750697; c=relaxed/simple;
	bh=RxifU/yJBlbKqgA0WaFg8THK6N2X/+zda32QZLg5H2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jiA51Da8i7ARsjbzVWfPvnWpB5WH8NsNLZ1NyahkNK1768GeDOFVVikL/H7Hvsqr1qRcgaA9oH1TpiNRXbkPhaLOmM9tEPluJe/trCc0rHn+o44y6cnKKMTowXLYYjmqHqVp6cF85/vJYy2pWCAgP+7PxOAF/wl7PwWhHpvlluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nKRux05T; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nKRux05T"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cX9Xd0437zm1742;
	Wed, 24 Sep 2025 21:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758750685; x=1761342686; bh=RxifU/yJBlbKqgA0WaFg8THK
	6N2X/+zda32QZLg5H2Y=; b=nKRux05TVIlp1cnPyfF86UrYcJIL88LNazwETS+d
	gYWZ9LwcEuUbw+H9vn0RDeeUhbgaa86RuPcYhQJIbaQCa/lBdT57Ddip/7m1oix/
	oWp5S/bN6OMVW0eKFyj9z6l+gqRMbA3n/va+pV3yPpFmiBlwnWtjsNH8chtoMNE2
	7AH/BNFaoTqcWp0L//ZGbj0BIuwhpFqwKNUC42ihPlxtZO1RLT7JHaYIJV2IYaGk
	JUJVeFw8nlq/tsXf537R/RV5tWS6XRQkecdsL6+sGZTKtl8N/+yV9tutENG0jBQM
	MLf1EkXH8hPPFSMV6BGChVNPAQVmNQ2aWa6Jxl92IqXR2Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 285EyIrC-T2E; Wed, 24 Sep 2025 21:51:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cX9XG3Bgtzm0ytZ;
	Wed, 24 Sep 2025 21:51:09 +0000 (UTC)
Message-ID: <c2b02246-1ff4-4882-a856-4af888f1a80f@acm.org>
Date: Wed, 24 Sep 2025 14:51:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
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
References: <20250923082147.2491450-1-peter.wang@mediatek.com>
 <ecc17025-692d-45fe-97eb-9cc4c4ce7a06@acm.org>
 <2ab086da45acaab5ff6ff5117670a8ae65d2f0ca.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2ab086da45acaab5ff6ff5117670a8ae65d2f0ca.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/24/25 2:26 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Are you saying that after the runtime suspend timer expires,
> the error handler might be triggered just before runtime suspend?
> I don't think this can happen, since there shouldn't be anything
> triggering the error handler when the bus has been idle for a long
> time.
Hi Peter,

The UFS error handler is not only triggered by bus errors. It can also
be activated via debugfs. Do you agree that activation via debugfs can
happen concurrently with runtime suspend?

Thanks,

Bart.
