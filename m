Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DE74A262E
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 12:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437343; cv=none; b=L8hDP2wnRvEZldPiEiDHlTXVspxtIqB2VsfL21UJ0CKT0WZ+dDEhEHtlB1CpO3Qg6zuz9TNqKkgUhskLYVm4wxFjQ5SLtQpT6kwrrHIhUS1HKEg8gFHtoKK50d6UsdyYqlo65dUkrj0i/MjWdk0e+z3BSc//hkaeiSFsbbXE75s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437343; c=relaxed/simple;
	bh=8zMCCFt2kdkh0qFuujHEFl/TvTjceg+rp/SOE5piDdA=;
	h=Subject:Date:Message-ID:In-Reply-To:References:From:To:Cc:
	 Content-Type:MIME-Version; b=rMtXqVudQK7avyWidhumD1Ug4eWPJll4IOLU3RfLRDhWTZsa8VSUR+dIkFf+l2/ZVkob58mXc1LQM98O43hO1jgo91AhzpIoiUcCZ4xWoOp8f0uZqqa+z4VpOm6oc8J7HRF/VCgGcsDmtEqi5UvDOzrYjw9l97N/z+hewRZXQCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5mlLBFb; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5mlLBFb"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d944747d41so26893335ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 05:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788437341; x=1789042141; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c/a03k/MuPRlTmtB5F3YuX+O633+V86tiPMiBZLx+n8=;
        b=F5mlLBFbhnWpTE0eLM1PRpZ/mrBDkq6w2oNlEBQyX3fvmmgd4wuHmWs9dcu27ufGqQ
         6/FEKvUwRuM6mTd6zIOkufmxhCWsTQBtEkewwO3tiA5kyB8/7qlj2ZyAdl+c1zSxlhWQ
         Ar+wHt1oRW/yDV9UqgiiPWn0QtRd3ZbwkQXCo4s2gZnc3XDsVrv+xqWOY318zGDrrHuA
         7U25QYjmx4k41uT3mNsDp8G7OdTi/M4Lf6HVG3jI65lrm3XDaTZuopTItbJGFC+njd/O
         OPj5qO2BD4NJr6LaSrvsv76Zb2Ua5BYBgolP5P1XrO2/aoo64G+LIhmm9eFgBcTSJCcZ
         jbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437341; x=1789042141;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c/a03k/MuPRlTmtB5F3YuX+O633+V86tiPMiBZLx+n8=;
        b=MJX6eEamtwEpNFNJUHhQXizlQFhiG2DiFVqD8BY4zsNtt3xy4HWJ9QMYE8awYe+AS1
         QbFEpZAlHuFLC3Hq5W/DpTg+mh9sTafsKMlKUNmI0XM2yLRTD6rV9LDO1gZ2Bxz+0LIk
         JvmaEHqLl3mcrP8AYQNahqdRLBv9XBaGmfMDXo63DriWEdbx7N309Hn0kCSIejs4ovy6
         8awzbnZp7HbsWDg3iGxZIU5X9VicSKAAja1FUmFNa5eykiyu14m0V4R8lWHpjNqasXQI
         E01t/6v4MC0t+6GT19WsVLk4FHybbh05kyEAZwOm2z1UI31jpntmKKWTVE5U5pi1PquB
         +mcg==
X-Forwarded-Encrypted: i=1; AKwUvBzx1mrx9BoZZDP3+1wwR3bO0udrCWHoNgzNLu7ThHdu/Xnf4Ghc47dvd6yVMD4cmNzWa3oqC8IXdG2L@vger.kernel.org
X-Gm-Message-State: AFuF++l3N6PQm6kJyuNFRqjvYpw7AO7MoX2tWPzHlwg0mIAtVXNMTlU9
	i6o919ppoVSZCobvVVJDs6R1IH5z6VP0GE/irCZyhI5JrDVAkXdX116/
X-Gm-Gg: AYBFou0m/oxOz1oY8y/NXg4OjstzL9ci3nSJtgys0/lCayrd+MJUx7GnMwUxY1kX6p+
	+ZpJ61AgrrU8go6LUnlgq/WzGvJfVevPpbXgEGWytrnbQj033uNapoJsshAN4GWxQ9xBEBb70kp
	NEX+XSMUwBE/zxg5xJzsocDTThB+Hlly9W6ej+wVgEqhFT4uJO6fwpzBuaKEPlMx7CAP5WpxOAA
	SeIjbIfGjz74oOwoNwR0FfLf7iCITfk+dHS9RKG+nRRICPZBKPLz8eVsOnUD7VBKEw6Gt1X5sMi
	08g+frCVewjf1uXrmQETOHBcN72ICmGS8j6we8w3IdXIvaMOnm0jI8kIa4GNpw8WOpplGK9E7Zs
	QvXQp6SJFiwd+QCiXMe8DVwQ/kf3tlR4M1pMIJwYS6Msygsk+MYYJt0Ra3UZ2urTgsiLXQYp8qC
	NW9zJFkQORRdDtmT2fC3Y4GpMC03KGpgkZGjVqQjQcLWCTIO8AP6ffyo3KHO2UQMs5og==
