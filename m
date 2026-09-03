Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4564DC53E;
	Thu,  3 Sep 2026 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452043; cv=none; b=O+eleHx9w8/oD5a2XJuT6AUThnyIjrmOXpH1vol4WbqVtNLauLEndYeMUn+2C4sEJdZZRQh0uEtk2u6HVBh55Z5WaRUzcWhj1Fi2I5ynxVQDYgRHnfMSaU1ADxyabVQ6T3fqiyhONgYI4eHlhDS7GFXT6Qrq1GfAYWzwNjMOKS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452043; c=relaxed/simple;
	bh=+vIyJ55JwfiugNBsVbUkXE42T3sQQCq8oBVpUpLL0z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYP3goCQUIush9hFL+BJpUFyJmXVGmelLrFZt24LtoDc71q0G4T/WAzLXl4vyNkG4kZS5BGVtqWSi5Sl6yo7c2cnDpiGJi+lQVshoCAcH90/nlhRJ02kpwC/1/jWCXkpC7XFBOsFwf+fcUjnzgrGYwibQ0FySEmDamWRXIt9ZFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbDz5Six; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbDz5Six"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853E41F000E9;
	Thu,  3 Sep 2026 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452041;
	bh=RXvP2AE6LBhdzWhfsyL5aOMR8/s9fFz8n1HlG2XmpQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbDz5SixQXmN6vyqhkLn+lgB0rAKZdxUqL8iyNpJcVEtC6B3youPCLePlnxZeA9dI
	 iwz3UovZDL8H8WMVQzIgStxhyH03WW5q4oa51XvsLD8oIq2pWuW1DWuCY6cd7z0GyL
	 ieT7sykzyxgVMAc5m9BIXbR+GnIJgWkJXM+DSIUU8QCF2tcqPqMKUMuBfcunLwbDvA
	 XpbBTIOPOUrgpd5JqxZX/s64Vb/dnefamXrmHdk+b0+Pcn8GK+GJdlK/x9lk85TZvX
	 OYd5GVrHfiArYph+QTZv4l8lqUOmoBSK9mg9FlqXQlAexnLJ2nPmtA9X3BLgAvjFAW
	 DhisBcXC+DN0A==
Date: Thu, 3 Sep 2026 17:13:57 +0100
From: Lee Jones <lee@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Liang Haowen <nbg2974@gmail.com>, linux-scsi@vger.kernel.org,
	linux-leds@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260903161357.GX2133376@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903122408.3CA6B1F00A3A@smtp.kernel.org>

On Thu, 03 Sep 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] The workqueue function unconditionally writes to flash even when no LEDs are dirty.
> - [Medium] Hardcoded LED class device names will cause a sysfs collision if multiple enclosures are connected.
> - [Medium] Missing memory barriers and locking for led->rgb cause data races and lost color updates.
> - [Low] Missing 'struct request_queue *' argument in blk_rq_map_kern() call.
> - [Low] Use of non-existent kzalloc_obj macro prevents compilation.

Please review, explain or fix the Sashiko review(s).

If this is a set, this request includes the other patches too.

