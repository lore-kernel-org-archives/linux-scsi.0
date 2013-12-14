From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 17:27:03 -0800
Message-ID: <1386984423.2055.92.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312131933320.3688-100000@saphir.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54275 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649Ab3LNB1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 20:27:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312131933320.3688-100000@saphir.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2013-12-13 at 19:48 -0500, Alan Stern wrote:
> On Fri, 13 Dec 2013, James Bottomley wrote:
> 
> > On Fri, 2013-12-13 at 16:06 -0500, Alan Stern wrote:
> > > On Fri, 13 Dec 2013, James Bottomley wrote:
> > > 
> > > > Actually, I think I have this figured out.  There's a thinko in one of
> > > > the scsi_target_reap() cases.  The original (and still existing) problem
> > > > with targets is that nothing creates them and nothing destroys them, so,
> > > > while we could rely on the refcounting of the device model to preserve
> > > > the actual target object, we had no idea when to remove it from
> > > > visibility.  That was the job of the reap reference, to track
> > > > visibility.  It looks like the reap on device last put is occurring too
> > > > late.  I think we should reap immediately after doing the sdev
> > > > device_del, so does this fix the warn on? (I'm not sure because no-one
> > > > has actually posted a backtrace, but it sounds like this is the
> > > > problem).
> > > > 
> > > > James
> > > > 
> > > > ---
> > > > 
> > > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > > index 8ff62c2..98d4eb3 100644
> > > > --- a/drivers/scsi/scsi_sysfs.c
> > > > +++ b/drivers/scsi/scsi_sysfs.c
> > > > @@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
> > > >  	/* NULL queue means the device can't be used */
> > > >  	sdev->request_queue = NULL;
> > > >  
> > > > -	scsi_target_reap(scsi_target(sdev));
> > > > -
> > > >  	kfree(sdev->inquiry);
> > > >  	kfree(sdev);
> > > >  
> > > > @@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
> > > >  	} else
> > > >  		put_device(&sdev->sdev_dev);
> > > >  
> > > > +	scsi_target_reap(scsi_target(sdev));
> > > > +
> > > >  	/*
> > > >  	 * Stop accepting new requests and wait until all queuecommand() and
> > > >  	 * scsi_run_queue() invocations have finished before tearing down the
> > > 
> > > This is not right.  The problem is that you don't keep track explicitly 
> > > of the number of references to a target; you rely implicitly on 
> > > starget->devices being non-empty.  starget->reap_ref is only a count of 
> > > local operations that should block removal.
> > 
> > No, it was supposed explicitly to be a visibility counter to answer the
> > question when can we delete the target.  It's incremented every time we
> > add a device to the target (and when we do an operation that may remove
> > one to keep an atomic context before we blow it away) and decremented
> > every time we remove one.
> 
> Sorry, but you're wrong.  starget->reap_ref is _not_ incremented every 
> time we add a device to the target.  That's one of the things we need to 
> fix.

Well, then we would have a pretty astonishing cockup in the code.  The
found case of scsi_alloc_target increments the reference each time it's
called, so scsi_add_device() definitely behaves like this.  I suppose
it's possible the list_empty() check is covering a miscount in some of
the other probing routines, but that would mean we have stale targets
for a lot of our use cases.  I'll audit the code.

James


