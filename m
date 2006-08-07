From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Don't add scsi_device for devices that return PQ=1,
 PDT=0x1f
Date: Mon, 7 Aug 2006 10:45:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608071023010.6836-100000@iolanthe.rowland.org>
References: <44D6D79E.3020304@netapp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:31241 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750960AbWHGOpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 10:45:07 -0400
In-Reply-To: <44D6D79E.3020304@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Wysochanski <davidw@netapp.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Christoph Hellwig <hch@lst.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>, michaelc@cs.wisc.edu, SCSI development list <linux-scsi@vger.kernel.org>, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, "Nair, Vinod K" <nvinod@netapp.com>

On Mon, 7 Aug 2006, Dave Wysochanski wrote:

> > If you look at scsi_probe_and_add_lun in current mainline we already
> > have a check for PDT=0x1f, keyed of a blacklist flag in the scsi target.
> > The comment above it says it's for USB UFI.  It's missing the PQ=1
> > check, though.  Can you reassure with the USB storage people that USB
> > UFI indeed sets that periphal qualifier aswell (I'd guess so as IIRC
> > that standard references SPC).  If that's the case replace that check
> > with your version and remove the target flag.
> > 
> Yeah, I saw that.  If you look at that patch description from Alan, he
> states the PQ=0 for these devices:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113951679626087&w=2
> 
> Unfortunately USB UFI 1.0 spec has "reserved" where the PQ bits normally are,
> so maybe that's why there's only a check for PDT=0x1f?  Alan or someone
> from the usb-storage list, can you confirm this is correct (PQ really
> "reserved" is 0 for the USB UFI devices)?  I thought I had a USB floppy
> lying around but no luck.

I don't have any UFI devices, but Matt Dharm probably does.  Maybe he can
verify this.

Although I've lost track of the original email thread leading to that 
patch, it seems clear that there never would have been a problem if the 
UFI device in question had set PQ=3.  Since the UFI spec really does say 
that those bits are reserved and should be set to 0, it's reasonable to 
assume that lots of UFI devices will do just that.

> Also, it does not look like pdt_1f_for_no_lun flag Alan added is used.
> Alan do you intend on submitting the patch to the USB slave_alloc() function
> as you mentioned?

You know, that was half a year ago and it simply slipped my mind.  Partly 
because I never know when James accepts one of my patches.  But yes, now 
that it's there I will add appropriate code to usb-storage.

> I'm not sure Alan's pdt_1f_for_no_lun flag should be used in my case,
> since I would want to set it based on vid/pid - most appropriate in
> scsi_get_device_flags() - and he wanted to set it in slave_alloc().
> Maybe setting it in 2 different places for different devices is ok
> though - your call.

I don't see any problem with setting the flag from two different places.  
We already do the same sort of thing with other flags.  It doesn't matter
_where_ the flag gets set; all that matters is that it _is_ set during the
scanning.

Alan Stern

