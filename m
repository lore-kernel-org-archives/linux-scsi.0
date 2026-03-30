Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFA3A6B8B
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 21:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907361; cv=none; b=oUiEZBFdxlnccTENYr7OttJWH3lJZFe+0ipENM8LXBa9rNMetriyfEv3y1AakmHJa4S7WEgAdM1PqUfYrz1/xCn6zqXw1pSixlF/csxjyio4fQvjgeEaiph/dV0cYYpJr88QqH4wJRJbMWSNUR/Efa2pwTINN4pjucInFLl8n0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907361; c=relaxed/simple;
	bh=OQEN2V1zf5XX4OmThoVCUFjgNAjn/1RVXrg71cZAxBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqXRBQn/M8WunkAieARqXlneNMZibtOzGFLWPnQmRVr8KZGso+TIhwkyL5GSuKUojFYXDY5APRmdvUbOaGXHzjak3HxdFHhdrIhcZEZG7RyZFPcfJCujarSwiwm1x2k4nFfv9AqTC9TW32hfQc2p5eMMyGtYOrtTEGHg9YYt0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk; spf=pass smtp.mailfrom=philpotter.co.uk; dkim=pass (2048-bit key) header.d=philpotter-co-uk.20230601.gappssmtp.com header.i=@philpotter-co-uk.20230601.gappssmtp.com header.b=IBV5Asfe; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20230601.gappssmtp.com header.i=@philpotter-co-uk.20230601.gappssmtp.com header.b="IBV5Asfe"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so62015055e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 14:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20230601.gappssmtp.com; s=20230601; t=1774907358; x=1775512158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iCtJw/YgoH39kldsewaUagjUei5D9Up/aGMmGXTIykc=;
        b=IBV5AsfeD1xJjHb3hUQ23H6HNZH+qUQ0LLqFofaEjDCzMWxMtDaRZ6EZMeJxTKI4Qq
         Etjg9JNhN2/JlFZW0npsvuQpSMc+9asur2KXBNDfp0Tw4s9yklcQfDg4ZTYQQwx+MCJ7
         zGtAxPNp4GWx8GT3IghoUGw4qdgdjZn+8sX2ZAWOQjqdlWx7ViCdR5g2xHR9p47UF00x
         jabF+DQDqIKI37QnpTp2/ygbBycSEiszCYNX9nOK0iDwqaG/6br/lv4+CeW3VQqRLfO4
         LvoXEVfr1KaJaX4fgirpuz8f5bs3D6SS8eNcDHI7dgBF62DEMUPDVBgY5nxqklMBK//e
         M97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774907358; x=1775512158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCtJw/YgoH39kldsewaUagjUei5D9Up/aGMmGXTIykc=;
        b=kfes0VWE4HCoR3zBqbRH0nbAbQX+qk5B0LVbms2IqDGk3+JWNCY3D8D2S0u6eTsXLY
         TeTXJ9XL1uqwUnf61K+Jtcqcri58CnClWi6ujLWFzda9hezgtWKFmCnKuPcX88YALfcN
         Fttvzg8HqOVcEDDxBPYb4Ain0zwor716ZqOsyB2jUt8lfmxguI5WQiEwynLANJHXN704
         pteZOIqkN1ScLElpTNz/WeTJhMBmDxXOY0oaK76HP/dneTW8qwRxSOFmPBahA5Wn26n6
         rBmrRurKe6z+ndFEyA5OoYVkUUzDJ9pBZjXGheljqAQeT3h7HmU6ey+mTHTVxlBHVgFH
         LzAw==
X-Forwarded-Encrypted: i=1; AJvYcCW2DZ/34uQLFOaS23b/AVFkKOUMeyIY3JJ3kzG/2uuqANHcy+Y7meMNYNfELlagjkGzlPO332R/ugKf@vger.kernel.org
X-Gm-Message-State: AOJu0YyvRK7fP8xAGKheGDNuQNOG4I88ZeyBGwal0/U4vvYy8YNsnXHE
	j5sdS7USg8OTZoTG2aDxJgXJ9Ci+vwBzzBb1ys3pMxNc9M5bNrvsMgrAFZC0CzfgEfA=
X-Gm-Gg: ATEYQzwUlM9xRzNSf1/zyTWAK9V49cIBsplstEFCfVPOx4Ps/zhH+X9eeEKkN4mMtu1
	mSos0Q8b4nuhx3rhlCWNUsuMRtg8GDR5XYW+Y06wiL1U+7yKhFx1zrG15pRnTorlrwc7aX8+1pg
	UnfDAiNA3VSVFwgPeb1foWrkjevglAoi3SakTHX4BVb8kHCLSrYONu6C74v4QtDc3utqmaWTH5z
	HpbPiijfenLWtxQbQb3ieYZqn8rub3cagl2PpYj1CwZg55zphpfzIabWy8i02OMgRbWHdyW3zcz
	QMYgboTDabndaWZpwQ0ke31ABHSTqn++Z3+SOOUbq8EDtXgn5dM48+WD2DDL4MB+2OsX4WzrDYX
	YKQMlRmwDMeDkBdp60gRADedxf+jMG7pMGqFwTV8+5AeMc9WWSkZw3AmtmwEcMXIM+SKKHwbRJI
	ek2GVwqETQZjCAGBmzirLZat/stKoYy+Mby5hlS/6xjQAk6CdSi6mAYtuDw2RJdKWKiw7RMNcXD
	k7F0KcoTw==
