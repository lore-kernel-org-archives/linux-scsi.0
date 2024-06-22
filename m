Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0528825632;
	Sat, 22 Jun 2024 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719073454; cv=none; b=lR8DLhM0sLaZZ7JcZfR1GG4GMoVG9Vf8Gk4fQY8Kjv9IlBOkLo/OqIhjSVGDBg6bQr+D1334L18CTjCcKrfvZ+uCEJ9bW06Xm6QgzjmjdnLWJ9xM4pVG+eCoiyUUKC9EWSRJk/fr9DrCHhDPbFkpLL6+Ky6IUPjoq5KPhBan+Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719073454; c=relaxed/simple;
	bh=Z8i8kg5ruIzaQvF9ui/N+qkFWHcVNLwOjp79GXf966Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pvJq0JOqP3y2uL6UwTkqYCZcd25rXo5pCZDc1Kzt1LGmYBBl1W64dnJ5oyca/OUyjyUv/fJ8GfVAwo7/39IpZ/sdrVbj9o3HEUbbhdAlPyzi0roqqzpbRmie5Csl+GPX3H5DtoqBEI+oSdecE3GiJ7NXerypu0Z0vTYUDowESrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FH1ddIgZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FH1ddIgZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W600r2Qzwz6CmR07;
	Sat, 22 Jun 2024 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719073448; x=1721665449; bh=UJYdrMEBRW4r/lhwmdGKzFlw
	KbiqAIgd3f13bjcWoaQ=; b=FH1ddIgZJpwB1bvqKj8JS8eSHNwwf8OSbKi7+1Zh
	9jcGV/HC3zNlqLy4vaEW3ooGNDUz6hmIrHklq9B+p0msaVXGcXuE/DnUlbnKvmEL
	wUIGRIq9j8Wt5fWn615LG3ToZBzJ3K4lrrNPq2ZuKT3bTmpWv7MWfUjvJSonkune
	cpFx5GJbDgvv+/spVRB/3RIqkroSvoF32eBhhpr50N1Am2GLY2MIjvK9RyVPCzPz
	FrB3kLIKyBUQevUX45TbVIMMutYcoB0F8PripCd1L/rrdSgbh3Ii3VgY6mZjDndv
	deB44Nc15+UJ5/M8SrOqZsH4BZEwbIq6NP/gtzQ495nGEA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9xpbyM_n4SVR; Sat, 22 Jun 2024 16:24:08 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W600k1Pvxz6CmQyM;
	Sat, 22 Jun 2024 16:24:05 +0000 (UTC)
Message-ID: <8778d191-436d-46cd-a17e-a7d264c32793@acm.org>
Date: Sat, 22 Jun 2024 09:24:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-scsi <linux-scsi@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
 <CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
 <yq15xu1oo3e.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/21/24 6:56 PM, Linus Torvalds wrote:
> But I also know that pretty much *EVERY* time the SCSI layer has
> decided to start looking at some new piece of data, it turns out that
> "Oh, look, all those devices have only ever been tested with operating
> systems that did *NOT* look at that mode page or other thing, and
> surprise surprise - not being tested means that it's buggy".

We got the message and we will do what we can to prevent future
regressions for USB devices.

As has been mentioned earlier, there is evidence in
sd_read_write_protect_flag() that SCSI devices may misbehave when
querying a mode page. However, I was not familiar with that code and
hence was not aware of the comments in that code. According to the git
history, these comments were added before 2005, that is before I started
reading the linux-scsi mailing list.

> My argument is that things should be opt-in.
> 
> If it wasn't needed for the previous 30 years go SCSI history, it sure
> as heck didn't suddenly become necessary today.
> 
> So you literally NEVER DO THIS unless the system admin has explicitly
> enabled it.
> 
> That's what opt-in means.
> 
> And honestly, then the Android people can decide to opt in. Not random
> other victims.
 >> What's the advantage of just enabling random new features that have no
> real use case today?
> 
> Put another way: why wasn't this an explicit opt-in from the get-go?
> And why can't we make that be the rule going forward for the *NEXT*
> time somebody introduces some random new mode page?

The new mode page has been introduced last year in SBC-5. UFS devices 
have a mix of SLC and TLC NAND internally and the new mode page allows
device vendors to reduce write amplification. This is important to UFS
device vendors.

I think that the new mode page is useful for all storage devices that
have a mix of slow and fast storage internally and hence that it is also
useful for some enterprise storage devices. This is why the new mode
page is read by default. But as has been mentioned above, we have
learned our lesson and will be much more careful in the future when
adding code that modifies the access pattern of the sd driver for USB
storage devices.

Thanks,

Bart.
