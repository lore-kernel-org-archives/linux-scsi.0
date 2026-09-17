Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDA34F5DFE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664219; cv=none; b=ZqnPyOXPMA5rM86MrNbtWCb3VVcxpeElTbX74AsYQPHfa0ukQD+nAbeQwcYQWQYJxxXI0MgI6mYe1G/i8TcwQBqTirpIFNblyYLdLFoAvk02reAC6s4+imbPoXF0QOY+fYR7VYV6QDov1b9rV+8DNUV0sciIHVt0vDiFB6aNVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664219; c=relaxed/simple;
	bh=dn6zdp2y2bOJRaaaQLDIzFmFi1gvO691DvcSbAUCigE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ylg5A+PmXGvxTdqxnxI/u7Gq8+oPGexK9qLKaDhiQmQDRAc4jybkMEsBtO+F6MpCtmazclLEHzZq+an+htDY8q45o+GplzavmAhQdKyQJMPkgKfO7CvZtxPo08dGCNrYG/+942yZX9KaGcHV9aVZ0Iq5eZiUfTX8qWAFjgLbWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dl7oiocz; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dl7oiocz"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b24c3so668990f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789664215; x=1790269015; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QNumNnYoURFzMwz5gShxa1JkMSD2gx61i8FWqYuf9ws=;
        b=Dl7oioczVUdXEXtspFX2+mOxyKTgtK7CijzIrDpETJMXfCsvKeEwdTQqdKEWbTBWRS
         g0Cma75FJqSZHCBIED+LGvJF2805FxD8fJmljj6KU6HGHzOBxNm21ZbleanAJjvXoZ5E
         AXWerMvg8PvsxH5KKEDRB3atyr7C1KcgqdGgsHcLp+9LxStr0YcywWbVfjIvMAwdnPgl
         8XZNYVkJnTCKaI6L3SGyV7KSnEh1lYay1KhPtwu10lJgKz9CsamytYnssW/ta5o7HtyR
         3j6SNkIEgLqlQICFNA1Yns+qW66481vHOwGwNuUlToLQcTUqoypTupxEMvBS61YbGf1s
         OpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664215; x=1790269015;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QNumNnYoURFzMwz5gShxa1JkMSD2gx61i8FWqYuf9ws=;
        b=XIgF3Wd6RJxhCbsYzAokb74COUaYsqXpcooUm9bip4yiaunwiMTWMwDrhw7196W50O
         4OKGSDUDMVanWGrXpguac5ifHuAo2FuRijWpMtFORop9fdFqKAKoxDpDgmGl9b+EzBfU
         iM7hiLEuPQZIgM8FypCoUGHHfZXzLchMqwUj7aSMk3ZUxsGwteKUfjgZTyQaM9ZefjBJ
         z+NnX01gm7rF57CTNBJYLdYUN1CUVYJjD59vY8Z76uBqtlfuxLBwxxwd0qmr1AidmC5R
         neFcnSq7gPGFrKIwhnCoP0mAF4UWqRQqpB47zNl5wip6/DzjLIYj61cXzV6paFI8oPVH
         J2jw==
X-Forwarded-Encrypted: i=1; AKwUvBz5IVcuSLQy0g9YOlBKNt2cqhZ0umVN0YrWVOQg5pG+QROCglGfFTtT6zjYvZyio2f0hldm9o+5xIVT@vger.kernel.org
X-Gm-Message-State: AFuF++l4aTz10fWjE3c8J9pl20mSDmFOHZ7hnzpxYIeGCqlpDJ/Y99BK
	EsG88PnRx6MK7GnRjJJH38x4wbsMetrsDWiJYIszqKeZEik0os2dLpG8
X-Gm-Gg: AYBFou1Q339NwRN656guW29rDPhOeD+6mR8v6mvKNYTRZ02qCFpsb069psUmdoyL9gv
	+rvzsWRGU6kzuswruiIhlo99BD6+JfaE+YRfPWj6kVm2ywBRrlQIv0egjSokqEVJt3vMv8cbznR
	+0Y9mCpWOe62Cjyn2KyYofuzvbesPcMt57LFCdewjngeszJJeajZFQMDGEV5mjcQIDffAiGTJVZ
	N3rOGogaHLBh+2g6F94J6YqRrS07UMJpuX75bDMrBxAnSxPvs2Ht8btGbwCcKE6XcMD7rTcgUbN
	pxpj6HFC7h5ClalcpSZ2mPTsN7TVsv31Iz4Sd056/ME2YxaQMsjsMBAldxMozi6KFRlPZADVsnS
	KX0LzMmKihpPmXCcDIitm/jbDr2jOzjBJEhxJu5cLWr85X4zKbkmMAyUDdHsSjSDzsk/Oy0udad
	76b0NlxcAHjItKn7EhC0tZBU8QukMHZp5ZaSjG6uaszBjqXYz3dMv8EGl3KtKgqZJ7hdEEeXzyY
	SHcaXlkTMA=
