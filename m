From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
Date: Wed, 28 Mar 2007 20:15:53 -0400
Message-ID: <460B0539.9040103@pobox.com>
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49103 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbXC2AP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2007 20:15:56 -0400
In-Reply-To: <20070328164450.b89d5156.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Kristen Carlson Accardi wrote:
> Allow user space to determine if an ATAPI device supports
> async notification (AN) of media changes.  This is done by
> adding a new sysfs file "async_notification" to genhd.
> If the file reads 1, then the device supports async 
> notification.  If the file reads 0, it does not.  
> 
> A flag is set in the generic disk to indicate whether
> or not AN is supported.  This flag is set by the SCSI
> subsystem when it registers with add_disk.  The SCSI
> system gets information from libata on whether the
> device supports AN during dev_configure. 
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-mm/block/genhd.c
> ===================================================================
> --- 2.6-mm.orig/block/genhd.c
> +++ 2.6-mm/block/genhd.c
> @@ -372,6 +372,11 @@ static ssize_t disk_size_read(struct gen
>  {
>  	return sprintf(page, "%llu\n", (unsigned long long)get_capacity(disk));
>  }
> +static ssize_t disk_AN_read(struct gendisk * disk, char *page)
> +{
> +	return sprintf(page, "%d\n",
> +		(disk->flags & GENHD_FL_ASYNC_NOTIFICATION ? 1 : 0));
> +}
>  
>  static ssize_t disk_stats_read(struct gendisk * disk, char *page)
>  {
> @@ -419,6 +424,10 @@ static struct disk_attribute disk_attr_s
>  	.attr = {.name = "stat", .mode = S_IRUGO },
>  	.show	= disk_stats_read
>  };
> +static struct disk_attribute disk_attr_AN = {
> +	.attr = {.name = "media_change_events", .mode = S_IRUGO },
> +	.show	= disk_AN_read
> +};
>  
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  
> @@ -455,6 +464,7 @@ static struct attribute * default_attrs[
>  	&disk_attr_removable.attr,
>  	&disk_attr_size.attr,
>  	&disk_attr_stat.attr,
> +	&disk_attr_AN.attr,
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	&disk_attr_fail.attr,
>  #endif
> Index: 2.6-mm/include/linux/genhd.h
> ===================================================================
> --- 2.6-mm.orig/include/linux/genhd.h
> +++ 2.6-mm/include/linux/genhd.h
> @@ -94,6 +94,7 @@ struct hd_struct {
>  
>  #define GENHD_FL_REMOVABLE			1
>  #define GENHD_FL_DRIVERFS			2
> +#define GENHD_FL_ASYNC_NOTIFICATION		4
>  #define GENHD_FL_CD				8
>  #define GENHD_FL_UP				16
>  #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
> Index: 2.6-mm/include/scsi/scsi_device.h
> ===================================================================
> --- 2.6-mm.orig/include/scsi/scsi_device.h
> +++ 2.6-mm/include/scsi/scsi_device.h
> @@ -126,7 +126,7 @@ struct scsi_device {
>  	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
>  	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
>  	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
> -
> +	unsigned async_notification:1;	/* device supports async notification */
>  	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
>  
>  	unsigned int max_device_blocked; /* what device_blocked counts down from  */
> Index: 2.6-mm/drivers/ata/libata-scsi.c
> ===================================================================
> --- 2.6-mm.orig/drivers/ata/libata-scsi.c
> +++ 2.6-mm/drivers/ata/libata-scsi.c
> @@ -899,6 +899,9 @@ static void ata_scsi_dev_config(struct s
>  		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
>  	}
>  
> +	if (dev->flags & ATA_DFLAG_AN)
> +		sdev->async_notification = 1;
> +
>  	if (dev->flags & ATA_DFLAG_NCQ) {
>  		int depth;
>  
> Index: 2.6-mm/drivers/scsi/sr.c
> ===================================================================
> --- 2.6-mm.orig/drivers/scsi/sr.c
> +++ 2.6-mm/drivers/scsi/sr.c
> @@ -603,6 +603,8 @@ static int sr_probe(struct device *dev)
>  
>  	dev_set_drvdata(dev, cd);
>  	disk->flags |= GENHD_FL_REMOVABLE;
> +	if (sdev->async_notification)
> +		disk->flags |= GENHD_FL_ASYNC_NOTIFICATION;
>  	add_disk(disk);

(added linux-scsi to CC)

Comments:

1) From a procedural standpoint, you'll want to separate this patch into 
three patches:  generic block layer stuff, SCSI stuff, and libata stuff.

2) I don't claim to be a sysfs expert, but this seems like a reasonable 
approach for reporting async-notification capabilities

3) I would make the contents of 'media_change_events' be a list of 
flags, rather than a boolean.  Thus, when AN is present, 
media_change_events would return "AN\n".  It would return "\n" (no 
flags) when AN is absent.  This permits future expansion of this 
capabilities reporting variable.

4) Figure out some place to document 'media_change_events', in 
Documentation/*

5) I think the method of delivery probably needs discussing, and some 
work.  Presumably the normal hotplug paths should be traversed for this 
sort of thing.

