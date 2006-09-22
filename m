From: Alan Stern <stern@rowland.harvard.edu>
Subject: How to make sd retry a command?
Date: Fri, 22 Sep 2006 17:19:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0609221711240.8511-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47623 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932169AbWIVVTm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 17:19:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

I've seen a few examples of USB storage devices that return clearly bogus 
error information on occasion.  For instance, the device might return 
CHECK CONDITION status with SK=5 (Illegal request) and ASC=20 (Invalid 
command) for a WRITE_10, even though it has accepted many other READ_10 
and WRITE_10 commands previously.  I don't know why the device does this.

When this happens, rather than failing the transfer entirely it makes 
sense to retry it.  Right now sd will switch over from WRITE_10 to 
WRITE_6, which is definitely the wrong thing to do.  I can prevent that 
easily enough.  The question is how to force a retry.

What information should sd_rw_intr() pass to scsi_io_completion() to
request a retry?  Or is there some other way of doing it?

And how can the number of retries be limited, say to 3?

Alan Stern

