Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527036;
	b=zQeon1iH/pUn1qP/RZeGOoEkdMhuOqt+73O+FZ7LsGKfOZ1yv9SeWM8ijG/RYZzbrO3b
	 TsmmhnigDKbohF12NabWQkEN/f+eC+1B9XLVyoQm39EhjG2fxHrAuCKXKvRZfUIUxnG8Z
	 1rSxaXTOJ3WNOWVBp393T8ZQTMW8dfwZF+BNtDQUrFqU1kNHc+PU/2katlXq2S6DkcaxJ
	 urZ/htunSfh5Z8dQklIVO2Psip3MRj72hNTK3Lz+8UutRw0eAKxDwXns0rLbvKI7/yZ5s
	 SzNtTXOps3/xXSnl9HIzlZRbMZMbKogK6Q4wGhVgtwWaorTs3hDJ3oxTN8+aHeF1qbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=AaK72SNggPqYF/BC/D57qO7dCLlZ7Z80+TEYhpfdQSE=;
	b=oA1yb+S/jyIEp078FIe+c5sDUEK75k78GwOPIox6EslouSq1F7oFvCk5/FAXtPhj3MRQ
	 xyH93jiBHZQ21oqTO6+/Xh/RHo3QGoH2EtfV+sUOmzHNoMwMbdS4nuHfbYkcCW5ImvlmX
	 469rjspp/N/GhXVigcuUrh5ns8tVpeablxyhXJ0/t8jf9bkdlNyW4jrm8kOAW0V0bRPTG
	 YgQwJp1fRN/fHh6urZrzirgij2WLvqQhGBlG+esxb4InTLwsmnz+qI/WemMtEGuXq0Rif
	 UmZo4XoXi0L69IQuxgFBRgZIeN35dgNim2iPuPsqASr+Vjk9iDL8T+4QUDwS4uaYsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DSTSAjky;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53004606A321
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 13:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53004606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DSTSAjky
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so39555875e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 05:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795527035; x=1796131835; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AaK72SNggPqYF/BC/D57qO7dCLlZ7Z80+TEYhpfdQSE=;
        b=DSTSAjkyYTAlehNkylmpxXQAMsK+0vWB4w08PbpwuVv3LL4OZkqY2SfOeI5hYeQKOI
         LpiQmLS7NRi46Ia0LqOnPVtVEisOA9Ggcu/slTOYH7Gx7jBq64Jt5vmS8zEi/bZBeusP
         6JHuekAWvtby4QDiWD7P/4bQFw6DYY/8uqVu4vCrExT86+cgYFliyV6U2TdUDVSFzTnp
         cqJhTHpXVcYfuOYQDqBv8FueMSsASBc/JBRq6jmHUrzmLCP2FeJlPexA1SrZLd3sjHQc
         aul10rfW9Fn4vKd782dhM0G8YvwNLJXd6Sb4eKYU/MVfT/EHtPSdFzAf/+uikM4NSXtL
         lEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527035; x=1796131835;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AaK72SNggPqYF/BC/D57qO7dCLlZ7Z80+TEYhpfdQSE=;
        b=VjzNabatHTlkC620JrlWXFnfZvxFd6JjVgxhvbJOtp5gCuLQ1ZPuRYGZHIukFcjeWl
         ZqHJ7e8Zu/RAC9oTpm6InNcoaPfYnyM8GUBR9YjH2+OK+gc8j7MCWZpwuMHWc1jz81N2
         vYWxxiKVaaibXiQvlG9UiqfKtPeQ8yzhSlm3Xw+xu4phH/Sr0SKijpcxAi8XZAhQtfLP
         mkyU7vfFxPZ2YVs+B8xD/AYJRTBLMJL1+0Mg9h/FfTH/mRvmzHnU1KiU96dTpR23sJnG
         +6SEmboymbuVCf3X/hI2jg8PnmcU7WFEWtEaJNbzqvXv3phGhstt5AYE+8KByMvXZzQB
         iOrQ==
X-Forwarded-Encrypted: i=1; AL+hErFW6jCf8pFWziQoqmJ5XVQkvPB3v+CuUVIE3t6z1FHF/Ld++TlR5bMuMmU7fuu8mpyrCbSQ1t0rq1gy@vger.kernel.org
X-Gm-Message-State: APuU4Z+57ebGe3JrCuvAOE7PEcMfFI1as3fi+WctAJOu/fJT1Uok+DJQ
	cZxicTTjG3Z+VAR3fYrzpiJOROzmjfE+9F80/j/D9RBTkdMxcX4N+AULpt2Lc7gMROg=
X-Gm-Gg: AZFdTZejkcogepXyqNFkOmU8jskNdZwS44zXh5Qsy2hMtty7XiRSUF77xBiv7xkGR05
	AjtHvgzk9bae3i2sx8cKtUpH7sI7uMpZcO+17JDhpNjXJW6whdNFrJO4P8XLqrwI3BUKDI8oA/Q
	upJpx0BjHC1RuwiafP/1Z5tbzX+6bOqb7XsrZHDfO1UsX0Ar+QgNLbU+3my8stRhQf5uSdOuh0S
	x1FcyMaWv4Ll68uB72GG/jpnX0JHL936x8AjlKuBjKrkxZvMA6eIR8tMnl1J2jGTQZ5Yzfi5tTO
	njnF03adNj/Ikjg1NDoQ7XQ1+ErEc5lX+PhSYLjsoAcHDh7mjZ5/PnLWu1I75ke1FLeYfDstOde
	CWHcVJou2kSw9VGB7VA+/oUf8xcYZ536oIKXmDCSdy7szMM8hIrLT+jyKU6GzTNVYSLAPGlwSA1
	EsGjobvkLGXQNunqCfd2ORWYxlyjdgquZ8PtXGz3J86ecH8mPHNu0Y9roWhyYAJq2dLv9peLwIJ
	kQEHDF8EjbpXX3pCkFsCA9AwurjlPoOxFH50lmdr+rSnPWBRvD8t/53vZzg7hHNoennheg9fh8g
	l0MTxJ48fSPMqUDIYmWdXLDuzKF8VStIDxdUZvKQe/bwzdQjs22lVR8YShszlWhrZJ1F
X-Received: by 2002:a05:600c:500c:b0:4bb:82f7:549f with SMTP id 5b1f17b1804b1-4bb8881409bmr321872905e9.19.1795527034467;
        Tue, 24 Nov 2026 05:30:34 -0800 (PST)
Received: from ?IPV6:2001:a61:132b:a401:6cb8:7c28:11e1:499? ([2001:a61:132b:a401:6cb8:7c28:11e1:499])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm227938555e9.3.2026.11.24.05.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 05:30:34 -0800 (PST)
Message-ID: <b2ad19d9-87a8-4106-97b3-46e6c649a9be@suse.com>
Date: Tue, 24 Nov 2026 14:30:32 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [usb-storage] Re: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in
 sysfs as ata_passthrough_disabled
To: Nathan Stratton Treadway <vgerlists2026@nathanst.com>,
 =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261121155253.4980-1-mat.jonczyk@o2.pl>
 <awRIRpJIxWPJcn5i@diagon-alley.stratway.net>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <awRIRpJIxWPJcn5i@diagon-alley.stratway.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.11.26 15:05, Nathan Stratton Treadway wrote:

> Would it make sense to explicitly mention something about "USB quirk flag
> US_FL_NO_ATA_1X" in this documentation entry?
No, probably not. The exact flag the kernel uses internally
isn't and shouldn't be exported to user space. Hence mentioning
it in the documentation is not appropriate either.

	Regards
		Oliver

