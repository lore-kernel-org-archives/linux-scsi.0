From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] oops in sd_shutdown
Date: Tue, 12 Aug 2003 17:24:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030813002450.GA8712@beaverton.ibm.com>
References: <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher> <20030812002844.B1353@pclin040.win.tue.nl> <20030812075353.A18547@infradead.org> <20030812213549.GA2158@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030812213549.GA2158@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andries Brouwer <aebr@win.tue.nl>, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Greg KH [greg@kroah.com] wrote:
> On Tue, Aug 12, 2003 at 07:53:53AM +0100, Christoph Hellwig wrote:
> > On Tue, Aug 12, 2003 at 12:28:44AM +0200, Andries Brouwer wrote:
> > > I see an Oops in the SCSI code, caused by the fact that sdkp is NULL
> > > in sd_shutdown. "How can that be?", you will ask - dev->driver_data was set
> > > in sd_probe. But in my case sd_probe never finished. An insmod usb-storage
> > > hangs forever, or at least for more than six hours, giving ample opportunity
> > > to observe this race between sd_probe and sd_shutdown.
> > > (Of course sd_probe hangs in sd_revalidate disk.)
> > 
> > Well, this same problem could show upb in any other driver.  Could
> > you instead send a patch to Pat that the driver model never calls
> > the shutdown method for a driver that hasn't finished ->probe?
> 
> I think it already will not do that due to taking the bus->subsys.rwsem
> before calling either probe() or remove().
> 

Is the shutdown being called directly? The shutdown call is protected by
a different rwsem. Depending on the call graph setting dev->driver on
return of probe may provide a solution. I have not looked at all probe
routines to understand if this would cause any bad side effects.

Andries,
	Can you send the oops output?

-andmike
--
Michael Anderson
andmike@us.ibm.com
