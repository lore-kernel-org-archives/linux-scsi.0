From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 3 Oct 2002 18:40:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10210031840.ZM119812@classic.engr.sgi.com>
References: <200210031246.g93CkLF02116@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: James Bottomley <James.Bottomley@steeleye.com>
        "Re: PATCH: scsi device queue depth adjustability patch" (Oct  3,  8:46am)
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Oct 3,  8:46am, James Bottomley wrote:
> 
> > The mid layer simply does not have access to the info needed to do
> > what  you are talking about.  Let me give you an example from the
> > aic7xxx  driver.  On this card we have a sequencer that handles the
> [...]
> > how we avoid the random flip flops of queue depth that you were
> > worried about earlier. 
> 
> Yes, many HBAs have internal "issue" queues where commands wait before being 
> placed on the bus.  I was assuming, however, that when a HBA driver got QUEUE 
> FULL, it would traverse the issue queue and respond QUEUE FULL also to all 
> pending commands for that device.  The mid-layer should thus see a succession 
> of QUEUE FULLs for the device (we even have a nice signature for this because 
> the QUEUE FULL occurs while device_blocked is set).  However, as long as it 
> can correctly recognise this, it knows that when the last QUEUE FULL is 
> through it has the true device queue depth, doesn't it?

The Qlogic host adapters do not provide a way to find the true queue depth
to the device as described previously by Doug.  The midlayer depth is
probably about as accurate as you could get, with the exception being
if the Qlogic driver runs out of IOCBs.  I don't believe that they return
Queue Full for unsubmitted commands, but I do not know for sure.  I certainly
would not expect every host adapter to do that.

That was one of the holes in the Ordered Tag scheme.  You issue a bunch
of unordered commands, then an ordered one, followed by a bunch of unordered.

If the ordered tag gets the Queue Full, and you are depending on the
Ordered semantics, you're in Big Trouble.

jeremy
