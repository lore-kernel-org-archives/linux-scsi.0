From: Alan Stern <stern@rowland.harvard.edu>
Subject: Maximum_transfer_size and SCSI request buffer size parameters
Date: Thu, 24 Jul 2003 11:12:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307241035140.720-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5380 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269354AbTGXO5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 10:57:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, Harald Dunkel <harri@synopsys.COM>

I'm trying to solve the problem of a user whose USB disk drive crashes
when it is asked to write 512K bytes in a single command.  A good way to
solve this problem would be to have a maximum_transfer_size field as part 
of the scsi_device structure.  Is it worthwhile adding such a feature?

More importantly, however, I noticed the following additional problem in
the sd.c and sr.c files (presumably also present in st.c and sg.c, but I
didn't look).  It has to do with the scmd->bufflen and
scmd->request_bufflen fields are used.  Now they aren't very well
documented to begin with, but even so their usage is inconsistent and
liable to crash a USB storage device.

In sd.c and sr.c, scmd->request_bufflen is the number of bytes to
transfer.  Both files use the variable this_count to compute the number
of sectors, stored in the command's CDB.  this_count is based on
request_bufflen, but the values can disagree.  For example, if READ(6)  
is used and request_bufflen corresponds to more than 255 sectors, 
this_count will be reduced to 255.

Furthermore, sr.c goes to the trouble of adding up the lengths of all the
scatter-gather blocks, and if the total disagrees with request_bufflen it
sets request_bufflen equal to the total -- but it does this after storing
this_count in the CDB.

This combination is deadly for usb-storage!  It relies on having 
request_bufflen be the exact byte count for the command stored in the CDB.

A related issue is that in both sd.c and sr.c, the rw_intr() routine
identifies the number of sectors correctly transferred as scmd->bufflen
(if no error occurred).  Normally bufflen is initialized equal to
request_bufflen.  But if this_count has been altered, the number of
sectors will be different from bufflen.

If nobody objects, I will work on a patch to fix these problems.

Alan Stern

