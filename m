From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 14 Nov 2003 14:45:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068846339.3277.13.camel@patrh9>
References: <20031112155029.A20986@beaverton.ibm.com>
	 <3FB4379D.3060708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:31905 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264437AbTKNVqQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 16:46:16 -0500
In-Reply-To: <3FB4379D.3060708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > .../drivers/scsi/scsi_lib.c
> ...
> SPC-3 section 6.25 (REQUEST SENSE command) [spc3r15.pdf]
> says the maximum allocation length should be 252 (not
> 255). They are steering alway from odd numbers and preferring
> the next lower modulo 4 number.
> ...
> sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
> ...
> dito

Intriguing, thank you.

I see you quote that 252 = xFC but then I resist these implications as
follows:

1)

While focused in sd, I apply t10 SPC only to ops like x 03 1A.  I favour
the slightly binary incompatible, competing definitions of t10 MMC for
ops like x 12 5A.

2)

xC0 may often be Windows max for GPCMD_MODE_SENSE_10.

When the actual available max is larger, choosing xC0 rather than xFC
will produce aligned results on 64-bit (and on 128-bit) hardware.

By contrast we see aligned only for 32-bit hardware at the data of a
standard -i x24 -y "12 00:00:00 24 00" Inquiry does, and we see aligned
only for 64-bit hardware at the data of a standard -i 8 -y "25 00
00:00:00:00 00 00:00 00" Read Capacity.

I hope already we always have bothered to allot only whole machine words
for SCSI data.  Then transports that round up to the next aligned
boundary can't hurt us.

3)

Win XP/2K max for x03 GPCMD_REQUEST_SENSE often is x12.  Win ME/9X often
is x0E.  We might work better if we pushed an aligned-to-32-bit standard
like x18 or x10, or we might work worse.

I can't easily know.  Anybody else on Earth care?

Pat LaVarre


