From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12752] New: megaraid-sas driver performance worse than on-board sata_nv
Date: Sun, 22 Feb 2009 11:52:14 -0800 (PST)
Message-ID: <bug-12752-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZBVTwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 14:52:18 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1MJqFLg003217
	for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2009 11:52:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12752

           Summary: megaraid-sas driver performance worse than on-board
                    sata_nv
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: vanilla 2.6.28.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: kernel-bugs.dev1world@spamgourmet.com


Latest working kernel version:
Earliest failing kernel version:
Distribution: Gentoo
Hardware Environment: Dell PERC 5/i in a PCIe x16 slot, flashed with latest LSI
firmware, nForce4, AMD 3800 X2.
Software Environment: bonnie++ 1.94, HZ=300, NOHZ, CFQ, PREEMPT
Problem Description:

I ran two 1TB sata seagate drives on the on-board sata headers and created a
software raid0 (of size 30GB). Ran bonnie++ using ext4 as my filesystem. Then,
I put these on the PERC card and ran the same test with same FS and parameters.
The results are shown below. Why is megaraid card slower than the on-board
sata? With its 256MB cache (and enabled in BIOS), it should be doing better
than on-board sata. Also, note the weird behavior of adaptive read. The rewrite
improves but seq read b/w falls with adaptive read on the card. In both cases
the speed is lower than the on-board sata.

Version  1.94       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
OnBoardSATA      8G   398  99 229572  55 80200  19  1350  98 225241  32 321.8  
9
ReadAhead        8G   487  99 182941  44 66079  13  2108  98 196957  26 360.4  
7
ADaptiveReadAhed 8G   501  99 183013  44 78183  16  1566  91 163655  24 353.8  
9
Latency             26057us     636ms     137ms   21486us     165ms     236ms
Version  1.94       ------Sequential Create------ --------Random Create--------
sunil-amd-pc        -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 22084  54 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
Latency              7642us     110us     956us     530us     295us     202us

Both logical disks have the following cache related settings (reported by
megacli):

Default Cache Policy: WriteBack, ReadAdaptive, Cached, Write Cache OK if Bad
BBU
Current Cache Policy: WriteBack, ReadAdaptive, Cached, Write Cache OK if Bad
BBU
Access Policy: Read/Write
Disk Cache Policy: Enabled

I have tried various combos of these but the performance just tops out at what
is shown above. Is there some sort of throttling going on in the driver under
heavy load?

Let me know if you need more info.

Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
