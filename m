Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC14933C189;
	Tue, 18 Nov 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763487127; cv=none; b=CXa3U3/xbvhKS0tkJymifS+AWtS2ND2g5nbwx0XoTj70ZOWcfALfMvz7deON1E9NyTnYQ/4lUXxtyY7amdkLi8bs2txF2+6CLOGaxnE5ynR2k6kpChDvHSiTG3UFQmsA0X9570MONgPh6r0K+u7Wo+ekqWLPNuCdhz6G0kZt6Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763487127; c=relaxed/simple;
	bh=iKbJl8xVpniMCgJ5orBlSij/L73PPQUhbimiUfXkh+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LR3f1IlSWqVUgNsxL3SLnf2bVfk2HBaSR4lImfbjtHs31uXu+1H84Jnis23VCC9UjcfHbUJQfqZ4j5pRPqe71KFTi/XV0qf+oI/8E8YnWI5+98U4XgtBhcKPCW3nC4iJ4ggijsek2S6Zhxjk2fPQDo9E0iCzAlUwLvQzY7z3x2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zKZ+YgB+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zKZ+YgB+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9s9w4snJzltMVZ;
	Tue, 18 Nov 2025 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763487123; x=1766079124; bh=iKbJl8xVpniMCgJ5orBlSij/
	L73PPQUhbimiUfXkh+w=; b=zKZ+YgB+oBDs4bb2xuVJFIvPQ264tEiTVch343DB
	OJaR0yWy8AoMbNm/VfqRSyV/ubh5IJumnBTHdMrLXj5aU3k+jjTJtfDa0AgOPU54
	yClpOHr4GX1wIPXBpuSiE0z2QtJEeES5nCcm9QiX+DMEgwxiepwGbAbEd5xuKman
	n2292U3gwUt0wO2SMJ95pde+tDBYT1ecWgoM5fBOekS1fCSfMnIT/PgJ5yadw9v7
	CVxbg0qqZAnseUSQVaqg2fQzNF3Nb7DT/Wv43pRpLEVvCHq9r3TYNsWrrFx0y/eU
	RwbpzR/WtYzbVIKbk40chtqnE34+g6T+lemXMTqEPAEPDw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x6kDp3IJ6Rms; Tue, 18 Nov 2025 17:32:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9s9r1x5Bzlh3sX;
	Tue, 18 Nov 2025 17:31:58 +0000 (UTC)
Message-ID: <64bbe1aa-db10-4766-bcde-71a36d853987@acm.org>
Date: Tue, 18 Nov 2025 09:31:57 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
 <e3dcb711-990d-4e4e-a128-8a0cd0ce8886@acm.org>
 <a89ccf64710deeadfce9cba08e28867f88463c77.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a89ccf64710deeadfce9cba08e28867f88463c77.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/17/25 9:55 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> However, in extreme cases, it=E2=80=99s possible that after a 30-second
> timeout, the device just send a response, and at the same time,
> when the host receives the response, the IRQ is pending by system.
> (other irq is executing or spin_lock_irq, etc)

It is not clear to me how this could happen? If a response is not
received in time from the UFS device, an abort TMF is sent. If the
device does not respond to the abort TMF, the UFS device is reset
(ufshcd_device_reset() is called if ufshcd_abort_all() fails). This
prevents that a response can be received after the error handler has
finished, isn't it?

Thanks,

Bart.
