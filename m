From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] ses: add new Enclosure ULD
Date: Sun, 03 Feb 2008 15:48:56 -0600
Message-ID: <1202075336.3318.120.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55358 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYBCVtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 16:49:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>

This adds support to SCSI for enclosure services devices. It also makes
use of the enclosure services added in an earlier patch to display the
enclosure topology in sysfs.

At the moment, the enclosures are SAS specific, but if anyone actually
has a non-SAS enclosure that follows the SES-2 standard, we can add that
as well.

On my Vitesse based system, the enclosures show up like this:

sparkweed:~# ls -l /sys/class/enclosure/0\:0\:1\:0/
total 0
-r--r--r-- 1 root root 4096 2008-02-03 15:44 components
lrwxrwxrwx 1 root root    0 2008-02-03 15:44 device -> ../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:12/end_device-0:0:12/target0:0:1/0:0:1:0
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 000
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 001
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 002
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 003
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 004
drwxr-xr-x 2 root root    0 2008-02-03 15:44 SLOT 005
lrwxrwxrwx 1 root root    0 2008-02-03 15:44 subsystem -> ../../enclosure
--w------- 1 root root 4096 2008-02-03 15:44 uevent

And the individual occupied slots like this:

sparkweed:~# ls -l /sys/class/enclosure/0\:0\:1\:0/SLOT\ 001/
total 0
-rw-r--r-- 1 root root 4096 2008-02-03 15:45 active
lrwxrwxrwx 1 root root    0 2008-02-03 15:45 device -> ../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:11/end_device-0:0:11/target0:0:0/0:0:0:0
-rw-r--r-- 1 root root 4096 2008-02-03 15:45 fault
-rw-r--r-- 1 root root 4096 2008-02-03 15:45 locate
-rw-r--r-- 1 root root 4096 2008-02-03 15:45 status
lrwxrwxrwx 1 root root    0 2008-02-03 15:45 subsystem -> ../../../enclosure_component
-r--r--r-- 1 root root 4096 2008-02-03 15:45 type
--w------- 1 root root 4096 2008-02-03 15:45 uevent

You can flash the various blinky lights by echoing to the fault and locate files.

>From the device's point of view, you can see it has an enclosure like this:

sparkweed:~# ls /sys/class/scsi_disk/0\:0\:0\:0/device/
block:sda                     generic        queue_depth          state
bsg:0:0:0:0                   iocounterbits  queue_type           subsystem
bus                           iodone_cnt     rescan               timeout
delete                        ioerr_cnt      rev                  type
device_blocked                iorequest_cnt  scsi_device:0:0:0:0  uevent
driver                        modalias       scsi_disk:0:0:0:0    vendor
enclosure_component:SLOT 001  model          scsi_generic:sg0
evt_media_change              power          scsi_level

Note the enclosure_component:SLOT 001 which shows where in the enclosure
this device fits.

The astute will notice that I'm using SCSI VPD Inquiries to identify the
devices.  This, unfortunately, won't work for SATA devices unless we do
some really nasty hacking about on the SAT because the only think that
knows the SAS addresses for SATA devices is libsas, not libata where the
SAT resides.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/Kconfig  |   10 +-
 drivers/scsi/Makefile |    1 +
 drivers/scsi/ses.c    |  684 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 694 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/ses.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 0b243e0..7bc7b1a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -179,7 +179,15 @@ config CHR_DEV_SCH
 	  say M here and read <file:Documentation/kbuild/modules.txt> and
 	  <file:Documentation/scsi/scsi.txt>. The module will be called ch.o.
 	  If unsure, say N.
