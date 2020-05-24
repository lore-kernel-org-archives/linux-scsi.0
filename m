Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48659C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 16:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234BD2073B
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 16:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgEXQu7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 12:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgEXQu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 12:50:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 207877] New: ASMedia drive (174c:55aa) hangs in ioctl
 CDROM_DRIVE_STATUS when mounting a DVD
Date:   Sun, 24 May 2020 16:50:58 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zfigura@codeweavers.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207877-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207877

            Bug ID: 207877
           Summary: ASMedia drive (174c:55aa) hangs in ioctl
                    CDROM_DRIVE_STATUS when mounting a DVD
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.6.14-arch1-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: zfigura@codeweavers.com
        Regression: No

Created attachment 289267
  --> https://bugzilla.kernel.org/attachment.cgi?id=289267&action=edit
dmesg including backtrace of hang

The device has USB vendor/product 174c:55aa, and is described by its USB
product string as "ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge,
ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge".

When attempting to mount via "mount /dev/sr0 /mnt", strace shows the following
sequence (tail of log):

openat(AT_FDCWD, "/dev/sr0", O_RDONLY|O_NONBLOCK|O_CLOEXEC) = 3
fadvise64(3, 0, 0, POSIX_FADV_RANDOM)   = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0xb, 0), ...}) = 0
ioctl(3, BLKGETSIZE64, [8351399936])    = 0
openat(AT_FDCWD, "/sys/dev/block/11:0", O_RDONLY|O_CLOEXEC) = 4
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or
directory)
close(4)                                = 0
openat(AT_FDCWD, "/sys/dev/block/11:0", O_RDONLY|O_CLOEXEC) = 4
faccessat(4, "partition", F_OK)         = -1 ENOENT (No such file or directory)
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or
directory)
close(4)                                = 0
ioctl(3, CDROM_GET_CAPABILITY, 0)       = 2227183
ioctl(3, CDROM_DRIVE_STATUS

The last ioctl hangs in the kernel forever. mount cannot be killed even with
SIGKILL. dmesg shows a hang in multiple kernel thread which has been attached.

This problem occurs with at least one DVD I have tested, but I was able to
successfully mount, access, and unmount another CD-ROM.

-- 
You are receiving this mail because:
You are the assignee for the bug.
