From: Alan Stern <stern@rowland.harvard.edu>
Subject: Runtime PM for SCSI
Date: Thu, 18 Feb 2010 15:54:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002181529540.1269-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47530 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758484Ab0BRUyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2010 15:54:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, Kernel development list <linux-kernel@vger.kernel.org>

Developers have been receiving complaints about Linux's inability to
power-down card readers when they're not in use.  To address this issue
properly requires implementing runtime PM in the SCSI layer.  (For a
discussion of the current Runtime PM framework, see
Documentation/power/runtime_pm.txt.)

To begin with, it seems best to be safe: Don't suspend devices unless 
the device file is closed and there are no dirty buffers.  This last 
requirement arises because lots of USB card readers give spurious 
"Media may have changed" codes when resumed; if they had dirty buffers 
when suspended then the information would be lost.

Hence my first question: Can somebody tell me how to determine whether
a block device has any dirty buffers?  (And is there a particularly
good place in the SCSI layer or the block layer to test whether the
last dirty buffer has just been written out, or must this test be made
whenever a command completes?)

My second question: What are all the paths by which a command may be
added to the queue of a SCSI device whose file isn't open?  The
possibilities I'm aware of include:

	the sg driver (whose device file must itself be open);

	dirty-buffer writeback;

	the error handler thread;

	scsi_reset_provider().

Are there any others?

Alan Stern

