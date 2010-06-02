From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Wed, 02 Jun 2010 13:50:47 -0400
Message-ID: <4C0699F7.20004@garzik.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-7-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 05/15/2010 02:09 PM, Tejun Heo wrote:
> Implement sd_unlock_native_capacity() method which calls into
> hostt->unlock_native_capacity() if implemented.  This will be invoked
> by block layer if partitions extend beyond the end of the device and
> can be used to implement, for example, on-demand ATA host protected
> area unlocking.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Ben Hutchings<ben@decadent.org.uk>
> ---
>   drivers/scsi/sd.c        |   22 ++++++++++++++++++++++
>   include/scsi/scsi_host.h |    8 ++++++++
>   2 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8b827f3..b85906e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -97,6 +97,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
>   #endif
>
>   static int  sd_revalidate_disk(struct gendisk *);
> +static void sd_unlock_native_capacity(struct gendisk *disk);
>   static int  sd_probe(struct device *);
>   static int  sd_remove(struct device *);
>   static void sd_shutdown(struct device *);
> @@ -1100,6 +1101,7 @@ static const struct block_device_operations sd_fops = {
>   #endif
>   	.media_changed		= sd_media_changed,
>   	.revalidate_disk	= sd_revalidate_disk,
> +	.unlock_native_capacity	= sd_unlock_native_capacity,
>   };
>
>   static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
> @@ -2101,6 +2103,26 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   }
>
>   /**
> + *	sd_unlock_native_capacity - unlock native capacity
> + *	@disk: struct gendisk to set capacity for
> + *
> + *	Block layer calls this function if it detects that partitions
> + *	on @disk reach beyond the end of the device.  If the SCSI host
> + *	implements ->unlock_native_capacity() method, it's invoked to
> + *	give it a chance to adjust the device capacity.
> + *
> + *	CONTEXT:
> + *	Defined by block layer.  Might sleep.
> + */
> +static void sd_unlock_native_capacity(struct gendisk *disk)
> +{
> +	struct scsi_device *sdev = scsi_disk(disk)->device;
> +
> +	if (sdev->host->hostt->unlock_native_capacity)
> +		sdev->host->hostt->unlock_native_capacity(sdev);
> +}
> +
> +/**
>    *	sd_format_disk_name - format disk name
>    *	@prefix: name prefix - ie. "sd" for SCSI disks
>    *	@index: index of the disk to format name for
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index c50a97f..b7bdecb 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -327,6 +327,14 @@ struct scsi_host_template {
>   			sector_t, int []);
>
>   	/*
> +	 * This function is called when one or more partitions on the
> +	 * device reach beyond the end of the device.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	void (*unlock_native_capacity)(struct scsi_device *);
> +
> +	/*

applied 6-8, including this SCSI patch


