From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198081] New: scsi sg
Date: Mon, 04 Dec 2017 10:05:21 +0000
Message-ID: <bug-198081-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45160 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752886AbdLDKFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 05:05:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 32FD12885F
        for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2017 10:05:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198081

            Bug ID: 198081
           Summary: scsi sg
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.89 and higher
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: crinteanu.cristian@gmail.com
        Regression: No

Created attachment 261015
  --> https://bugzilla.kernel.org/attachment.cgi?id=261015&action=edit
scsi sg problems

hi, just noticed that one of the following commits introduced in 4.4.89 borks
some apps (like nerolinux and norton ghost 12.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3e0097499839e0fe3af380410eababe5a47c4cf9

https://lkml.org/lkml/2017/9/24/457

https://patchwork.kernel.org/patch/9968779/

https://lkml.org/lkml/2017/9/24/356

nerolinux fail to detect any drives on my pc with

 Call Trace:
  [<c02de73f>] ? dump_stack+0x44/0x57
  [<c013b639>] ? warn_slowpath_common+0x85/0x9a
  [<c03e1116>] ? sg_rq_end_io+0x42/0x277
  [<c013b6f1>] ? warn_slowpath_null+0xd/0x10
  [<c03e1116>] ? sg_rq_end_io+0x42/0x277
  [<c02bd08c>] ? blk_account_io_done+0xc/0xea
  [<c02bd1cd>] ? blk_finish_request+0x63/0x84
  [<c03c9f87>] ? scsi_end_request+0x11a/0x155
  [<c03cae32>] ? scsi_io_completion+0x1c7/0x4aa
  [<c02c1c2c>] ? blk_done_softirq+0x56/0x70
  [<c013df28>] ? __do_softirq+0xa6/0x18b
  [<c013de82>] ? tasklet_action+0x90/0x90
  [<c0103980>] ? do_softirq_own_stack+0x1a/0x1f
  <IRQ>  [<c013e144>] ? irq_exit+0x3c/0x7b
  [<c0103463>] ? do_IRQ+0x7a/0x8b
  [<c05343b3>] ? common_interrupt+0x33/0x38
  [<c016007b>] ? unregister_console+0x87/0xad
  [<c0476295>] ? cpuidle_enter_state+0xdb/0x17d
  [<c0155e6b>] ? cpu_startup_entry+0x17f/0x1e2
  [<c0129344>] ? start_secondary+0x13b/0x153
 ---[ end trace 36fc4958c27e64df ]---

and norton ghost 12

*********************************
Date   : Wed Nov 29 22:34:34 2017
Error Number: 36000
Message: A signal or windows exception occurred
Version: 12.0.0.10561(Nov  2 2017, Build=10561
OS Version: Linux 4.4.100-pclos1.pae #1 SMP Tue Nov 21 16:10:25 EET 2017 i686
Command line arguments:
Active Switches :
       AutoName
PathName            :
FlagImplode         : 0
FlagExplode         : 0

Operation Details :
  Total size.........0
  MB copied..........0
  MB remaining.......0
  Percent complete...0%
  Speed..............0 MB/min
  Time elapsed.......0:00  
  Time remaining.....0:00  

Processor exception
Generated at HardExceptionHandlerLinux.cpp:230

Program Call Stack
VolumeContainerManagerLvm::addIfPv
VolumeContainerManagerLvm::loadPvs
VolumeContainerManagerLvm::loadVolumeGroups
VolumeContainerManagerLvm::loadVolumeGroups
VolumeContainerManagerLvm::constructor
VolumeContainerManager::loadVolumeManagers
VolumeContainerManager::constructor
sub_main
main

Call Stack
  0xeba0f62a
  0xb77e8a0c
  0x084644f6
  0x084645ce
  0x086ad8e0
  0x086b3aac
  0x0870f00e
  0x0870f3a3
  0x0870f51b
  0x0870f7ab
  0x0870f8de
  0x086ff373
  0x086ffdab
  0x08700039
  0x08284c59
  0x08286679
  0x082893df
  0x08052d25
  0x080541b4
End Call Stack

Anyway i reversed the scsi: sg: changes introduced in 4.4.89 and everything
works fine (see the attach) - now i'm running 4.4.100 with the patch attached
thx!

-- 
You are receiving this mail because:
You are the assignee for the bug.
