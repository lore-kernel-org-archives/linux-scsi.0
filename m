Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252303876A9
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072869; cv=none; b=rQuihm30huCFJ6/t3O1Jo/rGJJqvUReGk3Nfm5KfSxrwGzHwrKPsYZZiT8Bipdl4e71B6tAsUT0zMCqwoIHq0ufWvsz9tbDObuQJPZgzXLcK8JrkXJ97KyWldynwj2wT4uO0BQw69FqCQsY1krnp3ocR9U1pwAjjoApBn4PWdIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072869; c=relaxed/simple;
	bh=0hXWrMLPZja53cQwmkCKqj7loKdH3CRsgLcF2CVfs/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2WtEL+pqk2DW05CGAjSO9e26kYN9d9ulEKz4FxnK1CngcSijZjWSuRYVNscYf3pt+XMHNKalG2P+BYrRyivO17Ot7zJgSCkUp+xFDr8jYg/aJMdvI/RTm9AI/gLh035RGM+h+oi+Ky0NKdlgZnrcgNjUpxlutTkx1ablTxyUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=syfBrBnX; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="syfBrBnX"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e901e114fdso21871155ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792072867; x=1792677667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IYL2Zmm8TTrpEFRYBVPJr6Yj6LDgf8oYTjHjngTpauE=;
        b=syfBrBnXHoNYGWPMMHiRoUlBI1p9UlNPFhY94AYP1hSW/gIdkFOYF+QOAT9c53doDh
         MX2QTEIQVxYvKQX8Vs9cWZIR2s0uUfKom20177VrrgYp0pKfyPEOqrbnj2hPO0OjAL4F
         xWLTb7aaLHadqYxTNroQ/eDUE3ySccZWRLwkhnlSFA70FeE4NuaksS4kSIZPsV2M52D5
         pzmSJPtLFUZhRcOQavoJ02P1Ef0JStb1nIUSGfnaJXgJbrnYcgr+Z0FqX20kSDYF3is/
         w9frUo+yD2ZZ9lFBkJZhh3ECYkcquWdwNTNy8xXzFVXhRNNo6ZhX23r5Gx/cMkfItPRV
         julQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792072867; x=1792677667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IYL2Zmm8TTrpEFRYBVPJr6Yj6LDgf8oYTjHjngTpauE=;
        b=BPhW3F2p4iocEjC0lmLWJ/3dkonlp8qFi+rLFe9qqPOzRJZ3N4US0KT7T1L5yENMRj
         zo60RzBQBm5b695XSLtU7IxjSLmMeHrLN23Y2pqPDHw6rsI4UPb8gEyq6b4hWebphpev
         WJFsOdbPYLmMy5cXtU2wgHtl2KbvzxWGfCWNYa93h+kcTjmicIPRQiiGTsPHMDrSolH1
         JFHFV2mRw9lTuPJfpZFAxp6iOQVbCRQKg7mQjFyspgSkI0tK4WcQ6Pq+DlAtqMPBxi7l
         uvFg/LYF7E3qPaFnPxK3SMiZpoTWNsOZjFxgyO4hQC0v+dXNCbi+htTQ/lS0oHyosPKB
         XpMA==
X-Forwarded-Encrypted: i=1; AKwUvBwMm7vBY8fQYWIGz/XR1yguUE5gUPt20sYpSjC5gWYPkL6NIUtFo0isF7wfBT/gpV7/t1F2cf9Xh+SJ@vger.kernel.org
X-Gm-Message-State: AFq9FYJpADRN42zVH72QBdGQX8JBxBeHQwYQDbSOErhmkPSC+XIbDxzC
	/7x9xGv5K9vyV8mx1PQmV/jjs6s7DJnvHuYA5HvR1n3ESU8NPrMk9iY+
