From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/6] ps3: Storage device registration routines.
Date: Wed, 04 Jul 2007 15:22:15 +0200
Message-ID: <20070704132346.389168000@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46185 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759854AbXGDNYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 09:24:52 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_probe.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>

Add support for storage devices to the device probe code.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
v2:
  - use msleep() instead of schedule_timeout()

 arch/powerpc/platforms/ps3/device-init.c |  286 ++++++++++++++++++++++=
+++++++++
 1 files changed, 286 insertions(+)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -26,6 +26,7 @@
=20
 #include <asm/firmware.h>
 #include <asm/lv1call.h>
+#include <asm/ps3stor.h>
=20
 #include "platform.h"
=20
@@ -237,6 +238,262 @@ static int __init ps3_setup_vuart_device
 	return result;
 }
=20
+static int ps3stor_wait_for_completion(u64 dev_id, u64 tag,
+				       unsigned int timeout)
+{
+	int result =3D -1;
+	unsigned int retries =3D 0;
+	u64 status;
+
+	for (retries =3D 0; retries < timeout; retries++) {
+		result =3D lv1_storage_check_async_status(dev_id, tag, &status);
+		if (!result)
+			break;
+
+		msleep(1);
+	}
+
+	if (result)
+		pr_debug("%s:%u: check_async_status: %s, status %lx\n",
+			 __func__, __LINE__, ps3_result(result), status);
+
+	return result;
+}
+
+/**
+ * ps3_storage_wait_for_device - Wait for a storage device to become r=
eady.
+ * @repo: The repository device to wait for.
+ *
+ * Uses the hypervisor's storage device notification mechanism to wait=
 until
+ * a storage device is ready.  The device notification mechanism uses =
a
+ * psuedo device (id =3D -1) to asynchronously notify the guest when s=
torage
+ * devices become ready.  The notification device has a block size of =
512
+ * bytes.
+ */
+
+static int ps3_storage_wait_for_device(const struct ps3_repository_dev=
ice *repo)
+{
+	int result;
+	const u64 notification_dev_id =3D (u64)-1LL;
+	const unsigned int timeout =3D HZ;
+	u64 lpar;
+	u64 tag;
+	struct {
+		u64 operation_code;	/* must be zero */
+		u64 event_mask;		/* 1 =3D device ready */
+	} *notify_cmd;
+	struct {
+		u64 event_type;		/* notify_device_ready */
+		u64 bus_id;
+		u64 dev_id;
+		u64 dev_type;
+		u64 dev_port;
+	} *notify_event;
+	enum {
+		notify_device_ready =3D 1
+	};
+
+	pr_debug(" -> %s:%u: bus_id %u, dev_id %u, dev_type %u\n", __func__,
+		 __LINE__, repo->bus_id, repo->dev_id, repo->dev_type);
+
+	notify_cmd =3D kzalloc(512, GFP_KERNEL);
+	notify_event =3D (void *)notify_cmd;
+	if (!notify_cmd)
+		return -ENOMEM;
+
+	lpar =3D ps3_mm_phys_to_lpar(__pa(notify_cmd));
+
+	result =3D lv1_open_device(repo->bus_id, notification_dev_id, 0);
+	if (result) {
+		printk(KERN_ERR "%s:%u: lv1_open_device %s\n", __func__,
+		       __LINE__, ps3_result(result));
+		result =3D -ENODEV;
+		goto fail_free;
+	}
+
+	/* Setup and write the request for device notification. */
+
+	notify_cmd->operation_code =3D 0;	/* must be zero */
+	notify_cmd->event_mask =3D 0x01;	/* device ready */
+
+	result =3D lv1_storage_write(notification_dev_id, 0, 0, 1, 0, lpar,
+				   &tag);
+	if (result) {
+		printk(KERN_ERR "%s:%u: write failed %s\n", __func__, __LINE__,
+		       ps3_result(result));
+		result =3D -ENODEV;
+		goto fail_close;
+	}
+
+	/* Wait for the write completion */
+
+	result =3D ps3stor_wait_for_completion(notification_dev_id, tag,
+					     timeout);
+	if (result) {
+		printk(KERN_ERR "%s:%u: write not completed %s\n", __func__,
+		       __LINE__, ps3_result(result));
+		result =3D -ENODEV;
+		goto fail_close;
+	}
+
+	/* Loop here processing the requested notification events. */
+
+	result =3D -ENODEV;
+	while (1) {
+		memset(notify_event, 0, sizeof(*notify_event));
+
+		result =3D lv1_storage_read(notification_dev_id, 0, 0, 1, 0,
+					  lpar, &tag);
+		if (result) {
+			printk(KERN_ERR "%s:%u: write failed %s\n", __func__,
+			       __LINE__, ps3_result(result));
+			break;
+		}
+
+		result =3D ps3stor_wait_for_completion(notification_dev_id, tag,
+						     timeout);
+		if (result) {
+			printk(KERN_ERR "%s:%u: read not completed %s\n",
+			       __func__, __LINE__, ps3_result(result));
+			break;
+		}
+
+		if (notify_event->event_type !=3D notify_device_ready ||
+		    notify_event->bus_id !=3D repo->bus_id) {
+			pr_debug("%s:%u: bad notify_event: event %lu, "
+				 "dev_id %lu, dev_type %lu\n",
+				 __func__, __LINE__, notify_event->event_type,
+				 notify_event->dev_id, notify_event->dev_type);
+			break;
+		}
+
+		if (notify_event->dev_id =3D=3D repo->dev_id &&
+		    notify_event->dev_type =3D=3D repo->dev_type) {
+			pr_debug("%s:%u: device ready: dev_id %u\n", __func__,
+				 __LINE__, repo->dev_id);
+			result =3D 0;
+			break;
+		}
+
+		if (notify_event->dev_id =3D=3D repo->dev_id &&
+		    notify_event->dev_type =3D=3D PS3_DEV_TYPE_NOACCESS) {
+			pr_debug("%s:%u: no access: dev_id %u\n", __func__,
+				 __LINE__, repo->dev_id);
+			break;
+		}
+	}
+
+fail_close:
+	lv1_close_device(repo->bus_id, notification_dev_id);
+fail_free:
+	kfree(notify_cmd);
+	pr_debug(" <- %s:%u\n", __func__, __LINE__);
+	return result;
+}
+
+static int ps3_setup_storage_dev(const struct ps3_repository_device *r=
epo,
+				 enum ps3_match_id match_id)
+{
+	int result;
+	struct ps3_storage_device *p;
+	u64 port, blk_size, num_blocks;
+	unsigned int num_regions, i;
+
+	pr_debug(" -> %s:%u: match_id %u\n", __func__, __LINE__, match_id);
+
+	result =3D ps3_repository_read_stor_dev_info(repo->bus_index,
+						   repo->dev_index, &port,
+						   &blk_size, &num_blocks,
+						   &num_regions);
+	if (result) {
+		printk(KERN_ERR "%s:%u: _read_stor_dev_info failed %d\n",
+		       __func__, __LINE__, result);
+		return -ENODEV;
+	}
+
+	pr_debug("%s:%u: index %u:%u: port %lu blk_size %lu num_blocks %lu "
+		 "num_regions %u\n", __func__, __LINE__, repo->bus_index,
+		 repo->dev_index, port, blk_size, num_blocks, num_regions);
+
+	p =3D kzalloc(sizeof(struct ps3_storage_device) +
+		    num_regions * sizeof(struct ps3_storage_region),
+		    GFP_KERNEL);
+	if (!p) {
+		result =3D -ENOMEM;
+		goto fail_malloc;
+	}
+
+	p->sbd.match_id =3D match_id;
+	p->sbd.dev_type =3D PS3_DEVICE_TYPE_SB;
+	p->sbd.bus_id =3D repo->bus_id;
+	p->sbd.dev_id =3D repo->dev_id;
+	p->sbd.d_region =3D &p->dma_region;
+	p->blk_size =3D blk_size;
+	p->num_regions =3D num_regions;
+
+	result =3D ps3_repository_find_interrupt(repo,
+					       PS3_INTERRUPT_TYPE_EVENT_PORT,
+					       &p->sbd.interrupt_id);
+	if (result) {
+		printk(KERN_ERR "%s:%u: find_interrupt failed %d\n", __func__,
+		       __LINE__, result);
+		result =3D -ENODEV;
+		goto fail_find_interrupt;
+	}
+
+	/* FIXME: Arrange to only do this on a 'cold' boot */
+
+	result =3D ps3_storage_wait_for_device(repo);
+	if (result) {
+		printk(KERN_ERR "%s:%u: storage_notification failed %d\n",
+		       __func__, __LINE__, result);
+		result =3D -ENODEV;
+		goto fail_probe_notification;
+	}
+
+	for (i =3D 0; i < num_regions; i++) {
+		unsigned int id;
+		u64 start, size;
+
+		result =3D ps3_repository_read_stor_dev_region(repo->bus_index,
+							     repo->dev_index,
+							     i, &id, &start,
+							     &size);
+		if (result) {
+			printk(KERN_ERR
+			       "%s:%u: read_stor_dev_region failed %d\n",
+			       __func__, __LINE__, result);
+			result =3D -ENODEV;
+			goto fail_read_region;
+		}
+		pr_debug("%s:%u: region %u: id %u start %lu size %lu\n",
+			 __func__, __LINE__, i, id, start, size);
+
+		p->regions[i].id =3D id;
+		p->regions[i].start =3D start;
+		p->regions[i].size =3D size;
+	}
+
+	result =3D ps3_system_bus_device_register(&p->sbd);
+	if (result) {
+		pr_debug("%s:%u ps3_system_bus_device_register failed\n",
+			 __func__, __LINE__);
+		goto fail_device_register;
+	}
+
+	pr_debug(" <- %s:%u\n", __func__, __LINE__);
+	return 0;
+
+fail_device_register:
+fail_read_region:
+fail_probe_notification:
+fail_find_interrupt:
+	kfree(p);
+fail_malloc:
+	pr_debug(" <- %s:%u: fail.\n", __func__, __LINE__);
+	return result;
+}
+
 static int __init ps3_register_vuart_devices(void)
 {
 	int result;
@@ -356,6 +613,35 @@ static int ps3_register_repository_devic
 				__func__, __LINE__);
 		}
 		break;
