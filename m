From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12730] New: USB memory stick moved to different device on error / may be due to problem with high concurrent load on two USB devices
Date: Tue, 17 Feb 2009 14:25:55 -0800 (PST)
Message-ID: <bug-12730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZBQWdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 17:33:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1HMWTGA022728
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 14:32:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12730

           Summary: USB memory stick moved to different device on error /
                    may be due to problem with high concurrent load on two
                    USB devices
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.27.17
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wagner@tik.ee.ethz.ch


Latest working kernel version: No idea
Earliest failing kernel version: No idea
Distribution: Debian Lenny
Hardware Environment: USB is EHCI by ATI/AMD SB600. CPU is a single core
Sempron LE-1250

Software Environment: dd_rescue and a self-written flash exerciser
Problem Description: I have a 2GB flash as /dev/sdd and a 16GB flash as
/dev/sde. The 2 GB is exercised by a tester that writes and verifies. (This is
intended to be run until there are read errors. I expect that may take up to a
year or longer.) The 16GB I wanted to do a speed test using dd_rescue /dev/sde
/dev/null. It seems this somehow caused a problem leadung to high volume
console output and USB disconnects for both devices (found in the logs). 

I have tried the read from the 16GB without the exerciser running, this seems
to work. Unfortunately I did not find any error diagnotics in the logs besides
the USB disconnect, at least not anythign I recognized. What I did should not
have caused USB disconnects in the first place, so this may also be an USB
driver problem or the like. 

Now the interesting thing is that the kernel seems to have disabled /dev/sdd
and used the 16GB flash as new /dev/sdd. The 2GB flash did not turn up again.
Not good, devices should not change without an explicit re-plug.

If an USB disconnect is indistinguishable in software from a physical unplug
and replug, I understand that nothing can be done. But if it can be
distinguished, devices should be prevented from moving around on error.

Steps to reproduce: I tried to run this again. Just a reading of the 16GB flash
with dd_rescue did not produce any problems. Starting the flash exerciser again
after replugging both flash devices to get them to their original devices
worked. I could not recreate the original situation, since the port with the
2GB device was now only using OHCI and a reboot on this machine causes some
effort. This may therefore also be an USB driver issue with the EHCI driver
being crashy.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
