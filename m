From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 23 Sep 2015 09:58:23 -0400
Message-ID: <1443016703.4132.84.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-20-git-send-email-hare@suse.de>
	 <1442951383.4132.65.camel@localhost.localdomain> <5601B6ED.7060400@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbbIWN6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2015 09:58:25 -0400
In-Reply-To: <5601B6ED.7060400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-09-22 at 22:15 +0200, Hannes Reinecke wrote:
> On 09/22/2015 09:49 PM, Ewan Milne wrote:
> > On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> >> The current ALUA device_handler has two drawbacks:
> >> - We're sending a 'SET TARGET PORT GROUP' command to every LUN,
> >>   disregarding the fact that several LUNs might be in a port group
> >>   and will be automatically switched whenever _any_ LUN within
> >>   that port group receives the command.
> >> - Whenever a LUN is in 'transitioning' mode we cannot block I/O
> >>   to that LUN, instead the controller has to abort the command.
> >>   This leads to increased traffic across the wire and heavy load
> >>   on the controller during switchover.
> > 
> > I'm not sure I understand what this means - why couldn't we block I/O?
> > and what does 'heavy load' mean?  Aborting commands is 'heavy load'?
> > 
> If we're getting a sense code indicating that the LUN is in
> transitioning _and_ we're blocking I/O we never ever send down I/Os to
> that driver anymore, so we cannot receive any sense codes indicating the
> transitioning is done.
> At the same time, every I/O we're sending down will be returned by the
> storage I/O with a sense code, requiring us to retry the command.
> Hence we're constantly retrying I/O.

Ah, OK.  Perhaps including this explanation either in the comments with
patch 22/23 which adds the TEST UNIT READY commands to poll for the
status, or in the patch description somewhere would be helpful.

> 
> [ .. ]
> >> @@ -811,10 +1088,17 @@ failed:
> >>  static void alua_bus_detach(struct scsi_device *sdev)
> >>  {
> >>  	struct alua_dh_data *h = sdev->handler_data;
> >> +	struct alua_port_group *pg;
> >>  
> >> -	if (h->pg) {
> >> -		kref_put(&h->pg->kref, release_port_group);
> >> -		h->pg = NULL;
> >> +	spin_lock(&h->pg_lock);
> >> +	pg = h->pg;
> >> +	rcu_assign_pointer(h->pg, NULL);
> >> +	spin_unlock(&h->pg_lock);
> >> +	synchronize_rcu();
> >> +	if (pg) {
> >> +		if (pg->rtpg_sdev)
> >> +			flush_workqueue(pg->work_q);
> >> +		kref_put(&pg->kref, release_port_group);
> >>  	}
> >>  	sdev->handler_data = NULL;
> >>  	kfree(h);
> > 
> > So, you've already had a bit of discussion with Christoph about this,
> > the main portion of your ALUA rewrite, and I won't go over all of that,
> > except to say that I'd have to agree that having separate work queues
> > for the different RTPG/STPG functions and having them manipulate each
> > other's flags seems like we'd be better off having just one work
> > function that did everything.  Less messy and easier to maintain.
> > 
> > Also, it seems like wrong ordering of kref_get() vs. scsi_device_get(),
> > in alua_rtpg_queue() since they are released as kref_put() then
> > scsi_device_put()?
> > 
> Yeah, I've reworked the reference counting.
> And reverted the workqueue handling to use the original model.
> 
> Cheers,
> 
> Hannes