-	
+
+config SCSI_ENCLOSURE
+	tristate "SCSI Enclosure Support"
+	depends on SCSI && ENCLOSURE_SERVICES
+	help
+	  Enclosures are devices sitting on or in SCSI backplanes that
+	  manage devices.  If you have a disk cage, the chances are that
+	  it has an enclosure device.  Selecting this option will just allow
+	  certain enclosure conditions to be reported and is not required.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 93e1428..46370cb 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -138,6 +138,7 @@ obj-$(CONFIG_BLK_DEV_SD)	+= sd_mod.o
 obj-$(CONFIG_BLK_DEV_SR)	+= sr_mod.o
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
+obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
new file mode 100644
index 0000000..2656b2d
--- /dev/null
+++ b/drivers/scsi/ses.c
@@ -0,0 +1,684 @@
+/*
+ * SCSI Enclosure Services
+ *
+ * Copyright (C) 2008 James Bottomley <James.Bottomley@HansenPartnership.com>
+ *
+**-----------------------------------------------------------------------------
+**
+**  This program is free software; you can redistribute it and/or
+**  modify it under the terms of the GNU General Public License
+**  version 2 as published by the Free Software Foundation.
+**
+**  This program is distributed in the hope that it will be useful,
+**  but WITHOUT ANY WARRANTY; without even the implied warranty of
+**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+**  GNU General Public License for more details.
+**
+**  You should have received a copy of the GNU General Public License
+**  along with this program; if not, write to the Free Software
+**  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+**
+**-----------------------------------------------------------------------------
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/enclosure.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+
+struct ses_device {
+	char *page1;
+	char *page2;
+	char *page10;
+	short page1_len;
+	short page2_len;
+	short page10_len;
+};
+
+struct ses_component {
+	u64 addr;
+	unsigned char *desc;
+};
+
+static int ses_probe(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = -ENODEV;
+
+	if (sdev->type != TYPE_ENCLOSURE)
+		goto out;
+
+	err = 0;
+	sdev_printk(KERN_NOTICE, sdev, "Attached Enclosure device\n");
+
+ out:
+	return err;
+}
+
+#define SES_TIMEOUT 30
+#define SES_RETRIES 3
+
+static int ses_recv_diag(struct scsi_device *sdev, int page_code,
+			 void *buf, int bufflen)
+{
+	char cmd[] = {
+		RECEIVE_DIAGNOSTIC,
+		1,		/* Set PCV bit */
+		page_code,
+		bufflen >> 8,
+		bufflen & 0xff,
+		0
+	};
+
+	return scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+				NULL, SES_TIMEOUT, SES_RETRIES);
+}
+
+static int ses_send_diag(struct scsi_device *sdev, int page_code,
+			 void *buf, int bufflen)
+{
+	u32 result;
+
+	char cmd[] = {
+		SEND_DIAGNOSTIC,
+		0x10,		/* Set PF bit */
+		0,
+		bufflen >> 8,
+		bufflen & 0xff,
+		0
+	};
+
+	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+				  NULL, SES_TIMEOUT, SES_RETRIES);
+	if (result)
+		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
+			    result);
+	return result;
+}
+
+static int ses_set_page2_descriptor(struct enclosure_device *edev,
+				      struct enclosure_component *ecomp,
+				      char *desc)
+{
+	int i, j, count = 0, descriptor = ecomp->number;
+	struct scsi_device *sdev = to_scsi_device(edev->cdev.dev);
+	struct ses_device *ses_dev = edev->scratch;
+	char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	char *desc_ptr = ses_dev->page2 + 8;
+
+	/* Clear everything */
+	memset(desc_ptr, 0, ses_dev->page2_len - 8);
+	for (i = 0; i < ses_dev->page1[10]; i++, type_ptr += 4) {
+		for (j = 0; j < type_ptr[1]; j++) {
+			desc_ptr += 4;
+			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
+			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
+				continue;
+			if (count++ == descriptor) {
+				memcpy(desc_ptr, desc, 4);
+				/* set select */
+				desc_ptr[0] |= 0x80;
+				/* clear reserved, just in case */
+				desc_ptr[0] &= 0xf0;
+			}
+		}
+	}
+
+	return ses_send_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
+}
+
+static char *ses_get_page2_descriptor(struct enclosure_device *edev,
+				      struct enclosure_component *ecomp)
+{
+	int i, j, count = 0, descriptor = ecomp->number;
+	struct scsi_device *sdev = to_scsi_device(edev->cdev.dev);
+	struct ses_device *ses_dev = edev->scratch;
+	char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	char *desc_ptr = ses_dev->page2 + 8;
+
+	ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
+
+	for (i = 0; i < ses_dev->page1[10]; i++, type_ptr += 4) {
+		for (j = 0; j < type_ptr[1]; j++) {
+			desc_ptr += 4;
+			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
+			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
+				continue;
+			if (count++ == descriptor)
+				return desc_ptr;
+		}
+	}
+	return NULL;
+}
+
+static void ses_get_fault(struct enclosure_device *edev,
+			  struct enclosure_component *ecomp)
+{
+	char *desc;
+
+	desc = ses_get_page2_descriptor(edev, ecomp);
+	ecomp->fault = (desc[3] & 0x60) >> 4;
+}
+
+static int ses_set_fault(struct enclosure_device *edev,
+			  struct enclosure_component *ecomp,
+			 enum enclosure_component_setting val)
+{
+	char desc[4] = {0 };
+
+	switch (val) {
+	case ENCLOSURE_SETTING_DISABLED:
+		/* zero is disabled */
+		break;
+	case ENCLOSURE_SETTING_ENABLED:
+		desc[2] = 0x02;
+		break;
+	default:
+		/* SES doesn't do the SGPIO blink settings */
+		return -EINVAL;
+	}
+
+	return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
+static void ses_get_status(struct enclosure_device *edev,
+			   struct enclosure_component *ecomp)
+{
+	char *desc;
+
+	desc = ses_get_page2_descriptor(edev, ecomp);
+	ecomp->status = (desc[0] & 0x0f);
+}
+
+static void ses_get_locate(struct enclosure_device *edev,
+			   struct enclosure_component *ecomp)
+{
+	char *desc;
+
+	desc = ses_get_page2_descriptor(edev, ecomp);
+	ecomp->locate = (desc[2] & 0x02) ? 1 : 0;
+}
+
+static int ses_set_locate(struct enclosure_device *edev,
+			  struct enclosure_component *ecomp,
+			  enum enclosure_component_setting val)
+{
+	char desc[4] = {0 };
+
+	switch (val) {
+	case ENCLOSURE_SETTING_DISABLED:
+		/* zero is disabled */
+		break;
+	case ENCLOSURE_SETTING_ENABLED:
+		desc[2] = 0x02;
+		break;
+	default:
+		/* SES doesn't do the SGPIO blink settings */
+		return -EINVAL;
+	}
+	return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
+static int ses_set_active(struct enclosure_device *edev,
+			  struct enclosure_component *ecomp,
+			  enum enclosure_component_setting val)
+{
+	char desc[4] = {0 };
+
+	switch (val) {
+	case ENCLOSURE_SETTING_DISABLED:
+		/* zero is disabled */
+		ecomp->active = 0;
+		break;
+	case ENCLOSURE_SETTING_ENABLED:
+		desc[2] = 0x80;
+		ecomp->active = 1;
+		break;
+	default:
+		/* SES doesn't do the SGPIO blink settings */
+		return -EINVAL;
+	}
+	return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
+static struct enclosure_component_callbacks ses_enclosure_callbacks = {
+	.get_fault		= ses_get_fault,
+	.set_fault		= ses_set_fault,
+	.get_status		= ses_get_status,
+	.get_locate		= ses_get_locate,
+	.set_locate		= ses_set_locate,
+	.set_active		= ses_set_active,
+};
+
+struct ses_host_edev {
+	struct Scsi_Host *shost;
+	struct enclosure_device *edev;
+};
+
+int ses_match_host(struct enclosure_device *edev, void *data)
+{
+	struct ses_host_edev *sed = data;
+	struct scsi_device *sdev;
+
+	if (!scsi_is_sdev_device(edev->cdev.dev))
+		return 0;
+
+	sdev = to_scsi_device(edev->cdev.dev);
+
+	if (sdev->host != sed->shost)
+		return 0;
+
+	sed->edev = edev;
+	return 1;
+}
+
+static void ses_process_descriptor(struct enclosure_component *ecomp,
+				   unsigned char *desc)
+{
+	int eip = desc[0] & 0x10;
+	int invalid = desc[0] & 0x80;
+	enum scsi_protocol proto = desc[0] & 0x0f;
+	u64 addr = 0;
+	struct ses_component *scomp = ecomp->scratch;
+	unsigned char *d;
+
+	scomp->desc = desc;
+
+	if (invalid)
+		return;
+
+	switch (proto) {
+	case SCSI_PROTOCOL_SAS:
+		if (eip)
+			d = desc + 8;
+		else
+			d = desc + 4;
+		/* only take the phy0 addr */
+		addr = (u64)d[12] << 56 |
+			(u64)d[13] << 48 |
+			(u64)d[14] << 40 |
+			(u64)d[15] << 32 |
+			(u64)d[16] << 24 |
+			(u64)d[17] << 16 |
+			(u64)d[18] << 8 |
+			(u64)d[19];
+		break;
+	default:
+		/* FIXME: Need to add more protocols than just SAS */
+		break;
+	}
+	scomp->addr = addr;
+}
+
+struct efd {
+	u64 addr;
+	struct device *dev;
+};
+
+static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
+				      void *data)
+{
+	struct efd *efd = data;
+	int i;
+	struct ses_component *scomp;
+
+	if (!edev->component[0].scratch)
+		return 0;
+
+	for (i = 0; i < edev->components; i++) {
+		scomp = edev->component[i].scratch;
+		if (scomp->addr != efd->addr)
+			continue;
+
+		enclosure_add_device(edev, i, efd->dev);
+		return 1;
+	}
+	return 0;
+}
+
+#define VPD_INQUIRY_SIZE 512
+
+static void ses_match_to_enclosure(struct enclosure_device *edev,
+				   struct scsi_device *sdev)
+{
+	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
+	unsigned char *desc;
+	int len;
+	struct efd efd = {
+		.addr = 0,
+	};
+	unsigned char cmd[] = {
+		INQUIRY,
+		1,
+		0x83,
+		VPD_INQUIRY_SIZE >> 8,
+		VPD_INQUIRY_SIZE & 0xff,
+		0
+	};
+
+	if (!buf)
+		return;
+
+	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
+			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
+		return;
+
+	len = (buf[2] << 8) + buf[3];
+	desc = buf + 4;
+	while (desc < buf + len) {
+		enum scsi_protocol proto = desc[0] >> 4;
+		u8 code_set = desc[0] & 0x0f;
+		u8 piv = desc[1] & 0x80;
+		u8 assoc = (desc[1] & 0x30) >> 4;
+		u8 type = desc[1] & 0x0f;
+		u8 len = desc[3];
+
+		if (piv && code_set == 1 && assoc == 1 && code_set == 1
+		    && proto == SCSI_PROTOCOL_SAS && type == 3 && len == 8)
+			efd.addr = (u64)desc[4] << 56 |
+				(u64)desc[5] << 48 |
+				(u64)desc[6] << 40 |
+				(u64)desc[7] << 32 |
+				(u64)desc[8] << 24 |
+				(u64)desc[9] << 16 |
+				(u64)desc[10] << 8 |
+				(u64)desc[11];
+
+		desc += len + 4;
+	}
+	if (!efd.addr)
+		return;
+
+	efd.dev = &sdev->sdev_gendev;
+
+	enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+}
+
+#define INIT_ALLOC_SIZE 32
+
+static int ses_intf_add(struct class_device *cdev,
+			struct class_interface *intf)
+{
+	struct scsi_device *sdev = to_scsi_device(cdev->dev);
+	struct scsi_device *tmp_sdev;
+	unsigned char *buf = NULL, *hdr_buf, *type_ptr, *desc_ptr,
+		*addl_desc_ptr;
+	struct ses_device *ses_dev;
+	u32 result;
+	int i, j, types, len, components = 0;
+	int err = -ENOMEM;
+	struct enclosure_device *edev;
+	struct ses_component *scomp;
+
+	if (!scsi_device_enclosure(sdev)) {
+		/* not an enclosure, but might be in one */
+		edev = 	enclosure_find(&sdev->host->shost_gendev);
+		if (edev)
+			ses_match_to_enclosure(edev, sdev);
+		return -ENODEV;
+	}
+
+	/* TYPE_ENCLOSURE prints a message in probe */
+	if (sdev->type != TYPE_ENCLOSURE)
+		sdev_printk(KERN_NOTICE, sdev, "Embedded Enclosure Device\n");
+
+	ses_dev = kzalloc(sizeof(*ses_dev), GFP_KERNEL);
+	hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
+	if (!hdr_buf || !ses_dev)
+		goto err_init_free;
+
+	result = ses_recv_diag(sdev, 1, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto recv_failed;
+
+	if (hdr_buf[1] != 0) {
+		/* FIXME: need subenclosure support; I've just never
+		 * seen a device with subenclosures and it makes the
+		 * traversal routines more complex */
+		sdev_printk(KERN_ERR, sdev,
+			"FIXME driver has no support for subenclosures (%d)\n",
+			buf[1]);
+		goto err_free;
+	}
+
+	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		goto err_free;
+
+	ses_dev->page1 = buf;
+	ses_dev->page1_len = len;
+
+	result = ses_recv_diag(sdev, 1, buf, len);
+	if (result)
+		goto recv_failed;
+
+	types = buf[10];
+	len = buf[11];
+
+	type_ptr = buf + 12 + len;
+
+	for (i = 0; i < types; i++, type_ptr += 4) {
+		if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
+		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
+			components += type_ptr[1];
+	}
+
+	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto recv_failed;
+
+	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		goto err_free;
+
+	/* make sure getting page 2 actually works */
+	result = ses_recv_diag(sdev, 2, buf, len);
+	if (result)
+		goto recv_failed;
+	ses_dev->page2 = buf;
+	ses_dev->page2_len = len;
+
+	/* The additional information page --- allows us
+	 * to match up the devices */
+	result = ses_recv_diag(sdev, 10, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto no_page10;
+
+	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		goto err_free;
+
+	result = ses_recv_diag(sdev, 10, buf, len);
+	if (result)
+		goto recv_failed;
+	ses_dev->page10 = buf;
+	ses_dev->page10_len = len;
+
+ no_page10:
+	scomp = kmalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
+	if (!scomp)
+		goto  err_free;
+
+	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
+				  components, &ses_enclosure_callbacks);
+	if (IS_ERR(edev)) {
+		err = PTR_ERR(edev);
+		goto err_free;
+	}
+
+	edev->scratch = ses_dev;
+	for (i = 0; i < components; i++)
+		edev->component[i].scratch = scomp++;
+
+	/* Page 7 for the descriptors is optional */
+	buf = NULL;
+	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto simple_populate;
+
+	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	/* add 1 for trailing '\0' we'll use */
+	buf = kzalloc(len + 1, GFP_KERNEL);
+	result = ses_recv_diag(sdev, 7, buf, len);
+	if (result) {
+ simple_populate:
+		kfree(buf);
+		buf = NULL;
+		desc_ptr = NULL;
+		addl_desc_ptr = NULL;
+	} else {
+		desc_ptr = buf + 8;
+		len = (desc_ptr[2] << 8) + desc_ptr[3];
+		/* skip past overall descriptor */
+		desc_ptr += len + 4;
+		addl_desc_ptr = ses_dev->page10 + 8;
+	}
+	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	components = 0;
+	for (i = 0; i < types; i++, type_ptr += 4) {
+		for (j = 0; j < type_ptr[1]; j++) {
+			char *name = NULL;
+			struct enclosure_component *ecomp;
+
+			if (desc_ptr) {
+				len = (desc_ptr[2] << 8) + desc_ptr[3];
+				desc_ptr += 4;
+				/* Add trailing zero - pushes into
+				 * reserved space */
+				desc_ptr[len] = '\0';
+				name = desc_ptr;
+			}
+			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
+			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
+				continue;
+			ecomp =	enclosure_component_register(edev,
+							     components++,
+							     type_ptr[0],
+							     name);
+			if (desc_ptr) {
+				desc_ptr += len;
+				if (!IS_ERR(ecomp))
+					ses_process_descriptor(ecomp,
+							       addl_desc_ptr);
+
+				if (addl_desc_ptr)
+					addl_desc_ptr += addl_desc_ptr[1] + 2;
+			}
+		}
+	}
+	kfree(buf);
+	kfree(hdr_buf);
+
+	/* see if there are any devices matching before
+	 * we found the enclosure */
+	shost_for_each_device(tmp_sdev, sdev->host) {
+		if (tmp_sdev->lun != 0 || scsi_device_enclosure(tmp_sdev))
+			continue;
+		ses_match_to_enclosure(edev, tmp_sdev);
+	}
+
+	return 0;
+
+ recv_failed:
+	sdev_printk(KERN_ERR, sdev, "Failed to get diagnostic page 0x%x\n",
+		    result);
+	err = -ENODEV;
+ err_free:
+	kfree(buf);
+	kfree(ses_dev->page10);
+	kfree(ses_dev->page2);
+	kfree(ses_dev->page1);
+ err_init_free:
+	kfree(ses_dev);
+	kfree(hdr_buf);
+	sdev_printk(KERN_ERR, sdev, "Failed to bind enclosure %d\n", err);
+	return err;
+	}
+
+static int ses_remove(struct device *dev)
+{
+	return 0;
+}
+
+static void ses_intf_remove(struct class_device *cdev,
+			    struct class_interface *intf)
+{
+	struct scsi_device *sdev = to_scsi_device(cdev->dev);
+	struct enclosure_device *edev;
+	struct ses_device *ses_dev;
+
+	if (!scsi_device_enclosure(sdev))
+		return;
+
+	edev = enclosure_find(cdev->dev);
+	if (!edev)
+		return;
+
+	ses_dev = edev->scratch;
+	edev->scratch = NULL;
+
+	kfree(ses_dev->page1);
+	kfree(ses_dev->page2);
+	kfree(ses_dev);
+
+	kfree(edev->component[0].scratch);
+
+	enclosure_unregister(edev);
+}
+
+static struct class_interface ses_interface = {
+	.add	= ses_intf_add,
+	.remove	= ses_intf_remove,
+};
+
+static struct scsi_driver ses_template = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name		= "ses",
+		.probe		= ses_probe,
+		.remove		= ses_remove,
+	},
+};
+
+static int __init ses_init(void)
+{
+	int err;
+
+	err = scsi_register_interface(&ses_interface);
+	if (err)
+		return err;
+
+	err = scsi_register_driver(&ses_template.gendrv);
+	if (err)
+		goto out_unreg;
+
+	return 0;
+
+ out_unreg:
+	scsi_unregister_interface(&ses_interface);
+	return err;
+}
+
+static void __exit ses_exit(void)
+{
+	scsi_unregister_driver(&ses_template.gendrv);
+	scsi_unregister_interface(&ses_interface);
+}
+
+module_init(ses_init);
+module_exit(ses_exit);
+
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ENCLOSURE);
+
+MODULE_AUTHOR("James Bottomley");
+MODULE_DESCRIPTION("SCSI Enclosure Services (ses) driver");
+MODULE_LICENSE("GPL v2");
-- 
1.5.3.8



