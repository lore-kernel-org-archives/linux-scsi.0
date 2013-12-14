From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 22:00:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312132147001.7197-100000@netrider.rowland.org>
References: <1386984423.2055.92.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49563 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753178Ab3LNDAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2013 22:00:16 -0500
In-Reply-To: <1386984423.2055.92.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 13 Dec 2013, James Bottomley wrote:

> > Sorry, but you're wrong.  starget->reap_ref is _not_ incremented every 
> > time we add a device to the target.  That's one of the things we need to 
> > fix.
> 
> Well, then we would have a pretty astonishing cockup in the code.  The
> found case of scsi_alloc_target increments the reference each time it's
> called, so scsi_add_device() definitely behaves like this.

You forgot that __scsi_add_device() calls scsi_target_reap() at the 
end.  So the reference count is incremented and then decremented again.

It's easy enough to check that the scsi_probe_and_add_lun pathway
doesn't elevate the refcount.  Print out the value of starget->reap_ref
just after __scsi_add_device() calls scsi_alloc_target() and just
before it calls scsi_target_reap().

>  I suppose
> it's possible the list_empty() check is covering a miscount in some of
> the other probing routines, but that would mean we have stale targets
> for a lot of our use cases.  I'll audit the code.

That's probably right; whenever a target has more than one LUN we must 
end up leaking the target.  In the common case of one LUN it works out, 
because the list is empty by the time the scsi_device is released.

Alan Stern

