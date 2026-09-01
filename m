Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307623DAABE
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273587; cv=none; b=iOMk027UfzYIJR4IX+d5SSUScx7Cjsr6LNTskFR/o9QiBdiqPbrL83pXb17LyCzXGwzABk79t/Ca9eX19E7B7W+E0fZBJ9V1AHDnxLRCPu8CfjOcTYqhm/YZM9V1QRILsxLi+GnhSXNXNUfqNwm4FX9tdDKr9tvs0r315zJrfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273587; c=relaxed/simple;
	bh=kOGNgka01Rbx4naEeer+gu66lJsk6kGK5mjENUjsGGA=;
	h=Subject:Date:Message-ID:In-Reply-To:References:From:To:Cc:
	 Content-Type:MIME-Version; b=hCmnEJ0qh79/youl4rqUI0ijBdp/YgvKK1YJaSAtTQb5ehsLIvQ9GHmzZD5leM/fMS+ejZcwAwl++LkBaM0CCskwYZeMnqI7DAxfwfbNhPVGlHVTklKQgx9NR6OeugNz1Ny0cMdD9ADixOthYrQOYf60mj2Mf+dyNIS5gCMzUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OlpLdncE; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OlpLdncE"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-39266382df6so4171897a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 07:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788273582; x=1788878382; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wcli28MkGdwnTIKu9eqrlLzImwDThZPPgbi3islhn3M=;
        b=OlpLdncE3FQ9npbOrcDEHj54Xk0SeIqyEDO3XN+46wZ51tKRGl+kXiwAaLuzV/Wz/b
         3Mnb1CAZghsMOCI7IeSqB6nQJnhgtngtcpV2AXhm/qRuui4bPjfx/QGaCgwBfahDusxT
         yCDlMhggnC2sm2He9bVaHKz80MPETVZXzQPqjqueoiMk/0/dGUTZ63ChwDpKz4h/7myY
         C4A2Q8B6fcNTK9DJQq+4Bw2Gcrlo7Cam2U89ynaBSBQNvYfEmOlGVlka1INXAq51h4K0
         DPf1rPElj++H1r93Itwi+mghh5EeE9r076hRdauuTfCD/W13Yf9/i5GpvAV1uUleWP+6
         XFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273582; x=1788878382;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wcli28MkGdwnTIKu9eqrlLzImwDThZPPgbi3islhn3M=;
        b=ZqHCtzggAngspWLiukR1NkppaDHdEDdY5HegzYO/0dybHarPw+lde65CD9+9I1eo1j
         nbehUpixqKpdI3Ryw2E75/ku3cpO+N8yRIf1xHtIAGtI5y8z+oh8hVODRx8AvxqcPOXK
         u51a7PcMVnYDe2ZPsqcPCD2M9qoukGmKg4GSD59nIzL6I+m2QpO6TLFYyYjpXk0LVoPP
         ncTscScybjLvjYsaPy50+kEzdYxYPICuDp5hDStc0khz3D5Fpt0WUSqHClodU/X3D27n
         YxsC0KBNeBOUo/lARQjx463k72F2GqPcB686qvOsBuowxlKik5AVusx/fNvGn8kgFiOp
         fy/A==
X-Forwarded-Encrypted: i=1; AKwUvBxT9XrC9T5Gb6Q0h/holWoPZu6pQkP5tOKB2eQSoA7QSSZFHNqXPcidHqmpNemyU3Wo5+/iXomBjK3M@vger.kernel.org
X-Gm-Message-State: AFuF++k6GvYjFyktvqpBX0iT0MUWEyIPlGA2OqvkFh/Wg17RAfu2vkFj
	DldsXgZD/2i1tZWsagI/KvwCd9kTlB1yDGnn8ERU7L0KwFEjxZwpRgTu
X-Gm-Gg: AYBFou3thgVaxQXfQKphugmiqlKCG6PzrEy1vLFiYJFLAwTR2uD57I2L3GsuWqP8E5M
	AecsqWQH8zdMsQylVvDLY6jLtYFLsh7+YVhNcWiEaq9KUty+g96pFz60CbPsqknWmDZQAjv6SyQ
	hurhu9Syc5CFJUEi3x6T6bXG5htAJiy0L5gETUz+3pSnY+z+ptcQ/uBvdhRiNOQ528NSMVdEtNS
	qd3z0kLbmLC9uwur875FhJLiVCW0WnYfi1CIKCN/aFDvuOLIBAJsBZkDA7qze6L5cEGdSS6Z2bu
	792GX2wWbSHzMTmfL9KA0SUzROxmKdLgFwAd8Cc4uV+R3Vj1W2TxPMtiGRkYor2a9Gubrg5u4Lv
	Qq55hR8vkkvQntd//d4EUCsSUuQD1eP3Mp9KPvM6gMrjgaBcH9mR0Y8mzHt48JJjgfOv5Owp4Fg
	s/Tw5k6WNhPt1jzBs0jYY3tUIM1Ldz3jHNVavtp19J26TGw8A0WatZyyf8JEHOOv8MvA==
X-Received: by 2002:a17:90b:1dcb:b0:398:dcf6:d40e with SMTP id 98e67ed59e1d1-39907db4f46mr13889642a91.17.1788273581712;
        Tue, 01 Sep 2026 07:39:41 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0dfcd65sm59248a91.3.2026.09.01.07.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:39:41 -0700 (PDT)
