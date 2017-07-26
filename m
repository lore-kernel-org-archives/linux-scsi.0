From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196493] New: When LUN assignments on the target was changed,
 event must be triggered
Date: Wed, 26 Jul 2017 09:31:08 +0000
Message-ID: <bug-196493-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51522 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdGZJbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 05:31:22 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F37A42873D
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2017 09:31:21 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196493

            Bug ID: 196493
           Summary: When LUN assignments on the target was changed, event
                    must be triggered
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.13…4.4 and probably all other
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: ds@vo-ix.ru
        Regression: No

1. The (e.g. SAN) device is unmapped and then the same LUN is reused by other
WWN, but no actions taken on linux-side.
2. Kernel receives indication and claims "Kernel: [15671249.097583] sd
8:0:15:9: Warning! Received an indication that the LUN assignments on this
target have changed. The Linux SCSI layer does not automatically remap LUN
assignments."
3. Observe no further actions at kernel-side. ioctl (requested via blockdev)
returns parameters of unmapped LUN.

Expect at least to cock the trigger on respective device (like mapped to sysfs
"/sys/block/sd*/device/evt_lun_change_reported") and thus provide the mechanism
to inform device mapper. In perspective, the feature of auto-invalidation and
rescan on changed path.

-- 
You are receiving this mail because:
You are the assignee for the bug.
