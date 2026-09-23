Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA7E4570FE;
	Wed, 23 Sep 2026 09:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790156747; cv=none; b=Ul2rVm+FKapzVSMjLo1N2sxdOg1jXpaEIJGVpN6+xkYDjRbJuZ6w0v1vFk4qkSgLadSz9tfZXEl0BolY3tMDsdZuiy6y683dlvm6XixBhiU3nJWz0VMhBzoK+mYNvTL75jDZ7zLJqueHy3K+iA513GGr68YvV9JTHBdF4LJiRo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790156747; c=relaxed/simple;
	bh=hkaxi53CxLEOGRJkhlYGKiyQ0iIv4+coLz3qKfWTPio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pqo9psy4CHJWdrWLCiMmiJ69KgQ2r15DnENamzm3dya/+TW6vXgDClhhuv+M42K7a6/UhUztDn4cturycn2c+9ywLpP38mt3YY8CYVdjpDI043lrVFr8YEU23EBjAOslcGbAVG3Xie2ehJ+P2L+rWoFklE2XrTPUov8emSTOpU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gam6tHlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gam6tHlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2051F000FF;
	Wed, 23 Sep 2026 09:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790156744;
	bh=J53wD1icBeDv0iyttZN6dt86cTmTzLUsmup7bkDO9N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gam6tHluSV2mjm+sU3lpay8M8VdbjiurXUMoUpoDV09pA3wdAqCEVmvWwRgBA121n
	 SympuvLgIhWs6Ye6rxS6QDfM8Zk6iiLPgYDMx5miA93x2ogrx7ysD6s41ykL3fDRhE
	 LwhOjL88j5mtaICyquGFAU+RYjM5c6eQAgWCCCkE5CKex4Wx4Oe6v2UGGBkFpD5HCI
	 +MiWFks342SlaT37pb8bNxmJ5ZVVfXYkNFTPurDqOUb0vVK8x/cIdHcP3ue3fzGmXD
	 rAT94vsrVilHKLpM5HhWBni9syjVCqvxUCcjAKh5WUqmOF5V9ehjqvJarKEEMr0+NT
	 o9DGZom/A7FWA==
Date: Wed, 23 Sep 2026 10:45:39 +0100
From: Lee Jones <lee@kernel.org>
To: Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH RFC v6 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260923094539.GA3864833@google.com>
References: <202609162200.RFCv6-0.lhw@gmail.com>
 <202609162200.RFCv6-1.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609162200.RFCv6-1.lhw@gmail.com>

On Wed, 16 Sep 2026, Liang Haowen wrote:

> From: Liang Haowen <nbg2974@gmail.com>
> Date: Wed, 16 Sep 2026 21:20:00 +0800
> Subject: [PATCH RFC v6] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for
>  ROG NVMe enclosures

What patch format is this?  How did you submit it?

> ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
> plain USB mass-storage devices with no HID interface: the Aura LEDs
> hang off an ENE controller driven by vendor SCSI commands on the same
> LUN as the disk. The enclosure has 4 independently addressable LEDs,
> verified on hardware.
> 
> Register a scsi_device_handler matched by INQUIRY (vendor "ROG",

If the SCSI DH the right approach here?

I only see references to it in the SCSI subsystem and only in its own
dedicated driver.  This is all very unusual.

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
> register index, argument count in cdb[13]). MODE 0x8021 (Static) must
> be written first in every sequence or the device ignores it; colours
> go to 0x8160 + 3 * led and 0x8100 + 3 * led (3 bytes, order R, B, G;
> both tables are written because firmware revisions pull from one or
> the other); APPLY 0x80a0 takes 0x01 to apply and 0xaa to save.
> 
> The CDB cannot go through scsi_execute_cmd(): it sizes the command
> via scsi_command_size(opcode), which maps vendor opcode 0xec to
> 10 bytes, so cdb[13] is dropped and the device silently ignores the
> write (GOOD status, no error). The request is built with
> scsi_alloc_request() instead, which initializes the scsi_cmnd parts a
> passthrough needs (command buffer, lengths, rcu head), with cmd_len
> forced to 16, mirroring what SG_IO does from userspace.
> 
> brightness_set only caches the colour and marks the LED in a per-zone
> dirty mask under a spinlock; led_mc_calc_color_components() runs under
> that lock too, because it writes the shared subled_info array and
> trigger events call led_set_brightness() without the led_access lock
> that serializes sysfs stores. A single work item per zone then
> snapshots the mask and colours and runs one ENE sequence for all
> pending LEDs (MODE, colour slots, APPLY, SAVE). Funneling every
> update through one work item keeps the sequences from interleaving
> between concurrent LED updates and batches multi-LED updates into a
> single APPLY/SAVE. A re-queued run with nothing pending returns
> before touching the device, so it cannot wear the flash with a
> pointless SAVE, and the lock keeps a colour write from being
> reordered after its dirty bit on weakly ordered architectures.
> 
> This is the monolithic out-of-tree version as verified on hardware;
> the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
> into a SCSI transport helper and a shared ASUS Aura LED interface.
> 
> Signed-off-by: Liang Haowen <nbg2974@gmail.com>
> ---
>  drivers/leds/leds-asus-aura-scsi.c | 392 +++++++++++++++++++++++++++++

