From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 14:33:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070573602.2269.32.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:23435 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263528AbTLDVxz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 16:53:55 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> > From: Matthew Dharm ...
> >
> > Microsoft has published information that indicates that they
> > 'translate' the mode-sense commands into the 10-byte variants for
> > everything bug 'transparent scsi' -- I think actually seeing that
> > information would be necessary in constructing a new algorithm for
> > Linux.
> ...
> As I understand it, the only real difference between the protocols is that
> everything but transparent scsi and RBC requires padding the commands to
> 12 bytes.

diff vs. bInterfaceSubClass=x06 as sketched by MSFT is as follows.

---

From: http://www.microsoft.com/whdc/hwdev/bus/usb/usbfaq.mspx
...

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

Includes a plea I nutshell as { generic usb flash = x 08 06 50 }.

To make sense of this text we have to remember Linux usb-storage
"protocols" = usb.org bInterfaceSubClass != usb.org bInterfaceProtocol.

Pat LaVarre


