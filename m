From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage -
	pass	larger receive buffer
Date: 13 Nov 2003 19:02:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068775342.2851.307.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <20031113171300.F30194@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:11426 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264484AbTKNCCy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:02:54 -0500
In-Reply-To: <20031113171300.F30194@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, ronald@kuetemeier.com, idan@idanso.dyndns.org, dmitrik@users.sourceforge.net, stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com

> From: Matthew Dharm ...
> How about:
> 	* Define an absolute bare minimum safe
>         subset of SCSI commands and use only
>         those commands when communicating with
>         a USB device
> ...
> a varient of blacklisting ... I like ...

Yes please, me too.

> From: Matthew Dharm ...
> I suggested something like this a while ago --
> if the emulated flag was set, certain commands
> were not sent.  Linus didn't like that, but I
> think he objected more to the 'emulated' flag
> than anything else.

Urgh.  What am I missing?

Minimum mostly safe subset works better.  Right?

Not just with SCSI over USB.  So likewise with SCSI over IDE (aka ATAPI)
and SCSI over 1394/ FireWire/ iLink (aka SBP2 Normative Annex B). 
Right?

I'm hoping we will discover for PDT x00 HDD/Flash the minimum mostly
safe subset includes such as that (transcribed-by-hand from CATC USB
Advisor) trace of Win XP SP1 once upon a time with a particular sample
device while disc absent:

> -i xC0 -y "1A 00:1C:00 C0 00" // Mode Sense (6)
> -i xC0 -y "1A 00:3F:00 C0 00" // Mode Sense (6)
> -i x0C -y "1A 00:00:00 0C 00" // Mode Sense (6)
> -i x0C -y "1A 00:3F:00 0C 00" // Mode Sense (6)

I'm not sure how Win translates to MMC op x5A GPCMD_MODE_SENSE_10 from
the SPC op x1A MODE_SENSE 6 of Win SCSI.

To be sure we'd have to trace something other than an x 08 06 50 device
(= Mass Storage, Transparent SCSI, BBB)

I'm thinking I remember seeing the length either doesn't change or else
adds four to account for the growth to 8 byte header from 4 byte header
i.e. either:

-p -i xC0 -y "5A 00 1C:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
-p -i xC0 -y "5A 00 3F:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
-p -i x0C -y "5A 00 00:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
-p -i x0C -y "5A 00 3F:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)

or else:

-p -i xC4 -y "5A 00 1C:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
-p -i xC4 -y "5A 00 3F:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
-p -i x10 -y "5A 00 00:00:00:00 00 00:10 00 00:00" // Mode Sense (10)
-p -i x10 -y "5A 00 3F:00:00:00 00 00:10 00 00:00" // Mode Sense (10)

Pat LaVarre


