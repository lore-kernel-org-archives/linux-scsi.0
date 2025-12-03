Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43A8405C
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723412; cv=none; b=pP48SnvMy3atSjWI/CeQ4AmqB84zpZVEkz+uhUpYPlOQgQRzQmlOnIyMxwvNh/qP9gI+IIVrtJCTVBe5KUU+AWORm1tzf0qKr0Y5SzJLMAroGoYkWPzEAfE3y8f4/hC9xIIAYbqhAEVKRVIUY6wdbZcaKTjPeQc/CyGvsx4FNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723412; c=relaxed/simple;
	bh=Qe+LyHWvG6IIVQQ2MDnSM1CSn/ljrERijBT+cMlAQ7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plx+baBVa95WAuRO0QDLCxjIXzPk+Z0q5JgfkW7yh6Hgm2a/6hJ7HwTWRA4H5vu2x1JGyUTiB9se8Qokmo1vyEihZ8TW7jVG4GuBkPvxuUouXS1XEwmlQLbh6JQ048TkVIFoZFiBAhp6zXhGNBvbp9SYp/vG90qngsMDzjSu4aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+WaU8m+; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+WaU8m+"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso4461020b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 16:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764723410; x=1765328210; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xIeq25nODub67uBJWLDr/T9J8C6eF/vS/9+u4qmJjzM=;
        b=G+WaU8m+9WJYA9vnKHvYvapzQ8uyPM+T3WqOIlcQC32jMG+nSE3Frzd5aAUIjdJ5wU
         B76qV7xBQrJdFJGhJCOFuuV1Cj0OOxzzBCdKd2dKCVGxpEXRex1PDffx63kY2GdZnOEv
         XZkzKxPTG6ZPqueo9B6dhp+4nTBBwmxDVJ9PlPGbhc7j5j7CCQZIJ4yaxOChNlr3AWZy
         hk/xojfLr+0v+YWrV0OOn4Ip/jiUProMqlrkD/LRPeejbpZQjSH2BkTZIyar8dE5CryG
         Gls1X8BILW4W2V9UVuoZvp6oikfC/4cSNrYcnMzSbhWGDom+ZR1uiqikrlCtXIhsRdJA
         r13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764723410; x=1765328210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xIeq25nODub67uBJWLDr/T9J8C6eF/vS/9+u4qmJjzM=;
        b=j0Z4vUZYrh++/XUoayUtWknD/loXpeXYBgkjDuAyBf2qtijRpEk01woiOgBgXVWbiD
         MADtvi5biIRGbJ/txm9IdDqurmJxVwArCUrDjp5zalpvQOPKf6ZyNZh5+juO6apYFjf3
         H+KZMq4xiK1EfoHIwBxTtbEaHvNknq42MwXhkanHGsnvi/3r/BHg4anhvSbRB6sk5MvL
         E1dt0JL9VNfeSe7NgVj+xoBX8V2WA0X/7DYDbsvq7Z6WptsqTAie7nz2nx0tFi7BkyXh
         Tu88MLfVL9jpXKb4wQuCB1krLA2WqGPsziZKm1y3pAoFXS4Fio3+8sIXHFr/PVQ3zD3g
         Mh8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUTodPGGkhjsauaYEbg+nGNZfvM55KPlIvThlrMzOohIlnsRYru5QR/aLOQPQRzb7dk0hvYns/8UAL@vger.kernel.org
X-Gm-Message-State: AOJu0YwsuykTnMh49saTCOaB3G3i6i7t8ufX5PGVFzpwo4aoOGJdFz4v
	SXGW37UIbWA+JS0wgQaBhMFWw6mrnh8yYQhBGd76LVW7xEgL+UhEmPW1
