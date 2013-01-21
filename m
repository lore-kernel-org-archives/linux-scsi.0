From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 52911] New: 3w-9xxx BUG on insmod with 9650-4LPML and Quanta
 S45 MB
Date: Mon, 21 Jan 2013 22:27:53 +0000 (UTC)
Message-ID: <bug-52911-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab3AUW17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 17:27:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DC96C203BF
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jan 2013 22:27:56 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5095E203A5
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jan 2013 22:27:53 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=52911

           Summary: 3w-9xxx BUG on insmod with 9650-4LPML and Quanta S45
                    MB
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: james@warp2biz.com
        Regression: No


I have a Quanta S45 motherboard that I'm trying to install Debian 6.0 on
with a 3Ware 9650-4LPML RAID card.
When the Debian installer inserts the 3w-9xxx module, I get the following
kernel BUG.
I've tried a different 9650 card and booting with acpi=off to no avail so
far. I'm assuming it's a weird MB issue. Does anyone know of a fix/workaround?

Thanks.

-- James

Jan 21 20:31:26 kernel: [   31.609437] 3ware 9000 Storage Controller device
driver for Linux v2.26.02.013.
Jan 21 20:31:26 kernel: [   31.609479] 3w-9xxx 0000:03:00.0: PCI->APIC IRQ
transform: INT A -> IRQ 16
Jan 21 20:31:26 kernel: [   31.609484] 3w-9xxx 0000:03:00.0: setting latency
timer to 64
...

