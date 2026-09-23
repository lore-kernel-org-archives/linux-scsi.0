Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7CE4F93AA
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 12:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165935; cv=none; b=I4Rfhujr7dMpWlbBF5UB/MM1CfG2rbhMJjAi64ubzaUP1v0i8qEIElAlTJV5CNZVnmKGD1mZUMnRxh7uW34WQsGKr0cjc76ZTcG4R8CwQRVaLQ5sQdpEzKK/Bh7LBnjFgf+z7gtZlgaTYwhrRc1fsrp1Yh0A3TEBpvROchSzO8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165935; c=relaxed/simple;
	bh=3XGjLvCXI58pE2GkmSSj/qJFPrLP4o/RZ3ZKkKZ7d5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJGP1sL1l359R4G/bygrq3lbnFKUM8pa5pEms6bkBUouru0ijD+w/3OK9kcwCXhmngdKYOirHcYGmsWgy0viK5mL27wgLZjNMohqD85jDf6JuW/dETjA8FVG+c1Lqsit+f1jUtWnv8ZxQVE9XAa3D2fMN5MXhJOoaGTDHz9P+dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eL7InZ5i; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eL7InZ5i"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd78e6eso319065a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 05:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790165933; x=1790770733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9cuWBhRzzxTiwhwxFxvBviW289+8Lt8E5TxpE0opblY=;
        b=eL7InZ5i3lpop4Fj7rq4WAlOu1awJOu0zOIXFURPRy4PoOTpAbj8zg3InYwOcE9Ww9
         Dd78QHiXhjtny71XJbk4s+34IW7WrhR/L6ey8GLTTLziiAv06ozB44g/C+UlVJebQW/x
         ti8dPtuZ8wjWfCGdtqoTf1vHQ6upHeLkmG2KZM44OksdL/ExUlIcpJ95a/bS2jJ9e4nV
         tSlbFuMXhgjdWlX3PepsNdshpX3Dgo4UExfb8lptBE+6w/1uOw/5KlqHFZFdwmSHeGO1
         e4crMvnORzEW6xCA3NH/4ai3RZCUt/Jk5N2IxfwBuebYunZv4ElhJ6ZhNikjcb9XOO5B
         g7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790165933; x=1790770733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9cuWBhRzzxTiwhwxFxvBviW289+8Lt8E5TxpE0opblY=;
        b=qVLDeaVs8G0VzHWy04Xm10PLYRYOgmUzZsI5hlwxEDCuYZMzDk/3RcaESxnEswdnHR
         s0QVeLOpclPvdQoIdsjdnrR3eGpvPbdmBJ+8ZOrLmD95yIDMW2JHT58paBOqH02StCSB
         ywNM7/mK7jYepaa0UXRbMRSxvD1fWFEila2HZeqSZpwoYxi+mbHUSal6cY8Trn6erinO
         9KTaS6ga0mb7PnGUUGRd9Y/ovlMF6WSGqmolNXOtYGn7VUddSIOX/IwZ2PJp4mB4oWPa
         Zh3Yd6qNBQmtvurnaAmkp6LEesFnn/A29JDHwsVv5S/vdYV8zG/gmcyJPIS0n5AxDH4Q
         w2WQ==
X-Forwarded-Encrypted: i=1; AKwUvByr/SFPtS8iIWKd3kFzHSejxJO73dgQPbf+XN7Mv8+holVbWcvPZ+amizHRv9Luv8HIkYdBbgytoJei@vger.kernel.org
X-Gm-Message-State: AFuF++nDxT2NHLjY6j1Y8ITidqS9m4VdSf+6GIMhsuIMtzKunBxR7lYf
	SRi/naKUCTlkU4m1vEFKShSOiCXqv1umPLIqTssvsmSKeFlXy0d773Q3