X-Gm-Gg: ASbGncuyfuU48+AWU2qa313phlDbqeZiVpVn6lfal+xdH9J0HWIAuMoJAemMwMq0hyS
	29rMj+sXTSQ6zhoMXCDkRwRAnPgZxEmp4rhosKS3P/v35oYPTHDyW4aUgbKFyFcCPKevFUv5/y8
	VRiVcSgm5FNhuJWOSHRVv8mDAHJvAgQ8zKqO55Cmmeqgp/cAAwzspdNa1aMPOfBzHgXPovPwfWL
	qKLjnijiS0eGG7VPKRRLUxP8Ex9N2YFsvH1mSlXEq9t72sQY9hDUXz8JHTg0qwnXm62q7bD+LzU
	aCxE5I2FA/SQILGby5EMRgAwFAwNGuNHqOjn1XXhbUUiNXvud8Cb9DvV/EJWV17VS0c49Ev3wr9
	jlumXYYGLpeJhU9+xOfJ6v0OzRgdx2WuK/wJaSi5WHYAelpeGUUEvOnEPi/0U9NVUDs/IelW+hg
	9Ibzrb8vQxnr4MZhdQTbZVhbTzNbprhu+oxtPDqg==
X-Google-Smtp-Source: AGHT+IGpAr81YW4tii5cYeSS5Aj8wL/3RSqYXE2qCiYPKaYdLsIPxATOspnpSRtWbLzzUgg6LbEF4w==
X-Received: by 2002:a05:6a20:158e:b0:32d:b925:4a8 with SMTP id adf61e73a8af0-363f5ce75cdmr889229637.3.1764723410611;
        Tue, 02 Dec 2025 16:56:50 -0800 (PST)
Received: from deb-101020-bm01.eng.stellus.in ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e6e6df9sm18125627b3a.39.2025.12.02.16.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:56:50 -0800 (PST)
Date: Wed, 3 Dec 2025 00:56:48 +0000
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org, kernel@pankajraghav.com,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: Re: [PATCH 2/2] scsi: enable sector_size > PAGE_SIZE
Message-ID: <aS-K0LVwGazNyVNj@deb-101020-bm01.eng.stellus.in>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
 <20251202021522.188419-4-sw.prabhu6@gmail.com>
 <401d8de5-63a8-461a-bc54-5b2986779a88@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <401d8de5-63a8-461a-bc54-5b2986779a88@acm.org>

On Tue, Dec 02, 2025 at 02:30:19PM -1000, Bart Van Assche wrote:
> On 12/1/25 4:15 PM, sw.prabhu6@gmail.com wrote:
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index b2ab97be5db3..b5839e62d3bb 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -8459,13 +8459,8 @@ static int __init scsi_debug_init(void)
> >   	} else if (sdebug_ndelay > 0)
> >   		sdebug_jdelay = JDELAY_OVERRIDDEN;
> > -	switch (sdebug_sector_size) {
> > -	case  512:
> > -	case 1024:
> > -	case 2048:
> > -	case 4096:
> > -		break;
> > -	default:
> > +	if (sdebug_sector_size < 512 || sdebug_sector_size > BLK_MAX_BLOCK_SIZE ||
> > +	    !is_power_of_2(sdebug_sector_size)) {
> >   		pr_err("invalid sector_size %d\n", sdebug_sector_size);
> >   		return -EINVAL;
> >   	}
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index c3502fcba1bb..f2eac79d7263 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2889,10 +2889,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
> >   			  "assuming 512.\n");
> >   	}
> > -	if (sector_size != 512 &&
> > -	    sector_size != 1024 &&
> > -	    sector_size != 2048 &&
> > -	    sector_size != 4096) {
> > +	if (sector_size < 512 || sector_size > BLK_MAX_BLOCK_SIZE ||
> > +	    !is_power_of_2(sector_size)) {
> >   		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
> >   			  sector_size);
> >   		/*
> 
> Please reorganize this patch series into one patch for the scsi_debug
> driver and another patch for the sd driver.
> 
  Sure, will do. 

  Thanks
  Swarna

