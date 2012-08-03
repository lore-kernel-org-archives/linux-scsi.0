From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v4 4/7] scsi: sr: block events when runtime suspended
Date: Fri, 3 Aug 2012 17:50:31 +0800
Message-ID: <501B9EE7.1080000@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com> <1343379650-2867-5-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343379650-2867-5-git-send-email-aaron.lu@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Sergei Shtylyov <sshtylyov@mvista.com>, Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Not sure if I should use EXPORT_SYMBOL or EXPORT_SYMBOL_GPL, any
comments?

Thanks,
Aaron

On 07/27/2012 05:00 PM, Aaron Lu wrote:
> When the ODD is runtime suspended, there is no need to poll it for
> events, so block events poll for it and unblock when resumed.
>
> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>   block/genhd.c     | 2 ++
>   drivers/scsi/sr.c | 7 ++++---
>   2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 9cf5583..bdb3682 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1458,6 +1458,7 @@ void disk_block_events(struct gendisk *disk)
>
>   	mutex_unlock(&ev->block_mutex);
>   }
> +EXPORT_SYMBOL(disk_block_events);
>
>   static void __disk_unblock_events(struct gendisk *disk, bool check_now)
>   {
> @@ -1502,6 +1503,7 @@ void disk_unblock_events(struct gendisk *disk)
>   	if (disk->ev)
>   		__disk_unblock_events(disk, false);
>   }
> +EXPORT_SYMBOL(disk_unblock_events);
>
>   /**
>    * disk_flush_events - schedule immediate event checking and flushing
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index acfd10a..cbc14ea 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -205,6 +205,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
>   		return -EBUSY;
>   	}
>
> +	disk_block_events(cd->disk);
> +
>   	return 0;
>   }
>
> @@ -226,6 +228,8 @@ static int sr_resume(struct device *dev)
>   		atomic_set(&cd->suspend_count, 1);
>   	}
>
> +	disk_unblock_events(cd->disk);
> +
>   	return 0;
>   }
>
> @@ -314,9 +318,6 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
>   	if (CDSL_CURRENT != slot)
>   		return 0;
>
> -	if (pm_runtime_suspended(&cd->device->sdev_gendev))
> -		return 0;
> -
>   	/* if the logical unit just finished loading/unloading, do a TUR */
>   	if (cd->device->can_power_off && cd->dbml && sr_unit_load_done(cd)) {
>   		events = 0;
>


