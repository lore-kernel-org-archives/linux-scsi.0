From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Sat, 3 Feb 2007 20:29:23 -0500
Message-ID: <20070204012922.GA26450@animx.eu.org>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org> <20070203004201.GB25027@animx.eu.org> <23196A89-6820-4441-B4AE-199E04B5CF96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:44856 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXBDBaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Feb 2007 20:30:18 -0500
Content-Disposition: inline
In-Reply-To: <23196A89-6820-4441-B4AE-199E04B5CF96@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

Please keep me in CC, I'm not on the list.

Mark Rustad wrote:
> On Feb 2, 2007, at 6:42 PM, Wakko Warner wrote:
> >The PC is a suprtmicro x5da8 with an onboard dual channel AHA-39320  
> >u320
> >controller.  I have a dual channel AHA-39160 u160 and a dual channel
> >AHA-2940U/UW (ch0/internal is wide/narrow, ch1/externel is narrow).
> 
> I have used an x6-class Supermicro motherboard with the Adaptec u320  
> controller and I had problems hot-swapping drives with 2.6.18. It  

This wasn't about hot swapping in my case.  On the hot swapping thing, I've
never successfully done this with a 2.6 kernel.

> seemed that the bus reset that the backplane processor generated  
> caused trouble for the driver, killing the SCSI bus. 2.6.16 and  
> 2.6.17 locked up the kernel in the case of hot-swapping drives.

I have a scsi box that supports hot plug.  I had a drive failing and I
decided to just replace it, took down the entire bus and the raid array with
it, fortunately, nothing lost.  This was with the dual u160 card.

> I switched to 2.6.19.2 and things are better. I did find that a card  
> dump is produced when hot-inserting a drive, so it is way noisier  
> than I think it should be, but it continues to operate and life goes  
> on, which is much better behavior than 2.6.16, 2.6.17 or 2.6.18.

I've never bothered with the 2.6.x.x kernels.  Yet =)

> >I thought it was because I had option roms turned off, but when I  
> >turned
> >them on, it still has problems.  What's odd is the fact that if I  
> >boot with init=/bin/sh, modprobe aic7xxx, it works fine and I can  
> >exec init and it works fine.
> 
> I don't know what is up with that, but based on what I have seen I  
> would recommend using 2.6.19.x instead of 2.6.18 for systems using  
> the aic79xx driver.

As stated in the email, it was the aic7xxx driver.  I've never had problems
with the u320 driver that I recall since I've had this machine.  It appears
that when I load aic7xxx, it finds both channels of the u160 card and all
it's devices, then when it hits the 2940u/uw card, it loads the first
channel, all devices and crashes before it hits the 2nd channel.  It looked
like it had problems with the plextor cdrw thats on ID2.

But the odd thing is, if I boot to /bin/sh, insmod aic7xxx, and exec init,
everything's fine.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