+	case PS3_DEV_TYPE_STOR_DISK:
+		result =3D ps3_setup_storage_dev(repo, PS3_MATCH_ID_STOR_DISK);
+
+		/* Some devices are not accessable from the Other OS lpar. */
+		if (result =3D=3D -ENODEV) {
+			result =3D 0;
+			pr_debug("%s:%u: not accessable\n", __func__,
+				 __LINE__);
+		}
+
+		if (result)
+			pr_debug("%s:%u ps3_setup_storage_dev failed\n",
+				 __func__, __LINE__);
+		break;
+
+	case PS3_DEV_TYPE_STOR_ROM:
+		result =3D ps3_setup_storage_dev(repo, PS3_MATCH_ID_STOR_ROM);
+		if (result)
+			pr_debug("%s:%u ps3_setup_storage_dev failed\n",
+				 __func__, __LINE__);
+		break;
+
+	case PS3_DEV_TYPE_STOR_FLASH:
+		result =3D ps3_setup_storage_dev(repo, PS3_MATCH_ID_STOR_FLASH);
+		if (result)
+			pr_debug("%s:%u ps3_setup_storage_dev failed\n",
+				 __func__, __LINE__);
+		break;
+
 	default:
 		result =3D 0;
 		pr_debug("%s:%u: unsupported dev_type %u\n", __func__, __LINE__,

--=20
With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
=46ax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Be=
lgium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
=46ortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
