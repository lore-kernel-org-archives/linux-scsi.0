From: Alan Stern <stern@rowland.harvard.edu>
Subject: Synchronizing scsi_remove_host and the error handler
Date: Sun, 7 Aug 2005 10:59:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:24069 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1751921AbVHGO7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 10:59:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

What sort of synchronization is there between scsi_remove_host and the 
error-handler thread?  Offhand I can see two possible problems, depending 
on how the LLD is written:

     1.	The error handler asks the LLD to perform a reset just as the LLD
	calls scsi_remove_host as part of rmmod.  scsi_remove_host 
	returns, the LLD's remove method returns, and the LLD is unloaded
	from memory while its reset routine is executing.

     2. The error handler asks the LLD to perform a reset just before the
	LLD calls scsi_remove_host.  The LLD's remove method can't return
	until the reset completes (otherwise the reset would be executing 
	code that is about to be unloaded, as in (1)).  But the reset
	can't get started until it acquires the host adapter's device 
	semaphore, which is owned by the rmmod thread.

(1) causes an oops and (2) causes a deadlock.  Note that (1) can be 
avoided by making scis_remove_host wait until the error handler thread has 
exited, but that will make (2) much more likely to happen.

In general, there needs to be some way for the error handler to prevent
the LLD from being unloaded.  I don't know what the best answer is.  Has
anyone thought about this?

Alan Stern

