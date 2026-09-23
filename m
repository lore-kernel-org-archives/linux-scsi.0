Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017630DEA5;
	Wed, 23 Sep 2026 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167563; cv=none; b=oops0qXB5vV+oz2T2XqTRFeVp8oihAjhQQT6uJMH6+Q24QE0NSV17o9PevSkzVGYKGm2GpmiZHkPOqplkFhba60yqkg4QUFiEefrfjC/rbLf/JgXv3J749xqqVegWzHEmFs1VPmNZz4fkEewMzVh4yCo6Ynpcs4cTXRsjl22eQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167563; c=relaxed/simple;
	bh=FiUSXNgxC2DzjLjOELG2aaTAfqPakk8IrIEAVofoEhU=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZMQceA9n1vMEQbKbXfr3NR2leZJh/LVU4qeXkS+f8KvNYU4nxzRi9lsnDFGL2vwxryaD2pmz/xvSI5UT5pf8w+zm+BOSZPuh7IH8Z22rLB6espF/n2XmhfPeAvlYWY1DV83UjlQfwxFaPc9XA5d5NzOjR4ONE36x89ncrgxJU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mHYRMinC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mHYRMinC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790167562; x=1821703562;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=FiUSXNgxC2DzjLjOELG2aaTAfqPakk8IrIEAVofoEhU=;
  b=mHYRMinCxYhhJ5zpqy5+gUCv1gykZNagPi3ELdCFHcjbZU6JuaWBZa/K
   ZUXHLPBbgo2pAzZ45EVhGGhqgNWN1Vw6vTO4eYdfAKbFQr/dTteBgSr3/
   swxu5Zlm6CPlDf3Ie3/AT+pcSUxK7eJEnNhqI3MsSR73OTVh8ZxKl6B3q
   5NHXEKNqxytcbRHzGG6k+p2xsoJ1Scztw/YzZOVkNoMFN45s6BstAmSyJ
   G7JO4ty6mWJnvdplJ9L/J3CZWgL7SCUSRFggfHV9IfilvmRSttM6bim1p
   3XYRLV+P85k6VA8Uvu/mKEA0X18ESkHeHbrRMcCPeCilumPkyKQrKuBsw
   g==;
X-CSE-ConnectionGUID: u4smDuKKRhSZnO0ZTDns8g==
X-CSE-MsgGUID: RA0YlYPGSA2J0Y6fgu1A6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="102216093"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="102216093"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 05:46:01 -0700
X-CSE-ConnectionGUID: ApQe5cyORFWCPOVF+HLEww==
X-CSE-MsgGUID: ZKF3L5BOQ+ufz29F0bkT0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="272204184"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.13])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 05:45:57 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 23 Sep 2026 15:45:53 +0300 (EEST)
To: Liang Haowen <nbg2974@gmail.com>
cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>, 
    Pavel Machek <pavel@kernel.org>, "Martin K . Petersen" <mkp@kernel.org>, 
    linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, Denis Benato <denis.benato@linux.dev>, 
    Armin Wolf <W_Armin@gmx.de>, Hans de Goede <hansg@kernel.org>