Shouldn't this live in drivers/leds/rgb ?

>  1 file changed, 392 insertions(+)
>  create mode 100644 drivers/leds/leds-asus-aura-scsi.c
> 
> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> new file mode 100644
> index 0000000..4e039bd
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
> @@ -0,0 +1,392 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * ASUS Aura RGB over SCSI for ROG external NVMe enclosures
> + * (e.g. ROG STRIX Arion, USB 0b05:1932).
> + *
> + * USB mass-storage device, no HID; the ENE LED controller is driven via
> + * vendor SCSI commands. Matched by INQUIRY (vendor "ROG", model "ESD-S1C"),
> + * does NOT claim the sdev (sd keeps owning the disk).
> + *
> + * The Arion exposes 4 independently addressable LEDs (verified on hardware):
> + * each is a multicolor LED class device (asus-arion-<H-C-T-L>::led-0..led-3,
> + * unique per enclosure). A colour change writes that LED's slot only:
> + * EFFECT 0x8160 + 3*led, DIRECT 0x8100 + 3*led (3 bytes, byte order R, B, G),
> + * then APPLY (0x01) and SAVE (0xaa). MODE (0x8021 = Static) is written first
> + * in every sequence; skipping it makes the device ignore the whole sequence.
> + *
> + * Scheduling: brightness_set (LED core fast path) caches the colour and
> + * marks the LED in a per-zone dirty mask under a spinlock; a single work
> + * item per zone snapshots the mask and colours, then runs one ENE
> + * sequence for all pending LEDs (MODE once, colour slots, APPLY, SAVE).
> + * Funneling every update through that one work item also serializes the
> + * sequences: the MODE/colour/APPLY/SAVE chain must never interleave
> + * between concurrent LED updates. The snapshot makes re-queued runs with
> + * nothing left to do return before touching the device, so a re-queue
> + * cannot wear the flash with a pointless SAVE, and the lock keeps a
> + * colour write from being reordered after its dirty bit on weakly
> + * ordered architectures.
> + *
> + * CDB length: scsi_execute_cmd() sizes the CDB via COMMAND_SIZE(opcode),
> + * which maps vendor opcode 0xec to 10 bytes. The ENE protocol uses a 16-byte
> + * CDB with the data length in cdb[13], so scsi_execute_cmd() drops cdb[13]
> + * and the device silently ignores the write. ene_write() therefore mirrors
> + * scsi_execute_cmd() on top of scsi_alloc_request() and forces cmd_len = 16
> + * (what SG_IO does from userspace).
> + *
> + * Attach manually until a notifier lands:
> + * echo asus_aura > /sys/block/sdX/device/dh_state
> + */
> +
> +#include <linux/module.h>
> +#include <linux/bits.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/leds.h>
> +#include <linux/led-class-multicolor.h>
> +#include <linux/blk_types.h>
> +#include <linux/blkdev.h>
> +#include <linux/blk-mq.h>
> +#include <linux/workqueue.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_dh.h>

Alphabetical.

> +#define ARION_INQ_VENDOR	"ROG"
> +#define ARION_INQ_MODEL		"ESD-S1C"
> +
> +#define ENE_OPCODE		0xec
> +#define ENE_REG_MODE		0x8021	/* AuraMode value: Static=1, Breathe=2, ... */
> +#define ENE_REG_APPLY		0x80a0
> +#define ENE_REG_COLORS		0x8160	/* + 3*led, 3 bytes per LED, order R,B,G */
> +#define ENE_REG_COLORS_DIRECT	0x8100	/* + 3*led, same layout */

