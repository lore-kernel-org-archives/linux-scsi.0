From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187221] New: HPSA resetting logical / reset logical
Date: Mon, 07 Nov 2016 13:39:48 +0000
Message-ID: <bug-187221-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbcKGNlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 08:41:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id EDACF201B9
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 13:39:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 917FF20165
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 13:39:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187221

            Bug ID: 187221
           Summary: HPSA resetting logical / reset logical
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.x, 4.8.x
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: kernelorg@bof.de
        Regression: No

I have about 20 HP DL 380 (some 360) servers, from Gen7 to Gen9, using the HPSA
driver with various smartarray controllers.

For a long time I've been running mainline 3.14 kernels, without any issues.
Some time ago I updated to mainline 4.4.x, up to the most recent 4.4.30.

Now I noticed, especially on one server, but in the logs on 6 of them, the
following kind of message:

2016-11-06T22:09:50.227592+01:00 HOST kernel: [68853.338610] hpsa 0000:03:00.0:
scsi 0:1:0:0: resetting logical  Direct-Access     HP       LOGICAL VOLUME  
RAID-5 SSDSmartPathCap- En- Exp=1
2016-11-06T22:10:18.713759+01:00 HOST kernel: [68881.832436] hpsa 0000:03:00.0:
scsi 0:1:0:0: reset logical  completed successfully Direct-Access     HP      
LOGICAL VOLUME   RAID-5 SSDSmartPathCap- En- Exp=1

I see such messages, _usually_ only with 1 second between resetting/reset, on
machines with the following controller+controller firmware variants:
1 P410i 5.14
1 P420i 5.42
2 P440ar 3.02
1 P440ar 3.56
1 P440ar 4.02

The one machine for which I've shown the concrete message, is a P440ar with
firmware 3.02. There, contrary to the other machines, it sometimes takes up to
20 seconds for that resetting operation, and meanwhile, all I/O stalls.

I also tested with 4.8.x kernels, and saw the same symptoms there. I'm somewhat
sure that I did not see these with 3.14 kernels. This morning I rebooted the
most problematic box to 3.14.79, so far it was silent. I'll report if that
changes.

Apart from these log lines, there is nothing strange to be found - no ILO or
IML notifications visible, no other kernel messages, no drive failures, SMART
alerts, or performance regressions...

-- 
You are receiving this mail because:
You are the assignee for the bug.
