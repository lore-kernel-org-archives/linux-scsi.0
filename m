From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 1/6] block: genhd: add an interface to set disk poll interval
Date: Thu, 20 Sep 2012 22:35:13 +0200
Message-ID: <201209202235.13258.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <1347438597-5903-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347438597-5903-2-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Please add a changelog explaining who's going to use the new interface, in
addition to the original user of that code, and why it is exported.

Thanks,
Rafael


On Wednesday, September 12, 2012, Aaron Lu wrote:
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  block/genhd.c         | 23 +++++++++++++++++------
>  include/linux/genhd.h |  1 +
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index cac7366..4244256 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1627,6 +1627,19 @@ static void disk_events_workfn(struct work_struct *work)
>  		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> +int disk_events_set_poll_msecs(struct gendisk *disk, long intv)
> +{
> +	if (intv < 0 && intv != -1)
> +		return -EINVAL;
> +
> +	disk_block_events(disk);
> +	disk->ev->poll_msecs = intv;
> +	__disk_unblock_events(disk, true);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(disk_events_set_poll_msecs);
> +
>  /*
>   * A disk events enabled device has the following sysfs nodes under
>   * its /sys/block/X/ directory.
> @@ -1683,16 +1696,14 @@ static ssize_t disk_events_poll_msecs_store(struct device *dev,
>  {
>  	struct gendisk *disk = dev_to_disk(dev);
>  	long intv;
> +	int ret;
>  
>  	if (!count || !sscanf(buf, "%ld", &intv))
>  		return -EINVAL;
>  
> -	if (intv < 0 && intv != -1)
> -		return -EINVAL;
> -
> -	disk_block_events(disk);
> -	disk->ev->poll_msecs = intv;
> -	__disk_unblock_events(disk, true);
> +	ret = disk_events_set_poll_msecs(disk, intv);
> +	if (ret)
> +		return ret;
>  
>  	return count;
>  }
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 4f440b3..63409e5 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -423,6 +423,7 @@ extern void disk_block_events(struct gendisk *disk);
>  extern void disk_unblock_events(struct gendisk *disk);
>  extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
>  extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
> +extern int disk_events_set_poll_msecs(struct gendisk *disk, long intv);
>  
>  /* drivers/char/random.c */
>  extern void add_disk_randomness(struct gendisk *disk);
> 

