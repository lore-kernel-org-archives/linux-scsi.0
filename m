Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48B309F1D
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 21:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780003492; cv=none; b=EAuXfKRP5sEPlMDTnwy7lTjt7R3FVfR7Rt05CiUhyvao/AfAlfg6k7hnZTFPf9Zv+QYxYmLH6b7t9uPsSABTy1v4/eD9y0rX7I0tRwUG8DoI0ditXs3luw+AgTPyHoFgPqT0BqK/qZ6LTd5jJ9Jub+IfzPJr+TmQ74T6JOcoA7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780003492; c=relaxed/simple;
	bh=lNHIcD9CNxqoxk+F5U0dzClf0Y/TIFmA2boxKoC17Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=taQmgvgOAsBpXNtxo0JPJls2FWIP8OGcZ6qlp0cG9aEji6mLniIJOQjSUItDF/qjeKoUnIb9R9htGf6d+DzJo4XyTgQV4Y3gaRgOWGzpqc/gFM8C9L7RZMmnBnjDDjFz4lILZ8voJTvYJ0IG2bp9fuwiVCB2kXPxxXpIaXhrmvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mST2tiOf; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mST2tiOf"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gRKJL6Vfqz1XM0ty;
	Thu, 28 May 2026 21:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780003487; x=1782595488; bh=lNHIcD9CNxqoxk+F5U0dzClf
	0Y/TIFmA2boxKoC17Vo=; b=mST2tiOf8jL7aMqkGorcDi0nuvckP/xJk9vqPOq0
	iQ/n798UY5tv7UHWDUutYAWYa/VVY6HHL9mBln70UcfwMxndg0FnR6fu4AsXbdcw
	j+a3drS6woeBBwCWcmaumS6A9t8cQGcrawsHo9tNUV8u3jpVkazUumH0C7wluMPi
	icM6cXAdmYf8wkt1i4wGGNO7+MxMghnwxPTFurHFhGo1Q/JFbEWXM5aiVRRghS0O
	2YKt1Yo66WJj48jBqE+/UiL0djIlzn9aqohWW+qDRyFST/wz7MPc+LVPGVoBKL4+
	gBaNHCRH5DS4VBrQ34Lcj01jeCWpEboURmWAAhnHOXCphg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z-GOQyxgSBhl; Thu, 28 May 2026 21:24:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gRKJG6BF9z1XM2FS;
	Thu, 28 May 2026 21:24:46 +0000 (UTC)
Message-ID: <9f50fb13-b3e8-4d1c-bb4a-045a15b957e0@acm.org>
Date: Thu, 28 May 2026 14:24:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
 <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
 <bcbfd7a71f698f6a3dcf627d3ea76c79b9897ccf.camel@mediatek.com>
 <064b4c51-c3e8-4380-b1a2-ce996078efe8@acm.org>
 <e02140af260edd8f0391889f7c925378dc79bf10.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e02140af260edd8f0391889f7c925378dc79bf10.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/18/26 2:26 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Sat, 2026-05-16 at 07:01 -0700, Bart Van Assche wrote:
>> The patch below reduces the time spent in UFS completion interrupts
>> from
>> 10 ms to 100 microseconds (100x) on my test setup. This patch needs
>> further refinement but is sufficient to show the root cause and a
>> potential solution.
>=20
> May I ask if there is a planned schedule for applying this
> patch after further fine-tuning?

A patch series that reduces how much time F2FS spends in interrupt mode
has been posted on the f2fs-devel mailing list and is also available
here: https://github.com/bvanassche/linux/tree/f2fs-irqlat

Bart.
