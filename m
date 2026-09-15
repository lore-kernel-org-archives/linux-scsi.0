Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD4A38C438
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476549; cv=none; b=pv3fDBIXlYJUdAwxLFOqwcy1CejsWmQd2IGaMc3kGw4LxQJ9EgyXn78AgtuDBRhMVixZaYQ94yZCbZ5oJjaQnusMRhAs2hWP9VYD0UHn+kX0WpzZiExWZjMKxsKbnAat08rq7HdNXq/Tyi22vuNCJ750Xojd6yLQN2MalIzvLNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476549; c=relaxed/simple;
	bh=TvlnTHaV/RIyJr65Yj8GpSoCOuiDShLNuh0hEgoHLm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=bNQcNTRKkQh8pYIey94ned51lq2g7SOzbXU3dmTp2rVwy8cOUvv1zucL23EnjSEOIH4prHAoss1F0RY4u01FI7a3r3WLUxInodfJ7CcFBQJL4OB17s9pz3fWwV30PCeiXKWNnoyMaw2SrsepNfXTJT4W+V8FvzKwodeokmXaTDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5CqMf3D; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5CqMf3D"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91c22d27dso17562295ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476547; x=1790081347; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/gt9ytua6+VNnEOvbXr4XTmgP7XS+BGTyBLkMGgxhzQ=;
        b=C5CqMf3DIDkFFsnUIz7hhlwafHMvk1KxQ+JwmjQA+WNhiiWcc5m/8Di0lpcQ3O4ZeZ
         uWGVqfHxCaPvBF2oS+yjDPxz3u58Z0KC06uJW2Lt9AnVwegEAZp9c9McsK0pZbfKsbCT
         Axr0WFy/Som3DxSTJaBxpjnXTZYwOd8Jnsshi4sEyn6SnBmti+9WHOQ3LpnTyVEK1clf
         7sRigKQbcl6HD/6YQI2a4odwwPsK90GhWj0pbJcGLQWXCVa6+ifPNUG46yw+ErbQVzxQ
         7otH0JVrw76OiGq8K5YRe4t86WXbVhekB7tJnc11rbi4NOkL5oe+zOppzAmn2RZnnbT4
         66jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476547; x=1790081347;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/gt9ytua6+VNnEOvbXr4XTmgP7XS+BGTyBLkMGgxhzQ=;
        b=tHp0NCBOPlr9gIrnxlq5JQn0BJ7fMe+wIXbwt/xti1dO3zUOhTJbQnL40A3Y6QQ+mP
         PAodKaeGqTF6N9bvrltb6/GeqoxozYGj7wKhj4/tx+oINbIWzbg1IMwh3COGvuwj+dDb
         8sOhH+rS0QjwqejclGpHYgJHiLZfwOuIwAFFJ5kkUnlDH3vuMsCp8kyf4FoIeYP5OaVl
         poiKsFfIMR8bGrkM7ruwvoSSPItAM2scjFLW0KDM2tF+T6pZ1Q4w0AF5rJ1ghVjiO7SK
         VgTpT4vQwC17L66r421MlZkXapVzx6JyR2qtUZJVv6DumRo8fK1cxykhZbWzQlU0Li+X
         o9mQ==
X-Forwarded-Encrypted: i=1; AKwUvByJD9MRNe42sWmEzwFZ8dgcLtXncyaaDO3lF94VVU5HRKeOIgCC3x8NModZr2vcp7VQahlgV7tSKf27@vger.kernel.org
X-Gm-Message-State: AFuF++kb1mq51TTdoTCFsdd6tD+9h068lAdvxkkveZmS4LXOsMfRFW0G
	dgSqeNGnc65TdhJEeOt8KduDLFUpa1y+M6bpXDJGLXSDuEWk3viOMdd3
X-Gm-Gg: AYBFou3bAhqfSvmA7BydH+qahhFA2EP9vFvCQ3+XasnVXd1qd+JxwcqsSIuq7agWolO
	mpEeEnn/E3egUhs8Db2dyj+jANIJ2h7I7RNEIHK5y0z2f3vtV9QDXoUm5VvThTIk7wQ0g5SvAnL
	CtnE/HU9QQD3XtBa+ld/RQFvHm+hlJjUBxctUE4iGQepmewdkUNGTM53y5t66x52zmsSY7ia3aQ
	FgRCp6EZJ7IF4ti3tjAwL1cRfUu1CstlWH8EIO84MCQKGVdPc7q7kK2HMV+wCOEDndNVY0oQGMk
	pUd9dfhXyo4FVXI4qSJ1zEmI6wxKDvSH966OBks+taswxsTfD33ONTEPB/miUMg7glq7aKi8xX9
	Q7LgMKVEBG8TgqQIJ2460pnMyXmKHttGG/C9t0LOAKGZDsgtBZU/C2ID9D7voTChtxabHHIQUV1
	/yOSSUc5yT/Fxe6IvVoOgITqzCKMVEJO9W2cr7gmQG2LEoiN1KEoewqY3rR3Wy+UK5SdKP5Q==
