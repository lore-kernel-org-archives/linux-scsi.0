From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 6 Sep 2012 14:50:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
References: <1670507.4ddqykZP6b@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1670507.4ddqykZP6b@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 6 Sep 2012, Oliver Neukum wrote:

> > > > But in the long run that wouldn't be a good solution.  What I'd really 
> > > > like is a way to do the status polling without having it reset the 
> > > > idle timer.
> > > > 
> > > > Oliver, what do you think?  Would that be a good solution?
> > > 
> > > Well, we could introduce a flag into the requests for the polls.
> > > But best would be to simply declare a device immediately idle
> > > as soon as we learn that it has no medium. No special casing
> > > would be needed.
> > 
> > We could do that, but what about idle drives that do have media?
> 
> Then we do have a problem. To handle this optimally we'd have to make
> a difference between the first time a new medium is noticed and later
> polls.

That's right.  It shouldn't be too difficult to accomplish.

One case to watch out for is a ZPODD with no media and an open door.  
We should put the drive into runtime suspend immediately, but continue
polling and leave the power on.  The runtime suspend after each poll
will to see if the door is shut; when it is then polling can be turned
off and power removed.

This leads to a question: How should the sr device tell its parent 
whether or not to turn off the power?  Aaron's current patches simply 
rely on the device being runtime suspended, but that won't work with 
this scheme.  Do we need a "ready_to_power_down" flag?

Alan Stern

