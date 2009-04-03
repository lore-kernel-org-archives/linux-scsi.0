From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Fri, 03 Apr 2009 01:32:04 +0000
Message-ID: <1238722324.13399.25.camel@mulgrave.int.hansenpartnership.com>
References: <20090402015455.GA14087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763967AbZDCBc1@vger.kernel.org>
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-04-01 at 21:54 -0400, Jeff Garzik wrote:
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.
> 
> See the comment block at the top of the driver for usage instructions.
> 
> 
> 
>  drivers/block/Kconfig  |   16 +
>  drivers/block/Makefile |    1 
>  drivers/block/osdblk.c |  563 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 580 insertions(+)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index e7b8aa0..ff46b0e 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -298,6 +298,22 @@ config BLK_DEV_NBD
>  
>  	  If unsure, say N.
>  
> +config BLK_DEV_OSD
> +	tristate "OSD object-as-blkdev support"
> +	depends on SCSI_OSD_INITIATOR
> +	---help---
> +	  Saying Y or M here will allow the exporting of a single SCSI
> +	  OSD (object-based storage) object as a Linux block device.
> +
> +	  For example, if you create a 2G object on an OSD device,
> +	  you can then use this module to present that 2G object as
> +	  a Linux block device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called osdblk.
> +
> +	  If unsure, say N.
> +
>  config BLK_DEV_SX8
>  	tristate "Promise SATA SX8 support"
>  	depends on PCI
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 3145141..859bf5d 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_BLK_DEV_DAC960)	+= DAC960.o
>  obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
>  obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
>  obj-$(CONFIG_SUNVDC)		+= sunvdc.o
> +obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
>  
>  obj-$(CONFIG_BLK_DEV_UMEM)	+= umem.o
>  obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> new file mode 100644
> index 0000000..d3a2fb5
> --- /dev/null
> +++ b/drivers/block/osdblk.c
> @@ -0,0 +1,563 @@
> +
> +/*
> +   osdblk.c -- Export a single SCSI OSD object as a Linux block device
> +
> +
> +   Copyright 2009 Red Hat, Inc.
> +
> +   This program is free software; you can redistribute it and/or modify
> +   it under the terms of the GNU General Public License as published by
> +   the Free Software Foundation.
> +
> +   This program is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with this program; see the file COPYING.  If not, write to
> +   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> +
> +
> +   Instructions for use
> +   --------------------
> +
> +   1) Map a Linux block device to an existing OSD object.
> +
> +      In this example, we will use partition id 1234, object id 5678,
> +      OSD device /dev/osd1.
> +
> +      $ echo "1234 5678 /dev/osd1" > /sys/class/osdblk/add
> +
> +
> +   2) List all active blkdev<->object mappings.
> +
> +      In this example, we have performed step #1 twice, creating two blkdevs,
> +      mapped to two separate OSD objects.
> +
> +      $ cat /sys/class/osdblk/list
> +      0 174 1234 5678 /dev/osd1
> +      1 179 1994 897123 /dev/osd0

This is a slight violation of the one piece of data per sysfs file
rule ... might it not be better as a file named <partid>-<objid> linking
to the osd device location in sysfs?

> +      The columns, in order, are:
> +      - blkdev unique id
> +      - blkdev assigned major
> +      - OSD object partition id
> +      - OSD object id
> +      - OSD device
> +
> +
> +   3) Remove an active blkdev<->object mapping.
> +
> +      $ echo 1 > /sys/class/osdblk/remove
> +
> +
> +   NOTE:  The actual creation and deletion of OSD objects is outside the scope
> +   of this driver.
> +
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <scsi/osd_initiator.h>
> +#include <scsi/osd_attributes.h>
> +#include <scsi/osd_sec.h>
> +
> +#define DRV_NAME "osdblk"
> +#define PFX DRV_NAME ": "
> +
> +struct osdblk_device;
> +
> +enum {
> +	OSDBLK_MAX_DEVS		= 64,
> +	OSDBLK_MINORS_PER_MAJOR	= 256,
> +	OSDBLK_MAX_REQ		= 32,
> +	OSDBLK_OP_TIMEOUT	= 4 * 60,
> +};
> +
> +struct osdblk_request {
> +	struct request		*rq;
> +	struct bio		*bio;
> +	struct osdblk_device	*osdev;
> +	int			tag;
> +	uint8_t			cred[OSD_CAP_LEN];
> +};
> +
> +struct osdblk_device {
> +	int			id;
> +
> +	int			major;
> +	struct gendisk		*disk;
> +	struct request_queue	*q;
> +
> +	struct osd_dev		*osd;
> +
> +	char			name[32];
> +
> +	spinlock_t		lock;
> +
> +	struct osd_obj_id	obj;
> +	uint8_t			obj_cred[OSD_CAP_LEN];
> +
> +	struct osdblk_request	req[OSDBLK_MAX_REQ];
> +
> +	unsigned long		part_id;
> +	unsigned long		obj_id;
> +	char			osd_path[0];
> +};
> +
> +static struct class *class_osdblk;		/* /sys/class/osdblk */
> +static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
> +static struct osdblk_device *osdblk_devs[OSDBLK_MAX_DEVS];

