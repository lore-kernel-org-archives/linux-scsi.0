From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 15:58:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024225849.GG1563@beaverton.ibm.com>
References: <3DB84C9A.2030702@mvista.com> <200210242002.g9OK27W03864@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210242002.g9OK27W03864@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> sdake@mvista.com said:
> > I plan to produce a now patch that dumps the filesystem interface and
> > replaces it with driverfs files in /sys/bus/scsi.  These things take
> > time, but I hope to be  finished by October 25th. 
> 
> OK, that's good, thanks.
> 

A note here is that the SCSI device model still may need to be altered. I
am having issues of trying to fill out support and in looks like we
might have to restructure a few things. 

If the nodes are structure under your own directory they should be ok.

It makes a asymmetric interface, but some parameters can be applied on
removal by a cd to the correct leaf node.

Lock operations are somewhat simplified if we convert some of these
operations to the device model.

> There will be a point where for a large number of drivers, a linear scan even 
> in the kernel will be slower than a good DB lookup in userspace.
> 
> > Hotplugs on FibreChannel don't trigger "events".  What they can do is
> > LIP (loop initialization procedure) if the device has been configured
> > in it's SCSI code pages to  do such a thing.  Since this is device
> > specific I'd hate to rely on it for hotswap. 
> 
> They don't now, but they should.  The LIP protocol makes the FC driver aware 
> of the gain or loss of devices.  This should be communicated to the mid-layer 
> and then trigger a hotplug event.  Someone needs to write this, I was just 
> wondering if you might.

In switched FC fabrics you do receive SCNs if you have registered for
them which most adapters do. 

We already have interface support from the device model we just need to make the
calls.

-andmike
--
Michael Anderson
andmike@us.ibm.com

