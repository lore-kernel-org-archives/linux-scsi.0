From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] New: HighPoint RocketRAID 2720 fail to detect some SATA
 hdd
Date: Fri, 21 Dec 2012 14:28:20 +0000 (UTC)
Message-ID: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33331 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2LUO2b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 09:28:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 09D1120187
	for <linux-scsi@vger.kernel.org>; Fri, 21 Dec 2012 14:28:25 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9E976200EB
	for <linux-scsi@vger.kernel.org>; Fri, 21 Dec 2012 14:28:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881

           Summary: HighPoint RocketRAID 2720 fail to detect some SATA hdd
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: kou1.ono@gmail.com
        Regression: Yes


After upgrading from 3.6.9 to 3.7, HighPoint RocketRAID 2720 (mvsas)  failed to
detect some hdd.
7 SATA hdds are connected, but only 2 or 3 hdds are detected.
I bisected and found bad commit:

65fe1f0f66a57380229a4ced844188103135f37b is the first bad commit
commit 65fe1f0f66a57380229a4ced844188103135f37b
Author: Shane Huang <shane.huang@amd.com>
Date:   Fri Sep 7 22:40:01 2012 +0800

    ahci: implement aggressive SATA device sleep support

    Device Sleep is a feature as described in AHCI 1.3.1 Technical Proposal.
    This feature enables an HBA and SATA storage device to enter the DevSleep
    interface state, enabling lower power SATA-based systems.

    Aggressive Device Sleep enables the HBA to assert the DEVSLP signal as
    soon as there are no commands outstanding to the device and the port
    specific Device Sleep idle timer has expired. This enables autonomous
    entry into the DevSleep interface state without waiting for software
    in power sensitive systems.

    This patch enables Aggressive Device Sleep only if both host controller
    and device support it.

    Tested on AMD reference board together with Device Sleep supported device
    sample.

    Signed-off-by: Shane Huang <shane.huang@amd.com>
    Reviewed-by: Aaron Lu <aaron.lwe@gmail.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

:040000 040000 9441b703760224de98a80546977129214d9528f8
436fe4f42392a48b4564f09cad69dafbe82be2c1 M    drivers
:040000 040000 3177c859173da3d15f3c2fb287364f063aa420d9
a39a26dc3f6c0b21433688420a820b121a921cec M    include


Revert 65fe1f0f66a from 3.7.1, all hdds are detected.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
