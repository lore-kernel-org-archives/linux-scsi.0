From: Alan Stern <stern@rowland.harvard.edu>
Subject: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 15 Oct 2004 15:19:19 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410151432250.1052-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:26884 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268334AbUJOTTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 15:19:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

A number of USB mass storage devices incorrectly return the total number 
of blocks rather than the largest block number in response to READ 
CAPACITY.  They then go on to compound the problem by not returning 
"Logical block address out of range" sense when asked to read the "last" 
block; instead they mess up the protocol and don't send any status phase 
information.

The usb-storage driver has been dealing with this by adding blacklist 
entries for these devices, but this isn't a very good solution.  After 
all, it's not a transport problem -- and it's not a good idea for a 
low-level driver to change the data being sent by a device.

Instead the adjustment should be made in sd.c, in the sd_read_capacity() 
routine.  One possibility is to have a SCSI blacklist flag for the bad 
devices.  A better choice might be to correct the mistake at runtime.  
Using the heuristic that the total number of blocks is almost always even 
(as far as I know it is _always_ even for USB disk-like devices), we could 
try to read the last block whenever READ CAPACITY reports an odd number of 
blocks.  If the read fails then we would know to decrement the number.

Does either of these sound like a good idea?  And if the second choice 
sounds better, is there anyone who could help me to write such a patch?

Alan Stern

