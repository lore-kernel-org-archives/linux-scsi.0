From: James.Smart@Emulex.Com
Subject: RE: [PATCH] updated: suspending I/Os to a device
Date: Thu, 19 Aug 2004 14:24:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F172@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:759 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S267184AbUHSSYy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 14:24:54 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

All True...  and I'm not trying to belittle it.

The main things that sent me to the LLDD side were:

1) The number of timers that had to be running. A single cable pull can be handled by 1 timer in the LLDD, which will always be there. If there's a timer per device - and the config (still small) has 4-8 arrays, each array with 256 LUNs - this is a 1k/2k timers vs 1 scenario. A single device disappearance (a target) is a 256 (or more) vs 1 scenario. Not only the amount of resources for the timers, but also the complexity of when all these timers fire and the same time and start spitting i/o - which is not necessarily coordinated with the LLDD state change. Makes for a lot of fun error handling. I'd rather deal with an LLDD that misses an unblock (easy to spot) vs the race conditions that could occur due to the last point. Granted, this should all work, but its in a location that is typically much harder to test and reproduce.

2) Your update mandated that the LLDD provide the timer context, which also mandates something that is roughly a per-device structure for LLDD. To date, although very common, the interfaces had yet to dictate it. We have moved away from device structures (targets are all we really needed to manage).

The other items on cleanliness were gravy - and typically, the cleaner, the better.

I also took Christoph's comments to indicate this was a reasonable thing to do.

-- James



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Thursday, August 19, 2004 1:43 PM
> To: Smart, James
> Cc: SCSI Mailing List
> Subject: RE: [PATCH] updated: suspending I/Os to a device
> 
> 
> On Thu, 2004-08-19 at 13:24, James.Smart@Emulex.Com wrote:
> > The one con:
> >   Depends on well-behaved LLDD's to not leave the device 
> blocked indefinitely.
> >   But this is no different from scsi_block_requests().
> 
> But that's the big one.
> 
> A significant number of driver bugs have come to us from 
> incorrect timer
> handling (not understanding the difference between del_timer and
> del_timer_sync being the biggest).
> 
> The whole reason for moving the code up into the mid-layer is to avoid
> the LLD handling the timer.
> 
> After the rewrite to simplify the code, the added overhead of 
> having the
> mid-layer (and transport classes) do the timer is scarcely sevently
> lines longer than the one you currently attach.
> 
> James
> 
> 
> 
