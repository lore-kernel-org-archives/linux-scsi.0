Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954A6490BFE
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526711; cv=none; b=IUFoyRH9SJNw7nMlN+Z7ABbdO94yxLmjtzFl62lcChRag3sT0run00Yw0hU4MKignR6X6yNyK+cxXPXf7XIB58Cbc6x+XyT/eFlgbJMNcKqmwN1+DCfiax55GxHmrBZevNo8IAL3aYxwLNolepT1AlCiNnrzjFbgcPSDcatfQdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526711; c=relaxed/simple;
	bh=Is8tfHroxKAskKJLsYwL1b9heFxU3KpHUQJuUgWlqG0=;
	h=Subject:Date:Message-ID:In-Reply-To:References:From:To:Cc:
	 Content-Type:MIME-Version; b=DaN1XdLjNLIBbSDQYvBM8bfGA6zMHz6HY0X4Pu7GQXt8yT/pYUAq6an4mBJbBTLOo4yTHpGPq/A5bcYm+htFKnHmQsmFqsYo5e2s9tY7lF6t+/P3yuZS26DTIohV4jbAZUMdPeBS2ViWlSpQSRrauwHoREhduy+PRGPFVPdYzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P69HqyJk; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P69HqyJk"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-39647184c73so2074261a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526709; x=1789131509; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+MG5ygb7cPqaycySngDMN+n/nAhBI6ReSE0L0NYO0KI=;
        b=P69HqyJk2d9M7a5eV58e5al7yvn2VJmVSk1QgbYL54NtvroQa18fhl5wRCIUUIHTg1
         /kbNNTdny4U4iXZwrwXLkgQ5GnhPRMTfm3lCdA4Y9tGRjwqylF5gdXwkxuBO4ibMXHUx
         PN06ZmJmNxyOAXmIxCGtUlccdDO9i0Y1Up8GFEE8NIkgQIEI19ktTsbSbKq4vgeVeCGm
         rs4PHCZer1fvxokOrQL3NGwPdNpRi0fp/LTjJ/4MX6zi0H79iqMBX8rZ+jR7ehkfz6Ev
         DcDrZR6uEdnzuv4POkhECLEjXJ2uS7xwChb6VH1B8AkEBBdt2G2iSNMRAy905Xcfjq41
         yz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526709; x=1789131509;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+MG5ygb7cPqaycySngDMN+n/nAhBI6ReSE0L0NYO0KI=;
        b=UiU8H2jC06Fn6vsayvT1DzXMvs/RmLQfNDQYmk7E+I+G1ECm9TXsuYAead1fxZBObO
         sVz1ibPWPSLP1IQlyFM0TrZel9wl6S4y8kqDSDEqEchxYQ6DIjZ2cxiVEi5OhdYv6/Df
         MpXEhfSPFOBmM9jxDrJz7i4EWnGQNBgxdn4oy5ZYM9cG9xFevQooionhc9TI3MHBpcCs
         +wfxVk5UQUBzezdgpvg0o/ucHHvfSUy4fwFEXfB5WJZR1DM38MKJDav4fygG3RSc1fgX
         bqdvqkQG5vLU6s6lEpRvUNvnOsk0tK4liC6P5OEVlGYtTK0ei2LJjtY72YGfceYwSHuj
         v1Sg==
X-Forwarded-Encrypted: i=1; AKwUvBwXW2MeimlQGc37mYbm4x9jY5YfFYh6Qh5aq0gfj9w8SZEJRJGiITqes2FdfxJA4Cq+uJaSWYvy5ynk@vger.kernel.org
X-Gm-Message-State: AFuF++l7fWYxH+IKcdDvO9/ssmV031aN/LyqdD9LjRQDts5t2+4wu1sy
	DS3shRw9r4zyxSxhOk4v9EuSjiMzV03EFnN3+pKZM+ZpaSQS1/2XHb3W
X-Gm-Gg: AYBFou1ezTrCdixh1RtnETiZ2fODNKbpdMrW2fk7a3ce4AkruFIhW9TphCNcMaJrgib
	FQgqjMuUkwCpw3AXPiCH9lohLU/mpBsh+kxRT4lmi0R17laAY0+KAE6Q1x2fn86KPSigWvCwRcW
	VX8gzQfPyRIZN5LtViNCmHfEA32A4QqVdy+pP/sh5rC2qz+h7/d77tATWtxifIc04l9LCLAGvjJ
	gCOHBOIDFjQKX3NN4Z4FTqiPkyrXQQe5/qGDjHMg4oIjZeDhBtjVPRchsOCUimDT0jqw1RVIZmy
	cqRq1xyl9TO2QmJBqRtfne29OytO1e9Q15VfITc4xUNSP3HmBAZvmmoeOE7ZhutRiQY76adLYbb
	N0vmQKYD4JZyC8xBDaCCWdTa1vhA/xuDQREgjbDj+Tq35VhSznKC1EHgpdRhWhcxfAs2E2epGXj
	s7EtDCcFPInyZ+W9GpzYhf7/Vi9DbZBSXz0xXC+zG1GdlnLH/7TmmOVLNROrDCqiCU9g==
