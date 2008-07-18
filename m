From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11120] New: aacraid driver stalls on high-load SMP machines
Date: Fri, 18 Jul 2008 14:36:00 -0700 (PDT)
Message-ID: <bug-11120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbYGRVgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2008 17:36:03 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6ILa0iv004797
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2008 14:36:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11120

           Summary: aacraid driver stalls on high-load SMP machines
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.24
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: smurf@smurf.noris.de


Latest working kernel version: unknown
Earliest failing kernel version: probably forever
Distribution: Ubuntu hardy
Hardware Environment: Dell PowerEdge 2650

Problem Description:

Under load, this happens rather often:

Jul 18 22:55:24 nun kernel: [86674.467410] aacraid: Host adapter abort request
(0,0,2,0)
Jul 18 22:55:24 nun kernel: [86674.467487] aacraid: Host adapter abort request
(0,0,3,0)
Jul 18 22:55:24 nun kernel: [86674.467617] aacraid: Host adapter reset request.
SCSI hang ?
Jul 18 22:57:26 nun kernel: [86815.728423] aacraid: Host adapter abort request
(0,0,0,0)
Jul 18 22:57:26 nun kernel: [86815.728500] aacraid: Host adapter abort request
(0,0,3,0)
Jul 18 22:57:26 nun kernel: [86815.728573] aacraid: Host adapter abort request
(0,0,2,0)
Jul 18 22:57:26 nun kernel: [86815.728640] aacraid: Host adapter abort request
(0,0,1,0)
Jul 18 22:57:26 nun kernel: [86815.728772] aacraid: Host adapter reset request.
SCSI hang ?

Access to the storage thus stalls for ten seconds or so.

I have successfully worked around the problem by using "schedtool -a 1
pid-of-basically-everything", so it seems to be an SMP-related problem.

However, one CPU is _somewhat_ slower than four, which is quite noticeable, so
we'd like to get this handled somehow :-/


lspci:

05:06.0 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)
        Subsystem: Dell PowerEdge 2400,2500,2550,4400
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
        BIST result: 00
        I/O ports at cc00 [size=256]
        Memory at fccff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fcd00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2

05:06.1 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)
        Subsystem: Dell PowerEdge 2400,2500,2550,4400
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
        BIST result: 00
        I/O ports at c800 [size=256]
        Memory at fccfe000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at f8100000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2


lspci -n:
05:06.0 0100: 9005:00c5 (rev 01)
        Subsystem: 1028:00c5
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
        BIST result: 00
        I/O ports at cc00 [size=256]
        Memory at fccff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fcd00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2

05:06.1 0100: 9005:00c5 (rev 01)
        Subsystem: 1028:00c5
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
        BIST result: 00
        I/O ports at c800 [size=256]
        Memory at fccfe000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at f8100000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
