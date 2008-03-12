From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [pnfs] [PATCH 05/28] pnfsblock: expose scsi interface
Date: Wed, 12 Mar 2008 18:33:34 +0200
Message-ID: <47D805DE.9000100@panasas.com>
References: <1205263929-8346-1-git-send-email-iisaman@citi.umich.edu>	<1205263929-8346-2-git-send-email-iisaman@citi.umich.edu>	<1205263929-8346-3-git-send-email-iisaman@citi.umich.edu>	<1205263929-8346-4-git-send-email-iisaman@citi.umich.edu>	<1205263929-8346-5-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:45017 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYCLQeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 12:34:18 -0400
In-Reply-To: <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fred Isaman <iisaman@citi.umich.edu>, Andy Adamson <andros@umich.edu>
Cc: pnfs@linux-nfs.org, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Cc'ing scsi mailing list (and Christoph, please speak up now,
or forever hold your peace ;-)

On Mar. 11, 2008, 21:31 +0200, Fred Isaman <iisaman@citi.umich.edu> wrote:
> Signed-off-by: Fred Isaman <iisaman@citi.umich.edu>
> ---
>  drivers/scsi/hosts.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 24271a8..64f2847 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -48,10 +48,11 @@ static void scsi_host_cls_release(struct class_device *class_dev)
>  	put_device(&class_to_shost(class_dev)->shost_gendev);
>  }
>  
> -static struct class shost_class = {
> +struct class shost_class = {
>  	.name		= "scsi_host",
>  	.release	= scsi_host_cls_release,
>  };
> +EXPORT_SYMBOL(shost_class);
>  
>  /**
>   *	scsi_host_set_state - Take the given host through the host


This calls for a layering violation.

To fill-in more context, here's an excerpt from the next patch,
showing how you use shost_class to scan all scsi disks:

+/* Walk the list of scsi_devices. Add disks that can be opened and claimed
+ * to the device list
+ */
+static int
+nfs4_blk_add_scsi_disk(struct Scsi_Host *shost,
+		       int index, struct list_head *dlist)
+{
+	static char *claim_ptr = "I belong to pnfs block driver";
+	struct block_device *bdev;
+	struct gendisk *gd;
+	struct scsi_device *sdev;
+	unsigned int major, minor, ret = 0;
+	dev_t dev;
+
+	dprintk("%s enter \n", __func__);
+	if (index >= MAX_VOLS) {
+		dprintk("%s MAX_VOLS hit\n", __func__);
+		return -ENOSPC;
+	}
+	dprintk("%s 1 \n", __func__);
+	index--;
+	shost_for_each_device(sdev, shost) {
+		dprintk("%s 2\n", __func__);
+		/* Need to do this check before bumping index */
+		if (sdev->type != TYPE_DISK)
+			continue;
+		dprintk("%s 3 index %d \n", __func__, index);
+		if (++index >= MAX_VOLS) {
+			scsi_device_put(sdev);
+			break;
+		}
+		major = (!(index >> 4) ? SCSI_DISK0_MAJOR :
+			 SCSI_DISK1_MAJOR-1 + (index  >> 4));
+		minor =  ((index << 4) & 255);
+
+		dprintk("%s SCSI device %d:%d \n", __func__, major, minor);
+
+		dev = MKDEV(major, minor);
+		bdev = nfs4_blkdev_get(dev);
+		if (!bdev) {
+			dprintk("%s: failed to open device %d:%d\n",
+					__func__, major, minor);
+			continue;
+		}
+		gd = bdev->bd_disk;
+
+		dprintk("%s 4\n", __func__);
+
+		if (bd_claim(bdev, claim_ptr)) {
+			dprintk("%s: failed to claim device %d:%d\n",
+				__func__, gd->major, gd->first_minor);
+			blkdev_put(bdev);
+			continue;
+		}
+
+		ret = alloc_add_disk(bdev, dlist);
+		if (ret < 0)
+			goto out_err;
+		dprintk("%s ADDED DEVICE capacity %ld, bd_block_size %d\n",
+					__func__,
+					(unsigned long)gd->capacity,
+					bdev->bd_block_size);
+
+	}
+	index++;
+	dprintk("%s returns index %d \n", __func__, index);
+	return index;
+
+out_err:
+	dprintk("%s Can't add disk to list. ERROR: %d\n", __func__, ret);
+	nfs4_blkdev_put(bdev);
+	return ret;
+}
+
+/*
+ * Create a temporary list of all SCSI disks host can see, and that have not
+ * yet been claimed.
+ * shost_class: list of all registered scsi_hosts
+ * returns -errno on error, and #of devices found on success.
+ * XXX Loosely emulate scsi_host_lookup from scsi/host.c
+*/
+int nfs4_blk_create_scsi_disk_list(struct list_head *dlist)
+{
+	struct class *class = &shost_class;
+	struct class_device *cdev;
+	struct Scsi_Host *shost;
+	int ret = 0, index = 0;
+
+	dprintk("%s enter\n", __func__);
+
+	down(&class->sem);
+	list_for_each_entry(cdev, &class->children, node) {
+		dprintk("%s 1\n", __func__);
+		shost = class_to_shost(cdev);
+		ret = nfs4_blk_add_scsi_disk(shost, index, dlist);
+		dprintk("%s 2 ret %d\n", __func__, ret);
+		if (ret < 0)
+			goto out;
+		index = ret;
+	}
+out:
+	up(&class->sem);
+	return ret;
+}

My question is how should a proper API between the scsi layer and
the block layout driver look like?

Can you list your requirements, e.g.:
- scanning all available devices,

- discovering new devices on the fly

- getting notified for new devices?

Benny

