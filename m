From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Fri, 20 Sep 2002 14:12:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D1EE@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxvs042.fm.intel.com (fmsmsxvs042.fm.intel.com [132.233.42.128])
	by momus.sc.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.45 2002/09/20 18:22:33 dmccart Exp $) with SMTP id g8KLBc222924
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2002 21:11:48 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, 'Mike Anderson' <andmike@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Patrick & Mike, 

Thanks for the prompt feedback.  

The pbuf and EPRINTK stuff is from the POSIX event log patch that I also
applied, sorry for the mixed code.

The init_done is a flag to use later in scan_scsis, so we know whether to
expect any existing devices or not, and call the scsi_dev_skip routine.  It
needs to be after the loop above it to make sure that the first scan_scsis
is really done.  It should have a comment there stating its purpose.  

Yes, I do get two attach messages.  I need to delete that printk.  It was
useful for debug, but no longer serves a purpose.

RE: queue_depth & commandblocks
Hmmm, needs more work/thought.  Where can I find Doug's slave_attach?

RE: where it is called from
>From my testing, this location does work, and the need_scan flag prevents
recursion, but I'd like to find a better context from which to call it.  

RE: impact of rescan to other scsi IOs
This gets back to where it is called from.  Maybe it needs to spawn its own
thread? (ugh) 

RE: streamlining scsi_dev_skip code
Thanks, that code used to look even worse during my debug, so it needed a
fresh look.  I need to add the != sdnew condition to the end, but that looks
better.  

RE: preventing error handler from doing rescan too
This is done via the need_scan flag.

Andy Cress

-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com] 
Sent: Friday, September 20, 2002 2:52 PM
Subject: Re: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)

[...]
Is init_done for optimization of the scan?

> +				if (SDpnt->attached && SDpnt->queue_depth  >
2) {
> +				  ;  /* already attached, do nothing */

Some devices will have a queue_depth of 1, all devices on some
adapters will have a queue_depth of 1 (AFAIR).

[...]
> +				  if (SDpnt->attached) {
> +					scsi_build_commandblocks(SDpnt);
> +					if (0 == SDpnt->has_cmdblocks)
> +						out_of_space = 1;
> +				  }

You need to call scsi_build_commandblocks after setting the queue_depth.

[...]

Calling select_queue_depths (even for the "hardcoded" scans) is somewhat
broken, depending on the adapter - some adapters will modify the queue
depth of all devices, but there is no adjustment made to the number
of command blocks allocated. This really needs something like Doug Ledford's
slave_attach().

> +
> +			if (!in_interrupt()) {
> +			   /* Check if we need to rescan after a reset.
ARC*/
> +			   if (SDpnt->host->need_scan == 1) {
> +				SDpnt->host->need_scan = 2;
> +				spin_unlock_irq(&io_request_lock);
> +				scsi_rescan(SDpnt->host,SDpnt->channel);
> +				spin_lock_irq(&io_request_lock);
> +				SDpnt->host->need_scan = 0;
> +			   }

Is this really OK to do if we aren't in interupt? What if this is
running as a tasklet (or ... what is it called?)?

This is going to penalize (possibly severely) some Scsi_Device-s IO, while
others on the same adapter keep running.

[...]

Something should be done to prevent the error handler (if it ever does
anything useful) bus reset from generating a rescan.


[...]
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
