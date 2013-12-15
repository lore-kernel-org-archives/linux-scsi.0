From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 14:14:34 -0800
Message-ID: <1387145674.2284.60.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312151550380.32133-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1312151550380.32133-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2013-12-15 at 16:32 -0500, Alan Stern wrote:
> On Sat, 14 Dec 2013, James Bottomley wrote:
> 
> > > The refcount test and state change race with scsi_alloc_target().  
> > > Maybe the race won't occur in practice, but to be safe you should hold
> > > shost->host_lock throughout that time interval, as the original code
> > > here does.
> > 
> > You mean the fact that using a state model to indicate whether we should
> > destroy a target without bothering to refcount isn't robust against two
> > threads of execution running through a scan on the same target?
> 
> I meant that the patch you posted suffers from a race when one thread
> is adding a device to a target and another thread is removing an
> existing device below that target at the same time.  Suppose the
> target's reap_ref count is initially equal to 1:
> 
> 	Thread 0			Thread 1
> 	--------			--------
> 	In scsi_alloc_target():		In scsi_target_reap():
> 	lock host_lock			scsi_target_reap_ref_put():
> 	find existing starget		starget->reap_ref drops to 0
> 	incr starget->reap_ref		In scsi_target_reap_ref_release():
> 	unlock host_lock		device_del(&starget->dev);
> 	starget->state == STARGET_DEL?
> 	No => okay to use starget	set starget->state = STARGET_DEL
> 
> Result: We end up using starget _and_ removing it.  The only way to
> avoid this race would be to guarantee that we never add and remove
> devices below the same target at the same time.  In theory this is 
> feasible, but I don't know if you want to do it.
> 
> This doesn't seem to be what you are talking about above.  In any case, 
> it is a bug.

No, I was thinking of the two thread scan bug (i.e. two scan threads)
not one scan and one remove, which is a bug in the old code.  This is a
race between put and get when the kref is incremented from zero (an
illegal operation which triggers a warn on).

The way to mediate this is to check for the kref already being zero
condition, like below.

James

---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 327c0e92..303d471 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -473,7 +473,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	return starget;
 
  found:
-	kref_get(&found_target->reap_ref);
+	if (!kref_get_unless_zero(&found_target->reap_ref))
+		/*
+		 * release routine already fired.  Target is dead, but
+		 * STARGET_DEL may not yet be set (set in the release
+		 * routine), so set here as well, just in case
+		 */
+		found_target->state = STARGET_DEL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
 		put_device(dev);



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
