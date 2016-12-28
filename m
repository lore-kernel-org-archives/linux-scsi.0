From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191381] New: LIO ignores XCOPY source and destination
 descriptor IDs
Date: Wed, 28 Dec 2016 17:10:29 +0000
Message-ID: <bug-191381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750976AbcL1RKd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Dec 2016 12:10:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A1536203DA
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 17:10:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 46A18203C2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 17:10:30 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191381

            Bug ID: 191381
           Summary: LIO ignores XCOPY source and destination descriptor
                    IDs
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.9.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: ddiss.dev@gmail.com
        Regression: No

The EXTENDED COPY SCSI command (XCOPY) is used extensively by VMware ESX
initiators, to offload to the iSCSI target, the process of copying data between
a source and destination LU region.
XCOPY is also supported by other initiators, such as ddpt
(http://sg.danny.cz/sg/ddpt.html), libiscsi, etc.

The XCOPY specification in SPC-4 (revision 37) states that the XCOPY source and
destination device(s) should be derived from the copy source and copy
destination descriptor (CSCD) IDs in the XCOPY segment descriptor. The CSCD IDs
are generally (for block -> block copies), indexes into the corresponding CSCD
list, i.e.

=================================
XCOPY Header    
=================================
CSCD List
- entry 0
  + LU ID
- entry 2
  + LU ID
=================================
Segment Descriptor List
- segment 0
  + src CSCD ID = (CSCD entry 0)
  + dest CSCD ID = (CSCD entry 1)
  + len
  + src lba
  + dest lba
=================================

Currently LIO completely ignores the src and dest CSCD IDs in the Segment
Descriptor List, and instead assumes that the first entry in the CSCD list
corresponds to the source, and the second to the destination.

This assumption appears to stand true for XCOPY requests from ESXi initiators.
However, deviation from the spec may break other initiators - it causes a
number of libiscsi tests to fail.

-- 
You are receiving this mail because:
You are the assignee for the bug.
