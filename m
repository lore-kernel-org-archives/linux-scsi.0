Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B84AF674
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 12:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560935; cv=none; b=N+eeG4DIPxK9bTKcF68W6Ic0e6QmaogFgJ2T4xTAZS8bmqG8tq/i+srLEKwWBaI3bOP3s7xv3UCq/YJPWusqZquiaS5K9GFvpFMWAo37KBWVrTIAP4hMAhJ0TsN2M3QsV6/F6LEyotaa+QgWB4PFaZP2D7hnYFVoGIcg7Xe4hcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560935; c=relaxed/simple;
	bh=G+t7Uu/yUnSdTQTwFBTWsgGXOuI33pFo4nrx0Y9g47w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=UvCbD/k925Ua+1nLhHrYvSt2lWWb5gBFMd8Vbd+yOPvyHVZVIqYsDZSfYiSDTu3iQOk0vEXCV316yejlpR8VNWINzTyWi9yWGdqP1t8zRqy1WINFTUogqyP79r1LADKHzhfkkAhpBVyM+DWTPTPoyiNW9CPAhp2lYh0Sug/C4OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XnVqIT0s; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnVqIT0s"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a2ffef2so429253b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 05:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789560931; x=1790165731; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G6KPoItI+unFrqZuA69kOtUW/E2I8iZteEH2M0b66eU=;
        b=XnVqIT0ssLxFwnP47E+56HFP+0ENnnX6J4cIhJcjRBAzoah78pFb4yoYk0Wqe9LD21
         JNmczE8FUuhIKylt+zNqK/mPR5VLyfa4sSXNJGk/xacEifKVsb/31Ivquh7rGIlO2O6j
         Ji6xy7r2qmVo7OO2adcP0m6d6f0SRIre1Liv7HQm7Zar7I/1u2X9KHwuzkracTMUaBMa
         PTWyR7kBTgB13bVdisMtHgMWewtEGa606hsmeWc7S3u1MsiwpgJyEDRaF58qskS7dUkA
         GsDCUybkuJz0ZiULje+AGGNB35qwU0d6NGm26zcnsXm0tXn5r3oDk719P5Z83fn7lhz2
         Q1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789560931; x=1790165731;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G6KPoItI+unFrqZuA69kOtUW/E2I8iZteEH2M0b66eU=;
        b=OozlsMff2VCbY1isf8xIzYjiR1PiNwYIs5kFYV7ddj/ty6m+oDT0PH/csKBlTM/ddB
         Vqb3hCNoQ9aMv9R6DBV4luGOSnrwQERqBxJYEkP6wNR300+cMbGm3h1kT7zijhF3dwi2
         34vKZFkKuXsT/PYbX+KVD1S7f+lwbThWgNz4fjPMvWwTYd3frcgt+9FZFnA+hbV68rZR
         8MsswccaXfgnBHx1bLvW1nmRUz6sm6ZrQQaC8cSpUNsxOXYTkOurACPSBp7M6cA70OlA
         DeDa6PGvyQuvvp0xFHoENbONSP9l5MxA8b6wAf2jW21h4WkD6VJR4b1308roWHekxwRh
         Cs5w==
X-Forwarded-Encrypted: i=1; AKwUvBz9Nt26VpWKTE+Ucl4sZMiOxKE0436ZX8CN/zBlMLjOUq/drQbm3IU1RUSicyl/zN9dJsUcUP4RQPnI@vger.kernel.org
X-Gm-Message-State: AFuF++k6WSWw9Hfh2IdtWWSYqqP6vuBGtOOyj4XCSG0vYLO2gE6lMa/m
	MS2XsGo4R9noPD9y446Xw5T8uLPH1BmZWORbGS0e0e6tVH6/sBCytwvF71GaQMGwQl51CA==
X-Gm-Gg: AYBFou1ujZvUxOmLf6NXdMoS2VUJWnsAp6rOSwwzkJWr/5ySMF7lMCjXqTI/KIdD1hq
	NRDqJXR4qh55/BzvETWheMEWLv25QNqipgQ2brJRZO/+c0wGQ+b5wyDlmeaiKJzsqsYF3cyMaej
	hBIG+zKTYIJA/q5YkKLyZcaxFpgp/dsxRsWp5v60N0FrDoLcnR5RCtpbpVybbR2uhMh1CrNxMeG
	5MsB7ZQRuu4WS8H/Z2av0WvGe4Gzu9JtxCblWpTBzJA27UZ5h9BKj6a3RoreV4nGWsLImLjRJyJ
	MgrCmKm115uLdLjcuwWfijZ4vta2QouLVwJ8kcoTXPvsogqiTRzx68DCiu7bA91der4Ycf3DNRp
	zds7GgbLL7bFwtEi3BIjjg1NwZ+b22qE0N+tCgbrG5X9uRZoKGZy4M1pFdLDJv0mbxkIbgI6sr6
	scPcabDk8Opx0fBTig6y4O6I6VaiFfaQ6yOcnVqC2Sfoxvpj/tD+V0zA+qtwAT4LgFcXRAeA==
X-Received: by 2002:a05:6808:3502:b0:4c1:5471:3f56 with SMTP id 5614622812f47-4ca4b96b76bmr3031525b6e.26.1789560931002;
        Wed, 16 Sep 2026 05:15:31 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab8ae01sm1512489a12.18.2026.09.16.05.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 05:15:30 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH RFC v5 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Wed, 16 Sep 2026 12:15:27 -0000
Message-Id: <202609162015.RFCv5-1.lhw@gmail.com>
In-Reply-To: <202609162015.RFCv5-0.lhw@gmail.com>
References: <202609162015.RFCv5-0.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

From: Liang Haowen <nbg2974@gmail.com>
Date: Wed, 16 Sep 2026 19:05:00 +0800
Subject: [PATCH RFC v5] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for
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
dirty mask under a spinlock; led_mc_calc_color_components() runs under
that lock too, because it writes the shared subled_info array and
trigger events call led_set_brightness() without the led_access lock
that serializes sysfs stores. A single work item per zone then
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
 drivers/leds/leds-asus-aura-scsi.c | 389 +++++++++++++++++++++++++++++
 1 file changed, 389 insertions(+)
 create mode 100644 drivers/leds/leds-asus-aura-scsi.c

diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
new file mode 100644
index 0000000..a1e31dc
--- /dev/null
+++ b/drivers/leds/leds-asus-aura-scsi.c
@@ -0,0 +1,389 @@
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
+	/*
+	 * led_mc_calc_color_components() writes the shared subled_info
+	 * array. The LED core serializes sysfs stores with led_access,
+	 * but trigger events call led_set_brightness() without it, so
+	 * computing and copying the components under the same lock keeps
+	 * a trigger-driven update and a sysfs store from reading a mix of
+	 * each other's colours.
+	 */
+	spin_lock_irqsave(&zone->lock, flags);
+	led_mc_calc_color_components(mc, brightness);
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

