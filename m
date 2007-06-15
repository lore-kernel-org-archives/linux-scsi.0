From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 6/6] ps3: FLASH ROM Storage Driver
Date: Fri, 15 Jun 2007 13:39:25 +0200
Message-ID: <20070615120848.558678000@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49693 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753527AbXFOMLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:24 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_flash.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a FLASH ROM Storage Driver for the PS3:
  - Implemented as a misc character device driver
  - Uses a fixed 256 KiB buffer allocated from boot memory as the hyper=
visor
    requires the writing of aligned 256 KiB blocks

CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Changes since previous submission:
      o Don't use `default y' in Kconfig
      o #include <linux/uaccess.h> instead of <asm/uaccess.h>
      o Set up sysfs links between misc character device and PS3 system=
 device:
	  . /sys/class/misc/ps3flash/device -> ../../../devices/ps3_system/sb_=
01
	  . /sys/devices/ps3_system/sb_01/misc:ps3flash -> ../../../class/misc=
/ps3flash

 arch/powerpc/platforms/ps3/Kconfig |   11 +
 drivers/char/Makefile              |    2=20
 drivers/char/ps3flash.c            |  404 ++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 417 insertions(+)

--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -122,4 +122,15 @@ config PS3_ROM
 	  This support is required to access the PS3 BD/DVD/CD-ROM drive.
 	  In general, all users will say Y or M.
=20
+config PS3_FLASH
+	tristate "PS3 FLASH ROM Storage Driver"
+	depends on PPC_PS3
+	select PS3_STORAGE
+	help
+	  Include support for the PS3 FLASH ROM Storage.
+
+	  This support is required to access the PS3 FLASH ROM, which
+	  contains the boot loader and some boot options.
+	  In general, all users will say Y or M.
+
 endmenu
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -104,6 +104,8 @@ obj-$(CONFIG_IPMI_HANDLER)	+=3D ipmi/
 obj-$(CONFIG_HANGCHECK_TIMER)	+=3D hangcheck-timer.o
 obj-$(CONFIG_TCG_TPM)		+=3D tpm/
=20
+obj-$(CONFIG_PS3_FLASH)		+=3D ps3flash.o
+
 # Files generated that shall be removed upon make clean
 clean-files :=3D consolemap_deftbl.c defkeymap.c
