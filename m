From: Alan Stern <stern@rowland.harvard.edu>
Subject: sg driver and the error handler
Date: Tue, 10 May 2005 14:51:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:1152 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261738AbVEJSvp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2005 14:51:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

I don't know who the right person is to handle this, but maybe someone can 
help...

When a command injected through the sg driver encounters any sort of
error, the usual retry mechanism and error handler are brought into play.  
Since sg sets the number of retries to 0 by default, the retry mechanism
shouldn't cause any difficulty.  But the error handler does.  IMO it
should never get involved with requests coming through sg -- sg should
provide access that is as transparent as possible so that userspace
programs will have a clean shot at managing their device.

Consider a case that just came up.  A USB CD drive causes a phase error
when it receives a certain READ BUFFER command (buggy firmware on the
drive, never mind that now).  You would expect the user program to receive
from sg a host_status value indicating DID_ERROR or something of the sort.

Instead the error handler takes charge and sends out one or two TEST UNIT 
READY commands.  The status information finally received by the user 
program is the status from the TEST UNIT READY, not from the failed READ 
BUFFER!  How's a program supposed to cope with that sort of obfuscation?

Something in the SCSI stack (scsi_io_completion ?) should check for 
requests coming in via sg and should know to complete the requests 
immediately.  No requeuing and no error handling.

Does this sound like a feasible thing to implement?

Alan Stern

