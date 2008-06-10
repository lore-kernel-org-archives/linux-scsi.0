From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 19:00:43 +0000
Message-ID: <200806101900.43572.chris2553@googlemail.com>
References: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
	<484D8019.3090900@s5r6.in-berlin.de>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <484D8019.3090900@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Monday 09 June 2008, Stefan Richter wrote:
> Alan Stern wrote:
> > In fact the log shows that the 30-second delay occurs in the middle of
> > ohci1394 (Firewire) initialization, not USB initialization:
> >
> > Jun  8 05:26:35 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI):
> > IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT
> > contexts=[4/8] Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0:
> > urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 Jun  8 05:26:35
> > upstairs kernel: hub 1-2:1.0: transfer --> -62
> > Jun  8 05:27:08 upstairs kernel: driver: '0000:02:0b.0': driver_bound:
> > bound to device 'ohci1394' Jun  8 05:27:08 upstairs kernel: bus: 'pci':
> > really_probe: bound device 0000:02:0b.0 to driver ohci1394
>
> The log at http://lkml.org/lkml/2008/6/6/317 shows two pauses.  One in
> the middle of USB related messages with no FireWire stuff around
> (17:25:19 to 17:25:44).  The other with parport, ieee1394, USB messages
> around it (17:25:44 to 17:26:31).
>
>  From there, the last 17:25:44 message is strange:  The device
> 00110666000013cc which is the controller is reported as being removed.
> Chris, did you do something at this point?

Ah sorry, that's a legacy of when I had considerably less ram than 2GB. I only 
use firewire on the rare occasion that I want to grab some video from my camera 
and I use the parallel port even less frequently. So one of the last things 
that happens in my rc.local init script is that I unload the related drivers.

>
> Also, in http://lkml.org/lkml/2008/6/1/2 you reported a patch which
> changes the SCSI core's interaction with the driver core as first bad
> commit.  Did you check that going before this commit removes _all_ the
> pauses, even those around USB or FireWire messages?  Or did you only
> check whether disk drives appear quickly?

When I was bisecting, I assessed good or bad based on whether I experienced the 
long pause during boot up. You may have seen my reply to James a short while 
ago that I have bisected again and arrived at the same patch.

Thanks,

Chris



-- 
Beauty is in the eye of the beerholder.

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