> --
> 
> commit 12eb38bf536e935469d4f61d68a4b96acd78d4b1
> Author: Liang Haowen <nbg2974@gmail.com>
> 
> leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
> 
> This commit adds a new out-of-tree driver for ASUS ROG external NVMe
> enclosures. It registers a SCSI device handler matched by INQUIRY and
> exposes the 4 addressable Aura RGB LEDs as multicolor LED class devices.
> A single per-zone work item handles the ENE protocol sequences and
> serializes updates.
> 
> > diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> > new file mode 100644
> > index 0000000000000..4dd559a5d8ec1
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
> Does this missing argument in ene_write() in
> drivers/leds/leds-asus-aura-scsi.c cause a build failure? The
> blk_rq_map_kern() function takes 5 arguments (requiring a
> struct request_queue *q as the first parameter), but only 4 are provided
> here.
> 
> > +		if (ret)
> > +			goto out;
> > +	}
> [ ... ]
> > +static void asus_aura_zone_work(struct work_struct *work)
> > +{
> > +	struct asus_aura_zone *zone =
> > +		container_of(work, struct asus_aura_zone, work);
> > +	struct scsi_device *sdev = zone->sdev;
> > +	u8 apply = ENE_APPLY;
> > +	u8 save = ENE_SAVE;
> > +	u8 mode = ENE_MODE_STATIC;
> > +	int i, ret;
> > +
> > +	if (!scsi_device_online(sdev))
> > +		return;
> > +
> > +	/* Mode first: without it the device ignores the whole sequence. */
> > +	ret = ene_write(sdev, ENE_REG_MODE, &mode, 1);
> > +	if (ret)
> > +		goto err;
> > +
> > +	for (i = 0; i < ARION_NUM_LEDS; i++) {
> > +		struct asus_aura_led *led = &zone->leds[i];
> > +
> > +		if (!test_and_clear_bit(i, &zone->dirty))
> > +			continue;
> > +
> > +		ret = ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
> > +				led->rgb, ENE_RGB_LEN);
> > +		if (ret)
> > +			goto err;
> > +
> > +		/*
> > +		 * Cover the DIRECT colour set too; some firmware revisions
> > +		 * pull from 0x8100 instead of 0x8160.
> > +		 */
> > +		ret = ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
> > +				led->rgb, ENE_RGB_LEN);
> > +		if (ret)
> > +			goto err;
> > +	}
> > +
> > +	ret = ene_write(sdev, ENE_REG_APPLY, &apply, 1);
> > +	if (ret)
> > +		goto err;
> > +
> > +	/*
> > +	 * The change only takes effect after SAVE (0xaa). NOTE: saving on
> > +	 * every brightness change writes flash each time; revisit for wear
> > +	 * once confirmed.
> > +	 */
> > +	ret = ene_write(sdev, ENE_REG_APPLY, &save, 1);
> 
> [Severity: High]
> Does asus_aura_zone_work() in drivers/leds/leds-asus-aura-scsi.c
> unconditionally write to the device flash even when no LEDs are dirty?
> 
> If schedule_work() is called while asus_aura_zone_work() is already
> executing, the work item gets re-queued. If the first execution already
> processed the newly set LED bit, the second execution will observe a fully
> cleared zone->dirty bitmap, but still send the MODE, APPLY, and SAVE
> commands to the hardware.
> 
> Since SAVE writes to the device flash, these spurious empty runs could cause
> unnecessary device flash wear.
> 
> > +	if (ret)
> > +		goto err;
> > +
> > +	return;
> > +err:
> > +	dev_err(&sdev->sdev_gendev,
> > +		"asus_aura: colour update failed: %d\n", ret);
> > +}
> > +
> > +/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI. */
> > +static void asus_aura_set(struct led_classdev *cdev,
> > +			  enum led_brightness brightness)
> > +{
> > +	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
> > +	struct asus_aura_led *led =
> > +		container_of(mc, struct asus_aura_led, mc_cdev);
> > +
> > +	led_mc_calc_color_components(mc, brightness);
> > +	/* ENE colour register byte order is R, B, G. */
> > +	led->rgb[0] = led->subled[0].brightness;
> > +	led->rgb[1] = led->subled[2].brightness;
> > +	led->rgb[2] = led->subled[1].brightness;
> > +
> > +	set_bit(led->index, &led->zone->dirty);
> > +	schedule_work(&led->zone->work);
> 
> [Severity: Medium]
> Can this cause data races and lost color updates?
> 
> In asus_aura_set() in drivers/leds/leds-asus-aura-scsi.c, led->rgb is updated
> before marking the LED as dirty via set_bit(). Because set_bit() lacks a full
> memory barrier, the CPU or compiler can reorder the led->rgb writes to occur
> after the dirty bit is set.
> 
> A concurrently executing asus_aura_zone_work() on another CPU could observe
> the dirty bit via test_and_clear_bit(), read stale led->rgb values, and
> clear the bit, causing the new color to be permanently lost.
> 
> > +}
> > +
> > +static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
> > +{
> > +	struct asus_aura_led *led = &zone->leds[index];
> > +	struct led_classdev *cdev = &led->mc_cdev.led_cdev;
> > +	int ret;
> > +
> > +	led->zone = zone;
> > +	led->index = index;
> > +
> > +	led->subled[0].color_index = LED_COLOR_ID_RED;
> > +	led->subled[1].color_index = LED_COLOR_ID_GREEN;
> > +	led->subled[2].color_index = LED_COLOR_ID_BLUE;
> > +	led->mc_cdev.num_colors = 3;
> > +	led->mc_cdev.subled_info = led->subled;
> > +
> > +	cdev->name = kasprintf(GFP_KERNEL, "asus-arion:led%d", index);
> 
> [Severity: Medium]
> Will this hardcoded name in asus_aura_register_led() in
> drivers/leds/leds-asus-aura-scsi.c cause a sysfs collision if multiple
> enclosures are connected?
> 
> If a user connects two ASUS ROG external NVMe enclosures, the second enclosure
> will attempt to register identical sysfs names (e.g.,
> /sys/class/leds/asus-arion:led0), resulting in an -EEXIST error and
> preventing the use of multiple devices simultaneously.
> 
> > +	if (!cdev->name)
> > +		return -ENOMEM;
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
> Does this prevent the driver from compiling?
> 
> In asus_aura_attach() in drivers/leds/leds-asus-aura-scsi.c, the macro
> kzalloc_obj does not exist in the Linux kernel headers, leading to an
> implicit declaration or undefined reference error.
> 
> > +	if (!zone)
> > +		return SCSI_DH_NOMEM;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/202609032000.RFCv2-1.lhw@gmail.com?part=1

-- 
Lee Jones
