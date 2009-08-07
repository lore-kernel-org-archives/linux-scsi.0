From: Roland Dreier <rdreier@cisco.com>
Subject: Re: sg_reset can trigger a NULL pointer dereference in the SRP  initiator
Date: Fri, 07 Aug 2009 14:14:03 -0700
Message-ID: <adatz0jcoo4.fsf@cisco.com>
References: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
	<4A7A949B.60408@panasas.com> <ada1vnohmc0.fsf@cisco.com>
	<e2e108260908070131r49dd2d37s8bb36c9365d991e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21818 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZHGVOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 17:14:04 -0400
In-Reply-To: <e2e108260908070131r49dd2d37s8bb36c9365d991e8@mail.gmail.com>
	(Bart Van Assche's message of "Fri, 7 Aug 2009 10:31:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>


 > A fix like the one below ?

I think this gets us part of the way, but not quite.

 > --- linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp-orig.c	2009-08-03
 > 12:13:11.000000000 +0200
 > +++ linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp.c	2009-08-07
 > 10:23:27.000000000 +0200
 > @@ -1371,16 +1371,27 @@ out:
 >  	return -1;
 >  }
 > 
 > +/**
 > + * Look up the struct srp_request that has been associated with the specified
 > + * SCSI command by srp_queuecommand().
 > + *
 > + * Returns 0 upon success and -1 upon failure.
 > + */
 >  static int srp_find_req(struct srp_target_port *target,
 >  			struct scsi_cmnd *scmnd,
 >  			struct srp_request **req)
 >  {
 > -	if (scmnd->host_scribble == (void *) -1L)
 > -		return -1;
 > +	/*
 > +	 * The code below will only work if SRP_RQ_SIZE is a power of two,
 > +	 * so check this first.
 > +	 */
 > +	BUILD_BUG_ON((SRP_RQ_SIZE ^ (SRP_RQ_SIZE - 1))
 > +		     != (SRP_RQ_SIZE | (SRP_RQ_SIZE - 1)));

could this be BUILD_BUG_ON(!is_power_of_2(SRP_RQ_SIZE)) ?
 > 
 > -	*req = &target->req_ring[(long) scmnd->host_scribble];
 > +	*req = &target->req_ring[(long)scmnd->host_scribble
 > +				 & (SRP_RQ_SIZE - 1)];
 > 
 > -	return 0;
 > +	return (*req)->scmnd == scmnd ? 0 : -1;
 >  }
 > 
 >  static int srp_abort(struct scsi_cmnd *scmnd)
 > @@ -1423,8 +1434,15 @@ static int srp_reset_device(struct scsi_
 > 
 >  	if (target->qp_in_error)
 >  		return FAILED;
 > -	if (srp_find_req(target, scmnd, &req))
 > -		return FAILED;
 > +	if (srp_find_req(target, scmnd, &req)) {
 > +		/*
 > +		 * scmnd has not yet been queued -- queue it now. This can
 > +		 * happen e.g. when a SG_SCSI_RESET ioctl has been issued.
 > +		 */
 > +		if (srp_queuecommand(scmnd, scmnd->scsi_done)
 > +		    || srp_find_req(target, scmnd, &req))
 > +			return FAILED;

I don't think we can just pass the command to srp_queuecommand() here.
For one thing queuecommand requires some locking, and second, we don't
actually want to queue the command -- in fact I'm not sure it is set up
properly with an opcode etc to execute the command.

What I think needs to happen is we need to allocate a request for the
command the same way srp_queuecommand() does, and in fact maybe that
code could be factored out to avoid duplication.

 -R .
