From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: Connecting same device through dual HBAs
Date: Thu, 01 Apr 2004 10:09:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080835758.5300.8.camel@localhost.localdomain>
References: <opr5r84tfarfijrn@smtp.hotpop.com>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:44219 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S262932AbUDAQJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 11:09:29 -0500
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVI003BT27IST@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 01 Apr 2004 11:09:27 -0500 (EST)
In-reply-to: <opr5r84tfarfijrn@smtp.hotpop.com>
List-Id: linux-scsi@vger.kernel.org
To: Christopher Campise <campise@hotpop.com>
Cc: linux-scsi@vger.kernel.org

Chris,

Some additional info may be needed here.  If the 2 SCSI cards are
connected to the same array, they may have a SCSI ID conflict.

It sounds as if the array that you have attached has two SCSI
interfaces.  Are you sure that this is not a pass-through for daisy
chaining multiple units?  If it is, then the 2 cards and the array are
all on the same SCSI bus.

The end result is a multi initiator situation.  Check to see if the SCSI
ID of one of the HBA cards can be altered.

Another thing to do for testing, is disconnect one of the cards from the
array (power everything down first lest you blow the TERM PWR fuse). 
Check the system again.  What SCSI ID do you get for the array and for
the card.

Power down, re-connect the one card, disconnecting the tested card and
do the same test, noting the IDs.

Do not connect each card to the same SCSI port on the array.  We are
also looking to see if the two ports report identical SCSI IDs.

If the IDs are identical each time, then there will be a conflict that
will need resolving.

Good luck.

Matt

----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884

On Thu, 2004-04-01 at 08:56, Christopher Campise wrote: 
> Hello Everyone-
> 
> First time caller here. :)
> 
> I'm currently running a Redhat9.0 setup with kernel 2.4.20-8.  I wish to 
> connect to a scsi external storage array, that has two interface cards, 
> via two Host Bus Adapters on my linux box (in an attempt to increase 
> throughput).
> 
> I'm using the stock qla2300 drivers and can see both cards when I do a 
> 'cat /proc/scsi/scsi' but I've only been able to see the array (and it's 
> associated LUNs) through one HBA though.  I've done some research and came 
> across the multipath concept and being not entirely sure of what it is, 
> was wondering if this is the direction I should continue to pursue in 
> order to accomplish this?  Or, if not, does anyone have advice as to what 
> I need to do to get this to work (if at all possible)?
> 
> Thanks in advance!
> 
> Chris
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