X-Received: by 2002:a05:600c:6092:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48727ef0284mr265075275e9.21.1774907357735;
        Mon, 30 Mar 2026 14:49:17 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873ab203e9sm113117135e9.0.2026.03.30.14.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:49:17 -0700 (PDT)
Date: Mon, 30 Mar 2026 22:49:15 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Felix Busch <felix.busch1@gmx.net>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	phil@philpotter.co.uk, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] CD-ROM: Additional LBA bound check
Message-ID: <acrv2_GCdJC5C0qE@equinox>
References: <20260325065335.7783-1-felix.busch1@gmx.net>
 <20260325074401.6530-1-felix.busch1@gmx.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325074401.6530-1-felix.busch1@gmx.net>

Hi Felix,

Nice to hear from you again, hope you're well. Apologies for me taking a
few days to reply, I've had a a fair amount on at work.

On Wed, Mar 25, 2026 at 08:44:01AM +0100, Felix Busch wrote:
> Upper bound check for the logical block address
> in mmc_ioctl_cdrom_read_data() of the CD-ROM driver.
> This prevents trying to read a block when the LBA is
> greater than the number of available blocks.
> 
> Signed-off-by: Felix Busch <felix.busch1@gmx.net>
> ---
>  drivers/cdrom/cdrom.c |  7 +++++--
>  drivers/scsi/sr.c     | 12 +++++++++++-
>  include/linux/cdrom.h |  2 ++
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index fc049612d6dc..cc0a6c0ae9e7 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -2926,6 +2926,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
>  {
>  	struct scsi_sense_hdr sshdr;
>  	struct cdrom_msf msf;
> +	const struct cdrom_device_ops *cdo = cdi->ops;
> +	u64 nr_blocks;
>  	int blocksize = 0, format = 0, lba;
>  	int ret;
>  
> @@ -2944,8 +2946,9 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
>  	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
>  		return -EFAULT;
>  	lba = msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0, msf.cdmsf_frame0);
> -	/* FIXME: we need upper bound checking, too!! */
> -	if (lba < 0)
> +	nr_blocks = cdo->get_capacity(cdi);

This (as with other function pointers that are part of cdrom_device_ops,
should be checked first to see if it's initialised? (it is for sr.c of course,
but what about others?)

> +	/* Lower and upper bound check for logical block address. */
> +	if ((lba < 0) || (lba > nr_blocks - 1))
>  		return -EINVAL;

The point James makes about the return value now being different (as it
would previously have been an error from the device itself) is a good
one. This is probably the hardest question to answer in terms of which
software may or may not break.

>  
>  	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 7adb2573f50d..a056c72341c4 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -120,6 +120,8 @@ static int sr_packet(struct cdrom_device_info *, struct packet_command *);
>  static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
>  		u32 lba, u32 nr, u8 *last_sense);
>  
> +static u64 sr_get_nr_blocks(struct cdrom_device_info *cdi);
> +
>  static const struct cdrom_device_ops sr_dops = {
>  	.open			= sr_open,
>  	.release	 	= sr_release,
> @@ -134,6 +136,7 @@ static const struct cdrom_device_ops sr_dops = {
>  	.audio_ioctl		= sr_audio_ioctl,
>  	.generic_packet		= sr_packet,
>  	.read_cdda_bpc		= sr_read_cdda_bpc,
> +	.get_capacity		= sr_get_nr_blocks,
>  	.capability		= SR_CAPABILITIES,
>  };
>  
> @@ -142,6 +145,13 @@ static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
>  	return disk->private_data;
>  }
>  
> +static inline u64 sr_get_nr_blocks(struct cdrom_device_info *cdi)
> +{
> +	struct scsi_cd *cd = scsi_cd(cdi->disk);
> +
> +	return cd->capacity;
> +}
> +
>  static int sr_runtime_suspend(struct device *dev)
>  {
>  	struct scsi_cd *cd = dev_get_drvdata(dev);
> @@ -782,7 +792,7 @@ static int get_sectorsize(struct scsi_cd *cd)
>  			sector_size = 2048;
>  			fallthrough;
>  		case 2048:
> -			cd->capacity *= 4;
> +			//cd->capacity *= 4;

This is here for a reason, it should not be commented out. I may not
have worded it clearly in my response to your previous patch, but this
is the kind of thing I was talking about before.

>  			fallthrough;
>  		case 512:
>  			break;
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index b907e6c2307d..406e6f4a55bb 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -91,6 +91,8 @@ struct cdrom_device_ops {
>  			       struct packet_command *);
>  	int (*read_cdda_bpc)(struct cdrom_device_info *cdi, void __user *ubuf,
>  			       u32 lba, u32 nframes, u8 *last_sense);
> +	/* Get size in blocks */
> +	u64 (*get_capacity)(struct cdrom_device_info *cdi);

I notice we only define an implementation of this for sr.c? At a glance,
it's also possible to trigger this code from the GD-ROM driver, unless
I'm missing something?

>  /* driver specifications */
>  	const int capability;   /* capability flags */
>  };
> -- 
> 2.53.0
>

I take your point about avoiding the read entirely, and I see what you
mean there. That said, I'm not sure this is necessary given the
potential dangers.

Regards,
Phil
