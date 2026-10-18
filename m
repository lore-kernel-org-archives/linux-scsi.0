Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DC3446C7;
	Sun, 18 Oct 2026 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792341690; cv=none; b=RMz6wdTGlfYy0QEuGmGqnDi9ODPg/j/c5U5tKSwNh02zJekVXFtYruA7X+MqQC2ateuxsatecihN4Le4SM7dqCe32jRpW2g4TmsG9F92fWQk5sEiEK9Ryz+jCpOZer3T7bn2UOOatAefpaF+LYfL+VlsJXX3C5u0IvaJZsFLwns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792341690; c=relaxed/simple;
	bh=o8hJVdeaVwXZ8od6XDgi46XGIhr3WOQHprnfFbLcHX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHYI7nsg7Q8DEZ81E/g+KkE9E8YwEiET806Tvnza6DuPUJvhYFZwEEBICe/abfXs+nqU1qfZhOODxuaSsDjikEqBygapX1ba2Pyrbyy9yoh0j9OIZIr91KNazMpNcsuwHMDa0peWcXoR1R5FXLAKpHhdHG8UL/QuF5k4hTeJaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U0O8yl6P; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U0O8yl6P"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j74FF1l9Bzlfvpn;
	Sun, 18 Oct 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792341678; x=1794933679; bh=4AWHPp8lSPd/t1bYHj068BCx
	rU2/TvcFgspDWB8/VwU=; b=U0O8yl6PoHeQLQeXxak6P+O3k6tqggbdiAvFtBns
	GQfnd02Ktyhao0j8McZHkR3rYJVG5ICbL0829MBk9YOAfSp/B/LobVjNmKTt+N3a
	jaE1bUKTM4mD5Yk/xoO/msw2zV9CVFY9/yd1oZKzVLQF70q/buqYylW1NScJrz0y
	Aoac69LGdAc/WIuqRQZVoVYrb4SDucLfYtAfN8TRgESj4wTwpgfRtkkSwFI2hOz+
	za0fx6pFYdXlaTOMns49yc8rYGjpEfeU9yuNdqVlE0or2MitRws0I1FRLAr8QKCT
	8pYsU+vJwMEdUMY9bcrHrDyFRB8HDeP0NP6uDP/Bk+0Mlw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DynZCCGGcDLd; Sun, 18 Oct 2026 16:41:18 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j74F91fbHzlfvpd;
	Sun, 18 Oct 2026 16:41:16 +0000 (UTC)
Message-ID: <cc4cb53d-51e4-472c-8e4f-6243100198d2@acm.org>
Date: Sun, 18 Oct 2026 09:41:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
To: Wang Yingjie <x-professor@outlook.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
Cc: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1792237341.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/26 8:41 AM, Wang Yingjie wrote:
> Several SCSI passthrough completion paths touch userspace while their
> completed request still owns a queue tag.  Sense or READ-bounce copyback
> can fault on a mapping backed by the same one-tag device, leaving the
> nested I/O unable to obtain the retained tag.  The synchronous and
> io_uring BSG paths additionally discard data-copyback failures.
How common are one-tag devices? Has it been considered to disable SG_IO
for one-tag devices instead of complicating the SG_IO implementation?

Thanks,

Bart.
