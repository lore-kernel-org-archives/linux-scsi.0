From: Alan Stern <stern@rowland.harvard.edu>
Subject: How to write a transparent SCSI bridge?
Date: Wed, 30 Jul 2003 10:38:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307301025050.2868-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4868 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S272916AbTG3Oij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 10:38:39 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Is it reasonably straightforward to write a kernel driver that acts as a 
transparent SCSI bridge?

What I have in mind is something that would receive CDBs and data over a 
USB link and would forward them to a standard SCSI device (or more 
accurately, a host adapter driver), and relay the replies back.

While familiar with the USB side, I don't have a very clear idea of what
would be involved on the SCSI end.  To keep things simple, I would only
handle one command at a time (no tagging or queueing).  Even so, several
difficulties suggest themselves:

	1. The SCSI protocol isn't designed for easy bridging.  My driver 
would have to figure out the direction of the data flow for each command 
by examining the CDB and also figure out the amount of data.  Since some 
commands encode the amount as a number of blocks, and since the blocksize 
is device-dependent, this isn't a simple task.  Also, it might be 
impossible to handle vendor-specific commands.

	2. My driver might require some very large I/O buffers.  It
wouldn't know beforehand how large a data transfer was going to be, and
the entire buffer must be present and filled before the command can be
forwarded to the SCSI device.

	3. I know very little about how the block layer works.  Somehow my 
driver would have to insert its requests into the appropriate queue.

Does this sound feasible?  Can anyone offer any advice?

Thanks in advance,

Alan Stern

