From: Alan Stern <stern@rowland.harvard.edu>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Wed, 22 Jan 2014 14:59:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401221446370.1310-100000@iolanthe.rowland.org>
References: <20140122201924.01C70D33@centrum.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753116AbaAVT7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 14:59:18 -0500
In-Reply-To: <20140122201924.01C70D33@centrum.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, =?utf-8?q?USB_Storage_List?= <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 22 Jan 2014, Milan Svoboda wrote:

> Here is the usbmon log. The disk works with TV and Windows. No error messages.
> Could it be under-powered?

That's possible, but not if it works under Windows on the same 
computer.

The first reset occurred when the disk failed to respond correctly to a
GET WINDOW command:

> ffff8801fdbb2c00 2271440149 S Bo:3:004:2 -115 31 = 55534243 59000000 00020000 80001024 2480fe01 00000000 000000ec 000000
> ffff8801fdbb2c00 2271440171 C Bo:3:004:2 0 31 >
> ffff8800d19fd240 2271440179 S Bi:3:004:1 -115 512 <
> ffff8800d19fd240 2271444020 C Bi:3:004:1 -121 13 = 55534253 59000000 00000000 00
> ffff8801fdbb2c00 2271444044 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2278599765 C Bi:3:004:1 -104 0

It sent the status when it should have sent the data.  That's 
definitely a bug in the disk or its USB interface.

A bit later we see repeated attempts to read 8 blocks starting at
block 1250258607.  In the first attempt, the disk returned 8 blocks of 
data but sent an error status.  When asked for the error information, 
the disk sent "No Information":

> ffff8801fdbb2c00 2278816851 S Bo:3:004:2 -115 31 = 55534243 5d000000 00100000 80000a28 004a856e af000008 00000000 000000
> ffff8801fdbb2c00 2278816886 C Bo:3:004:2 0 31 >
> ffff8800c22c69c0 2278816911 S Bi:3:004:1 -115 4096 <
> ffff8800c22c69c0 2278817038 C Bi:3:004:1 0 4096 = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> ffff8801fdbb2c00 2278817085 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2289976173 C Bi:3:004:1 -32 0
> ffff8801fdbb2c00 2289976229 S Co:3:004:0 s 02 01 0000 0081 0000 0
> ffff8801fdbb2c00 2289976257 C Co:3:004:0 0 0
> ffff8801fdbb2c00 2289976273 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2289976335 C Bi:3:004:1 0 13 = 55534253 5d000000 00000000 01
> ffff8801fdbb2c00 2289976378 S Bo:3:004:2 -115 31 = 55534243 5e000000 12000000 80000603 00000012 00000000 00000000 000000
> ffff8801fdbb2c00 2289976419 C Bo:3:004:2 0 31 >
> ffff8800c0afccc0 2289976428 S Bi:3:004:1 -115 18 <
> ffff8800c0afccc0 2290123415 C Bi:3:004:1 0 18 = 70000000 0000000a 00000000 00000000 0000
> ffff8801fdbb2c00 2290123463 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2290123486 C Bi:3:004:1 0 13 = 55534253 5e000000 00000000 00

In the second attempt, the disk returned only 1 block of data, and 
again, no error information:

> ffff8801fdbb2c00 2290129737 S Bo:3:004:2 -115 31 = 55534243 5f000000 00100000 80000a28 004a856e af000008 00000000 000000
> ffff8801fdbb2c00 2290129782 C Bo:3:004:2 0 31 >
> ffff8800d4a51b40 2290129803 S Bi:3:004:1 -115 4096 <
> ffff8800d4a51b40 2301288990 C Bi:3:004:1 -32 512 = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> ffff8801fdbb2c00 2301289039 S Co:3:004:0 s 02 01 0000 0081 0000 0
> ffff8801fdbb2c00 2301289068 C Co:3:004:0 0 0
> ffff8801fdbb2c00 2301289086 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2301289153 C Bi:3:004:1 0 13 = 55534253 5f000000 00000000 01
> ffff8801fdbb2c00 2301289189 S Bo:3:004:2 -115 31 = 55534243 60000000 12000000 80000603 00000012 00000000 00000000 000000
> ffff8801fdbb2c00 2301289223 C Bo:3:004:2 0 31 >
> ffff8800d188c780 2301289263 S Bi:3:004:1 -115 18 <
> ffff8800d188c780 2301299693 C Bi:3:004:1 0 18 = 70000000 0000000a 00000000 00000000 0000
> ffff8801fdbb2c00 2301299741 S Bi:3:004:1 -115 13 <
> ffff8801fdbb2c00 2301299765 C Bi:3:004:1 0 13 = 55534253 60000000 00000000 00

This continued a few more times until the computer gave up.  Maybe
there is something wrong with one particular block at that address on
the disk.

Do you have a USB-2 port on the computer you can plug the disk into,
instead of USB-3?

Alan Stern