X-Received: by 2002:a05:600c:358a:b0:49c:fc6e:a3dc with SMTP id 5b1f17b1804b1-49eb733cea8mr116064525e9.27.1789664215299;
        Thu, 17 Sep 2026 09:56:55 -0700 (PDT)
Received: from foxbook (bez152.neoplus.adsl.tpnet.pl. [83.28.37.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd225898sm95977295e9.9.2026.09.17.09.56.54
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 17 Sep 2026 09:56:55 -0700 (PDT)
Date: Thu, 17 Sep 2026 18:56:50 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: djraszit <djraszit@gmail.com>
Cc: Oliver Neukum <oneukum@suse.com>, Oliver Neukum <oliver@neukum.org>,
 Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after
 host reboot
Message-ID: <20260917185650.7fdea3cb.michal.pecio@gmail.com>
In-Reply-To: <CAFKhL9dmR1KDaBQGta=X5xDCGirzJ8t7u0rH4HUgBoFqN152DA@mail.gmail.com>
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
	<c335085d-a824-4632-ad3a-c06715258c81@suse.com>
	<CAFKhL9f6aLZgerw_7bohbQWvzMxSfd-m-LFcuNP1_p1vWkN4=Q@mail.gmail.com>
	<1320caa3-85b5-47dc-aa2d-56d3b003c6ef@neukum.org>
	<CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
	<20260915233818.5881ad97.michal.pecio@gmail.com>
	<CAFKhL9fL++S1xh+aUCuYbk6EkLQnfUn95y7TBoWaGnPAVP1gYA@mail.gmail.com>
	<20260916204713.22c4f575.michal.pecio@gmail.com>
	<6041fdad-78b9-4310-a86b-f9931563de19@suse.com>
	<CAFKhL9dmR1KDaBQGta=X5xDCGirzJ8t7u0rH4HUgBoFqN152DA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Sep 2026 18:02:02 +0200, djraszit wrote:
> shutdown Pi with the enclosure connected
> -> disconnect USB after shutdown
> -> boot the Pi without the enclosure
> -> wait for Linux to boot completely
> -> reconnect USB  
> 
> I repeated this three times. All three tests were GOOD

> USB_MSD_PWR_OFF_TIME=0
> 
> I do not currently reproduce the state where the enclosure enumerates
> successfully but returns incorrect data. Instead, after consecutive
> reboots I reproducibly get the "Cannot enable" failure described
> above.
> 
> After changing it back to:
> 
> USB_MSD_PWR_OFF_TIME=1000
> 
> I repeated the test twice, starting from a known GOOD state each time.
> A reboot reproducibly resulted in the enclosure enumerating normally,
> but:
> 
> Alternate GPT is invalid, using primary GPT.
> 
> and the previously tested block returned the BAD hash.

So it's a boot issue. I think it would make sense to determine whether
the problem is caused by bootloader actions or the kernel.

Is it possible to configure the bootloader to wait a few seconds before
booting the kernel and connect or disconnect the device during this
time, or to never boot the kernel at all so that the device can be
disconnected and tested on another machine?

If it's the bootloader, and things seem to be going in this direction,
then you will need to sort this out with the vendor, obviously.

> Regarding the Raspberry Pi 5 test: yes, the enclosure was connected to
> USB 3.0/SuperSpeed. The Pi 5 uses the RP1 southbridge rather than the
> VL805 used by the Pi 4. On my Pi 5 Linux exposes two xHCI controllers,
> xhci-hcd.0 and xhci-hcd.1, each with a SuperSpeed bus at 5000M.

Thanks, that's all I wanted to know. It's some other xHCI controller.

(I looked it up, it seems RP1 uses Synopsys IP).

Regards,
Michal
