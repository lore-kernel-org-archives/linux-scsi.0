From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed, 05 Nov 2008 13:46:13 -0500
Message-ID: <1225910773.4703.51.camel@localhost.localdomain>
References: <20081105040154.9690A108048@picon.linux-foundation.org>
	 <1225898691.4703.32.camel@localhost.localdomain>
	 <4911D6F2.2080309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39135 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYKESq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 13:46:26 -0500
In-Reply-To: <4911D6F2.2080309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-11-05 at 11:25 -0600, Mike Christie wrote:
> James Bottomley wrote:
> > The reason for doing it like this is so that if someone slices the loop
> > apart again (which is how this crept in) they won't get a continue or
> > something which allows this to happen.
> > 
> > It shouldn't be conditional on the starved list (or anything else)
> > because it's probably a register and should happen at the same point as
> > the list deletion but before we drop the problem lock (because once we
> > drop that lock we'll need to recompute starvation).
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index f5d3b96..f9a531f 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
> >  		}
> >  
> >  		list_del_init(&sdev->starved_entry);
> > +		starved_entry = NULL;
> 
> Should this be starved_head?

Yes, sorry, constructed patch on 'plane and didn't compile it.

> >  		spin_unlock(shost->host_lock);
> >  
> >  		spin_lock(sdev->request_queue->queue_lock);
> > 
> 
> Do you think we can just splice the list like the attached patch (patch 
> is example only and is not tested)?

Afraid not ... you could still get a starved_head that's no longer
current (it gets tagged as starved_head then removed from the spliced
starved_list and then continued lower down) which would still cause the
endless loop.

> I thought the code is clearer, but I think it may be less efficient. If 
> scsi_run_queue is run on multiple processors then with the attached 
> patch one processor would splice the list and possibly have to execute 
> __blk_run_queue for all the devices on the list serially.
> 
> Currently we can at least prep the devices in parallel. One processor 
> would grab one entry on the list and drop the host lock, so then another 
> processor could grab another entry on the list and start the execution 
> process (I wrote start the process because it might turn out that this 
> second entry execution might have to wait on the first one when the scsi 
> layer has to grab the queue lock again).

James


