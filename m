From: Christoph Hellwig <hch@lst.de>
Subject: Re: What's the state of sdev->tagged_queue
Date: Fri, 6 Jun 2003 16:19:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606141933.GA23096@lst.de>
References: <20030606074813.GA18748@lst.de> <3EE09F82.2060000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:27349 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261624AbTFFOGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:06:03 -0400
Content-Disposition: inline
In-Reply-To: <3EE09F82.2060000@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 06, 2003 at 10:04:50AM -0400, Doug Ledford wrote:
> >but several drivers still look at it although it's never touched
> >outside scsi_ioctl.c and the individual drivers.  Most drivers uses also
> >look pretty bogus.  Can we just the ioctls and the field?
> 
> I assume that should read "Can we just kill the ioctls and the field?" :-)

Umm, yes..

> The answer to that is yes I think.  The ioctls for certain, the field 
> I'm pretty sure of.  Originally, the field was used as a boolean that 
> was when we enabled tagged queueing on a device.  Now, a value of 
> simple_tags > 1 should do the same thing.

simple_tags == 1?  in my source it's a bitfield.

> However, due to usage of 
> cmd_per_lun on both tagged and untagged devices (I would have to check 
> this, I'm a bit out of touch since my accident)

Sorry, didn't know of that.  I hope you're well already and if not
I wish you to get well soon.

> may cause confusion.  If 
> we set queue depth to cmd_per_lun the device may look tagged when it is 
> in fact not tagged.  The replacement test may need to be if simple_tags 

<snip>

> Currently, we use the value of host->this_id to skip the scsi device of 
> the host controller in our device scan.  What I would like to do is 
> create an sg device entry for this_id that is type processor,

We already have scsi_get_host_dev to get such a device if the LLDD
wants it.  Generalizing it sounds like a good idea.  But before
that we need a 64bit dev_t so we can have sg devices for the
ever-growing number of scsi_devices :)

> is a fake 
> device, that implements whatever ioctls at the mid layer level that are 
> appropriate, but that also allow the low level driver to register a fall 
> through host ioctl routine that can be attached to this device.

I don't think we should another ioctl routine.  Just use the normal
ioctl routine in the host template and let the LLDD check for
host->this_id.

