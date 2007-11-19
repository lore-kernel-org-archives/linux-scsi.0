From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI dynamic power management
Date: Mon, 19 Nov 2007 10:36:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191028400.4806-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44841 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754158AbXKSPgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 10:36:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Oliver (or anybody else):

Adding dynamic (AKA runtime) power management to the SCSI core is
looking a little difficult.  (Actually, since as far as I know the SCSI
specification takes no heed of power management, perhaps this should be
called "idle-device management".)

Imagine a SCSI disk has been idle long enough that we want to spin it
down.  When I/O requests do start to arrive later on, we want to delay
them in the request queue until the disk has a chance to spin back up.  
Or even to fail them, if the user has done a "manual" suspend.

These are conflicting requirements.  How can we send the START-STOP 
UNIT commands to spin the disk up/down through the request queue while 
delaying or failing all others?  What happens if one of the 
START-STOP UNIT commands encounters a problem and the error handler 
needs to send some commands of its own?

Any suggestions or ideas are welcome.

Alan Stern

