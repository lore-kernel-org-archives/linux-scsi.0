From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Thu, 02 Apr 2009 15:26:58 +0300
Message-ID: <49D4AF12.40708@panasas.com>
References: <20090402015455.GA14087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:27665 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752069AbZDBMaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 08:30:00 -0400
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>

On 04/02/2009 04:54 AM, Jeff Garzik wrote:
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

Forwarding to open-osd ml

Jeff is it OK if I pick up this patch through my tree and will push it
together with the other pending patches for 2.6.31 Kernel? I intend to
send a pull request for the exofs tree directly to Linus tonight, and
if it goes well, do so every kernel.

Unless you have intended this for the current 2.6.30 merge window which
would be hard for me to help, I don't want to push my luck.

I have already put this patch on the out-of-tree git. On your
positive feedback I can put it in the osd-Linux tree and it will
so, be included in linux-next (After the current merge window ends).

> It should be noted that the first handful of functions are duplicates of 
> fs/exofs/osd.c; an obvious consolidation is in order.
> 

I have taken that to my heart and will submit patches for that, next week.
Including a complimentary patch to this driver. These changes are only
intended for 2.6.31 though.

I also want to add a small utility that can manage objects, create, size,
remove, and mount as a complimentary wrapper for this driver is "osdblk"
a good name for such utility?

Few code comments below.

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
> +
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
> +
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

