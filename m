From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 11:37:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068748629.16444.58.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
	 <1068744259.13580.41.camel@patrh9>
	 <20031113100424.A26197@beaverton.ibm.com>
	 <1068747355.16444.22.camel@patrh9>  <1068747746.16444.30.camel@patrh9>
	 <1068747998.16444.35.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:46311 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264383AbTKMShq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 13:37:46 -0500
In-Reply-To: <1068747998.16444.35.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > How about we blacklist all the bInterfaceSubClass that Windows does not
> > regard as generic.  I remember Windows does regard bInterfaceSubClass =
> > x06 as generic.  I think I remember there are two others.
> 
> grep -i generic
> in windows/inf/usbstor.inf yields, hex:
> 
> 08 02 50
> 08 05 50
> 08 06 50
> 
> How about we [guess] disk writable
> [without risking mode sense]
> if we do not find bInterfaceSubClass in
> the set x 02 05 06?

In short:

Or how about we only blacklist mode sense from devices that report
bInterfaceSubClass = any of the x07..FF Reserved codes?  Surely a device
sending us a formally Reserved code is a good first clue that it may not
behave robustly thereafter?  Or maybe we just blacklist mode sense from
bInterfaceSubClass = xFF FormallyReservedButInformallyVendorSpecific? 
Surely a device sending us that code is an even better first clue that
it may not behave robustly thereafter?

At length ...

usb.org --> Developers --> Documents --> USB Device Class Specifications
--> Approved yields:

http://www.usb.org/developers/devclass_docs#approved

http://www.usb.org/developers/devclass_docs/usb_msc_overview_1.2.pdf

xpdf then shows, in page 6 of 7, "Table 2.1 - SubClass Codes Mapped to
Command Block Specifications"

x01..x06 = RBC SFF-CD/MMC QIC UFI SFF-FDD SCSI
x07..xFF = "Reserved for future use."

De facto practice says xFF = vendor-specific, by analogy with other
usb.org texts.

Blacklisting mode sense from all but 02 05 06, same as Windows, means
blacklisting all but QIC SFF-FDD SCSI.  Maybe uncomfortably aggressive.

> > Here we have bInterfaceSubClass = xFF ...
> > > That's this device TELLING US THIS DEVICE DOES NOT TALK SCSI.

By the way, kudos to Dmitri Katchalov for including USB descriptors in
the trace, rather than tracing only CDB's & data.

Pat LaVarre