X-Gm-Gg: AYBFou2hDK5MT0cp1ab4iRAEajqhOgyWn38673aRVWxwdWZZdvwCdQElTf5Ttoqa7ww
	wP0WGo769egCCzAZh0mlsFxYsJU8vUVaKRH0zXp33bPKokeFgpj0oZr9LDb7rWMatuyKyc1dMzk
	aIiuiQQoWh63emipIvn1F0Gdxf6MAUd7UceYm0a+1Kpeb4maPYZbEoprW3v2k15YIb4gxW1SXc9
	4FqPb07BDdQIA17wakisxyh/346ceVzYduH/loQz5aa8kt5UztF5v+ajSkpF3+6Ubo9lj558OXG
	9U0o44n2DZpfqYCcQWTbr5DOnKD8fp5kkKIZTtOBUmLpwUImZfGNuiAnY/rbbi4ahVGXXe0Rq7z
	HPbWdP0pLyHyX2yV6EmS20lamwI1KoQfGkJB7bWcfEwWhS1BudCHkAdSp+I5cZMQ/phe2hmPodb
	01m9YqaOf69r7wo/F3R5iG2zfS0VW1fNqUlQSMQILuxZFagTjW3Z7udzYe9E7tgamPFgsjlH5Yh
	PGEmA==
X-Received: by 2002:a17:90b:4408:b0:39e:3d38:7ef1 with SMTP id 98e67ed59e1d1-3a07e48cbbcmr1523302a91.10.1790165928221;
        Wed, 23 Sep 2026 05:18:48 -0700 (PDT)
Received: from ROGZephyrusG16Air ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dbc013fsm5867255a91.5.2026.09.23.05.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:18:47 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [RFC v8 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
Date: Wed, 23 Sep 2026 20:18:32 +0800
Message-ID: <20260923121832.2613187-2-nbg2974@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923121832.2613187-1-nbg2974@gmail.com>
References: <20260923121832.2613187-1-nbg2974@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
plain USB mass-storage devices with no HID interface: the Aura LEDs
hang off an ENE controller driven by vendor SCSI commands on the same
LUN as the disk. The enclosure has 4 independently addressable LEDs,
verified on hardware.

Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
disk) and exposes each LED as a multicolor LED class device,
/sys/class/leds/asus-arion-0-0-0-0::led-0 through led-3. The
H:C:T:L part of the sdev name keeps the names unique when more than
one enclosure is connected, with its colons flattened to dashes. The
color section stays empty, since multicolor LEDs enumerate their
palette via multi_intensity, and the four identical zones use the
function name with a "-N" ordinal, as the naming section in
Documentation/leds/leds-class.rst asks for.

Protocol: a 16-byte vendor CDB (opcode 0xec, 'A' 'S' signature,
BE16 register index, argument count in byte 13), modelled by
struct ene_cdb. MODE 0x8021 (Static) must be written first in every
sequence or the device ignores it; colours go to 0x8160 + 3 * led
and 0x8100 + 3 * led (3 bytes, wire order R, B, G; both tables are
written because firmware revisions pull from one or the other);
APPLY 0x80a0 takes 0x01 to apply and 0xaa to save.

The CDB cannot go through scsi_execute_cmd(): it sizes the command
via scsi_command_size(opcode), which maps vendor opcode 0xec to
10 bytes, so byte 13 is dropped and the device silently ignores the
write (GOOD status, no error). scsi_execute_cmd() also offers no way
to override the derived length. The request is therefore built with
scsi_alloc_request(), which initializes the scsi_cmnd parts a
passthrough needs, with cmd_len set to the CDB size, mirroring what
SG_IO does from userspace. A 5 s timeout and a single retry-less
quiet submission cover the register writes.

The write payload is copied into a per-device buffer before it is
mapped with blk_rq_map_kern(), so no stack memory is ever mapped for
DMA (VMAP_STACK).

brightness_set only caches the colour and marks the LED pending
under a spinlock; led_mc_calc_color_components() runs under that
lock too, because it writes the shared subled_info array and
trigger events call led_set_brightness() without the led_access lock
that serializes sysfs stores. A single work item per enclosure then
snapshots the pending LEDs and runs one ENE sequence for all of
them. Funneling every update through one work item keeps the
sequences from interleaving between concurrent LED updates and
batches multi-LED updates into a single APPLY/SAVE. A re-queued run
with nothing pending returns before touching the device, so it
cannot wear the flash with a pointless SAVE, and the lock keeps a
colour write from being reordered after its pending flag on weakly
ordered architectures.

This is the monolithic out-of-tree version as verified on hardware;
the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
into a SCSI transport helper and a shared ASUS Aura LED interface.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
---
 drivers/leds/rgb/leds-asus-aura-scsi.c | 388 +++++++++++++++++++++++++
 1 file changed, 388 insertions(+)
 create mode 100644 drivers/leds/rgb/leds-asus-aura-scsi.c