Not sure these comments make things any clearer?

> +#define ENE_APPLY		0x01
> +#define ENE_SAVE		0xaa
> +#define ENE_MODE_STATIC		1
> +#define ENE_CDB_LEN		16
> +#define ENE_RGB_LEN		3
> +#define ENE_TIMEOUT		(10 * HZ)

Isn't 10s a lifetime?

> +
> +/*
> + * Verified on hardware: the enclosure has 4 independently settable LEDs.
> + * (The colour table reserves 16 slots; only the first 4 drive anything.)
> + */

Do we really need to know about the trial and error during development?

> +#define ARION_NUM_LEDS		4
> +
> +struct asus_aura_led {
> +	struct asus_aura_zone	*zone;

Is 'zone' SCSI terminology?

> +	int			index;
> +	struct mc_subled	subled[3];
> +	u8			rgb[ENE_RGB_LEN];
> +};
> +
> +struct asus_aura_zone {
> +	struct scsi_device	*sdev;
> +	struct asus_aura_led	leds[ARION_NUM_LEDS];
> +	spinlock_t		lock;	/* protects dirty and cached colours */
> +	u8			dirty;	/* bit i: led i needs a colour write */

What does dirty even mean in this context?  I suggest the nomenclature
needs improvement.

If you make this an LED-level attribute, you can remove the faux
LED indexing.

> +	struct work_struct	work;
> +};
> +
> +static void ene_build_cdb(u8 *cdb, u16 reg, u8 arg_count)
> +{
> +	memset(cdb, 0, ENE_CDB_LEN);
> +	cdb[0] = ENE_OPCODE;

Would defining these offsets make sense?

Nicer to read if they have a name.

> +	cdb[1] = 'A';
> +	cdb[2] = 'S';
> +	cdb[3] = (reg >> 8) & 0xff;
> +	cdb[4] = reg & 0xff;
> +	cdb[13] = arg_count;
> +}
> +
> +/*
> + * scsi_execute_cmd() with cmd_len forced to 16. scsi_alloc_request()
> + * initializes the parts of the scsi_cmnd a passthrough needs (zeroed
> + * cmnd, cmd_len = MAX_COMMAND_SIZE, sense_len, rcu head, retries);
> + * a raw blk_mq_alloc_request() does none of that.

And you're telling us this because?

Was there a decision based off of this?  Please elaborate.

> + */
> +static int ene_write(struct scsi_device *sdev, u16 reg,
> +		     const void *data, u8 arg_count)

Data is a terrible variable name.

It's also odd that we're passing back read-data in a write() function!

> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	u8 cdb[ENE_CDB_LEN];
> +	int ret;
> +
> +	ene_build_cdb(cdb, reg, arg_count);
> +
> +	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(rq))
> +		return PTR_ERR(rq);
> +
> +	if (arg_count) {

When is this not true?

> +		ret = blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->cmd_len = ENE_CDB_LEN;
> +	memcpy(scmd->cmnd, cdb, ENE_CDB_LEN);
> +	scmd->allowed = 1;
> +	rq->timeout = ENE_TIMEOUT;
> +	rq->rq_flags |= RQF_QUIET;
> +
> +	blk_execute_rq(rq, true);
> +	ret = scmd->result;

I have no idea what any of this means.  I'd need a SCSI person to help here.

> +out:
> +	blk_mq_free_request(rq);
> +	return ret;
> +}
> +
> +/*
> + * Sleepable: runs on the system workqueue. One ENE sequence for every LED
> + * marked in the dirty mask. The mask and colours are snapshotted under the
> + * zone lock: asus_aura_set() may run concurrently on another CPU, and the
> + * lock keeps a colour write from being reordered after its dirty bit on
> + * weakly ordered architectures. A colour cached while this runs requeues
> + * the work and is picked up by the next sequence.
> + */
> +static void asus_aura_zone_work(struct work_struct *work)
> +{
> +	struct asus_aura_zone *zone =
> +		container_of(work, struct asus_aura_zone, work);
> +	struct scsi_device *sdev = zone->sdev;
> +	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
> +	u8 apply = ENE_APPLY;
> +	u8 save = ENE_SAVE;
> +	u8 mode = ENE_MODE_STATIC;
> +	unsigned long flags;
> +	u8 pending;
> +	int i, ret;
> +
> +	spin_lock_irqsave(&zone->lock, flags);
> +	pending = zone->dirty;
> +	zone->dirty = 0;
> +	for (i = 0; i < ARION_NUM_LEDS; i++)
> +		memcpy(rgb[i], zone->leds[i].rgb, ENE_RGB_LEN);
> +	spin_unlock_irqrestore(&zone->lock, flags);
> +
> +	/*
> +	 * schedule_work() while this function runs requeues it, and the
> +	 * pending colour may already have been consumed above; the requeued
> +	 * run then has nothing to do. Return before touching the device:
> +	 * SAVE writes its flash.
> +	 */
> +	if (!pending)
> +		return;

All of the above is pointless if (zone->dirty == 0), so why not move
this check to the top and skip all of it?

> +
> +	if (!scsi_device_online(sdev))
> +		return;
> +
> +	/* Mode first: without it the device ignores the whole sequence. */
> +	ret = ene_write(sdev, ENE_REG_MODE, &mode, 1);

Are we sure it is safe to pass stack variables (like 'mode', 'apply',
'save', and 'rgb') to 'blk_rq_map_kern()'?  Stack memory is not DMA-safe
and will cause issues with VMAP_STACK.  Should we allocate a DMA-safe
bounce buffer in 'struct asus_aura_zone' instead?

> +	if (ret)
> +		goto err;
> +
> +	for (i = 0; i < ARION_NUM_LEDS; i++) {

for (int leds = 0; ...

> +		if (!(pending & BIT(i)))

zone->leds[led]->pending ?

> +			continue;
> +
> +		ret = ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
> +				rgb[i], ENE_RGB_LEN);

Use 100-chars to unwrap some of these.

> +		if (ret)
> +			goto err;
> +
> +		/*
> +		 * Cover the DIRECT colour set too; some firmware revisions
> +		 * pull from 0x8100 instead of 0x8160.
> +		 */
> +		ret = ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
> +				rgb[i], ENE_RGB_LEN);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	ret = ene_write(sdev, ENE_REG_APPLY, &apply, 1);

Are these variables even used?

> +	if (ret)
> +		goto err;
> +
> +	/*
> +	 * The change only takes effect after SAVE (0xaa). NOTE: saving on
> +	 * every brightness change writes flash each time; revisit for wear
> +	 * once confirmed.
> +	 */
> +	ret = ene_write(sdev, ENE_REG_APPLY, &save, 1);
> +	if (ret)
> +		goto err;
> +
> +	return;
> +err:
> +	dev_err(&sdev->sdev_gendev,
> +		"asus_aura: colour update failed: %d\n", ret);

Shouldn't we be telling the caller than there was an error?

> +}
> +
> +/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI. */
> +static void asus_aura_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)

Un-wrap.

