Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF97285C96
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769444353; cv=none; b=eQYiKJVrC0uJ+KTmh/WRuRhVENWtipIODjOiq4xPkHACTSBZ+NeXmEgG8D6bD+7pwH3S3VjtQV0PA16Um2WhSClLawORen4FiuCabt7+8KHdXqtIJabjT4ogPmtjFfgbgE4n7QghIM/46BeDsIqaT/3R29cIuZytMx7/Iio8DIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769444353; c=relaxed/simple;
	bh=lJr+9LjXijVG2L3doiOysGn3q8Yh/YioTMPp6/ZPQOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZoUoCiiuHtD+C0DL5CWV820dc+qp1TeH0xSR2iK4RF2eSRP6JTC2171j9Gyeikz2DIMNYoUI4sDzOLDmhIpkYVcaFedwoXri/CCZFjyO7Av6X/XF4XehqJ1RDKz/wCZLbysQJrbvCgTos3ECb3hg+T8+y8/6S9/PdV7LPOsUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVFL7IkK; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVFL7IkK"
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-45c93e60525so1349649b6e.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 08:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769444350; x=1770049150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Re7o1luj0nF8ENFMBzSgQp4htPbrtZUdaJYqDNv3ZpA=;
        b=RVFL7IkKyB3uSibg7IdzRVOLDoTggaKbr0utLxr9EXoUCCcjH7+tBmWQ2w4G/KShnx
         POGnFUrzXxFjkYP3qFE+3zuTkHYlGAgpLlBnZWDWMdBtvlVYhH8S95QhNvwJbcq1ESTo
         d9K2p4hBCGdgyrNSrlugNaQpIX61inCnhvvs9fCxNmVXUOXcBN0wgCIb9SVqJPMXdCQn
         VhdPySo0/F1GfHjKgHw4ogjgP7ogtu7+fKAkJwe2SaOdYeVq2FTc37VjLcZOU52j8bpx
         0woOkJFTvZXLR73NALOTxQLF/WbduP+bNFKEjjAUs2krkeFWcj57STGLe5PNqSJ2cc5w
         UhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769444350; x=1770049150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Re7o1luj0nF8ENFMBzSgQp4htPbrtZUdaJYqDNv3ZpA=;
        b=l4lMbU8OFEo0FdclCAgO3zHo+z4DIbS1DQpdjSfj7mH4c8SqnWktP03qL+LI2IH6Mf
         BJx8Q4/ibf6cawRqlEjGDin5WVjbZ/3j0fOaS5JD1sxLaxqTHcwSxqZj3pTsAtYg5WVJ
         hRp/rdTvcPL3O12zQhYiVyIFpBTZih7v3BsUAjBzIrcRvCHLRRCewar2zv8b9AePz6Fx
         +jNstk92QGJ/aFp5i20Zq+tOd1cH03kN+qYGJ7WHQ2bIH6cKqVyXBM4ajQGFGoys3DHr
         3KKibcn6f+Fj9oe+7NsyujCow1sVxzKDKzA3YLX31lW2B8Da8YMKetTRnsrwPkGTKDOh
         N78g==
X-Forwarded-Encrypted: i=1; AJvYcCX93Z/EPzBBEuHMnV6yfEYHLMU2TyN6ZD4OF302eX+/U9nxvGMZY3SMvrHUWLlY6dATLvFXHb2CxclO@vger.kernel.org
X-Gm-Message-State: AOJu0YyIyBq7Ed0p2VjYtwBJvpWjKaHbc+S2rNu89GLCQdcAQxebiF/T
	Dx2UUKZp7YHlWCw78QKKryL7b6LIbBbSCy5sbqo9XOq3F0TTOxaIgacs
X-Gm-Gg: AZuq6aI3etbuH4l6ZVVkmRhmYfqH6HWmSDTsKNa6zKhT6FzzmWnshz/Ug9LlPU0Y5eU
	uHnPqJYEbTx7/rASHr2LJaBd2gioSW05j14et81J4EHUBF7gcqTylj98LP4B0wlpe5tmobfyuER
	IWhvQg5GICWy71r4hGBHMcE3OlG0J+A7SMBkPDzgSza9UtZW7rDyIriCvMeS9PNQnWr6KOXtfMJ
	FcBWW+P9+QE5l9fJgOC2Km3FuJhUKmNUHAejtCAH2C9GMf/9qfsnc4Yhf+Cg0GhWe1tjW5CSYOm
	9WFzvs+2154pH58DO7j2vdxV/rw8W0S077E9gPxuTyUJWTjaD2Di5xUhVesoPd4hP67RUrVds27
	h/o2Ieb30f/LaygdEIrjJYT/SxE2siF3f9/JLRMWIoPXTw4J0nRgxa74dRnerAHd9ilSWSI246X
	dekKiaHcQNoa64xsZvPRHY5HvY3rr4GMq/bAC94Zn5xpMdifYCxOlC4U2czW0nnptlasg=
X-Received: by 2002:a05:6808:4f60:b0:45a:8d42:646f with SMTP id 5614622812f47-45ed9a95bdemr2130038b6e.62.1769444349706;
        Mon, 26 Jan 2026 08:19:09 -0800 (PST)
Received: from [172.31.250.1] (47-162-126-134.bng01.plan.tx.frontiernet.net. [47.162.126.134])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb40e32desm5928854b6e.5.2026.01.26.08.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 08:19:09 -0800 (PST)
Message-ID: <03a91568-d1a0-4779-a465-2788f4765a42@gmail.com>
Date: Mon, 26 Jan 2026 10:19:07 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
To: Niklas Cassel <cassel@kernel.org>, Markus Probst <markus.probst@posteo.de>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Jacek Anaszewski <jacek.anaszewski@gmail.com>,
 Damien Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
 <aXctPaaXFYemV20T@ryzen>
Content-Language: en-US
From: Ian Pilcher <arequipeno@gmail.com>
In-Reply-To: <aXctPaaXFYemV20T@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 3:00 AM, Niklas Cassel wrote:
> But I'm not a fan of making the driver more complex.
> If we want something more complex than what is already there, then it
> is probably much better handled in user space, considering the amount
> of possible configuration options.
> 
> Basically the same argument as used in:
> https://lore.kernel.org/linux-nvme/20220227234258.24619-1-ematsumiya@suse.de/T/#u

Niklas -

Can you provide some links on how this might be done in userspace?

I've been maintaining my out-of-tree block device trigger for years, to
make the LEDs on my NAS work.

  https://github.com/ipilcher/ledtrig-blkdev/blob/v6.9%2B/drivers/leds/trigger/ledtrig-blkdev.c

I'd love to be able to replace it with something in-tree.

-- 
========================================================================
If your user interface is intuitive in retrospect ... it isn't intuitive
========================================================================

