Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A263B71B2;
	Tue, 15 Sep 2026 13:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477252; cv=none; b=i5gZMIWdGTUd8PL2jTZoVUfVBIZl5EcimvpLKup5ucZFAJQgvQza4Pz9FhhBmEHY2AJsC0ZVmXpE1M8abuAt3zdRyTkre2k9Kvb07HUYM5K+5H8DfHjubEtPdevop1WKpq0sgWoZ4lxOgbvy0pJqYEsn5ANq+URiXKEaFxpuCQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477252; c=relaxed/simple;
	bh=yy7mA24WsKV2zO6NWo0I+xvQyK0K45KGWnKs/MXZI14=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CRCRgm+JOOdO4Pr826ijXo0/TBD8r+BljD/rCtRZGVT5cx0Tdz0JcU1YvGdvFmNCObPJQN4AtjChXs36QHlwtx9XrnkQ5eo2b8sgFPLPqt0rcI5EtWrZOi7zq+fjY5dPUJnXKzgr23i9hxZune0iMzw+YtS6kRAWtoy6ySXkTS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lz00xntp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lz00xntp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CDB1F000FF;
	Tue, 15 Sep 2026 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477251;
	bh=QDiSlZrYXo7lOf07/To81JeA6hEVSiQOx4NiBK4eBNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lz00xntpIlTnefRhqnXP6OqZ/Utk1Cd+lzOA1s+D+KBSV3rLWQ2S2yCAUtyDPF4QP
	 RYC0ibzzsLPdklRALk+kN+Thcm04mPYCNWPoDX9MTTFnswGyyzyU5T2lRqy9zlfbWI
	 tnm2XQRK2Yv0eoBBSXTLw59kDZz93uMsAX+e7M+leZEdBtVwqek7EA481v+oTTo4M+
	 GHZbiy98BgEesdnpcwFyDaVyPRY/9FSQZBRMPNXZaJfnAV9Q66dYMeNohPXMdUkkee
	 h984ESPcrIWAYtnwR8McpoucLwM4xW7Qrtf7/OEueZhuQfrstSNqWnyNet9oo+I+9n
	 auxlw+lle9Ezg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v4 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-leds@vger.kernel.org, lee@kernel.org
In-Reply-To: <202609152112.RFCv4-1.lhw@gmail.com>
References: <202609152112.RFCv4-0.lhw@gmail.com>
 <202609152112.RFCv4-1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:00:50 +0000
Message-Id: <20260915130050.E8CDB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] leds: data race on subled_info array causes torn color updates
- [Low] leds: build failure due to undefined macro kzalloc_obj
- [Low] leds: build failure due to missing argument in blk_rq_map_kern()
--

commit e6ce9b3b67cc2aa4897215acc2c62600810790a8
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit introduces a driver for ASUS ROG external NVMe enclosures that
exposes 4 independently addressable LEDs via the LED multicolor class. It
uses a SCSI device handler matched by vendor INQUIRY to send custom ENE
sequences over passthrough SCSI commands.

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..089cc3dcee105
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
[ ... ]
> +static int ene_write(struct scsi_device *sdev, u16 reg,
> +		     const void *data, u8 arg_count)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	u8 cdb[ENE_CDB_LEN];
> +	int ret;
> +
> +	ene_build_cdb(cdb, reg, arg_count);
> +
> +	rq =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(rq))
> +		return PTR_ERR(rq);
> +
> +	if (arg_count) {
> +		ret =3D blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);

[Severity: Low]
Does this cause a build failure? The kernel API blk_rq_map_kern() requires 5
arguments, where the first parameter should be the struct request_queue *q,
but it is called here with only 4 arguments.

> +		if (ret)
> +			goto out;
> +	}
[ ... ]
> +static void asus_aura_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	struct led_classdev_mc *mc =3D lcdev_to_mccdev(cdev);
> +	struct asus_aura_led *led =3D
> +		container_of(mc, struct asus_aura_led, mc_cdev);
> +	struct asus_aura_zone *zone =3D led->zone;
> +	unsigned long flags;
> +
> +	led_mc_calc_color_components(mc, brightness);
> +
> +	spin_lock_irqsave(&zone->lock, flags);

[Severity: Medium]
Could this lead to a data race on the subled_info array? The LED core allows
concurrent brightness_set callbacks for the same LED (for instance, from
sysfs and a hardware trigger). The helper led_mc_calc_color_components()
modifies the shared mc->subled_info array locklessly before the driver
acquires its spinlock. If multiple threads update the brightness
concurrently, they might interleave their writes to the array, causing the
winning thread to read a mix of old and new color components.

> +	/* ENE colour register byte order is R, B, G. */
> +	led->rgb[0] =3D led->subled[0].brightness;
> +	led->rgb[1] =3D led->subled[2].brightness;
> +	led->rgb[2] =3D led->subled[1].brightness;
> +	zone->dirty |=3D BIT(led->index);
> +	spin_unlock_irqrestore(&zone->lock, flags);
> +
> +	schedule_work(&zone->work);
> +}
[ ... ]
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone;
> +	int i, ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Does this code fail to compile? It looks like it invokes an undefined macro
kzalloc_obj() instead of the standard kzalloc() function to allocate memory.

> +	if (!zone)
> +		return SCSI_DH_NOMEM;
> +	zone->sdev =3D sdev;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609152112.RFCv4-=
1.lhw@gmail.com?part=3D1
