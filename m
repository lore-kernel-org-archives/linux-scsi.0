From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sat, 14 Dec 2013 15:55:13 -0800
Message-ID: <1387065313.6096.16.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312132220260.7586-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57441 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab3LNXzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Dec 2013 18:55:15 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312132220260.7586-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2013-12-13 at 22:32 -0500, Alan Stern wrote:
> On Fri, 13 Dec 2013, James Bottomley wrote:
> 
> > This patch eliminates the reap_ref and replaces it with a proper kref.
> > On last put of this kref, the target is removed from visibility in
> > sysfs.  The final call to scsi_target_reap() for the device is done from
> > __scsi_remove_device() and only if the device was made visible.  This
> > ensures that the target disappears as soon as the last device is gone
> > rather than waiting until final release of the device (which is often
> > too long).
> 
> 
> > @@ -474,28 +496,11 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
> >   */
> >  void scsi_target_reap(struct scsi_target *starget)
> >  {
> > -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> > -	unsigned long flags;
> > -	enum scsi_target_state state;
> > -	int empty = 0;
> > -
> > -	spin_lock_irqsave(shost->host_lock, flags);
> > -	state = starget->state;
> > -	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> > -		empty = 1;
> > -		starget->state = STARGET_DEL;
> > -	}
> > -	spin_unlock_irqrestore(shost->host_lock, flags);
> > -
> > -	if (!empty)
> > -		return;
> > -
> > -	BUG_ON(state == STARGET_DEL);
> > -	if (state == STARGET_CREATED)
> > +	BUG_ON(starget->state == STARGET_DEL);
> > +	if (starget->state == STARGET_CREATED)
> >  		scsi_target_destroy(starget);
> >  	else
> > -		execute_in_process_context(scsi_target_reap_usercontext,
> > -					   &starget->ew);
> > +		scsi_target_reap_ref_put(starget);
> 
> The refcount test and state change race with scsi_alloc_target().  
> Maybe the race won't occur in practice, but to be safe you should hold
> shost->host_lock throughout that time interval, as the original code
> here does.

You mean the fact that using a state model to indicate whether we should
destroy a target without bothering to refcount isn't robust against two
threads of execution running through a scan on the same target?  Yes, it
could be construed as a bug, but it's a bug in the old code as well.

> This means the kref approach won't work so easily.  You might as well
> leave reap_ref as an ordinary int.

Actually, no, we can better fix it using krefs.  We just force
everything through the kref put instead of special casing the not made
visible destruction case.  We can then case the release routine to fix
this, like below.  I suppose since this is a separate bug I'll keep it
as a separate patch.

> > @@ -393,7 +393,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
> >  	starget = to_scsi_target(parent);
> >  
> >  	spin_lock_irqsave(sdev->host->host_lock, flags);
> > -	starget->reap_ref++;
> >  	list_del(&sdev->siblings);
> >  	list_del(&sdev->same_target_siblings);
> >  	list_del(&sdev->starved_entry);
> 
> starget is now an unused local variable.  It can be eliminated.

True, dumped them, thanks.

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d966e36..327c0e92 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -320,6 +320,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
@@ -384,9 +385,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
 	struct scsi_target *starget
 		= container_of(kref, struct scsi_target, reap_ref);
 
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	starget->state = STARGET_DEL;
+	/*
+	 * if we get here and the target is still in the CREATED state that
+	 * means it was allocated but never made visible (because a scan
+	 * turned up no LUNs), so don't call device_del() on it.
+	 */
+	if (starget->state == STARGET_RUNNING) {
+		transport_remove_device(&starget->dev);
+		device_del(&starget->dev);
+	}
 	scsi_target_destroy(starget);
 }
 
@@ -496,11 +503,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
+	/*
+	 * serious problem if this triggers: STARGET_DEL is only set in the
+	 * kref release routine, so we're doing another final put on an
+	 * already released kref
+	 */
 	BUG_ON(starget->state == STARGET_DEL);
-	if (starget->state == STARGET_CREATED)
-		scsi_target_destroy(starget);
-	else
-		scsi_target_reap_ref_put(starget);
+	scsi_target_reap_ref_put(starget);
 }
 
 /**


