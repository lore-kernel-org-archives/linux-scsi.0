From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Thu, 4 Dec 2003 15:59:58 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
References: <20031204184428.GA17116@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:15108 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263539AbTLDU77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2003 15:59:59 -0500
In-Reply-To: <20031204184428.GA17116@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 4 Dec 2003, Matthew Dharm wrote:

> Did the device advertise 'generic scsi' or one of the other protocol codes?
> 
> Microsoft has published information that indicates that they 'translate'
> the mode-sense commands into the 10-byte variants for everything bug
> 'transparent scsi' -- I think actually seeing that information would be
> necessary in constructing a new algorithm for Linux.
> 
> Matt

It was generic (transparent) scsi.

Perhaps I'll try implementing some of the other protocol codes in FSG,
maybe also the "removeable media" flag.  This would also require
implementing the PREVENT-ALLOW-MEDIUM-REMOVAL, READ-FORMAT-CAPACITIES, and
START-STOP, possibly also REZERO-UNIT, SEEK, READ(12), and WRITE(12).

(1).  Am I missing anything important?

(2).  Can I afford to leave out some of those?  The last four don't look 
very useful.

As I understand it, the only real difference between the protocols is that
everything but transparent scsi and RBC requires padding the commands to
12 bytes.  Pat LaVarre says that protocols x02 (SFF-8020i = CD/DVD) and
x05 (SFF-8070i = Removeable media, floppy) are the most important, since
they are the only other ones the generic Windows USB mass storage drivers
recognize.

Alan Stern

