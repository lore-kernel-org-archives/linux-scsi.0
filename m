From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/9] scsi_dh: scsi handling of REQ_LB_OP_TRANSITION
Date: Wed, 06 Feb 2008 14:52:26 -0600
Message-ID: <1202331146.3112.124.camel@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003059.18871.89111.sendpatchset@localhost.localdomain>
	 <47A37A65.8020500@cs.wisc.edu>
	 <1202151767.3096.86.camel@localhost.localdomain>
	 <20080206190039.GD32522@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46250 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124AbYBFUwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 15:52:35 -0500
In-Reply-To: <20080206190039.GD32522@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Chandra Seetharaman <sekharan@us.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 2008-02-06 at 11:00 -0800, Mike Anderson wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > On Fri, 2008-02-01 at 14:00 -0600, Mike Christie wrote:
> > > Chandra Seetharaman wrote:
> > > > @@ -1445,9 +1479,24 @@ static void scsi_kill_request(struct req
> > > >  static void scsi_softirq_done(struct request *rq)
> > > >  {
> > > >  	struct scsi_cmnd *cmd = rq->completion_data;
> > > > -	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
> > > >  	int disposition;
> > > > +	struct request_queue *q;
> > > > +	unsigned long wait_for, flags;
> > > >  
> > > > +	if (blk_linux_request(rq)) {
> > > > +		q = rq->q;
> > > > +		spin_lock_irqsave(q->queue_lock, flags);
> > > > +		/*
> > > > +		 * we always return 1 and the caller should
> > > > +		 * check rq->errors for the complete status
> > > > +		 */
> > > > +		end_that_request_last(rq, 1);
> > > > +		spin_unlock_irqrestore(q->queue_lock, flags);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +
> > > > +	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
> > > >  	INIT_LIST_HEAD(&cmd->eh_entry);
> > > >  
> > > .....
> > > 
> > > > +
> > > >  /*
> > > >   * Function:    scsi_request_fn()
> > > >   *
> > > > @@ -1519,7 +1612,23 @@ static void scsi_request_fn(struct reque
> > > >  		 * accept it.
> > > >  		 */
> > > >  		req = elv_next_request(q);
> > > > -		if (!req || !scsi_dev_queue_ready(q, sdev))
> > > > +		if (!req)
> > > > +			break;
> > > > +
> > > > +		/*
> > > > +		 * We do not account for linux blk req in the device
> > > > +		 * or host busy accounting because it is not necessarily
> > > > +		 * a scsi command that is sent to some object. The lower
> > > > +		 * level can translate it into a request/scsi_cmnd, if
> > > > +		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
> > > > +		 */
> > > > +		if (blk_linux_request(req)) {
> > > > +			blkdev_dequeue_request(req);
> > > > +			scsi_execute_blk_linux_cmd(req);
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		if (!scsi_dev_queue_ready(q, sdev))
> > > >  			break;
> > > 
> > > I think these two pieces are one of the reasons I have not pushed the 
> > > patches. I thought the completion and execution pieces here are a little 
> > > ugly and seem to just wedge themselves in where they want to be.
> > > 
> > > Is there any way to make the insertion of non-scsi commands more common? 
> > > Do we have the code for being able to send requests directly to 
> > > something like a fc rport done? Could we maybe inject these special 
> > > commands to the hw handler using something similar to how bsg would send 
> > > non scsi commands to weird objects (objects like rport, sessions, and 
> > > not devices we traditionally associated with queues like scsi_devices). 
> > > Just a thought with no code :) that is why the ugly code existed still :)
> > 
> > We sort of do.  The bsg code in scsi_transport_sas to send SMP frames to
> > expander devices would be an example of non-scsi commands going via a
> > mechanism other than being encapsulated in SCSI.  I don't know if that's
> > the complete solution in this case, but you could investigate it.
> 
> I looked at the bsg code in scsi_transport_sas and all I see it doing is
> calling blk_init_queue to set the request_fn. The request_fn
> (*smp_request) just processes one cmd_type. Is there code is another tree
> that has more processing?

No ... that's it.  It's designed to expose a frame driven SMP
communication channel to expanders via a block tap.

Part of the problem seems to be that your current code is very much
trying to do this in-band.  A block tap like the SMP handlers are
effectively out of band

> A idea to allow for more control / flexibility cmd_type handlers could be
> added inside request_fn, prep_rq_fn, softirq_done_fn.
> 
> I thought about this being at a higher level in the block layer, but it
> would be hard to handle the request_fn cleanly at the high level. The
> localized change would reduce impact on users who do not want or need per
> cmd_type handlers.

But this type of thinking does lead to a lot of apparent nastiness
inside your actual handlers.  Trying to do all of this in-band has you
doing a lot of callback driven async I/O stuff using
blk_execute_rq_nowait().  It might be a lot cleaner to do it out of band
on a thread using the standard waiting interfaces.

James


