From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type
	storag edevices?
Date: 10 Mar 2004 13:58:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078952324.5156.266.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0403101515470.962-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:46781 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262820AbUCJVA5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 16:00:57 -0500
In-Reply-To: <Pine.LNX.4.44L0.0403101515470.962-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

> > I hear Windows starts with page x08, not x3F.
> 
> That's not so.  Windows 2000 asks for page x1C, then page x3F.  Windows XP 
> does the same and then asks for page x08.

Did we see Win fetch page x3F after finding page x1C?

> > > all pages (0x3F), but only 4 bytes.
> > 
> > SCSI Pass-Through Mode Sense Command May Crash the Computer
> > http://support.microsoft.com/?kbid=813908
> > 
> > suggests Talk-like-Windows excludes 4 bytes, by saying -i 4 -y "1A
> > xx:xx:xx 04 00" crashes the Win 2K kernel for much Atapi, just as -y "12
> > 00:00:00 00 00" crashes some lk for much Usb.
> 
> I don't think so.  That web page actually states that a bug in Windows' 
> atapi.sys storage port driver causes the crash and

Eh?  Why don't you "think so"?  What did I say that contradicts that
elaboration?

> an update is available to fix the problem.

Yes, but you mentioning this fact interests me greatly.

Can you concisely say why we care if an update is available for a
massively distributed Microsoft bug or no?  Personally I've never yet
understood why Microsoft bothered to write that Win 2K update. 
Microsoft already had shipped Win XP when it appeared.

> So it's no longer relevant.

Eh?  Relevance I still see includes:

a) Talk-SCSI-like-Windows probably doesn't include -i 4 -x "1A xx xx xx
04 00", even for the many significantly different test cases for which
we have not collected bus traces.

b) Device folk who test with net-disconnected labs full of gold Win 2K
are not sending -i 4 -x "1A xx xx xx 04 00" to their Atapi devices.

c) ...

Win 2K was and remains Massively Distributed, of course.

> In any case, 
> I'm proposing to always ask for 192 bytes (for USB devices).

Yes like Windows please.

> > > some devices hang if we ask for more than is available.
> > 
> > Also some hosts hang when D < H.
> 
> Not USB hosts.

No lk ever?

I know some hosts choke over the CSW stall that commonly distinguishes D
< H from D = H in BBB.  The detail of hang vs. fail doesn't always reach
me e.g. maybe I no longer accurately remember how lk rejected -y "12
00:00:00 00 00" Inquiry for zero.

> > Offline recently I received an as yet unconfirmed report that 2.4.25
> > ioctl CDROM_SEND_PACKET fails (but does not hang) when D < H.
> > 
> > > ... my devices ... work...
> > 
> > Yes, here we choose among evils.
> > 
> > If Windows doesn't discover PDT x00/0E writability except by trying to
> > write blocks, then any other technique we invent will fail to
> > interoperate broadly.
> 
> For PDT x00, Windows appears to use the same technique that we do: look at
> the header from a page x3F response.

Ah.  Maybe we can teach lk to properly distinguish my write-protected
PDT x00 disks.  Hmmm.

Pat LaVarre


