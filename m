From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 14:51:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C7D87.6050804@pacbell.net>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name>
 <20030117085047.GB2531@beaverton.ibm.com>
 <200301171155.36452.oliver@neukum.name>
 <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com>
 <3E2C5750.2040301@pacbell.net> <3E2C753B.3090805@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.247.72])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H9100HF9B61CS@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Mon, 20 Jan 2003 14:44:31 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:

> David, when I said ``... the transport will tell the LLDD that the
> device ...'' this is *exactly* what I meant.  You're just repeating
> it here in a more broken-down way.

OK


> By transport I mean USB, FC, SPI, etc; LLDD is the transport portal
> and the initiator (aka the initiator port).  This terminology is not
> really that new, but still not that old, and described in SAM-3.

I was hoping for something described in the 2.5.58 kernel docs,
which only talks about LLD (Documentation/scsi) except in one case
(looked like a typo) ... I remember SAM-3 as a kind of missile!



> We just cannot let a transport event just wipe out a device,
> without consulting hotplugging first -- think security.

Certainly "device gone" would be an auditable event, but this is
primarily an integrity issue:  don't free objects until other
components have stopped using them.

If any components attach security policies to that "gone" state
transition, that'd be atypical but purely their own business.
(Like a transport erasing session master keys ... most transports
wouldn't have them, and would likely erase them as soon as the
device is known to be gone, no hotplug involved.)


> That is, when a transport event takes place, the LLDD doesn't
> have to ``run to'' SCSI Core right away. Just let the kernel
> know about this event, and start returning errors, on newly
> queued commands.
> 
> The kernel will decide what to do about this device going away,
> i.e. hotplugging, sysop notification, etc.

Sounds right. Except that it'd normally be the SCSI core that
we "let" know about the event. (Not always, I can imagine that
some transports might be able to kick in recovery procedures
and find some other path for accessing the device.  But in
such cases, SCSI might never see the device as "gone" ... )

- Dave