X-Gm-Gg: AYBFou3WZr2BMScMnZuEpfA6wQcxZ1oS+nHpY17xHnAOHQx363U5S0VXVpe/4WxtzxC
	yEnwmaKDN3+4MYV0auY11Cx7+06z98dixLDS9HZO8cGVl3FcmGBKKyfDlgQuXCOOJ5VbbdyxO6F
	uWYa5FOFIdGtTw1EdAxmSChWxrjqU4gnJRzXrJnMN4fXojGMHj63zrSPjpbQqOKUn9ubzSzgahb
	oimlDcAgi8c6Xd+AqmyqMPWmLbOhTEPP5DUyUArJYDVvSHFg11bziLG1KxohHZ1jHyQZm/IaQZJ
	E2kqAPKPML1eR2hhi53wK84HbHqKsNApb4ER7nrhAmNZdrhiD4uRH8Vw8yAKrj9OdIZv8phBBLC
	2SLwYTzDNrSdr5ij2XfWTH0z7u2wDbfCE423RU6M9aFxTkKkFbZmsQDWHZcvDuN1IQ1W34i+4m0
	LXL7d/OOKCwKPFRQZe7PGy7k3p0b3xIDHht+g9p040LAJPXHWKiTLIQr9CQ0rJgI+/w+wmQtqjB
	vB6FQ==
X-Received: by 2002:a17:902:cccc:b0:2e2:c8a1:ab63 with SMTP id d9443c01a7336-2e8429a96cdmr165651965ad.17.1792072866863;
        Thu, 15 Oct 2026 07:01:06 -0700 (PDT)
Received: from ROGZephyrusG16Air ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8c4csm82919675ad.56.2026.10.15.07.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:01:06 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: lee@kernel.org,
	pavel@kernel.org,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	denis.benato@linux.dev,
	W_Armin@gmx.de,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com,
	scardracs@disroot.org
