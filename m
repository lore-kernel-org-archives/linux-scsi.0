From: Steven Hirsch <snhirsch@gmail.com>
Subject: Problem w/ DLT7000 tape drive
Date: Sat, 1 Sep 2007 10:19:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0709011004330.6209@duo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.burlingtontelecom.net ([204.13.40.89]:48407 "EHLO
	victor.burlingtontelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbXIAOmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Sep 2007 10:42:52 -0400
Received: from duo (65-183-141-215-dhcp.burlingtontelecom.net [65.183.141.215])
	by victor.burlingtontelecom.net (Postfix) with ESMTP id C04644C14D
	for <linux-scsi@vger.kernel.org>; Sat,  1 Sep 2007 10:19:59 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been struggling with a Quantum DLT7000 SCSI tape drive for the past 
week, and I'm not sure where else to turn for help.  The problem is 
simple; the drive's hardware compression simply does not work when backing 
up my system.

System particulars:

- 2x Pentium III CPU @ 500Mhz.
- 896MB memory
- RAID 5 array on IBM Serveraid 4H controller
- DLT7000 on Adaptec 2940W controller.

I need to backup several logical volumes on the raid controller.  The raid 
controller can easily support continuous reads at > 30MB/s and the tape 
drive (a SCSI2 device) needs about 5MB/s to maintain streaming.

I have (3) of the tape units.  All of them pass the full manufacturer 
diagnostics, which presumably exercise compression.

I am using plain, old tar for backup (but have also tried dump/restore).

Regardless of archive application or block settings (and I've tried 
dozens), the tape runs out of room at 34.9 GB.  This is the uncompressed 
capacity for a DLTIV tape.  Compression is definitely engaged (the panel 
LED on the drive is illuminated).  Granted that the advertised 2:1 
compression is optimistic, but I'd still expect to see _some_ compression 
on a generic spread of data.

For a control, I turned off the hardware compression and ran tar with the 
'z' flag to pipe through gzip.  Everything fits with room to spare.  A 
back of the napkin calculation suggests that I'm seeing about 1.5:1 
compression using this approach.  The downside is that its about 3x slower 
and creates an annoying amount of shoeshining.  Software compression is 
not fast enough to keep the drive streaming.

I'm about out of ideas.  It stretches my credulity to believe that all 
three drives (from very different sources) are defective.  What on earth 
can I do to get the hardware compression to show an advantage?  Is it a 
SCSI subsystem issue?  Any suggestions would be greatly appreciated.

Steve


-- 

