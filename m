From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-strage not working in the latest kernel 2.4
Date: Mon, 8 Sep 2003 15:42:29 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309081523200.665-100000@ida.rowland.org>
References: <3F5CA89B.8060003@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3076 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263525AbTIHTmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2003 15:42:35 -0400
In-Reply-To: <3F5CA89B.8060003@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Mon, 8 Sep 2003, David Brownell wrote:

> > It seems that a device does not answer in the case of kernel 2.4.
> > However, when operating by kernel 2.6 and two or more devices
> > are connected simultaneously, it operates. 
> > I cannot think the error of a device.
> 
> I'd almost agree, except that the device stops responding;
> and seems to stop responding to anything except (cases I've
> seen) that it'll accept more OUT packets ... maybe treating
> them as data to write to the disk (one hypothesis).
> 
> When a device stops responding, it's hard to think the
> problem is anything other than with the device.  (Though
> I still don't see where the storage class-specific reset
> gets sent by usb-storage, maybe that'd clean up better.)

The reset was sent three times.  Twice in response to command aborts and
once at the express request of the SCSI layer.  You can see it in the
logs:

usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 01 ce 22 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x93534f Trg 0 LUN 0 L 129024 F 128 CL 12
usb-storage: command_abort() called
usb-storage: Bulk command transfer result=-104
usb-storage: -- transport indicates command was aborted

Here's one:
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x935350 Trg 0 LUN 0 L 0 F 0 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: command_abort() called
usb-storage: -- transport indicates command was aborted

Here's another:
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.

Here's the third:
usb-storage: device_reset() called
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110

Those "Bulk reset requested" messages refer to the class-specific device 
reset command, not a clear-halt for a bulk pipe.

Alan Stern

