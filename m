From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 15:21:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124232128.GC2775@beaverton.ibm.com>
References: <3E31AB91.9080400@splentec.com> <Pine.LNX.4.44L0.0301241649460.692-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0301241649460.692-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Fri, 24 Jan 2003, Luben Tuikov wrote:
> 
> > >>A LLDD should and must *not* call scsi_unregister_host().  This brakes
> > >>all hierarchy.
> > > 
> > 
> > What I probably meant is the detect()/release() pair; release() itself
> > normally calls scsi_unregister(host); the point is that it got nudged
> > from ``above'', i.e. SCSI Core.
> > 
> > How can a LLDD be certain that it can safely call scsi_unregister_host()
> > whenever it wishes?  As Doug pointed out this leads to problems.
> 
> Apparently it can't.  I don't mean to say that this was the right thing to 
> do; I just meant that this is what Matt's currently-proposed patch does.  
> Personally, I'm not very familiar with the details of the SCSI subsystem, 
> and I don't know what preconditions are required for calling the various 
> API's.
> 
> > Furhtermore, are we talking about scsi_unregister_host() or
> > scsi_unregister(host)?  The former does drivers and the latter
> > does hosts.  This would mean that my original statement was
> > nevertheless correct, how can a LLDD decide to unload itself safely?
> 
> I did indeed type it wrong.  The code first calls scsi_remove_host(host)  
> and then it calls scsi_unregister(host).
> 

I probably should have looked at Matt's patch closer, sorry. If a LLDD is
going to be using scsi_add_host and scsi_remove_host the driver should
not use scsi_register_host / scsi_unregister_host. 

If the driver is updated to the sysfs driver model then:

	1.) The drivers probe routine should call into the scsi mid with.
		scsi_register(...);
		scsi_add_host(...);

	2.) The drivers remove routine should call into the scsi mid with.

		scsi_remove_host(...);
		scsi_unregister(...);

	(scsi_remove_host is part of this current discussion).

The event that calls probe / remove is the device_register /
device_unregister of the the adapter device.

The LLDD's device_initcall / module_exit routines will call
driver_register and driver_unregister to cause device to driver
binding. Which will cause probe / remove to be called.

-andmike
--
Michael Anderson
andmike@us.ibm.com

