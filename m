From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: 28 Oct 2003 15:54:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067381663.11029.16.camel@patehci2>
References: <Pine.LNX.4.44L0.0310281724430.6912-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:47745 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261820AbTJ1Wyc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 17:54:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310281724430.6912-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

> Pat, I think maybe you're misunderstanding the reason behind this thread.  
> The device in question wasn't failing the MODE-SENSE(10) for page x08 
> (determine cache-type); it was failing the MODE-SENSE(10) for page x3F 
> (where only the first 4 bytes are read to determine write-enable).

That much I knew, thanks for finding the time to nak me.

> The code that does this is in 
> drivers/scsi/sd.c:sd_read_write_protect_flag().

Great link, thanks.  There now in -test9 I think I see:

We guess writable if need be, but we prefer to settle for:

sdkp->write_prot = ((data.device_specific & 0x80) != 0);

after the first command that works in the sequence:

sd_do_mode_sense(..., 0x3F, ..., 4, ...);
sd_do_mode_sense(..., 0, buffer, 4, ...);
sd_do_mode_sense(..., 0x3F, buffer, 255, ...);

I mean to suggest, ahead of these more creative (i.e. less friendly)
alternatives, in order to fetch that bit of header, we try a command
that more closely resembles the commands of the Talk Like Windows set,
e.g.:

sd_do_mode_sense(..., 0x08, ..., 4, ...);

I'm pleased to think I see sd.c sd_do_mode_sense via scsi_lib.c
__scsi_mode_sense will round up our header-only length of 4 to 8 when
using op x5A MODE_SENSE_10 rather than op x1A MODE_SENSE.

Furthermore, I believe we'd work better still if we fit our first try
completely into the Talk Like Windows command set.  My first glance at
__scsi_mode_sense says we don't reliably produce completely equivalent
op x5A MODE_SENSE_10 vs. op x1A MODE_SENSE.  This behaviour I recognise
from other hosts.

Me, I think the equivalent mode sense near here are:

-y "1A 00:08:00 18 00" -i x18 // x18 = 4 header + 8 block desc + xC page
-y "5A 00 08:00:00:00 00 00:1C 00" -i x1C // x1C = 8 header + ...

But I think if we try:

sd_do_mode_sense(..., 0x08, ..., 0x18, ...);

instead we get the inconsistent pair:

-y "1A 00:08:00 18 00" -i x18
-y "5A 00 08:00:00:00 00 00:18 00" -i x18 // four short of x1C wanted

And I think if we try:

sd_do_mode_sense(..., 0x08, ..., 0x1C, ...);

instead we get the inconsistent pair:

-y "1A 00:08:00 1C 00" -i x1C // four beyond of x18 wanted
-y "5A 00 08:00:00:00 00 00:1C 00" -i x1C

> ...

Am I yet more clear than mud?

Thank you for your patience.

Pat LaVarre