X-Received: by 2002:a17:90b:2751:b0:398:9bd3:d6d4 with SMTP id 98e67ed59e1d1-39b27ec580fmr4161805a91.14.1788526708279;
        Fri, 04 Sep 2026 05:58:28 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260cd2aasm4492886a91.3.2026.09.04.05.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:58:27 -0700 (PDT)
Subject: [PATCH RFC v3 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Fri, 04 Sep 2026 20:30:00 +0800
Message-ID: <202609042030.RFCv3-1.lhw@gmail.com>
In-Reply-To: <202609042000.RFCv3-0.lhw@gmail.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com> <202609032000.RFCv2-0.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com> <20260903161357.GX2133376@google.com>
 <202609042000.RFCv3-0.lhw@gmail.com>
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
plain USB mass-storage devices with no HID interface: the Aura LEDs
hang off an ENE controller driven by vendor SCSI commands on the same
LUN as the disk. The enclosure has 4 independently addressable LEDs,
verified on hardware.

Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
disk) and exposes each LED as a multicolor LED class device,
/sys/class/leds/asus-arion-<H:C:T:L>:led0 through led3. The
H:C:T:L part keeps the names unique when more than one enclosure
is connected.

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
 drivers/leds/leds-asus-aura-scsi.c | 375 +++++++++++++++++++++++++++++
 1 file changed, 375 insertions(+)
 create mode 100644 drivers/leds/leds-asus-aura-scsi.c

diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura=
-scsi.c
new file mode 100644
index 0000000..3ff3361
--- /dev/null
+++ b/drivers/leds/leds-asus-aura-scsi.c
@@ -0,0 +1,375 @@
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
+ * each is a multicolor LED class device (asus-arion-<H:C:T:L>:led0..led3,
+ * unique per enclosure). A colour change writes that LED's slot only:
+ * EFFECT 0x8160 + 3*led, DIRECT 0x8100 + 3*led (3 bytes, byte order R, B, G=
),
+ * then APPLY (0x01) and SAVE (0xaa). MODE (0x8021 =3D Static) is written fi=
rst
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
+ * scsi_execute_cmd() on top of scsi_alloc_request() and forces cmd_len =3D =
16
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
+#define ENE_REG_MODE		0x8021	/* AuraMode value: Static=3D1, Breathe=3D2, ...=
 */
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
+	cdb[0] =3D ENE_OPCODE;
+	cdb[1] =3D 'A';
+	cdb[2] =3D 'S';
+	cdb[3] =3D (reg >> 8) & 0xff;
+	cdb[4] =3D reg & 0xff;
+	cdb[13] =3D arg_count;
+}
+
+/*
+ * scsi_execute_cmd() with cmd_len forced to 16. scsi_alloc_request()
+ * initializes the parts of the scsi_cmnd a passthrough needs (zeroed
+ * cmnd, cmd_len =3D MAX_COMMAND_SIZE, sense_len, rcu head, retries);
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
+	rq =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	if (arg_count) {
+		ret =3D blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
+		if (ret)
+			goto out;
+	}
+
+	scmd =3D blk_mq_rq_to_pdu(rq);
+	scmd->cmd_len =3D ENE_CDB_LEN;
+	memcpy(scmd->cmnd, cdb, ENE_CDB_LEN);
+	scmd->allowed =3D 1;
+	rq->timeout =3D ENE_TIMEOUT;
+	rq->rq_flags |=3D RQF_QUIET;
+
+	blk_execute_rq(rq, true);
+	ret =3D scmd->result;
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
+	struct asus_aura_zone *zone =3D
+		container_of(work, struct asus_aura_zone, work);
+	struct scsi_device *sdev =3D zone->sdev;
+	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
+	u8 apply =3D ENE_APPLY;
+	u8 save =3D ENE_SAVE;
+	u8 mode =3D ENE_MODE_STATIC;
+	unsigned long flags;
+	u8 pending;
+	int i, ret;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	pending =3D zone->dirty;
+	zone->dirty =3D 0;
+	for (i =3D 0; i < ARION_NUM_LEDS; i++)
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
+	ret =3D ene_write(sdev, ENE_REG_MODE, &mode, 1);
+	if (ret)
+		goto err;
+
+	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
+		if (!(pending & BIT(i)))
+			continue;
+
+		ret =3D ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
+				rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+
+		/*
+		 * Cover the DIRECT colour set too; some firmware revisions
+		 * pull from 0x8100 instead of 0x8160.
+		 */
+		ret =3D ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
+				rgb[i], ENE_RGB_LEN);
+		if (ret)
+			goto err;
+	}
+
+	ret =3D ene_write(sdev, ENE_REG_APPLY, &apply, 1);
+	if (ret)
+		goto err;
+
+	/*
+	 * The change only takes effect after SAVE (0xaa). NOTE: saving on
+	 * every brightness change writes flash each time; revisit for wear
+	 * once confirmed.
+	 */
+	ret =3D ene_write(sdev, ENE_REG_APPLY, &save, 1);
+	if (ret)
+		goto err;
+
+	return;
+err:
+	dev_err(&sdev->sdev_gendev,
+		"asus_aura: colour update failed: %d\n", ret);
+}
+
+/* Non-blocking LED callback (LED core fast path). Cache colour, defer SCSI.=
 */
