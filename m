From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] st implement tape statistics v3 (updated patch)
Date: Mon, 9 Feb 2015 23:12:11 +0800
Message-ID: <20150209151211.GA3120@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3F48B@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbbBIPMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 10:12:16 -0500
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3F48B@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>

On Mon, Feb 09, 2015 at 11:56:25AM +0000, Seymour, Shane M wrote:
> Hi Greg,
> 
> Thank you for pushing me to go that little further. The statistics directory is back. Any feedback from anyone would be appreciated.
> 
> Thanks
> Shane
> --
> 
> Signed-off-by: shane.seymour@hp.com
> Tested-by: shane.seymour@hp.com

Please provide a "real" changelog so that people can figure out what is
going on here.

And you need '<' and '>' for your signed-off-by lines.


> ---
> --- a/drivers/scsi/st.c	2015-01-11 14:46:00.243814755 -0600
> +++ b/drivers/scsi/st.c	2015-02-09 00:05:46.838967740 -0600
> @@ -476,10 +476,25 @@ static void st_scsi_execute_end(struct r
>  	struct st_request *SRpnt = req->end_io_data;
>  	struct scsi_tape *STp = SRpnt->stp;
>  	struct bio *tmp;
> +	u64 ticks;
>  
>  	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
>  	STp->buffer->cmdstat.residual = req->resid_len;
>  
> +/* Note that irrespective of the I/O succeeding or not we count it. We
> +   don't have bufflen any more so a read at end of file will over count
> +   the blocks by one. */
> +	if (STp->stats != NULL) {
> +		ticks = get_jiffies_64();
> +		STp->stats->in_flight--;
> +		ticks -= STp->stats->stamp;
> +		STp->stats->io_ticks += ticks;
> +		if (req->cmd[0] == WRITE_6)
> +			STp->stats->write_ticks += ticks;
> +		else if (req->cmd[0] == READ_6)
> +			STp->stats->read_ticks += ticks;
> +	}
> +
>  	tmp = SRpnt->bio;
>  	if (SRpnt->waiting)
>  		complete(SRpnt->waiting);
> @@ -496,6 +511,7 @@ static int st_scsi_execute(struct st_req
>  	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
>  	int err = 0;
>  	int write = (data_direction == DMA_TO_DEVICE);
> +	struct scsi_tape *STp = SRpnt->stp;
>  
>  	req = blk_get_request(SRpnt->stp->device->request_queue, write,
>  			      GFP_KERNEL);
> @@ -516,6 +532,20 @@ static int st_scsi_execute(struct st_req
>  		}
>  	}
>  
> +	if (STp->stats != NULL) {
> +		if (cmd[0] == WRITE_6) {
> +			STp->stats->write_cnt++;
> +			STp->stats->write_byte_cnt += bufflen;
> +		} else if (cmd[0] == READ_6) {
> +			STp->stats->read_cnt++;
> +			STp->stats->read_byte_cnt += bufflen;
> +		} else {
> +			STp->stats->other_cnt++;
> +		}
> +		STp->stats->stamp = get_jiffies_64();
> +		STp->stats->in_flight++;
> +	}
> +
>  	SRpnt->bio = req->bio;
>  	req->cmd_len = COMMAND_SIZE(cmd[0]);
>  	memset(req->cmd, 0, BLK_MAX_CDB);
> @@ -4064,6 +4094,7 @@ out:
>  static int create_cdevs(struct scsi_tape *tape)
>  {
>  	int mode, error;
> +

Not related to this patch.

>  	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
>  		error = create_one_cdev(tape, mode, 0);
>  		if (error)
> @@ -4222,6 +4253,8 @@ static int st_probe(struct device *dev)
>  	}
>  	tpnt->index = error;
>  	sprintf(disk->disk_name, "st%d", tpnt->index);
> +/* Allocate stats structure */

Odd indentation.

> +	tpnt->stats = kzalloc(sizeof(struct scsi_tape_stats), GFP_ATOMIC);

No checking to see if it succeeded?  Why not?

And why ATOMIC?  You are not in interrupt contect in your probe
function.

>  
>  	dev_set_drvdata(dev, tpnt);
>  
> @@ -4248,6 +4281,8 @@ out_put_queue:
>  	blk_put_queue(disk->queue);
>  out_put_disk:
>  	put_disk(disk);
> +	if (tpnt->stats != NULL)
> +		kfree(tpnt->stats);

The if check is not needed.

>  	kfree(tpnt);
>  out_buffer_free:
>  	kfree(buffer);
> @@ -4298,6 +4333,10 @@ static void scsi_tape_release(struct kre
>  
>  	disk->private_data = NULL;
>  	put_disk(disk);
> +	if (tpnt->stats != NULL) {
> +		kfree(tpnt->stats);
> +		tpnt->stats = NULL;
> +	}
>  	kfree(tpnt);
>  	return;
>  }
> @@ -4513,6 +4552,223 @@ options_show(struct device *dev, struct
>  }
>  static DEVICE_ATTR_RO(options);
>  
> +/* Support for tape stats */
> +
> +/**
> + * read_cnt_how - return read count - count of reads made from tape drive
> + * @dev: struct device
> + * @attr: attribute structure
> + * @buf: buffer to return formatted data in
> + */
> +static ssize_t read_cnt_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct st_modedef *STm = dev_get_drvdata(dev);
> +	struct scsi_tape *STp = STm->tape;
> +	struct scsi_tape_stats *STt;
> +
> +	if ((STp == 0) || (STp->stats == 0))
> +		return -EINVAL;

How can STp or STP->stats ever be NULL?  (hint, check against NULL for
typesafe)

> +	STt = STp->stats;
> +	if (STt == 0)
> +		return -EINVAL;

You already made this check above?  Please fix all of this up in all of
these callbacks, the checking should not be needed.

> +	return snprintf(buf, PAGE_SIZE, "%llu", STt->read_cnt);
> +}
> +static DEVICE_ATTR_RO(read_cnt);
> +
> +/**
> + * read_byte_cnt_show - return read byte count - tape drives
> + * may use blocks less than 512 bytes this gives the raw byte count of
> + * of data read from the tape drive.
> + * @dev: struct device
> + * @attr: attribute structure
> + * @buf: buffer to return formatted data in
> + */
> +static ssize_t read_byte_cnt_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct st_modedef *STm = dev_get_drvdata(dev);
> +	struct scsi_tape *STp = STm->tape;
> +	struct scsi_tape_stats *STt;
> +
> +	if ((STp == 0) || (STp->stats == 0))
> +		return -EINVAL;
> +	STt = STp->stats;
> +	if (STt == 0)
> +		return -EINVAL;
> +	return snprintf(buf, PAGE_SIZE, "%llu", STt->read_byte_cnt);
> +}
> +DEVICE_ATTR_RO(read_byte_cnt);

Why are all of your attribute structures global?

thanks,

greg k-h
