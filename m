From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89531] New: mpt2sas: only every second disk working with PCIe
 x4 connection
Date: Wed, 10 Dec 2014 18:36:38 +0000
Message-ID: <bug-89531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33496 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaLJSgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2014 13:36:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9654C2015A
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2014 18:36:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F2C0D20166
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2014 18:36:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=89531

            Bug ID: 89531
           Summary: mpt2sas: only every second disk working with PCIe x4
                    connection
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.16.5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: abusse@cs.tu-berlin.de
        Regression: No

Created attachment 160351
  --> https://bugzilla.kernel.org/attachment.cgi?id=160351&action=edit
syslog

I have an SAS controller with LSI SAS 2008 controller in a PCIe slot with only
four lanes where the card can use up to eight lanes. I have the following
issue. Lets assume there are four drives attached to the controller
(sda...sdd). I use the following simple benchmark "cat /dev/sdX | pipebench >
/dev/null". When accessing every drive individually, every thing works fine.
However when I run the experiment on sda and sdb concurrently, it still works
on sda but the benchmarks stalls on sdb. When I kill the benchmark after some
seconds I see the error messages in the attachment. 

However, it gets more strange. When I run the benchmark concurrently on sda and
sdc every thing works as expected. When trying to read sdb or sdd concurrently
it always results in the error described above.

I also tried to change the hardware setup and only used every second connection
of the card. However the result stayed the same: concurrent access to every
second disk fails.

In the same machine I have the same SAS controller model in a PCIe x16 slot and
there every thing works like a charm. I also swaped the cards and the issue
stays with the PCIe x4 slot. So a defective card as the source of the problem
can be ruled out.

Thank you

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