Might it not be better to do this as a linked list on the private dev
structure instead?  This only works if you have one entry
in /sys/class/osdblock per device because now you have a device private
pointer to hang it off

> +static struct block_device_operations osdblk_bd_ops = {
> +	.owner		= THIS_MODULE,
> +};
> +
> +const struct osd_attr g_attr_logical_length = ATTR_DEF(
> +	OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_LOGICAL_LENGTH, 8);
> +
> +static void osd_make_credential(u8 cred_a[OSD_CAP_LEN],
> +				const struct osd_obj_id *obj)
> +{
> +	osd_sec_init_nosec_doall_caps(cred_a, obj, false, true);
> +}
> +
> +/*
> + * Perform a synchronous OSD operation.
> + */
> +static int osd_sync_op(struct osd_request *or, int timeout, uint8_t *credential)
> +{
> +	int ret;
> +
> +	or->timeout = timeout;
> +	ret = osd_finalize_request(or, 0, credential, NULL);
> +	if (ret)
> +		return ret;
> +
> +	ret = osd_execute_request(or);
> +
> +	/* osd_req_decode_sense(or, ret); */
> +	return ret;
> +}
> +
> +/*
> + * Perform an asynchronous OSD operation.
> + */
> +static int osd_async_op(struct osd_request *or, osd_req_done_fn *async_done,
> +		   void *caller_context, u8 *cred)
> +{
> +	int ret;
> +
> +	ret = osd_finalize_request(or, 0, cred, NULL);
> +	if (ret)
> +		return ret;
> +
> +	ret = osd_execute_request_async(or, async_done, caller_context);
> +
> +	return ret;
> +}
> +
> +static int extract_attr_from_req(struct osd_request *or, struct osd_attr *attr)
> +{
> +	struct osd_attr cur_attr = {.attr_page = 0}; /* start with zeros */
> +	void *iter = NULL;
> +	int nelem;
> +
> +	do {
> +		nelem = 1;
> +		osd_req_decode_get_attr_list(or, &cur_attr, &nelem, &iter);
> +		if ((cur_attr.attr_page == attr->attr_page) &&
> +		    (cur_attr.attr_id == attr->attr_id)) {
> +			attr->len = cur_attr.len;
> +			attr->val_ptr = cur_attr.val_ptr;
> +			return 0;
> +		}
> +	} while (iter);
> +
> +	return -EIO;
> +}
> +
> +static int osdblk_get_obj_size(struct osdblk_device *osdev, u64 *size_out)
> +{
> +	struct osd_request *or;
> +	struct osd_attr attr;
> +	int ret;
> +
> +	osd_make_credential(osdev->obj_cred, &osdev->obj);
> +
> +	or = osd_start_request(osdev->osd, GFP_KERNEL);
> +	if (!or)
> +		return -ENOMEM;
> +
> +	osd_req_get_attributes(or, &osdev->obj);
> +
> +	osd_req_add_get_attr_list(or, &g_attr_logical_length, 1);
> +
> +	/* execute op synchronously */
> +	ret = osd_sync_op(or, OSDBLK_OP_TIMEOUT, osdev->obj_cred);
> +	if (ret)
> +		goto out;
> +
> +	attr = g_attr_logical_length;
> +	ret = extract_attr_from_req(or, &attr);
> +	if (ret)
> +		goto out;
> +
> +	*size_out = get_unaligned_be64(attr.val_ptr);
> +
> +out:
> +	osd_end_request(or);
> +	return ret;
> +
> +}
> +
> +static int osdblk_get_free_req(struct osdblk_device *osdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < OSDBLK_MAX_REQ; i++) {
> +		if (!osdev->req[i].rq)
> +			return i;
> +	}

Rather than using a static list of outstanding requests, I think you
could probably use the block tag handling infrastructure for all of this

The rest looks fine.

James
