From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type
	storage de vices?
Date: 08 Mar 2004 10:55:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078768520.2341.54.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:33533 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262664AbUCHR51
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2004 12:57:27 -0500
In-Reply-To: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

> On a related note, we've run across reports from several users
> indicating that their USB devices die when handed a PREVENT-ALLOW
> MEDIUM REMOVAL command, even though they set the Removable-Medium flag
> in their INQUIRY data.  Could there be a device flag that would cause
> the sd driver to avoid these commands?

I hear op x1E Prevent/ Allow appears in Windows bus traces.

I wonder what cbw/ sequence avoids killing such devices for Windows.

> Windows uses MODE SENSE(6) for Transparent Scsi (USB SubClass =
> 0x06) and MODE SENSE(10) for everything else -- according to Pat LaVarre
> anyway, and it agrees with the trace data.  (MODE SELECT is treated the
> same way, but that's irrelevant for our purposes.)

(-: I doubt I ever said anything so easily understood. :-)

More precisely I imagine I actually have said that my limited experience
of ATAPI & USB Windows bus traces confirms the published portions of
Microsoft's host-vendor-specific definition of USB Mass
bInterfaceSubClass x06, in particular:

--- http://www.google.com/search?q=microsoft+design+usb
---
--- second hit today
--- http://www.microsoft.com/whdc/hwdev/bus/USB/default.mspx
---
--- FAQ for USB Storage Support in Windows
--- http://www.microsoft.com/whdc/hwdev/bus/usb/usbfaq.mspx

Usbstor.sys and Device Class Support
Q: Which device classes does usbstor.sys understand?
In Windows XP, Windows 2000, and Windows Me, usbstor.sys makes only one
distinction: 

bInterfaceSubClass == 06h 
- OR - 
bInterfaceSubClass != 06h 

The value bInterfaceSubClass == 06h means that:

Command descriptor blocks (CDBs) should not be padded to 12 bytes.

Mode Sense / Mode Select commands should not be translated from 1AH /
15h to 5AH / 55h.

Subclass 0x06 should generally be used for flash memory devices.

The value bInterfaceSubClass != 06h means that:

CDBs should be padded to 12 bytes.

Mode Sense / Mode Select commands should be translated from 1AH / 15h to
5AH / 55h.

---

Pat LaVarre

P.S.

I wonder if our collected Windows USB Mass traces show that t10.org SBC
neglects to emphasise op x23 is HOST-vendor-specific.

P.P.S.

If we choose to teach Linux to talk more like Windows here, then of
course I hope we still allow ioctl SG_IO, CDROM_SEND_PACKET, etc. to
pass SCSI thru transparently, especially to bInterfaceSubClass x06.

I remember thinking in/correctly that devices of
drivers/usb/storage/unusual_devs.h connect transparently only with a
patched kernel.


