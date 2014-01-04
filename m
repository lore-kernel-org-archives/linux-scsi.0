From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 2/2] dual scan thread bug fix
Date: Sat, 4 Jan 2014 11:27:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401041119030.31700-100000@netrider.rowland.org>
References: <1388814065.6687.0.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36694 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754513AbaADQ1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2014 11:27:38 -0500
In-Reply-To: <1388814065.6687.0.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Fri, 3 Jan 2014, James Bottomley wrote:

> > I'm still concerned about one thing.  The previous patch does this in
> > scsi_alloc_target():
> > 
> > >   found:
> > > -	found_target->reap_ref++;
> > > +	if (!kref_get_unless_zero(&found_target->reap_ref))
> > > +		/*
> > > +		 * release routine already fired.  Target is dead, but
> > > +		 * STARGET_DEL may not yet be set (set in the release
> > > +		 * routine), so set here as well, just in case
> > > +		 */
> > > +		found_target->state = STARGET_DEL;
> > >  	spin_unlock_irqrestore(shost->host_lock, flags);
> > 
> > As a result, the two comments in this patch aren't right:
> > 
> > > @@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
> > >  	struct scsi_target *starget
> > >  		= container_of(kref, struct scsi_target, reap_ref);
> > >  
> > > -	transport_remove_device(&starget->dev);
> > > -	device_del(&starget->dev);
> > > -	starget->state = STARGET_DEL;
> > > +	/*
> > > +	 * if we get here and the target is still in the CREATED state that
> > > +	 * means it was allocated but never made visible (because a scan
> > > +	 * turned up no LUNs), so don't call device_del() on it.
> > > +	 */
> > > +	if (starget->state == STARGET_RUNNING) {
> > > +		transport_remove_device(&starget->dev);
> > > +		device_del(&starget->dev);
> > > +	}
> > 
> > Here the state could already be STARGET_DEL, even though the target is
> > still visible.
> 
> Well, I agree with the theory.  In practise, there are only a few
> machine instructions between the kref going to zero and us reaching that
> point, because kref_release will jump into this routine next, so the
> condition would be very hard to see.

It's true that the window is very small and not at all likely to be
hit.  Still, I prefer eliminating such things entirely.

>  However, I suppose it's easy to
> close by checking for != STARGET_CREATED and there's no reason not to do
> that, so I'll change it.

Checking for != STARGET_CREATED is also wrong in principle.  The state
could already be STARGET_DEL even though the target was never made
visible.

The basic problem is that you are relying on the state to be an
accurate description of the target's visibility, but
scsi_alloc_target() changes the state without changing the visibility.  
I really think you should get rid of that extra assignment in
scsi_alloc_target().

> How does the attached diff look?

Better but still not right.

Alan Stern