Subject: Re: [RFC v8 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
In-Reply-To: <20260923121832.2613187-2-nbg2974@gmail.com>
Message-ID: <507d6c26-7892-f83b-45b7-bcfd12e11fcc@linux.intel.com>
References: <20260923121832.2613187-1-nbg2974@gmail.com> <20260923121832.2613187-2-nbg2974@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 23 Sep 2026, Liang Haowen wrote:

> ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
> plain USB mass-storage devices with no HID interface: the Aura LEDs
> hang off an ENE controller driven by vendor SCSI commands on the same
> LUN as the disk. The enclosure has 4 independently addressable LEDs,
> verified on hardware.
> 
> Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
> model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
> disk) and exposes each LED as a multicolor LED class device,
> /sys/class/leds/asus-arion-0-0-0-0::led-0 through led-3. The
> H:C:T:L part of the sdev name keeps the names unique when more than
> one enclosure is connected, with its colons flattened to dashes. The
> color section stays empty, since multicolor LEDs enumerate their
> palette via multi_intensity, and the four identical zones use the
> function name with a "-N" ordinal, as the naming section in
> Documentation/leds/leds-class.rst asks for.
> 
> Protocol: a 16-byte vendor CDB (opcode 0xec, 'A' 'S' signature,
> BE16 register index, argument count in byte 13), modelled by
> struct ene_cdb. MODE 0x8021 (Static) must be written first in every
> sequence or the device ignores it; colours go to 0x8160 + 3 * led
> and 0x8100 + 3 * led (3 bytes, wire order R, B, G; both tables are
> written because firmware revisions pull from one or the other);
> APPLY 0x80a0 takes 0x01 to apply and 0xaa to save.
> 
> The CDB cannot go through scsi_execute_cmd(): it sizes the command
> via scsi_command_size(opcode), which maps vendor opcode 0xec to
> 10 bytes, so byte 13 is dropped and the device silently ignores the
> write (GOOD status, no error). scsi_execute_cmd() also offers no way
> to override the derived length. The request is therefore built with
> scsi_alloc_request(), which initializes the scsi_cmnd parts a
> passthrough needs, with cmd_len set to the CDB size, mirroring what
> SG_IO does from userspace. A 5 s timeout and a single retry-less
> quiet submission cover the register writes.
> 
> The write payload is copied into a per-device buffer before it is
> mapped with blk_rq_map_kern(), so no stack memory is ever mapped for
> DMA (VMAP_STACK).
> 
> brightness_set only caches the colour and marks the LED pending
> under a spinlock; led_mc_calc_color_components() runs under that
> lock too, because it writes the shared subled_info array and
> trigger events call led_set_brightness() without the led_access lock
> that serializes sysfs stores. A single work item per enclosure then
> snapshots the pending LEDs and runs one ENE sequence for all of
> them. Funneling every update through one work item keeps the
> sequences from interleaving between concurrent LED updates and
> batches multi-LED updates into a single APPLY/SAVE. A re-queued run
> with nothing pending returns before touching the device, so it
> cannot wear the flash with a pointless SAVE, and the lock keeps a
> colour write from being reordered after its pending flag on weakly
> ordered architectures.
> 
> This is the monolithic out-of-tree version as verified on hardware;
> the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
> into a SCSI transport helper and a shared ASUS Aura LED interface.
> 
> Signed-off-by: Liang Haowen <nbg2974@gmail.com>
> ---
>  drivers/leds/rgb/leds-asus-aura-scsi.c | 388 +++++++++++++++++++++++++
>  1 file changed, 388 insertions(+)
>  create mode 100644 drivers/leds/rgb/leds-asus-aura-scsi.c
> 
> diff --git a/drivers/leds/rgb/leds-asus-aura-scsi.c b/drivers/leds/rgb/leds-asus-aura-scsi.c
> new file mode 100644
> index 0000000..eaba968
> --- /dev/null
> +++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
> @@ -0,0 +1,388 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * ASUS Aura RGB over SCSI for ROG external NVMe enclosures
> + * (e.g. ROG STRIX Arion, USB 0b05:1932).
> + *
> + * USB mass-storage device, no HID; the ENE LED controller is driven via
> + * vendor SCSI commands on the disk's LUN. Matched by INQUIRY (vendor
> + * "ROG", model "ESD-S1C"); the sdev is not claimed, sd keeps owning the
> + * disk. Attach manually until the SCSI side agrees on an in-tree hook:
> + * echo asus_aura > /sys/block/sdX/device/dh_state
> + *
> + * Each of the 4 LEDs is a multicolor LED class device,
> + * /sys/class/leds/asus-arion-<H-C-T-L>::led-0..led-3. A colour change
> + * writes only that LED's slots in the ENE colour tables, then applies
> + * and saves; MODE must precede every sequence or the device ignores
> + * it. The register layout is described by struct ene_cdb.
> + *
> + * brightness_set (LED core fast path) only caches the colour and marks
> + * the LED pending under a spinlock; a single work item per enclosure
> + * snapshots all pending LEDs and runs one ENE sequence for them. One
> + * work item also serializes the sequences against each other: the
> + * MODE/colour/APPLY/SAVE chain must never interleave between
> + * concurrent LED updates.
> + */
> +
> +#include <linux/bits.h>
> +#include <linux/blk-mq.h>
> +#include <linux/blk_types.h>
> +#include <linux/blkdev.h>
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/led-class-multicolor.h>
> +#include <linux/leds.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/workqueue.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_dh.h>
> +
> +#define ARION_INQ_VENDOR	"ROG"
> +#define ARION_INQ_MODEL		"ESD-S1C"
> +
> +/* The colour table has 16 slots; 4 of them drive LEDs. */
> +#define ARION_NUM_LEDS		4
> +
> +/* ENE register map (BE16 on the wire). */
> +#define ENE_REG_MODE		0x8021	/* 1 = Static selects the colour tables */
> +#define ENE_REG_APPLY		0x80a0	/* 0x01 = apply, 0xaa = apply and save */
> +#define ENE_REG_COLORS_EFFECT	0x8160	/* colour table, 3 bytes per LED */
> +#define ENE_REG_COLORS_DIRECT	0x8100	/* second table some firmware uses */
> +
> +#define ENE_MODE_STATIC		1
> +#define ENE_APPLY		0x01
> +#define ENE_SAVE		0xaa
> +
> +/* The colour tables are R, B, G on the wire; the subleds are R, G, B. */
> +#define ENE_WIRE_R		0
> +#define ENE_WIRE_B		1
> +#define ENE_WIRE_G		2
> +#define ENE_RGB_LEN		3
> +
> +/*
> + * Vendor CDB: opcode, 'A''S' signature, register, argument count in
> + * byte 13. scsi_execute_cmd() cannot be used for it, see the commit
> + * message.
> + */
> +struct ene_cdb {
> +	u8		opcode;
> +	u8		sig[2];
> +	__be16		reg;
> +	u8		reserved[8];
> +	u8		arg_count;
> +	u8		pad[2];
> +} __packed;
> +
> +static_assert(sizeof(struct ene_cdb) == 16);

