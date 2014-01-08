From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 2/2] dual scan thread bug fix
Date: Thu, 09 Jan 2014 06:37:10 +0800
Message-ID: <1389220630.2440.10.camel@dabdike.pnp.gw>
References: <Pine.LNX.4.44L0.1401081051160.1659-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42575 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbaAHWhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 17:37:14 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401081051160.1659-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, 2014-01-08 at 10:57 -0500, Alan Stern wrote:
> On Wed, 8 Jan 2014, James Bottomley wrote:
> 
> > OK, Agreed, but that means modifying the 1/2 patch with the below.  This
> > should make the proposed diff to 2/2 correct.
> > 
> > James
> > 
> > ---
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index ef3f958..5fad646 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -417,7 +417,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
> >  		+ shost->transportt->target_size;
> >  	struct scsi_target *starget;
> >  	struct scsi_target *found_target;
> > -	int error;
> > +	int error, ref_got;
> >  
> >  	starget = kzalloc(size, GFP_KERNEL);
> >  	if (!starget) {
> > @@ -466,15 +466,15 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
> >  	return starget;
> >  
> >   found:
> > -	if (!kref_get_unless_zero(&found_target->reap_ref))
> > -		/*
> > -		 * release routine already fired.  Target is dead, but
> > -		 * STARGET_DEL may not yet be set (set in the release
> > -		 * routine), so set here as well, just in case
> > -		 */
> > -		found_target->state = STARGET_DEL;
> > +	/*
> > +	 * release routine already fired if kref is zero, so if we can still
> > +	 * take the reference, the target must be alive.  If we can't, it must
> > +	 * be dying and we need to wait for a new target
> > +	 */
> > +	ref_got = kref_get_unless_zero(&found_target->reap_ref);
> > +
> >  	spin_unlock_irqrestore(shost->host_lock, flags);
> > -	if (found_target->state != STARGET_DEL) {
> > +	if (ref_got) {
> >  		put_device(dev);
> >  		return found_target;
> >  	}
> > @@ -482,8 +482,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
> >  	 * Unfortunately, we found a dying target; need to wait until it's
> >  	 * dead before we can get a new one.  There is an anomaly here.  We
> >  	 * *should* call scsi_target_reap() to balance the kref_get() of the
> > -	 * reap_ref above.  However, since the target is in state STARGET_DEL,
> > -	 * it's already invisible and the reap_ref is irrelevant.  If we call
> > +	 * reap_ref above.  However, since the target being released, it's
> > +	 * already invisible and the reap_ref is irrelevant.  If we call
> >  	 * scsi_target_reap() we might spuriously do another device_del() on
> >  	 * an already invisible target.
> >  	 */
> 
> In fact, most of this comment (everything after the first sentence) is
> no longer needed.  If the target is dying then kref_get_unless_zero
> must have failed, so there is no need to worry about unbalanced
> refcounts.

I'd like to keep the comment: I get a lot of email from people who write
static checkers for this.  In principle, I agree, they should treat
kref_get_unless_zero() as a spin_trylock(), but it's nice to have
something concrete in the code to point to when the email arrives.

> Otherwise this looks good.

Great, thanks, I'll re-roll and repost.

James



