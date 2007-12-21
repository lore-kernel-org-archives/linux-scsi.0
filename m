From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cciss: export more attributes to sysfs (repost)
Date: Fri, 21 Dec 2007 15:16:47 -0800
Message-ID: <20071221151647.ac8f864c.akpm@linux-foundation.org>
References: <20071214221744.GA32019@roadking.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbXLUXRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 18:17:07 -0500
In-Reply-To: <20071214221744.GA32019@roadking.usa.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 14 Dec 2007 16:17:44 -0600
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 3
> 
> Sorry to take so long to repost.
> 
> This patch exports more attributes to /sys so we can work work better with
> udev. Some distros use unique_id among other attributes. This patch attempts
> to provide that and other attributes to reveal more information about cciss
> devices in /sys. It's also an effort to be more sysfs friendly.
> Please consider this for inclusion.
> 

I'm getting some deja vu here.  I'm sure I already commented on some of
these things?

> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 7d70496..54080e6 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -229,20 +229,485 @@ static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
>  	return c;
>  }
>  
> +static inline int find_drv_index(int ctlr, drive_info_struct *drv){
> +        int i;
> +        for (i=0; i < CISS_MAX_LUN; i++) {
> +                if (hba[ctlr]->drv[i].LunID == drv->LunID)
> +                        return i;
> +        }
> +        return i;
> +}

pleeeeeeeeeeeze always feed all diffs through scripts/checkpatch.pl.  Twice.

This function has multiple coding-style mistakes.

It is also far too large to be inlined.

>  #include "cciss_scsi.c"		/* For SCSI tape support */
>  
> +#define ENG_GIG 1000000000
> +#define ENG_GIG_FACTOR (ENG_GIG/512)
>  #define RAID_UNKNOWN 6
> +static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
> +	"UNKNOWN"};
> +
> +
> +static spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;

checkpatch would have informed you about this mistake as well.

> +static void cciss_sysfs_stat_inquiry(int ctlr, int logvol,
> +			int withirq, drive_info_struct *drv)
> +{
> +	int return_code;
> +	InquiryData_struct *inq_buff;
> +
> +	/* If there are no heads then this is the controller disk and
> +	 * not a valid logical drive so don't query it.
> +	 */
> +	if (!drv->heads)
> +		return;
> +
> +	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
> +	if (!inq_buff) {
> +		printk(KERN_ERR "cciss: out of memory\n");

This failure gets dropped on the floor.  Is there really no need to report
it?  Will the driver still correctly function even thoug this function
didn't do anything?

> +		goto err;
> +	}
> +
> +	if (withirq)
> +		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
> +			inq_buff, sizeof(*inq_buff), 1, logvol ,0, TYPE_CMD);
> +	else
> +		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
> +			sizeof(*inq_buff), 1, logvol , 0, NULL, TYPE_CMD);
> +	if (return_code == IO_OK) {
> +		memcpy(drv->vendor, &inq_buff->data_byte[8], 8);
> +		drv->vendor[8]='\0';
> +		memcpy(drv->model, &inq_buff->data_byte[16], 16);
> +		drv->model[16] = '\0';
> +		memcpy(drv->rev, &inq_buff->data_byte[32], 4);
> +		drv->rev[4] = '\0';
> +	} else { /* Get geometry failed */
> +		printk(KERN_WARNING "cciss: inquiry for VPD page 0 failed\n");
> +	}
> +
> +	if (withirq)
> +		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
> +			inq_buff, sizeof(*inq_buff), 1, logvol ,0x83, TYPE_CMD);
> +	else
> +		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
> +			sizeof(*inq_buff), 1, logvol , 0x83, NULL, TYPE_CMD);
> +
> +	if (return_code == IO_OK) {
> +		memcpy(drv->uid, &inq_buff->data_byte[8], 16);
> +	} else { /* Get geometry failed */
> +		printk(KERN_WARNING "cciss: inquiry for VPD page 83 failed\n");
> +	}
> +
> +	kfree(inq_buff);
> +err:
> +	drv->vendor[8] = '\0';
> +	drv->model[16] = '\0';
> +	drv->rev[4] = '\0';
> +
> +}
> +
> +static ssize_t cciss_show_raid_level(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct drv_dynamic *d;
> +	drive_info_struct *drv;
> +	ctlr_info_t *h;
> +	unsigned long flags;
> +	int raid;
> +
> +	d = container_of(dev, struct drv_dynamic, dev);
> +	spin_lock(&sysfs_lock);
> +	if (!d->disk) {
> +		spin_unlock(&sysfs_lock);
> +		return -ENOENT;
> +	}
> +
> +	h = get_host(d->disk);
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return snprintf(buf, 30, "Device busy configuring\n");
> +	}

The above code snippet gets repeated again and again and again.  As I
suggested last time: can this be fixed?

