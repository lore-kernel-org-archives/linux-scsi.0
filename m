From: "Jonathan Fischer" <jfischer@csusm.edu>
Subject: Megaraid and Dell PERC 4 controllers
Date: Tue, 23 Aug 2005 13:51:30 -0700
Message-ID: <86BF48E0F11BE44D99952F9FB349BC4B0982A488@priority>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from priority.csusm.edu ([144.37.11.60]:25435 "EHLO
	priority.csusm.edu") by vger.kernel.org with ESMTP id S1750784AbVHWUvY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 16:51:24 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I apologize if this is the wrong list to ask this kind of question on;
I've posted on Dell's PowerEdge list and Red Hat's lists as well, but I
figure the people here might know better what to try for this problem.

I have 2 Dell PowerEdge 2850's, one with a PERC 4e/DC raid controller,
and the other with a PERC 4e/Di.  On both of these systems, I can
reliably cause the controllers to lock up under heavy load.  This is
using a fully up-to-date Red Hat 4 EL (non x86_64) installation on both
computers.  The controllers use the megaraid_mbox driver.

During a period of high load, the controller suddenly seems to stop
responding to the driver, causing the driver to go into a waiting loop
for it.  It waits 3 minutes for the controller to respond, which it
never does, and then takes the controller offline, pretty much yanking
the filesystem out from underneath the OS.

Some things keep running alright, so (working with Red Hat's support) I
got the thing set up to netdump to another server to see if we could
figure out what was going wrong.  The kernel never actually crashes, so
netdump doesn't produce a vmcore to look through, but syslog keeps
spouting out information, so I've got that.

Every time this lockup occurs, the log file looks like this:

megaraid: aborting-29762 cmd=2a <c=2 t=0 l=0>
megaraid abort: 29762:21[255:128], fw owner
megaraid: aborting-29763 cmd=2a <c=2 t=0 l=0>
megaraid abort: 29763:39[255:128], fw owner
megaraid: aborting-29764 cmd=2a <c=2 t=0 l=0>
megaraid abort: 29764:16[255:128], fw owner
megaraid: aborting-29768 cmd=2a <c=2 t=0 l=0>
megaraid abort: 29768:53[255:128], fw owner

	This part repeats 64 times, then...

megaraid: aborting-29831 cmd=2a <c=2 t=0 l=0>
megaraid abort: 29831:8[255:128], fw owner
megaraid: resetting the host...
megaraid: 64 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 64 commands to complete:180
megaraid mbox: Wait for 64 commands to complete:175
	
	megaraid mbox counts down to 0, and then...

megaraid mbox: critical hardware error!
megaraid: resetting the host...
megaraid: hw error, cannot reset
megaraid: resetting the host...
megaraid: hw error, cannot reset
SCSI error : <0 2 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 242938701
Buffer I/O error on device dm-4, logical block 9893952 lost page write
due to I/O error on dm-4
scsi0 (0:0): rejecting I/O to offline device

The commands that the driver are waiting for are always the same, except
for the sequence number (the number right after "aborting-" and  "abort:
").  And there are always 64 commands backed up that the driver is
waiting for.

Both machines in question pass memtest86 and Dell's diagnostic sets, and
since the failure is identical in both I don't believe it's bad
hardware.  We've got the latest BIOS, RAID firmware, and backplane
firmware on the machines.

I've also tried:
- the RHEL 4 Update 2 Beta kernel (at Red Hat's suggestion)
- RHEL 4 x86_64
- RHEL 3 x86_64
- Fedora Core 4 x86
- disabling Patrol Read in the RAID bios
- disabling read-ahead in the RAID bios
- changing the writeback cache flush to every 2 seconds, instead of the
default 4

I think next up I'm trying writethru mode, instead of write back, but
has anyone seen anything like this, or have any insight they might
offer?  I'm quickly getting to the point of being stumped.

Jonathan Fischer
Operating Systems Analyst - CSU San Marcos
jfischer@csusm.edu

