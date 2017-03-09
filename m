From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] New: VM with virtio-scsi drive often crashes during
 boot with kernel 4.11rc1
Date: Thu, 09 Mar 2017 23:53:52 +0000
Message-ID: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56502 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752412AbdCIXyE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 18:54:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D3853286E5
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2017 23:53:59 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 51743286E5
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2017 23:53:59 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

            Bug ID: 194837
           Summary: VM with virtio-scsi drive often crashes during boot
                    with kernel 4.11rc1
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.11rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: adamw@happyassassin.net
        Regression: No

In Fedora, we use the openQA automated test system, which runs qemu VMs and
does tests in them. By default, it attaches optical disc images to the test VM
using a virtio-scsi drive.

When Fedora 26 and Rawhide's kernels went from kernel-4.11.0-0.rc0.git9.1 to
kernel-4.11.0-0.rc1.git0.1 , many openQA tests suddenly started failing because
at some point in the test, the VM would fail to boot properly, with a kernel
error and traceback often displayed (sometimes the screen would just be blank).
I've seen three variants on this failure so far. Two have identical-looking
tracebacks but a slightly different error message:

https://openqa.fedoraproject.org/tests/60571#step/_console_wait_login/7
https://openqa.fedoraproject.org/tests/60572#step/_console_wait_login/6

note that one error is 'unable to handle kernel paging request' and the other
is 'unable to handle kernel NULL pointer dereference', but the tracebacks look
very similar.

Another case shows a somewhat different traceback:

https://openqa.fedoraproject.org/tests/60574#step/_console_wait_login/4

but doesn't show an error message (it may just be in the backscroll,
unfortunately there's no way to recover it from that test now). The traceback
is still in SCSI code, however.

I can reproduce this problem manually using virt-manager, so long as I attach a
SCSI optical drive to the VM (Add Hardware, Device type -> "CDROM device", Bus
type -> "SCSI"). If I use an IDE optical drive (which is the default in
virt-manager), the bug does not occur. So long as a SCSI optical drive is
attached, about half of the attempts to boot the system with the affected
kernel fail. Usually with a traceback looking like the ones from openQA,
sometimes it also just apparently hangs when enumerating SCSI devices (I think
that's what it's doing, the last line is 'scsi 3:0:0:0: CD-ROM     QEMU   QEMU
CD-ROM   2.0. PQ: 0 ANSI: 5' or a bit after that).

-- 
You are receiving this mail because:
You are the assignee for the bug.
