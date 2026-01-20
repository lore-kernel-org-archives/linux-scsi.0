Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A249543634B;
	Tue, 20 Jan 2026 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768916907; cv=none; b=EAhEvJaVCXDqrhSgu2h32lBKtSiLKjGFIyGwPbDaaywYvFIvM9aTSw6jggvO+xN216JLUOYB7XIN/xY2M3K1uUqxdy7ProNy+vHp/wEpeWFk3goRyavSTPCijUrxJ1dvmD87SOgjNK6PEtFkUBe1HdkoxbyN/5BVbzPCEpWfukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768916907; c=relaxed/simple;
	bh=DdCeDquolF/w7F6B01lbUF/rIeGCTbJAYlhr8LWHkJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KNI2YjCQxUYqED0XJSTECT7G4YqRxOszl2iv+IdTAnr86H7tGGK1M+v/mbsh9Yqo1yTW03Efr4h1Jycz4WxKK4oQn1VT719u5NGwJDUPTOopUm8gcsqEiyFWIwg8kiNEnIpNMVykMFCwbAxzT7IOEkDMh3q4wgXWU/7uTGw4WJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HTe8UjMP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HTe8UjMP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dwTDn1j0Jzlfl8N;
	Tue, 20 Jan 2026 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768916902; x=1771508903; bh=SOAdpbDm0eHpipCEaZSPiJYY
	fuJseVJynyq5vsxpEV0=; b=HTe8UjMPTjFI9fuDL/EbKshTsyDMz8UC31uq9k1O
	Cfy33tTlYI5lLEnOH0qyyH1qVdEMv+/PgjXJ8bQKvhgP9DNWjIhegnWrnqd6He9q
	lGjsPcxa63+y29eQGndXn5GOzJ1Fav8lDjmnjcxuSo/j0FlHmMojrSR1Pn0z4WUx
	OFvKWP7SRWTB4vZ/j2dsu/aujjuu8Mv4+wtauAAGawlQvAmKtOrrGFfqqltPyxSF
	yzPSkobUXBU0Jrz5rNnsCRI51UVfEXB116vMtHoaqYO2R2g1YzqveQbNHCX1bBd/
	e7q5iMjhhmSSpyGE9opMZ/+oJhBRldiPMP+4q64iaxhGQg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TM8u1GgFmxyU; Tue, 20 Jan 2026 13:48:22 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dwTDf2ftVzlfpMC;
	Tue, 20 Jan 2026 13:48:18 +0000 (UTC)
Message-ID: <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
Date: Tue, 20 Jan 2026 05:48:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
To: Prithvi <activprithvi@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
 jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260119185049.mvcjjntdkmtdk4je@inspiron>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/19/26 10:50 AM, Prithvi wrote:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&p->frag_sem);
>    lock(&p->frag_sem);
The least intrusive way to suppress this type of lockdep complaints is
by using lockdep_register_key() and lockdep_unregister_key().

Thanks,

Bart.
