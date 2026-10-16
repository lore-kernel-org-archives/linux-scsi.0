Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC62D738F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 03:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121939; cv=none; b=aZ8YGdLbJYci8K/BzH/UhjB4u8FDBQcUu+qq8jotAcLN6G+byqIXN/K3CM30ETkp+kF2wb2IukS0Nf1+dET6FHsLpES22IBvJK7loxvKIrmoiplK1tHElnWz00XA5yc0/00tE0CLVJf2ku6ab+QLT4EewwqLH6IOvCD0vT1fUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121939; c=relaxed/simple;
	bh=4E/cN0Kqcsz+t7k3QiXCJekPREW/1Eg+6EsD48Jvg4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mF8gzL0YUbmA31qz6oUkjAsOywC4Cdeu7IuOzDVnB0p1p/UV8Zp4l2pqTjVfrqtfQXqNHp1qwSFz5GZhFoai5DPz6KEWQqbOT4Za5dySc7c08FRlZ1A+jI0YB3zaTyDaQz703kKB3FrLlfDbxkifLhiU5kbU6J8/ZunaiYrb4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DtaitbSA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DtaitbSA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5VzQ029Zz1XM5kD;
	Fri, 16 Oct 2026 03:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792121935; x=1794713936; bh=rnBqkNcETYt2zIBujyEq/Gci
	y6wAitQHLyWNqIB2dl0=; b=DtaitbSALBCYGdBw3db4f+5q6zz+rsK5pLMsKBcu
	FKy7jACIcCePkHya/HHPn6YkanpqwB1RcnaIVDaU1u8SkVXVT6Q3jTyeqNyv9wia
	OP5JmKD4stm2KsthlsFV+jthL3lfIiXKa1wCg6sDp4nLgXq4JaQuCuyEvKkK188a
	p0WJs8WtKoihbvrYOZEL2eW1X7XYb7TMRv+bLm1fCSy5Jq3OcHKJgaMPNoEPsww+
	gUkt09VLpDntFSrVFgOmCPadhlGttg+tHQ1M7uMdOVQCviu9i0PaCWNmEzyNmmRC
	0xKSY+3ajzK7XOKmtV3D+aSIyanA0D1HHkaT4klMD8gYzQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2XMrP35FeHsY; Fri, 16 Oct 2026 03:38:55 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5VzL2GTHz1XM4Tl;
	Fri, 16 Oct 2026 03:38:54 +0000 (UTC)
Message-ID: <9c375265-e198-42e1-97f5-fdfb08563d41@acm.org>
Date: Thu, 15 Oct 2026 20:38:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/54] scsi: fnic: Enable lock context analysis
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>
 <20261016023120.GA2863622@ax162>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261016023120.GA2863622@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/26 7:31 PM, Nathan Chancellor wrote:
> Hi Bart,
> 
> On Fri, Sep 25, 2026 at 11:26:04AM -0700, Bart Van Assche wrote:
>> Document locking requirements with __must_hold(). Suppress complaints
>> about conditional locking in fnic_device_reset() with __acquire() and
>> __release().
>>
>> Cc: Karan Tilak Kumar <kartilak@cisco.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> I am seeing the following warnings/errors with LLVM 23.1.3 after this
> change in -next as commit 70d2304ae575 ("scsi: fnic: Enable lock context
> analysis"):
> 
>    $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/scsi/fnic/
>    drivers/scsi/fnic/fnic_nvme.c:1332:2: error: releasing spinlock 'iport->fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
>     1332 |         spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>          |         ^

I can't reproduce this with LLVM built from git HEAD (commit
d7ae8658cb98b2ef2c7e6ebf21912f31d2c1feeb). Could the above indicate a
bug in LLVM 23.1.3?

Thanks,

Bart.
