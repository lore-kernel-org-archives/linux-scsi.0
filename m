From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] New: QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Thu, 25 Sep 2008 06:55:18 -0700 (PDT)
Message-ID: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684AbYIYN4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 09:56:16 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PDthPQ013831
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 06:55:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646

           Summary: QLA2xxx: Kernel deadlock on high load somewhere after
                    2.6.20
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: grin@grin.hu


Latest working kernel version: 2.6.20
Earliest failing kernel version: known 2.6.24
Distribution: Debian stable
Hardware Environment: QLogic Corp. QLA2422 Fibre Channel Adapter (rev 02), IBM
(intel based) HS21 blade server, external SAN storage [IBM DS4200], optional
full multipath (happens with or without), further details on specified requests
Software Environment: multipathd handling dm devices, lvm2, xfs

Problem Description:
The machines go dead under heavy IO load. Go dead may mean rare complete
crashes, more often infinite resource wait states, or stuck udev streads all
over. 

The diagnostic was pretty hard, many components were checked and finally it
boiled down to the qla2xxx driver. 
It seems that somewhere after 2.6.20 the driver have a problem with high loads,
where it first:
- start to see (or generate) link downs without reason
- tries to handle these, by logging thousands of "try to dump firmware"
messages, while
- somehow screw up IRQ handling, because more often than not even eth0 starts
complaining about transmit timeouts, and the kernel often say "..no IRQ handler
for vector"
- never recovers. I've seen many messages like:
== mailbox command timeout
== performing isp recovery
== loop up 4gbps
== SNS scan failed - assuming zero entry result
== scsi: abort command issued ...
then often
== FC repot port time out
== SCSI DEVICE RESET ISSUED
and it sometimes ends with a stack trace and the happy message
== RIP 0x10

The diagnosic is hard because I cannot easily make it crash by force: even
bonnie++ survive multiple runs without problems, but a busy postgres can crash
it in a few hours usually.

After we changed and upgraded almost everything in both paths and nothing
helped (including kernel upgrade to latest official one) I backed up to 2.6.20
and the problem disappeared. It is not easy to tell when was it broken because
I cannot just start playing with live servers and I cannot make it crash on a
test server. But if you have any tests which should crash it then I can try it
on a different (testing) machine.


Steps to reproduce: I wish I knew. Loads of IO in an unknown pattern make it
die in a few hours, or days.

I can provide any info you ask and I'm able to pry out of the machines, kernel
[logs], etc. Most crashes does only have screenshots of remote console, since
it killed all disk IO around.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
