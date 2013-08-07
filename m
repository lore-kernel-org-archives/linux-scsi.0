From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60711] New: USB drive no longer detected as removable storage
 media
Date: Wed, 07 Aug 2013 08:15:30 +0000
Message-ID: <bug-60711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3HGIPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Aug 2013 04:15:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E6BD3201F7
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2013 08:15:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 80497201F0
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2013 08:15:31 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60711

            Bug ID: 60711
           Summary: USB drive no longer detected as removable storage
                    media
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.3
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: trallala@onlinehome.de
        Regression: No

Created attachment 107132
  --> https://bugzilla.kernel.org/attachment.cgi?id=107132&action=edit
DMESG excerpt from success and failure

This patch

commit 98dcc2946adbe4349ef1ef9b99873b912831edd4
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Thu Jun 6 22:15:55 2013 -0400
SCSI: sd: Update WRITE SAME heuristics
commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d upstream.

introduced with kernel patch-3.10.3 effectively breaks detection of some USB
drives as removable storage media. The concerned drives are recognized by the
SCSI layer, but are no longer available as removable storage (see attachment).

Commenting out the following if-clause from sd.c (function sd_read_write_same)
        if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
            sdev->no_write_same = 1;
makes anything working as expected.

-- 
You are receiving this mail because:
You are the assignee for the bug.
