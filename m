From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 27 Feb 2009 17:09:27 -0600
Message-ID: <20090227230927.GA21377@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45349 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZB0XJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 18:09:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

PATCH 1 of 1

New driver for HP Smart Array, hpsa

This patch is a scsi based driver for the HP Smart Array controllers. It
will eventually replace the block driver called cciss. At his time there is
some overlap for controller support. We did this to enable testing by
members of community who are interested.
The overlap affects these controllers:
	P800
	P400
	P212
	P410
	P411
	P812
	P711m
	P712m
If you have an older controller that you wish to test we have added a module
parameter to enable other HP controllers. I suppose we could done with no
overlap, but what the heck. Eventually, we will have to make a hard cutoff
and remove any overlap between hpsa and cciss. In the meanwhile you may wish
to just add/remove support to suit your needs.

To use with older controllers the module parameter is:

	modprobe hpsa allow_unknown_smart_array=1

Caveats:
	Controller overlap

Issues:
	/proc/scsi entry needs work to support many logical volumes
	kdump support not tested
	error handling not well tested
	possible issues with logical volume expansion during use

The driver is based on the cciss code so many things will be familiar to
those who know the cciss driver. The IO path is very stable.

Please consider this patch for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Tom Lawler <tom.lawler@hp.com>

