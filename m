From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191471] New: Mp2Sas and Mpt3Sas (now mpxsas) drivers are
 spinning forever in the IRQ handler under load condition
Date: Thu, 29 Dec 2016 15:16:46 +0000
Message-ID: <bug-191471-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752311AbcL2PQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Dec 2016 10:16:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3C81320519
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2016 15:16:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 36BE4204A2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2016 15:16:47 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191471

            Bug ID: 191471
           Summary: Mp2Sas and Mpt3Sas (now mpxsas) drivers are spinning
                    forever in the IRQ handler under load condition
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: okaya@codeaurora.org
        Regression: No

When there are a lot of IO requests queued for the HW, the IRQ handler of the
mpxsas driver spins forever until all requests are serviced. 

Spinning in the IRQ handler forever is a bad design and causes stalls on the
other cores that is unrelated to this request.

A simple solution has been posted here but rejected by the maintainer as the
maintainer has been looking to offload only the slow path to task context.

https://patchwork.kernel.org/patch/7579951/

Further requests for details to resolve the issue has been unanswered.

Logging the issue here for awareness.

-- 
You are receiving this mail because:
You are the assignee for the bug.