X-Received: by 2002:a17:90b:33c4:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-39aedf644damr16055891a91.5.1788437340066;
        Thu, 03 Sep 2026 05:09:00 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc43d424edesm869853a12.22.2026.09.03.05.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:08:59 -0700 (PDT)
Subject: [PATCH RFC v2 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Thu, 03 Sep 2026 20:00:00 +0800
Message-ID: <202609032000.RFCv2-1.lhw@gmail.com>
In-Reply-To: <202609012200.RFC0.lhw@gmail.com>
References:
 <202609012200.RFC0.lhw@gmail.com> <202609012200.RFC1.lhw@gmail.com>
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
/sys/class/leds/asus-arion:led0 through led3.

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
scsi_alloc_request() instead, which fully initializes the scsi_cmnd,
with cmd_len forced to 16, mirroring what SG_IO does from userspace.

brightness_set only caches the colour and marks the LED in a per-zone
dirty bitmap; a single work item per zone then runs one ENE sequence
for all pending LEDs (MODE, colour slots, APPLY, SAVE). Funneling
every update through one work item keeps the sequences from
interleaving between concurrent LED updates and batches multi-LED
updates into a single APPLY/SAVE.

This is the monolithic out-of-tree version as verified on hardware;
the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
into a SCSI transport helper and a shared ASUS Aura LED interface.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
---
 drivers/leds/leds-asus-aura-scsi.c | 332 +++++++++++++++++++++++++++++
 1 file changed, 332 insertions(+)
 create mode 100644 drivers/leds/leds-asus-aura-scsi.c

diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura=
-scsi.c
new file mode 100644
index 0000000..4dd559a
--- /dev/null
+++ b/drivers/leds/leds-asus-aura-scsi.c
@@ -0,0 +1,332 @@
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
+ * each is a multicolor LED class device (asus-arion:led0..led3). A colour
+ * change writes that LED's slot only: EFFECT 0x8160 + 3*led, DIRECT
+ * 0x8100 + 3*led (3 bytes, byte order R, B, G), then APPLY (0x01) and
+ * SAVE (0xaa). MODE (0x8021 =3D Static) is written first in every sequence;
+ * skipping it makes the device ignore the whole sequence.
+ *
+ * Scheduling: brightness_set (LED core fast path) caches the colour and
+ * marks the LED in a per-zone dirty bitmap; a single work item per zone
+ * runs one ENE sequence for all pending LEDs (MODE once, colour slots,
+ * APPLY, SAVE). Funneling every update through that one work item also
+ * serializes the sequences: the MODE/colour/APPLY/SAVE chain must never
+ * interleave between concurrent LED updates.
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
+#include <linux/slab.h>
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
+	unsigned long		dirty;	/* bit i: led i needs a colour write */
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
+ * initializes the scsi_cmnd fully (scsi_initialize_rq(): zeroed cmnd, sense
+ * and rcu head, retries), which a raw blk_mq_alloc_request() does not.
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
+ * marked in the dirty bitmap. test_and_clear_bit() pairs with the set_bit()
+ * in asus_aura_set(): a colour cached while this runs requeues the work and
+ * is picked up by the next sequence.
+ */
+static void asus_aura_zone_work(struct work_struct *work)
+{
+	struct asus_aura_zone *zone =3D
+		container_of(work, struct asus_aura_zone, work);
+	struct scsi_device *sdev =3D zone->sdev;
+	u8 apply =3D ENE_APPLY;
+	u8 save =3D ENE_SAVE;
+	u8 mode =3D ENE_MODE_STATIC;
+	int i, ret;
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
+		struct asus_aura_led *led =3D &zone->leds[i];
+
+		if (!test_and_clear_bit(i, &zone->dirty))
+			continue;
+
+		ret =3D ene_write(sdev, ENE_REG_COLORS + i * ENE_RGB_LEN,
+				led->rgb, ENE_RGB_LEN);
+		if (ret)
+			goto err;
+
+		/*
+		 * Cover the DIRECT colour set too; some firmware revisions
+		 * pull from 0x8100 instead of 0x8160.
+		 */
+		ret =3D ene_write(sdev, ENE_REG_COLORS_DIRECT + i * ENE_RGB_LEN,
+				led->rgb, ENE_RGB_LEN);
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
+
+	led_mc_calc_color_components(mc, brightness);
+	/* ENE colour register byte order is R, B, G. */
+	led->rgb[0] =3D led->subled[0].brightness;
+	led->rgb[1] =3D led->subled[2].brightness;
+	led->rgb[2] =3D led->subled[1].brightness;
+
+	set_bit(led->index, &led->zone->dirty);
+	schedule_work(&led->zone->work);
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
+	cdev->name =3D kasprintf(GFP_KERNEL, "asus-arion:led%d", index);
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


