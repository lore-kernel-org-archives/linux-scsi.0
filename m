From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3 v3] osdblk: a Linux block device for OSD objects
Date: Mon, 27 Apr 2009 18:59:42 +0300
Message-ID: <49F5D66E.2040506@panasas.com>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org> <20090410114821.GA10602@havoc.gtf.org> <20090410114908.GB10602@havoc.gtf.org> <20090410115045.GC10602@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090410115045.GC10602@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, osd-dev@open-osd.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/10/2009 02:50 PM, Jeff Garzik wrote:
> NOT-Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Changes since last version:
> - support bio chains
> 
> Still needs testing with some real OSD devices...
> 
> 
>  drivers/block/Kconfig            |   16 
>  drivers/block/Makefile           |    1 
>  drivers/block/osdblk.c           |  669 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 754 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index ddea8e4..34722c8 100644
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
> index 7755a5e..cdaa3f8 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
>  obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
>  obj-$(CONFIG_MG_DISK)		+= mg_disk.o
>  obj-$(CONFIG_SUNVDC)		+= sunvdc.o
> +obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
>  
>  obj-$(CONFIG_BLK_DEV_UMEM)	+= umem.o
>  obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> new file mode 100644
> index 0000000..c7a1bb7
> --- /dev/null
> +++ b/drivers/block/osdblk.c
> @@ -0,0 +1,669 @@
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
> +      In this example, we remove the mapping with blkdev unique id 1.
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
> +	OSDBLK_MINORS_PER_MAJOR	= 256,		/* max minors per blkdev */
> +	OSDBLK_MAX_REQ		= 32,		/* max parallel requests */
> +	OSDBLK_OP_TIMEOUT	= 4 * 60,	/* sync OSD req timeout */
> +};
> +
> +struct osdblk_request {
> +	struct request		*rq;		/* blk layer request */
> +	struct bio		*bio;		/* cloned bio */
> +	struct osdblk_device	*osdev;		/* associated blkdev */
> +};
> +
> +struct osdblk_device {
> +	int			id;		/* blkdev unique id */
> +
> +	int			major;		/* blkdev assigned major */
> +	struct gendisk		*disk;		/* blkdev's gendisk and rq */
> +	struct request_queue	*q;
> +
> +	struct osd_dev		*osd;		/* associated OSD */
> +
> +	char			name[32];	/* blkdev name, e.g. osdblk34 */
> +
> +	spinlock_t		lock;		/* queue lock */
> +
> +	struct osd_obj_id	obj;		/* OSD partition, obj id */
> +	uint8_t			obj_cred[OSD_CAP_LEN]; /* OSD cred */
> +
> +	struct osdblk_request	req[OSDBLK_MAX_REQ]; /* request table */
> +
> +	struct list_head	node;
> +
> +	char			osd_path[0];	/* OSD device path */
> +};
> +
> +static struct class *class_osdblk;		/* /sys/class/osdblk */
> +static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
> +static LIST_HEAD(osdblkdev_list);
> +
> +static struct block_device_operations osdblk_bd_ops = {
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct osd_attr g_attr_logical_length = ATTR_DEF(
> +	OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_LOGICAL_LENGTH, 8);
> +
> +/* copied from exofs; move to libosd? */

- /* copied from exofs; move to libosd? */

> +static void osd_make_credential(u8 cred_a[OSD_CAP_LEN],
> +				const struct osd_obj_id *obj)
> +{
> +	osd_sec_init_nosec_doall_caps(cred_a, obj, false, true);
> +}
> +

this member should stay. It will be enhanced in the future with calls
to a network security manager. For now it issues it's own NO_SEC caps.
Perhaps osd_make_credential => osdblk_make_credential?

+ /* copied from exofs; move to libosd? */

> +/*
> + * Perform a synchronous OSD operation.  copied from exofs; move to libosd?
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
> + * Perform an asynchronous OSD operation.  copied from exofs; move to libosd?
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

NOTE-TO-ME:
  these two will be changed to plain osd_execute_* where osd_finalize_request
  will be called internally.

> +/* copied from exofs; move to libosd? */
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

NOTE-TO-ME:
  This is needed because of a bug (short-comings) in osd_req_decode_get_attr_list().
  Once fixed it can be just removed.

> +static int osdblk_get_obj_size(struct osdblk_device *osdev, u64 *size_out)
> +{
> +	struct osd_request *or;
> +	struct osd_attr attr;
> +	int ret;
> +
> +	/* start request */
> +	or = osd_start_request(osdev->osd, GFP_KERNEL);
> +	if (!or)
> +		return -ENOMEM;
> +
> +	/* create a get-attributes(length) request */
> +	osd_req_get_attributes(or, &osdev->obj);
> +
> +	osd_req_add_get_attr_list(or, &g_attr_logical_length, 1);
> +
> +	/* execute op synchronously */
> +	ret = osd_sync_op(or, OSDBLK_OP_TIMEOUT, osdev->obj_cred);
> +	if (ret)
> +		goto out;
> +
> +	/* extract length from returned attribute info */
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
> +static void osdblk_end_request(struct osdblk_device *osdev,
> +			       struct osdblk_request *orq,
> +			       int error)
> +{
> +	struct request *rq = orq->rq;
> +	int rc;
> +
> +	/* complete request, at block layer */
> +	rc = __blk_end_request(rq, error, blk_rq_bytes(rq));
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
> +	/* complete OSD request */
> +	osd_end_request(or);
> +
> +	/* complete request passed to osdblk by block layer */
> +	osdblk_end_request(orq->osdev, orq, ret);

Only a single user left for osdblk_end_request(). Perhaps it would be
more clear to open code it?

> +}
> +
> +static void bio_chain_put(struct bio *chain)
> +{
> +	struct bio *tmp;
> +
> +	while (chain) {
> +		tmp = chain;
> +		chain = chain->bi_next;
> +
> +		bio_put(tmp);
> +	}
> +}
> +

NOTE-TO-ME:
  blk_bio_put()

> +static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
> +{
> +	struct bio *tmp, *new_chain = NULL, *tail = NULL;
> +
> +	while (old_chain) {
> +		tmp = bio_clone(old_chain, gfpmask);
> +		if (!tmp)
> +			goto err_out;
> +
> +		tmp->bi_next = NULL;
> +		if (!new_chain)
> +			new_chain = tail = tmp;
> +		else {
> +			tail->bi_next = tmp;
> +			tail = tmp;
> +		}
> +
> +		old_chain = old_chain->bi_next;
> +	}
> +
> +	return new_chain;
> +
> +err_out:
> +	bio_chain_put(new_chain);
> +	return NULL;
> +}
> +

NOTE-TO-ME:
  blk_bio_clone()

> +static void osdblk_rq_fn(struct request_queue *q)
> +{
> +	struct osdblk_device *osdev = q->queuedata;
> +	struct request *rq;
> +	struct osdblk_request *orq;
> +	struct osd_request *or;
> +	struct bio *bio;
> +	int do_write, do_flush;
> +
> +	while (1) {
> +		/* peek at request from block layer */
> +		rq = elv_next_request(q);
> +		if (!rq)
> +			break;
> +
> +		/* filter out block requests we don't understand */
> +		if (!blk_fs_request(rq) && !blk_barrier_rq(rq)) {
> +			end_request(rq, 0);
> +			continue;
> +		}
> +
> +		/* deduce our operation (read, write, flush) */
> +		/* I wish the block layer simplified cmd_type/cmd_flags/cmd[]
> +		 * into a clearly defined set of RPC commands:
> +		 * read, write, flush, scsi command, power mgmt req,
> +		 * driver-specific, etc.
> +		 */
> +
> +		do_flush = (rq->special == (void *) 0xdeadbeefUL);

That's for real? or it needs a "FIXME" next to it?

> +		do_write = (rq_data_dir(rq) == WRITE);
> +
> +		/* a bio clone to be passed down to OSD request */
> +		bio = bio_chain_clone(rq->bio, GFP_ATOMIC);
> +		if (!bio)
> +			break;

does blk_barrier_rq() have a rq->bio?

> +
> +		/* alloc internal OSD request, for OSD command execution */
> +		or = osd_start_request(osdev->osd, GFP_ATOMIC);
> +		if (!or) {
> +			bio_chain_put(bio);
> +			break;
> +		}
> +
> +		orq = &osdev->req[rq->tag];
> +		orq->rq = rq;
> +		orq->bio = bio;
> +		orq->osdev = osdev;
> +
> +		/* init OSD command: flush, write or read */
> +		if (do_flush)
> +			osd_req_flush_object(or, &osdev->obj,
> +					     OSD_CDB_FLUSH_ALL, 0, 0);

Is this enough? I mean, osd_req_flush_object+osd_async_op will insure osd-target
writes all it's caches to stable storage. But what about in-flight requests.
Do we need to wait for all requests to finish then issue the flush, or does
the block layer do that for us? (is queue empty at this point?)

> +		else if (do_write)
> +			osd_req_write(or, &osdev->obj, bio,
> +				      rq->sector * 512ULL);
> +		else
> +			osd_req_read(or, &osdev->obj, bio,
> +				     rq->sector * 512ULL);
> +

OK, this is my original mistake, question remains:

Are we guaranteed that blk_rq_bytes(rq) (see osdblk_end_request) is the same
as chained_size(bio). I think that there are corner cases when it might be a bit
shorter (bio-size was rounded up)

I wish we just pass total_bytes to osd_req_read/write and let blk layer sort this
out. Will also save the trouble inside osd_req_read/write too.

so for example:

+			osd_req_read(or, &osdev->obj, bio, blk_rq_bytes(rq),
+				     rq->sector * 512ULL);

(It should be no trouble to change all users)

> +		/* begin OSD command execution */
> +		if (osd_async_op(or, osdblk_osd_complete, orq,
> +				 osdev->obj_cred)) {
> +			osd_end_request(or);
> +			blk_requeue_request(q, rq);
> +			bio_chain_put(bio);
> +		}
> +
> +		/* remove the special 'flush' marker, now that the command
> +		 * is executing
> +		 */
> +		rq->special = NULL;
> +	}
> +}
> +
> +static void osdblk_prepare_flush(struct request_queue *q, struct request *rq)
> +{
> +	/* add driver-specific marker, to indicate that this request
> +	 * is a flush command
> +	 */
> +	rq->special = (void *) 0xdeadbeefUL;

OK now I get it, disregard the comment above

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
> +	/* contact OSD, request size info about the object being mapped */
> +	rc = osdblk_get_obj_size(osdev, &obj_size);
> +	if (rc)
> +		return rc;
> +
> +	/* create gendisk info */
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
> +	/* init rq */
> +	q = blk_init_queue(osdblk_rq_fn, &osdev->lock);
> +	if (!q) {
> +		put_disk(disk);
> +		return -ENOMEM;
> +	}
> +
> +	/* switch queue to TCQ mode; allocate tag map */
> +	rc = blk_queue_init_tags(q, OSDBLK_MAX_REQ, NULL);
> +	if (rc) {
> +		blk_cleanup_queue(q);
> +		put_disk(disk);
> +		return rc;
> +	}
> +
> +	blk_queue_prep_rq(q, blk_queue_start_tag);
> +	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
> +
> +	disk->queue = q;
> +
> +	q->queuedata = osdev;
> +
> +	osdev->disk = disk;
> +	osdev->q = q;
> +
> +	/* finally, announce the disk to the world */
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
> +static ssize_t class_osdblk_list(struct class *c, char *data)
> +{
> +	int n = 0;
> +	struct list_head *tmp;
> +
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +
> +	list_for_each(tmp, &osdblkdev_list) {
> +		struct osdblk_device *osdev;
> +
> +		osdev = list_entry(tmp, struct osdblk_device, node);
> +
> +		n += sprintf(data+n, "%d %d %llu %llu %s\n",
> +			osdev->id,
> +			osdev->major,
> +			osdev->obj.partition,
> +			osdev->obj.id,
> +			osdev->osd_path);
> +	}
> +
> +	mutex_unlock(&ctl_mutex);
> +	return n;
> +}
> +
> +static ssize_t class_osdblk_add(struct class *c, const char *buf, size_t count)
> +{
> +	struct osdblk_device *osdev;
> +	ssize_t rc;
> +	int irc, new_id = 0;
> +	struct list_head *tmp;
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;
> +
> +	/* new osdblk_device object */
> +	osdev = kzalloc(sizeof(*osdev) + strlen(buf) + 1, GFP_KERNEL);
> +	if (!osdev) {
> +		rc = -ENOMEM;
> +		goto err_out_mod;
> +	}
> +
> +	/* static osdblk_device initialization */
> +	spin_lock_init(&osdev->lock);
> +	INIT_LIST_HEAD(&osdev->node);
> +
> +	/* generate unique id: find highest unique id, add one */
> +
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +
> +	list_for_each(tmp, &osdblkdev_list) {
> +		struct osdblk_device *osdev;
> +
> +		osdev = list_entry(tmp, struct osdblk_device, node);
> +		if (osdev->id > new_id)
> +			new_id = osdev->id + 1;
> +	}
> +
> +	osdev->id = new_id;
> +
> +	/* add to global list */
> +	list_add_tail(&osdev->node, &osdblkdev_list);
> +
> +	mutex_unlock(&ctl_mutex);
> +
> +	/* parse add command */
> +	if (sscanf(buf, "%llu %llu %s", &osdev->obj.partition, &osdev->obj.id,
> +		   osdev->osd_path) != 3) {
> +		rc = -EINVAL;
> +		goto err_out_slot;
> +	}
> +
> +	/* initialize rest of new object */
> +	sprintf(osdev->name, DRV_NAME "%d", osdev->id);
> +
> +	/* contact requested OSD */
> +	osdev->osd = osduld_path_lookup(osdev->osd_path);
> +	if (IS_ERR(osdev->osd)) {
> +		rc = PTR_ERR(osdev->osd);
> +		goto err_out_slot;
> +	}
> +
> +	/* build OSD credential */
> +	osd_make_credential(osdev->obj_cred, &osdev->obj);
> +
> +	/* register our block device */
> +	irc = register_blkdev(0, osdev->name);
> +	if (irc < 0) {
> +		rc = irc;
> +		goto err_out_osd;
> +	}
> +
> +	osdev->major = irc;
> +
> +	/* set up and announce blkdev mapping */
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
> +	list_del_init(&osdev->node);
> +	mutex_unlock(&ctl_mutex);
> +
> +	kfree(osdev);
> +err_out_mod:
> +	module_put(THIS_MODULE);
> +	return rc;
> +}
> +
> +static ssize_t class_osdblk_remove(struct class *c, const char *buf,
> +					size_t count)
> +{
> +	struct osdblk_device *osdev = NULL;
> +	int target_id, rc;
> +	unsigned long ul;
> +	struct list_head *tmp;
> +
> +	rc = strict_strtoul(buf, 10, &ul);
> +	if (rc)
> +		return rc;
> +
> +	/* convert to int; abort if we lost anything in the conversion */
> +	target_id = (int) ul;
> +	if (target_id != ul)
> +		return -EINVAL;
> +
> +	/* remove object from list immediately */
> +	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
> +
> +	list_for_each(tmp, &osdblkdev_list) {
> +		osdev = list_entry(tmp, struct osdblk_device, node);
> +		if (osdev->id == target_id) {
> +			list_del_init(&osdev->node);
> +			break;
> +		}
> +		osdev = NULL;
> +	}
> +
> +	mutex_unlock(&ctl_mutex);
> +
> +	if (!osdev)
> +		return -ENOENT;
> +
> +	/* clean up and free blkdev and associated OSD connection */
> +	osdblk_free_disk(osdev);
> +	unregister_blkdev(osdev->major, osdev->name);
> +	osduld_put_device(osdev->osd);
> +	kfree(osdev);
> +
> +	/* release module ref */
> +	module_put(THIS_MODULE);
> +
> +	return 0;
> +}
> +
> +static struct class_attribute class_osdblk_attrs[] = {
> +	__ATTR(add,	0200, NULL, class_osdblk_add),
> +	__ATTR(remove,	0200, NULL, class_osdblk_remove),
> +	__ATTR(list,	0444, class_osdblk_list, NULL),
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

I think we should push for a couple of new block-layer APIs:

blk_bio_put() - takes care of chained bio's
blk_bio_clone() - clones a chain. Set all directions and sizes properly

and also for osd_initiator we will need something like:
  blk_make_request(bio, total_bytes, ...) 
  That can deal with a chained-bio and sets all sizes and members accordingly.

Perhaps there will be many other users for these APIs?

Also one more comment:
  I'm not sure, but maybe you would want to set all upper request_queue
  alignments, masks and limits to be byte-aligned, maximum aloud, this will
  avoid any kind of un-wanted bouncing at the upper level. If any,
  (not iscsi osd), proper bouncing will be done at the lower-level request_queue
  where the right limitations are known. (and are done once).

Thanks
Boaz