Jan 21 20:31:57 kernel: [   61.868012] 3w-9xxx: scsi7: ERROR: (0x06:0x0003): No
valid response while draining AEN queue.
Jan 21 20:31:57 kernel: [   61.868016] 3w-9xxx: scsi7: ERROR: (0x06:0x0022):
AEN drain failed during reset sequence.
Jan 21 20:32:07 kernel: [   72.208012] 3w-9xxx: scsi7: AEN: INFO (0x04:0x0053):
Battery capacity test is overdue:.
Jan 21 20:32:07 kernel: [   72.320014] 3w-9xxx: scsi7: AEN: INFO (0x04:0x0053):
Battery capacity test is overdue:.
Jan 21 20:32:07 kernel: [   72.432014] 3w-9xxx: scsi7: AEN: INFO (0x04:0x0001):
Controller reset occurred:resets=1.
Jan 21 20:32:07 kernel: [   72.544007] scsi7 : 3ware 9000 Storage Controller
Jan 21 20:32:07 kernel: [   72.544082] 3w-9xxx: scsi7: Found a 3ware 9000
Storage Controller at 0xdf5ff000, IRQ: 16.
Jan 21 20:32:38 kernel: [  102.568007] 3w-9xxx: scsi7: ERROR: (0x06:0x0013): No
valid response during get param.
Jan 21 20:32:38 kernel: [  102.568018] BUG: unable to handle kernel NULL
pointer dereference at (null)
Jan 21 20:32:38 kernel: [  102.572002] IP: [<ffffffffa00fd525>]
twa_probe+0x541/0x714 [3w_9xxx]
Jan 21 20:32:38 kernel: [  102.572002] PGD 43a17f067 PUD 43c6c0067 PMD 0
Jan 21 20:32:38 kernel: [  102.572002] Oops: 0000 [#1] SMP
Jan 21 20:32:38 kernel: [  102.572002] last sysfs file:
/sys/devices/pci0000:00/0000:00:19.0/net/eth0/uevent
Jan 21 20:32:38 kernel: [  102.572002] CPU 0
Jan 21 20:32:38 kernel: [  102.744014] Modules linked in: e1000e 3w_9xxx(+)
nls_utf8 isofs sg sr_mod cdrom hid_microsoft usbhid hid
thermal_sys usb_storage uhci_hcd ehci_hcd ahci li
Jan 21 20:32:38 kernel: [  102.744014] Pid: 3265, comm: modprobe Not tainted
2.6.32-5-amd64 #1 S45
Jan 21 20:32:38 kernel: [  102.744014] RIP: 0010:[<ffffffffa00fd525>] 
[<ffffffffa00fd525>] twa_probe+0x541/0x714 [3w_9xxx]
Jan 21 20:32:38 kernel: [  102.744014] RSP: 0018:ffff880437cdfd98  EFLAGS:
00010292
Jan 21 20:32:38 udevd-work[3259]: '/sbin/modprobe -b
pci:v000013C1d00001004sv000013C1sd00001004bc01sc04i00' unexpected exit with
status 0x0009
Jan 21 20:32:38 kernel: [  102.744014] RAX: 0000000000000000 RBX:
ffff88043e601090 RCX: 0000000000000004
Jan 21 20:32:38 kernel: [  102.744014] RDX: 0000000000000402 RSI:
0000000000000001 RDI: ffff8804370445a0
Jan 21 20:32:38 kernel: [  102.744014] RBP: ffff8804370445a0 R08:
0000000000000010 R09: ffffffff813b0932
Jan 21 20:32:38 kernel: [  102.744014] R10: 0000000000000000 R11:
00000000000186a0 R12: 00000000df5ff000
Jan 21 20:32:38 kernel: [  102.744014] R13: ffff88043e601000 R14:
ffff880437044000 R15: 0000000000000000
Jan 21 20:32:38 kernel: [  102.744014] FS:  00007f64f8eb9700(0000)
GS:ffff88000fa00000(0000) knlGS:0000000000000000
Jan 21 20:32:38 kernel: [  102.744014] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jan 21 20:32:38 kernel: [  102.744014] CR2: 0000000000000000 CR3:
000000043989d000 CR4: 00000000000006f0
Jan 21 20:32:38 kernel: [  102.744014] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 21 20:32:38 kernel: [  102.744014] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 21 20:32:38 kernel: [  102.744014] Process modprobe (pid: 3265, threadinfo
ffff880437cde000, task ffff88043c6adbd0)
Jan 21 20:32:38 kernel: [  102.744014] Stack:
Jan 21 20:32:38 kernel: [  102.744014]  0000000000000000 00000000ffffffff
ffff88043e601000 ffff88043e601090
Jan 21 20:32:38 kernel: [  102.744014] <0> ffffffffa00ff970 0000000000000000
0000000000405047 ffffffff811a2d46
Jan 21 20:32:38 kernel: [  102.744014] <0> ffff88043e601000 ffffffff811a3996
ffffffffa00ff970 ffff88043e601000
Jan 21 20:32:38 kernel: [  102.744014] Call Trace:
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff811a2d46>] ?
local_pci_probe+0x12/0x16
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff811a3996>] ?
pci_device_probe+0xc0/0xe9
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff81221520>] ?
driver_probe_device+0xa3/0x14b
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff81221617>] ?
__driver_attach+0x4f/0x6f
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff812215c8>] ?
__driver_attach+0x0/0x6f
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff81220def>] ?
bus_for_each_dev+0x43/0x74
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff812207af>] ?
bus_add_driver+0xaf/0x1f8
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff812218cf>] ?
driver_register+0xa7/0x111
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffffa0004000>] ?
twa_init+0x0/0x35 [3w_9xxx]
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff811a3bdc>] ?
__pci_register_driver+0x50/0xb8
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffffa0004000>] ?
twa_init+0x0/0x35 [3w_9xxx]
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff8100a065>] ?
do_one_initcall+0x64/0x174
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff8107ab54>] ?
sys_init_module+0xc5/0x21a
Jan 21 20:32:38 kernel: [  102.744014]  [<ffffffff81010b42>] ?
system_call_fastpath+0x16/0x1b
Jan 21 20:32:38 kernel: [  102.744014] Code: 00 ba 03 04 00 00 be 02 00 00 00
48 89 ef e8 e1 d3 ff ff 41 b8 10 00 00 00 b9 04 00 00 00 ba 02
04 00 00 be 01 00 00 00 48 89 ef <44> 8b
Jan 21 20:32:38 kernel: [  102.744014] RIP  [<ffffffffa00fd525>]
twa_probe+0x541/0x714 [3w_9xxx]
Jan 21 20:32:38 kernel: [  102.744014]  RSP <ffff880437cdfd98>
Jan 21 20:32:38 kernel: [  102.744014] CR2: 0000000000000000
Jan 21 20:32:38 kernel: [  102.748574] ---[ end trace 97d7904a50c0f684 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
