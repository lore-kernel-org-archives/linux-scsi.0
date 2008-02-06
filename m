From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] scsi_dh: scsi handling of REQ_LB_OP_TRANSITION
Date: Wed, 6 Feb 2008 11:00:39 -0800
Message-ID: <20080206190039.GD32522@linux.vnet.ibm.com>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain> <20080124003059.18871.89111.sendpatchset@localhost.localdomain> <47A37A65.8020500@cs.wisc.edu> <1202151767.3096.86.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33503 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbYBFTBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Feb 2008 14:01:41 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m16J3U6c027399
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2008 14:03:30 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m16J1Qif876680
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2008 14:01:27 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m16J1J7F001409
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2008 12:01:20 -0700
Content-Disposition: inline
In-Reply-To: <1202151767.3096.86.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Chandra Seetharaman <sekharan@us.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> On Fri, 2008-02-01 at 14:00 -0600, Mike Christie wrote:
> > Chandra Seetharaman wrote:
> > > @@ -1445,9 +1479,24 @@ static void scsi_kill_request(struct req
> > >  static void scsi_softirq_done(struct request *rq)
> > >  {
> > >  	struct scsi_cmnd *cmd = rq->completion_data;
> > > -	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
> > >  	int disposition;
> > > +	struct request_queue *q;
> > > +	unsigned long wait_for, flags;
> > >  
> > > +	if (blk_linux_request(rq)) {
> > > +		q = rq->q;
> > > +		spin_lock_irqsave(q->queue_lock, flags);
> > > +		/*
> > > +		 * we always return 1 and the caller should
> > > +		 * check rq->errors for the complete status
> > > +		 */
> > > +		end_that_request_last(rq, 1);
> > > +		spin_unlock_irqrestore(q->queue_lock, flags);
> > > +		return;
> > > +	}
> > > +
> > > +
> > > +	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
> > >  	INIT_LIST_HEAD(&cmd->eh_entry);
> > >  
> > .....
> > 
> > > +
> > >  /*
> > >   * Function:    scsi_request_fn()
> > >   *
> > > @@ -1519,7 +1612,23 @@ static void scsi_request_fn(struct reque
> > >  		 * accept it.
> > >  		 */
> > >  		req = elv_next_request(q);
> > > -		if (!req || !scsi_dev_queue_ready(q, sdev))
> > > +		if (!req)
> > > +			break;
> > > +
> > > +		/*
> > > +		 * We do not account for linux blk req in the device
> > > +		 * or host busy accounting because it is not necessarily
> > > +		 * a scsi command that is sent to some object. The lower
> > > +		 * level can translate it into a request/scsi_cmnd, if
> > > +		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
> > > +		 */
> > > +		if (blk_linux_request(req)) {
> > > +			blkdev_dequeue_request(req);
> > > +			scsi_execute_blk_linux_cmd(req);
> > > +			continue;
> > > +		}
> > > +
> > > +		if (!scsi_dev_queue_ready(q, sdev))
> > >  			break;
> > 
> > I think these two pieces are one of the reasons I have not pushed the 
> > patches. I thought the completion and execution pieces here are a little 
> > ugly and seem to just wedge themselves in where they want to be.
> > 
> > Is there any way to make the insertion of non-scsi commands more common? 
> > Do we have the code for being able to send requests directly to 
> > something like a fc rport done? Could we maybe inject these special 
> > commands to the hw handler using something similar to how bsg would send 
> > non scsi commands to weird objects (objects like rport, sessions, and 
> > not devices we traditionally associated with queues like scsi_devices). 
> > Just a thought with no code :) that is why the ugly code existed still :)
> 
> We sort of do.  The bsg code in scsi_transport_sas to send SMP frames to
> expander devices would be an example of non-scsi commands going via a
> mechanism other than being encapsulated in SCSI.  I don't know if that's
> the complete solution in this case, but you could investigate it.

I looked at the bsg code in scsi_transport_sas and all I see it doing is
calling blk_init_queue to set the request_fn. The request_fn
(*smp_request) just processes one cmd_type. Is there code is another tree
that has more processing?

A idea to allow for more control / flexibility cmd_type handlers could be
added inside request_fn, prep_rq_fn, softirq_done_fn.

I thought about this being at a higher level in the block layer, but it
would be hard to handle the request_fn cleanly at the high level. The
localized change would reduce impact on users who do not want or need per
cmd_type handlers.

A SCSI example might be something like:

static void scsi_softirq_done(struct request *rq)
{
	...
	sdev->cmd_type_handler[rq->cmd_type]->softirq_done(rq)
	...
}

int scsi_prep_fn(struct request_queue *q, struct request *req)
{
	...
	sdev->cmd_type_handler[rq->cmd_type]->prep_fn(req)
	...
}

static void scsi_request_fn(struct request_queue *q)
{
	...
	sdev->cmd_type_handler[rq->cmd_type]->request_fn(req)
	...
}

This is just moving the code inside the cmd_type "if" checks, but it may
reduce the number of cmd_type "if" checks in some paths (if we make
multiple decisions based on cmd_type). On init of the sdev default
handlers would be installed.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
