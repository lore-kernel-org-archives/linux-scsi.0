From: Christian Grigis <glove@earthling.net>
Subject: BusLogic error handling in kernel 2.6
Date: Thu, 4 Sep 2003 13:57:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904115709.GA29956@mooch.dyndns.org>
Reply-To: glove@earthling.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail6.bluewin.ch ([195.186.4.229]:45520 "EHLO mail6.bluewin.ch")
	by vger.kernel.org with ESMTP id S264933AbTIDL5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2003 07:57:15 -0400
Received: from localhost (62.203.115.141) by mail6.bluewin.ch (Bluewin AG 7.0.020)
        id 3F57071200004549 for linux-scsi@vger.kernel.org; Thu, 4 Sep 2003 11:57:14 +0000
Received: from glove by localhost with local (Exim 3.36 #1 (Debian))
	id 19usjd-00014x-00
	for <linux-scsi@vger.kernel.org>; Thu, 04 Sep 2003 13:57:09 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have been using a BusLogic BT-958 SCSI host adapter on my machine for
a long time, and I recently tried to boot a 2.6 kernel (-test4). In the
kernel boot logs, I get the following messages:

(...)
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
ERROR: SCSI host `BusLogic' has no error handling
ERROR: This is not a safe way to run your SCSI host
ERROR: The error handling must be added to this driver
Call Trace:
 [<c020ebf1>] scsi_host_alloc+0x271/0x280
 [<c01a1e87>] vsprintf+0x27/0x30
 [<c0219546>] BusLogic_Message+0xa6/0x1a0
 [<c020ec1f>] scsi_register+0x1f/0x70
 [<c037f8c5>] BusLogic_DetectHostAdapter+0x1d5/0x360
 [<c037fa50>] BusLogic_ReleaseHostAdapter+0x0/0x50
 [<c03803ae>] init_this_scsi_driver+0x3e/0x100
 [<c036a73b>] do_initcalls+0x2b/0xa0
 [<c0126d2f>] init_workqueues+0xf/0x60
 [<c010506b>] init+0x2b/0x180
 [<c0105040>] init+0x0/0x180
 [<c0106ff5>] kernel_thread_helper+0x5/0x10

scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0xDC00, IRQ Channel: 10/Level
scsi0:   PCI Bus: 0, Device: 11, Address: 0xD6000000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: UUUUUUU#UFFFFFFU, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0:   Error Recovery Strategy: Default, SCSI Bus Reset: Enabled
scsi0:   SCSI Bus Termination: High Enabled, SCAM: Enabled, Level 1
scsi0: *** BusLogic BT-958 Initialized Successfully ***
(...)

I did some research about it, and even though I could see some mentioning
of the same problem, I could not find direct answers.

My understanding is that the SCSI error handling functions have changed
in 2.6, and that the BusLogic driver has not yet been converted to use
the new approach. Is that correct?

Is anyone currently working, or planning to work, on this, for this adapter?

If not, I would be glad to contribute my help, within the realm of
possibilities; could anyone give me some pointers as to where I should
start?

Thank you very much, and best regards!

-Christian
