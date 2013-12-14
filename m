From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 19:48:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312131933320.3688-100000@saphir.localdomain>
References: <1386969529.2055.79.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386969529.2055.79.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 13 Dec 2013, James Bottomley wrote:

> On Fri, 2013-12-13 at 16:06 -0500, Alan Stern wrote:
> > On Fri, 13 Dec 2013, James Bottomley wrote:
> > 
> > > Actually, I think I have this figured out.  There's a thinko in one of
> > > the scsi_target_reap() cases.  The original (and still existing) problem
> > > with targets is that nothing creates them and nothing destroys them, so,
> > > while we could rely on the refcounting of the device model to preserve
> > > the actual target object, we had no idea when to remove it from
> > > visibility.  That was the job of the reap reference, to track
> > > visibility.  It looks like the reap on device last put is occurring too
> > > late.  I think we should reap immediately after doing the sdev
> > > device_del, so does this fix the warn on? (I'm not sure because no-one
> > > has actually posted a backtrace, but it sounds like this is the
> > > problem).
> > > 
> > > James
> > > 
> > > ---
> > > 
> > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > index 8ff62c2..98d4eb3 100644
> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
> > >  	/* NULL queue means the device can't be used */
> > >  	sdev->request_queue = NULL;
> > >  
> > > -	scsi_target_reap(scsi_target(sdev));
> > > -
> > >  	kfree(sdev->inquiry);
> > >  	kfree(sdev);
> > >  
> > > @@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
> > >  	} else
> > >  		put_device(&sdev->sdev_dev);
> > >  
> > > +	scsi_target_reap(scsi_target(sdev));
> > > +
> > >  	/*
> > >  	 * Stop accepting new requests and wait until all queuecommand() and
> > >  	 * scsi_run_queue() invocations have finished before tearing down the
> > 
> > This is not right.  The problem is that you don't keep track explicitly 
> > of the number of references to a target; you rely implicitly on 
> > starget->devices being non-empty.  starget->reap_ref is only a count of 
> > local operations that should block removal.
> 
> No, it was supposed explicitly to be a visibility counter to answer the
> question when can we delete the target.  It's incremented every time we
> add a device to the target (and when we do an operation that may remove
> one to keep an atomic context before we blow it away) and decremented
> every time we remove one.

Sorry, but you're wrong.  starget->reap_ref is _not_ incremented every 
time we add a device to the target.  That's one of the things we need to 
fix.

> > Consider, for example, what would happen if there is more than one LUN.  
> > What if one of them is removed while the other remains?
> 
> Then the reap reference remains above zero and the target stays.
> 
> > A more invasive change is needed.
> 
> I think you might be right in that we need to kill the list_empty check,
> but I think that should be it.

That, plus a one or two other things.  Look over the patch below.

Alan Stern



Index: usb-3.13/drivers/scsi/scsi_scan.c
===================================================================
--- usb-3.13.orig/drivers/scsi/scsi_scan.c
+++ usb-3.13/drivers/scsi/scsi_scan.c
@@ -334,6 +334,7 @@ static void scsi_target_dev_release(stru
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	WARN_ON(!list_empty(&starget->devices));
 	kfree(starget);
 	put_device(parent);
 }
@@ -481,7 +482,7 @@ void scsi_target_reap(struct scsi_target
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+	if (--starget->reap_ref == 0) {
 		empty = 1;
 		starget->state = STARGET_DEL;
 	}
Index: usb-3.13/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.13.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.13/drivers/scsi/scsi_sysfs.c
@@ -369,17 +369,13 @@ static void scsi_device_dev_release_user
 {
 	struct scsi_device *sdev;
 	struct device *parent;
-	struct scsi_target *starget;
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
-
 	parent = sdev->sdev_gendev.parent;
-	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
@@ -399,13 +395,10 @@ static void scsi_device_dev_release_user
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-	if (parent)
-		put_device(parent);
+	put_device(parent);
 }
 
 static void scsi_device_dev_release(struct device *dev)
@@ -1044,6 +1037,8 @@ void __scsi_remove_device(struct scsi_de
 	} else
 		put_device(&sdev->sdev_dev);
 
+	scsi_target_reap(scsi_target(sdev));
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
@@ -1200,6 +1195,7 @@ void scsi_sysfs_device_initialize(struct
 	sdev->scsi_level = starget->scsi_level;
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
+	++starget->reap_ref;
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