> +	drv = d->disk->private_data;
> +	if ((drv->raid_level < 0) || (drv->raid_level) > 5)
> +		raid = RAID_UNKNOWN;
> +	else
> +		raid = drv->raid_level;
> +
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +	spin_unlock(&sysfs_lock);
> +	return snprintf(buf, 20, "RAID %s\n", raid_label[raid]);
> +}
>
> ...
>
> +static ssize_t cciss_show_disk_size(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct drv_dynamic *d;
> +	drive_info_struct *drv;
> +	ctlr_info_t *h;
> +	unsigned long flags;
> +	sector_t vol_sz, vol_sz_frac;
> +
> +	d = container_of(dev, struct drv_dynamic, dev);
> +	spin_lock(&sysfs_lock);
> +	if (!d->disk) {
> +		spin_unlock(&sysfs_lock);
> +		return -ENOENT;
> +	}
> +	h = get_host(d->disk);
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return snprintf(buf, 30, "Device busy configuring\n");
> +	}
> +
> +	drv = d->disk->private_data;
> +	vol_sz = drv->nr_blocks;
> +	vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
> +	vol_sz_frac *= 100;
> +	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
> +
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +	spin_unlock(&sysfs_lock);
> +	return snprintf(buf, 30, "%4u.%02uGB\n", (int)vol_sz, (int)vol_sz_frac);

Strange to print it as an unsigned quantity, yet cast it to a signed one.

Are you sure that vol_sz cannot overflow a 32-bit integer?

The patch feeds magical 20's and 30's into snprintf in lots of places.  Can
these magic numbers be cleaned up?

> +static ssize_t cciss_show_vendor(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct drv_dynamic *d;
> +	drive_info_struct *drv;
> +	ctlr_info_t *h;
> +	unsigned long flags;
> +	int drv_index;
> +
> +	d = container_of(dev, struct drv_dynamic, dev);
> +	spin_lock(&sysfs_lock);
> +	if (!d->disk) {
> +		spin_unlock(&sysfs_lock);
> +		return -ENOENT;
> +	}
> +
> +	h = get_host(d->disk);
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return -EBUSY;
> +	}
> +
> +	drv = d->disk->private_data;
> +
> +	if (!drv->heads) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return -ENOTTY;
> +	}
> +
> +	drv_index = find_drv_index(h->ctlr, drv);
> +	if (drv_index != CISS_MAX_LUN) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return snprintf(buf, 20, "%s\n", (char *)drv->vendor);
> +	}
> +
> +	printk(KERN_ERR "cciss: logical drive not found\n");
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +	spin_unlock(&sysfs_lock);
> +	return -ENOTTY;
> +}

Multiple return points per function.

There are several reasons why we prefer the `goto out' approach to
unwinding:

- Probably generates less code

- Easier to verify that all resources adn locks got released.

- Much easier to modify in the future: if you later add an allocation of
  a lock-taking then there is only one site where it needs to be undone.

> +static ssize_t cciss_show_model(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct drv_dynamic *d;
> +	drive_info_struct *drv;
> +	ctlr_info_t *h;
> +	unsigned long flags;
> +	int drv_index;
> +
> +	d = container_of(dev, struct drv_dynamic, dev);
> +	spin_lock(&sysfs_lock);
> +	if (!d->disk) {
> +		spin_unlock(&sysfs_lock);
> +		return -ENOENT;
> +	}
> +
> +	h = get_host(d->disk);
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return -EBUSY;
> +	}
> +
> +	drv = d->disk->private_data;
> +
> +	if (!drv->heads) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return -ENOTTY;
> +	}
> +
> +	drv_index = find_drv_index(h->ctlr, drv);
> +	if (drv_index != CISS_MAX_LUN) {
> +		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +		spin_unlock(&sysfs_lock);
> +		return snprintf(buf, 20, "%s\n", (char *)drv->model);
> +	}
> +	printk(KERN_ERR "cciss: logical drive not found\n");
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +	spin_unlock(&sysfs_lock);
> +	return -ENOTTY;
> +}
>

Much duplication...

> +static void cciss_add_blk_sysfs_dev(drive_info_struct *drv,
> +				    struct gendisk* disk,
> +				    struct pci_dev *pdev, int disk_num)
> +{
> +	int r;
> +	struct drv_dynamic *d = kzalloc(sizeof(struct drv_dynamic), GFP_KERNEL);
> +	if (!d)
> +		return;

What are the consequences of this failure?

> +	disk->driverfs_dev = &d->dev;
> +	d->dev.parent = &pdev->dev;
> +	d->dev.release = (void (*)(struct device *))kfree;
> +	sprintf(d->dev.bus_id, "disk%d", disk_num);
> +	d->dev.driver_data = "cciss";
> +	if (device_register(&d->dev)) {
> +		put_device(&d->dev);
> +		return;
> +	}
> +	r = sysfs_create_group(&d->dev.kobj, &cciss_attrs);
> +	if (r)
> +		return;
> +	d->disk = disk;
> +	drv->dev_info = &d->dev;
> +}
> +
> +static void cciss_remove_blk_sysfs_dev(struct gendisk *disk)
> +{
> +	drive_info_struct *drv = get_drv(disk);
> +	struct drv_dynamic *d;
> +
> +	if (!drv->dev_info)
> +		return;
> +
> +	d = container_of(drv->dev_info, struct drv_dynamic, dev);
> +	spin_lock(&sysfs_lock);
> +	sysfs_remove_group(&d->dev.kobj, &cciss_attrs);
> +	d->disk = NULL;
> +	spin_unlock(&sysfs_lock);

Mike, what's going on?  I definitely told you last time I looked at this
patch that it is a bug to call sysfs_remove_group() under spinlock, because
sysfs_remove_group() takes sleeping locks.  Yet here it is again.

Maybe you lost my email.  It is here: http://lkml.org/lkml/2007/11/20/77


Also please see http://lkml.org/lkml/2007/11/20/79
