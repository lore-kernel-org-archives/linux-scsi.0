From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC 2/2] dual scan thread bug fix
Date: Wed, 08 Jan 2014 07:42:36 +0800
Message-ID: <1389138156.2064.7.camel@dabdike.pnp.gw>
References: <Pine.LNX.4.44L0.1401041119030.31700-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1401041119030.31700-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-01-04 at 11:27 -0500, Alan Stern wrote:
> On Fri, 3 Jan 2014, James Bottomley wrote:
> 
> > > I'm still concerned about one thing.  The previous patch does this in
> > > scsi_alloc_target():
> > > 
> > > >   found:
> > > > -	found_target->reap_ref++;
> > > > +	if (!kref_get_unless_zero(&found_target->reap_ref))
> > > > +		/*
> > > > +		 * release routine already fired.  Target is dead, but
> > > > +		 * STARGET_DEL may not yet be set (set in the release
> > > > +		 * routine), so set here as well, just in case
> > > > +		 */
> > > > +		found_target->state = STARGET_DEL;
> > > >  	spin_unlock_irqrestore(shost->host_lock, flags);
> > > 
> > > As a result, the two comments in this patch aren't right:
> > > 
> > > > @@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
> > > >  	struct scsi_target *starget
> > > >  		= container_of(kref, struct scsi_target, reap_ref);
> > > >  
> > > > -	transport_remove_device(&starget->dev);
> > > > -	device_del(&starget->dev);
> > > > -	starget->state = STARGET_DEL;
> > > > +	/*
> > > > +	 * if we get here and the target is still in the CREATED state that
> > > > +	 * means it was allocated but never made visible (because a scan
> > > > +	 * turned up no LUNs), so don't call device_del() on it.
> > > > +	 */
> > > > +	if (starget->state == STARGET_RUNNING) {
> > > > +		transport_remove_device(&starget->dev);
> > > > +		device_del(&starget->dev);
> > > > +	}
> > > 
> > > Here the state could already be STARGET_DEL, even though the target is
> > > still visible.
> > 
> > Well, I agree with the theory.  In practise, there are only a few
> > machine instructions between the kref going to zero and us reaching that
> > point, because kref_release will jump into this routine next, so the
> > condition would be very hard to see.
> 
> It's true that the window is very small and not at all likely to be
> hit.  Still, I prefer eliminating such things entirely.
> 
> >  However, I suppose it's easy to
> > close by checking for != STARGET_CREATED and there's no reason not to do
> > that, so I'll change it.
> 
> Checking for != STARGET_CREATED is also wrong in principle.  The state
> could already be STARGET_DEL even though the target was never made
> visible.
> 
> The basic problem is that you are relying on the state to be an
> accurate description of the target's visibility, but
> scsi_alloc_target() changes the state without changing the visibility.  
> I really think you should get rid of that extra assignment in
> scsi_alloc_target().

OK, Agreed, but that means modifying the 1/2 patch with the below.  This
should make the proposed diff to 2/2 correct.

James

---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef3f958..5fad646 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -417,7 +417,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		+ shost->transportt->target_size;
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
-	int error;
+	int error, ref_got;
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -466,15 +466,15 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	return starget;
 
  found:
-	if (!kref_get_unless_zero(&found_target->reap_ref))
-		/*
-		 * release routine already fired.  Target is dead, but
-		 * STARGET_DEL may not yet be set (set in the release
-		 * routine), so set here as well, just in case
-		 */
-		found_target->state = STARGET_DEL;
+	/*
+	 * release routine already fired if kref is zero, so if we can still
+	 * take the reference, the target must be alive.  If we can't, it must
+	 * be dying and we need to wait for a new target
+	 */
+	ref_got = kref_get_unless_zero(&found_target->reap_ref);
+
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	if (found_target->state != STARGET_DEL) {
+	if (ref_got) {
 		put_device(dev);
 		return found_target;
 	}
@@ -482,8 +482,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	 * Unfortunately, we found a dying target; need to wait until it's
 	 * dead before we can get a new one.  There is an anomaly here.  We
 	 * *should* call scsi_target_reap() to balance the kref_get() of the
-	 * reap_ref above.  However, since the target is in state STARGET_DEL,
-	 * it's already invisible and the reap_ref is irrelevant.  If we call
+	 * reap_ref above.  However, since the target being released, it's
+	 * already invisible and the reap_ref is irrelevant.  If we call
 	 * scsi_target_reap() we might spuriously do another device_del() on
 	 * an already invisible target.
 	 */




--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
