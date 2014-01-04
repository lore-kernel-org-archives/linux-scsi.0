From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 2/2] dual scan thread bug fix
Date: Fri, 03 Jan 2014 21:41:05 -0800
Message-ID: <1388814065.6687.0.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1401031047150.15237-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42805 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbaADFlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2014 00:41:07 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401031047150.15237-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>


On Fri, 2014-01-03 at 10:58 -0500, Alan Stern wrote:
> On Thu, 2 Jan 2014, James Bottomley wrote:
> 
> > In the highly unusual case where two threads are running concurrently through
> > the scanning code scanning the same target, we run into the situation where
> > one may allocate the target while the other is still using it.  In this case,
> > because the reap checks for STARGET_CREATED and kills the target without
> > reference counting, the second thread will do the wrong thing on reap.
> > 
> > Fix this by reference counting even creates and doing the STARGET_CREATED
> > check in the final put.
> 
> I'm still concerned about one thing.  The previous patch does this in
> scsi_alloc_target():
> 
> >   found:
> > -	found_target->reap_ref++;
> > +	if (!kref_get_unless_zero(&found_target->reap_ref))
> > +		/*
> > +		 * release routine already fired.  Target is dead, but
> > +		 * STARGET_DEL may not yet be set (set in the release
> > +		 * routine), so set here as well, just in case
> > +		 */
> > +		found_target->state = STARGET_DEL;
> >  	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> As a result, the two comments in this patch aren't right:
> 
> > @@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
> >  	struct scsi_target *starget
> >  		= container_of(kref, struct scsi_target, reap_ref);
> >  
> > -	transport_remove_device(&starget->dev);
> > -	device_del(&starget->dev);
> > -	starget->state = STARGET_DEL;
> > +	/*
> > +	 * if we get here and the target is still in the CREATED state that
> > +	 * means it was allocated but never made visible (because a scan
> > +	 * turned up no LUNs), so don't call device_del() on it.
> > +	 */
> > +	if (starget->state == STARGET_RUNNING) {
> > +		transport_remove_device(&starget->dev);
> > +		device_del(&starget->dev);
> > +	}
> 
> Here the state could already be STARGET_DEL, even though the target is
> still visible.

Well, I agree with the theory.  In practise, there are only a few
machine instructions between the kref going to zero and us reaching that
point, because kref_release will jump into this routine next, so the
condition would be very hard to see.  However, I suppose it's easy to
close by checking for != STARGET_CREATED and there's no reason not to do
that, so I'll change it.

> Also, it's a little odd that the comment talks about CREATED but the 
> code really checks for RUNNING.  They should be consistent.

!= STARGET_CREATED should solve this.

> > @@ -506,11 +513,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
> >   */
> >  void scsi_target_reap(struct scsi_target *starget)
> >  {
> > +	/*
> > +	 * serious problem if this triggers: STARGET_DEL is only set in the
> > +	 * kref release routine, so we're doing another final put on an
> > +	 * already released kref
> > +	 */
> >  	BUG_ON(starget->state == STARGET_DEL);
> 
> Here the code is okay but the comment is wrong: STARGET_DEL is set in 
> _two_ places (but neither of them runs until reap_ref has reached 0).
> 
> Would it be better in scsi_alloc_target() to behave as though the state 
> were STARGET_DEL without actually setting it?

Yes, I'll update the comment to it only goes to DEL after the kref goes
to zero.

How does the attached diff look?

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 82cf902..2f7de33 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -390,7 +390,7 @@ static void scsi_target_reap_ref_release(struct kref *kref)
 	 * means it was allocated but never made visible (because a scan
 	 * turned up no LUNs), so don't call device_del() on it.
 	 */
-	if (starget->state == STARGET_RUNNING) {
+	if (starget->state != STARGET_CREATED) {
 		transport_remove_device(&starget->dev);
 		device_del(&starget->dev);
 	}
@@ -514,9 +514,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 void scsi_target_reap(struct scsi_target *starget)
 {
 	/*
-	 * serious problem if this triggers: STARGET_DEL is only set in the
-	 * kref release routine, so we're doing another final put on an
-	 * already released kref
+	 * serious problem if this triggers: STARGET_DEL is only set in the if
+	 * the reap_ref drops to zero, so we're trying to do another final put
+	 * on an already released kref
 	 */
 	BUG_ON(starget->state == STARGET_DEL);
 	scsi_target_reap_ref_put(starget);




