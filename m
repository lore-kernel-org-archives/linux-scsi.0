From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Sat, 5 Jul 2003 10:11:18 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307050959020.16984-100000@netrider.rowland.org>
References: <20030704125444.B17588@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1799 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S266353AbTGEN4s
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jul 2003 09:56:48 -0400
In-Reply-To: <20030704125444.B17588@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 4 Jul 2003, Matthew Dharm wrote:

> On Fri, Jul 04, 2003 at 03:36:55PM -0400, Alan Stern wrote:
> > Finally a segmentation violation occurs when __scsi_get_command() tries to
> > access dev->host->cmd_pool->gfp_mask.  Not surprising since the host
> > structure is gone.
> 
> This could still be our (usb-storage) problem.
> 
> We're not supposed to release the host structures until after ->release is
> called.  I think we're violating that right now.

Although that used to be true, it's not true any longer.  The SCSI 
midlayer interface changed very recently, and ->release is no longer 
called for hot-pluggable hosts.  See 
Documentation/scsi/scsi_mid_low_api.txt in 2.5.74.

> Add a little bit of debugging (a stub ->release() function that printk's)
> and see if the mid-layer really thinks that everything should have been
> freed already.

Not necessary.  Furthermore, it has been true for a while that the host 
structure is not deallocated when the driver calls scsi_unregister() -- or 
now scsi_host_put() -- but rather when its reference count goes to 0.  
This is a good example of the sort of thing that Christoph Hellwig says 
the driver shouldn't even be aware of, it should be completely internal to 
the SCSI core.

In any case, this particular problem isn't a result of deallocating the 
host too early; it's a result of trying to access the host (and maybe 
other related characteristics) of a device that is offline.  Now, I'm not 
familiar with the plans for completing the integration of the SCSI 
subsystem with the driver model -- maybe the host _isn't_ supposed to be 
deallocated until all the device structures have been freed first.  In 
that case, the problem would be that the device is failing to maintain a 
reference to the host structure.  Regardless, it will be solved when the 
driver model integration is completed; I think it's definitely _not_ a 
failing of usb-storage.

Alan Stern


