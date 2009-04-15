From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Wed, 15 Apr 2009 16:48:35 +0900
Message-ID: <20090415164725S.fujita.tomonori@lab.ntt.co.jp>
References: <20090415084431H.fujita.tomonori@lab.ntt.co.jp>
	<49E561A0.7040607@kernel.org>
	<20090415072655.GA11054@liondog.tnic>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38739 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZDOHtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Apr 2009 03:49:47 -0400
In-Reply-To: <20090415072655.GA11054@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com
Cc: tj@kernel.org, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 09:26:55 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> Hi guys,
> 
> On Wed, Apr 15, 2009 at 01:25:04PM +0900, Tejun Heo wrote:
> > >> Basically, I opted for preallocating a sense request in the ->do_request
> > >> routine and do that only on demand, i.e. I reinitialize it only if it
> > >> got used in the irq handler. So in case you want to shove a rq sense in
> > >> front of the queue, you simply use the already prepared one. Then in the
> > >> irq handler it is being finished the usual ways (blk_end_request). Next
> > >> time around you ->do_request, you reallocate it again since it got eaten
> > >> in the last round.
> > > 
> > > Sounds a workable solution.
> > 
> > Haven't actually looked at the code but sweeeeeet.
> > 
> > >> The good thing is that now I don't need all those static block layer
> > >> structs in the driver (bio, bio_vec, etc) and do the preferred dynamic
> > >> allocation instead.
> > > 
> > > That's surely good.
> > > 
> > > Well, if you could remove the usage of request structure that are not
> > > came from blk_get_request, it will be super. But it's a different
> > > topic and Tejun can go forward without such change.
> > > 
> > >> The patch is ontop of Tejun's series at
> > >> http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=ide-phase1
> > >> with some small modifications in commit 15783b1443f810ae72cb5ccb3a3a3ccc3aeb8729
> > >> wrt proper sense buffer length.
> > > 
> > > I think that Tejun will drop some of the patchset. At least, we don't
> > > need blk_rq_map_kern_prealloc stuff. I think that Tejun doesn't need
> > > to play with the mapping API. Well, we need to play with the mapping
> > > API for OSD but it's not directly related with the block layer
> > > cleanups necessary for the libata SCSI separation.
> > 
> > Yeah, the blk_rq_map_kern_prealloc() was basically shifting rq map
> > from ide to blk/bio so that at least codes are all in one place.  If
> > it's not necessary, super.  :-)
> > 
> > I'll drop stuff from this and the other patchset and repost them with
> > Borislav's patch in a few hours.  Thanks guys.
> 
> here's a version which gets rid of the static drive->request_sense_rq
> structure and does the usual blk_get_request(), as Fujita suggested.
> 
> @Tejun: we're gonna need the same thing for ide-atapi before you'll be
> able to get rid of the _prealloc() hack. I'll try to cook something up by
> tomorrow the latest.
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Tue, 14 Apr 2009 13:24:43 +0200
> Subject: [PATCH] ide-cd: preallocate rq sense out of the irq path
> 
> Preallocate a sense request in the ->do_request method and reinitialize
> it only on demand, in case it's been consumed in the IRQ handler path.
> The reason for this is that we don't want to be mapping rq to bio in
> the IRQ path and introduce all kinds of unnecessary hacks to the block
> layer.
> 
> CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |   67 +++++++++++++++++++++++++++++---------------------
>  include/linux/ide.h  |    3 ++
>  2 files changed, 42 insertions(+), 28 deletions(-)

Great, thanks!

I have some comments.


> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 35d0973..82c9339 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -206,32 +206,21 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
>  	ide_cd_log_error(drive->name, failed_command, sense);
>  }
>  
> -static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
> -				      struct request *failed_command)
> +static struct request *ide_cd_prep_sense(ide_drive_t *drive)
>  {
>  	struct cdrom_info *info	= drive->driver_data;
> -	struct request *rq	= &drive->request_sense_rq;
> -	struct bio *bio		= &drive->request_sense_bio;
> -	struct bio_vec *bvec	= drive->request_sense_bvec;
> -	unsigned int bvec_len	= ARRAY_SIZE(drive->request_sense_bvec);
> -	unsigned sense_len	= 18;
> -	int error;
> +	void *sense		= &info->sense_data;
> +	unsigned sense_len	= sizeof(struct request_sense);
> +	struct request *rq;
>  
>  	ide_debug_log(IDE_DBG_SENSE, "enter");
>  
> -	if (sense == NULL) {
> -		sense = &info->sense_data;
> -		sense_len = sizeof(struct request_sense);
> -	}
> -
>  	memset(sense, 0, sense_len);
>  
> -	/* stuff the sense request in front of our current request */
> -	blk_rq_init(NULL, rq);
> +	rq = blk_get_request(drive->queue, 0, __GFP_WAIT);
>  
> -	error = blk_rq_map_kern_prealloc(drive->queue, rq, bio, bvec, bvec_len,
> -					 sense, sense_len, true);
> -	BUG_ON(error);
> +	if (blk_rq_map_kern(drive->queue, rq, sense, sense_len, __GFP_WAIT))
> +		return NULL;
>  
>  	rq->rq_disk = info->disk;
>  
> @@ -241,18 +230,17 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
>  	rq->cmd_type = REQ_TYPE_SENSE;
>  	rq->cmd_flags |= REQ_PREEMPT;
>  
> -	/* NOTE! Save the failed command in "rq->special" */
> -	rq->special = (void *)failed_command;
> -
> -	if (failed_command)
> -		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
> -					     failed_command->cmd[0]);
> +	return rq;
> +}
>  
> -	drive->hwif->rq = NULL;
> +static void ide_cd_queue_rq_sense(ide_drive_t *drive)
> +{
> +	BUG_ON(!drive->rq_sense);
>  
> -	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
> +	elv_add_request(drive->queue, drive->rq_sense, ELEVATOR_INSERT_FRONT, 0);
>  }
>  
> +
>  static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
>  {
>  	/*
> @@ -440,7 +428,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
>  
>  	/* if we got a CHECK_CONDITION status, queue a request sense command */
>  	if (stat & ATA_ERR)
> -		cdrom_queue_request_sense(drive, NULL, NULL);
> +		ide_cd_queue_rq_sense(drive);
>  	return 1;
>  
>  end_request:
> @@ -454,7 +442,7 @@ end_request:
>  
>  		hwif->rq = NULL;
>  
> -		cdrom_queue_request_sense(drive, rq->sense, rq);
> +		ide_cd_queue_rq_sense(drive);
>  		return 1;
>  	} else
>  		return 2;
> @@ -788,6 +776,10 @@ out_end:
>  
>  		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
>  
> +		/* our sense buffer got used, reset it the next time around. */
> +		if (sense)
> +			drive->rq_sense = NULL;

Needs to call blk_put_request() here?

I guess that we also need to call blk_put_request() when ide_drive_s
is freed.

> +
>  		if (sense && rc == 2)
>  			ide_error(drive, "request sense failure", stat);
>  	}
> @@ -901,6 +893,25 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
>  		goto out_end;
>  	}
>  
> +	/*
> +	 * prepare request sense if it got used with the last rq
> +	 */
> +	if (!drive->rq_sense) {
> +		drive->rq_sense = ide_cd_prep_sense(drive);
> +		if (!drive->rq_sense) {
> +			printk(KERN_ERR "%s: error prepping sense request!\n",
> +					drive->name);
> +			return ide_stopped;
> +		}
> +	}
> +
> +	/*
> +	 * save the current request in case we'll be queueing a sense rq
> +	 * afterwards due to its potential failure.
> +	 */
> +	if (!blk_sense_request(rq))
> +		drive->rq_sense->special = (void *)rq;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  
>  	if (rq_data_dir(rq))
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index c942533..4c2d310 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -605,6 +605,9 @@ struct ide_drive_s {
>  	struct request request_sense_rq;
>  	struct bio request_sense_bio;
>  	struct bio_vec request_sense_bvec[2];

We can remove the above, right?

> +
> +	/* current sense rq */
> +	struct request *rq_sense;
>  };
>  
>  typedef struct ide_drive_s ide_drive_t;
> -- 
> 1.6.2.2
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
