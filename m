From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Wed, 15 Apr 2009 10:13:00 +0200
Message-ID: <20090415081259.GB11054@liondog.tnic>
References: <20090415084431H.fujita.tomonori@lab.ntt.co.jp> <49E561A0.7040607@kernel.org> <20090415072655.GA11054@liondog.tnic> <20090415164725S.fujita.tomonori@lab.ntt.co.jp>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52252 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZDOING (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 04:13:06 -0400
Content-Disposition: inline
In-Reply-To: <20090415164725S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 15, 2009 at 04:48:35PM +0900, FUJITA Tomonori wrote:

[..]

> I have some comments.
> 
> 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 35d0973..82c9339 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -206,32 +206,21 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
> >  	ide_cd_log_error(drive->name, failed_command, sense);
> >  }
> >  
> > -static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
> > -				      struct request *failed_command)
> > +static struct request *ide_cd_prep_sense(ide_drive_t *drive)
> >  {
> >  	struct cdrom_info *info	= drive->driver_data;
> > -	struct request *rq	= &drive->request_sense_rq;
> > -	struct bio *bio		= &drive->request_sense_bio;
> > -	struct bio_vec *bvec	= drive->request_sense_bvec;
> > -	unsigned int bvec_len	= ARRAY_SIZE(drive->request_sense_bvec);
> > -	unsigned sense_len	= 18;
> > -	int error;
> > +	void *sense		= &info->sense_data;
> > +	unsigned sense_len	= sizeof(struct request_sense);
> > +	struct request *rq;
> >  
> >  	ide_debug_log(IDE_DBG_SENSE, "enter");
> >  
> > -	if (sense == NULL) {
> > -		sense = &info->sense_data;
> > -		sense_len = sizeof(struct request_sense);
> > -	}
> > -
> >  	memset(sense, 0, sense_len);
> >  
> > -	/* stuff the sense request in front of our current request */
> > -	blk_rq_init(NULL, rq);
> > +	rq = blk_get_request(drive->queue, 0, __GFP_WAIT);
> >  
> > -	error = blk_rq_map_kern_prealloc(drive->queue, rq, bio, bvec, bvec_len,
> > -					 sense, sense_len, true);
> > -	BUG_ON(error);
> > +	if (blk_rq_map_kern(drive->queue, rq, sense, sense_len, __GFP_WAIT))
> > +		return NULL;
> >  
> >  	rq->rq_disk = info->disk;
> >  
> > @@ -241,18 +230,17 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
> >  	rq->cmd_type = REQ_TYPE_SENSE;
> >  	rq->cmd_flags |= REQ_PREEMPT;
> >  
> > -	/* NOTE! Save the failed command in "rq->special" */
> > -	rq->special = (void *)failed_command;
> > -
> > -	if (failed_command)
> > -		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
> > -					     failed_command->cmd[0]);
> > +	return rq;
> > +}
> >  
> > -	drive->hwif->rq = NULL;
> > +static void ide_cd_queue_rq_sense(ide_drive_t *drive)
> > +{
> > +	BUG_ON(!drive->rq_sense);
> >  
> > -	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
> > +	elv_add_request(drive->queue, drive->rq_sense, ELEVATOR_INSERT_FRONT, 0);
> >  }
> >  
> > +
> >  static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
> >  {
> >  	/*
> > @@ -440,7 +428,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
> >  
> >  	/* if we got a CHECK_CONDITION status, queue a request sense command */
> >  	if (stat & ATA_ERR)
> > -		cdrom_queue_request_sense(drive, NULL, NULL);
> > +		ide_cd_queue_rq_sense(drive);
> >  	return 1;
> >  
> >  end_request:
> > @@ -454,7 +442,7 @@ end_request:
> >  
> >  		hwif->rq = NULL;
> >  
> > -		cdrom_queue_request_sense(drive, rq->sense, rq);
> > +		ide_cd_queue_rq_sense(drive);
> >  		return 1;
> >  	} else
> >  		return 2;
> > @@ -788,6 +776,10 @@ out_end:
> >  
> >  		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
> >  
> > +		/* our sense buffer got used, reset it the next time around. */
> > +		if (sense)
> > +			drive->rq_sense = NULL;
> 
> Needs to call blk_put_request() here?

No, because this is done by ide_complete_rq() above. Otherwise I'd be
ending the sense request even it didn't get used. This way, I only use
it if I call ide_cd_queue_rq_sense() from which cdrom_decode_status().

> I guess that we also need to call blk_put_request() when ide_drive_s
> is freed.

That we need to do, thanks. Will update accordingly.

> > +
> >  		if (sense && rc == 2)
> >  			ide_error(drive, "request sense failure", stat);
> >  	}
> > @@ -901,6 +893,25 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
> >  		goto out_end;
> >  	}
> >  
> > +	/*
> > +	 * prepare request sense if it got used with the last rq
> > +	 */
> > +	if (!drive->rq_sense) {
> > +		drive->rq_sense = ide_cd_prep_sense(drive);
> > +		if (!drive->rq_sense) {
> > +			printk(KERN_ERR "%s: error prepping sense request!\n",
> > +					drive->name);
> > +			return ide_stopped;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * save the current request in case we'll be queueing a sense rq
> > +	 * afterwards due to its potential failure.
> > +	 */
> > +	if (!blk_sense_request(rq))
> > +		drive->rq_sense->special = (void *)rq;
> > +
> >  	memset(&cmd, 0, sizeof(cmd));
> >  
> >  	if (rq_data_dir(rq))
> > diff --git a/include/linux/ide.h b/include/linux/ide.h
> > index c942533..4c2d310 100644
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > @@ -605,6 +605,9 @@ struct ide_drive_s {
> >  	struct request request_sense_rq;
> >  	struct bio request_sense_bio;
> >  	struct bio_vec request_sense_bvec[2];
> 
> We can remove the above, right?

id-atapi uses them too, see
http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=commitdiff;h=9ac15840a6e5bf1fa6dce293484cb7aba4d078bb

They can go after I've converted ide-floppy and ide-tape to the same
sense handling as ide-cd. I'm on it...

-- 
Regards/Gruss,
    Boris.
