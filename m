From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] New: aacraid is generally unstable with newer kernels
Date: Wed, 16 Mar 2011 17:43:58 GMT
Message-ID: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54558 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1CPRn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 13:43:59 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2GHhwkK019299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 17:43:58 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212

           Summary: aacraid is generally unstable with newer kernels
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32, 2.6.37.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: nemesis@icequake.net
        Regression: No


Created an attachment (id=50962)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=50962)
dmesg

I have a HP DL380 with an Adaptec 2120S that, many moons ago, never exhibited
any problems.  Since lenny and squeeze I have had frequent "Host adapter abort
request" messages followed by a RAID firmware panic under heavy disk I/O.  In
2.6.32 it seemed impossible to recover from these things, it would offline the
RAID and disable the system.  In 2.6.37.3 it seems better at recovering after a
delay, but I am afraid something is wrong at a low level that may corrupt data:

[572820.064043] aacraid: Host adapter abort request (2,0,0,0)
[572820.149996] aacraid: Host adapter abort request (2,0,0,0)
[572820.235786] aacraid: Host adapter abort request (2,0,0,0)
[572820.321554] aacraid: Host adapter abort request (2,0,0,0)
[572820.407418] aacraid: Host adapter reset request. SCSI hang ?
[572820.496444] AAC: Host adapter BLINK LED 0x3
[572820.567966] AAC0: adapter kernel panic'd 3.
[595047.992045] aacraid: Host adapter abort request (2,0,0,0)
[595048.078463] aacraid: Host adapter abort request (2,0,0,0)
[595048.164959] aacraid: Host adapter abort request (2,0,0,0)
[595048.250844] aacraid: Host adapter abort request (2,0,0,0)
[595048.336629] aacraid: Host adapter abort request (2,0,0,0)
[595048.336637] aacraid: Host adapter abort request (2,0,0,0)
[595048.336644] aacraid: Host adapter abort request (2,0,0,0)
[595048.336650] aacraid: Host adapter abort request (2,0,0,0)
[595048.336657] aacraid: Host adapter abort request (2,0,0,0)
[595048.336663] aacraid: Host adapter abort request (2,0,0,0)
[595048.336773] aacraid: Host adapter reset request. SCSI hang ?
[595048.336782] AAC: Host adapter BLINK LED 0x3
[595048.336916] AAC0: adapter kernel panic'd 3.
[596524.064044] aacraid: Host adapter abort request (2,0,0,0)
[596524.146368] aacraid: Host adapter abort request (2,0,0,0)
[596524.228197] aacraid: Host adapter abort request (2,0,0,0)
[596524.309288] aacraid: Host adapter abort request (2,0,0,0)
[596524.389967] aacraid: Host adapter reset request. SCSI hang ?
[596524.473168] AAC: Host adapter BLINK LED 0x3
[596524.538332] AAC0: adapter kernel panic'd 3.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