-------------------------------------------------------------------------
diff -urNp linux-2.6/drivers/scsi/hpsa.c linux-2.6-hpsa/drivers/scsi/hpsa.c
--- linux-2.6/drivers/scsi/hpsa.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6-hpsa/drivers/scsi/hpsa.c	2009-02-27 16:56:38.000000000 -0600
@@ -0,0 +1,3590 @@
+/*
+ *    Disk Array driver for HP SA 5xxx and 6xxx Controllers
+ *    Copyright 2000, 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/compat.h>
+#include <linux/blktrace_api.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <linux/cciss_ioctl.h>
+#include <linux/string.h>
+#include <asm/atomic.h>
+#include "hpsa_cmd.h"
+#include "hpsa.h"
+
+#define HPSA_DRIVER_VERSION(maj, min, submin) ((maj<<16)|(min<<8)|(submin))
+#define DRIVER_NAME "HP HPSA Driver (v 1.0.0)"
+#define DRIVER_VERSION HPSA_DRIVER_VERSION(1, 0, 0)
+
+/* How long to wait (in milliseconds) for board to go into simple mode */
+#define MAX_CONFIG_WAIT 30000
+#define MAX_IOCTL_CONFIG_WAIT 1000
+
+/*define how many times we will try a command because of bus resets */
+#define MAX_CMD_RETRIES 3
+#define MAX_CTLR	32
+
+/* Embedded module documentation macros - see modules.h */
+MODULE_AUTHOR("Hewlett-Packard Company");
+MODULE_DESCRIPTION("Driver for HP Smart Array Controller version 1.0.0");
+MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
+MODULE_VERSION("1.0.0");
+MODULE_LICENSE("GPL");
+
+static int allow_unknown_smartarray;
+module_param(allow_unknown_smartarray, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(allow_unknown_smartarray,
+		"Allow driver to load on unknown HP Smart Array hardware");
+
+/* define the PCI info for the cards we can control */
+static const struct pci_device_id hpsa_pci_device_id[] = {
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3223},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3234},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
+	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, hpsa_pci_device_id);
+
+/*  board_id = Subsystem Device ID & Vendor ID
+ *  product = Marketing Name for the board
+ *  access = Address of the struct of function pointers
+ */
+static struct board_type products[] = {
+	{0x3223103C, "Smart Array P800", &SA5_access},
+	{0x3234103C, "Smart Array P400", &SA5_access},
+	{0x323d103c, "Smart Array P700M", &SA5_access},
+	{0x3241103C, "Smart Array P212", &SA5_access},
+	{0x3243103C, "Smart Array P410", &SA5_access},
+	{0x3245103C, "Smart Array P410i", &SA5_access},
+	{0x3247103C, "Smart Array P411", &SA5_access},
+	{0x3249103C, "Smart Array P812", &SA5_access},
+	{0x324a103C, "Smart Array P712m", &SA5_access},
+	{0x324b103C, "Smart Array P711m", &SA5_access},
+	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
+};
+
+static struct ctlr_info *hba[MAX_CTLR];
+static irqreturn_t do_hpsa_intr(int irq, void *dev_id);
+static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
+static void start_io(struct ctlr_info *h);
+static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
+		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
+
+#ifdef CONFIG_COMPAT
+static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
+#endif
+
+static void cmd_free(struct ctlr_info *h, struct CommandList_struct *c);
+static void cmd_special_free(struct ctlr_info *h, struct CommandList_struct *c);
+static struct CommandList_struct *cmd_alloc(struct ctlr_info *h);
+static struct CommandList_struct *cmd_special_alloc(struct ctlr_info *h);
+
+static int hpsa_scsi_proc_info(
+		struct Scsi_Host *sh,
+		char *buffer, /* data buffer */
+		char **start, 	   /* where data in buffer starts */
+		off_t offset,	   /* offset from start of imaginary file */
+		int length, 	   /* length of data in buffer */
+		int func);	   /* 0 == read, 1 == write */
+
+static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *));
+
+static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
+
+static struct scsi_host_template hpsa_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "hpsa",
+	.proc_name		= "hpsa",
+	.proc_info		= hpsa_scsi_proc_info,
+	.queuecommand		= hpsa_scsi_queue_command,
+	.can_queue		= 512,
+	.this_id		= -1,
+	.sg_tablesize		= MAXSGENTRIES,
+	.cmd_per_lun		= 512,
+	.use_clustering		= DISABLE_CLUSTERING,
+	.eh_device_reset_handler = hpsa_eh_device_reset_handler,
+	.ioctl			= hpsa_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= hpsa_compat_ioctl,
+#endif
+};
+
+/* Enqueuing and dequeuing functions for cmdlists. */
+static inline void addQ(struct hlist_head *list, struct CommandList_struct *c)
+{
+	hlist_add_head(&c->list, list);
+}
+
+static inline void removeQ(struct CommandList_struct *c)
+{
+	if (WARN_ON(hlist_unhashed(&c->list)))
+		return;
+	hlist_del_init(&c->list);
+}
+
+static inline int bit_is_set(__u8 bitarray[], int bit)
+{
+	return bitarray[bit >> 3] & (1 << (bit & 0x07));
+}
+
+static inline void set_bit_in_array(__u8 bitarray[], int bit)
+{
+	bitarray[bit >> 3] |= (1 << (bit & 0x07));
+}
+
+static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
+{
+	return ((scsi3addr[3] & 0xC0) == 0x40 &&
+		memcmp(scsi3addr, RAID_CTLR_LUNID, 8) != 0);
+}
+
+struct scsi2map {
+	char scsi3addr[8];
+	int bus, target, lun;
+};
+
+static int hpsa_find_bus_target_lun(struct ctlr_info *h,
+	unsigned char scsi3addr[], int *bus, int *target, int *lun)
+{
+	/* finds an unused bus, target, lun for a new physical device */
+	/* assumes h->devlock is held */
+	int i, found = 0;
+	unsigned char lun_taken[HPSA_MAX_SCSI_DEVS_PER_HBA >> 3];
+
+	memset(&lun_taken[0], 0, HPSA_MAX_SCSI_DEVS_PER_HBA >> 3);
+
+	for (i = 0; i < h->ndevices; i++)
+		if (h->dev[i].bus == *bus && h->dev[i].target != -1)
+			set_bit_in_array(lun_taken, h->dev[i].target);
+
+	for (i = 0; i < HPSA_MAX_SCSI_DEVS_PER_HBA; i++) {
+		if (!bit_is_set(lun_taken, i)) {
+			*bus = 1;
+			*target = i;
+			*lun = 0;
+			found = 1;
+			break;
+		}
+	}
+	return !found;
+}
+
+/* Add an entry into h->dev[] array. */
+static int hpsa_scsi_add_entry(struct ctlr_info *h, int hostno,
+		struct hpsa_scsi_dev_t *device,
+		struct scsi2map *added, int *nadded)
+{
+	/* assumes hba[ctlr]->devlock is held */
+	int n = h->ndevices;
+	int i;
+	unsigned char addr1[8], addr2[8];
+	struct hpsa_scsi_dev_t *sd;
+
+	if (n >= HPSA_MAX_SCSI_DEVS_PER_HBA) {
+		printk(KERN_ERR "hpsa%d: Too many devices, "
+			"some will be inaccessible.\n", h->ctlr);
+		return -1;
+	}
+
+	/* physical devices do not have lun or target assigned until now. */
+	if (device->lun != -1)
+		/* Logical device, lun is already assigned. */
+		goto lun_assigned;
+
+	/* If this device a non-zero lun of a multi-lun device */
+	/* byte 4 of the 8-byte LUN addr will contain the logical */
+	/* unit no, zero otherise. */
+	if (device->scsi3addr[4] == 0) {
+		/* This is not a non-zero lun of a multi-lun device */
+		if (hpsa_find_bus_target_lun(h, device->scsi3addr,
+			&device->bus, &device->target, &device->lun) != 0)
+			return -1;
+		goto lun_assigned;
+	}
+
+	/* This is a non-zero lun of a multi-lun device. */
+	/* Search through our list and find the device which */
+	/* has the same 8 byte LUN address, excepting byte 4. */
+	/* Assign the same bus and target for this new LUN. */
+	/* Use the logical unit number from the firmware. */
+	memcpy(addr1, device->scsi3addr, 8);
+	addr1[4] = 0;
+	for (i = 0; i < n; i++) {
+		sd = &h->dev[i];
+		memcpy(addr2, sd->scsi3addr, 8);
+		addr2[4] = 0;
+		/* differ only in byte 4? */
+		if (memcmp(addr1, addr2, 8) == 0) {
+			device->bus = sd->bus;
+			device->target = sd->target;
+			device->lun = device->scsi3addr[4];
+			break;
+		}
+	}
+	if (device->lun == -1) {
+		printk(KERN_WARNING "hpsa%d: Physical device with no LUN=0, "
+			"suspect firmware bug or unsupported hardware "
+			"configuration.\n", h->ctlr);
+			return -1;
+	}
+
+lun_assigned:
+
+	h->dev[n] = *device;
+	h->ndevices++;
+
+	added[*nadded].bus = device->bus;
+	added[*nadded].target = device->target;
+	added[*nadded].lun = device->lun;
+	(*nadded)++;
+
+	/* initially, (before registering with scsi layer) we don't
+	   know our hostno and we don't want to print anything first
+	   time anyway (the scsi layer's inquiries will show that info) */
+	if (hostno != -1)
+		printk("hpsa%d: %s device c%db%dt%dl%d added.\n",
+			h->ctlr, scsi_device_type(device->devtype), hostno,
+			device->bus, device->target, device->lun);
+	return 0;
+}
+
+/* Remove an entry from h->dev[] array. */
+static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
+	struct scsi2map *removed, int *nremoved)
+{
+	/* assumes h->devlock is held */
+	int i;
+	struct hpsa_scsi_dev_t sd;
+
+	if (entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA)
+		return;
+
+	sd = h->dev[entry];
+	removed[*nremoved].bus    = sd.bus;
+	removed[*nremoved].target = sd.target;
+	removed[*nremoved].lun    = sd.lun;
+	(*nremoved)++;
+
+	for (i = entry; i < h->ndevices-1; i++)
+		h->dev[i] = h->dev[i+1];
+	h->ndevices--;
+	printk(KERN_INFO "hpsa%d: %s device c%db%dt%dl%d removed.\n",
+		h->ctlr, scsi_device_type(sd.devtype), hostno,
+			sd.bus, sd.target, sd.lun);
+}
+
+#define SCSI3ADDR_EQ(a, b) ( \
+	(a)[7] == (b)[7] && \
+	(a)[6] == (b)[6] && \
+	(a)[5] == (b)[5] && \
+	(a)[4] == (b)[4] && \
+	(a)[3] == (b)[3] && \
+	(a)[2] == (b)[2] && \
+	(a)[1] == (b)[1] && \
+	(a)[0] == (b)[0])
+
+static void fixup_botched_add(struct ctlr_info *h, char *scsi3addr)
+{
+	/* called when scsi_add_device fails in order to re-adjust */
+	/* h->dev[] to match the mid layer's view. */
+	unsigned long flags;
+	int i, j;
+
+	spin_lock_irqsave(&h->lock, flags);
+	for (i = 0; i < h->ndevices; i++) {
+		if (memcmp(scsi3addr, h->dev[i].scsi3addr, 8) == 0) {
+			for (j = i; j < h->ndevices-1; j++)
+				h->dev[j] = h->dev[j+1];
+			h->ndevices--;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
+static inline int device_is_the_same(struct hpsa_scsi_dev_t *dev1,
+	struct hpsa_scsi_dev_t *dev2)
+{
+	if (is_logical_dev_addr_mode(dev1->scsi3addr) ||
+		(dev1->lun != -1 && dev2->lun != -1))
+		return (memcmp(dev1, dev2, sizeof(*dev1)) == 0);
+
+	/* we compare everything except lun and target as these
+	   are not yet assigned.  Compare parts likely
+	   to differ first */
+	if (memcmp(dev1->scsi3addr, dev2->scsi3addr,
+		sizeof(dev1->scsi3addr)) != 0)
+		return 0;
+	if (memcmp(dev1->device_id, dev2->device_id,
+		sizeof(dev1->device_id)) != 0)
+		return 0;
+	if (memcmp(dev1->model, dev2->model, sizeof(dev1->model)) != 0)
+		return 0;
+	if (memcmp(dev1->vendor, dev2->vendor, sizeof(dev1->vendor)) != 0)
+		return 0;
+	if (memcmp(dev1->revision, dev2->revision, sizeof(dev1->revision)) != 0)
+		return 0;
+	if (dev1->devtype != dev2->devtype)
+		return 0;
+	if (dev1->raid_level != dev2->raid_level)
+		return 0;
+	if (dev1->bus != dev2->bus)
+		return 0;
+	return 1;
+}
+
+/* Find needle in haystack.  If exact match found, return DEVICE_SAME,
+   and return needle location in *index.  If scsi3addr matches, but not
+   vendor, model, serial num, etc. return DEVICE_CHANGED, and return needle
+   location in *index.  If needle not found, return DEVICE_NOT_FOUND. */
+static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
+	struct hpsa_scsi_dev_t haystack[], int haystack_size,
+	int *index)
+{
+	int i;
+#define DEVICE_NOT_FOUND 0
+#define DEVICE_CHANGED 1
+#define DEVICE_SAME 2
+	for (i = 0; i < haystack_size; i++) {
+		if (SCSI3ADDR_EQ(needle->scsi3addr, haystack[i].scsi3addr)) {
+			*index = i;
+			if (device_is_the_same(needle, &haystack[i]))
+				return DEVICE_SAME;
+			else
+				return DEVICE_CHANGED;
+		}
+	}
+	*index = -1;
+	return DEVICE_NOT_FOUND;
+}
+
+static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
+	struct hpsa_scsi_dev_t sd[], int nsds)
+{
+	/* sd contains scsi3 addresses and devtypes, and inquiry */
+	/* data.  This function takes what's in sd to be the current */
+	/* reality and updates h->dev[] to reflect that reality. */
+
+	int i, entry, device_change, changes = 0;
+	struct hpsa_scsi_dev_t *csd;
+	unsigned long flags;
+	struct scsi2map *added, *removed;
+	int nadded, nremoved;
+	struct Scsi_Host *sh = NULL;
+
+	added = kzalloc(sizeof(*added) * HPSA_MAX_SCSI_DEVS_PER_HBA,
+		GFP_KERNEL);
+	removed = kzalloc(sizeof(*removed) * HPSA_MAX_SCSI_DEVS_PER_HBA,
+		GFP_KERNEL);
+
+	if (!added || !removed) {
+		printk(KERN_WARNING "hpsa%d: Out of memory in "
+		"adjust_hpsa_scsi_table\n", h->ctlr);
+		goto free_and_out;
+	}
+
+	spin_lock_irqsave(&h->devlock, flags);
+
+	/* find any devices in h->dev[] that are not in
+	   sd[] and remove them from h->dev[], and for any
+	   devices which have changed, remove the old device
+	   info and add the new device info. */
+
+	i = 0;
+	nremoved = 0;
+	nadded = 0;
+	while (i < h->ndevices) {
+		csd = &h->dev[i];
+		device_change = hpsa_scsi_find_entry(csd, sd, nsds, &entry);
+		if (device_change == DEVICE_NOT_FOUND) {
+			changes++;
+			hpsa_scsi_remove_entry(h, hostno, i,
+				removed, &nremoved);
+			continue; /* remove ^^^, hence i not incremented */
+		} else if (device_change == DEVICE_CHANGED) {
+			changes++;
+			hpsa_scsi_remove_entry(h, hostno, i,
+				removed, &nremoved);
+			if (hpsa_scsi_add_entry(h, hostno, &sd[entry],
+				added, &nadded) != 0)
+				/* we just removed one, so add can't fail. */
+				BUG();
+		}
+		i++;
+	}
+
+	/* Now, make sure every device listed in sd[] is also
+	listed in h->dev[], adding them if they aren't found */
+
+	for (i = 0; i < nsds; i++) {
+		device_change = hpsa_scsi_find_entry(&sd[i], h->dev,
+					h->ndevices, &entry);
+		if (device_change == DEVICE_NOT_FOUND) {
+			changes++;
+			if (hpsa_scsi_add_entry(h, hostno, &sd[i],
+				added, &nadded) != 0)
+				break;
+		} else if (device_change == DEVICE_CHANGED) {
+			/* should never happen... */
+			changes++;
+			printk("hpsa%d: device unexpectedly changed.\n",
+				h->ctlr);
+			/* but if it does happen, we just ignore that device */
+		}
+	}
+	spin_unlock_irqrestore(&h->devlock, flags);
+
+	/* Don't notify scsi mid layer of any changes the first time through */
+	/* (or if there are no changes) scsi_scan_host will do it later the */
+	/* first time through. */
+	if (hostno == -1 || !changes)
+		goto free_and_out;
+
+	sh = h->scsi_host;
+	/* Notify scsi mid layer of any removed devices */
+	for (i = 0; i < nremoved; i++) {
+		struct scsi_device *sdev =
+			scsi_device_lookup(sh, removed[i].bus,
+				removed[i].target, removed[i].lun);
+		if (sdev != NULL) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
+		} else {
+			/* We don't expect to get here. */
+			/* future cmds to this device will get selection */
+			/* timeout as if the device was gone. */
+			printk(KERN_WARNING "hpsa%d: didn't find "
+				"c%db%dt%dl%d\n for removal.",
+				h->ctlr, hostno, removed[i].bus,
+				removed[i].target, removed[i].lun);
+		}
+	}
+
+	/* Notify scsi mid layer of any added devices */
+	for (i = 0; i < nadded; i++) {
+		if (scsi_add_device(sh, added[i].bus,
+			added[i].target, added[i].lun) == 0)
+			continue;
+		printk(KERN_WARNING "hpsa%d: scsi_add_device "
+			"c%db%dt%dl%d failed, device not added.\n",
+			h->ctlr, hostno,
+			added[i].bus, added[i].target, added[i].lun);
+		/* now we have to remove it from h->dev, */
+		/* since it didn't get added to scsi mid layer */
+		fixup_botched_add(h, added[i].scsi3addr);
+	}
+
+free_and_out:
+	kfree(added);
+	kfree(removed);
+	return 0;
+}
+
+static int lookup_scsi3addr(struct ctlr_info *h, int bus, int target, int lun,
+	char *scsi3addr)
+{
+	int i;
+	struct hpsa_scsi_dev_t *sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->devlock, flags);
+
+	for (i = 0; i < h->ndevices; i++) {
+		sd = &h->dev[i];
+		if (sd->bus == bus && sd->target == target && sd->lun == lun) {
+			memcpy(scsi3addr, &sd->scsi3addr[0], 8);
+			spin_unlock_irqrestore(&h->devlock, flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&h->devlock, flags);
+	return -1;
+}
+
+static void hpsa_scsi_setup(struct ctlr_info *h)
+{
+	h->ndevices = 0;
+	h->scsi_host = NULL;
+	spin_lock_init(&h->devlock);
+	return;
+}
+
+static void complete_scsi_command(struct CommandList_struct *cp,
+	int timeout, __u32 tag)
+{
+	struct scsi_cmnd *cmd;
+	struct ctlr_info *ctlr;
+	struct ErrorInfo_struct *ei;
+
+	unsigned char sense_key;
+	unsigned char asc;      /* additional sense code */
+	unsigned char ascq;     /* additional sense code qualifier */
+
+	ei = cp->err_info;
+
+	/* First, see if it was a message rather than a command */
+	if (cp->Request.Type.Type == TYPE_MSG)  {
+		cp->cmd_type = CMD_MSG_DONE;
+		return;
+	}
+
+	cmd = (struct scsi_cmnd *) cp->scsi_cmd;
+	ctlr = hba[cp->ctlr];
+
+	scsi_dma_unmap(cmd); /* undo the DMA mappings */
+
+	cmd->result = (DID_OK << 16); 		/* host byte */
+	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
+	cmd->result |= (ei->ScsiStatus);
+
+	/* copy the sense data whether we need to or not. */
+	memcpy(cmd->sense_buffer, ei->SenseInfo,
+		ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
+			SCSI_SENSE_BUFFERSIZE :
+			ei->SenseLen);
+	scsi_set_resid(cmd, ei->ResidualCnt);
+
+	if (ei->CommandStatus == 0) {
+		cmd->scsi_done(cmd);
+		cmd_free(ctlr, cp);
+		return;
+	}
+
+	/* an error has occurred */
+	switch (ei->CommandStatus) {
+
+	case CMD_TARGET_STATUS:
+		if (ei->ScsiStatus) {
+			/* Get sense key */
+			sense_key = 0xf & ei->SenseInfo[2];
+			/* Get additional sense code */
+			asc = ei->SenseInfo[12];
+			/* Get addition sense code qualifier */
+			ascq = ei->SenseInfo[13];
+		}
+
+		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
+
+			if (sense_key == ILLEGAL_REQUEST) {
+				/* If ASC/ASCQ indicate Logical Unit
+				 * Not Supported condition,
+				 */
+				if ((asc == 0x25) && (ascq == 0x0)) {
+					printk(KERN_WARNING "hpsa: cp %p "
+						"has check condition\n", cp);
+					break;
+				}
+			}
+
+			if (sense_key == NOT_READY) {
+				/* If Sense is Not Ready, Logical Unit
+				 * Not ready, Manual Intervention
+				 * required
+				 */
+				if ((asc == 0x04) && (ascq == 0x03)) {
+					cmd->result = DID_NO_CONNECT << 16;
+					printk(KERN_WARNING "hpsa: cp %p "
+						"has check condition: unit "
+						"not ready, manual "
+						"intervention required\n", cp);
+					break;
+				}
+			}
+
+
+			/* Must be some other type of check condition */
+			cmd->result |= (ei->ScsiStatus < 1);
+			printk(KERN_WARNING "hpsa: cp %p has check condition: "
+					"unknown type: "
+					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
+					"Returning result: 0x%x, "
+					"cmd=[%02x %02x %02x %02x %02x "
+					"%02x %02x %02x %02x %02x]\n",
+					cp, sense_key, asc, ascq,
+					cmd->result,
+					cmd->cmnd[0], cmd->cmnd[1],
+					cmd->cmnd[2], cmd->cmnd[3],
+					cmd->cmnd[4], cmd->cmnd[5],
+					cmd->cmnd[6], cmd->cmnd[7],
+					cmd->cmnd[8], cmd->cmnd[9]);
+			break;
+		}
+
+
+		/* Problem was not a check condition */
+		/* Pass it up to the upper layers... */
+		if (ei->ScsiStatus) {
+
+			cmd->result |= (ei->ScsiStatus < 1);
+			printk(KERN_WARNING "hpsa: cp %p has status 0x%x "
+				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
+				"Returning result: 0x%x\n",
+				cp, ei->ScsiStatus,
+				sense_key, asc, ascq,
+				cmd->result);
+		} else {  /* scsi status is zero??? How??? */
+			printk(KERN_WARNING "hpsa: cp %p SCSI status was 0. "
+				"Returning no connection.\n", cp),
+
+			/* Ordinarily, this case should never happen,
+			 * but there is a bug in some released firmware
+			 * revisions that allows it to happen if, for
+			 * example, a 4100 backplane loses power and
+			 * the tape drive is in it.  We assume that
+			 * it's a fatal error of some kind because we
+			 * can't show that it wasn't. We will make it
+			 * look like selection timeout since that is
+			 * the most common reason for this to occur,
+			 * and it's severe enough.
+			 */
+
+			cmd->result = DID_NO_CONNECT << 16;
+		}
+		break;
+
+	case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
+		break;
+	case CMD_DATA_OVERRUN:
+		printk(KERN_WARNING "hpsa: cp %p has"
+			" completed with data overrun "
+			"reported\n", cp);
+		break;
+	case CMD_INVALID: {
+		/* print_bytes(cp, sizeof(*cp), 1, 0);
+		print_cmd(cp); */
+		/* We get CMD_INVALID if you address a non-existent device
+		 * instead of a selection timeout (no response).  You will
+		 * see this if you yank out a drive, then try to access it.
+		 * This is kind of a shame because it means that any other
+		 * CMD_INVALID (e.g. driver bug) will get interpreted as a
+		 * missing target. */
+		cmd->result = DID_NO_CONNECT << 16;
+	}
+		break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "hpsa: cp %p has "
+			"protocol error \n", cp);
+		break;
+	case CMD_HARDWARE_ERR:
+		cmd->result = DID_ERROR << 16;
+		printk(KERN_WARNING "hpsa: cp %p had "
+			" hardware error\n", cp);
+		break;
+	case CMD_CONNECTION_LOST:
+		cmd->result = DID_ERROR << 16;
+		printk(KERN_WARNING "hpsa: cp %p had "
+				"connection lost\n", cp);
+		break;
+	case CMD_ABORTED:
+		cmd->result = DID_ABORT << 16;
+		printk(KERN_WARNING "hpsa: cp %p was "
+				"aborted with status 0x%x\n",
+				cp, ei->ScsiStatus);
+		break;
+	case CMD_ABORT_FAILED:
+		cmd->result = DID_ERROR << 16;
+		printk(KERN_WARNING "hpsa: cp %p reports "
+			"abort failed\n", cp);
+		break;
+	case CMD_UNSOLICITED_ABORT:
+		cmd->result = DID_ABORT << 16;
+		printk(KERN_WARNING "hpsa: cp %p aborted "
+			"do to an unsolicited abort\n", cp);
+		break;
+	case CMD_TIMEOUT:
+		cmd->result = DID_TIME_OUT << 16;
+		printk(KERN_WARNING "hpsa: cp %p timedout\n",
+			cp);
+		break;
+	default:
+		cmd->result = DID_ERROR << 16;
+		printk(KERN_WARNING "hpsa: cp %p returned "
+			"unknown status %x\n", cp,
+				ei->CommandStatus);
+	}
+	cmd->scsi_done(cmd);
+	cmd_free(ctlr, cp);
+}
+
+static int hpsa_scsi_detect(struct ctlr_info *h)
+{
+	struct Scsi_Host *sh;
+	int error;
+
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
+	if (sh == NULL)
+		goto fail;
+
+	sh->io_port = 0;
+	sh->n_io_port = 0;
+	sh->this_id = -1;
+	sh->max_channel = 1;
+
+	sh->max_lun = HPSA_MAX_LUN;
+	sh->max_id = HPSA_MAX_LUN;
+	h->scsi_host = sh;
+	sh->hostdata[0] = (unsigned long) h;
+	sh->irq = h->intr[SIMPLE_MODE_INT];
+	sh->unique_id = sh->irq;
+	error = scsi_add_host(sh, &h->pdev->dev);
+	if (error)
+		goto fail_host_put;
+	scsi_scan_host(sh);
+	return 1;
+
+ fail_host_put:
+	printk(KERN_ERR "hpsa_scsi_detect: scsi_add_host"
+		" failed for controller %d\n", h->ctlr);
+	scsi_host_put(sh);
+	return 0;
+ fail:
+	printk(KERN_ERR "hpsa_scsi_detect: scsi_host_alloc"
+		" failed for controller %d\n", h->ctlr);
+	return 0;
+}
+
+static void hpsa_unmap_one(struct pci_dev *pdev,
+		struct CommandList_struct *cp,
+		size_t buflen,
+		int data_direction)
+{
+	union u64bit addr64;
+
+	addr64.val32.lower = cp->SG[0].Addr.lower;
+	addr64.val32.upper = cp->SG[0].Addr.upper;
+	pci_unmap_single(pdev, (dma_addr_t) addr64.val,
+		buflen, data_direction);
+}
+
+static void hpsa_map_one(struct pci_dev *pdev,
+		struct CommandList_struct *cp,
+		unsigned char *buf,
+		size_t buflen,
+		int data_direction)
+{
+	__u64 addr64;
+
+	addr64 = (__u64) pci_map_single(pdev, buf, buflen, data_direction);
+	cp->SG[0].Addr.lower =
+	  (__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
+	cp->SG[0].Addr.upper =
+	  (__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);
+	cp->SG[0].Len = buflen;
+	cp->Header.SGList = (__u8) 1;   /* no. SGs contig in this cmd */
+	cp->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
+}
+
+static int hpsa_scsi_do_simple_cmd(struct ctlr_info *c,
+			struct CommandList_struct *cp,
+			unsigned char *scsi3addr,
+			unsigned char *cdb,
+			unsigned char cdblen,
+			unsigned char *buf, int bufsize,
+			int direction)
+{
+	unsigned long flags;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	cp->cmd_type = CMD_IOCTL_PEND;		/* treat this like an ioctl */
+	cp->scsi_cmd = NULL;
+	cp->Header.ReplyQueue = 0;  /* unused in simple mode */
+	memcpy(&cp->Header.LUN, scsi3addr, sizeof(cp->Header.LUN));
+	cp->Header.Tag.lower = cp->busaddr;  /* Use k. address of cmd as tag */
+
+	/* Fill in the request block... */
+	memset(cp->Request.CDB, 0, sizeof(cp->Request.CDB));
+	memcpy(cp->Request.CDB, cdb, cdblen);
+	cp->Request.Timeout = 0;
+	cp->Request.CDBLen = cdblen;
+	cp->Request.Type.Type = TYPE_CMD;
+	cp->Request.Type.Attribute = ATTR_SIMPLE;
+	cp->Request.Type.Direction = direction;
+
+	/* Fill in the SG list and do dma mapping */
+	hpsa_map_one(c->pdev, cp, (unsigned char *) buf,
+			bufsize, DMA_FROM_DEVICE);
+
+	cp->waiting = &wait;
+
+	/* Put the request on the tail of the request queue */
+	spin_lock_irqsave(&c->lock, flags);
+	addQ(&c->reqQ, cp);
+	c->Qdepth++;
+	start_io(c);
+	spin_unlock_irqrestore(&c->lock, flags);
+
+	wait_for_completion(&wait);
+
+	/* undo the dma mapping */
+	hpsa_unmap_one(c->pdev, cp, bufsize, DMA_FROM_DEVICE);
+	return 0;
+}
+
+static void hpsa_scsi_interpret_error(struct CommandList_struct *cp)
+{
+	struct ErrorInfo_struct *ei;
+
+	ei = cp->err_info;
+	switch (ei->CommandStatus) {
+	case CMD_TARGET_STATUS:
+		printk(KERN_WARNING "hpsa: cmd %p has "
+			"completed with errors\n", cp);
+		printk(KERN_WARNING "hpsa: cmd %p "
+			"has SCSI Status = %x\n",
+				cp,
+				ei->ScsiStatus);
+		if (ei->ScsiStatus == 0)
+			printk(KERN_WARNING
+			"hpsa:SCSI status is abnormally zero.  "
+			"(probably indicates selection timeout "
+			"reported incorrectly due to a known "
+			"firmware bug, circa July, 2001.)\n");
+	break;
+	case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
+			printk("UNDERRUN\n");
+	break;
+	case CMD_DATA_OVERRUN:
+		printk(KERN_WARNING "hpsa: cp %p has"
+			" completed with data overrun "
+			"reported\n", cp);
+	break;
+	case CMD_INVALID: {
+		/* controller unfortunately reports SCSI passthru's */
+		/* to non-existent targets as invalid commands. */
+		printk(KERN_WARNING "hpsa: cp %p is "
+			"reported invalid (probably means "
+			"target device no longer present)\n",
+			cp);
+		/* print_bytes((unsigned char *) cp, sizeof(*cp), 1, 0);
+		print_cmd(cp);  */
+		}
+	break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "hpsa: cp %p has "
+			"protocol error \n", cp);
+	break;
+	case CMD_HARDWARE_ERR:
+		/* cmd->result = DID_ERROR << 16; */
+		printk(KERN_WARNING "hpsa: cp %p had "
+			" hardware error\n", cp);
+	break;
+	case CMD_CONNECTION_LOST:
+		printk(KERN_WARNING "hpsa: cp %p had "
+			"connection lost\n", cp);
+	break;
+	case CMD_ABORTED:
+		printk(KERN_WARNING "hpsa: cp %p was "
+			"aborted\n", cp);
+	break;
+	case CMD_ABORT_FAILED:
+		printk(KERN_WARNING "hpsa: cp %p reports "
+			"abort failed\n", cp);
+	break;
+	case CMD_UNSOLICITED_ABORT:
+		printk(KERN_WARNING "hpsa: cp %p aborted "
+			"do to an unsolicited abort\n", cp);
+	break;
+	case CMD_TIMEOUT:
+		printk(KERN_WARNING "hpsa: cp %p timedout\n",
+			cp);
+	break;
+	default:
+		printk(KERN_WARNING "hpsa: cp %p returned "
+			"unknown status %x\n", cp,
+				ei->CommandStatus);
+	}
+}
+
+static int hpsa_scsi_do_inquiry(struct ctlr_info *c, unsigned char *scsi3addr,
+			unsigned char page, unsigned char *buf,
+			unsigned char bufsize)
+{
+	int rc;
+	struct CommandList_struct *cp;
+	char cdb[6];
+	struct ErrorInfo_struct *ei;
+
+	cp = cmd_special_alloc(c);
+
+	if (cp == NULL) {			/* trouble... */
+		printk(KERN_WARNING "hpsa: cmd_special_alloc returned NULL!\n");
+		return -1;
+	}
+
+	ei = cp->err_info;
+
+	cdb[0] = HPSA_INQUIRY;
+	cdb[1] = (page != 0);
+	cdb[2] = page;
+	cdb[3] = 0;
+	cdb[4] = bufsize;
+	cdb[5] = 0;
+	rc = hpsa_scsi_do_simple_cmd(c, cp, scsi3addr, cdb,
+				6, buf, bufsize, XFER_READ);
+
+	if (rc != 0)
+		return rc; /* something went wrong */
+
+	if (ei->CommandStatus != 0 &&
+	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		hpsa_scsi_interpret_error(cp);
+		rc = -1;
+	}
+	cmd_special_free(c, cp);
+	return rc;
+}
+
+#define RAID_UNKNOWN 6
+static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
+	"UNKNOWN"
+};
+
+static void hpsa_get_raid_level(struct ctlr_info *h,
+	unsigned char *scsi3addr, unsigned char *raid_level)
+{
+	int rc;
+	unsigned char *buf;
+
+	*raid_level = RAID_UNKNOWN;
+	buf = kzalloc(64, GFP_KERNEL);
+	if (!buf)
+		return;
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, 0xC1, buf, 64);
+	if (rc == 0)
+		*raid_level = buf[8];
+	if (*raid_level > RAID_UNKNOWN)
+		*raid_level = RAID_UNKNOWN;
+	kfree(buf);
+	return;
+}
+
+/* Get the device id from inquiry page 0x83 */
+static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
+	unsigned char *device_id, int buflen)
+{
+	int rc;
+	unsigned char *buf;
+
+	if (buflen > 16)
+		buflen = 16;
+	buf = kzalloc(64, GFP_KERNEL);
+	if (!buf)
+		return -1;
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, 0x83, buf, 64);
+	if (rc == 0)
+		memcpy(device_id, &buf[8], buflen);
+	kfree(buf);
+	return rc != 0;
+}
+
+static int hpsa_scsi_do_report_luns(struct ctlr_info *c, int logical,
+		struct ReportLUNdata_struct *buf, int bufsize,
+		int extended_response)
+{
+	int rc;
+	struct CommandList_struct *cp;
+	unsigned char cdb[12];
+	unsigned char scsi3addr[8];
+	struct ErrorInfo_struct *ei;
+
+	cp = cmd_special_alloc(c);
+	if (cp == NULL) {			/* trouble... */
+		printk(KERN_ERR "cmd_special_alloc returned NULL!\n");
+		return -1;
+	}
+
+	memset(&scsi3addr[0], 0, 8); /* address the controller */
+	cdb[0] = logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS;
+	if (extended_response)
+		cdb[1] = extended_response;
+	else
+		cdb[1] = 0;
+	cdb[2] = 0;
+	cdb[3] = 0;
+	cdb[4] = 0;
+	cdb[5] = 0;
+	cdb[6] = (bufsize >> 24) & 0xFF;  /* MSB */
+	cdb[7] = (bufsize >> 16) & 0xFF;
+	cdb[8] = (bufsize >> 8) & 0xFF;
+	cdb[9] = bufsize & 0xFF;
+	cdb[10] = 0;
+	cdb[11] = 0;
+
+	rc = hpsa_scsi_do_simple_cmd(c, cp, scsi3addr,
+				cdb, 12,
+				(unsigned char *) buf,
+				bufsize, XFER_READ);
+
+	if (rc != 0)
+		return rc; /* something went wrong */
+
+	ei = cp->err_info;
+	if (ei->CommandStatus != 0 &&
+	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		hpsa_scsi_interpret_error(cp);
+		rc = -1;
+	}
+	cmd_special_free(c, cp);
+	return rc;
+}
+
+static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *c,
+		struct ReportLUNdata_struct *buf,
+		int bufsize, int extended_response)
+{
+	return hpsa_scsi_do_report_luns(c, 0, buf, bufsize, extended_response);
+}
+
+static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *c,
+		struct ReportLUNdata_struct *buf, int bufsize)
+{
+	return hpsa_scsi_do_report_luns(c, 1, buf, bufsize, 0);
+}
+
+static int hpsa_update_device_info(struct ctlr_info *h,
+	unsigned char scsi3addr[], int bus, int target, int lun,
+	struct hpsa_scsi_dev_t *this_device)
+{
+#define OBDR_TAPE_INQ_SIZE 49
+	unsigned char *inq_buff = NULL;
+
+	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
+	if (!inq_buff)
+		goto bail_out;
+
+	memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);
+	/* Do an inquiry to the device to see what it is. */
+	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
+		(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {
+		/* Inquiry failed (msg printed already) */
+		printk(KERN_ERR "hpsa_update_device_info: inquiry failed\n");
+		goto bail_out;
+	}
+
+	/* As a side effect, record the firmware version number */
+	/* if we happen to be talking to the RAID controller. */
+	if (memcmp(RAID_CTLR_LUNID, scsi3addr, 8) == 0)
+		memcpy(h->firm_ver, &inq_buff[32], 4);
+
+	this_device->devtype = (inq_buff[0] & 0x1f);
+	this_device->bus = bus;
+	this_device->target = target;
+	this_device->lun = lun;
+	memcpy(this_device->scsi3addr, scsi3addr, 8);
+	memcpy(this_device->vendor, &inq_buff[8],
+		sizeof(this_device->vendor));
+	memcpy(this_device->model, &inq_buff[16],
+		sizeof(this_device->model));
+	memcpy(this_device->revision, &inq_buff[32],
+		sizeof(this_device->revision));
+	memset(this_device->device_id, 0,
+		sizeof(this_device->device_id));
+	hpsa_get_device_id(h, scsi3addr, this_device->device_id,
+		sizeof(this_device->device_id));
+
+	if (this_device->devtype == TYPE_DISK &&
+		is_logical_dev_addr_mode(scsi3addr))
+		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
+	else
+		this_device->raid_level = RAID_UNKNOWN;
+
+	kfree(inq_buff);
+	return 0;
+
+bail_out:
+	kfree(inq_buff);
+	return 1;
+}
+
+static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
+{
+	/* the idea here is we could get notified
+	   that some devices have changed, so we do a report
+	   physical luns and report logical luns cmd, and adjust
+	   our list of devices accordingly.
+
+	   The scsi3addr's of devices won't change so long as the
+	   adapter is not reset.  That means we can rescan and
+	   tell which devices we already know about, vs. new
+	   devices, vs.  disappearing devices.
+	 */
+	struct ReportLUNdata_struct *physdev_list = NULL;
+	struct ReportLUNdata_struct *logdev_list = NULL;
+	unsigned char *inq_buff = NULL;
+
+	unsigned char scsi3addr[8];
+	__u32 nphysicals = 0;
+	__u32 nlogicals = 0;
+	struct hpsa_scsi_dev_t *currentsd, *this_device;
+	int ncurrent = 0;
+	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 8;
+	int i;
+	int bus, target, lun;
+	__u8 *lunzerobits;
+
+	currentsd = kmalloc(sizeof(*currentsd) * HPSA_MAX_SCSI_DEVS_PER_HBA,
+		GFP_KERNEL);
+	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
+	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
+	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
+	lunzerobits = kzalloc(HPSA_MAX_TARGETS_PER_CTLR / 8, GFP_KERNEL);
+
+	if (!currentsd || !physdev_list || !logdev_list || !inq_buff ||
+		!lunzerobits) {
+		printk(KERN_ERR "hpsa: out of memory\n");
+		goto out;
+	}
+
+	/* Now do the regular report_phys_luns */
+	if (hpsa_scsi_do_report_phys_luns(h, physdev_list, reportlunsize, 0)) {
+		printk(KERN_ERR  "hpsa: Report physical LUNs failed.\n");
+		goto out;
+	}
+	memcpy(&nphysicals, &physdev_list->LUNListLength[0],
+		sizeof(nphysicals));
+	nphysicals = be32_to_cpu(nphysicals) / 8;
+#ifdef DEBUG
+	printk(KERN_INFO "hpsa: number of physical luns is %d\n", nphysicals);
+#endif
+	if (nphysicals > HPSA_MAX_PHYS_LUN) {
+		printk(KERN_WARNING
+			"hpsa: Maximum physical LUNs (%d) exceeded.  "
+			"%d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
+			nphysicals - HPSA_MAX_PHYS_LUN);
+		nphysicals = HPSA_MAX_PHYS_LUN;
+	}
+
+	/* Now do the report_log_luns */
+	if (hpsa_scsi_do_report_log_luns(h, logdev_list, reportlunsize)) {
+		printk(KERN_ERR "hpsa: Report logical LUNs failed.\n");
+		goto out;
+	}
+
+	memcpy(&nlogicals, &logdev_list->LUNListLength[0], 4);
+	nlogicals = be32_to_cpu(nlogicals) / 8;
+#ifdef DEBUG
+	printk(KERN_INFO "hpsa: number of logical luns is %d\n", nlogicals);
+#endif
+
+	/* Reject Logicals in excess of our max capability. */
+	if (nlogicals > HPSA_MAX_LUN) {
+		printk(KERN_WARNING
+			"hpsa: Maximum logical LUNs (%d) exceeded.  "
+			"%d LUNs ignored.\n", HPSA_MAX_LUN,
+			nlogicals - HPSA_MAX_LUN);
+			nlogicals = HPSA_MAX_LUN;
+	}
+
+	if (nlogicals + nphysicals > HPSA_MAX_PHYS_LUN) {
+		printk(KERN_WARNING
+			"hpsa: Maximum logical + physical LUNs (%d) exceeded. "
+			"%d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
+			nphysicals + nlogicals - HPSA_MAX_PHYS_LUN);
+		nlogicals = HPSA_MAX_PHYS_LUN - nphysicals;
+	}
+
+	h->num_luns = nlogicals;
+
+	/* adjust our table of devices */
+	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
+		__u8 *lunaddrbytes;
+		unsigned int lunid = 0;
+
+		/* Figure out where the LUN ID info is coming from */
+		if (i < nphysicals)
+			lunaddrbytes = &physdev_list->LUN[i][0];
+		else
+			if (i < nphysicals + nlogicals)
+				lunaddrbytes =
+					&logdev_list->LUN[i-nphysicals][0];
+			else /* jam in the RAID controller at the end */
+				lunaddrbytes = RAID_CTLR_LUNID;
+
+		/* skip masked physical devices. */
+		if (lunaddrbytes[3] & 0xC0 && i < nphysicals) {
+#ifdef DEBUG
+			printk(KERN_INFO "hpsa: device found, LUN ID:"
+				" 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+				lunaddrbytes[0], lunaddrbytes[1],
+				lunaddrbytes[2], lunaddrbytes[3],
+				lunaddrbytes[4], lunaddrbytes[5],
+				lunaddrbytes[6], lunaddrbytes[7]);
+#endif
+			continue;
+		}
+
+		/* Put logical volumes on bus 0, physical devices on bus 1. */
+		/* The physicals come first, except the RAID controller, */
+		/* which is last.  For logical drives, Use target and lun */
+		/* as given by the ctlr. The logical drives use only the */
+		/* first 4 bytes for addressing, but the physical devices */
+		/* use all 8 bytes, so we do a more arbitrary mapping to */
+		/* linux bus/target/lun for those. */
+		if (is_logical_dev_addr_mode(lunaddrbytes)) {
+			/* logical device */
+			memcpy(&lunid, lunaddrbytes, sizeof(lunid));
+			lunid = le32_to_cpu(lunid);
+			bus = 0;
+			target = (lunid >> 16) & 0x3fff;
+			lun = lunid & 0x00ff;
+		} else {
+			/* physical device */
+			bus = 1;
+			target = -1;
+			lun = -1; /* we will fill these in later. */
+		}
+
+		this_device = &currentsd[ncurrent];
+
+		/* Lun 0 of some devices doesn't show up in report luns data. */
+		/* but every device has to have a lun 0 (I think.)  And in */
+		/* the msa2012, case we see this behavior, and the lun 0 */
+		/* is there.  Also, if there's no lun 0, the OS won't scan */
+		/* for lun 1..n  So, We insert an entry for lun 0 if we */
+		/* find a target without a lun 0 in the list. */
+		if (!bit_is_set(lunzerobits, target) &&
+			is_logical_dev_addr_mode(lunaddrbytes)) {
+
+			/* If this is first LUN of a target, and LUN id is not 0
+			 * add a LUN id of 0, which is enclosure on MSA2012sa.
+			 * This allows scanning code to work properly
+			 * Is this really needed for linux?
+			 */
+
+			/* a LUN 0 on every target. */
+			if (lun != 0) {
+				memset(scsi3addr, 0, 8);
+				scsi3addr[3] = target;
+				hpsa_update_device_info(h, scsi3addr,
+					bus, target, 0, this_device);
+				ncurrent++;
+				this_device++;
+			}
+			set_bit_in_array(lunzerobits, target);
+		}
+
+		memcpy(&scsi3addr[0], lunaddrbytes, 8);
+		/* Get device type, vendor, model, device id */
+		if (hpsa_update_device_info(h, scsi3addr,
+			bus, target, lun, this_device) != 0)
+			continue; /* skip it if we can't talk to it. */
+
+		switch (this_device->devtype) {
+		case TYPE_ROM:
+			{
+
+			/* We don't *really* support actual CD-ROM devices,
+			 * just "One Button Disaster Recovery" tape drive
+			 * which temporarily pretends to be a CD-ROM drive.
+			 * So we check that the device is really an OBDR tape
+			 * device by checking for "$DR-10" in bytes 43-48 of
+			 * the inquiry data.
+			 */
+			char obdr_sig[7];
+#define OBDR_TAPE_SIG "$DR-10"
+
+			strncpy(obdr_sig, &inq_buff[43], 6);
+			obdr_sig[6] = '\0';
+			if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
+				/* Not OBDR device, ignore it. */
+				break;
+			}
+			/* fall through . . . */
+
+		case TYPE_DISK:
+			/* skip the physical disks, only expose logicals. */
+			if (this_device->devtype == TYPE_DISK && i < nphysicals)
+				break;
+
+			/* Fall through. */
+		case TYPE_RAID:
+		case TYPE_TAPE:
+		case TYPE_MEDIUM_CHANGER:
+			if (ncurrent >= HPSA_MAX_SCSI_DEVS_PER_HBA) {
+				printk(KERN_INFO "hpsa%d: %s ignored, "
+					"too many devices.\n", h->ctlr,
+					scsi_device_type(this_device->devtype));
+				break;
+			}
+			currentsd[ncurrent] = *this_device;
+			ncurrent++;
+			break;
+		default:
+			break;
+		}
+		if (ncurrent >= HPSA_MAX_SCSI_DEVS_PER_HBA)
+			break;
+	}
+	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
+out:
+	kfree(currentsd);
+	kfree(inq_buff);
+	kfree(physdev_list);
+	kfree(logdev_list);
+	kfree(lunzerobits);
+	return;
+}
+
+static int is_keyword(char *ptr, int len, char *verb)
+{
+	int verb_len = strlen(verb);
+	if (len >= verb_len && !memcmp(verb, ptr, verb_len))
+		return verb_len;
+	else
+		return 0;
+}
+
+static int hpsa_scsi_user_command(struct ctlr_info *h, int hostno,
+	char *buffer, int length)
+{
+	int arg_len;
+
+	arg_len = is_keyword(buffer, length, "rescan");
+	if (arg_len != 0)
+		hpsa_update_scsi_devices(h, hostno);
+	else
+		return -EINVAL;
+	return length;
+}
+
+static int hpsa_scsi_proc_info(struct Scsi_Host *sh,
+		char *buffer, /* data buffer */
+		char **start, 	   /* where data in buffer starts */
+		off_t offset,	   /* offset from start of imaginary file */
+		int length, 	   /* length of data in buffer */
+		int func)	   /* 0 == read, 1 == write */
+{
+
+	int buflen, datalen;
+	struct ctlr_info *h;
+	int i;
+
+	h = (struct ctlr_info *) sh->hostdata[0];
+	if (h == NULL)  /* This really shouldn't ever happen. */
+		return -EINVAL;
+	if (func == 0) {	/* User is reading from /proc/scsi/hpsa*?/?*  */
+		buflen = sprintf(buffer, "hpsa%d: SCSI host: %d\n",
+				h->ctlr, sh->host_no);
+
+		/* Only print the first 20 devices, to avoid proc page limit. */
+		for (i = 0; i < min(h->ndevices, 20); i++) {
+			struct hpsa_scsi_dev_t *sd = &h->dev[i];
+			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%d %02d "
+				"0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+				sh->host_no, sd->bus, sd->target, sd->lun,
+				sd->devtype,
+				sd->scsi3addr[0], sd->scsi3addr[1],
+				sd->scsi3addr[2], sd->scsi3addr[3],
+				sd->scsi3addr[4], sd->scsi3addr[5],
+				sd->scsi3addr[6], sd->scsi3addr[7]);
+		}
+		buflen = min(buflen, length - 80);
+		datalen = buflen - offset;
+		if (datalen < 0) { 	/* they're reading past EOF. */
+			datalen = 0;
+			*start = buffer+buflen;
+		} else
+			*start = buffer + offset;
+		return datalen;
+	} else 	/* User is writing to /proc/scsi/hpsa*?/?*  ... */
+		return hpsa_scsi_user_command(h, sh->host_no, buffer, length);
+}
+
+/* hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
+   dma mapping  and fills in the scatter gather entries of the
+   hpsa command, cp. */
+
+static void hpsa_scatter_gather(struct pci_dev *pdev,
+		struct CommandList_struct *cp,
+		struct scsi_cmnd *cmd)
+{
+	unsigned int len;
+	struct scatterlist *sg;
+	__u64 addr64;
+	int use_sg, i;
+
+	BUG_ON(scsi_sg_count(cmd) > MAXSGENTRIES);
+
+	use_sg = scsi_dma_map(cmd);
+	if (!use_sg)
+		goto sglist_finished;
+
+	scsi_for_each_sg(cmd, sg, use_sg, i) {
+		addr64 = (__u64) sg_dma_address(sg);
+		len  = sg_dma_len(sg);
+		cp->SG[i].Addr.lower =
+			(__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
+		cp->SG[i].Addr.upper =
+			(__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);
+		cp->SG[i].Len = len;
+		cp->SG[i].Ext = 0;  /* we are not chaining */
+	}
+
+sglist_finished:
+
+	cp->Header.SGList = (__u8) use_sg;   /* no. SGs contig in this cmd */
+	cp->Header.SGTotal = (__u16) use_sg; /* total sgs in this cmd list */
+	return;
+}
+
+
+static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
+	void (*done)(struct scsi_cmnd *))
+{
+	struct ctlr_info *h;
+	int rc;
+	unsigned char scsi3addr[8];
+	struct CommandList_struct *cp;
+	unsigned long flags;
+
+	/* Get the ptr to our adapter structure (hba[i]) out of cmd->host. */
+	h = (struct ctlr_info *) cmd->device->host->hostdata[0];
+
+	rc = lookup_scsi3addr(h, cmd->device->channel, cmd->device->id,
+			cmd->device->lun, scsi3addr);
+	if (rc != 0) {
+		/* the scsi nexus does not match any that we presented... */
+		/* pretend to mid layer that we got selection timeout */
+		cmd->result = DID_NO_CONNECT << 16;
+		done(cmd);
+		/* we might want to think about registering controller itself
+		   as a processor device on the bus so sg binds to it. */
+		return 0;
+	}
+
+	/* Ok, we have a reasonable scsi nexus, so send the cmd down, and
+	   see what the device thinks of it. */
+
+	/* Need a lock as this is being allocated from the pool */
+	spin_lock_irqsave(&h->lock, flags);
+	cp = cmd_alloc(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+	if (cp == NULL) {			/* trouble... */
+		printk(KERN_ERR "hpsa: cmd_alloc returned NULL!\n");
+		cmd->result = DID_NO_CONNECT << 16;
+		done(cmd);
+		return 0;
+	}
+
+	/* Fill in the command list header */
+
+	cmd->scsi_done = done;    /* save this for use by completion code */
+
+	/* save cp in case we have to abort it  */
+	cmd->host_scribble = (unsigned char *) cp;
+
+	cp->cmd_type = CMD_SCSI;
+	cp->scsi_cmd = cmd;
+	cp->Header.ReplyQueue = 0;  /* unused in simple mode */
+	memcpy(&cp->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
+	cp->Header.Tag.lower = cp->busaddr;  /* Use k. address of cmd as tag */
+
+	/* Fill in the request block... */
+
+	cp->Request.Timeout = 0;
+	memset(cp->Request.CDB, 0, sizeof(cp->Request.CDB));
+	BUG_ON(cmd->cmd_len > sizeof(cp->Request.CDB));
+	cp->Request.CDBLen = cmd->cmd_len;
+	memcpy(cp->Request.CDB, cmd->cmnd, cmd->cmd_len);
+	cp->Request.Type.Type = TYPE_CMD;
+	cp->Request.Type.Attribute = ATTR_SIMPLE;
+	switch (cmd->sc_data_direction) {
+	case DMA_TO_DEVICE:
+		cp->Request.Type.Direction = XFER_WRITE;
+		break;
+	case DMA_FROM_DEVICE:
+		cp->Request.Type.Direction = XFER_READ;
+		break;
+	case DMA_NONE:
+		cp->Request.Type.Direction = XFER_NONE;
+		break;
+	case DMA_BIDIRECTIONAL:
+		/* This can happen if a buggy application does a scsi passthru
+		 * and sets both inlen and outlen to non-zero. ( see
+		 * ../scsi/scsi_ioctl.c:scsi_ioctl_send_command() )
+		 */
+
+		cp->Request.Type.Direction = XFER_RSVD;
+		/* This is technically wrong, and hpsa controllers should
+		 * reject it with CMD_INVALID, which is the most correct
+		 * response, but non-fibre backends appear to let it
+		 * slide by, and give the same results as if this field
+		 * were set correctly.  Either way is acceptable for
+		 * our purposes here.
+		 */
+
+		break;
+
+	default:
+		printk(KERN_ERR "hpsa: unknown data direction: %d\n",
+			cmd->sc_data_direction);
+		BUG();
+		break;
+	}
+
+	hpsa_scatter_gather(h->pdev, cp, cmd); /* Fill the SG list */
+
+	/* Put the request on the tail of the request queue */
+	spin_lock_irqsave(&h->lock, flags);
+	addQ(&h->reqQ, cp);
+	h->Qdepth++;
+	start_io(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+
+	/* the cmd'll come back via intr handler in complete_scsi_command()  */
+	return 0;
+}
+
+static void hpsa_unregister_scsi(struct ctlr_info *h)
+{
+	unsigned long flags;
+
+	/* we are being forcibly unloaded, and may not refuse. */
+	scsi_remove_host(h->scsi_host);
+	scsi_host_put(h->scsi_host);
+	spin_lock_irqsave(&h->lock, flags);
+	h->scsi_host = NULL;
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
+static int hpsa_register_scsi(struct ctlr_info *h)
+{
+	int rc;
+
+	hpsa_update_scsi_devices(h, -1);
+	rc = hpsa_scsi_detect(h);
+	if (rc == 0)
+		printk(KERN_ERR "hpsa: hpsa_register_scsi: failed"
+			" hpsa_scsi_detect(), rc is %d\n", rc);
+	return rc;
+}
+
+/* Need at least one of these error handlers to keep ../scsi/hosts.c from
+ * complaining.  Doing a host- or bus-reset can't do anything good here.
+ */
+
+static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
+{
+	int rc;
+	struct ctlr_info *h;
+	unsigned char scsi3addr[8];
+
+	/* find the controller to which the command to be aborted was sent */
+	h = (struct ctlr_info *) scsicmd->device->host->hostdata[0];
+	if (h == NULL) /* paranoia */
+		return FAILED;
+	printk(KERN_WARNING "hpsa%d: resetting drive\n", h->ctlr);
+
+	rc = lookup_scsi3addr(h, scsicmd->device->channel,
+		scsicmd->device->id, scsicmd->device->lun, scsi3addr);
+	if (rc != 0) {
+		printk(KERN_ERR "hpsa_eh_device_reset_handler: "
+			"lookup_scsi3addr failed.\n");
+		return FAILED;
+	}
+
+	/* send a reset to the SCSI LUN which the command was sent to */
+	rc = sendcmd(HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr, TYPE_MSG);
+
+	/* sendcmd turned off interrupts on the board, turn 'em back on. */
+	h->access.set_intr_mask(h, HPSA_INTR_ON);
+	if (rc == 0)
+		return SUCCESS;
+
+	printk(KERN_WARNING "hpsa%d: resetting device failed.\n", h->ctlr);
+	return FAILED;
+}
+
+#ifdef CONFIG_PROC_FS
+
+/*
+ * Report information about this controller.
+ */
+static struct proc_dir_entry *proc_hpsa;
+
+static void hpsa_seq_show_header(struct seq_file *seq)
+{
+	struct ctlr_info *h = seq->private;
+
+	seq_printf(seq, "%s: HP %s Controller\n"
+		"Board ID: 0x%08lx\n"
+		"Firmware Version: %c%c%c%c\n"
+		"IRQ: %d\n"
+		"Logical drives: %d\n"
+		"Current Q depth: %d\n"
+		"Current # commands on controller: %d\n"
+		"Max Q depth since init: %d\n"
+		"Max # commands on controller since init: %d\n"
+		"Max SG entries since init: %d\n\n",
+		h->devname,
+		h->product_name,
+		(unsigned long)h->board_id,
+		h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
+		h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
+		h->num_luns, h->Qdepth, h->commands_outstanding,
+		h->maxQsinceinit, h->max_outstanding, h->maxSG);
+}
+
+static void *hpsa_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos == 0)
+		hpsa_seq_show_header(seq);
+	return pos;
+}
+
+static int hpsa_seq_show(struct seq_file *seq, void *v)
+{
+	struct ctlr_info *h = seq->private;
+	loff_t *pos = v;
+	struct hpsa_scsi_dev_t *dev;
+
+	if (*pos >= h->ndevices)
+		return 0;
+
+	dev = &h->dev[*pos];
+
+	if (dev->devtype == TYPE_DISK &&
+		!is_logical_dev_addr_mode(dev->scsi3addr))
+		seq_printf(seq, "c%db%dt%dl%d:\tRAID %s\n",
+			h->scsi_host->host_no, dev->bus, dev->target,
+			dev->lun, raid_label[dev->raid_level]);
+	else
+		seq_printf(seq, "c%db%dt%dl%d:\t%s\n",
+			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			scsi_device_type(dev->devtype));
+	return 0;
+}
+
+static void *hpsa_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct ctlr_info *h = seq->private;
+
+	if (*pos >= h->ndevices)
+		return NULL;
+	*pos += 1;
+	return pos;
+}
+
+static void hpsa_seq_stop(struct seq_file *seq, void *v)
+{
+	return;
+}
+
+static const struct seq_operations hpsa_seq_ops = {
+	.start = hpsa_seq_start,
+	.show  = hpsa_seq_show,
+	.next  = hpsa_seq_next,
+	.stop  = hpsa_seq_stop,
+};
+
+static int hpsa_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &hpsa_seq_ops);
+	struct seq_file *seq = file->private_data;
+
+	if (!ret)
+		seq->private = PDE(inode)->data;
+	return ret;
+}
+
+static const struct file_operations hpsa_proc_fops = {
+	.owner   = THIS_MODULE,
+	.open    = hpsa_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release,
+};
+
+/* Get us a file in /proc/hpsa that says something about each controller.
+ * Create /proc/hpsa if it doesn't exist yet.  */
+static void __devinit hpsa_procinit(struct ctlr_info *h)
+{
+	struct proc_dir_entry *pde;
+
+	if (proc_hpsa == NULL)
+		proc_hpsa = proc_mkdir("driver/hpsa", NULL);
+	if (!proc_hpsa)
+		return;
+	pde = proc_create_data(h->devname, S_IRUSR | S_IRGRP | S_IROTH,
+				     proc_hpsa, &hpsa_proc_fops, h);
+}
+#endif				/* CONFIG_PROC_FS */
+
+/*
+ * For operations that cannot sleep, a command block is allocated at init,
+ * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
+ * which ones are free or in use.  Lock must be held when calling this.
+ * cmd_free() is the complement.
+ */
+static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
+{
+	struct CommandList_struct *c;
+	int i;
+	union u64bit temp64;
+	dma_addr_t cmd_dma_handle, err_dma_handle;
+
+	do {
+		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
+		if (i == h->nr_cmds)
+			return NULL;
+	} while (test_and_set_bit
+		 (i & (BITS_PER_LONG - 1),
+		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	c = h->cmd_pool + i;
+	memset(c, 0, sizeof(struct CommandList_struct));
+	cmd_dma_handle = h->cmd_pool_dhandle
+	    + i * sizeof(struct CommandList_struct);
+	c->err_info = h->errinfo_pool + i;
+	memset(c->err_info, 0, sizeof(struct ErrorInfo_struct));
+	err_dma_handle = h->errinfo_pool_dhandle
+	    + i * sizeof(struct ErrorInfo_struct);
+	h->nr_allocs++;
+
+	c->cmdindex = i;
+
+	INIT_HLIST_NODE(&c->list);
+	c->busaddr = (__u32) cmd_dma_handle;
+	temp64.val = (__u64) err_dma_handle;
+	c->ErrDesc.Addr.lower = temp64.val32.lower;
+	c->ErrDesc.Addr.upper = temp64.val32.upper;
+	c->ErrDesc.Len = sizeof(struct ErrorInfo_struct);
+
+	c->ctlr = h->ctlr;
+	return c;
+}
+
+/* For operations that can wait for kmalloc to possibly sleep,
+ * this routine can be called. Lock need not be held to call
+ * cmd_special_alloc. cmd_special_free() is the complement.
+ */
+static struct CommandList_struct *cmd_special_alloc(struct ctlr_info *h)
+{
+	struct CommandList_struct *c;
+	union u64bit temp64;
+	dma_addr_t cmd_dma_handle, err_dma_handle;
+
+	c = (struct CommandList_struct *) pci_alloc_consistent(h->pdev,
+		sizeof(struct CommandList_struct), &cmd_dma_handle);
+	if (c == NULL)
+		return NULL;
+	memset(c, 0, sizeof(struct CommandList_struct));
+
+	c->cmdindex = -1;
+
+	c->err_info = (struct ErrorInfo_struct *)
+	    pci_alloc_consistent(h->pdev, sizeof(struct ErrorInfo_struct),
+		    &err_dma_handle);
+
+	if (c->err_info == NULL) {
+		pci_free_consistent(h->pdev,
+			sizeof(struct CommandList_struct), c, cmd_dma_handle);
+		return NULL;
+	}
+	memset(c->err_info, 0, sizeof(struct ErrorInfo_struct));
+
+	INIT_HLIST_NODE(&c->list);
+	c->busaddr = (__u32) cmd_dma_handle;
+	temp64.val = (__u64) err_dma_handle;
+	c->ErrDesc.Addr.lower = temp64.val32.lower;
+	c->ErrDesc.Addr.upper = temp64.val32.upper;
+	c->ErrDesc.Len = sizeof(struct ErrorInfo_struct);
+
+	c->ctlr = h->ctlr;
+	return c;
+}
+
+
+/* Free a command block previously allocated with cmd_alloc(). */
+static void cmd_free(struct ctlr_info *h, struct CommandList_struct *c)
+{
+	int i;
+	i = c - h->cmd_pool;
+	clear_bit(i & (BITS_PER_LONG - 1),
+		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	h->nr_frees++;
+}
+
+/* Free a command block previously allocated with cmd_special_alloc(). */
+static void cmd_special_free(struct ctlr_info *h, struct CommandList_struct *c)
+{
+	union u64bit temp64;
+
+	temp64.val32.lower = c->ErrDesc.Addr.lower;
+	temp64.val32.upper = c->ErrDesc.Addr.upper;
+	pci_free_consistent(h->pdev, sizeof(struct ErrorInfo_struct),
+			    c->err_info, (dma_addr_t) temp64.val);
+	pci_free_consistent(h->pdev, sizeof(struct CommandList_struct),
+			    c, (dma_addr_t) c->busaddr);
+}
+
+#ifdef CONFIG_COMPAT
+
+static int do_ioctl(struct scsi_device *dev, int cmd, void *arg)
+{
+	int ret;
+	lock_kernel();
+	ret = hpsa_ioctl(dev, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
+static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg);
+static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
+	int cmd, void *arg);
+
+static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg)
+{
+	switch (cmd) {
+	case CCISS_GETPCIINFO:
+	case CCISS_GETINTINFO:
+	case CCISS_SETINTINFO:
+	case CCISS_GETNODENAME:
+	case CCISS_SETNODENAME:
+	case CCISS_GETHEARTBEAT:
+	case CCISS_GETBUSTYPES:
+	case CCISS_GETFIRMVER:
+	case CCISS_GETDRIVVER:
+	case CCISS_REVALIDVOLS:
+	case CCISS_DEREGDISK:
+	case CCISS_REGNEWDISK:
+	case CCISS_REGNEWD:
+	case CCISS_RESCANDISK:
+	case CCISS_GETLUNINFO:
+		return do_ioctl(dev, cmd, arg);
+
+	case CCISS_PASSTHRU32:
+		return hpsa_ioctl32_passthru(dev, cmd, arg);
+	case CCISS_BIG_PASSTHRU32:
+		return hpsa_ioctl32_big_passthru(dev, cmd, arg);
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
+{
+	IOCTL32_Command_struct __user *arg32 =
+	    (IOCTL32_Command_struct __user *) arg;
+	IOCTL_Command_struct arg64;
+	IOCTL_Command_struct __user *p = compat_alloc_user_space(sizeof(arg64));
+	int err;
+	u32 cp;
+
+	err = 0;
+	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
+			   sizeof(arg64.LUN_info));
+	err |= copy_from_user(&arg64.Request, &arg32->Request,
+			   sizeof(arg64.Request));
+	err |= copy_from_user(&arg64.error_info, &arg32->error_info,
+			   sizeof(arg64.error_info));
+	err |= get_user(arg64.buf_size, &arg32->buf_size);
+	err |= get_user(cp, &arg32->buf);
+	arg64.buf = compat_ptr(cp);
+	err |= copy_to_user(p, &arg64, sizeof(arg64));
+
+	if (err)
+		return -EFAULT;
+
+	err = do_ioctl(dev, CCISS_PASSTHRU, (void *)p);
+	if (err)
+		return err;
+	err |= copy_in_user(&arg32->error_info, &p->error_info,
+			 sizeof(arg32->error_info));
+	if (err)
+		return -EFAULT;
+	return err;
+}
+
+static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
+	int cmd, void *arg)
+{
+	BIG_IOCTL32_Command_struct __user *arg32 =
+	    (BIG_IOCTL32_Command_struct __user *) arg;
+	BIG_IOCTL_Command_struct arg64;
+	BIG_IOCTL_Command_struct __user *p =
+	    compat_alloc_user_space(sizeof(arg64));
+	int err;
+	u32 cp;
+
+	err = 0;
+	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
+			   sizeof(arg64.LUN_info));
+	err |= copy_from_user(&arg64.Request, &arg32->Request,
+			   sizeof(arg64.Request));
+	err |= copy_from_user(&arg64.error_info, &arg32->error_info,
+			   sizeof(arg64.error_info));
+	err |= get_user(arg64.buf_size, &arg32->buf_size);
+	err |= get_user(arg64.malloc_size, &arg32->malloc_size);
+	err |= get_user(cp, &arg32->buf);
+	arg64.buf = compat_ptr(cp);
+	err |= copy_to_user(p, &arg64, sizeof(arg64));
+
+	if (err)
+		return -EFAULT;
+
+	err = do_ioctl(dev, CCISS_BIG_PASSTHRU, (void *)p);
+	if (err)
+		return err;
+	err |= copy_in_user(&arg32->error_info, &p->error_info,
+			 sizeof(arg32->error_info));
+	if (err)
+		return -EFAULT;
+	return err;
+}
+#endif
+
+/*
+ * ioctl
+ */
+static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
+{
+
+	struct ctlr_info *h;
+	void __user *argp = (void __user *)arg;
+
+	h = (struct ctlr_info *) dev->host->hostdata[0];
+	if (h == NULL) {
+		printk(KERN_INFO "hpsa_ioctl hostdata is NULL for "
+			"host %d.\n", dev->host->host_no);
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case CCISS_DEREGDISK:
+	case CCISS_REGNEWDISK:
+	case CCISS_REGNEWD: {
+		hpsa_update_scsi_devices(h, dev->host->host_no);
+		return 0;
+	}
+	case CCISS_GETPCIINFO: {
+			struct hpsa_pci_info_struct pciinfo;
+
+			if (!arg)
+				return -EINVAL;
+			pciinfo.domain = pci_domain_nr(h->pdev->bus);
+			pciinfo.bus = h->pdev->bus->number;
+			pciinfo.dev_fn = h->pdev->devfn;
+			pciinfo.board_id = h->board_id;
+			if (copy_to_user(argp, &pciinfo, sizeof(pciinfo)))
+				return -EFAULT;
+			return 0;
+		}
+	case CCISS_GETDRIVVER: {
+			DriverVer_type DriverVer = DRIVER_VERSION;
+
+			if (!arg)
+				return -EINVAL;
+
+			if (copy_to_user(argp, &DriverVer,
+				sizeof(DriverVer_type)))
+				return -EFAULT;
+			return 0;
+		}
+
+	case CCISS_PASSTHRU: {
+			IOCTL_Command_struct iocommand;
+			struct CommandList_struct *c;
+			char *buff = NULL;
+			union u64bit temp64;
+			unsigned long flags;
+			DECLARE_COMPLETION_ONSTACK(wait);
+
+			if (!arg)
+				return -EINVAL;
+
+			if (!capable(CAP_SYS_RAWIO))
+				return -EPERM;
+
+			if (copy_from_user
+			    (&iocommand, argp, sizeof(IOCTL_Command_struct)))
+				return -EFAULT;
+			if ((iocommand.buf_size < 1) &&
+			    (iocommand.Request.Type.Direction != XFER_NONE)) {
+				return -EINVAL;
+			}
+			if (iocommand.buf_size > 0) {
+				buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
+				if (buff == NULL)
+					return -EFAULT;
+			}
+			if (iocommand.Request.Type.Direction == XFER_WRITE) {
+				/* Copy the data into the buffer we created */
+				if (copy_from_user
+				    (buff, iocommand.buf, iocommand.buf_size)) {
+					kfree(buff);
+					return -EFAULT;
+				}
+			} else {
+				memset(buff, 0, iocommand.buf_size);
+			}
+			c = cmd_special_alloc(h);
+			if (c == NULL) {
+				kfree(buff);
+				return -ENOMEM;
+			}
+			/* Fill in the command type */
+			c->cmd_type = CMD_IOCTL_PEND;
+			/* Fill in Command Header */
+			c->Header.ReplyQueue = 0; /* unused in simple mode */
+			if (iocommand.buf_size > 0) {	/* buffer to fill */
+				c->Header.SGList = 1;
+				c->Header.SGTotal = 1;
+			} else	{ /* no buffers to fill */
+				c->Header.SGList = 0;
+				c->Header.SGTotal = 0;
+			}
+			memcpy(&c->Header.LUN, &iocommand.LUN_info,
+				sizeof(c->Header.LUN));
+			/* use the kernel address the cmd block for tag */
+			c->Header.Tag.lower = c->busaddr;
+
+			/* Fill in Request block */
+			memcpy(&c->Request, &iocommand.Request,
+				sizeof(c->Request));
+
+			/* Fill in the scatter gather information */
+			if (iocommand.buf_size > 0) {
+				temp64.val = pci_map_single(h->pdev, buff,
+					iocommand.buf_size,
+					PCI_DMA_BIDIRECTIONAL);
+				c->SG[0].Addr.lower = temp64.val32.lower;
+				c->SG[0].Addr.upper = temp64.val32.upper;
+				c->SG[0].Len = iocommand.buf_size;
+				c->SG[0].Ext = 0; /* we are not chaining*/
+			}
+			c->waiting = &wait;
+
+			/* Put the request on the tail of the request queue */
+			spin_lock_irqsave(&h->lock, flags);
+			addQ(&h->reqQ, c);
+			h->Qdepth++;
+			start_io(h);
+			spin_unlock_irqrestore(&h->lock, flags);
+
+			wait_for_completion(&wait);
+
+			/* unlock the buffers from DMA */
+			temp64.val32.lower = c->SG[0].Addr.lower;
+			temp64.val32.upper = c->SG[0].Addr.upper;
+			pci_unmap_single(h->pdev, (dma_addr_t) temp64.val,
+					 iocommand.buf_size,
+					 PCI_DMA_BIDIRECTIONAL);
+
+			/* Copy the error information out */
+			memcpy(&iocommand.error_info, c->err_info,
+				sizeof(iocommand.error_info));
+			if (copy_to_user
+			    (argp, &iocommand, sizeof(IOCTL_Command_struct))) {
+				kfree(buff);
+				cmd_special_free(h, c);
+				return -EFAULT;
+			}
+
+			if (iocommand.Request.Type.Direction == XFER_READ) {
+				/* Copy the data out of the buffer we created */
+				if (copy_to_user
+				    (iocommand.buf, buff, iocommand.buf_size)) {
+					kfree(buff);
+					cmd_special_free(h, c);
+					return -EFAULT;
+				}
+			}
+			kfree(buff);
+			cmd_special_free(h, c);
+			return 0;
+		}
+	case CCISS_BIG_PASSTHRU:{
+			BIG_IOCTL_Command_struct *ioc;
+			struct CommandList_struct *c;
+			unsigned char **buff = NULL;
+			int *buff_size = NULL;
+			union u64bit temp64;
+			unsigned long flags;
+			BYTE sg_used = 0;
+			int status = 0;
+			int i;
+			DECLARE_COMPLETION_ONSTACK(wait);
+			__u32 left;
+			__u32 sz;
+			BYTE __user *data_ptr;
+
+			if (!arg)
+				return -EINVAL;
+			if (!capable(CAP_SYS_RAWIO))
+				return -EPERM;
+			ioc = (BIG_IOCTL_Command_struct *)
+			    kmalloc(sizeof(*ioc), GFP_KERNEL);
+			if (!ioc) {
+				status = -ENOMEM;
+				goto cleanup1;
+			}
+			if (copy_from_user(ioc, argp, sizeof(*ioc))) {
+				status = -EFAULT;
+				goto cleanup1;
+			}
+			if ((ioc->buf_size < 1) &&
+			    (ioc->Request.Type.Direction != XFER_NONE)) {
+				status = -EINVAL;
+				goto cleanup1;
+			}
+			/* Check kmalloc limits  using all SGs */
+			if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
+				status = -EINVAL;
+				goto cleanup1;
+			}
+			if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
+				status = -EINVAL;
+				goto cleanup1;
+			}
+			buff =
+			    kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
+			if (!buff) {
+				status = -ENOMEM;
+				goto cleanup1;
+			}
+			buff_size = kmalloc(MAXSGENTRIES * sizeof(int),
+						   GFP_KERNEL);
+			if (!buff_size) {
+				status = -ENOMEM;
+				goto cleanup1;
+			}
+			left = ioc->buf_size;
+			data_ptr = ioc->buf;
+			while (left) {
+				sz = (left >
+				      ioc->malloc_size) ? ioc->
+				    malloc_size : left;
+				buff_size[sg_used] = sz;
+				buff[sg_used] = kmalloc(sz, GFP_KERNEL);
+				if (buff[sg_used] == NULL) {
+					status = -ENOMEM;
+					goto cleanup1;
+				}
+				if (ioc->Request.Type.Direction == XFER_WRITE) {
+					if (copy_from_user
+					    (buff[sg_used], data_ptr, sz)) {
+						status = -ENOMEM;
+						goto cleanup1;
+					}
+				} else {
+					memset(buff[sg_used], 0, sz);
+				}
+				left -= sz;
+				data_ptr += sz;
+				sg_used++;
+			}
+			c = cmd_special_alloc(h);
+			if (c == NULL) {
+				status = -ENOMEM;
+				goto cleanup1;
+			}
+			c->cmd_type = CMD_IOCTL_PEND;
+			c->Header.ReplyQueue = 0;
+
+			if (ioc->buf_size > 0) {
+				c->Header.SGList = sg_used;
+				c->Header.SGTotal = sg_used;
+			} else {
+				c->Header.SGList = 0;
+				c->Header.SGTotal = 0;
+			}
+			memcpy(&c->Header.LUN, &ioc->LUN_info,
+				sizeof(c->Header.LUN));
+			c->Header.Tag.lower = c->busaddr;
+
+			memcpy(&c->Request, &ioc->Request, sizeof(c->Request));
+			if (ioc->buf_size > 0) {
+				int i;
+				for (i = 0; i < sg_used; i++) {
+					temp64.val =
+					    pci_map_single(h->pdev, buff[i],
+						    buff_size[i],
+						    PCI_DMA_BIDIRECTIONAL);
+					c->SG[i].Addr.lower =
+					    temp64.val32.lower;
+					c->SG[i].Addr.upper =
+					    temp64.val32.upper;
+					c->SG[i].Len = buff_size[i];
+					/* we are not chaining */
+					c->SG[i].Ext = 0;
+				}
+			}
+			c->waiting = &wait;
+			/* Put the request on the tail of the request queue */
+			spin_lock_irqsave(&h->lock, flags);
+			addQ(&h->reqQ, c);
+			h->Qdepth++;
+			start_io(h);
+			spin_unlock_irqrestore(&h->lock, flags);
+			wait_for_completion(&wait);
+			/* unlock the buffers from DMA */
+			for (i = 0; i < sg_used; i++) {
+				temp64.val32.lower = c->SG[i].Addr.lower;
+				temp64.val32.upper = c->SG[i].Addr.upper;
+				pci_unmap_single(h->pdev,
+					(dma_addr_t) temp64.val, buff_size[i],
+					PCI_DMA_BIDIRECTIONAL);
+			}
+			/* Copy the error information out */
+			memcpy(&ioc->error_info, c->err_info,
+				sizeof(ioc->error_info));
+			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
+				cmd_special_free(h, c);
+				status = -EFAULT;
+				goto cleanup1;
+			}
+			if (ioc->Request.Type.Direction == XFER_READ) {
+				/* Copy the data out of the buffer we created */
+				BYTE __user *ptr = ioc->buf;
+				for (i = 0; i < sg_used; i++) {
+					if (copy_to_user
+					    (ptr, buff[i], buff_size[i])) {
+						cmd_special_free(h, c);
+						status = -EFAULT;
+						goto cleanup1;
+					}
+					ptr += buff_size[i];
+				}
+			}
+			cmd_special_free(h, c);
+			status = 0;
+cleanup1:
+			if (buff) {
+				for (i = 0; i < sg_used; i++)
+					kfree(buff[i]);
+				kfree(buff);
+			}
+			kfree(buff_size);
+			kfree(ioc);
+			return status;
+		}
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int fill_cmd(struct CommandList_struct *c, __u8 cmd, struct ctlr_info *h,
+	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
+	int cmd_type)
+{
+	union u64bit buff_dma_handle;
+	int status = IO_OK;
+
+	c->cmd_type = CMD_IOCTL_PEND;
+	c->Header.ReplyQueue = 0;
+	if (buff != NULL && size > 0) {
+		c->Header.SGList = 1;
+		c->Header.SGTotal = 1;
+	} else {
+		c->Header.SGList = 0;
+		c->Header.SGTotal = 0;
+	}
+	c->Header.Tag.lower = c->busaddr;
+	memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
+
+	c->Request.Type.Type = cmd_type;
+	if (cmd_type == TYPE_CMD) {
+		switch (cmd) {
+		case HPSA_INQUIRY:
+			/* are we trying to read a vital product page */
+			if (page_code != 0) {
+				c->Request.CDB[1] = 0x01;
+				c->Request.CDB[2] = page_code;
+			}
+			c->Request.CDBLen = 6;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_READ;
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = HPSA_INQUIRY;
+			c->Request.CDB[4] = size & 0xFF;
+			break;
+		case HPSA_REPORT_LOG:
+		case HPSA_REPORT_PHYS:
+			/* Talking to controller so It's a physical command
+			   mode = 00 target = 0.  Nothing to write.
+			 */
+			c->Request.CDBLen = 12;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_READ;
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = cmd;
+			c->Request.CDB[6] = (size >> 24) & 0xFF; /* MSB */
+			c->Request.CDB[7] = (size >> 16) & 0xFF;
+			c->Request.CDB[8] = (size >> 8) & 0xFF;
+			c->Request.CDB[9] = size & 0xFF;
+			break;
+
+		case HPSA_READ_CAPACITY:
+			c->Request.CDBLen = 10;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_READ;
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = cmd;
+			break;
+		case HPSA_CACHE_FLUSH:
+			c->Request.CDBLen = 12;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_WRITE;
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = BMIC_WRITE;
+			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
+			break;
+		default:
+			printk(KERN_WARNING
+			       "hpsa%d:  Unknown Command 0x%c\n", h->ctlr, cmd);
+			return IO_ERROR;
+		}
+	} else if (cmd_type == TYPE_MSG) {
+		switch (cmd) {
+
+		case  HPSA_DEVICE_RESET_MSG:
+			c->Request.CDBLen = 12;
+			c->Request.Type.Type =  1; /* It is a MSG not a CMD */
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_WRITE; /* Write */
+			c->Request.Timeout = 0; /* Don't time out */
+			c->Request.CDB[0] =  0x01; /* RESET_MSG is 0x01 */
+			c->Request.CDB[1] = 0x04;  /* Reset LunID above */
+			/* If bytes 4-7 are zero, it means reset the */
+			/* LunID device */
+			c->Request.CDB[4] = 0x00;
+			c->Request.CDB[5] = 0x00;
+			c->Request.CDB[6] = 0x00;
+			c->Request.CDB[7] = 0x00;
+		break;
+
+		default:
+			printk(KERN_WARNING
+			       "hpsa%d: unknown message type %d\n",
+				h->ctlr, cmd);
+			return IO_ERROR;
+		}
+	} else {
+		printk(KERN_WARNING
+		       "hpsa%d: unknown command type %d\n", h->ctlr, cmd_type);
+		return IO_ERROR;
+	}
+	/* Fill in the scatter gather information */
+	if (size > 0) {
+		buff_dma_handle.val =
+			(__u64) pci_map_single(h->pdev, buff, size,
+					     PCI_DMA_BIDIRECTIONAL);
+		c->SG[0].Addr.lower = buff_dma_handle.val32.lower;
+		c->SG[0].Addr.upper = buff_dma_handle.val32.upper;
+		c->SG[0].Len = size;
+		c->SG[0].Ext = 0;	/* we are not chaining */
+	}
+	return status;
+}
+
+
+/*
+ *   Wait polling for a command to complete.
+ *   The memory mapped FIFO is polled for the completion.
+ *   Used only at init time, interrupts from the HBA are disabled.
+ */
+static unsigned long pollcomplete(struct ctlr_info *h)
+{
+	unsigned long done;
+	int i;
+
+	/* Wait (up to 20 seconds) for a command to complete */
+
+	for (i = 20 * HZ; i > 0; i--) {
+		done = h->access.command_completed(h);
+		if (done == FIFO_EMPTY)
+			schedule_timeout_uninterruptible(1);
+		else
+			return done;
+	}
+	/* Invalid address to tell caller we ran out of time */
+	printk(KERN_WARNING "hpsa: pollcomplete(): returning 1\n");
+	return 1;
+}
+
+static int add_sendcmd_reject(__u8 cmd, struct ctlr_info *h,
+	unsigned long complete)
+{
+	/* We get in here if sendcmd() is polling for completions
+	   and gets some command back that it wasn't expecting --
+	   something other than that which it just sent down.
+	   Ordinarily, that shouldn't happen, but it can happen when
+	   the scsi stuff gets into error handling mode, and
+	   starts using sendcmd() to try to abort commands and
+	   reset drives.  In that case, sendcmd may pick up
+	   completions of commands that were sent to logical drives
+	   through the regular i/o system, or hpsa ioctls completing, etc.
+	   In that case, we need to save those completions for later
+	   processing by the interrupt handler.
+	 */
+
+	struct sendcmd_reject_list *srl = &h->scsi_rejects;
+
+	/* If it's not the scsi stuff doing error handling, (abort */
+	/* or reset) then we don't expect anything weird. */
+	if (cmd != HPSA_DEVICE_RESET_MSG &&
+		cmd != HPSA_REPORT_PHYS &&
+		cmd != HPSA_INQUIRY &&
+		cmd != HPSA_CACHE_FLUSH) {
+		printk(KERN_WARNING "hpsa hpsa%d: SendCmd "
+		       "Invalid command type, invalid list "
+			"address returned! (%lx)\n", h->ctlr, complete);
+		/* not much we can do. */
+		return 1;
+	}
+
+	/* We've sent down an abort or reset, but something else
+	   has completed */
+	if (srl->ncompletions >= (h->nr_cmds + 2)) {
+		/* Uh oh.  No room to save it for later... */
+		printk(KERN_WARNING "hpsa%d: Sendcmd: Invalid command addr, "
+		       "reject list overflow, command lost!\n", h->ctlr);
+		return 1;
+	}
+	/* Save it for later */
+	srl->complete[srl->ncompletions] = complete;
+	srl->ncompletions++;
+	return 0;
+}
+
+/*
+ * Send a command to the controller, and wait for it to complete.
+ * Only used at init time or to send abort/reset messages
+ */
+static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
+		   __u8 page_code, unsigned char *scsi3addr, int cmd_type)
+{
+	struct CommandList_struct *c;
+	int i;
+	unsigned long complete;
+	union u64bit buff_dma_handle;
+	int status, done = 0;
+
+	c = cmd_alloc(h);
+	if (c == NULL) {
+		printk(KERN_WARNING "hpsa: unable to get memory");
+		return IO_ERROR;
+	}
+	status = fill_cmd(c, cmd, h, buff, size, page_code,
+		scsi3addr, cmd_type);
+	if (status != IO_OK) {
+		cmd_free(h, c);
+		return status;
+	}
+resend_cmd1:
+	/*
+	 * Disable interrupt
+	 */
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
+
+	/* Make sure there is room in the command FIFO */
+	/* Actually it should be completely empty at this time */
+	/* unless we are in here doing error handling for the scsi */
+	/* side of the driver. */
+	for (i = 200000; i > 0; i--) {
+		/* if fifo isn't full go */
+		if (!(h->access.fifo_full(h)))
+			break;
+		udelay(10);
+		printk(KERN_WARNING "hpsa hpsa%d: SendCmd FIFO full,"
+		       " waiting!\n", h->ctlr);
+	}
+	/*
+	 * Send the cmd
+	 */
+	h->access.submit_command(h, c);
+	done = 0;
+	do {
+		complete = pollcomplete(h);
+
+		if (complete == 1) {
+			printk(KERN_WARNING
+			       "hpsa hpsa%d: SendCmd Timeout out, "
+			       "No command list address returned!\n", h->ctlr);
+			status = IO_ERROR;
+			done = 1;
+			break;
+		}
+
+		/* This will need to change for direct lookup completions */
+		if ((complete & HPSA_ERROR_BIT)
+		    && (complete & ~HPSA_ERROR_BIT) == c->busaddr) {
+			/* if data overrun or underun on Report command
+			   ignore it
+			 */
+			if (((c->Request.CDB[0] == HPSA_REPORT_LOG) ||
+			     (c->Request.CDB[0] == HPSA_REPORT_PHYS) ||
+			     (c->Request.CDB[0] == HPSA_INQUIRY)) &&
+			    ((c->err_info->CommandStatus ==
+			      CMD_DATA_OVERRUN) ||
+			     (c->err_info->CommandStatus == CMD_DATA_UNDERRUN)
+			    )) {
+				complete = c->busaddr;
+			} else {
+				if (c->err_info->CommandStatus ==
+				    CMD_UNSOLICITED_ABORT) {
+					printk(KERN_WARNING "hpsa%d: "
+					       "unsolicited abort %p\n",
+					       h->ctlr, c);
+					if (c->retry_count < MAX_CMD_RETRIES) {
+						printk(KERN_WARNING
+						       "hpsa%d: retrying %p\n",
+						       h->ctlr, c);
+						c->retry_count++;
+						/* erase the old error */
+						/* information */
+						memset(c->err_info, 0,
+						       sizeof(c->err_info));
+						goto resend_cmd1;
+					} else {
+						printk(KERN_WARNING
+							"hpsa%d: retried %p "
+							"too many times\n",
+							h->ctlr, c);
+						status = IO_ERROR;
+						goto cleanup1;
+					}
+				} else if (c->err_info->CommandStatus ==
+					   CMD_UNABORTABLE) {
+					printk(KERN_WARNING
+					       "hpsa%d: command could not "
+						"be aborted.\n", h->ctlr);
+					status = IO_ERROR;
+					goto cleanup1;
+				}
+				printk(KERN_WARNING "hpsa%d: sendcmd"
+				       " Error %x \n", h->ctlr,
+				       c->err_info->CommandStatus);
+				printk(KERN_WARNING "hpsa%d: sendcmd"
+				       " offensive info\n"
+				       "  size %x\n   num %x   value %x\n",
+				       h->ctlr,
+				       c->err_info->MoreErrInfo.Invalid_Cmd.
+				       offense_size,
+				       c->err_info->MoreErrInfo.Invalid_Cmd.
+				       offense_num,
+				       c->err_info->MoreErrInfo.Invalid_Cmd.
+				       offense_value);
+				status = IO_ERROR;
+				goto cleanup1;
+			}
+		}
+		/* This will need changing for direct lookup completions */
+		if (complete != c->busaddr) {
+			if (add_sendcmd_reject(cmd, h, complete) != 0)
+				BUG();	/* pretty much hosed if we get here. */
+			continue;
+		} else
+			done = 1;
+	} while (!done);
+
+cleanup1:
+	/* unlock the data buffer from DMA */
+	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
+	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
+	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
+			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
+	/* if we saved some commands for later, process them now. */
+	if (h->scsi_rejects.ncompletions > 0)
+		do_hpsa_intr(0, h);
+	cmd_free(h, c);
+	return status;
+}
+
+/*
+ * Map (physical) PCI mem into (virtual) kernel space
+ */
+static void __iomem *remap_pci_mem(ulong base, ulong size)
+{
+	ulong page_base = ((ulong) base) & PAGE_MASK;
+	ulong page_offs = ((ulong) base) - page_base;
+	void __iomem *page_remapped = ioremap(page_base, page_offs + size);
+
+	return page_remapped ? (page_remapped + page_offs) : NULL;
+}
+
+/*
+ * Takes jobs of the Q and sends them to the hardware, then puts it on
+ * the Q to wait for completion.
+ */
+static void start_io(struct ctlr_info *h)
+{
+	struct CommandList_struct *c;
+
+	while (!hlist_empty(&h->reqQ)) {
+		c = hlist_entry(h->reqQ.first, struct CommandList_struct, list);
+		/* can't do anything if fifo is full */
+		if ((h->access.fifo_full(h))) {
+			printk(KERN_WARNING "hpsa: fifo full\n");
+			break;
+		}
+
+		/* Get the first entry from the Request Q */
+		removeQ(c);
+		h->Qdepth--;
+
+		/* Tell the controller execute command */
+		h->access.submit_command(h, c);
+
+		/* Put job onto the completed Q */
+		addQ(&h->cmpQ, c);
+	}
+}
+
+/* Assumes that h->lock is held. */
+/* Zeros out the error record and then resends the command back */
+/* to the controller */
+static inline void resend_hpsa_cmd(struct ctlr_info *h,
+	struct CommandList_struct *c)
+{
+	/* erase the old error information */
+	memset(c->err_info, 0, sizeof(c->err_info));
+
+	/* add it to software queue and then send it to the controller */
+	addQ(&(h->reqQ), c);
+	h->Qdepth++;
+	if (h->Qdepth > h->maxQsinceinit)
+		h->maxQsinceinit = h->Qdepth;
+
+	start_io(h);
+}
+
+static inline unsigned long get_next_completion(struct ctlr_info *h)
+{
+	/* Any rejects from sendcmd() lying around? Process them first */
+	if (h->scsi_rejects.ncompletions == 0)
+		return h->access.command_completed(h);
+	else {
+		struct sendcmd_reject_list *srl;
+		int n;
+		srl = &h->scsi_rejects;
+		n = --srl->ncompletions;
+		return srl->complete[n];
+	}
+}
+
+static inline int interrupt_pending(struct ctlr_info *h)
+{
+	return (h->access.intr_pending(h)
+		|| (h->scsi_rejects.ncompletions > 0));
+}
+
+static inline long interrupt_not_for_us(struct ctlr_info *h)
+{
+	return (((h->access.intr_pending(h) == 0) ||
+		 (h->interrupts_enabled == 0))
+		&& (h->scsi_rejects.ncompletions == 0));
+}
+
+static irqreturn_t do_hpsa_intr(int irq, void *dev_id)
+{
+	struct ctlr_info *h = dev_id;
+	struct CommandList_struct *c;
+	unsigned long flags;
+	__u32 a, a1, a2;
+
+	if (interrupt_not_for_us(h))
+		return IRQ_NONE;
+	/*
+	 * If there are completed commands in the completion queue,
+	 * we had better do something about it.
+	 */
+	spin_lock_irqsave(&h->lock, flags);
+	while (interrupt_pending(h)) {
+		while ((a = get_next_completion(h)) != FIFO_EMPTY) {
+			a1 = a;
+			if ((a & 0x04)) {
+				a2 = (a >> 3);
+				if (a2 >= h->nr_cmds) {
+					printk(KERN_WARNING
+					       "hpsa: controller hpsa%d "
+						"failed, stopping.\n",
+						h->ctlr);
+					return IRQ_HANDLED;
+				}
+
+				c = h->cmd_pool + a2;
+				a = c->busaddr;
+
+			} else {
+				struct hlist_node *tmp;
+
+				a &= ~3;
+				c = NULL;
+				hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
+					if (c->busaddr == a)
+						break;
+				}
+			}
+			/*
+			 * If we've found the command, take it off the
+			 * completion Q and free it
+			 */
+			if (c && c->busaddr == a) {
+				removeQ(c);
+				if (likely(c->cmd_type == CMD_SCSI))
+					complete_scsi_command(c, 0, a1);
+				else if (c->cmd_type == CMD_IOCTL_PEND)
+					complete(c->waiting);
+				continue;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&h->lock, flags);
+	return IRQ_HANDLED;
+}
+
+/* Send a message CDB to the firmware. */
+static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
+						unsigned char type)
+{
+	struct Command {
+		struct CommandListHeader_struct CommandHeader;
+		struct RequestBlock_struct Request;
+		struct ErrDescriptor_struct ErrorDescriptor;
+	};
+	static const size_t cmd_sz = sizeof(struct Command) +
+					sizeof(ErrorInfo_struct);
+	struct Command *cmd;
+	dma_addr_t paddr64;
+	uint32_t paddr32, tag;
+	void __iomem *vaddr;
+	int i, err;
+
+	vaddr = ioremap_nocache(pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0));
+	if (vaddr == NULL)
+		return -ENOMEM;
+
+	/* The Inbound Post Queue only accepts 32-bit physical addresses for the
+	   CCISS commands, so they must be allocated from the lower 4GiB of
+	   memory. */
+	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err) {
+		iounmap(vaddr);
+		return -ENOMEM;
+	}
+
+	cmd = pci_alloc_consistent(pdev, cmd_sz, &paddr64);
+	if (cmd == NULL) {
+		iounmap(vaddr);
+		return -ENOMEM;
+	}
+
+	/* This must fit, because of the 32-bit consistent DMA mask.  Also,
+	   although there's no guarantee, we assume that the address is at
+	   least 4-byte aligned (most likely, it's page-aligned). */
+	paddr32 = paddr64;
+
+	cmd->CommandHeader.ReplyQueue = 0;
+	cmd->CommandHeader.SGList = 0;
+	cmd->CommandHeader.SGTotal = 0;
+	cmd->CommandHeader.Tag.lower = paddr32;
+	cmd->CommandHeader.Tag.upper = 0;
+	memset(&cmd->CommandHeader.LUN.LunAddrBytes, 0, 8);
+
+	cmd->Request.CDBLen = 16;
+	cmd->Request.Type.Type = TYPE_MSG;
+	cmd->Request.Type.Attribute = ATTR_HEADOFQUEUE;
+	cmd->Request.Type.Direction = XFER_NONE;
+	cmd->Request.Timeout = 0; /* Don't time out */
+	cmd->Request.CDB[0] = opcode;
+	cmd->Request.CDB[1] = type;
+	memset(&cmd->Request.CDB[2], 0, 14); /* rest of the CDB is reserved */
+	cmd->ErrorDescriptor.Addr.lower = paddr32 + sizeof(struct Command);
+	cmd->ErrorDescriptor.Addr.upper = 0;
+	cmd->ErrorDescriptor.Len = sizeof(ErrorInfo_struct);
+
+	writel(paddr32, vaddr + SA5_REQUEST_PORT_OFFSET);
+
+	for (i = 0; i < 10; i++) {
+		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
+		if ((tag & ~3) == paddr32)
+			break;
+		schedule_timeout_uninterruptible(HZ);
+	}
+
+	iounmap(vaddr);
+
+	/* we leak the DMA buffer here ... no choice since the controller could
+	   still complete the command. */
+	if (i == 10) {
+		printk(KERN_ERR "hpsa: controller message %02x:%02x timed out\n",
+			opcode, type);
+		return -ETIMEDOUT;
+	}
+
+	pci_free_consistent(pdev, cmd_sz, cmd, paddr64);
+
+	if (tag & 2) {
+		printk(KERN_ERR "hpsa: controller message %02x:%02x failed\n",
+			opcode, type);
+		return -EIO;
+	}
+
+	printk(KERN_INFO "hpsa: controller message %02x:%02x succeeded\n",
+		opcode, type);
+	return 0;
+}
+
+#define hpsa_soft_reset_controller(p) hpsa_message(p, 1, 0)
+#define hpsa_noop(p) hpsa_message(p, 3, 0)
+
+static __devinit int hpsa_reset_msi(struct pci_dev *pdev)
+{
+/* the #defines are stolen from drivers/pci/msi.h. */
+#define msi_control_reg(base)		(base + PCI_MSI_FLAGS)
+#define PCI_MSIX_FLAGS_ENABLE		(1 << 15)
+
+	int pos;
+	u16 control = 0;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	if (pos) {
+		pci_read_config_word(pdev, msi_control_reg(pos), &control);
+		if (control & PCI_MSI_FLAGS_ENABLE) {
+			printk(KERN_INFO "hpsa: resetting MSI\n");
+			pci_write_config_word(pdev, msi_control_reg(pos),
+					control & ~PCI_MSI_FLAGS_ENABLE);
+		}
+	}
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (pos) {
+		pci_read_config_word(pdev, msi_control_reg(pos), &control);
+		if (control & PCI_MSIX_FLAGS_ENABLE) {
+			printk(KERN_INFO "hpsa: resetting MSI-X\n");
+			pci_write_config_word(pdev, msi_control_reg(pos),
+					control & ~PCI_MSIX_FLAGS_ENABLE);
+		}
+	}
+
+	return 0;
+}
+
+/* This does a hard reset of the controller using PCI power management
+ * states. */
+static __devinit int hpsa_hard_reset_controller(struct pci_dev *pdev)
+{
+	u16 pmcsr, saved_config_space[32];
+	int i, pos;
+
+	printk(KERN_INFO "hpsa: using PCI PM to reset controller\n");
+
+	/* This is very nearly the same thing as
+
+	   pci_save_state(pci_dev);
+	   pci_set_power_state(pci_dev, PCI_D3hot);
+	   pci_set_power_state(pci_dev, PCI_D0);
+	   pci_restore_state(pci_dev);
+
+	   but we can't use these nice canned kernel routines on
+	   kexec, because they also check the MSI/MSI-X state in PCI
+	   configuration space and do the wrong thing when it is
+	   set/cleared.  Also, the pci_save/restore_state functions
+	   violate the ordering requirements for restoring the
+	   configuration space from the CCISS document (see the
+	   comment below).  So we roll our own .... */
+
+	for (i = 0; i < 32; i++)
+		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
+	if (pos == 0) {
+		printk(KERN_ERR "hpsa_reset_controller: PCI PM not supported\n");
+		return -ENODEV;
+	}
+
+	/* Quoting from the Open CISS Specification: "The Power
+	 * Management Control/Status Register (CSR) controls the power
+	 * state of the device.  The normal operating state is D0,
+	 * CSR=00h.  The software off state is D3, CSR=03h.  To reset
+	 * the controller, place the interface device in D3 then to
+	 * D0, this causes a secondary PCI reset which will reset the
+	 * controller." */
+
+	/* enter the D3hot power management state */
+	pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
+	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+	pmcsr |= PCI_D3hot;
+	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_timeout(HZ >> 1);
+
+	/* enter the D0 power management state */
+	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+	pmcsr |= PCI_D0;
+	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_timeout(HZ >> 1);
+
+	/* Restore the PCI configuration space.  The Open CISS
+	 * Specification says, "Restore the PCI Configuration
+	 * Registers, offsets 00h through 60h. It is important to
+	 * restore the command register, 16-bits at offset 04h,
+	 * last. Do not restore the configuration status register,
+	 * 16-bits at offset 06h."  Note that the offset is 2*i. */
+	for (i = 0; i < 32; i++) {
+		if (i == 2 || i == 3)
+			continue;
+		pci_write_config_word(pdev, 2*i, saved_config_space[i]);
+	}
+	wmb();
+	pci_write_config_word(pdev, 4, saved_config_space[2]);
+
+	return 0;
+}
+
+/*
+ *  We cannot read the structure directly, for portability we must use
+ *   the io functions.
+ *   This is for debug only.
+ */
+#ifdef HPSA_DEBUG
+static void print_cfg_table(struct CfgTable_struct *tb)
+{
+	int i;
+	char temp_name[17];
+
+	printk(KERN_INFO "Controller Configuration information\n");
+	printk(KERN_INFO "------------------------------------\n");
+	for (i = 0; i < 4; i++)
+		temp_name[i] = readb(&(tb->Signature[i]));
+	temp_name[4] = '\0';
+	printk(KERN_INFO "   Signature = %s\n", temp_name);
+	printk(KERN_INFO "   Spec Number = %d\n", readl(&(tb->SpecValence)));
+	printk(KERN_INFO "   Transport methods supported = 0x%x\n",
+	       readl(&(tb->TransportSupport)));
+	printk(KERN_INFO "   Transport methods active = 0x%x\n",
+	       readl(&(tb->TransportActive)));
+	printk(KERN_INFO "   Requested transport Method = 0x%x\n",
+	       readl(&(tb->HostWrite.TransportRequest)));
+	printk(KERN_INFO "   Coalesce Interrupt Delay = 0x%x\n",
+	       readl(&(tb->HostWrite.CoalIntDelay)));
+	printk(KERN_INFO "   Coalesce Interrupt Count = 0x%x\n",
+	       readl(&(tb->HostWrite.CoalIntCount)));
+	printk(KERN_INFO "   Max outstanding commands = 0x%d\n",
+	       readl(&(tb->CmdsOutMax)));
+	printk(KERN_INFO "   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
+	for (i = 0; i < 16; i++)
+		temp_name[i] = readb(&(tb->ServerName[i]));
+	temp_name[16] = '\0';
+	printk(KERN_INFO "   Server Name = %s\n", temp_name);
+	printk(KERN_INFO "   Heartbeat Counter = 0x%x\n\n\n",
+		readl(&(tb->HeartBeat)));
+}
+#endif				/* HPSA_DEBUG */
+
+static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
+{
+	int i, offset, mem_type, bar_type;
+	if (pci_bar_addr == PCI_BASE_ADDRESS_0)	/* looking for BAR zero? */
+		return 0;
+	offset = 0;
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		bar_type = pci_resource_flags(pdev, i) & PCI_BASE_ADDRESS_SPACE;
+		if (bar_type == PCI_BASE_ADDRESS_SPACE_IO)
+			offset += 4;
+		else {
+			mem_type = pci_resource_flags(pdev, i) &
+			    PCI_BASE_ADDRESS_MEM_TYPE_MASK;
+			switch (mem_type) {
+			case PCI_BASE_ADDRESS_MEM_TYPE_32:
+			case PCI_BASE_ADDRESS_MEM_TYPE_1M:
+				offset += 4;	/* 32 bit */
+				break;
+			case PCI_BASE_ADDRESS_MEM_TYPE_64:
+				offset += 8;
+				break;
+			default:	/* reserved in PCI 2.2 */
+				printk(KERN_WARNING
+				       "Base address is invalid\n");
+				return -1;
+				break;
+			}
+		}
+		if (offset == pci_bar_addr - PCI_BASE_ADDRESS_0)
+			return i + 1;
+	}
+	return -1;
+}
+
+/* If MSI/MSI-X is supported by the kernel we will try to enable it on
+ * controllers that are capable. If not, we use IO-APIC mode.
+ */
+
+static void __devinit hpsa_interrupt_mode(struct ctlr_info *c,
+					   struct pci_dev *pdev, __u32 board_id)
+{
+#ifdef CONFIG_PCI_MSI
+	int err;
+	struct msix_entry hpsa_msix_entries[4] = { {0, 0}, {0, 1},
+	{0, 2}, {0, 3}
+	};
+
+	/* Some boards advertise MSI but don't really support it */
+	if ((board_id == 0x40700E11) ||
+	    (board_id == 0x40800E11) ||
+	    (board_id == 0x40820E11) || (board_id == 0x40830E11))
+		goto default_int_mode;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		printk(KERN_WARNING "hpsa: MSIX\n");
+		err = pci_enable_msix(pdev, hpsa_msix_entries, 4);
+		if (!err) {
+			c->intr[0] = hpsa_msix_entries[0].vector;
+			c->intr[1] = hpsa_msix_entries[1].vector;
+			c->intr[2] = hpsa_msix_entries[2].vector;
+			c->intr[3] = hpsa_msix_entries[3].vector;
+			c->msix_vector = 1;
+			return;
+		}
+		if (err > 0) {
+			printk(KERN_WARNING "hpsa: only %d MSI-X vectors "
+			       "available\n", err);
+			goto default_int_mode;
+		} else {
+			printk(KERN_WARNING "hpsa: MSI-X init failed %d\n",
+			       err);
+			goto default_int_mode;
+		}
+	}
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+		printk(KERN_WARNING "hpsa: MSI\n");
+		if (!pci_enable_msi(pdev))
+			c->msi_vector = 1;
+		else
+			printk(KERN_WARNING "hpsa: MSI init failed\n");
+	}
+default_int_mode:
+#endif				/* CONFIG_PCI_MSI */
+	/* if we get here we're going to use the default interrupt mode */
+	c->intr[SIMPLE_MODE_INT] = pdev->irq;
+	return;
+}
+
+static int hpsa_pci_init(struct ctlr_info *c, struct pci_dev *pdev)
+{
+	ushort subsystem_vendor_id, subsystem_device_id, command;
+	__u32 board_id, scratchpad = 0;
+	__u64 cfg_offset;
+	__u32 cfg_base_addr;
+	__u64 cfg_base_addr_index;
+	int i, prod_index, err;
+
+	subsystem_vendor_id = pdev->subsystem_vendor;
+	subsystem_device_id = pdev->subsystem_device;
+	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
+		    subsystem_vendor_id);
+
+	for (i = 0; i < ARRAY_SIZE(products); i++)
+		if (board_id == products[i].board_id)
+			break;
+
+	prod_index = i;
+
+	if (prod_index == ARRAY_SIZE(products)) {
+		prod_index--;
+		if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
+				!allow_unknown_smartarray) {
+			printk(KERN_WARNING "hpsa: Sorry, I don't "
+				"know how to access the Smart "
+				"Array controller %08lx\n",
+				(unsigned long) board_id);
+			return -ENODEV;
+		}
+	}
+	/* check to see if controller has been disabled */
+	/* BEFORE trying to enable it */
+	(void)pci_read_config_word(pdev, PCI_COMMAND, &command);
+	if (!(command & 0x02)) {
+		printk(KERN_WARNING
+		       "hpsa: controller appears to be disabled\n");
+		return -ENODEV;
+	}
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "hpsa: Unable to Enable PCI device\n");
+		return err;
+	}
+
+	err = pci_request_regions(pdev, "hpsa");
+	if (err) {
+		printk(KERN_ERR "hpsa: Cannot obtain PCI resources, "
+		       "aborting\n");
+		return err;
+	}
+
+/* If the kernel supports MSI/MSI-X we will try to enable that functionality,
+ * else we use the IO-APIC interrupt assigned to us by system ROM.
+ */
+	hpsa_interrupt_mode(c, pdev, board_id);
+
+	/*
+	 * Memory base addr is first addr , the second points to the config
+	 *   table
+	 */
+
+	/* addressing mode bits already removed */
+	c->paddr = pci_resource_start(pdev, 0);
+	c->vaddr = remap_pci_mem(c->paddr, 0x250);
+
+	/* Wait for the board to become ready.  (PCI hotplug needs this.)
+	 * We poll for up to 120 secs, once per 100ms. */
+	for (i = 0; i < 1200; i++) {
+		scratchpad = readl(c->vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (scratchpad == HPSA_FIRMWARE_READY)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ / 10);	/* wait 100ms */
+	}
+	if (scratchpad != HPSA_FIRMWARE_READY) {
+		printk(KERN_WARNING "hpsa: Board not ready.  Timed out.\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+
+	/* get the address index number */
+	cfg_base_addr = readl(c->vaddr + SA5_CTCFG_OFFSET);
+	cfg_base_addr &= (__u32) 0x0000ffff;
+	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
+	if (cfg_base_addr_index == -1) {
+		printk(KERN_WARNING "hpsa: Cannot find cfg_base_addr_index\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+
+	cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
+	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
+			       cfg_base_addr_index) + cfg_offset,
+				sizeof(struct CfgTable_struct));
+	c->board_id = board_id;
+
+	/* Query controller for max supported commands: */
+	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
+
+	c->product_name = products[prod_index].product_name;
+	c->access = *(products[prod_index].access);
+	/* Allow room for some ioctls */
+	c->nr_cmds = c->max_commands - 4;
+
+	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
+	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
+	    (readb(&c->cfgtable->Signature[2]) != 'S') ||
+	    (readb(&c->cfgtable->Signature[3]) != 'S')) {
+		printk(KERN_WARNING "cciss: not a valid CISS config table\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+#ifdef CONFIG_X86
+	{
+		/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+		__u32 prefetch;
+		prefetch = readl(&(c->cfgtable->SCSI_Prefetch));
+		prefetch |= 0x100;
+		writel(prefetch, &(c->cfgtable->SCSI_Prefetch));
+	}
+#endif
+
+	/* Disabling DMA prefetch for the P600
+	 * An ASIC bug may result in a prefetch beyond
+	 * physical memory.
+	 */
+	if (board_id == 0x3225103C) {
+		__u32 dma_prefetch;
+		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
+		dma_prefetch |= 0x8000;
+		writel(dma_prefetch, c->vaddr + I2O_DMA1_CFG);
+	}
+
+	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
+	/* Update the field, and then ring the doorbell */
+	writel(CFGTBL_Trans_Simple, &(c->cfgtable->HostWrite.TransportRequest));
+	writel(CFGTBL_ChangeReq, c->vaddr + SA5_DOORBELL);
+
+	/* under certain very rare conditions, this can take awhile.
+	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
+	 * as we enter this code.) */
+	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+		if (!(readl(c->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
+			break;
+		/* delay and try again */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+
+#ifdef HPSA_DEBUG
+	print_cfg_table(c->cfgtable);
+#endif				/* HPSA_DEBUG */
+
+	if (!(readl(&(c->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
+		printk(KERN_WARNING "hpsa: unable to get board into"
+		       " simple mode\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+	return 0;
+
+err_out_free_res:
+	/*
+	 * Deliberately omit pci_disable_device(): it does something nasty to
+	 * Smart Array controllers that pci_enable_device does not undo
+	 */
+	pci_release_regions(pdev);
+	return err;
+}
+
+/* Function to find the first free pointer into our hba[] array */
+/* Returns -1 if no free entries are left.  */
+static int alloc_hpsa_hba(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_CTLR; i++) {
+		if (!hba[i]) {
+			struct ctlr_info *p;
+			p = kzalloc(sizeof(struct ctlr_info), GFP_KERNEL);
+			if (!p)
+				goto Enomem;
+			hba[i] = p;
+			return i;
+		}
+	}
+	printk(KERN_WARNING "hpsa: This driver supports a maximum"
+	       " of %d controllers.\n", MAX_CTLR);
+	goto out;
+Enomem:
+	printk(KERN_ERR "hpsa: out of memory.\n");
+out:
+	return -1;
+}
+
+static void free_hba(int i)
+{
+	struct ctlr_info *p = hba[i];
+
+	hba[i] = NULL;
+	kfree(p);
+}
+
+/*
+ *  This is it.  Find all the controllers and register them.  I really hate
+ *  stealing all these major device numbers.
+ *  returns the number of block devices registered.
+ */
+static int __devinit hpsa_init_one(struct pci_dev *pdev,
+				    const struct pci_device_id *ent)
+{
+	int i;
+	int dac;
+	struct ctlr_info *h;
+
+	if (reset_devices) {
+		/* Reset the controller with a PCI power-cycle */
+		if (hpsa_hard_reset_controller(pdev) || hpsa_reset_msi(pdev))
+			return -ENODEV;
+
+		/* Some devices (notably the HP Smart Array 5i Controller)
+		   need a little pause here */
+		schedule_timeout_uninterruptible(30*HZ);
+
+		/* Now try to get the controller to respond to a no-op */
+		for (i = 0; i < 12; i++) {
+			if (hpsa_noop(pdev) == 0)
+				break;
+			else
+				printk(KERN_WARNING "hpsa: no-op failed%s\n",
+						(i < 11 ? "; re-trying" : ""));
+		}
+	}
+
+	BUILD_BUG_ON(sizeof(struct CommandList_struct) % 8);
+	i = alloc_hpsa_hba();
+	if (i < 0)
+		return -1;
+	h = hba[i];
+
+
+	INIT_HLIST_HEAD(&h->cmpQ);
+	INIT_HLIST_HEAD(&h->reqQ);
+	if (hpsa_pci_init(h, pdev) != 0)
+		goto clean1;
+
+	sprintf(h->devname, "hpsa%d", i);
+	h->ctlr = i;
+	h->pdev = pdev;
+
+	/* configure PCI DMA stuff */
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK))
+		dac = 1;
+	else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
+		dac = 0;
+	else {
+		printk(KERN_ERR "hpsa: no suitable DMA available\n");
+		goto clean1;
+	}
+
+	/*
+	 * register with the major number, or get a dynamic major number
+	 * by passing 0 as argument.  This is done for greater than
+	 * 8 controller support.
+	 */
+
+	/* make sure the board interrupts are off */
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
+	if (request_irq(h->intr[SIMPLE_MODE_INT], do_hpsa_intr,
+			IRQF_DISABLED | IRQF_SHARED, h->devname, h)) {
+		printk(KERN_ERR "hpsa: Unable to get irq %d for %s\n",
+		       h->intr[SIMPLE_MODE_INT], h->devname);
+		goto clean2;
+	}
+
+	printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
+	       h->devname, pdev->device, pci_name(pdev),
+	       h->intr[SIMPLE_MODE_INT], dac ? "" : " not");
+
+	h->cmd_pool_bits =
+	    kmalloc(((h->nr_cmds + BITS_PER_LONG -
+		      1) / BITS_PER_LONG) * sizeof(unsigned long), GFP_KERNEL);
+	h->cmd_pool = (struct CommandList_struct *)
+	    pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(struct CommandList_struct),
+		    &(h->cmd_pool_dhandle));
+	h->errinfo_pool = (struct ErrorInfo_struct *)
+	    pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(struct ErrorInfo_struct),
+		    &(h->errinfo_pool_dhandle));
+	if ((h->cmd_pool_bits == NULL)
+	    || (h->cmd_pool == NULL)
+	    || (h->errinfo_pool == NULL)) {
+		printk(KERN_ERR "hpsa: out of memory");
+		goto clean4;
+	}
+	h->scsi_rejects.complete =
+	    kmalloc(sizeof(h->scsi_rejects.complete[0]) *
+		    (h->nr_cmds + 5), GFP_KERNEL);
+	if (h->scsi_rejects.complete == NULL) {
+		printk(KERN_ERR "hpsa: out of memory");
+		goto clean4;
+	}
+	spin_lock_init(&h->lock);
+
+	/* Initialize the pdev driver private data.
+	   have it point to h.  */
+	pci_set_drvdata(pdev, h);
+	/* command and error info recs zeroed out before
+	   they are used */
+	memset(h->cmd_pool_bits, 0,
+	       ((h->nr_cmds + BITS_PER_LONG -
+		 1) / BITS_PER_LONG) * sizeof(unsigned long));
+
+	hpsa_scsi_setup(h);
+
+	/* Turn the interrupts on so we can service requests */
+	h->access.set_intr_mask(h, HPSA_INTR_ON);
+
+	hpsa_procinit(h);
+	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
+
+	return 1;
+
+clean4:
+	kfree(h->scsi_rejects.complete);
+	kfree(h->cmd_pool_bits);
+	if (h->cmd_pool)
+		pci_free_consistent(h->pdev,
+			    h->nr_cmds * sizeof(struct CommandList_struct),
+			    h->cmd_pool, h->cmd_pool_dhandle);
+	if (h->errinfo_pool)
+		pci_free_consistent(h->pdev,
+			    h->nr_cmds * sizeof(struct ErrorInfo_struct),
+			    h->errinfo_pool,
+			    h->errinfo_pool_dhandle);
+	free_irq(h->intr[SIMPLE_MODE_INT], h);
+clean2:
+clean1:
+	free_hba(i);
+	return -1;
+}
+
+static void hpsa_shutdown(struct pci_dev *pdev)
+{
+	struct ctlr_info *h;
+	int i;
+	char flush_buf[4];
+	int return_code;
+
+	h = pci_get_drvdata(pdev);
+	if (h == NULL) {
+		printk(KERN_ERR "hpsa: Unable to shutdown device \n");
+		return;
+	}
+	i = h->ctlr;
+	if (hba[i] == NULL) {
+		printk(KERN_ERR "hpsa: device appears to "
+		       "already be removed \n");
+		return;
+	}
+	/* Turn board interrupts off  and send the flush cache command */
+	/* sendcmd will turn off interrupt, and send the flush...
+	 * To write all data in the battery backed cache to disks */
+	memset(flush_buf, 0, 4);
+	return_code = sendcmd(HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
+				RAID_CTLR_LUNID, TYPE_CMD);
+	if (return_code != IO_OK) {
+		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
+		       h->ctlr);
+	}
+	free_irq(h->intr[2], h);
+#ifdef CONFIG_PCI_MSI
+	if (h->msix_vector)
+		pci_disable_msix(h->pdev);
+	else if (h->msi_vector)
+		pci_disable_msi(h->pdev);
+#endif				/* CONFIG_PCI_MSI */
+}
+
+static void __devexit hpsa_remove_one(struct pci_dev *pdev)
+{
+	struct ctlr_info *h;
+	int i;
+
+	if (pci_get_drvdata(pdev) == NULL) {
+		printk(KERN_ERR "hpsa: Unable to remove device \n");
+		return;
+	}
+	h = pci_get_drvdata(pdev);
+	i = h->ctlr;
+	if (hba[i] == NULL) {
+		printk(KERN_ERR "hpsa: device appears to "
+		       "already be removed \n");
+		return;
+	}
+
+	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
+	remove_proc_entry(h->devname, proc_hpsa);
+	hpsa_shutdown(pdev);
+	iounmap(h->vaddr);
+
+	/* remove it from the disk list */
+
+	pci_free_consistent(h->pdev,
+		h->nr_cmds * sizeof(struct CommandList_struct),
+		h->cmd_pool, h->cmd_pool_dhandle);
+	pci_free_consistent(h->pdev,
+		h->nr_cmds * sizeof(struct ErrorInfo_struct),
+		h->errinfo_pool, h->errinfo_pool_dhandle);
+	kfree(h->cmd_pool_bits);
+	kfree(h->scsi_rejects.complete);
+	/*
+	 * Deliberately omit pci_disable_device(): it does something nasty to
+	 * Smart Array controllers that pci_enable_device does not undo
+	 */
+	pci_release_regions(pdev);
+	pci_set_drvdata(pdev, NULL);
+	free_hba(i);
+}
+
+static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
+	__attribute__((unused)) pm_message_t state)
+{
+	return -ENOSYS;
+}
+
+static int hpsa_resume(__attribute__((unused)) struct pci_dev *pdev)
+{
+	return -ENOSYS;
+}
+
+static struct pci_driver hpsa_pci_driver = {
+	.name = "hpsa",
+	.probe = hpsa_init_one,
+	.remove = __devexit_p(hpsa_remove_one),
+	.id_table = hpsa_pci_device_id,	/* id_table */
+	.shutdown = hpsa_shutdown,
+	.suspend = hpsa_suspend,
+	.resume = hpsa_resume,
+};
+
+/*
+ *  This is it.  Register the PCI driver information for the cards we control
+ *  the OS will call our registered routines when it finds one of our cards.
+ */
+static int __init hpsa_init(void)
+{
+	printk(KERN_INFO DRIVER_NAME "hpsa\n");
+	/* Register for our PCI devices */
+	return pci_register_driver(&hpsa_pci_driver);
+}
+
+static void __exit hpsa_cleanup(void)
+{
+	int i;
+
+	pci_unregister_driver(&hpsa_pci_driver);
+	/* double check that all controller entrys have been removed */
+	for (i = 0; i < MAX_CTLR; i++) {
+		if (hba[i] != NULL) {
+			printk(KERN_WARNING "hpsa: had to remove"
+			       " controller %d\n", i);
+			hpsa_remove_one(hba[i]->pdev);
+		}
+	}
+	remove_proc_entry("driver/hpsa", NULL);
+}
+
+module_init(hpsa_init);
+module_exit(hpsa_cleanup);
diff -urNp linux-2.6/drivers/scsi/hpsa_cmd.h linux-2.6-hpsa/drivers/scsi/hpsa_cmd.h
--- linux-2.6/drivers/scsi/hpsa_cmd.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6-hpsa/drivers/scsi/hpsa_cmd.h	2009-02-27 16:43:48.000000000 -0600
@@ -0,0 +1,307 @@
+/*
+ *    Disk Array driver for HP SA 5xxx and 6xxx Controllers
+ *    Copyright 2000, 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *
+ */
+#ifndef HPSA_CMD_H
+#define HPSA_CMD_H
+
+#define HPSA_VERSION "1.00"
+
+/* general boundary defintions */
+#define SENSEINFOBYTES          32 /* may vary between hbas */
+#define MAXSGENTRIES            31
+#define MAXREPLYQS              256
+
+/* Command Status value */
+#define CMD_SUCCESS             0x0000
+#define CMD_TARGET_STATUS       0x0001
+#define CMD_DATA_UNDERRUN       0x0002
+#define CMD_DATA_OVERRUN        0x0003
+#define CMD_INVALID             0x0004
+#define CMD_PROTOCOL_ERR        0x0005
+#define CMD_HARDWARE_ERR        0x0006
+#define CMD_CONNECTION_LOST     0x0007
+#define CMD_ABORTED             0x0008
+#define CMD_ABORT_FAILED        0x0009
+#define CMD_UNSOLICITED_ABORT   0x000A
+#define CMD_TIMEOUT             0x000B
+#define CMD_UNABORTABLE		0x000C
+
+/* transfer direction */
+#define XFER_NONE               0x00
+#define XFER_WRITE              0x01
+#define XFER_READ               0x02
+#define XFER_RSVD               0x03
+
+/* task attribute */
+#define ATTR_UNTAGGED           0x00
+#define ATTR_SIMPLE             0x04
+#define ATTR_HEADOFQUEUE        0x05
+#define ATTR_ORDERED            0x06
+#define ATTR_ACA                0x07
+
+/* cdb type */
+#define TYPE_CMD				0x00
+#define TYPE_MSG				0x01
+
+/* config space register offsets */
+#define CFG_VENDORID            0x00
+#define CFG_DEVICEID            0x02
+#define CFG_I2OBAR              0x10
+#define CFG_MEM1BAR             0x14
+
+/* i2o space register offsets */
+#define I2O_IBDB_SET            0x20
+#define I2O_IBDB_CLEAR          0x70
+#define I2O_INT_STATUS          0x30
+#define I2O_INT_MASK            0x34
+#define I2O_IBPOST_Q            0x40
+#define I2O_OBPOST_Q            0x44
+#define I2O_DMA1_CFG		0x214
+
+/* Configuration Table */
+#define CFGTBL_ChangeReq        0x00000001l
+#define CFGTBL_AccCmds          0x00000001l
+
+#define CFGTBL_Trans_Simple     0x00000002l
+
+#define CFGTBL_BusType_Ultra2   0x00000001l
+#define CFGTBL_BusType_Ultra3   0x00000002l
+#define CFGTBL_BusType_Fibre1G  0x00000100l
+#define CFGTBL_BusType_Fibre2G  0x00000200l
+struct vals32 {
+	__u32   lower;
+	__u32   upper;
+};
+
+union u64bit {
+	struct vals32 val32;
+	__u64 val;
+};
+
+/* FIXME this is a per controller value (barf!) */
+#define HPSA_MAX_TARGETS_PER_CTLR 16
+#define HPSA_MAX_LUN 256
+#define HPSA_MAX_PHYS_LUN 1024
+
+/* SCSI-3 Commands */
+#pragma pack(1)
+
+#define HPSA_INQUIRY 0x12
+struct InquiryData_struct {
+	__u8 data_byte[36];
+};
+
+#define HPSA_REPORT_LOG 0xc2    /* Report Logical LUNs */
+#define HPSA_REPORT_PHYS 0xc3   /* Report Physical LUNs */
+struct ReportLUNdata_struct {
+	__u8 LUNListLength[4];
+	__u32 reserved;
+	__u8 LUN[HPSA_MAX_LUN][8];
+};
+
+struct ReportExtendedLUNdata_struct {
+	__u8 LUNListLength[4];
+	__u8 extended_response_flag;
+	__u8 reserved[3];
+	__u8 LUN[HPSA_MAX_LUN][24];
+};
+
+struct SenseSubsystem_info_struct {
+	__u8 reserved[36];
+	__u8 portname[8];
+	__u8 reserved1[1108];
+};
+
+#define HPSA_READ_CAPACITY 0x25 /* Read Capacity */
+struct ReadCapdata_struct {
+	__u8 total_size[4];	/* Total size in blocks */
+	__u8 block_size[4];	/* Size of blocks in bytes */
+};
+
+#if 0
+/* 12 byte commands not implemented in firmware yet. */
+#define HPSA_READ 	0xa8
+#define HPSA_WRITE	0xaa
+#endif
+
+#define HPSA_READ   0x28    /* Read(10) */
+#define HPSA_WRITE  0x2a    /* Write(10) */
+
+/* BMIC commands */
+#define BMIC_READ 0x26
+#define BMIC_WRITE 0x27
+#define BMIC_CACHE_FLUSH 0xc2
+#define HPSA_CACHE_FLUSH 0x01	/* C2 was already being used by HPSA */
+
+/* Command List Structure */
+union SCSI3Addr_union {
+	struct {
+		__u8 Dev;
+		__u8 Bus:6;
+		__u8 Mode:2;        /* b00 */
+	} PeripDev;
+	struct {
+		__u8 DevLSB;
+		__u8 DevMSB:6;
+		__u8 Mode:2;        /* b01 */
+	} LogDev;
+	struct {
+		__u8 Dev:5;
+		__u8 Bus:3;
+		__u8 Targ:6;
+		__u8 Mode:2;        /* b10 */
+	} LogUnit;
+};
+
+struct PhysDevAddr_struct {
+	__u32             TargetId:24;
+	__u32             Bus:6;
+	__u32             Mode:2;
+	/* 2 level target device addr */
+	union SCSI3Addr_union  Target[2];
+};
+
+struct LogDevAddr_struct {
+	__u32            VolId:30;
+	__u32            Mode:2;
+	__u8             reserved[4];
+};
+
+union LUNAddr_union {
+	__u8               LunAddrBytes[8];
+	union SCSI3Addr_union   SCSI3Lun[4];
+	struct PhysDevAddr_struct PhysDev;
+	struct LogDevAddr_struct  LogDev;
+};
+
+struct CommandListHeader_struct {
+	__u8              ReplyQueue;
+	__u8              SGList;
+	__u16             SGTotal;
+	struct vals32     Tag;
+	union LUNAddr_union    LUN;
+};
+
+struct RequestBlock_struct {
+	__u8   CDBLen;
+	struct {
+		__u8 Type:3;
+		__u8 Attribute:3;
+		__u8 Direction:2;
+	} Type;
+	__u16  Timeout;
+	__u8   CDB[16];
+};
+
+struct ErrDescriptor_struct {
+	struct vals32 Addr;
+	__u32  Len;
+};
+
+struct SGDescriptor_struct {
+	struct vals32 Addr;
+	__u32  Len;
+	__u32  Ext;
+};
+
+union MoreErrInfo_union{
+	struct {
+		__u8  Reserved[3];
+		__u8  Type;
+		__u32 ErrorInfo;
+	} Common_Info;
+	struct {
+		__u8  Reserved[2];
+		__u8  offense_size; /* size of offending entry */
+		__u8  offense_num;  /* byte # of offense 0-base */
+		__u32 offense_value;
+	} Invalid_Cmd;
+};
+struct ErrorInfo_struct {
+	__u8               ScsiStatus;
+	__u8               SenseLen;
+	__u16              CommandStatus;
+	__u32              ResidualCnt;
+	union MoreErrInfo_union  MoreErrInfo;
+	__u8               SenseInfo[SENSEINFOBYTES];
+};
+/* Command types */
+#define CMD_IOCTL_PEND  0x01
+#define CMD_SCSI	0x03
+#define CMD_MSG_DONE	0x04
+#define CMD_MSG_TIMEOUT 0x05
+
+/* This structure needs to be divisible by 8 for new
+ * indexing method.
+ */
+#define PADSIZE (sizeof(long) - 4)
+struct CommandList_struct {
+	struct CommandListHeader_struct Header;
+	struct RequestBlock_struct      Request;
+	struct ErrDescriptor_struct     ErrDesc;
+	struct SGDescriptor_struct      SG[MAXSGENTRIES];
+	/* information associated with the command */
+	__u32			   busaddr; /* physical addr of this record */
+	struct ErrorInfo_struct *err_info; /* pointer to the allocated mem */
+	int			   ctlr;
+	int			   cmd_type;
+	long			   cmdindex;
+	struct hlist_node list;
+	struct CommandList_struct *prev;
+	struct CommandList_struct *next;
+	struct request *rq;
+	struct completion *waiting;
+	int	 retry_count;
+	void   *scsi_cmd;
+	char   pad[PADSIZE];
+};
+
+/* Configuration Table Structure */
+struct HostWrite_struct {
+	__u32 TransportRequest;
+	__u32 Reserved;
+	__u32 CoalIntDelay;
+	__u32 CoalIntCount;
+};
+
+struct CfgTable_struct {
+	__u8             Signature[4];
+	__u32            SpecValence;
+	__u32            TransportSupport;
+	__u32            TransportActive;
+	struct HostWrite_struct HostWrite;
+	__u32            CmdsOutMax;
+	__u32            BusTypes;
+	__u32            Reserved;
+	__u8             ServerName[16];
+	__u32            HeartBeat;
+	__u32            SCSI_Prefetch;
+};
+
+struct hpsa_pci_info_struct {
+	unsigned char	bus;
+	unsigned char	dev_fn;
+	unsigned short	domain;
+	__u32		board_id;
+};
+
+#pragma pack()
+#endif /* HPSA_CMD_H */
diff -urNp linux-2.6/drivers/scsi/hpsa.h linux-2.6-hpsa/drivers/scsi/hpsa.h
--- linux-2.6/drivers/scsi/hpsa.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6-hpsa/drivers/scsi/hpsa.h	2009-02-27 16:42:16.000000000 -0600
@@ -0,0 +1,244 @@
+/*
+ *    Disk Array driver for HP SA 5xxx and 6xxx Controllers
+ *    Copyright 2000, 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *
+ */
+#ifndef HPSA_H
+#define HPSA_H
+
+#include <scsi/scsicam.h>
+
+#define IO_OK		0
+#define IO_ERROR	1
+
+struct ctlr_info;
+
+struct access_method {
+	void (*submit_command)(struct ctlr_info *h,
+		struct CommandList_struct *c);
+	void (*set_intr_mask)(struct ctlr_info *h, unsigned long val);
+	unsigned long (*fifo_full)(struct ctlr_info *h);
+	unsigned long (*intr_pending)(struct ctlr_info *h);
+	unsigned long (*command_completed)(struct ctlr_info *h);
+};
+
+struct sendcmd_reject_list {
+	int ncompletions;
+	unsigned long *complete; /* array of NR_CMDS tags */
+};
+
+struct hpsa_scsi_dev_t {
+	int devtype;
+	int bus, target, lun;		/* as presented to the OS */
+	unsigned char scsi3addr[8];	/* as presented to the HW */
+#define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
+	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
+	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
+	unsigned char model[16];        /* bytes 16-31 of inquiry data */
+	unsigned char revision[4];      /* bytes 32-35 of inquiry data */
+	unsigned char raid_level;	/* from inquiry page 0xC1 */
+};
+
+struct ctlr_info {
+	int	ctlr;
+	char	devname[8];
+	char    *product_name;
+	char	firm_ver[4]; /* Firmware version */
+	struct pci_dev *pdev;
+	__u32	board_id;
+	void __iomem *vaddr;
+	unsigned long paddr;
+	int 	nr_cmds; /* Number of commands allowed on this controller */
+	struct CfgTable_struct __iomem *cfgtable;
+	int	interrupts_enabled;
+	int	major;
+	int 	max_commands;
+	int	commands_outstanding;
+	int 	max_outstanding; /* Debug */
+	int	num_luns;
+	int	usage_count;  /* number of opens all all minor devices */
+#	define DOORBELL_INT	0
+#	define PERF_MODE_INT	1
+#	define SIMPLE_MODE_INT	2
+#	define MEMQ_MODE_INT	3
+	unsigned int intr[4];
+	unsigned int msix_vector;
+	unsigned int msi_vector;
+	struct access_method access;
+
+	/* queue and queue Info */
+	struct hlist_head reqQ;
+	struct hlist_head cmpQ;
+	unsigned int Qdepth;
+	unsigned int maxQsinceinit;
+	unsigned int maxSG;
+	spinlock_t lock;
+
+	/* pointers to command and error info pool */
+	struct CommandList_struct 	*cmd_pool;
+	dma_addr_t		cmd_pool_dhandle;
+	struct ErrorInfo_struct 	*errinfo_pool;
+	dma_addr_t		errinfo_pool_dhandle;
+	unsigned long  		*cmd_pool_bits;
+	int			nr_allocs;
+	int			nr_frees;
+
+	struct Scsi_Host *scsi_host;
+	spinlock_t devlock; /* to protect hba[ctlr]->dev[];  */
+	int ndevices; /* number of used elements in .dev[] array. */
+#define HPSA_MAX_SCSI_DEVS_PER_HBA 256
+	struct hpsa_scsi_dev_t dev[HPSA_MAX_SCSI_DEVS_PER_HBA];
+
+	/* Error handling routines poll for their command completions */
+	/* if they encounter a completion they weren't expecting (normally */
+	/* that shouldn't happen) they put it in scsi_rejects for later */
+	/* processing */
+	struct sendcmd_reject_list scsi_rejects;
+};
+#define HPSA_ABORT_MSG 0
+#define HPSA_DEVICE_RESET_MSG 1
+#define HPSA_BUS_RESET_MSG 2
+#define HPSA_HOST_RESET_MSG 3
+
+/*  Defining the diffent access_menthods */
+/*
+ * Memory mapped FIFO interface (SMART 53xx cards)
+ */
+#define SA5_DOORBELL	0x20
+#define SA5_REQUEST_PORT_OFFSET	0x40
+#define SA5_REPLY_INTR_MASK_OFFSET	0x34
+#define SA5_REPLY_PORT_OFFSET		0x44
+#define SA5_INTR_STATUS		0x30
+#define SA5_SCRATCHPAD_OFFSET	0xB0
+
+#define SA5_CTCFG_OFFSET	0xB4
+#define SA5_CTMEM_OFFSET	0xB8
+
+#define SA5_INTR_OFF		0x08
+#define SA5B_INTR_OFF		0x04
+#define SA5_INTR_PENDING	0x08
+#define SA5B_INTR_PENDING	0x04
+#define FIFO_EMPTY		0xffffffff
+#define HPSA_FIRMWARE_READY	0xffff0000 /* value in scratchpad register */
+
+#define  HPSA_ERROR_BIT		0x02
+
+#define HPSA_INTR_ON 	1
+#define HPSA_INTR_OFF	0
+/*
+	Send the command to the hardware
+*/
+static void SA5_submit_command(struct ctlr_info *h,
+	struct CommandList_struct *c)
+{
+#ifdef HPSA_DEBUG
+	 printk(KERN_WARNING "hpsa: Sending %x - down to controller\n",
+		c->busaddr);
+#endif /* HPSA_DEBUG */
+	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	h->commands_outstanding++;
+	if (h->commands_outstanding > h->max_outstanding)
+		h->max_outstanding = h->commands_outstanding;
+}
+
+/*
+ *  This card is the opposite of the other cards.
+ *   0 turns interrupts on...
+ *   0x08 turns them off...
+ */
+static void SA5_intr_mask(struct ctlr_info *h, unsigned long val)
+{
+	if (val) { /* Turn interrupts on */
+		h->interrupts_enabled = 1;
+		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	} else { /* Turn them off */
+		h->interrupts_enabled = 0;
+		writel(SA5_INTR_OFF,
+			h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	}
+}
+/*
+ *  Returns true if fifo is full.
+ *
+ */
+static unsigned long SA5_fifo_full(struct ctlr_info *h)
+{
+	if (h->commands_outstanding >= h->max_commands)
+		return 1;
+	else
+		return 0;
+
+}
+/*
+ *   returns value read from hardware.
+ *     returns FIFO_EMPTY if there is nothing to read
+ */
+static unsigned long SA5_completed(struct ctlr_info *h)
+{
+	unsigned long register_value
+		= readl(h->vaddr + SA5_REPLY_PORT_OFFSET);
+
+	if (register_value != FIFO_EMPTY)
+		h->commands_outstanding--;
+
+#ifdef HPSA_DEBUG
+	if (register_value != FIFO_EMPTY)
+		printk(KERN_INFO "hpsa:  Read %lx back from board\n",
+			register_value);
+	else
+		printk(KERN_INFO "hpsa:  FIFO Empty read\n");
+#endif
+
+	return register_value;
+}
+/*
+ *	Returns true if an interrupt is pending..
+ */
+static unsigned long SA5_intr_pending(struct ctlr_info *h)
+{
+	unsigned long register_value  =
+		readl(h->vaddr + SA5_INTR_STATUS);
+#ifdef HPSA_DEBUG
+	printk(KERN_INFO "hpsa: intr_pending %lx\n", register_value);
+#endif  /* HPSA_DEBUG */
+	if (register_value &  SA5_INTR_PENDING)
+		return  1;
+	return 0 ;
+}
+
+
+static struct access_method SA5_access = {
+	SA5_submit_command,
+	SA5_intr_mask,
+	SA5_fifo_full,
+	SA5_intr_pending,
+	SA5_completed,
+};
+
+struct board_type {
+	__u32	board_id;
+	char	*product_name;
+	struct access_method *access;
+};
+
+
+/* end of old hpsa_scsi.h file */
+
+#endif /* HPSA_H */
+
diff -urNp linux-2.6/drivers/scsi/Kconfig linux-2.6-hpsa/drivers/scsi/Kconfig
--- linux-2.6/drivers/scsi/Kconfig	2009-02-24 11:13:04.000000000 -0600
+++ linux-2.6-hpsa/drivers/scsi/Kconfig	2009-02-27 16:42:16.000000000 -0600
@@ -374,6 +374,12 @@ config BLK_DEV_3W_XXXX_RAID
 	  Please read the comments at the top of
 	  <file:drivers/scsi/3w-xxxx.c>.
 
+config SCSI_HPSA
+	tristate "HP Smart Array SCSI driver"
+	depends on PCI && SCSI
+	help
+	  This driver supports
+
 config SCSI_3W_9XXX
 	tristate "3ware 9xxx SATA-RAID support"
 	depends on PCI && SCSI
diff -urNp linux-2.6/drivers/scsi/Makefile linux-2.6-hpsa/drivers/scsi/Makefile
--- linux-2.6/drivers/scsi/Makefile	2009-02-24 11:13:04.000000000 -0600
+++ linux-2.6-hpsa/drivers/scsi/Makefile	2009-02-27 16:42:16.000000000 -0600
@@ -87,6 +87,7 @@ obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
+obj-$(CONFIG_SCSI_HPSA)		+= hpsa.o
 obj-$(CONFIG_SCSI_DTC3280)	+= dtc.o
 obj-$(CONFIG_SCSI_SYM53C8XX_2)	+= sym53c8xx_2/
 obj-$(CONFIG_SCSI_ZALON)	+= zalon7xx.o
