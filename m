From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-starge not working in the latest kernel 2.4
Date: Mon, 1 Sep 2003 20:05:38 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309011106.UAA29067@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:31921 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S262821AbTIALG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2003 07:06:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>

Hi Alan,

Thank you for your replay.

A portion is omitted in the first half.

Haruo> usb-storage: bus_reset() called
Haruo> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
Haruo> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
Haruo> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
Haruo> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
Haruo> ehci_hcd 00:0c.2: port 1 high speed
Haruo> ehci_hcd 00:0c.2: GetStatus port 1 status 001005 POWER 
Haruo> sig=se0  PE CONNECT
Haruo> hub.c: port 1, portstatus 503, change 10, 480 Mb/s
Haruo> ehci_hcd 00:0c.2: devpath 1 ep0out 3strikes
Haruo> hub.c: USB device not accepting new address (error=-71)
 
Alan> This "not accepting new address" problem for ECHI was 
Alan> recently addressed  by a new patch.  See
Alan> http://sourceforge.net/mailarchive/message.php?msg_id=5927120
Alan> Maybe once that's fixed the error recovery will work better.

I think that this patch is related with usb reset.
If it goes through the transaction translator of a 2.0 hub, 
because after resetting the device, usb_reset_device() does a 
set_address(), but the ehci driver sends this to the device's previous 
address, when it's post-reset address is 0.
I will test using kernel 2.4.22-bk6.

Haruo> Please teach me how to analyze the root cause of this issue.
 
Alan> It's not easy to do.  Nothing special stands out.  
Alan> One small possibility 
Alan> is the length of the READ command where the error occurred: 
Alan> 129024 bytes.  
Alan> Check through earlier parts of the log and see if it contains 
Alan> successful 
Alan> READs or WRITEs for that much data.  Some devices have an 
Alan> upper limit on 
Alan> how much they can transfer in a single command and don't like 
Alan> it when that  limit is exceeded.

OK, I will think.

Alan> Did you said that the device works well when connected through a high
Alan> speed hub, but it fails when connected directly to the 
Alan> computer?

It seems that it stabilizes and operates 
when two devices are connected by high speed hub. 
However, it becomes an error in using only one device.
The high speed hub was used when using two devices.
In the case of one device, device connected the computer directly.

Thanks!!
Haruo