Subject:
 [PATCH RFC 1/1] leds: add ASUS Aura SCSI driver for ROG NVMe enclosures
Date: Tue, 01 Sep 2026 22:34:34 +0800
Message-ID: <202609012200.RFC1.lhw@gmail.com>
In-Reply-To: <202609012200.RFC0.lhw@gmail.com>
References: <202609012200.RFC0.lhw@gmail.com>
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
write (GOOD status, no error). Build the block request by hand and
force cmd_len =3D 16, mirroring what SG_IO does from userspace.

This is the monolithic out-of-tree version as verified on hardware;
the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
into a SCSI transport helper and a shared ASUS Aura LED interface.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>

---
------------------------------------------------------------------------
 drivers/leds/leds-asus-aura-scsi.c | 302 ++++++++++
 1 file changed, 302 insertions(+)
------------------------------------------------------------------------

diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura=
-scsi.c
new file mode 100644
index 000000000000..111111111111
--- /dev/null
+++ b/drivers/leds/leds-asus-aura-scsi.c
@@ -0,0 +1,302 @@
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
+ * Uses brightness_set (non-blocking LED core fast path) + a work_struct
+ * for the sleeping block-request vendor CDB send.
+ *
+ * CDB length: scsi_execute_cmd() sizes the CDB via scsi_command_size(opcode=
),
+ * which maps vendor opcode 0xec to 10 bytes. The ENE protocol uses a 16-byte
+ * CDB with the data length in cdb[13], so scsi_execute_cmd() drops cdb[13]
+ * and the device silently ignores the write. We build the request by hand
+ * and force cmd_len =3D 16 (what SG_IO does from userspace).
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
+	struct work_struct	work;
+};
+
+struct asus_aura_zone {
+	struct scsi_device	*sdev;
+	struct asus_aura_led	leds[ARION_NUM_LEDS];
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
+/* Raw block request so we can force cmd_len=3D16 (see file header). */
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
+	rq =3D blk_mq_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	scmd =3D blk_mq_rq_to_pdu(rq);
+	scmd->cmd_len =3D ENE_CDB_LEN;
+	memcpy(scmd->cmnd, cdb, ENE_CDB_LEN);
+
+	if (arg_count) {
+		ret =3D blk_rq_map_kern(rq,
+				      (void *)data, arg_count, GFP_KERNEL);
+		if (ret)
+			goto out;
+	}
+
+	blk_execute_rq(rq, true);
+	ret =3D scmd->result;
+out:
+	blk_mq_free_request(rq);
+	return ret;
+}
+
+/* Sleepable: runs on the system workqueue. Writes one LED's slot. */
+static void asus_aura_led_work(struct work_struct *work)
+{
+	struct asus_aura_led *led =3D
+		container_of(work, struct asus_aura_led, work);
+	struct scsi_device *sdev =3D led->zone->sdev;
+	u8 apply =3D ENE_APPLY;
+	u8 save =3D ENE_SAVE;
+	u8 mode =3D ENE_MODE_STATIC;
+	int ret;
+
+	if (!scsi_device_online(sdev))
+		return;
+
+	/* Mode first: without it the device ignores the whole sequence. */
+	ret =3D ene_write(sdev, ENE_REG_MODE, &mode, 1);
+	if (ret)
+		goto err;
+
+	ret =3D ene_write(sdev, ENE_REG_COLORS + led->index * ENE_RGB_LEN,
+			led->rgb, ENE_RGB_LEN);
+	if (ret)
+		goto err;
+
+	/*
+	 * Cover the DIRECT colour set too; some firmware revisions pull
+	 * from 0x8100 instead of 0x8160.
+	 */
+	ret =3D ene_write(sdev, ENE_REG_COLORS_DIRECT + led->index * ENE_RGB_LEN,
+			led->rgb, ENE_RGB_LEN);
+	if (ret)
+		goto err;
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
+		"asus_aura: led%d write failed: %d\n", led->index, ret);
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
+	schedule_work(&led->work);
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
+	INIT_WORK(&led->work, asus_aura_led_work);
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
+
+	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
+		ret =3D asus_aura_register_led(zone, i);
+		if (ret)
+			goto err_free;
+	}
+
+	sdev->handler_data =3D zone;
+	sdev_printk(KERN_INFO, sdev,
+		    "asus_aura: %d per-LED multicolor LEDs registered\n",
+		    ARION_NUM_LEDS);
+	return SCSI_DH_OK;
+
+err_free:
+	while (i--) {
+		cancel_work_sync(&zone->leds[i].work);
+		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);
+		kfree(zone->leds[i].mc_cdev.led_cdev.name);
+	}
+	kfree(zone);
+	return SCSI_DH_NOMEM;
+}
+
+static void asus_aura_detach(struct scsi_device *sdev)
+{
+	struct asus_aura_zone *zone =3D sdev->handler_data;
+	int i;
+
+	if (!zone)
+		return;
+	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
+		cancel_work_sync(&zone->leds[i].work);
+		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);
+		kfree(zone->leds[i].mc_cdev.led_cdev.name);
+	}
+	kfree(zone);
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

