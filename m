From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 14:37:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070573840.2269.43.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:54498 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263593AbTLDV5u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 16:57:50 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>

> As I understand it, the only real difference between the protocols is
> that everything but transparent scsi and RBC requires padding the
> commands to 12 bytes.

If we dig I believe we can unearth specific binary incompatibilities
among the de jure paper definitions of bInterfaceSubClass.

Me, I invented bInterfaceSubClass = x06 in 1998 to give my device a way
of reporting that I chose to perpetuate my employer's binary-code-only
legacy of an ANSI T10 SPC interpretation, rather than abandoning that
legacy in favour of the technically binary incompatible SFF proposal
which had not yet become ANSI T10 MMC.

For example, SFF/ MMC requires the device to zero the the byte 2 Version
of op x12 Inquiry data, SCSI-2/ SPC recommends nonzero.  SFF/ MMC
requires the device to exclude block descriptors from mode sense data,
SCSI-2/ SPC recommends inclusion.

Hopefully we will find SFF/ MMC never requires something SCSI-2/ SPC
actually forbids.

Hopefully we will find we only dig up insignificant incompatibilities.

I think I remember these binary incompatibilities didn't appear
officially incorporated into ANSI T10 until bleeding-edge T10 (= MMC 4,
trails SFF) i.e. may be absent from last stable T10 (= MMC 3).

Frustrates me that clueless folk repeatedly design pointless binary
incompatibility into competing SCSI definitions.  For example, the SFF
folk could have ducked the block descriptor issue by requiring the host
to set the standard mode sense cdb bit that disables block descriptors. 
Instead the SFF folk pointlessly chose to require the host and the
device to redefine what a zero bit there means.  I've heard the latest
SFF drafts try to patch up this mess somehow.

Truth or slander I do not know, but I've heard that the RBC folk messed
up legacy mode sense, and that some FireWire folk neglected to implement
legacy op x12 Inquiry (!!!).

Once upon a time, the usb.org bInterfaceSubClass = x06 specifications
very carefully referenced no specific de jure paper.  The original
English for x06 was something like "Windows, Linux, Mac, Sun SCSI".
People lost the sense of that by voting in the replacement text
"Transparent SCSI". In the time since, people may have polluted that
accurately pure description by linking to technically less than
completely accurate texts.

So far as I know, we have no executable specification of SCSI in open
source, unless you count Linux itself, which by being designed to work
consciously includes such redefining exceptions as the
US_FL_FIX_CAPACITY of drivers/usb/storage/unusual_devs.h.

Pat LaVarre


