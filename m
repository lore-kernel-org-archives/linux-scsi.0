From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 10:10:52 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404061002070.1042-100000@ida.rowland.org>
References: <20040405151031.A5470@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5380 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263813AbUDFOKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 10:10:52 -0400
In-Reply-To: <20040405151031.A5470@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 5 Apr 2004, Patrick Mansfield wrote:

> Yes. 
> 
> If we are in middle opening an sd, and are anywhere between the
> kobj_lookup having completed call to up_read(domain->sem) [called via
> do_open calling get_gendisk] and sd_open calling scsi_device_get(), and
> separately an sd_remove call completes [freeing the scsi_disk and the
> scsi_device] there could be an oops.
> 
> Much as I hate it, simply adding a lock_kernel in sd_remove would solve
> the problem, since do_open uses lock_kernel.

There must be a better solution, although I can't recommend anything 
offhand.  It might require changing the genhd interface somewhat.

> And I don't see why the kobject_get/put use an atomic_inc/dec, it just
> obscures the need for a lock. We already have a reference to the kobject
> (it's passed as an argument). The calls to the get/put must either be
> protected with a lock or other method, or we have already gotten a
> reference to the object and getting another is meaningless.

This is really a matter of definitions.  The kobject/driver-model people 
use "reference" to mean, very specifically, an incremented refcounter.  
They do not (so far as I can tell) intend the more general meaning, i.e., 
any sort of pointer to the object.  So yes, the call to kobject_get passes 
as an argument a "reference" in the general sense, and the call returns a 
"reference" in the more specific sense.

The point is, the refcounting model is meant only to guarantee that an
object will not be deallocated when it has any outstanding "references" in
the specific sense -- i.e., when its refcount is positive.  It does _not_
guarantee that there are no pointers to the object lurking somewhere else
in the kernel; that job is up to the driver's author.  With careful
programming it can be done.  The code in sd.c is not sufficiently careful.

Alan Stern

