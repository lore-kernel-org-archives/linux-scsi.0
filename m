Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681DB4EE85E;
	Wed, 16 Sep 2026 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789555409; cv=none; b=C5YDv7mpMZVgyjkFFjsunTILTg0ZtxjfgCchLs4CNc47Lfzr3vXMBzx00WKUWLfgVFsKcyXSgJRsW6FboZD09TTd1zVHF++EKm53ePcjdFJMCd2c71VsCizvwchtP2xQrylrx9q7LCBzOOFhbAG2OPvXmFiD58kaW21JKj88i24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789555409; c=relaxed/simple;
	bh=pNF/fYZKvcKlZCJNJy4Ik87MUKWeVC4PAUAyo2PWQB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bz81jzssjlkdsMBcJH40PlDyZmNeKulS5vDYVVVHJcZp22eaB34tpqYbTuItL3fXYhY76MdyYRc9mMDqZ9GGzLjCGrX/Iyr3uWOG3/bjpucMGHFdNfvJbnKUyW6S1TRhRgfkfl0zxCzJ+Oz4S1gDKhQkduaRSVb7wYwMO6MVREw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huxaqQI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huxaqQI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767AB1F0089D;
	Wed, 16 Sep 2026 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789555389;
	bh=/UGygQGXhuhDnAfhN574yKe4CYpKDrynLUaMeDlvo5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=huxaqQI2TwNroiRMo7UjM/+rKuW2mlKdf7v57qzlMcWhE0jthgS9TjiY4+kKxXoSq
	 rS3XGxZJj0vj4XSxGsx3dvGxSWBvLSkMtmqnxk4gy7EPNBuFiQf1iHmE92Wh+e3h0q
	 +BkYS2MJwFfM6A8zgGgrUp+DnlgUFSxDRMDLbuxZLi/chvTvcJtz6bwVraJxNd03zI
	 JMr9tXFxycEv2d6My8ACQbRfl8vRNd5j6XwSZz+/rrO7xunXrgswzsHnGNgwHyJ844
	 2SnHZ9wtVvSD0Mc1HgliTNNp78ORg4SQtXU+RK1V1kbzzicqhDHg2MInzUVYHYX7jF
	 wxtL5EVEMzVBA==
Date: Wed, 16 Sep 2026 11:43:05 +0100
From: Lee Jones <lee@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Liang Haowen <nbg2974@gmail.com>, linux-scsi@vger.kernel.org,
	linux-leds@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260916104305.GM11487@google.com>
References: <202609152112.RFCv4-0.lhw@gmail.com>
 <202609152112.RFCv4-1.lhw@gmail.com>
 <20260915130050.E8CDB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260915130050.E8CDB1F000FF@smtp.kernel.org>

On Tue, 15 Sep 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] leds: data race on subled_info array causes torn color updates
> - [Low] leds: build failure due to undefined macro kzalloc_obj
> - [Low] leds: build failure due to missing argument in blk_rq_map_kern()

Please review, explain or fix the Sashiko review(s).

If this is a set, this request includes the other patches too.

> --
> 
> commit e6ce9b3b67cc2aa4897215acc2c62600810790a8
> Author: Liang Haowen <nbg2974@gmail.com>
> 
> leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
> 
> This commit introduces a driver for ASUS ROG external NVMe enclosures that
> exposes 4 independently addressable LEDs via the LED multicolor class. It
> uses a SCSI device handler matched by vendor INQUIRY to send custom ENE
> sequences over passthrough SCSI commands.
> 
> > diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> > new file mode 100644
> > index 0000000000000..089cc3dcee105
> > --- /dev/null
> > +++ b/drivers/leds/leds-asus-aura-scsi.c
> [ ... ]
> > +static int ene_write(struct scsi_device *sdev, u16 reg,
> > +		     const void *data, u8 arg_count)
> > +{
> > +	struct request *rq;
> > +	struct scsi_cmnd *scmd;
> > +	u8 cdb[ENE_CDB_LEN];
> > +	int ret;
> > +
> > +	ene_build_cdb(cdb, reg, arg_count);
> > +
> > +	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> > +	if (IS_ERR(rq))
> > +		return PTR_ERR(rq);
> > +
> > +	if (arg_count) {
> > +		ret = blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
> 
> [Severity: Low]
> Does this cause a build failure? The kernel API blk_rq_map_kern() requires 5
> arguments, where the first parameter should be the struct request_queue *q,
> but it is called here with only 4 arguments.
> 
> > +		if (ret)
> > +			goto out;
> > +	}
> [ ... ]
> > +static void asus_aura_set(struct led_classdev *cdev,
> > +			  enum led_brightness brightness)
> > +{
> > +	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
> > +	struct asus_aura_led *led =
> > +		container_of(mc, struct asus_aura_led, mc_cdev);
> > +	struct asus_aura_zone *zone = led->zone;
> > +	unsigned long flags;
> > +
> > +	led_mc_calc_color_components(mc, brightness);
> > +
> > +	spin_lock_irqsave(&zone->lock, flags);
> 
> [Severity: Medium]
> Could this lead to a data race on the subled_info array? The LED core allows
> concurrent brightness_set callbacks for the same LED (for instance, from
> sysfs and a hardware trigger). The helper led_mc_calc_color_components()
> modifies the shared mc->subled_info array locklessly before the driver
> acquires its spinlock. If multiple threads update the brightness
> concurrently, they might interleave their writes to the array, causing the
> winning thread to read a mix of old and new color components.
> 
> > +	/* ENE colour register byte order is R, B, G. */
> > +	led->rgb[0] = led->subled[0].brightness;
> > +	led->rgb[1] = led->subled[2].brightness;
> > +	led->rgb[2] = led->subled[1].brightness;
> > +	zone->dirty |= BIT(led->index);
> > +	spin_unlock_irqrestore(&zone->lock, flags);
> > +
> > +	schedule_work(&zone->work);
> > +}
> [ ... ]
> > +static int asus_aura_attach(struct scsi_device *sdev)
> > +{
> > +	struct asus_aura_zone *zone;
> > +	int i, ret;
> > +
> > +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> > +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> > +		return SCSI_DH_DEV_UNSUPP;
> > +
> > +	zone = kzalloc_obj(*zone, GFP_KERNEL);
> 
> [Severity: Low]
> Does this code fail to compile? It looks like it invokes an undefined macro
> kzalloc_obj() instead of the standard kzalloc() function to allocate memory.
> 
> > +	if (!zone)
> > +		return SCSI_DH_NOMEM;
> > +	zone->sdev = sdev;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/202609152112.RFCv4-1.lhw@gmail.com?part=1

-- 
Lee Jones