X-Received: by 2002:a17:902:d4c5:b0:2d8:d4d3:3fc0 with SMTP id d9443c01a7336-2dd6c7d8c87mr145548445ad.20.1789476546269;
        Tue, 15 Sep 2026 05:49:06 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd48ae3cacsm52866095ad.26.2026.09.15.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 05:49:05 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH RFC v4 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Tue, 15 Sep 2026 12:49:01 -0000
Message-Id: <202609152112.RFCv4-1.lhw@gmail.com>
In-Reply-To: <202609152112.RFCv4-0.lhw@gmail.com>
References: <202609152112.RFCv4-0.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

From: Liang Haowen <nbg2974@gmail.com>
Date: Tue, 15 Sep 2026 20:18:15 +0800
Subject: [PATCH RFC v4] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for
 ROG NVMe enclosures

ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
plain USB mass-storage devices with no HID interface: the Aura LEDs
hang off an ENE controller driven by vendor SCSI commands on the same
LUN as the disk. The enclosure has 4 independently addressable LEDs,
verified on hardware.

Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
disk) and exposes each LED as a multicolor LED class device,
/sys/class/leds/asus-arion-0-0-0-0:led0 through led3. The
H:C:T:L part of the sdev name keeps the names unique when more than
one enclosure is connected, with its colons flattened to dashes so the
name keeps a single separator and follows the devicename:color:function
convention userspace parses LED class names with.

Protocol: a 16-byte vendor CDB (opcode 0xec, 'A' 'S' signature,
register index, argument count in cdb[13]). MODE 0x8021 (Static) must
be written first in every sequence or the device ignores it; colours
go to 0x8160 + 3 * led and 0x8100 + 3 * led (3 bytes, order R, B, G;
both tables are written because firmware revisions pull from one or
the other); APPLY 0x80a0 takes 0x01 to apply and 0xaa to save.

The CDB cannot go through scsi_execute_cmd(): it sizes the command
via scsi_command_size(opcode), which maps vendor opcode 0xec to
10 bytes, so cdb[13] is dropped and the device silently ignores the
write (GOOD status, no error). The request is built with
scsi_alloc_request() instead, which initializes the scsi_cmnd parts a
passthrough needs (command buffer, lengths, rcu head), with cmd_len
forced to 16, mirroring what SG_IO does from userspace.

brightness_set only caches the colour and marks the LED in a per-zone
dirty mask under a spinlock; a single work item per zone then
snapshots the mask and colours and runs one ENE sequence for all
pending LEDs (MODE, colour slots, APPLY, SAVE). Funneling every
update through one work item keeps the sequences from interleaving
between concurrent LED updates and batches multi-LED updates into a
single APPLY/SAVE. A re-queued run with nothing pending returns
before touching the device, so it cannot wear the flash with a
pointless SAVE, and the lock keeps a colour write from being
reordered after its dirty bit on weakly ordered architectures.

This is the monolithic out-of-tree version as verified on hardware;
the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
into a SCSI transport helper and a shared ASUS Aura LED interface.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
---
 drivers/leds/leds-asus-aura-scsi.c | 382 +++++++++++++++++++++++++++++
 1 file changed, 382 insertions(+)
 create mode 100644 drivers/leds/leds-asus-aura-scsi.c

diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
new file mode 100644
index 0000000..089cc3d
--- /dev/null
+++ b/drivers/leds/leds-asus-aura-scsi.c
@@ -0,0 +1,382 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * ASUS Aura RGB over SCSI for ROG external NVMe enclosures
+ * (e.g. ROG STRIX Arion, USB 0b05:1932).
+ *
+ * USB mass-storage device, no HID; the ENE LED controller is driven via
+ * vendor SCSI commands. Matched by INQUIRY (vendor "ROG", model "ESD-S1C"),
+ * does NOT claim the sdev (sd keeps owning the disk).
+ *
+ * The Arion exposes 4 independently addressable LEDs (verified on hardware):
+ * each is a multicolor LED class device (asus-arion-<H-C-T-L>:led0..led3,
+ * unique per enclosure). A colour change writes that LED's slot only:
+ * EFFECT 0x8160 + 3*led, DIRECT 0x8100 + 3*led (3 bytes, byte order R, B, G),
+ * then APPLY (0x01) and SAVE (0xaa). MODE (0x8021 = Static) is written first
+ * in every sequence; skipping it makes the device ignore the whole sequence.
+ *
+ * Scheduling: brightness_set (LED core fast path) caches the colour and
+ * marks the LED in a per-zone dirty mask under a spinlock; a single work
+ * item per zone snapshots the mask and colours, then runs one ENE
+ * sequence for all pending LEDs (MODE once, colour slots, APPLY, SAVE).
+ * Funneling every update through that one work item also serializes the
+ * sequences: the MODE/colour/APPLY/SAVE chain must never interleave
+ * between concurrent LED updates. The snapshot makes re-queued runs with
+ * nothing left to do return before touching the device, so a re-queue
+ * cannot wear the flash with a pointless SAVE, and the lock keeps a
+ * colour write from being reordered after its dirty bit on weakly
+ * ordered architectures.
+ *
+ * CDB length: scsi_execute_cmd() sizes the CDB via COMMAND_SIZE(opcode),
+ * which maps vendor opcode 0xec to 10 bytes. The ENE protocol uses a 16-byte
+ * CDB with the data length in cdb[13], so scsi_execute_cmd() drops cdb[13]
+ * and the device silently ignores the write. ene_write() therefore mirrors
+ * scsi_execute_cmd() on top of scsi_alloc_request() and forces cmd_len = 16
+ * (what SG_IO does from userspace).
+ *
+ * Attach manually until a notifier lands:
+ * echo asus_aura > /sys/block/sdX/device/dh_state
+ */
+
+#include <linux/module.h>
+#include <linux/bits.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/leds.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+#include <linux/blk-mq.h>
+#include <linux/workqueue.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dh.h>
+
+#define ARION_INQ_VENDOR	"ROG"
+#define ARION_INQ_MODEL		"ESD-S1C"
+
+#define ENE_OPCODE		0xec
+#define ENE_REG_MODE		0x8021	/* AuraMode value: Static=1, Breathe=2, ... */
+#define ENE_REG_APPLY		0x80a0
+#define ENE_REG_COLORS		0x8160	/* + 3*led, 3 bytes per LED, order R,B,G */
+#define ENE_REG_COLORS_DIRECT	0x8100	/* + 3*led, same layout */
+#define ENE_APPLY		0x01
+#define ENE_SAVE		0xaa
+#define ENE_MODE_STATIC		1
+#define ENE_CDB_LEN		16
+#define ENE_RGB_LEN		3
+#define ENE_TIMEOUT		(10 * HZ)
+
+/*
+ * Verified on hardware: the enclosure has 4 independently settable LEDs.
+ * (The colour table reserves 16 slots; only the first 4 drive anything.)
+ */
+#define ARION_NUM_LEDS		4
+
+struct asus_aura_led {
+	struct asus_aura_zone	*zone;
+	int			index;
+	struct led_classdev_mc	mc_cdev;
+	struct mc_subled	subled[3];
+	u8			rgb[ENE_RGB_LEN];
+};
+
+struct asus_aura_zone {
+	struct scsi_device	*sdev;
+	struct asus_aura_led	leds[ARION_NUM_LEDS];
+	spinlock_t		lock;	/* protects dirty and cached colours */
+	u8			dirty;	/* bit i: led i needs a colour write */
+	struct work_struct	work;
+};
+
+static void ene_build_cdb(u8 *cdb, u16 reg, u8 arg_count)
+{
+	memset(cdb, 0, ENE_CDB_LEN);
+	cdb[0] = ENE_OPCODE;
+	cdb[1] = 'A';
+	cdb[2] = 'S';
+	cdb[3] = (reg >> 8) & 0xff;
+	cdb[4] = reg & 0xff;
+	cdb[13] = arg_count;
+}
+
+/*
+ * scsi_execute_cmd() with cmd_len forced to 16. scsi_alloc_request()
+ * initializes the parts of the scsi_cmnd a passthrough needs (zeroed
+ * cmnd, cmd_len = MAX_COMMAND_SIZE, sense_len, rcu head, retries);
+ * a raw blk_mq_alloc_request() does none of that.
+ */
+static int ene_write(struct scsi_device *sdev, u16 reg,
+		     const void *data, u8 arg_count)
+{
+	struct request *rq;
+	struct scsi_cmnd *scmd;
+	u8 cdb[ENE_CDB_LEN];
+	int ret;
+
+	ene_build_cdb(cdb, reg, arg_count);
+
+	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	if (arg_count) {
+		ret = blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
+		if (ret)
+			goto out;
+	}
+
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->cmd_len = ENE_CDB_LEN;
+	memcpy(scmd->cmnd, cdb, ENE_CDB_LEN);
+	scmd->allowed = 1;
+	rq->timeout = ENE_TIMEOUT;
+	rq->rq_flags |= RQF_QUIET;
+
+	blk_execute_rq(rq, true);
+	ret = scmd->result;
+out:
+	blk_mq_free_request(rq);
+	return ret;
+}
+
+/*
+ * Sleepable: runs on the system workqueue. One ENE sequence for every LED
+ * marked in the dirty mask. The mask and colours are snapshotted under the
+ * zone lock: asus_aura_set() may run concurrently on another CPU, and the
+ * lock keeps a colour write from being reordered after its dirty bit on
+ * weakly ordered architectures. A colour cached while this runs requeues
+ * the work and is picked up by the next sequence.
+ */
+static void asus_aura_zone_work(struct work_struct *work)
+{
+	struct asus_aura_zone *zone =
+		container_of(work, struct asus_aura_zone, work);
+	struct scsi_device *sdev = zone->sdev;
+	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
+	u8 apply = ENE_APPLY;
+	u8 save = ENE_SAVE;
+	u8 mode = ENE_MODE_STATIC;
+	unsigned long flags;
+	u8 pending;
+	int i, ret;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	pending = zone->dirty;
+	zone->dirty = 0;
+	for (i = 0; i < ARION_NUM_LEDS; i++)
+		memcpy(rgb[i], zone->leds[i].rgb, ENE_RGB_LEN);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	/*
+	 * schedule_work() while this function runs requeues it, and the
+	 * pending colour may already have been consumed above; the requeued
+	 * run then has nothing to do. Return before touching the device:
+	 * SAVE writes its flash.
+	 */
+	if (!pending)
+		return;
+
+	if (!scsi_device_online(sdev))
+		return;
+
+	/* Mode first: without it the device ignores the whole sequence. */
+	ret = ene_write(sdev, ENE_REG_MODE, &mode, 1);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < ARION_NUM_LEDS; i++) {
+		if (!(pending & BIT(i)))
+			continue;
+
+		ret = ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
+				rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+
+		/*
+		 * Cover the DIRECT colour set too; some firmware revisions
+		 * pull from 0x8100 instead of 0x8160.
+		 */
+		ret = ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
+				rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+	}
+
+	ret = ene_write(sdev, ENE_REG_APPLY, &apply, 1);
+	if (ret)
+		goto err;
+
+	/*
+	 * The change only takes effect after SAVE (0xaa). NOTE: saving on
+	 * every brightness change writes flash each time; revisit for wear
+	 * once confirmed.
+	 */
+	ret = ene_write(sdev, ENE_REG_APPLY, &save, 1);
+	if (ret)
+		goto err;
+
+	return;
+err:
+	dev_err(&sdev->sdev_gendev,
+		"asus_aura: colour update failed: %d\n", ret);
+}
+
+/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI. */
+static void asus_aura_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
+	struct asus_aura_led *led =
+		container_of(mc, struct asus_aura_led, mc_cdev);
+	struct asus_aura_zone *zone = led->zone;
+	unsigned long flags;
+
+	led_mc_calc_color_components(mc, brightness);
+
+	spin_lock_irqsave(&zone->lock, flags);
+	/* ENE colour register byte order is R, B, G. */
+	led->rgb[0] = led->subled[0].brightness;
+	led->rgb[1] = led->subled[2].brightness;
+	led->rgb[2] = led->subled[1].brightness;
+	zone->dirty |= BIT(led->index);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	schedule_work(&zone->work);
+}
+
+static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
+{
+	struct asus_aura_led *led = &zone->leds[index];
+	struct led_classdev *cdev = &led->mc_cdev.led_cdev;
+	char hctl[32];
+	int ret;
+
+	led->zone = zone;
+	led->index = index;
+
+	led->subled[0].color_index = LED_COLOR_ID_RED;
+	led->subled[1].color_index = LED_COLOR_ID_GREEN;
+	led->subled[2].color_index = LED_COLOR_ID_BLUE;
+	led->mc_cdev.num_colors = 3;
+	led->mc_cdev.subled_info = led->subled;
+
+	/*
+	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
+	 * host, so the names stay unique when more than one is connected.
+	 * With a static name the LED core would register the second
+	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
+	 * is the wrong device identity. The names are per-attachment, like
+	 * sd X letters, and userspace is expected to enumerate.
+	 *
+	 * dev_name() renders the sdev as H:C:T:L; the extra colons would
+	 * break the devicename:color:function scheme userspace parses LED
+	 * class names with, so they are flattened to dashes and the name
+	 * keeps exactly one separator.
+	 */
+	strscpy(hctl, dev_name(&zone->sdev->sdev_gendev), sizeof(hctl));
+	strreplace(hctl, ':', '-');
+	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s:led%d", hctl, index);
+	if (!cdev->name)
+		return -ENOMEM;
+	cdev->max_brightness = 255;
+	cdev->brightness_set = asus_aura_set;
+
+	led_mc_calc_color_components(&led->mc_cdev, cdev->brightness);
+
+	/*
+	 * Register with NULL parent: parenting the LED to the sdev takes a
+	 * device reference, which blocks the sdev's final release on unplug,
+	 * which is what calls scsi_dh_release_device() -> our .detach() that
+	 * unregisters the LEDs. That reference cycle leaked the LED nodes and
+	 * the module refcount on every hot-unplug.
+	 */
+	ret = led_classdev_multicolor_register(NULL, &led->mc_cdev);
+	if (ret)
+		kfree(cdev->name);
+	return ret;
+}
+
+/*
+ * Unregister the LED devices before cancelling the work: unregistering
+ * removes the sysfs attributes, so no new brightness_set can schedule the
+ * zone work afterwards, and it waits for in-flight sysfs callbacks.
+ * Cancelling first would leave a window where a brightness write requeues
+ * the work after cancel_work_sync() returned, and the work would then run
+ * on freed memory.
+ */
+static void asus_aura_release(struct asus_aura_zone *zone, int num_leds)
+{
+	int i;
+
+	for (i = 0; i < num_leds; i++)
+		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);
+	cancel_work_sync(&zone->work);
+	for (i = 0; i < num_leds; i++)
+		kfree(zone->leds[i].mc_cdev.led_cdev.name);
+	kfree(zone);
+}
+
+static int asus_aura_attach(struct scsi_device *sdev)
+{
+	struct asus_aura_zone *zone;
+	int i, ret;
+
+	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
+	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
+		return SCSI_DH_DEV_UNSUPP;
+
+	zone = kzalloc_obj(*zone, GFP_KERNEL);
+	if (!zone)
+		return SCSI_DH_NOMEM;
+	zone->sdev = sdev;
+	spin_lock_init(&zone->lock);
+	INIT_WORK(&zone->work, asus_aura_zone_work);
+
+	for (i = 0; i < ARION_NUM_LEDS; i++) {
+		ret = asus_aura_register_led(zone, i);
+		if (ret) {
+			asus_aura_release(zone, i);
+			return SCSI_DH_NOMEM;
+		}
+	}
+
+	sdev->handler_data = zone;
+	return SCSI_DH_OK;
+}
+
+static void asus_aura_detach(struct scsi_device *sdev)
+{
+	struct asus_aura_zone *zone = sdev->handler_data;
+
+	if (!zone)
+		return;
+	asus_aura_release(zone, ARION_NUM_LEDS);
+	sdev->handler_data = NULL;
+}
+
+static struct scsi_device_handler asus_aura_dh = {
+	.name	= "asus_aura",
+	.module	= THIS_MODULE,
+	.attach	= asus_aura_attach,
+	.detach	= asus_aura_detach,
+};
+
+static int __init asus_aura_init(void)
+{
+	return scsi_register_device_handler(&asus_aura_dh);
+}
+
+static void __exit asus_aura_exit(void)
+{
+	scsi_unregister_device_handler(&asus_aura_dh);
+}
+
+module_init(asus_aura_init);
+module_exit(asus_aura_exit);
+
+MODULE_DESCRIPTION("ASUS Aura RGB over SCSI for ROG NVMe enclosures (per-LED)");
+MODULE_AUTHOR("Liang Haowen");
+MODULE_LICENSE("GPL");
-- 
2.55.0

