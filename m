From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Mon, 26 Jul 2004 00:32:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10407260026590.1977-100000@master.linux-ide.org>
References: <1090793440.1987.2.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-245.ca.astound.net ([64.85.224.245]:53006
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S264984AbUGZHsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 03:48:42 -0400
In-Reply-To: <1090793440.1987.2.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nathan Bryant <nbryant@optonline.net>, linux-scsi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>


Ben,

Remember to prevent suspend "BRAIN DAMAGE", scsi has host-hba
dma-queue-rings to manage.  I have thought about this for a while and have
considered a glass of scotch or two ease the pain.

SCSI != IDE

IDE is a simple child by comparison.

SCSI is painful because the hardware specifically prevents raw low-level
access to the bus-phase.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Sun, 25 Jul 2004, Benjamin Herrenschmidt wrote:

> On Sat, 2004-07-24 at 20:19, Nathan Bryant wrote:
> > Benjamin Herrenschmidt wrote:
> > 
> > > That's different, because the disks are actually registered as
> > > "struct device" childs of the bus, and thus get proper suspend/resume
> > > callbacks.
> > 
> > Ok, Seems like we rely on the BIOS a lot, here.
> 
> How so ? not at all !
> 
> > > Oh sure, the disks are in the loop, the problem happens with multipath
> > > and such which "breaks" the bus hiearchy somewhat. The queue management
> > > is part of the "functional" hierarchy (read: block layer) on top of
> > > SCSI disks, thus the disks will be the one getting the suspend callback,
> > > but they have to "notify" their functional parent (block layer, md, ...)
> > > to properly get the queues stopped.
> > 
> > All right, I can see where that's probably the easiest solution.
> > 
> > > IDE sort-of does that internally, by generating a special request that
> > > goes down the queue (in order to be properly ordered with whatever
> > > is pending in the queue, including pending tagged commands if any),
> > > and the "toplevel" IDE handling will stop processing the queue once
> > > that request got past, but it's a hackery that at this point is quite
> > > specific to drivers/ide/
> > 
> > The queued special command trick does mostly the same thing as the 
> > scsi_device_quiesce(), right? As far as I can tell, the only difference 
> > is that we attempt to drain the queue (and sometimes leave error 
> > handlers running) and they just pause it at some mostly sane stopping point.
> 
> I don't know, I have to look more closely at the SCSI code.
> 
> > Now correct me if I'm wrong, but it seems that with what we understand 
> > now, we are in a position that we could decide to make SCSI layer do the 
> > following on suspend, in this order:
> > 
> > scsi_device_quiesce();
> > { LLD pause and flush work; aic7xxx will run the completion queue at 
> > this point }
> > blk_stop_queue();
> > { LLD reset registers and shutdown, etc }
> > 
> > And once the MD problem is solved we will also need to do another call 
> > before blk_stop_queue().
> > 
> > Am I missing anything?
> 
> We need to issue the stuff from the low level driver (like aix7xxx) or
> the disk, that is sd, but we should make sure sg etc... also properly
> call the stuff, actually, look at IDE, I defined the special power
> request to act as a state machine once down the queue so the ide layer
> acts differently for disks, cdroms, etc... by sending appropriate
> commands like standby for disks.
> 
> Ben.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