> +{
> +	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
> +	struct asus_aura_led *led =
> +		container_of(mc, struct asus_aura_led, mc_cdev);

Un-wrap.

Etc.

> +	struct asus_aura_zone *zone = led->zone;
> +	unsigned long flags;
> +
> +	/*
> +	 * led_mc_calc_color_components() writes the shared subled_info
> +	 * array. The LED core serializes sysfs stores with led_access,
> +	 * but trigger events call led_set_brightness() without it, so
> +	 * computing and copying the components under the same lock keeps
> +	 * a trigger-driven update and a sysfs store from reading a mix of
> +	 * each other's colours.
> +	 */
> +	spin_lock_irqsave(&zone->lock, flags);
> +	led_mc_calc_color_components(mc, brightness);
> +	/* ENE colour register byte order is R, B, G. */
> +	led->rgb[0] = led->subled[0].brightness;
> +	led->rgb[1] = led->subled[2].brightness;
> +	led->rgb[2] = led->subled[1].brightness;
> +	zone->dirty |= BIT(led->index);
> +	spin_unlock_irqrestore(&zone->lock, flags);

This is all very claustrophobic.  Can you space some of these out in groups?

Other places too.  Nicely spaced out code is easier to parse.

> +
> +	schedule_work(&zone->work);
> +}
> +
> +static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
> +{
> +	struct asus_aura_led *led = &zone->leds[index];
> +	struct led_classdev *cdev = &led->mc_cdev.led_cdev;
> +	char hctl[32];
> +	int ret;
> +
> +	led->zone = zone;
> +	led->index = index;
> +
> +	led->subled[0].color_index = LED_COLOR_ID_RED;
> +	led->subled[1].color_index = LED_COLOR_ID_GREEN;
> +	led->subled[2].color_index = LED_COLOR_ID_BLUE;
> +	led->mc_cdev.num_colors = 3;
> +	led->mc_cdev.subled_info = led->subled;
> +
> +	/*
> +	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
> +	 * host, so the names stay unique when more than one is connected.
> +	 * With a static name the LED core would register the second
> +	 * enclosure's LEDs under renamed nodes (asus-arion::led-0_1),
> +	 * which is the wrong device identity. The names are per-attachment,
> +	 * like sd X letters, and userspace is expected to enumerate.
> +	 *
> +	 * dev_name() renders the sdev as H:C:T:L; the extra colons would
> +	 * break the devicename:color:function scheme userspace parses LED
> +	 * class names with, so they are flattened to dashes. The color
> +	 * section stays empty (these are multicolor LEDs, the palette is
> +	 * enumerated via multi_intensity), and the four identical zones
> +	 * get the function name with a "-N" ordinal, like the
> +	 * Documentation/leds/leds-class.rst naming section asks for.
> +	 */
> +	strscpy(hctl, dev_name(&zone->sdev->sdev_gendev), sizeof(hctl));
> +	strreplace(hctl, ':', '-');
> +	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s::led-%d", hctl, index);
> +	if (!cdev->name)
> +		return -ENOMEM;
> +	cdev->max_brightness = 255;
> +	cdev->brightness_set = asus_aura_set;
> +
> +	led_mc_calc_color_components(&led->mc_cdev, cdev->brightness);
> +
> +	/*
> +	 * Register with NULL parent: parenting the LED to the sdev takes a
> +	 * device reference, which blocks the sdev's final release on unplug,
> +	 * which is what calls scsi_dh_release_device() -> our .detach() that
> +	 * unregisters the LEDs. That reference cycle leaked the LED nodes and
> +	 * the module refcount on every hot-unplug.
> +	 */
> +	ret = led_classdev_multicolor_register(NULL, &led->mc_cdev);
> +	if (ret)
> +		kfree(cdev->name);
> +	return ret;
> +}
> +
> +/*
> + * Unregister the LED devices before cancelling the work: unregistering
> + * removes the sysfs attributes, so no new brightness_set can schedule the
> + * zone work afterwards, and it waits for in-flight sysfs callbacks.
> + * Cancelling first would leave a window where a brightness write requeues
> + * the work after cancel_work_sync() returned, and the work would then run
> + * on freed memory.
> + */
> +static void asus_aura_release(struct asus_aura_zone *zone, int num_leds)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_leds; i++)
> +		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);
> +	cancel_work_sync(&zone->work);
> +	for (i = 0; i < num_leds; i++)
> +		kfree(zone->leds[i].mc_cdev.led_cdev.name);
> +	kfree(zone);
> +}
> +
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone;
> +	int i, ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone = kzalloc_obj(*zone, GFP_KERNEL);
> +	if (!zone)
> +		return SCSI_DH_NOMEM;
> +	zone->sdev = sdev;
> +	spin_lock_init(&zone->lock);
> +	INIT_WORK(&zone->work, asus_aura_zone_work);
> +
> +	for (i = 0; i < ARION_NUM_LEDS; i++) {
> +		ret = asus_aura_register_led(zone, i);
> +		if (ret) {
> +			asus_aura_release(zone, i);

Shouldn't asus_aura_register_led unwind itself on failure?

> +			return SCSI_DH_NOMEM;
> +		}
> +	}
> +
> +	sdev->handler_data = zone;
> +	return SCSI_DH_OK;
> +}
> +
> +static void asus_aura_detach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone = sdev->handler_data;
> +
> +	if (!zone)
> +		return;
> +	asus_aura_release(zone, ARION_NUM_LEDS);
> +	sdev->handler_data = NULL;
> +}
> +
> +static struct scsi_device_handler asus_aura_dh = {
> +	.name	= "asus_aura",
> +	.module	= THIS_MODULE,

Are you sure this isn't handled for you by the subsystem?

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
> +MODULE_DESCRIPTION("ASUS Aura RGB over SCSI for ROG NVMe enclosures (per-LED)");
> +MODULE_AUTHOR("Liang Haowen");
> +MODULE_LICENSE("GPL");
> -- 
> 2.55.0
> 
> 

-- 
Lee Jones
