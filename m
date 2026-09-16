Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E774EC670;
	Wed, 16 Sep 2026 13:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563968; cv=none; b=sy5suASL7A0l+QveYBdG+a9prjo5JNTnm8TrwgAyCTfOqRCQIABCA2HXeuOnMay1sdvbsl2UEAXRmttw3dK95bymYa4vD7ARofozT9i5o92FB2XHDK1KqViUV7rOIiOxoLpFgVGvZE84txnTaV/9uKkspPw//bRO7JTtBczeRJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563968; c=relaxed/simple;
	bh=OEHtg1p84kx6f3DzgTvPJzWknTXzS9yYPhdLrqLc/bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gs6JjwRn35vlsOQAuPuPp0eQgvuWAC7hAh8QzynzYy2tKX2TuA/GbNcZZfw2GLvcXo367su82W7n/0GafWKfHlUnoHmR71jaHyuT4urA0yDKxpmKDxTtygRbE0N5bVNX2azpyhLs20leZJLKRn5YLiLqhD/HIK3dYxHfDTYWgds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOhQroah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOhQroah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CF31F000FF;
	Wed, 16 Sep 2026 13:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789563966;
	bh=PfGGrmKweRllIGhSRi+kSnniWVoapBRjDNkyOw0DN7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XOhQroah05o7T0iDqWNVLdPa9kvAEFeJQMcnXHDJKbGkRFZLaHx/r2nNuXMh8a50a
	 WsZwLd1PIHevOlWQ7ZEVpKT7f11Jy+wAnb7WjQ0arZrWl182i9GJKbBufy4+7bXLRD
	 njcMBEGweQ6t7Eh9I6LA2IVh1R5kGXjpG7uA84onvX759YeiClrBTIFY8rFDhQuQjT
	 terdlI/WSTuViJd0IsvfUWavazth92IZHMJFTvNLU2dw5Qf1tirbJu5Js6Ivbt47jy
	 2FpoCu2fZQ/8VxMK/HW96DXd4PVkGHIohT9JeqRzQBlDhOJFeZkIr8w/vfbA2vl+JB
	 l7mtcvxSO2zyQ==
Date: Wed, 16 Sep 2026 14:06:02 +0100
From: Lee Jones <lee@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Liang Haowen <nbg2974@gmail.com>, linux-scsi@vger.kernel.org,
	linux-leds@vger.kernel.org
Subject: Re: [PATCH RFC v5 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260916130602.GS11487@google.com>
References: <202609162015.RFCv5-0.lhw@gmail.com>
 <202609162015.RFCv5-1.lhw@gmail.com>
 <20260916122740.921E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260916122740.921E51F000FF@smtp.kernel.org>

On Wed, 16 Sep 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Low] block: build failure due to missing request_queue argument in blk_rq_map_kern()
> - [Low] leds: build failure due to undefined macro kzalloc_obj()
> - [Low] leds: UAPI naming convention violation for LED class device
> --

Please review, explain or fix the Sashiko review(s).

If this is a set, this request includes the other patches too.

> commit fe7900b55dc69157a3ef071f13e8783fac33da59
> Author: Liang Haowen <nbg2974@gmail.com>
> 
> leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
> 
> This commit adds a new SCSI driver for ASUS Aura RGB LEDs found on ROG
> NVMe enclosures. It exposes each LED as a multicolor LED class device by
> routing vendor SCSI commands. Updates are batched and scheduled via a
> workqueue to prevent concurrent writes.
> 
> > diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> > new file mode 100644
> > index 0000000000000..a1e31dc3f0101
> > --- /dev/null
> > +++ b/drivers/leds/leds-asus-aura-scsi.c
> [ ... ]
> > +	if (arg_count) {
> > +		ret = blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
> 
> [Severity: Low]
> Does this build against the current block layer?
> 
> The blk_rq_map_kern() function requires five arguments, including a
> struct request_queue pointer. Only four arguments are provided here.
> 
> > +		if (ret)
> > +			goto out;
> > +	}
> [ ... ]
> > +	/*
> > +	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
> > +	 * host, so the names stay unique when more than one is connected.
> > +	 * With a static name the LED core would register the second
> > +	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
> > +	 * is the wrong device identity. The names are per-attachment, like
> > +	 * sd X letters, and userspace is expected to enumerate.
> > +	 *
> > +	 * dev_name() renders the sdev as H:C:T:L; the extra colons would
> > +	 * break the devicename:color:function scheme userspace parses LED
> > +	 * class names with, so they are flattened to dashes and the name
> > +	 * keeps exactly one separator.
> > +	 */
> > +	strscpy(hctl, dev_name(&zone->sdev->sdev_gendev), sizeof(hctl));
> > +	strreplace(hctl, ':', '-');
> > +	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s:led%d", hctl, index);
> 
> [Severity: Low]
> Does this naming scheme violate the UAPI LED naming convention?
> 
> The standard format requires two colons (devicename:color:function), as
> documented in Documentation/leds/leds-class.rst. The comment above states
> this follows the devicename:color:function convention, but the generated
> name (e.g., asus-arion-xxxx:led0) only contains a single colon.
> 
> > +	if (!cdev->name)
> > +		return -ENOMEM;
> [ ... ]
> > +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> > +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> > +		return SCSI_DH_DEV_UNSUPP;
> > +
> > +	zone = kzalloc_obj(*zone, GFP_KERNEL);
> 
> [Severity: Low]
> Is kzalloc_obj() a valid macro in the kernel API?
> 
> It appears to be undefined, which will cause a build failure.
> Should this just be kzalloc(sizeof(*zone), GFP_KERNEL)?
> 
> > +	if (!zone)
> > +		return SCSI_DH_NOMEM;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/202609162015.RFCv5-1.lhw@gmail.com?part=1

-- 
Lee Jones