=20
--- /dev/null
+++ b/drivers/char/ps3flash.c
@@ -0,0 +1,404 @@
+/*
+ * PS3 FLASH ROM Storage Driver
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
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+
+#include <asm/ps3stor.h>
+
+
+#define DEVICE_NAME		"ps3flash"
+
+#define FLASH_BLOCK_SIZE	(256*1024)
+
+
+struct ps3flash_private {
+	struct mutex mutex;	/* Bounce buffer mutex */
+};
+#define ps3flash_priv(dev)	((dev)->sbd.core.driver_data)
+
+static struct ps3_storage_device *ps3flash_dev;
+
+static ssize_t ps3flash_read_write_sectors(struct ps3_storage_device *=
dev,
+					   u64 lpar, u64 start_sector,
+					   u64 sectors, int write)
+{
+	const char *op =3D write ? "write" : "read";
+	u64 res =3D ps3stor_read_write_sectors(dev, lpar, start_sector, secto=
rs,
+					     write);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
+			__LINE__, op, res);
+		return -EIO;
+	}
+	return sectors;
+}
+
+static ssize_t ps3flash_read_sectors(struct ps3_storage_device *dev,
+				     u64 start_sector, u64 sectors,
+				     unsigned int sector_offset)
+{
+	u64 max_sectors, lpar;
+
+	max_sectors =3D dev->bounce_size / dev->blk_size;
+	if (sectors > max_sectors) {
+		dev_dbg(&dev->sbd.core, "%s:%u Limiting sectors to %lu\n",
+			__func__, __LINE__, max_sectors);
+		sectors =3D max_sectors;
+	}
+
+	lpar =3D dev->bounce_lpar + sector_offset * dev->blk_size;
+	return ps3flash_read_write_sectors(dev, lpar, start_sector, sectors,
+					   0);
+}
+
+static ssize_t ps3flash_write_chunk(struct ps3_storage_device *dev,
+				    u64 start_sector)
+{
+       u64 sectors =3D dev->bounce_size / dev->blk_size;
+       return ps3flash_read_write_sectors(dev, dev->bounce_lpar, start=
_sector,
+					  sectors, 1);
+}
+
+static loff_t ps3flash_llseek(struct file *file, loff_t offset, int or=
igin)
+{
+	struct ps3_storage_device *dev =3D ps3flash_dev;
+	u64 size =3D dev->regions[dev->region_idx].size*dev->blk_size;
+
+	switch (origin) {
+	case 1:
+		offset +=3D file->f_pos;
+		break;
+	case 2:
+		offset +=3D size;
+		break;
+	}
+	if (offset < 0)
+		return -EINVAL;
+
+	file->f_pos =3D offset;
+	return file->f_pos;
+}
+
+static ssize_t ps3flash_read(struct file *file, char __user *buf, size=
_t count,
+			     loff_t *pos)
+{
+	struct ps3_storage_device *dev =3D ps3flash_dev;
+	struct ps3flash_private *priv =3D ps3flash_priv(dev);
+	u64 size, start_sector, end_sector, offset;
+	ssize_t sectors_read;
+	size_t remaining, n;
+
+	dev_dbg(&dev->sbd.core,
+		"%s:%u: Reading %zu bytes at position %lld to user 0x%p\n",
+		__func__, __LINE__, count, *pos, buf);
+
+	size =3D dev->regions[dev->region_idx].size*dev->blk_size;
+	if (*pos >=3D size || !count)
+		return 0;
+
+	if (*pos+count > size) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u Truncating count from %zu to %llu\n", __func__,
+			__LINE__, count, size - *pos);
+		count =3D size - *pos;
+	}
+
+	start_sector =3D do_div_llr(*pos, dev->blk_size, &offset);
+	end_sector =3D DIV_ROUND_UP(*pos+count, dev->blk_size);
+
+	remaining =3D count;
+	do {
+		mutex_lock(&priv->mutex);
+
+		sectors_read =3D ps3flash_read_sectors(dev, start_sector,
+						     end_sector-start_sector,
+						     0);
+		if (sectors_read < 0) {
+			mutex_unlock(&priv->mutex);
+			return sectors_read;
+		}
+
+		n =3D min(remaining, sectors_read*dev->blk_size-offset);
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: copy %lu bytes from 0x%p to user 0x%p\n",
+			__func__, __LINE__, n, dev->bounce_buf+offset, buf);
+		if (copy_to_user(buf, dev->bounce_buf+offset, n)) {
+			mutex_unlock(&priv->mutex);
+			return -EFAULT;
+		}
+
+		mutex_unlock(&priv->mutex);
+
+		*pos +=3D n;
+		buf +=3D n;
+		remaining -=3D n;
+		start_sector +=3D sectors_read;
+		offset =3D 0;
+	} while (remaining > 0);
+
+	return count;
+}
+
+static ssize_t ps3flash_write(struct file *file, const char __user *bu=
f,
+			      size_t count, loff_t *pos)
+{
+	struct ps3_storage_device *dev =3D ps3flash_dev;
+	struct ps3flash_private *priv =3D ps3flash_priv(dev);
+	u64 size, chunk_sectors, start_write_sector, end_write_sector,
+	    end_read_sector, start_read_sector, head, tail, offset;
+	ssize_t res;
+	size_t remaining, n;
+	unsigned int sec_off;
+
+	dev_dbg(&dev->sbd.core,
+		"%s:%u: Writing %zu bytes at position %lld from user 0x%p\n",
+		__func__, __LINE__, count, *pos, buf);
+
+	size =3D dev->regions[dev->region_idx].size*dev->blk_size;
+	if (*pos >=3D size || !count)
+		return 0;
+
+	if (*pos+count > size) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u Truncating count from %zu to %llu\n", __func__,
+			__LINE__, count, size - *pos);
+		count =3D size - *pos;
+	}
+
+	chunk_sectors =3D dev->bounce_size / dev->blk_size;
+
+	start_write_sector =3D do_div_llr(*pos, dev->bounce_size, &offset) *
+			     chunk_sectors;
+	end_write_sector =3D DIV_ROUND_UP(*pos+count, dev->bounce_size) *
+			   chunk_sectors;
+
+	end_read_sector =3D DIV_ROUND_UP(*pos, dev->blk_size);
+	start_read_sector =3D (*pos+count) / dev->blk_size;
+
+	/*
+	 * As we have to write in 256 KiB chunks, while we can read in blk_si=
ze
+	 * (usually 512 bytes) chunks, we perform the following steps:
+	 *   1. Read from start_write_sector to end_read_sector ("head")
+	 *   2. Read from start_read_sector to end_write_sector ("tail")
+	 *   3. Copy data to buffer
+	 *   4. Write from start_write_sector to end_write_sector
+	 * All of this is complicated by using only one 256 KiB bounce buffer=
=2E
+	 */
+
+	head =3D end_read_sector-start_write_sector;
+	tail =3D end_write_sector-start_read_sector;
+
+	remaining =3D count;
+	do {
+		mutex_lock(&priv->mutex);
+
+		if (end_read_sector >=3D start_read_sector) {
+			/* Merge head and tail */
+			dev_dbg(&dev->sbd.core,
+				"Merged head and tail: %lu sectors at %lu\n",
+				chunk_sectors, start_write_sector);
+			res =3D ps3flash_read_sectors(dev, start_write_sector,
+						    chunk_sectors, 0);
+			if (res < 0)
+				goto fail;
+		} else {
+			if (head) {
+				/* Read head */
+				dev_dbg(&dev->sbd.core,
+					"head: %lu sectors at %lu\n", head,
+					start_write_sector);
+				res =3D ps3flash_read_sectors(dev,
+							    start_write_sector,
+							    head, 0);
+				if (res < 0)
+					goto fail;
+			}
+			if (start_read_sector <
+			    start_write_sector+chunk_sectors) {
+				/* Read tail */
+				dev_dbg(&dev->sbd.core,
+					"tail: %lu sectors at %lu\n", tail,
+					start_read_sector);
+				sec_off =3D start_read_sector-start_write_sector;
+				res =3D ps3flash_read_sectors(dev,
+							    start_read_sector,
+							    tail, sec_off);
+				if (res < 0)
+					goto fail;
+			}
+		}
+
+		n =3D min(remaining, dev->bounce_size-offset);
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: copy %lu bytes from user 0x%p to 0x%p\n",
+			__func__, __LINE__, n, buf, dev->bounce_buf+offset);
+		if (copy_from_user(dev->bounce_buf+offset, buf, n)) {
+			res =3D -EFAULT;
+			goto fail;
+		}
+
+		res =3D ps3flash_write_chunk(dev, start_write_sector);
+		if (res < 0)
+			goto fail;
+
+		mutex_unlock(&priv->mutex);
+
+		*pos +=3D n;
+		buf +=3D n;
+		remaining -=3D n;
+		start_write_sector +=3D chunk_sectors;
+		head =3D 0;
+		offset =3D 0;
+	} while (remaining > 0);
+
+	return count;
+
+fail:
+	mutex_unlock(&priv->mutex);
+	return res;
+}
+
+
+static const struct file_operations ps3flash_fops =3D {
+	.owner	=3D THIS_MODULE,
+	.llseek	=3D ps3flash_llseek,
+	.read	=3D ps3flash_read,
+	.write	=3D ps3flash_write,
+};
+
+static struct miscdevice ps3flash_misc =3D {
+	.minor	=3D MISC_DYNAMIC_MINOR,
+	.name	=3D DEVICE_NAME,
+	.fops	=3D &ps3flash_fops,
+};
+
+static int __devinit ps3flash_probe(struct ps3_system_bus_device *_dev=
)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+	struct ps3flash_private *priv;
+	int error;
+	unsigned long tmp;
+
+	tmp =3D dev->regions[dev->region_idx].start*dev->blk_size;
+	if (tmp % FLASH_BLOCK_SIZE) {
+		dev_err(&dev->sbd.core,
+			"%s:%u region start %lu is not aligned\n", __func__,
+			__LINE__, tmp);
+		return -EINVAL;
+	}
+	tmp =3D dev->regions[dev->region_idx].size*dev->blk_size;
+	if (tmp % FLASH_BLOCK_SIZE) {
+		dev_err(&dev->sbd.core,
+			"%s:%u region size %lu is not aligned\n", __func__,
+			__LINE__, tmp);
+		return -EINVAL;
+	}
+
+	/* use static buffer, kmalloc cannot allocate 256 KiB */
+	if (!ps3flash_bounce_buffer.address)
+		return -ENOMEM;
+
+	if (ps3flash_dev) {
+		dev_err(&dev->sbd.core,
+			"Only one FLASH device is supported\n");
+		return -EBUSY;
+	}
+
+	ps3flash_dev =3D dev;
+
+	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		error =3D -ENOMEM;
+		goto fail;
+	}
+
+	ps3flash_priv(dev) =3D priv;
+	mutex_init(&priv->mutex);
+
+	dev->bounce_size =3D ps3flash_bounce_buffer.size;
+	dev->bounce_buf =3D ps3flash_bounce_buffer.address;
+
+	error =3D ps3stor_setup(dev);
+	if (error)
+		goto fail_free_priv;
+
+	ps3flash_misc.parent =3D &dev->sbd.core;
+	error =3D misc_register(&ps3flash_misc);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: misc_register failed %d\n",
+			__func__, __LINE__, error);
+		goto fail_teardown;
+	}
+
+	dev_info(&dev->sbd.core, "%s:%u: registered misc device %d\n",
+		 __func__, __LINE__, ps3flash_misc.minor);
+	return 0;
+
+fail_teardown:
+	ps3stor_teardown(dev);
+fail_free_priv:
+	kfree(priv);
+fail:
+	ps3flash_dev =3D NULL;
+	return error;
+}
+
+static int ps3flash_remove(struct ps3_system_bus_device *_dev)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+
+	misc_deregister(&ps3flash_misc);
+	ps3stor_teardown(dev);
+	kfree(ps3flash_priv(dev));
+	ps3flash_dev =3D NULL;
+	return 0;
+}
+
+
+static struct ps3_system_bus_driver ps3flash =3D {
+	.match_id	=3D PS3_MATCH_ID_STOR_FLASH,
+	.core.name	=3D DEVICE_NAME,
+	.core.owner	=3D THIS_MODULE,
+	.probe		=3D ps3flash_probe,
+	.remove		=3D ps3flash_remove,
+	.shutdown	=3D ps3flash_remove,
+};
+
+
+static int __init ps3flash_init(void)
+{
+	return ps3_system_bus_driver_register(&ps3flash);
+}
+
+static void __exit ps3flash_exit(void)
+{
+	ps3_system_bus_driver_unregister(&ps3flash);
+}
+
+module_init(ps3flash_init);
+module_exit(ps3flash_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PS3 FLASH ROM Storage Driver");
+MODULE_AUTHOR("Sony Corporation");
+MODULE_ALIAS(PS3_MODULE_ALIAS_STOR_FLASH);

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
