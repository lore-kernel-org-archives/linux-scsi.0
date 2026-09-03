Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0770349DB86;
	Thu,  3 Sep 2026 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438250; cv=none; b=SWXydAg1K9KKsmBP4jpVYi/UVs1peoruwrWATc4Nt3Y2A3WpDdOTGrvtm2s3IM+nSNiGME4ceXUdrSXPQb76B7g7/WYCr6DaPudi2O7TOW4/CkforqAqqmJVuc1qvZ8bEbzeDte5vYU/ZASbwY+y0jvW6JqmZ5yCD7ClrBzD9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438250; c=relaxed/simple;
	bh=plPVReR3aOcsS069d0n0qceKY0+r0wK1piw5KRtY9XY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bJ8QEVYyMlGkgcqAt41tjMNd0C1pNWTPv2mBpckU13CQmxbGV9flv9doaL7VOxL2votnXJSSowkop8nF68cQ4FfpEU8tu7cB1BLoboYoVK6218fYQqsYQGHx31ZANDLes3HGE80Xnf5E/UCOQSNOSlUU5cHp1CM1vtQ9eUU1WEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DENo3zOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DENo3zOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA6B1F00A3A;
	Thu,  3 Sep 2026 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788438248;
	bh=q5POko0sUiRncaFp/YIrOSduHhs26KPKvFV67rmjG1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DENo3zOkgnoNEI86XQEmdCrrcL8jnzG8VosPcR6TnlEZWNczYQHj0GG2UDf90rsLs
	 fmj+Y3nWYNi8flCRzkvNN3ISW0r9m+YIlsNx8YNjqk7uhtfqdfpoWLDAWkOwTHNf2K
	 /0fBmAMTbaQvt9g0z1kYtNWCb91gA9g5axkEbjrCUSPveUNIszC986gdrzgy8KZgA0
	 /ck0gvIPBxwfafCDceCiOp5EN/jrLKbpCiBWMsjQxzmcHjxIbO6jxHbZPMhIdRC6aP
	 out3Vq5zNqQpSjrV2vFi34mWBAvASrgNF1buW3mpfwISA3thJUucDlDWz3fpevsBdx
	 4VAnJuTZhMguQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-leds@vger.kernel.org, lee@kernel.org
In-Reply-To: <202609032000.RFCv2-1.lhw@gmail.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com> <202609032000.RFCv2-1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:24:07 +0000
Message-Id: <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] The workqueue function unconditionally writes to flash even when n=
o LEDs are dirty.
- [Medium] Hardcoded LED class device names will cause a sysfs collision if=
 multiple enclosures are connected.
- [Medium] Missing memory barriers and locking for led->rgb cause data race=
s and lost color updates.
- [Low] Missing 'struct request_queue *' argument in blk_rq_map_kern() call.
- [Low] Use of non-existent kzalloc_obj macro prevents compilation.
--

commit 12eb38bf536e935469d4f61d68a4b96acd78d4b1
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit adds a new out-of-tree driver for ASUS ROG external NVMe
enclosures. It registers a SCSI device handler matched by INQUIRY and
exposes the 4 addressable Aura RGB LEDs as multicolor LED class devices.
A single per-zone work item handles the ENE protocol sequences and
serializes updates.

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..4dd559a5d8ec1
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
Does this missing argument in ene_write() in
drivers/leds/leds-asus-aura-scsi.c cause a build failure? The
blk_rq_map_kern() function takes 5 arguments (requiring a
struct request_queue *q as the first parameter), but only 4 are provided
here.

> +		if (ret)
> +			goto out;
> +	}
[ ... ]
> +static void asus_aura_zone_work(struct work_struct *work)
> +{
> +	struct asus_aura_zone *zone =3D
> +		container_of(work, struct asus_aura_zone, work);
> +	struct scsi_device *sdev =3D zone->sdev;
> +	u8 apply =3D ENE_APPLY;
> +	u8 save =3D ENE_SAVE;
> +	u8 mode =3D ENE_MODE_STATIC;
> +	int i, ret;
> +
> +	if (!scsi_device_online(sdev))
> +		return;
> +
> +	/* Mode first: without it the device ignores the whole sequence. */
> +	ret =3D ene_write(sdev, ENE_REG_MODE, &mode, 1);
> +	if (ret)
> +		goto err;
> +
> +	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
> +		struct asus_aura_led *led =3D &zone->leds[i];
> +
> +		if (!test_and_clear_bit(i, &zone->dirty))
> +			continue;
> +
> +		ret =3D ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
> +				led->rgb, ENE_RGB_LEN);
> +		if (ret)
> +			goto err;
> +
> +		/*
> +		 * Cover the DIRECT colour set too; some firmware revisions
> +		 * pull from 0x8100 instead of 0x8160.
> +		 */
> +		ret =3D ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
> +				led->rgb, ENE_RGB_LEN);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	ret =3D ene_write(sdev, ENE_REG_APPLY, &apply, 1);
> +	if (ret)
> +		goto err;
> +
> +	/*
> +	 * The change only takes effect after SAVE (0xaa). NOTE: saving on
> +	 * every brightness change writes flash each time; revisit for wear
> +	 * once confirmed.
> +	 */
> +	ret =3D ene_write(sdev, ENE_REG_APPLY, &save, 1);

