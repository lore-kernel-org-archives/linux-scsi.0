From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-starge not working in the latest kernel 2.4
Date: Fri, 29 Aug 2003 10:09:20 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0308290958190.824-100000@ida.rowland.org>
References: <200308290143.KAA00294@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:15364 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261230AbTH2OJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 10:09:21 -0400
In-Reply-To: <200308290143.KAA00294@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Fri, 29 Aug 2003, Tomita, Haruo wrote:

> Dear Alan,
> 
> I've tested usb-storage with the 2.6.0-test2-bk2 kernel version,
> It seems that 2.6 kernel version is stable. 
> However, 2.4 version is unstable.
> 
> The host  controller mPD270100 of NEC and VT6202 of VIA.
> When it tested in a high speed multihub, it operated about two weeks. 
> However, it became the following errors when the number of devices was one.
> I think that it is not failure of a device.
> Is it the problem of error handling?
> 
> This error was generated in the latest kernel 2.4.22.

> usb-storage: Attempting to get CSW...
> usb-storage: Bulk status result = 0
> usb-storage: Bulk status Sig 0x53425355 T 0x7862f7 R 0 Stat 0x0

The device worked here, reporting the status from the previous command.

> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.
> usb-storage: queuecommand() called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_10 (10 bytes)
> usb-storage: 28 00 00 02 e5 24 00 00 3f 00 00 00
> usb-storage: Bulk command S 0x43425355 T 0x7862f8 Trg 0 LUN 0 L 129024 F 128 CL 12
> usb-storage: command_abort() called

It stopped working here.  The driver tried to send the next command but 
the drive never acknowledged receiving it.

> usb-storage: Bulk command transfer result=-104
> usb-storage: -- transport indicates command was aborted
> usb-storage: Bulk reset requested
> usb_control/bulk_msg: timeout
> usb-storage: Bulk soft reset failed -110

After this point, no communication with the drive worked.  Eventually a 
USB port reset was tried:

> usb-storage: bus_reset() called
> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
> ehci_hcd 00:0c.2: port 1 high speed
> ehci_hcd 00:0c.2: GetStatus port 1 status 001005 POWER sig=se0  PE CONNECT
> hub.c: port 1, portstatus 503, change 10, 480 Mb/s
> ehci_hcd 00:0c.2: devpath 1 ep0out 3strikes
> hub.c: USB device not accepting new address (error=-71)

This "not accepting new address" problem for ECHI was recently addressed 
by a new patch.  See

http://sourceforge.net/mailarchive/message.php?msg_id=5927120

Maybe once that's fixed the error recovery will work better.

> Please teach me how to analyze the root cause of this isseu.

It's not easy to do.  Nothing special stands out.  One small possibility 
is the length of the READ command where the error occurred: 129024 bytes.  
Check through earlier parts of the log and see if it contains successful 
READs or WRITEs for that much data.  Some devices have an upper limit on 
how much they can transfer in a single command and don't like it when that 
limit is exceeded.

Did you said that the device works well when connected through a high
speed hub, but it fails when connected directly to the computer?  That's a 
big clue, but I don't know what it means.

Alan Stern

