From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 19:38:44 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304221738.h3MHciN16670.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:51624 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263272AbTDVR06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 13:26:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

Finally the third one is again of the kind 2.4 works, 2.5 fails.
So again, not a mysterious device but a software bug in
usb-storage and/or scsi/sd.

It looks different from the other two - the core is


Mar 30 15:42:12 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Mar 30 15:42:12 crusoe kernel: usb-storage:  00 00 00 00 00 00
Mar 30 15:42:12 crusoe kernel: usb-storage: usb_stor_ctrl_transfer(): rq=00 rqtype=21 value=0000 index=00 len=12
Mar 30 15:42:12 crusoe kernel: usb-storage: Status code -32; transferred 0/12
Mar 30 15:42:12 crusoe kernel: usb-storage: -- stall on control pipe
Mar 30 15:42:12 crusoe kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 3
Mar 30 15:42:12 crusoe kernel: usb-storage: -- transport indicates error, resetting
Mar 30 15:42:12 crusoe kernel: usb-storage: CB_reset() called


But I suppose nothing is wrong with the command TEST_UNIT_READY.
It is just that the device was not ready yet.
The successful 2.4 trace also has a failing TEST_UNIT_READY,
but itis followed by a successful one.

Mar 30 19:47:46 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Mar 30 19:47:46 crusoe kernel: usb-storage: 00 00 00 00 00 00 00 00 00 00 14 c0
Mar 30 19:47:46 crusoe kernel: usb-uhci.c: interrupt, status 2, frame# 1414
Mar 30 19:47:46 crusoe kernel: usb-storage: Call to usb_stor_control_msg() returned -32
Mar 30 19:47:46 crusoe kernel: usb-storage: -- Stall on control pipe. Clearing
Mar 30 19:47:46 crusoe kernel: usb-storage: usb_stor_clear_halt: result=0
...
Mar 30 19:47:46 crusoe kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Mar 30 19:47:46 crusoe kernel: usb-storage: 00 00 00 00 00 00 00 00 00 00 14 c0
Mar 30 19:47:46 crusoe kernel: usb-storage: Call to usb_stor_control_msg() returned 12


So, it looks like the bad part of 2.5 is that it asks for a reset.

Andries


