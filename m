From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Fri, 20 Sep 2002 11:51:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020920115151.A21018@eng2.beaverton.ibm.com>
References: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>; from andrew.r.cress@intel.com on Fri, Sep 20, 2002 at 10:17:03AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Mads Peter Bach' <mpb@hum.auc.dk>, Jens Arnfelt <jens.arnfelt@ab-innovation.dk>

On Fri, Sep 20, 2002 at 10:17:03AM -0700, Cress, Andrew R wrote:

Your mailer is munging the patch - adding extra new lines, you should
send it again as an attachment or use a different mailer.

I don't see any variable pbuf in 2.4.18, so this is probably not
against a pure 2.4.18 tree.

> +		for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
> +			shpnt->init_done = 1;
> +		}

Is init_done for optimization of the scan?

> +				if (SDpnt->attached && SDpnt->queue_depth >
> 2) {
> +				  ;  /* already attached, do nothing */

Some devices will have a queue_depth of 1, all devices on some
adapters will have a queue_depth of 1 (AFAIR).

> +				} else {
> +				  if (sdtpnt->attach) {
> +				     /* Note /dev/sd* maj=8, /dev/sg* maj=21
> */
> +				     EPRINTK("Attaching scsi%d:%d:%d:%d to
> maj %d\n",
> +					SDpnt->host->host_no,SDpnt->channel,
> +					SDpnt->id,
> SDpnt->lun,sdtpnt->major);
> +					(*sdtpnt->attach) (SDpnt);

The upper level prints an attach message - are you getting two messages
on a rescan finding a new device?

> +					fdidattach = 1;
> +				  }
> +				  if (SDpnt->attached) {
> +					scsi_build_commandblocks(SDpnt);
> +					if (0 == SDpnt->has_cmdblocks)
> +						out_of_space = 1;
> +				  }

You need to call scsi_build_commandblocks after setting the queue_depth.

> +			  	} /*end-else*/
> +			} /*end-for*/
> +		}
> +		if (fdidattach) {
> +		   new_dev++;
> +                   if (SHpnt->select_queue_depths != NULL) {
> +                             (SHpnt->select_queue_depths) (SHpnt,
> SHpnt->host_queue);
> +                             }

Calling select_queue_depths (even for the "hardcoded" scans) is somewhat
broken, depending on the adapter - some adapters will modify the queue
depth of all devices, but there is no adjustment made to the number
of command blocks allocated. This really needs something like Doug Ledford's
slave_attach().

>   * Function:    scsi_request_fn()
>   *
> @@ -922,6 +989,17 @@
>  				spin_lock_irq(&io_request_lock);
>  				continue;
>  			}
> +
> +			if (!in_interrupt()) {
> +			   /* Check if we need to rescan after a reset.
> ARC*/

Is this really OK to do if we aren't in interupt? What if this is
running as a tasklet (or ... what is it called?)?

This is going to penalize (possibly severely) some Scsi_Device-s IO, while
others on the same adapter keep running.

> +			   if (SDpnt->host->need_scan == 1) {
> +				SDpnt->host->need_scan = 2;
> +				spin_unlock_irq(&io_request_lock);
> +				scsi_rescan(SDpnt->host,SDpnt->channel);
> +				spin_lock_irq(&io_request_lock);
> +				SDpnt->host->need_scan = 0;
> +			   }
> +			}
>  		}
>  
>  		/*
> @@ -1174,14 +1252,27 @@
>  void scsi_report_bus_reset(struct Scsi_Host * SHpnt, int channel)
>  {
>  	Scsi_Device *SDloop;
> +
>  	for (SDloop = SHpnt->host_queue; SDloop; SDloop = SDloop->next) {
>  		if (channel == SDloop->channel) {
> +			/*
> +			 * Sometimes we get here repeatedly, so only
> +			 * increment the tally if this is the start
> +			 * of a reset.
> +			 */
> +			if (SDloop->was_reset == 0) SDloop->sdev_resets++;
>  			SDloop->was_reset = 1;
>  			SDloop->expecting_cc_ua = 1;
> -			SDloop->sdev_resets++;

Something should be done to prevent the error handler (if it ever does
anything useful) bus reset from generating a rescan.

> --- linux-2.4.18-orig/drivers/scsi/scsi_scan.c	Wed Aug 28 20:38:13 2002
> +++ linux-2.4.18/drivers/scsi/scsi_scan.c	Thu Aug 29 12:43:24 2002
> @@ -216,7 +216,7 @@
>  		if (data[i] >= 0x20 && i < data[4] + 5)
>  			pbuf[n++] = data[i];
>  		else
> -			pbuf[n++] = " ";
> +			pbuf[n++] = ' ';

Not 2.4.18 code.

>  
>  /*
> + * scsi_dev_skip
> + * Returns 1 if there was already a device on this host at the same
> + * channel/dev/lun, indicating that the caller should skip this one.
> + */
> +static int
> +scsi_dev_skip(struct Scsi_Host *shpnt, uint channel, uint dev, uint lun, 
> +	      Scsi_Device *sdnew) 
> +{
> +	Scsi_Device *sdpnt; 
> +	int fmatch = 0;
> +	int ret = 0;
> +	for (sdpnt = shpnt->host_queue; sdpnt; sdpnt = sdpnt->next)
> +	{
> +		fmatch = 0;
> +		if (sdpnt->host == shpnt && 
> +		    sdpnt->channel == channel &&
> +		    sdpnt->id == dev) {
> +			/* 
> +			 * Skip if it was already in the host_queue, as 
> +			 * long as this one isn't the sdnew temporary 
> +			 * device.
> +			 * sdpnt->attached is often already set here.
> +			 * We might check sdpnt->single_lun, but the
> +			 * scan loop will continue anyway.
> +			 */
> +			if ((sdpnt != sdnew) && (sdpnt->lun == lun)) {
> +			   fmatch = 1;
> +			   ret = 1;
> +			   /* already exists, skip it */
> +			   break;
> +			   }
> +		} 
> +	}  /*end for*/
> +	return(ret);
> +}  /*end scsi_dev_skip*/
> +

The above looks overly complex, how about:

static int
scsi_dev_skip(struct Scsi_Host *shpnt, uint channel, uint dev, uint lun, 
	      Scsi_Device *sdnew) 
{
	for (sdpnt = shpnt->host_queue; sdpnt; sdpnt = sdpnt->next)
		if ((sdpnt->id == dev) && (sdpnt->host == shpnt) && 
		    (sdpnt->channel == channel) && (sdpnt->lun == lun))
			return 1;
	return 0;
}

-- Patrick Mansfield