When you add new non-local stuff, you should be concious if you need to 
add a header for it. Here you added __packed and static_assert() both 
require a new include to be added.

It would be good for you to do one pass over your own code to check if you 
still miss other includes.

> +struct asus_aura_led {
> +	struct led_classdev_mc	mc_cdev;
> +	struct mc_subled	subled[ENE_RGB_LEN];
> +
> +	/* Cached colour, consumed by the work item. */
> +	u8			rgb[ENE_RGB_LEN];
> +	bool			pending;
> +
> +	struct asus_aura	*aura;
> +};
> +
> +struct asus_aura {
> +	struct scsi_device	*sdev;
> +	struct asus_aura_led	leds[ARION_NUM_LEDS];
> +
> +	/* Serializes the cached colours and pending flags. */
> +	spinlock_t		lock;
> +	struct work_struct	work;
> +
> +	/* DMA-safe staging buffer, the only memory ever mapped for DMA. */
> +	u8			tx[ENE_RGB_LEN];
> +};
> +
> +static int ene_write_reg(struct asus_aura *aura, u16 reg,
> +			 const u8 *tx, u8 len)
> +{
> +	struct scsi_device *sdev = aura->sdev;
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	struct ene_cdb cdb = {
> +		.opcode		= 0xec,
> +		.sig		= { 'A', 'S' },
> +		.reg		= cpu_to_be16(reg),

Include for cpu_to_be16().

> +		.arg_count	= len,
> +	};
> +	int ret;
> +
> +	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(rq))
> +		return PTR_ERR(rq);
> +
> +	/*
> +	 * Stack memory is not DMA-safe (VMAP_STACK), so the payload is
> +	 * copied into the per-device buffer first.
> +	 */
> +	memcpy(aura->tx, tx, len);
> +	ret = blk_rq_map_kern(rq, aura->tx, len, GFP_NOIO);
> +	if (ret)
> +		goto out;
> +
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->cmd_len = sizeof(cdb);
> +	memcpy(scmd->cmnd, &cdb, sizeof(cdb));
> +	scmd->allowed = 1;
> +	rq->timeout = 5 * HZ;

I don't think moving it here from define was an improvements.

