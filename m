From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] SCSI: fix target allocation outside of scan_mutex
Date: Sat, 13 Mar 2010 10:51:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003131017130.14655-100000@netrider.rowland.org>
References: <1268430358.2802.360.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:54199 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759309Ab0CMPvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Mar 2010 10:51:46 -0500
In-Reply-To: <1268430358.2802.360.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 12 Mar 2010, James Bottomley wrote:

> > You're right that a duplicate target wouldn't get created.  Still,
> > there really is a bug.  Suppose two different threads call
> > scsi_alloc_target() for the same target ID at about the same time.  The
> > first thread won't find an existing target on the list, so it will
> > allocate and initialize a new target structure.  However, it releases
> > the host lock before calling the host template's target_alloc method.
> > 
> > Meanwhile, the second thread will find the new target structure on the 
> > list and will therefore feel free to start using it.  If the timing 
> > works out, it could start using the new target before the first thread 
> > calls target_alloc.
> 
> So currently, that can't happen because of the scan mutex.

True.  Okay, that's not a bug.  However I still have the feeling that
the concurrency issues associated with targets haven't been thought out
sufficiently.

Here's another example.  Suppose that two threads probe two different 
LUNs under the same target at the same time, and suppose that 
scsi_target_add() fails:

	Thread 0			Thread 1
	--------			--------
	scsi_alloc_target() creates a new target
	Lock scan_mutex
	Scan LUN1
					scsi_alloc_target() finds the
						existing target and
						increments its reap_ref
					Blocks waiting for scan_mutex
	scsi_target_add() fails
	Destroy the sdev for LUN1 (the target
	  isn't destroyed because thread 1
	  has incremented reap_ref)
	Unlock scan_mutex
					Scan LUN2
					Call scsi_target_add() again

The code ends up calling device_add() twice for the same target
structure.  Even though the first call fails, the driver core does not
guarantee this will work properly.  AFAIK, nobody has ever audited that
code to see if there are any fields assumed to be 0 which may end up
being nonzero after a failed registration.

Also, notice that in its failure path, scsi_alloc_target() calls 
scsi_target_reap().  This doesn't seem right; it's unbalanced.  Here's 
what can happen:

	__scsi_add_device() calls scsi_alloc_target(), creating a new
	target with reap_ref = 1.

	It then calls scsi_probe_and_add_lun(), which calls 
	scsi_alloc_sdev(), increasing reap_ref to 2.

	Next we call scsi_add_lun(), but scsi_target_add() fails
	decreasing reap_ref back to 1.

	scsi_add_lun() returns SCSI_SCAN_NO_RESPONSE because of
	the failure, so scsi_probe_and_add_lun() goes on to call
	__scsi_remove_device().

	This causes scsi_device_dev_release_usercontext() to call
	scsi_target_reap(), decreasing reap_ref to 0 and deallocating
	the target structure.

	Finally, __scsi_add_device() calls scsi_target_reap(), passing
	a pointer to a structure that no longer exists.

The last two steps may occur in the opposite order because of the use
of a workqueue, but the end result is the same: scsi_target_reap() gets
called with a stale pointer.  It certainly looks as though
scsi_target_add() should not include the

		get_device(&starget->dev);
		scsi_target_reap(starget);
		put_device(&starget->dev);

sequence.  (Not to mention that the get_device and put_device calls are 
totally gratuitous anyway.)

Alan Stern

