From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storag
 edevices?
Date: Wed, 10 Mar 2004 15:24:29 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403101515470.962-100000@ida.rowland.org>
References: <1078944795.5156.210.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9988 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262793AbUCJUYf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 15:24:35 -0500
In-Reply-To: <1078944795.5156.210.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On 10 Mar 2004, Pat LaVarre wrote:

> > * First attempt: ask for all pages (0x3F), ...
> 
> I hear Windows starts with page x08, not x3F.

That's not so.  Windows 2000 asks for page x1C, then page x3F.  Windows XP 
does the same and then asks for page x08.

> > all pages (0x3F), but only 4 bytes.
> 
> SCSI Pass-Through Mode Sense Command May Crash the Computer
> http://support.microsoft.com/?kbid=813908
> 
> suggests Talk-like-Windows excludes 4 bytes, by saying -i 4 -y "1A
> xx:xx:xx 04 00" crashes the Win 2K kernel for much Atapi, just as -y "12
> 00:00:00 00 00" crashes some lk for much Usb.

I don't think so.  That web page actually states that a bug in Windows' 
atapi.sys storage port driver causes the crash and that an update is 
available to fix the problem.  So it's no longer relevant.  In any case, 
I'm proposing to always ask for 192 bytes (for USB devices).

> > some devices hang if we ask for more than is available.
> 
> Also some hosts hang when D < H.

Not USB hosts.

> Offline recently I received an as yet unconfirmed report that 2.4.25
> ioctl CDROM_SEND_PACKET fails (but does not hang) when D < H.
> 
> > ... my devices ... work...
> 
> Yes, here we choose among evils.
> 
> If Windows doesn't discover PDT x00/0E writability except by trying to
> write blocks, then any other technique we invent will fail to
> interoperate broadly.

For PDT x00, Windows appears to use the same technique that we do: look at
the header from a page x3F response.

Alan Stern