> +	rq->rq_flags |= RQF_QUIET;
> +
> +	blk_execute_rq(rq, true);
> +
> +	/* GOOD status is zero in the fields we care about. */
> +	ret = scmd->result ? -EIO : 0;
> +out:
> +	blk_mq_free_request(rq);
> +	return ret;
> +}
> +
> +static void asus_aura_work(struct work_struct *work)
> +{
> +	struct asus_aura *aura =
> +		container_of(work, struct asus_aura, work);

Lee did ask you to put these on a single line.

Also add the include for container_of().

> +	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
> +	bool pending[ARION_NUM_LEDS];
> +	bool any = false;
> +	unsigned long flags;
> +	int ret;
> +
> +	/*
> +	 * Fast path without the lock: if nothing is pending, return
> +	 * before touching the device. A colour arriving right after
> +	 * the check re-queues this work, so nothing is lost.
> +	 */
> +	for (int i = 0; i < ARION_NUM_LEDS; i++) {

For anything that iterates over an array of entries, use ARRAY_SIZE(). 
Don't forget to add include for it.

> +		if (READ_ONCE(aura->leds[i].pending)) {

Include for READ_ONCE()

> +			any = true;
> +			break;
> +		}
> +	}
> +	if (!any)
> +		return;
> +
> +	/* Snapshot the cached colours and clear the pending flags. */
> +	spin_lock_irqsave(&aura->lock, flags);
> +	for (int i = 0; i < ARION_NUM_LEDS; i++) {

ARRAY_SIZE()

> +		pending[i] = aura->leds[i].pending;
> +		aura->leds[i].pending = false;
> +		memcpy(rgb[i], aura->leds[i].rgb, ENE_RGB_LEN);
> +	}
> +	spin_unlock_irqrestore(&aura->lock, flags);
> +
> +	if (!scsi_device_online(aura->sdev))
> +		return;
> +
> +	/* Mode first: without it the device ignores the sequence. */
> +	ret = ene_write_reg(aura, ENE_REG_MODE,
> +			   &(u8){ ENE_MODE_STATIC }, 1);

To make it easier for those two read this code, I suggest you add a local 
u8 and then use sizeof() to bind the len to its size. It would also avoid
the complex looking initializer.

> +	if (ret)
> +		goto err;
> +
> +	for (int i = 0; i < ARION_NUM_LEDS; i++) {

ARRAY_SIZE().

> +		if (!pending[i])
> +			continue;
> +
> +		/*
> +		 * Both colour tables are written: firmware revisions
> +		 * pull from either of them.
> +		 */
> +		ret = ene_write_reg(aura, ENE_REG_COLORS_EFFECT + i * ENE_RGB_LEN,
> +				    rgb[i], ENE_RGB_LEN);
> +		if (ret)
> +			goto err;
> +
> +		ret = ene_write_reg(aura, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
> +				    rgb[i], ENE_RGB_LEN);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	ret = ene_write_reg(aura, ENE_REG_APPLY, &(u8){ ENE_APPLY }, 1);
> +	if (ret)
> +		goto err;
> +
> +	/* The change only takes effect after a save. */
> +	ret = ene_write_reg(aura, ENE_REG_APPLY, &(u8){ ENE_SAVE }, 1);
> +	if (ret)
> +		goto err;
> +
> +	return;
> +
> +err:
> +	/*
> +	 * This runs detached from the LED core, which has no error
> +	 * channel for brightness_set. The write is dropped and logged
> +	 * ratelimited; the LED keeps the last successfully applied
> +	 * colour until the next user update.
> +	 */
> +	dev_err_ratelimited(&aura->sdev->sdev_gendev,

Still missing the include for dev_*() printing.

> +			    "asus_aura: colour update failed: %d\n", ret);
> +}
> +
> +/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI. */
> +static void asus_aura_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
> +	struct asus_aura_led *led =
> +		container_of(mc, struct asus_aura_led, mc_cdev);
> +	struct asus_aura *aura = led->aura;
> +	unsigned long flags;
> +
> +	/*
> +	 * led_mc_calc_color_components() writes the shared subled_info
> +	 * array. Sysfs stores are serialized by the LED core, but
> +	 * trigger events call led_set_brightness() without that lock,
> +	 * so compute and cache under the aura lock.
> +	 */
> +	spin_lock_irqsave(&aura->lock, flags);
> +
> +	led_mc_calc_color_components(mc, brightness);
> +
> +	led->rgb[ENE_WIRE_R] = led->subled[0].brightness;
> +	led->rgb[ENE_WIRE_B] = led->subled[2].brightness;
> +	led->rgb[ENE_WIRE_G] = led->subled[1].brightness;
> +	led->pending = true;
> +
> +	spin_unlock_irqrestore(&aura->lock, flags);
> +
> +	schedule_work(&aura->work);
> +}
> +
> +static int asus_aura_register_led(struct asus_aura *aura, int index)
> +{
> +	struct asus_aura_led *led = &aura->leds[index];
> +	struct led_classdev *cdev = &led->mc_cdev.led_cdev;
> +	char hctl[32];
> +	int ret;
> +
> +	led->aura = aura;
> +
> +	led->subled[0].color_index = LED_COLOR_ID_RED;
> +	led->subled[1].color_index = LED_COLOR_ID_GREEN;
> +	led->subled[2].color_index = LED_COLOR_ID_BLUE;
> +	led->mc_cdev.num_colors = ENE_RGB_LEN;
> +	led->mc_cdev.subled_info = led->subled;
> +
> +	/*
> +	 * The sdev's H:C:T:L keeps the names unique when more than one
> +	 * enclosure is connected; with a static name the LED core would
> +	 * register a second enclosure's LEDs under renamed nodes
> +	 * (asus-arion::led-0_1), the wrong device identity. The colons
> +	 * are flattened to dashes, the color section stays empty
> +	 * (multicolor, palette via multi_intensity) and the four
> +	 * identical zones take a "-N" ordinal, as
> +	 * Documentation/leds/leds-class.rst asks for.
> +	 */
> +	strscpy(hctl, dev_name(&aura->sdev->sdev_gendev));
> +	strreplace(hctl, ':', '-');
> +	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s::led-%d", hctl, index);
> +	if (!cdev->name)
> +		return -ENOMEM;
> +
> +	cdev->max_brightness = 255;
> +	cdev->brightness_set = asus_aura_set;
> +
> +	led_mc_calc_color_components(&led->mc_cdev, cdev->brightness);
> +
> +	/*
> +	 * NULL parent: a device reference on the sdev would block its
> +	 * final release on unplug, which is what calls detach() to
> +	 * unregister the LEDs. The cycle leaked nodes and the module
> +	 * refcount on every hot-unplug.
> +	 */
> +	ret = led_classdev_multicolor_register(NULL, &led->mc_cdev);
> +	if (ret)
> +		kfree(cdev->name);
> +	return ret;
> +}
> +
> +/*
> + * Unregister the LEDs before cancelling the work: unregistering removes
> + * the sysfs attributes, so no new brightness_set can schedule the work
> + * afterwards. Cancelling first would leave a window where a brightness
> + * write requeues the work after cancel_work_sync() returned.
> + */
> +static void asus_aura_release(struct asus_aura *aura, int num_leds)
> +{
> +	for (int i = 0; i < num_leds; i++) {
> +		led_classdev_multicolor_unregister(&aura->leds[i].mc_cdev);
> +		kfree(aura->leds[i].mc_cdev.led_cdev.name);
> +	}
> +
> +	cancel_work_sync(&aura->work);
> +	kfree(aura);
> +}
> +
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura *aura;
> +	int ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	aura = kzalloc_obj(*aura, GFP_KERNEL);
> +	if (!aura)
> +		return SCSI_DH_NOMEM;
> +
> +	aura->sdev = sdev;
> +	spin_lock_init(&aura->lock);
> +	INIT_WORK(&aura->work, asus_aura_work);
> +
> +	for (int i = 0; i < ARION_NUM_LEDS; i++) {
> +		ret = asus_aura_register_led(aura, i);
> +		if (ret) {
> +			asus_aura_release(aura, i);
> +			return SCSI_DH_NOMEM;
> +		}
> +	}
> +
> +	sdev->handler_data = aura;
> +	return SCSI_DH_OK;
> +}
> +
> +static void asus_aura_detach(struct scsi_device *sdev)
> +{
> +	struct asus_aura *aura = sdev->handler_data;
> +
> +	if (!aura)
> +		return;
> +
> +	asus_aura_release(aura, ARION_NUM_LEDS);
> +	sdev->handler_data = NULL;
> +}
> +
> +static struct scsi_device_handler asus_aura_dh = {
> +	.name	= "asus_aura",
> +	.module	= THIS_MODULE,
> +	.attach	= asus_aura_attach,
> +	.detach	= asus_aura_detach,
> +};
> +
> +static int __init asus_aura_init(void)
> +{
> +	return scsi_register_device_handler(&asus_aura_dh);
> +}
> +
> +static void __exit asus_aura_exit(void)
> +{
> +	scsi_unregister_device_handler(&asus_aura_dh);
> +}
> +
> +module_init(asus_aura_init);
> +module_exit(asus_aura_exit);
> +
> +MODULE_DESCRIPTION("ASUS Aura RGB over SCSI for ROG NVMe enclosures");
> +MODULE_AUTHOR("Liang Haowen");
> +MODULE_LICENSE("GPL");
> 

-- 
 i.

