From: Alan Stern <stern@rowland.harvard.edu>
Subject: Device flags: use_10_for_rw and use_10_for_ms
Date: Mon, 28 Nov 2005 16:43:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511281626460.4796-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37280 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751311AbVK1VnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:43:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Patrick and James:

There are a couple of problems with the implementation of the 
use_10_for_rw and use_10_for_ms flags.

The easy problem is that use_10_for_rw is implemented twice: once in 
sd.c:sd_rw_intr and once in scsi_lib.c:scsi_io_completion.  The obvious 
fix is to remove of them.  Since scsi_io_completion is more general, it 
makes sense to leave the code there and remove it from sd.c.

The hard problem is that sometimes devices return an ILLEGAL_REQUEST sense
key when they shouldn't.  I posted an example a week or two ago; what
happened was the use_10_for_rw flag got turned off and from then on only
6-byte commands were used (and of course the device failed to recognize
them).

Clearly we need a mechanism for going the other way: when a 6-byte command 
gets ILLEGAL_REQUEST sense, turn the use_10_for_xxx flag back on.  The 
difficulty is that this will cause an infinite retry loop if the device 
doesn't like either form of the command.

Is there a standard way to limit the number of retries for these cases in 
scsi_io_completion?  The code pathway involves getting rid of the 
scsi_cmnd and keeping only the struct request, so I don't know where an 
appropriate place would be to store the retry counter.

Any ideas?

Alan Stern