diff --git a/drivers/leds/rgb/leds-asus-aura-scsi.c b/drivers/leds/rgb/leds-asus-aura-scsi.c
new file mode 100644
index 0000000..eaba968
--- /dev/null
+++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * ASUS Aura RGB over SCSI for ROG external NVMe enclosures
+ * (e.g. ROG STRIX Arion, USB 0b05:1932).
+ *
+ * USB mass-storage device, no HID; the ENE LED controller is driven via
+ * vendor SCSI commands on the disk's LUN. Matched by INQUIRY (vendor
+ * "ROG", model "ESD-S1C"); the sdev is not claimed, sd keeps owning the
+ * disk. Attach manually until the SCSI side agrees on an in-tree hook:
+ * echo asus_aura > /sys/block/sdX/device/dh_state
+ *
+ * Each of the 4 LEDs is a multicolor LED class device,
+ * /sys/class/leds/asus-arion-<H-C-T-L>::led-0..led-3. A colour change
+ * writes only that LED's slots in the ENE colour tables, then applies
+ * and saves; MODE must precede every sequence or the device ignores
+ * it. The register layout is described by struct ene_cdb.
+ *
+ * brightness_set (LED core fast path) only caches the colour and marks
+ * the LED pending under a spinlock; a single work item per enclosure
+ * snapshots all pending LEDs and runs one ENE sequence for them. One
+ * work item also serializes the sequences against each other: the
+ * MODE/colour/APPLY/SAVE chain must never interleave between
+ * concurrent LED updates.
+ */
+
+#include <linux/bits.h>
+#include <linux/blk-mq.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dh.h>
+
+#define ARION_INQ_VENDOR	"ROG"
+#define ARION_INQ_MODEL		"ESD-S1C"
+
+/* The colour table has 16 slots; 4 of them drive LEDs. */
+#define ARION_NUM_LEDS		4
+
+/* ENE register map (BE16 on the wire). */
+#define ENE_REG_MODE		0x8021	/* 1 = Static selects the colour tables */
+#define ENE_REG_APPLY		0x80a0	/* 0x01 = apply, 0xaa = apply and save */
+#define ENE_REG_COLORS_EFFECT	0x8160	/* colour table, 3 bytes per LED */
+#define ENE_REG_COLORS_DIRECT	0x8100	/* second table some firmware uses */
+
+#define ENE_MODE_STATIC		1
+#define ENE_APPLY		0x01
+#define ENE_SAVE		0xaa
+
+/* The colour tables are R, B, G on the wire; the subleds are R, G, B. */
+#define ENE_WIRE_R		0
+#define ENE_WIRE_B		1
+#define ENE_WIRE_G		2
+#define ENE_RGB_LEN		3
+
+/*
+ * Vendor CDB: opcode, 'A''S' signature, register, argument count in
+ * byte 13. scsi_execute_cmd() cannot be used for it, see the commit
+ * message.
+ */
+struct ene_cdb {
+	u8		opcode;
+	u8		sig[2];
+	__be16		reg;
+	u8		reserved[8];
+	u8		arg_count;
+	u8		pad[2];
+} __packed;
+
+static_assert(sizeof(struct ene_cdb) == 16);
+
+struct asus_aura_led {
+	struct led_classdev_mc	mc_cdev;
+	struct mc_subled	subled[ENE_RGB_LEN];
+
+	/* Cached colour, consumed by the work item. */
+	u8			rgb[ENE_RGB_LEN];
+	bool			pending;
+
+	struct asus_aura	*aura;
+};
+
+struct asus_aura {
+	struct scsi_device	*sdev;
+	struct asus_aura_led	leds[ARION_NUM_LEDS];
+
+	/* Serializes the cached colours and pending flags. */
+	spinlock_t		lock;
+	struct work_struct	work;
+
+	/* DMA-safe staging buffer, the only memory ever mapped for DMA. */
+	u8			tx[ENE_RGB_LEN];
+};
+
+static int ene_write_reg(struct asus_aura *aura, u16 reg,
+			 const u8 *tx, u8 len)
+{
+	struct scsi_device *sdev = aura->sdev;
+	struct request *rq;
+	struct scsi_cmnd *scmd;
+	struct ene_cdb cdb = {
+		.opcode		= 0xec,
+		.sig		= { 'A', 'S' },
+		.reg		= cpu_to_be16(reg),
+		.arg_count	= len,
+	};
+	int ret;
+
+	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	/*
+	 * Stack memory is not DMA-safe (VMAP_STACK), so the payload is
+	 * copied into the per-device buffer first.
+	 */
+	memcpy(aura->tx, tx, len);
+	ret = blk_rq_map_kern(rq, aura->tx, len, GFP_NOIO);
+	if (ret)
+		goto out;
+
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->cmd_len = sizeof(cdb);
+	memcpy(scmd->cmnd, &cdb, sizeof(cdb));
+	scmd->allowed = 1;
+	rq->timeout = 5 * HZ;
+	rq->rq_flags |= RQF_QUIET;
+
+	blk_execute_rq(rq, true);
+
+	/* GOOD status is zero in the fields we care about. */
+	ret = scmd->result ? -EIO : 0;
+out:
+	blk_mq_free_request(rq);
+	return ret;
+}
+
+static void asus_aura_work(struct work_struct *work)
+{
+	struct asus_aura *aura =
+		container_of(work, struct asus_aura, work);
+	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
+	bool pending[ARION_NUM_LEDS];
+	bool any = false;
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * Fast path without the lock: if nothing is pending, return
+	 * before touching the device. A colour arriving right after
+	 * the check re-queues this work, so nothing is lost.
+	 */
+	for (int i = 0; i < ARION_NUM_LEDS; i++) {
+		if (READ_ONCE(aura->leds[i].pending)) {
+			any = true;
+			break;
+		}
+	}
+	if (!any)
+		return;
+
+	/* Snapshot the cached colours and clear the pending flags. */
+	spin_lock_irqsave(&aura->lock, flags);
+	for (int i = 0; i < ARION_NUM_LEDS; i++) {
+		pending[i] = aura->leds[i].pending;
+		aura->leds[i].pending = false;
+		memcpy(rgb[i], aura->leds[i].rgb, ENE_RGB_LEN);
+	}
+	spin_unlock_irqrestore(&aura->lock, flags);
+
+	if (!scsi_device_online(aura->sdev))
+		return;
+
+	/* Mode first: without it the device ignores the sequence. */
+	ret = ene_write_reg(aura, ENE_REG_MODE,
+			   &(u8){ ENE_MODE_STATIC }, 1);
+	if (ret)
+		goto err;
+
+	for (int i = 0; i < ARION_NUM_LEDS; i++) {
+		if (!pending[i])
+			continue;
+
+		/*
+		 * Both colour tables are written: firmware revisions
+		 * pull from either of them.
+		 */
+		ret = ene_write_reg(aura, ENE_REG_COLORS_EFFECT + i * ENE_RGB_LEN,
+				    rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+
+		ret = ene_write_reg(aura, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
+				    rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+	}
+
+	ret = ene_write_reg(aura, ENE_REG_APPLY, &(u8){ ENE_APPLY }, 1);
+	if (ret)
+		goto err;
+
+	/* The change only takes effect after a save. */
+	ret = ene_write_reg(aura, ENE_REG_APPLY, &(u8){ ENE_SAVE }, 1);
+	if (ret)
+		goto err;
+
+	return;
+
+err:
+	/*
+	 * This runs detached from the LED core, which has no error
+	 * channel for brightness_set. The write is dropped and logged
+	 * ratelimited; the LED keeps the last successfully applied
+	 * colour until the next user update.
+	 */
+	dev_err_ratelimited(&aura->sdev->sdev_gendev,
+			    "asus_aura: colour update failed: %d\n", ret);
+}
+
+/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI. */
+static void asus_aura_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
+	struct asus_aura_led *led =
+		container_of(mc, struct asus_aura_led, mc_cdev);
+	struct asus_aura *aura = led->aura;
+	unsigned long flags;
+
+	/*
+	 * led_mc_calc_color_components() writes the shared subled_info
+	 * array. Sysfs stores are serialized by the LED core, but
+	 * trigger events call led_set_brightness() without that lock,
+	 * so compute and cache under the aura lock.
+	 */
+	spin_lock_irqsave(&aura->lock, flags);
+
+	led_mc_calc_color_components(mc, brightness);
+
+	led->rgb[ENE_WIRE_R] = led->subled[0].brightness;
+	led->rgb[ENE_WIRE_B] = led->subled[2].brightness;
+	led->rgb[ENE_WIRE_G] = led->subled[1].brightness;
+	led->pending = true;
+
+	spin_unlock_irqrestore(&aura->lock, flags);
+
+	schedule_work(&aura->work);
+}
+
+static int asus_aura_register_led(struct asus_aura *aura, int index)
+{
+	struct asus_aura_led *led = &aura->leds[index];
+	struct led_classdev *cdev = &led->mc_cdev.led_cdev;
+	char hctl[32];
+	int ret;
+
+	led->aura = aura;
+
+	led->subled[0].color_index = LED_COLOR_ID_RED;
+	led->subled[1].color_index = LED_COLOR_ID_GREEN;
+	led->subled[2].color_index = LED_COLOR_ID_BLUE;
+	led->mc_cdev.num_colors = ENE_RGB_LEN;
+	led->mc_cdev.subled_info = led->subled;
+
+	/*
+	 * The sdev's H:C:T:L keeps the names unique when more than one
+	 * enclosure is connected; with a static name the LED core would
+	 * register a second enclosure's LEDs under renamed nodes
+	 * (asus-arion::led-0_1), the wrong device identity. The colons
+	 * are flattened to dashes, the color section stays empty
+	 * (multicolor, palette via multi_intensity) and the four
+	 * identical zones take a "-N" ordinal, as
+	 * Documentation/leds/leds-class.rst asks for.
+	 */
+	strscpy(hctl, dev_name(&aura->sdev->sdev_gendev));
+	strreplace(hctl, ':', '-');
+	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s::led-%d", hctl, index);
+	if (!cdev->name)
+		return -ENOMEM;
+
+	cdev->max_brightness = 255;
+	cdev->brightness_set = asus_aura_set;
+
+	led_mc_calc_color_components(&led->mc_cdev, cdev->brightness);
+
+	/*
+	 * NULL parent: a device reference on the sdev would block its
+	 * final release on unplug, which is what calls detach() to
+	 * unregister the LEDs. The cycle leaked nodes and the module
+	 * refcount on every hot-unplug.
+	 */
+	ret = led_classdev_multicolor_register(NULL, &led->mc_cdev);
+	if (ret)
+		kfree(cdev->name);
+	return ret;
+}
+
+/*
+ * Unregister the LEDs before cancelling the work: unregistering removes
+ * the sysfs attributes, so no new brightness_set can schedule the work
+ * afterwards. Cancelling first would leave a window where a brightness
+ * write requeues the work after cancel_work_sync() returned.
+ */
+static void asus_aura_release(struct asus_aura *aura, int num_leds)
+{
+	for (int i = 0; i < num_leds; i++) {
+		led_classdev_multicolor_unregister(&aura->leds[i].mc_cdev);
+		kfree(aura->leds[i].mc_cdev.led_cdev.name);
+	}
+
+	cancel_work_sync(&aura->work);
+	kfree(aura);
+}
+
+static int asus_aura_attach(struct scsi_device *sdev)
+{
+	struct asus_aura *aura;
+	int ret;
+
+	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
+	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
+		return SCSI_DH_DEV_UNSUPP;
+
+	aura = kzalloc_obj(*aura, GFP_KERNEL);
+	if (!aura)
+		return SCSI_DH_NOMEM;
+
+	aura->sdev = sdev;
+	spin_lock_init(&aura->lock);
+	INIT_WORK(&aura->work, asus_aura_work);
+
+	for (int i = 0; i < ARION_NUM_LEDS; i++) {
+		ret = asus_aura_register_led(aura, i);
+		if (ret) {
+			asus_aura_release(aura, i);
+			return SCSI_DH_NOMEM;
+		}
+	}
+
+	sdev->handler_data = aura;
+	return SCSI_DH_OK;
+}
+
+static void asus_aura_detach(struct scsi_device *sdev)
+{
+	struct asus_aura *aura = sdev->handler_data;
+
+	if (!aura)
+		return;
+
+	asus_aura_release(aura, ARION_NUM_LEDS);
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
+MODULE_DESCRIPTION("ASUS Aura RGB over SCSI for ROG NVMe enclosures");
+MODULE_AUTHOR("Liang Haowen");
+MODULE_LICENSE("GPL");
-- 
2.55.0