Subject: [RFC v10 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
Date: Thu, 15 Oct 2026 22:00:51 +0800
Message-ID: <20261015140051.1159817-2-nbg2974@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261015140051.1159817-1-nbg2974@gmail.com>
References: <20261015140051.1159817-1-nbg2974@gmail.com>
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
APPLY 0x80a0 takes 0x01 to apply; the controller also accepts 0xaa
to save the state to its flash, which this driver never sends: the
LED class interface is runtime state and does not promise persistence
across power cycles, and a save on every update would wear the
controller flash. The colour reverts to the stored default on power
cycle, like any other runtime-only LED.

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
batches multi-LED updates into a single APPLY. A re-queued run
with nothing pending returns before touching the device, so it
cannot wear the flash with a pointless SAVE, and the lock keeps a
colour write from being reordered after its pending flag on weakly
ordered architectures.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
---
 drivers/leds/rgb/Kconfig               |  13 +
 drivers/leds/rgb/Makefile              |   1 +
 drivers/leds/rgb/leds-asus-aura-scsi.c | 404 +++++++++++++++++++++++++
 3 files changed, 418 insertions(+)
 create mode 100644 drivers/leds/rgb/leds-asus-aura-scsi.c

diff --git a/drivers/leds/rgb/Kconfig b/drivers/leds/rgb/Kconfig
index 6e9ab5f..983f50b 100644
--- a/drivers/leds/rgb/Kconfig
+++ b/drivers/leds/rgb/Kconfig
@@ -2,6 +2,19 @@
 
 if LEDS_CLASS_MULTICOLOR
 
+config LEDS_ASUS_AURA_SCSI
+	tristate "ASUS Aura RGB LEDs on ROG external NVMe enclosures"
+	depends on SCSI
+	help
+	  Say Y here if you want to control the RGB LEDs of ASUS ROG
+	  external NVMe enclosures such as the ROG STRIX Arion. The LEDs
+	  sit behind an ENE controller on the drive's SCSI LUN and are
+	  programmed with vendor commands; each of the four LED zones is
+	  exposed as a multicolor LED class device.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called leds-asus-aura-scsi.
+
 config LEDS_GROUP_MULTICOLOR
 	tristate "LEDs group multi-color support"
 	depends on OF
diff --git a/drivers/leds/rgb/Makefile b/drivers/leds/rgb/Makefile
index cc0f2df..a59c133 100644
--- a/drivers/leds/rgb/Makefile
+++ b/drivers/leds/rgb/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
+obj-$(CONFIG_LEDS_ASUS_AURA_SCSI)	+= leds-asus-aura-scsi.o
 obj-$(CONFIG_LEDS_GROUP_MULTICOLOR)	+= leds-group-multicolor.o
 obj-$(CONFIG_LEDS_KTD202X)		+= leds-ktd202x.o
 obj-$(CONFIG_LEDS_LP5812)		+= leds-lp5812.o
diff --git a/drivers/leds/rgb/leds-asus-aura-scsi.c b/drivers/leds/rgb/leds-asus-aura-scsi.c
new file mode 100644
index 0000000..7b58fce
--- /dev/null
+++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
@@ -0,0 +1,404 @@
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
+ * without saving (runtime state, no flash wear); MODE must precede
+ * every sequence or the device ignores it. The register layout is
+ * described by struct ene_cdb.
+ *
+ * brightness_set (LED core fast path) only caches the colour and marks
+ * the LED pending under a spinlock; a single work item per enclosure
+ * snapshots all pending LEDs and runs one ENE sequence for them. One
+ * work item also serializes the sequences against each other: the
+ * MODE/colour/APPLY chain must never interleave between
+ * concurrent LED updates.
+ */
+
+#include <linux/array_size.h>
+#include <linux/blk-mq.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+#include <linux/build_bug.h>
+#include <linux/byteorder/generic.h>
+#include <linux/cache.h>
+#include <linux/compiler.h>
+#include <linux/compiler_attributes.h>
+#include <linux/container_of.h>
+#include <linux/dev_printk.h>
+#include <linux/err.h>
+#include <linux/jiffies.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/sprintf.h>
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
+#define ENE_OPCODE		0xec
+
+/* ENE register map (BE16 on the wire). */
+#define ENE_REG_MODE		0x8021	/* 1 = Static selects the colour tables */
+#define ENE_REG_APPLY		0x80a0	/* 0x01 = apply, 0xaa = apply and save */
+#define ENE_REG_COLORS_EFFECT	0x8160	/* colour table, 3 bytes per LED */
+#define ENE_REG_COLORS_DIRECT	0x8100	/* second table some firmware uses */
+
+#define ENE_MODE_STATIC		1
+#define ENE_APPLY		0x01
+#define ENE_TIMEOUT		(5 * HZ)
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
+	/*
+	 * DMA-safe staging buffer, the only memory ever mapped for DMA.
+	 * Cacheline-aligned so that invalidation on non-coherent
+	 * architectures cannot clobber the members above.
+	 */
+	u8			tx[ENE_RGB_LEN] ____cacheline_aligned;
+};
+
+static int ene_write_reg(struct asus_aura *aura, u16 reg,
+			 const u8 *tx, u8 len)
+{
+	struct scsi_device *sdev = aura->sdev;
+	struct request *rq;
+	struct scsi_cmnd *scmd;
+	struct ene_cdb cdb = {
+		.opcode		= ENE_OPCODE,
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
+	rq->timeout = ENE_TIMEOUT;
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
+	struct asus_aura *aura = container_of(work, struct asus_aura, work);
+	u8 rgb[ARION_NUM_LEDS][ENE_RGB_LEN];
+	u8 mode = ENE_MODE_STATIC;
+	u8 apply = ENE_APPLY;
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
+	for (int i = 0; i < ARRAY_SIZE(aura->leds); i++) {
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
+	for (int i = 0; i < ARRAY_SIZE(aura->leds); i++) {
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
+	ret = ene_write_reg(aura, ENE_REG_MODE, &mode, sizeof(mode));
+	if (ret)
+		goto err;
+
+	for (int i = 0; i < ARRAY_SIZE(aura->leds); i++) {
+		if (!pending[i])
+			continue;
+
+		/*
+		 * Both colour tables are written: firmware revisions
+		 * pull from either of them.
+		 */
+		ret = ene_write_reg(aura,
+				    ENE_REG_COLORS_EFFECT + i * ENE_RGB_LEN,
+				    rgb[i], sizeof(rgb[i]));
+		if (ret)
+			goto err;
+
+		ret = ene_write_reg(aura,
+				    ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
+				    rgb[i], sizeof(rgb[i]));
+		if (ret)
+			goto err;
+	}
+
+	/*
+	 * Apply without save: the LED class interface is runtime state
+	 * and does not promise persistence across power cycles, and a
+	 * save on every update would wear the controller flash.
+	 */
+	ret = ene_write_reg(aura, ENE_REG_APPLY, &apply, sizeof(apply));
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
+	struct asus_aura_led *led = container_of(mc, struct asus_aura_led, mc_cdev);
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
+	strscpy(hctl, dev_name(&aura->sdev->sdev_gendev), sizeof(hctl));
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
+	for (int i = 0; i < ARRAY_SIZE(aura->leds); i++) {
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

