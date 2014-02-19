From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70851] New: mpt3sas / LSI SAS 9300-8i write performance
 bottleneck
Date: Wed, 19 Feb 2014 15:38:47 +0000
Message-ID: <bug-70851-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34679 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbaBSPiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 10:38:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58E73201D5
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2014 15:38:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 99E49201BA
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2014 15:38:47 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70851

            Bug ID: 70851
           Summary: mpt3sas / LSI SAS 9300-8i write performance bottleneck
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.12.9-201.fc19.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: heinzm@redhat.com
        Regression: No

Description of problem:

LSI SAS 9300-8i write performance too slow
(whilst read performance is just fine).

Version-Release number of selected component (if applicable):

Kernel 3.12.9-201.fc19.x86_64


How reproducible:
Always


Steps to Reproduce:
1. attach 3 SSDs to adapter
2. create striped mapped device (e.g. using LVM)
3. dd of=/dev/$TheStripedDevice oflag=direct if=/dev/zero iflag=fullblock bs=2G
count=1

Actual results:

Single threaded read performance is as expected, ie. 3 SSDs (3 * Samsung 840EVO
 1TB) with per drive sustained read throughput of 540MB/s lead to ~1.6GB/s on a
striped logical volume (all 3 attached to one SFF-8643 port of the HBA via a
1:4 mSAS to SAS cable).

Write performance on the same striped LV as in "Steps to Reproduce" (1 thread)
maxes out at ~750MB/s as opposed to the maximum write throughput of ~490MB/s on
each of the 3 SSDs written one by one

Measured:
- ~490MB/s writing (1 thread) to the individual SSDs one by one
- ~750MB/s writing (1 thread) to all 3 SSDs in parallel via the striped LV
- ~1GB/s (3 * ~340MB/s) writing (3 threads) to all 3 SSDs in parallel;
     ie. better than the striped LV write performance


Expected results:

Expecting >1.4GB/s write maximum on the striped LV written single threaded.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
