From: Alan Stern <stern@rowland.harvard.edu>
Subject: How to force abort of a SCSI command
Date: Tue, 18 Nov 2003 11:36:34 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311181112210.783-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:15876 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261841AbTKRQgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 11:36:36 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

I'm starting to work on a kernel driver that will submit SCSI requests 
directly to a device queue -- rather like the sg driver except that mine 
will operate as a bottom half, not in process context.  There won't be any 
predetermined timeouts for the commands, but sometimes my driver will need 
to abort a command and perform a device reset.

I see that scsi_reset_provider() is available to implement device reset
requests (although it needs to run in a process, no big deal).  But it
won't abort a command that's already in progress.

So I need to know how to abort a queued request.  That actually involves 
two problems: how to abort a request that hasn't yet made it to the head 
of the queue and begun processing, and how to abort a command that has 
already gone to the low-level device driver.  The first problem probably 
doesn't matter much; I'm assuming that nobody else will be using the 
device at the same time as my driver.  But it would be nice to know how to 
cancel _all_ the outstanding requests on the device queue.

The second problem is the real one I have to face.  Is there some way to 
abort an ongoing command, perhaps by following pointers to the scsi_cmnd 
structure and invoking the timeout routine directly?

Alan Stern

