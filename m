From: Alan Stern <stern@rowland.harvard.edu>
Subject: Infinite retries
Date: Thu, 16 Oct 2008 14:21:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810161359560.2180-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46244 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752667AbYJPSVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 14:21:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

We do have a problem with infinite retry loops.  I'm not sure which 
kernels are affected, but there's a good chance 2.6.27 is and an 
excellent chance that 2.6.28-rc1 will be.

The problem is caused by buggy USB devices that return the number of 
sectors in response to READ CAPACITY, rather than the highest sector 
number.  Thus they appear to have one more sector than they really do.  
We can create blacklist entries for these devices, but they constantly 
appear and the list is never up-to-date.  So we need to handle them 
robustly even when they aren't on the blacklist.

When the system tries to read the non-existent last sector, the devices
send back no data.  In addition, the stupid devices return no sense
information (even though they often do return Check Condition status).

The question is: What should usb-storage report to the midlayer when
this happens?  Setting scmd->result to DID_ERROR doesn't help, because
sd_done() sets it back to 0 in the NO_SENSE case.  We end up calling
scsi_end_request() with error = 0 and bytes = 0, thereby requeuing the
request.  There's no counter to limit the number of times the same
request can be requeued.

I actually saw this happen to somebody in the log accompanying a bug
report a few days ago (Bugzilla #11768).

What's the proper solution?  Should usb-storage make up some bogus 
sense data (HARDWARE_ERROR sense key maybe)?

Alan Stern

P.S.: What about my proposed changes to scsi_io_completion()?  There 
hasn't been any response.