+static void asus_aura_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc =3D lcdev_to_mccdev(cdev);
+	struct asus_aura_led *led =3D
+		container_of(mc, struct asus_aura_led, mc_cdev);
+	struct asus_aura_zone *zone =3D led->zone;
+	unsigned long flags;
+
+	led_mc_calc_color_components(mc, brightness);
+
+	spin_lock_irqsave(&zone->lock, flags);
+	/* ENE colour register byte order is R, B, G. */
+	led->rgb[0] =3D led->subled[0].brightness;
+	led->rgb[1] =3D led->subled[2].brightness;
+	led->rgb[2] =3D led->subled[1].brightness;
+	zone->dirty |=3D BIT(led->index);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	schedule_work(&zone->work);
+}
+
+static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
+{
+	struct asus_aura_led *led =3D &zone->leds[index];
+	struct led_classdev *cdev =3D &led->mc_cdev.led_cdev;
+	int ret;
+
+	led->zone =3D zone;
+	led->index =3D index;
+
+	led->subled[0].color_index =3D LED_COLOR_ID_RED;
+	led->subled[1].color_index =3D LED_COLOR_ID_GREEN;
+	led->subled[2].color_index =3D LED_COLOR_ID_BLUE;
+	led->mc_cdev.num_colors =3D 3;
+	led->mc_cdev.subled_info =3D led->subled;
+
+	/*
+	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
+	 * host, so the names stay unique when more than one is connected.
+	 * With a static name the LED core would register the second
+	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
+	 * is the wrong device identity. The names are per-attachment, like
+	 * sd X letters, and userspace is expected to enumerate.
+	 */
+	cdev->name =3D kasprintf(GFP_KERNEL, "asus-arion-%s:led%d",
+			       dev_name(&zone->sdev->sdev_gendev), index);
+	if (!cdev->name)
+		return -ENOMEM;
+	cdev->max_brightness =3D 255;
+	cdev->brightness_set =3D asus_aura_set;
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
+	ret =3D led_classdev_multicolor_register(NULL, &led->mc_cdev);
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
+	for (i =3D 0; i < num_leds; i++)
+		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);
+	cancel_work_sync(&zone->work);
+	for (i =3D 0; i < num_leds; i++)
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
+	zone =3D kzalloc_obj(*zone, GFP_KERNEL);
+	if (!zone)
+		return SCSI_DH_NOMEM;
+	zone->sdev =3D sdev;
+	spin_lock_init(&zone->lock);
+	INIT_WORK(&zone->work, asus_aura_zone_work);
+
+	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
+		ret =3D asus_aura_register_led(zone, i);
+		if (ret) {
+			asus_aura_release(zone, i);
+			return SCSI_DH_NOMEM;
+		}
+	}
+
+	sdev->handler_data =3D zone;
+	return SCSI_DH_OK;
+}
+
+static void asus_aura_detach(struct scsi_device *sdev)
+{
+	struct asus_aura_zone *zone =3D sdev->handler_data;
+
+	if (!zone)
+		return;
+	asus_aura_release(zone, ARION_NUM_LEDS);
+	sdev->handler_data =3D NULL;
+}
+
+static struct scsi_device_handler asus_aura_dh =3D {
+	.name	=3D "asus_aura",
+	.module	=3D THIS_MODULE,
+	.attach	=3D asus_aura_attach,
+	.detach	=3D asus_aura_detach,
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
+MODULE_DESCRIPTION("ASUS Aura RGB over SCSI for ROG NVMe enclosures (per-LED=
)");
+MODULE_AUTHOR("Liang Haowen");
+MODULE_LICENSE("GPL");
--=20
2.55.0


