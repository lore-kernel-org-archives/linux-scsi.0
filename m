From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated
 SCSI hosts
Date: Tue, 22 Apr 2003 14:23:26 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304221413580.644-100000@ida.rowland.org>
References: <UTC200304221738.h3MHciN16670.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:17412 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263320AbTDVSLU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 14:11:20 -0400
In-Reply-To: <UTC200304221738.h3MHciN16670.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

On Tue, 22 Apr 2003 Andries.Brouwer@cwi.nl wrote:

> Finally the third one is again of the kind 2.4 works, 2.5 fails.
> So again, not a mysterious device but a software bug in
> usb-storage and/or scsi/sd.
> 
> It looks different from the other two - the core is
> 
> 
> Mar 30 15:42:12 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Mar 30 15:42:12 crusoe kernel: usb-storage:  00 00 00 00 00 00
> Mar 30 15:42:12 crusoe kernel: usb-storage: usb_stor_ctrl_transfer(): rq=00 rqtype=21 value=0000 index=00 len=12
> Mar 30 15:42:12 crusoe kernel: usb-storage: Status code -32; transferred 0/12
> Mar 30 15:42:12 crusoe kernel: usb-storage: -- stall on control pipe
> Mar 30 15:42:12 crusoe kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 3
> Mar 30 15:42:12 crusoe kernel: usb-storage: -- transport indicates error, resetting
> Mar 30 15:42:12 crusoe kernel: usb-storage: CB_reset() called
> 
> 
> But I suppose nothing is wrong with the command TEST_UNIT_READY.
> It is just that the device was not ready yet.
> The successful 2.4 trace also has a failing TEST_UNIT_READY,
> but itis followed by a successful one.
> 
> Mar 30 19:47:46 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Mar 30 19:47:46 crusoe kernel: usb-storage: 00 00 00 00 00 00 00 00 00 00 14 c0
> Mar 30 19:47:46 crusoe kernel: usb-uhci.c: interrupt, status 2, frame# 1414
> Mar 30 19:47:46 crusoe kernel: usb-storage: Call to usb_stor_control_msg() returned -32
> Mar 30 19:47:46 crusoe kernel: usb-storage: -- Stall on control pipe. Clearing
> Mar 30 19:47:46 crusoe kernel: usb-storage: usb_stor_clear_halt: result=0
> ...
> Mar 30 19:47:46 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Mar 30 19:47:46 crusoe kernel: usb-storage: 00 00 00 00 00 00 00 00 00 00 14 c0
> Mar 30 19:47:46 crusoe kernel: usb-storage: Call to usb_stor_control_msg() returned 12
> 
> 
> So, it looks like the bad part of 2.5 is that it asks for a reset.
> 
> Andries

I believe a recent patch addressed this problem.  I've lost track of the 
Bugzilla bug #'s, but the patch is documented as fixing bug #510: a STALL 
on a control endpoint isn't necessarily an error; it can indicate a 
command failure.  See drivers/usb/storage/transport.c rev 1.971.70.16:
<http://linux.bkbits.net:8080/linux-2.5/related/drivers/usb/storage/transport.c?nav=index.html|src/|src/drivers|src/drivers/usb|src/drivers/usb/storage>

Alan Stern

