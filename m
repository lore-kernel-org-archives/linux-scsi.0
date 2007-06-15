From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 2/6] ps3: Storage Driver Core
Date: Fri, 15 Jun 2007 13:39:21 +0200
Message-ID: <20070615120848.103104000@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49680 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753792AbXFOMLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:23 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_bus.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add storage driver core support for the PS3.
PS3 storage devices are a special kind of PS3 system bus devices

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
Changes since previous submission:
  - Remove the `name' parameters of ps3stor_setup(), as it can be obtai=
ned from
    the driver structure
  - Cleanup struct ps3_storage_device

 arch/powerpc/platforms/ps3/Kconfig |    4=20
 drivers/ps3/Makefile               |    1=20
 drivers/ps3/ps3stor_lib.c          |  326 ++++++++++++++++++++++++++++=
+++++++++
 include/asm-powerpc/ps3stor.h      |   70 +++++++
 4 files changed, 401 insertions(+)

--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -98,4 +98,8 @@ config PS3_SYS_MANAGER
 	  This support is required for system control.  In
 	  general, all users will say Y or M.
=20
+config PS3_STORAGE
+	depends on PPC_PS3
+	tristate
+
 endmenu
--- a/drivers/ps3/Makefile
+++ b/drivers/ps3/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_PS3_PS3AV) +=3D ps3av_mod.o
 ps3av_mod-objs		+=3D ps3av.o ps3av_cmd.o
 obj-$(CONFIG_PPC_PS3) +=3D sys-manager-core.o
 obj-$(CONFIG_PS3_SYS_MANAGER) +=3D sys-manager.o
+obj-$(CONFIG_PS3_STORAGE) +=3D ps3stor_lib.o
--- /dev/null
+++ b/drivers/ps3/ps3stor_lib.c
@@ -0,0 +1,326 @@
+/*
+ * PS3 Storage Library
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long
+ * with this program; if not, write to the Free Software Foundation, I=
nc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+
+#include <asm/lv1call.h>
+#include <asm/ps3stor.h>
+
+
+static irqreturn_t ps3stor_interrupt(int irq, void *data)
+{
+	struct ps3_storage_device *dev =3D data;
+	int res;
+	u64 tag, status;
+
+	res =3D lv1_storage_get_async_status(dev->sbd.dev_id, &tag, &status);
+
+	if (tag !=3D dev->tag)
+		dev_err(&dev->sbd.core,
+			"%s:%u: tag mismatch, got %lx, expected %lx\n",
+			__func__, __LINE__, tag, dev->tag);
+
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: res=3D%d status=3D0x%lx\n",
+			__func__, __LINE__, res, status);
+	} else {
+		dev->lv1_status =3D status;
+		complete(&dev->done);
+	}
+	return IRQ_HANDLED;
+}
+
+
+static int ps3stor_probe_access(struct ps3_storage_device *dev)
+{
+	int res, error;
+	unsigned int i;
+	unsigned long n;
+
+	if (dev->sbd.match_id =3D=3D PS3_MATCH_ID_STOR_ROM) {
+		/* special case: CD-ROM is assumed always accessible */
+		dev->accessible_regions =3D 1;
+		return 0;
+	}
+
+	error =3D -EPERM;
+	for (i =3D 0; i < dev->num_regions; i++) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: checking accessibility of region %u\n",
+			__func__, __LINE__, i);
+
+		dev->region_idx =3D i;
+		res =3D ps3stor_read_write_sectors(dev, dev->bounce_lpar, 0, 1,
+						 0);
+		if (res) {
+			dev_dbg(&dev->sbd.core, "%s:%u: read failed, "
+				"region %u is not accessible\n", __func__,
+				__LINE__, i);
+			continue;
+		}
+
+		dev_dbg(&dev->sbd.core, "%s:%u: region %u is accessible\n",
+			__func__, __LINE__, i);
+		set_bit(i, &dev->accessible_regions);
+
+		/* We can access at least one region */
+		error =3D 0;
+	}
+	if (error)
+		return error;
+
+	n =3D hweight_long(dev->accessible_regions);
+	if (n > 1)
+		dev_info(&dev->sbd.core,
+			 "%s:%u: %lu accessible regions found. Only the first "
+			 "one will be used",
+			 __func__, __LINE__, n);
+	dev->region_idx =3D __ffs(dev->accessible_regions);
+	dev_info(&dev->sbd.core,
+		 "First accessible region has index %u start %lu size %lu\n",
+		 dev->region_idx, dev->regions[dev->region_idx].start,
+		 dev->regions[dev->region_idx].size);
+
+	return 0;
+}
+
+
+/**
+ *	ps3stor_setup - Setup a storage device before use
+ *	@dev: Pointer to a struct ps3_storage_device
+ *
+ *	Returns 0 for success, or an error code
+ */
+int ps3stor_setup(struct ps3_storage_device *dev)
+{
+	int error, res, alignment;
+	enum ps3_dma_page_size page_size;
+
+	error =3D ps3_open_hv_device(&dev->sbd);
+	if (error) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_open_hv_device failed %d\n", __func__,
+			__LINE__, error);
+		goto fail;
+	}
+
+	error =3D ps3_sb_event_receive_port_setup(&dev->sbd, PS3_BINDING_CPU_=
ANY,
+						&dev->irq);
+	if (error) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_sb_event_receive_port_setup failed %d\n",
+		       __func__, __LINE__, error);
+		goto fail_close_device;
+	}
+
+	error =3D request_irq(dev->irq, ps3stor_interrupt, IRQF_DISABLED,
+			    dev->sbd.core.driver->name, dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
+			__func__, __LINE__, error);
+		goto fail_sb_event_receive_port_destroy;
+	}
+
+	alignment =3D min(__ffs(dev->bounce_size),
+			__ffs((unsigned long)dev->bounce_buf));
+	if (alignment < 12) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: bounce buffer not aligned (%lx at 0x%p)\n",
+			__func__, __LINE__, dev->bounce_size, dev->bounce_buf);
+		error =3D -EINVAL;
+		goto fail_free_irq;
+	} else if (alignment < 16)
+		page_size =3D PS3_DMA_4K;
+	else
+		page_size =3D PS3_DMA_64K;
+	dev->sbd.d_region =3D &dev->dma_region;
+	ps3_dma_region_init(&dev->sbd, &dev->dma_region, page_size,
+			    PS3_DMA_OTHER, dev->bounce_buf, dev->bounce_size);
+	res =3D ps3_dma_region_create(&dev->dma_region);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: cannot create DMA region\n",
+			__func__, __LINE__);
+		error =3D -ENOMEM;
+		goto fail_free_irq;
+	}
+
+	dev->bounce_lpar =3D ps3_mm_phys_to_lpar(__pa(dev->bounce_buf));
+	dev->bounce_dma =3D dma_map_single(&dev->sbd.core, dev->bounce_buf,
+					 dev->bounce_size, DMA_BIDIRECTIONAL);
+	if (!dev->bounce_dma) {
+		dev_err(&dev->sbd.core, "%s:%u: map DMA region failed\n",
+			__func__, __LINE__);
+		error =3D -ENODEV;
+		goto fail_free_dma;
+	}
+
+	error =3D ps3stor_probe_access(dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: No accessible regions found\n",
+			__func__, __LINE__);
+		goto fail_unmap_dma;
+	}
+	return 0;
+
+fail_unmap_dma:
+	dma_unmap_single(&dev->sbd.core, dev->bounce_dma, dev->bounce_size,
+			 DMA_BIDIRECTIONAL);
+fail_free_dma:
+	ps3_dma_region_free(&dev->dma_region);
+fail_free_irq:
+	free_irq(dev->irq, dev);
+fail_sb_event_receive_port_destroy:
+	ps3_sb_event_receive_port_destroy(&dev->sbd, dev->irq);
+fail_close_device:
+	ps3_close_hv_device(&dev->sbd);
+fail:
+	return error;
+}
+EXPORT_SYMBOL_GPL(ps3stor_setup);
+
+
+/**
+ *	ps3stor_teardown - Tear down a storage device after use
+ *	@dev: Pointer to a struct ps3_storage_device
+ */
+void ps3stor_teardown(struct ps3_storage_device *dev)
+{
+	int error;
+
+	dma_unmap_single(&dev->sbd.core, dev->bounce_dma, dev->bounce_size,
+			 DMA_BIDIRECTIONAL);
+	ps3_dma_region_free(&dev->dma_region);
+
+	free_irq(dev->irq, dev);
+
+	error =3D ps3_sb_event_receive_port_destroy(&dev->sbd, dev->irq);
+	if (error)
+		dev_err(&dev->sbd.core,
+			"%s:%u: destroy event receive port failed %d\n",
+			__func__, __LINE__, error);
+
+	error =3D ps3_close_hv_device(&dev->sbd);
+	if (error)
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_close_hv_device failed %d\n", __func__,
+			__LINE__, error);
+}
+EXPORT_SYMBOL_GPL(ps3stor_teardown);
+
+
+/**
+ *	ps3stor_read_write_sectors - read/write from/to a storage device
+ *	@dev: Pointer to a struct ps3_storage_device
+ *	@lpar: HV logical partition address
+ *	@start_sector: First sector to read/write
+ *	@sectors: Number of sectors to read/write
+ *	@write: Flag indicating write (non-zero) or read (zero)
+ *
+ *	Returns 0 for success, -1 in case of failure to submit the command,=
 or
+ *	an LV1 status value in case of other errors
+ */
+u64 ps3stor_read_write_sectors(struct ps3_storage_device *dev, u64 lpa=
r,
+			       u64 start_sector, u64 sectors, int write)
+{
+	unsigned int region_id =3D dev->regions[dev->region_idx].id;
+	const char *op =3D write ? "write" : "read";
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
+		__func__, __LINE__, op, sectors, start_sector);
+
+	init_completion(&dev->done);
+	res =3D write ? lv1_storage_write(dev->sbd.dev_id, region_id,
+					start_sector, sectors, 0, lpar,
+					&dev->tag)
+		    : lv1_storage_read(dev->sbd.dev_id, region_id,
+				       start_sector, sectors, 0, lpar,
+				       &dev->tag);
+	if (res) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
+			__LINE__, op, res);
+		return -1;
+	}
+
+	wait_for_completion(&dev->done);
+	if (dev->lv1_status) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
+			__LINE__, op, dev->lv1_status);
+		return dev->lv1_status;
+	}
+
+	dev_dbg(&dev->sbd.core, "%s:%u: %s completed\n", __func__, __LINE__,
+		op);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3stor_read_write_sectors);
+
+
+/**
+ *	ps3stor_send_command - send a device command to a storage device
+ *	@dev: Pointer to a struct ps3_storage_device
+ *	@cmd: Command number
+ *	@arg1: First command argument
+ *	@arg2: Second command argument
+ *	@arg3: Third command argument
+ *	@arg4: Fourth command argument
+ *
+ *	Returns 0 for success, -1 in case of failure to submit the command,=
 or
+ *	an LV1 status value in case of other errors
+ */
+u64 ps3stor_send_command(struct ps3_storage_device *dev, u64 cmd, u64 =
arg1,
+			 u64 arg2, u64 arg3, u64 arg4)
+{
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: send device command 0x%lx\n", __func_=
_,
+		__LINE__, cmd);
+
+	init_completion(&dev->done);
+
+	res =3D lv1_storage_send_device_command(dev->sbd.dev_id, cmd, arg1,
+					      arg2, arg3, arg4, &dev->tag);
+	if (res) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: send_device_command 0x%lx failed %d\n",
+			__func__, __LINE__, cmd, res);
+		return -1;
+	}
+
+	wait_for_completion(&dev->done);
+	if (dev->lv1_status) {
+		dev_dbg(&dev->sbd.core, "%s:%u: command 0x%lx failed 0x%lx\n",
+			__func__, __LINE__, cmd, dev->lv1_status);
+		return dev->lv1_status;
+	}
+
+	dev_dbg(&dev->sbd.core, "%s:%u: command 0x%lx completed\n", __func__,
+		__LINE__, cmd);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3stor_send_command);
+
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PS3 Storage Bus Library");
+MODULE_AUTHOR("Sony Corporation");
--- /dev/null
+++ b/include/asm-powerpc/ps3stor.h
@@ -0,0 +1,70 @@
+/*
+ * PS3 Storage Devices
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long
+ * with this program; if not, write to the Free Software Foundation, I=
nc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _ASM_POWERPC_PS3STOR_H_
+#define _ASM_POWERPC_PS3STOR_H_
+
+#include <linux/irqreturn.h>
+
+#include <asm/ps3.h>
+
+
+struct ps3_storage_region {
+	unsigned int id;
+	u64 start;
+	u64 size;
+};
+
+struct ps3_storage_device {
+	struct ps3_system_bus_device sbd;
+
+	struct ps3_dma_region dma_region;
+	unsigned int irq;
+	u64 blk_size;
+
+	u64 tag;
+	u64 lv1_status;
+	struct completion done;
+
+	unsigned long bounce_size;
+	void *bounce_buf;
+	u64 bounce_lpar;
+	dma_addr_t bounce_dma;
+
+	unsigned int num_regions;
+	unsigned long accessible_regions;
+	unsigned int region_idx;		/* first accessible region */
+	struct ps3_storage_region regions[0];	/* Must be last */
+};
+
+static inline struct ps3_storage_device *to_ps3_storage_device(struct =
device *dev)
+{
+	return container_of(dev, struct ps3_storage_device, sbd.core);
+}
+
+extern int ps3stor_setup(struct ps3_storage_device *dev);
+extern void ps3stor_teardown(struct ps3_storage_device *dev);
+extern u64 ps3stor_read_write_sectors(struct ps3_storage_device *dev, =
u64 lpar,
+				      u64 start_sector, u64 sectors,
+				      int write);
+extern u64 ps3stor_send_command(struct ps3_storage_device *dev, u64 cm=
d,
+				u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+
+#endif /* _ASM_POWERPC_PS3STOR_H_ */

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
