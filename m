From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 19:24:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068776681.2851.336.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068766632.2851.142.camel@patrh9>
	 <20031113162401.A29775@beaverton.ibm.com>
	 <1068774856.2851.259.camel@patrh9>
	 <20031113180837.H30194@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:33532 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264495AbTKNCZO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:25:14 -0500
In-Reply-To: <20031113180837.H30194@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, patmans@us.ibm.com, stern@rowland.harvard.edu, james.bottomley@steeleye.com, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> From: Matthew Dharm ...

All clear now thanks, sorry I was slow.

> > > > If we check after the open for a write failure
> > > > to read only media, we cannot keep the same
> > > > open semantics (return EROFS on open).
> > 
> > Without mode sense, we will see the open for write pass thru, and we
> > will have to teach the fs (ext3, fat, fat32, udf, ...) to recover
> > gracefully from a late write error, yes?
> 
> This should already be in place.

In place by now in kernel but not yet above?

I will try 2.6.0-test9.  Me, I thought when last I tried something like
this I saw dd finish without error while the dmesg filled with
complaints.

> > If we eat those commands, how then can write-protect work in Linux for
> > that rare case of an actually compliant device with a write-protectab;e
> > disk (like the device firmware I remember shipping myself 1994..2003)?
> 
> Presumeably, when the send a WRITE command to the device, it will refuse
> with meaningful sense data.

Works for SCSI transports that support the Dn < Ho case of the thirteen
cases, aye.  Fun to see that trace showing Win XP SP1 requiring certain
Dn < Hi and Di < Hi to work.

> ...

I will report back (many hours from now) after next I can try what I
think Patrick M suggested for letting writable open of read-only sd pass
thru:

echo "$vendor:$model:0x4000" > /proc/scsi/device_info

(I'll try this with sr too, just in case it works.)

Pat LaVarre


