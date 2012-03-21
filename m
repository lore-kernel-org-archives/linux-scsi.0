From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 21 Mar 2012 17:52:05 -0600
Message-ID: <201203211752.05576.thomas@fjellstrom.ca>
References: <201203211716.45418.thomas@fjellstrom.ca> <CAHtARFGL0ibTZ=ADOL+x4akVvF-d1LjWoqW-WAv8_AeX+O3RdA@mail.gmail.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:40446 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab2CUXwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2012 19:52:20 -0400
In-Reply-To: <CAHtARFGL0ibTZ=ADOL+x4akVvF-d1LjWoqW-WAv8_AeX+O3RdA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed Mar 21, 2012, adam radford wrote:
> On Wed, Mar 21, 2012 at 4:16 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> > I recently got an IBM M1015 (MegaRaid 9240-8i) card, and after getting a
> > new motherboard, the system now boots, but the megaraid_sas driver seems
> > to be getting stuck when trying to initialize the card.
> > 
> > Looking through the source, it seems to be stuck in the
> > megasas_adp_reset_gen2 function, in the while loop at the end. Now,
> > according to the code it can't actually get stuck there permanently, but
> > it does take quite a while for the loop to finish, and the udev timeout
> > messages to stop.
> > 
> > I've looked around quite a bit, but haven't found any solutions thus far.
> > If anyone could point me in the right direction I'd appreciate it.
> 
> If you are getting controller resets during driver load, you must not
> be getting interrupts or firmware is not responding to the inquiry
> roll-call.  Make sure you have the latest firmware.

I updated to the latest on LSI's site today before emailing. It changes the 
behavior slightly. With the older firmware, it would not print any of the 
initial reset messages, but would once udev decides to start killing modprobe. 
With the new firmware, I get a:

ADP_RESET_GEN2: HostDiag=a0

followed by a bunch of:

RESET_GEN2: retry=%x, hostdiag=a4

Now I'm not sure the hostdiag should be different between the two. if this aN 
identifier is similar to the aN identifiers in the MegaCli tool, then it would 
mean its trying to reset a device that doesn't exist? I only have a single 
M1015 card installed.
 
> The code at the end of megasas_adp_reset_gen2() just looks for
> DIAG_RESET_ADAPTER flag to clear on the host diag register when
> issuing a controller reset... that should happen almost immediately
> unless there is a hardware or firmware issue.
> 
> Are you sure your 'new' motherboard is actually good ?

It boots and runs fine without the sas card installed. I haven't run any heavy 
load tests, but it seems ok.

> Can you move your megaraid 9240-8i into a 'known working' system and
> re-test ?

Nope. This is the furthest I've gotten it to get with this card installed. The 
old system would fail to boot into grub properly, let alone linux. These cards 
seem to be /very/ picky about what motherboard you install them in.

> -Adam


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
