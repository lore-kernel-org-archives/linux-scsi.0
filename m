From: Alan Stern <stern@rowland.harvard.edu>
Subject: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Sun, 22 Aug 2004 12:21:50 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4108 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S267930AbUHVQVv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 12:21:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Mike R." <turbanator1@verizon.net>

The SCSI core doesn't react properly when it receives SK/ASC/ASCQ = x 
02/04/01 = Not Ready, Logical unit in process of becoming ready.

The core is complex enough that I can't tell exactly what's wrong or how
it should be fixed.  That particular sense data combination is spotted in
two different places: scsi_lib.c:scsi_io_completion() and
scsi_error.c:scsi_check_sense().  It's not clear which one is causing the
problem -- maybe they both are.

Anyway, the reaction in both routines is to requeue the request for
immediate retry.  Obviously that's the wrong thing to do.  The request
should be retried, yes, but only after a delay of, say, a second or so.  
(Presumably the queue should remain blocked during that time.)  And this
should keep happening for up to maybe 30 seconds.

Instead what happens is that all the retries get exhausted in a fraction 
of a second, which isn't long enough for any device to spin up.  The 
drivers then proceed blindly with whatever else they want to do, which 
generally incurs its own set of errors.

This problem seems to be particularly bad for USB DVD drives.  One user
was able to work around it by manually loading the usb-storage driver 20
to 30 seconds after plugging the drive into the computer.  Obviously it
would be much better to have the system do the right thing in the first
place.

I don't know enough about the SCSI core to change it properly.  Can
someone please help?

Alan Stern

