From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage -
	pass	larger receive buffer
Date: 13 Nov 2003 19:10:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068775834.2851.321.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:34299 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264488AbTKNCLG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:11:06 -0500
In-Reply-To: <1068768796.3fb41e1c8d075@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> * Define an absolute bare minimum safe subset of SCSI commands and 
> fall back to it whenever you see a non-compliant device like this one.

Did we find a kind of reset that worked with this device?

> Note that Win98 did not support my Sony Handycam Memory Stick out of 
> the box, I had to install drivers from Sony installation CD. 
> Obviously these drivers do not attempt to issue any commands that 
> the device does not understand. XP did detect Sony out of the box but 
> it is very likely that it still loaded proprietary Sony driver based 
> on USB Device/Vendor ID. 

I agree.

I guess this from seeing bInterfaceSubClass = xFF = Formally Reserved
But Informally Vendor Specific SCSI.  That pushes the bInterfaceClass
...SubClass ...Protocol outside of the tuples that Microsoft blesses as
generic usb storage i.e. outside of the set x 08 (02|05|06) 50.

> Also note: the device does not claim any SCSI compliance as indicated 
> by reserved values in its device descriptor and by scsi version being 
> set to 0 in reply to INQUIRY.

Aye.

> IMHO the solution is either or both of:
> * Blacklist it

Can we blacklist mode sense from bInterfaceSubClass = xFF?

That way we don't break as many write-protectable devices as if we
blacklisted mode sense always?

I remember today already I once proposed blacklisting only
bInterfaceSubClass = xFF, Matt said no once, I don't think I yet grok
Matt's no.

Can we blacklist only xFF if I wrote the patch myself?

I've shipped generic devices that I think comply: that gives me a
personal interest in having their write-protect work, no matter if
connected via USB.

Pat LaVarre

P.S.

> Also note: the device does not claim any SCSI compliance...
> miracle it worked at all.

Aye.  Myself, I'd like to get an academic grant to study why computers
work.  As far as I can tell, they shouldn't.  Fundamentally chaotic
design.  Try flipping a bit in an instruction stream, and watch what
happens.