[Severity: High]
Does asus_aura_zone_work() in drivers/leds/leds-asus-aura-scsi.c
unconditionally write to the device flash even when no LEDs are dirty?

If schedule_work() is called while asus_aura_zone_work() is already
executing, the work item gets re-queued. If the first execution already
processed the newly set LED bit, the second execution will observe a fully
cleared zone->dirty bitmap, but still send the MODE, APPLY, and SAVE
commands to the hardware.

Since SAVE writes to the device flash, these spurious empty runs could cause
unnecessary device flash wear.

> +	if (ret)
> +		goto err;
> +
> +	return;
> +err:
> +	dev_err(&sdev->sdev_gendev,
> +		"asus_aura: colour update failed: %d\n", ret);
> +}
> +
> +/* Non-blocking LED callback (LED core fast path). Cache colour, defer S=
CSI. */
> +static void asus_aura_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	struct led_classdev_mc *mc =3D lcdev_to_mccdev(cdev);
> +	struct asus_aura_led *led =3D
> +		container_of(mc, struct asus_aura_led, mc_cdev);
> +
> +	led_mc_calc_color_components(mc, brightness);
> +	/* ENE colour register byte order is R, B, G. */
> +	led->rgb[0] =3D led->subled[0].brightness;
> +	led->rgb[1] =3D led->subled[2].brightness;
> +	led->rgb[2] =3D led->subled[1].brightness;
> +
> +	set_bit(led->index, &led->zone->dirty);
> +	schedule_work(&led->zone->work);

[Severity: Medium]
Can this cause data races and lost color updates?

In asus_aura_set() in drivers/leds/leds-asus-aura-scsi.c, led->rgb is updat=
ed
before marking the LED as dirty via set_bit(). Because set_bit() lacks a fu=
ll
memory barrier, the CPU or compiler can reorder the led->rgb writes to occur
after the dirty bit is set.

A concurrently executing asus_aura_zone_work() on another CPU could observe
the dirty bit via test_and_clear_bit(), read stale led->rgb values, and
clear the bit, causing the new color to be permanently lost.

> +}
> +
> +static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
> +{
> +	struct asus_aura_led *led =3D &zone->leds[index];
> +	struct led_classdev *cdev =3D &led->mc_cdev.led_cdev;
> +	int ret;
> +
> +	led->zone =3D zone;
> +	led->index =3D index;
> +
> +	led->subled[0].color_index =3D LED_COLOR_ID_RED;
> +	led->subled[1].color_index =3D LED_COLOR_ID_GREEN;
> +	led->subled[2].color_index =3D LED_COLOR_ID_BLUE;
> +	led->mc_cdev.num_colors =3D 3;
> +	led->mc_cdev.subled_info =3D led->subled;
> +
> +	cdev->name =3D kasprintf(GFP_KERNEL, "asus-arion:led%d", index);

[Severity: Medium]
Will this hardcoded name in asus_aura_register_led() in
drivers/leds/leds-asus-aura-scsi.c cause a sysfs collision if multiple
enclosures are connected?

If a user connects two ASUS ROG external NVMe enclosures, the second enclos=
ure
will attempt to register identical sysfs names (e.g.,
/sys/class/leds/asus-arion:led0), resulting in an -EEXIST error and
preventing the use of multiple devices simultaneously.

> +	if (!cdev->name)
> +		return -ENOMEM;
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
Does this prevent the driver from compiling?

In asus_aura_attach() in drivers/leds/leds-asus-aura-scsi.c, the macro
kzalloc_obj does not exist in the Linux kernel headers, leading to an
implicit declaration or undefined reference error.

> +	if (!zone)
> +		return SCSI_DH_NOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609032000.RFCv2-=
1.lhw@gmail.com?part=3D1
