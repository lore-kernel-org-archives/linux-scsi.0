From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Sun, 16 May 2010 08:39:35 -0500
Message-ID: <1274017175.14187.9.camel@mulgrave.site>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	 <1273946974-29131-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-7-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 2010-05-15 at 20:09 +0200, Tejun Heo wrote:
> Implement sd_unlock_native_capacity() method which calls into
> hostt->unlock_native_capacity() if implemented.  This will be invoked
> by block layer if partitions extend beyond the end of the device and
> can be used to implement, for example, on-demand ATA host protected
> area unlocking.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/scsi/sd.c        |   22 ++++++++++++++++++++++
>  include/scsi/scsi_host.h |    8 ++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8b827f3..b85906e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -97,6 +97,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
>  #endif
>  
>  static int  sd_revalidate_disk(struct gendisk *);
> +static void sd_unlock_native_capacity(struct gendisk *disk);
>  static int  sd_probe(struct device *);
>  static int  sd_remove(struct device *);
>  static void sd_shutdown(struct device *);
> @@ -1100,6 +1101,7 @@ static const struct block_device_operations sd_fops = {
>  #endif
>  	.media_changed		= sd_media_changed,
>  	.revalidate_disk	= sd_revalidate_disk,
> +	.unlock_native_capacity	= sd_unlock_native_capacity,
>  };
>  
>  static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
> @@ -2101,6 +2103,26 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  }
>  
>  /**
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
>   *	sd_format_disk_name - format disk name
>   *	@prefix: name prefix - ie. "sd" for SCSI disks
>   *	@index: index of the disk to format name for
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index c50a97f..b7bdecb 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -327,6 +327,14 @@ struct scsi_host_template {
>  			sector_t, int []);
>  
>  	/*
> +	 * This function is called when one or more partitions on the
> +	 * device reach beyond the end of the device.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	void (*unlock_native_capacity)(struct scsi_device *);
> +
> +	/*

I still principally dislike this threading of the operation up and down
the stack.  Although we've done it before, we're trying to get away from
the paradigm of driver conditions to scsi and scsi conditions to block
for all stuff where driver could condition straight to block (alignment
is a classic example of the new way of doing things).

The reason you need the threading is because the block ops gets hidden
at the top of the stack in the upper layers (this was a design choice to
try to prevent the lower layers mucking with it).  The way we get around
this is to use a queue operation instead.  As far as I can tell, there's
no logical reason for the unlock to be a block op, so lets make it a
queue op instead.  The consumer in 

static bool disk_unlock_native_capacity(struct gendisk *disk)

then becomes

	blk_unlock_native_capacity(disk->queue)

Block's implementation of this would probably call directly through the
queue.

You place the usual function in the queue template so the ata slave
configure can say

	blk_queue_unlock_native_function(rq, <unlock_function>)

Then there's no need for anything at all in SCSI ... and it becomes a
whole lot more obvious how to do legacy ide (if we ever get problems
there).

James