-	osd_make_credential(osdev->obj_cred, &osdev->obj);
see below

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
> +
> +	return -1;
> +}
> +
> +static void osdblk_end_request(struct osdblk_device *osdev,
> +			       struct osdblk_request *orq,
> +			       int error)
> +{
> +	struct request *rq = orq->rq;
> +	int rc;
> +
> +	/* complete request, at block layer */
> +	rc = __blk_end_request(rq, error, blk_rq_bytes(rq));
> +
> +	/* clear request slot for use */
> +	osdev->req[orq->tag].rq = NULL;
> +
> +	/* restart queue, if necessary */
> +	blk_start_queue(osdev->q);
> +}
> +
> +static void osdblk_osd_complete(struct osd_request *or, void *private)
> +{
> +	struct osdblk_request *orq = private;
> +	struct osd_sense_info osi;
> +	int ret = osd_req_decode_sense(or, &osi);
> +
> +	if (ret)
> +		ret = -EIO;
> +
> +	osd_end_request(or);
> +	osdblk_end_request(orq->osdev, orq, ret);

should be reversed, very bad things will happen otherwise

+	osdblk_end_request(orq->osdev, orq, ret);
+	osd_end_request(or);

> +}
> +
> +static void osdblk_rq_fn(struct request_queue *q)
> +{
> +	struct osdblk_device *osdev = q->queuedata;
> +	struct request *rq;
> +	struct osdblk_request *orq;
> +	struct osd_request *or;
> +	struct bio *bio;
> +	int rq_idx, do_write;
> +
> +	while (1) {
> +		rq = elv_next_request(q);
> +		if (!rq)
> +			break;
> +
> +		do_write = (rq_data_dir(rq) == WRITE);
> +
> +		bio = bio_clone(rq->bio, GFP_NOIO);
> +		if (!bio)
> +			break;
> +
> +		rq_idx = osdblk_get_free_req(osdev);
> +		if (rq_idx < 0) {
> +			bio_put(bio);
> +			blk_stop_queue(q);
> +			break;
> +		}
> +
> +		orq = &osdev->req[rq_idx];
> +		orq->tag = rq_idx;
> +		orq->rq = rq;
> +		orq->bio = bio;
> +		orq->osdev = osdev;
> +
> +		blkdev_dequeue_request(rq);
> +
> +		osd_make_credential(orq->cred, &osdev->obj);

-		osd_make_credential(orq->cred, &osdev->obj);

Don't do this here do it once on mount. The creds, once we define
the credential-manager protocol will have to be acquired at the begging.
(See below)

At much later stage, the credential-manager API will be able to callback
credentials and clients will need to reacquire them, or on credentials error
returns from I/O.

> +
> +		or = osd_start_request(osdev->osd, GFP_NOIO);
> +		if (!or) {
> +			blk_requeue_request(q, rq);
> +			bio_put(bio);
> +			break;
> +		}
> +
> +		if (do_write)
> +			osd_req_write(or, &osdev->obj, bio,
> +				      rq->sector * 512ULL);
> +		else
> +			osd_req_read(or, &osdev->obj, bio,
> +				     rq->sector * 512ULL);
> +
> +		if (osd_async_op(or, osdblk_osd_complete, orq, orq->cred)) {
> +			/* FIXME: leak OSD request 'or' ? */

yes a leak

> +			blk_requeue_request(q, rq);
	
+			or->request = NULL;

Sorry about that, I'll need to think of it some more.
Other wise osd_end_request() below will try to destroy
the request.

+			osd_end_request()


> +			bio_put(bio);
> +		}
> +	}
> +}
> +
> +static void osdblk_free_disk(struct osdblk_device *osdev)
> +{
> +	struct gendisk *disk = osdev->disk;
> +
> +	if (!disk)
> +		return;
> +
> +	if (disk->flags & GENHD_FL_UP)
> +		del_gendisk(disk);
> +	if (disk->queue)
> +		blk_cleanup_queue(disk->queue);
> +	put_disk(disk);
> +}
> +
> +static int osdblk_init_disk(struct osdblk_device *osdev)
> +{
> +	struct gendisk *disk;
> +	struct request_queue *q;
> +	int rc;
> +	u64 obj_size = 0;
> +

+	osd_make_credential(osdev->obj_cred, &osdev->obj);

Later, when credential-manager is used, this will get expensive and sleepy
possibly going on the network and back.

> +	rc = osdblk_get_obj_size(osdev, &obj_size);
> +	if (rc)
> +		return rc;
> +
> +	disk = alloc_disk(OSDBLK_MINORS_PER_MAJOR);
> +	if (!disk)
> +		return -ENOMEM;
> +
> +	sprintf(disk->disk_name, DRV_NAME "/%d", osdev->id);
> +	disk->major = osdev->major;
> +	disk->first_minor = 0;
> +	disk->fops = &osdblk_bd_ops;
> +	disk->private_data = osdev;
> +
> +	q = blk_init_queue(osdblk_rq_fn, &osdev->lock);
> +	if (!q) {
> +		put_disk(disk);
> +		return -ENOMEM;
> +	}
> +
> +	disk->queue = q;
> +
> +	q->queuedata = osdev;
> +
> +	osdev->disk = disk;
> +	osdev->q = q;
> +
> +	set_capacity(disk, obj_size);
> +	add_disk(disk);
> +
> +	return 0;
> +}
> +
> +/********************************************************************
> +  /sys/class/osdblk/
> +                     add	map OSD object to blkdev
> +                     remove	unmap OSD object
> +                     list	show mappings
> + *******************************************************************/
> +
> +static void class_osdblk_release(struct class *cls)
> +{
> +	kfree(cls);
> +}
> +
> +static ssize_t class_osdblk_show(struct class *c, char *data)
> +{
> +	int n = 0;
> +	int idx;
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +	for (idx = 0; idx < OSDBLK_MAX_DEVS; idx++) {
> +		struct osdblk_device *osdev = osdblk_devs[idx];
> +		if (!osdev)
> +			continue;
> +		n += sprintf(data+n, "%d %d %lu %lu %s\n",
> +			osdev->id,
> +			osdev->major,
> +			osdev->part_id,
> +			osdev->obj_id,
> +			osdev->osd_path);
> +	}
> +	mutex_unlock(&ctl_mutex);
> +	return n;
> +}
> +
> +static ssize_t class_osdblk_add(struct class *c, const char *buf, size_t count)
> +{
> +	struct osdblk_device *osdev;
> +	ssize_t rc;
> +	int idx, irc;
> +
> +	osdev = kzalloc(sizeof(*osdev) + strlen(buf) + 1, GFP_KERNEL);
> +	if (!osdev)
> +		return -ENOMEM;
> +
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +
> +	for (idx = 0; idx < OSDBLK_MAX_DEVS; idx++) {
> +		if (!osdblk_devs[idx]) {
> +			osdblk_devs[idx] = osdev;
> +			osdev->id = idx;
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&ctl_mutex);
> +
> +	if (idx == OSDBLK_MAX_DEVS) {
> +		rc = -ENOSPC;
> +		goto err_out;
> +	}
> +
> +	if (sscanf(buf, "%lu %lu %s", &osdev->part_id, &osdev->obj_id,

-	if (sscanf(buf, "%lu %lu %s", &osdev->part_id, &osdev->obj_id,
+	if (sscanf(buf, "%llu %llu %s", &osdev->obj.partition, &osdev->obj.id,

> +		   osdev->osd_path) != 3) {
> +		rc = -EINVAL;
> +		goto err_out_slot;
> +	}
> +
> +	osdev->obj.partition = osdev->part_id;
> +	osdev->obj.id = osdev->obj_id;

-	osdev->obj.partition = osdev->part_id;
-	osdev->obj.id = osdev->obj_id;

osdev->obj_id, and osdev->part_id can be removed.

> +
> +	sprintf(osdev->name, DRV_NAME "%d", osdev->id);
> +	spin_lock_init(&osdev->lock);
> +
> +	osdev->osd = osduld_path_lookup(osdev->osd_path);
> +	if (IS_ERR(osdev->osd)) {
> +		rc = PTR_ERR(osdev->osd);
> +		goto err_out_slot;
> +	}
> +
> +	irc = register_blkdev(0, osdev->name);
> +	if (irc < 0) {
> +		rc = irc;
> +		goto err_out_osd;
> +	}
> +
> +	osdev->major = irc;
> +
> +	rc = osdblk_init_disk(osdev);
> +	if (rc)
> +		goto err_out_blkdev;
> +
> +	return 0;
> +
> +err_out_blkdev:
> +	unregister_blkdev(osdev->major, osdev->name);
> +err_out_osd:
> +	osduld_put_device(osdev->osd);
> +err_out_slot:
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +	osdblk_devs[osdev->id] = NULL;
> +	mutex_unlock(&ctl_mutex);
> +err_out:
> +	kfree(osdev);
> +	return rc;
> +}
> +
> +static ssize_t class_osdblk_remove(struct class *c, const char *buf,
> +					size_t count)
> +{
> +	struct osdblk_device *osdev;
> +	int target_id;
> +
> +	if (sscanf(buf, "%d", &target_id) != 1)
> +		return -EINVAL;
> +	if (target_id < 0 || target_id >= OSDBLK_MAX_DEVS)
> +		return -EINVAL;
> +
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +	osdev = osdblk_devs[target_id];
> +	osdblk_devs[target_id] = NULL;
> +	mutex_unlock(&ctl_mutex);
> +
> +	if (!osdev)
> +		return -ENOENT;
> +
> +	osdblk_free_disk(osdev);
> +	unregister_blkdev(osdev->major, osdev->name);
> +	osduld_put_device(osdev->osd);
> +	kfree(osdev);
> +
> +	return 0;
> +}
> +
> +static struct class_attribute class_osdblk_attrs[] = {
> +	__ATTR(add,	0200, NULL, class_osdblk_add),
> +	__ATTR(remove,	0200, NULL, class_osdblk_remove),
> +	__ATTR(list,	0444, class_osdblk_show, NULL),
> +	__ATTR_NULL
> +};
> +
> +static int osdblk_sysfs_init(void)
> +{
> +	int ret = 0;
> +
> +	/*
> +	 * create control files in sysfs
> +	 * /sys/class/osdblk/...
> +	 */
> +	class_osdblk = kzalloc(sizeof(*class_osdblk), GFP_KERNEL);
> +	if (!class_osdblk)
> +		return -ENOMEM;
> +
> +	class_osdblk->name = DRV_NAME;
> +	class_osdblk->owner = THIS_MODULE;
> +	class_osdblk->class_release = class_osdblk_release;
> +	class_osdblk->class_attrs = class_osdblk_attrs;
> +
> +	ret = class_register(class_osdblk);
> +	if (ret) {
> +		kfree(class_osdblk);
> +		class_osdblk = NULL;
> +		printk(PFX "failed to create class osdblk\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void osdblk_sysfs_cleanup(void)
> +{
> +	if (class_osdblk)
> +		class_destroy(class_osdblk);
> +	class_osdblk = NULL;
> +}
> +
> +static int __init osdblk_init(void)
> +{
> +	int rc;
> +
> +	rc = osdblk_sysfs_init();
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static void __exit osdblk_exit(void)
> +{
> +	osdblk_sysfs_cleanup();
> +}
> +
> +module_init(osdblk_init);
> +module_exit(osdblk_exit);
> +

What can I say, great stuff.

OSD is a very clean API, that makes whole subsystems look trivial.

Thanks a million
Boaz
