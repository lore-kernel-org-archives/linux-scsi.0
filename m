From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] check non-scsi part of status in
	scsi_status_is_good
Date: 30 Oct 2003 10:38:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067535485.6411.42.camel@pathost1.iomegacorp.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:2770 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262707AbTJ3RiV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 12:38:21 -0500
In-Reply-To: <20031030091808.A6781@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> Per your other post, in short change to use MODE SENSE page 8 all the
> time, even to get the write protect bit, and in addition use size 1c for
> 10 byte mode sense, and size 0x18 for the 6 byte variant.

Yes.

I mean to ask: does that alternative does more accurately emulate
Windows talk, and does that alternative therefore interoperate better.

> If we had a full set of borken devices or testers, we could make the
> change and know that it is well tested post 2.6.0.

Yes.

Me personally, I'm working remotely here, secondhand thru others.

I have not yet plugged any device of my own into sd.c that does not
work.  Bugs happen to me too, but I haven't yet suffered any bugs that
large.

I'm reasoning only from the email I see near here from other folk.  In
particular, the fsg usb gadget folk (led by Alan S I think) have lately
been teaching Linux to talk the device-side of SCSI over USB.  I think
they have been reporting Windows tries mode sense of page x08 for header
plus optional block descriptor plus whole page.  Somehow the fsg usb
gadget decides to cut that data short, perhaps by omitting the optional
block descriptor recommended by SPC but forbidden by MMC.

> > Not idiosyncratic, if in fact -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C
> > does work.
> 
> OK, I finally get it after re-reading your other posts. 

Sorry I was unclear.

> Where the heck does that "-y / -i" syntax come from?

A pet obsession of mine is how sd, sr, ide-cd, cdrom, etc. all say much
the same thing in ways that are only just barely binary incompatible.

http://members.aol.com/plscsi/
tries to resolve this at the command line with syntax like:
-x "5A 00 08:00:00:00 00 00:1C 00" -i x1C

http://members.aol.com/plscsi/tools/gccscsi/
tries to resolve this at the command line with syntax like:
-i x1C -y "5A 00 08:00:00:00 00 00:1C 00"

The gccscsi syntax has the virtue of corresponding directly with
compilable, yet concise (cryptic?), C code:

i(0x1C); y("5A 00 08:00:00:00 00 00:1C 00");

All those syntaxes have the advantage of appearing as plain hex, without
the noise of decimal and English, in particular without any bias in
favour of sd English or sr English or ide-cd English or cdrom English or
spc English or mmc English or ....

Work progresses, volunteers welcome.

Pat LaVarre


