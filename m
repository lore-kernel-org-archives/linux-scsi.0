From: Doug Ledford <dledford@redhat.com>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Ada
	pter
Date: Fri, 05 Nov 2004 23:20:20 -0500
Message-ID: <1099714821.10944.27.camel@compaq-rhel4.xsintricity.com>
References: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4>
	 <20041105203651.GA24690@parcelfarce.linux.theplanet.co.uk>
	 <418C105E.4040607@babut.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:61158 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261311AbUKFEUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 23:20:24 -0500
In-Reply-To: <418C105E.4040607@babut.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Babut <thomas@babut.net>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

On Sat, 2004-11-06 at 00:44 +0100, Thomas Babut wrote:

> None of the patches you posted solved my problems. I'm loosing hope... ;)

Well, having "been there, done that" many years ago when PPR messages
were first defined, here's the logic I found that worked in all cases:

OK, in the INQUIRY snoop area of the completion handler, I did the
appropriate card/device checks to determine if we should enable PPR:

if (bus_mode == LVD && sdev->scsi_level >= 3 &&
	host->user_transfer_settings >= MIN_DT_SPEED)
	use_ppr = 1;
else if (bus_mode == LVD && sdev->scsi_level < 3 && 
	(inquiry_len >= 57 && inq_data[56] & INQUIRY_DT_BIT) &&
	host->user_transfer_settings >= MIN_DT_SPEED)
	use_ppr = 1;
else
	use_sdtr_wdtr = 1;

In the event we set ppr on a device that can't handle it, I had to go
into the interrupt handler routine and in both the case of BUSFREE and
MSG_REJECT, if we were in the process of sending a ppr message and we
get either one of these in return, then turn off ppr messages for the
device (otherwise, we can get into an infinite loop were we accidentally
turned PPR on for a device that won't tolerate it for whatever reason,
and in fact once I know the ppr message has been rejected, the interrupt
handler would rewrite the ppr message into the closest possible
WDTR/SDTR message pair, assert ATNO on the bus to get us back in message
out phase, and proceed to go ahead and send the WDTR message, then wait
for a WDTR return, then assert ATNO again so we have a chance to do the
SDTR, then wait for the SDTR return, then proceed with the other
phases).

Finally, there are devices out there that do target initiated speed
negotiations.  If we get an incoming PPR message from a device, then you
are free to skip all those other checks in the INQUIRY snoop area and
just immediately set PPR on this device.  Now, you still need to do the
things like check that the bus is LVD before actually enabling LVD
speeds, but an unsolicited incoming PPR message is a dead giveaway that
the device supports PPR messages.  So, in the incoming message handling
portion of the interrupt handler, if we get an unsolicited PPR message
from a device, then we override any other settings we may have on the
device in terms of whether or not it supports PPR messages and we
disable the whole INQUIRY snoop operation for this device because we
don't want the INQUIRY snoop to disable PPR now that we know for a fact
that it's supported on this device.

Implement that, and you won't have these problems any more.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


