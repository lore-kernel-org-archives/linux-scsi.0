From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Problem with external USB2.0 case and LG GSA
 4040-B
Date: Mon, 15 Dec 2003 15:49:42 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312151529160.895-100000@ida.rowland.org>
References: <200312132137.18128.cornelius.claussen@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:28932 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263904AbTLOUtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 15:49:43 -0500
In-Reply-To: <200312132137.18128.cornelius.claussen@gmx.de>
List-Id: linux-scsi@vger.kernel.org
To: Cornelius Claussen <cornelius.claussen@gmx.de>, Patrick Mansfield <patmans@us.ibm.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Patrick:

Cornelius Claussen reported the following problem with error recovery in
2.6.0-test11.  His device is one of those problem-prone Genesys Logic
units, a USB DVD drive.  The complete message and log can be found at

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=107134787817252&w=2

Here's a condensed and annotated version of his log:

usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 00 00 b6 91 00 00 2e 00
usb-storage: Status code -75; transferred 68096/94208
usb-storage: -- babble
usb-storage: -- transport indicates error, resetting
usb-storage: Soft reset done
usb-storage: scsi cmd done, result=0x70000

The device messed up; to recover we had to send it a soft reset command.
The scmd->result code was DID_ERROR << 16.  The SCSI layer retried the 
command:

usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 00 00 b6 91 00 00 2e 00
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
usb-storage: Unit Attention: Power on, reset, or bus device reset occurred
usb-storage: scsi cmd done, result=0x2

The device reported the reset via Unit Attention.  The scmd->result code
was SAM_STAT_CHECK_CONDITION.  Presumably another retry at this point
would have worked.  Instead he got...

end_request: I/O error, dev sr1, sector 186948
Buffer I/O error on device sr1, logical block 46737
Buffer I/O error on device sr1, logical block 46738
etc.

In fact, another READ command queued shortly afterward,

usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 00 00 b6 bf 00 00 3c 00
usb-storage: Bulk Status S 0x53425355 T 0xec9 R 2048 Stat 0x0
usb-storage: scsi cmd done, result=0x0

succeeded, albeit with a residue of 2048.  But by then it was too late, 
the original request had failed.

What's the right way to fix this?

Alan Stern


