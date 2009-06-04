From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13452] New: When log in a iscsi target it's fail and there is a
 bug scsi related
Date: Thu, 4 Jun 2009 08:16:23 GMT
Message-ID: <bug-13452-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41571 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZFDIQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 04:16:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n548GNTx022295
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 08:16:23 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13452

           Summary: When log in a iscsi target it's fail and there is a
                    bug scsi related
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.27.5-xen.hg
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: jrodriguez@ari.es
        Regression: No


I'm using a 2.6.27.5-hg Xen kernel. Modules iscsi_tcp and libiscsi are loaded
but when I log in a target iscsi syslog says that there is a kernel bug in
/var/xen/linux-2.6.27-xen.hg/drivers/scsi/scsi_lib.c:1759. I have download a
mainline kernel 2.6.27.5 and the source code differs.

2.6.27.5-xen.hg
 1757 struct device *dev = dev_to_nonscsi_dev(shost->shost_gendev.parent);

 1759 BUG_ON(!dev);

2.6.27.5 mainline

 1634 struct device *dev = shost->shost_gendev.parent;


I suposse that the Xen kernel is patched with "[PATCH][REPOST] scsi_lib_dma.c :
fix bug w/ dma on virtual fc ports." so i'm not sure if another kernel upper
2.6.27.5 are "bugged?".

Thank you.


This is the syslog trace:


Jun  4 09:14:58 xen2 kernel: ------------[ cut here ]------------
Jun  4 09:14:58 xen2 kernel: kernel BUG at
/var/xen/linux-2.6.27-xen.hg/drivers/scsi/scsi_lib.c:1759!
Jun  4 09:14:58 xen2 kernel: invalid opcode: 0000 [#1] SMP 
Jun  4 09:14:58 xen2 kernel: last sysfs file: /sys/class/scsi_host/host1/scan
Jun  4 09:14:58 xen2 kernel: Modules linked in: crc32c(N) iscsi_tcp(FN)
libiscsi(FN) scsi_transport_iscsi(FN) button(N) thermal(N) processor(N) fan(N)
th
ermal_sys(N)
Jun  4 09:14:58 xen2 kernel: Supported: No
Jun  4 09:14:58 xen2 kernel: 
Jun  4 09:14:58 xen2 kernel: Pid: 26876, comm: iscsid Tainted: GF        
(2.6.27.5 #3)
Jun  4 09:14:58 xen2 kernel: EIP: 0061:[<c031f9ec>] EFLAGS: 00010246 CPU: 0
Jun  4 09:14:58 xen2 kernel: EIP is at __scsi_alloc_queue+0x12c/0x140
Jun  4 09:14:58 xen2 kernel: EAX: 00000000 EBX: ed4cf800 ECX: 00000000 EDX:
c031f430
Jun  4 09:14:58 xen2 kernel: ESI: 00000000 EDI: ec2b0400 EBP: ebbdfd90 ESP:
ebbdfd70
Jun  4 09:14:58 xen2 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
Jun  4 09:14:58 xen2 kernel: Process iscsid (pid: 26876, ti=ebbde000
task=ebb24b10 task.ti=ebbde000)
Jun  4 09:14:58 xen2 kernel: Stack: ebbdfd80 ee332820 00000000 eb860e8c
c031f430 ed4cf800 ebbfba00 ebbfba14 
Jun  4 09:14:58 xen2 kernel:        ebbdfd9c c031fa10 ed4cf800 ebbdfdc4
c0320ae2 00000000 ebbdfdc4 ec2b0400 
Jun  4 09:14:58 xen2 kernel:        00000001 00000000 00000000 00000000
ebbfba00 ebbdfdf0 c03218c0 ebbfba04 
Jun  4 09:14:58 xen2 kernel: Call Trace:
Jun  4 09:14:58 xen2 kernel:  [<ee332820>] ? iscsi_session_match+0x10/0x70
[scsi_transport_iscsi]
Jun  4 09:14:58 xen2 kernel:  [<c031f430>] ? scsi_request_fn+0x0/0x460
Jun  4 09:14:58 xen2 kernel:  [<c031fa10>] ? scsi_alloc_queue+0x10/0x50
Jun  4 09:14:58 xen2 kernel:  [<c0320ae2>] ? scsi_alloc_sdev+0x132/0x1e0
Jun  4 09:14:58 xen2 kernel:  [<c03218c0>] ? scsi_probe_and_add_lun+0x1d0/0x270
Jun  4 09:14:58 xen2 kernel:  [<c03220e0>] ? __scsi_scan_target+0xb0/0xe0
Jun  4 09:14:58 xen2 kernel:  [<c03221c5>] ? scsi_scan_target+0xb5/0xc0
Jun  4 09:14:58 xen2 kernel:  [<ee33071b>] ? iscsi_user_scan_session+0xdb/0xf0
[scsi_transport_iscsi]
Jun  4 09:14:58 xen2 kernel:  [<ee330640>] ? iscsi_user_scan_session+0x0/0xf0
[scsi_transport_iscsi]
Jun  4 09:14:58 xen2 kernel:  [<c0284a89>] ? device_for_each_child+0x29/0x50
Jun  4 09:14:58 xen2 kernel:  [<ee330754>] ? iscsi_user_scan+0x24/0x30
[scsi_transport_iscsi]
Jun  4 09:14:58 xen2 kernel:  [<c0322a5d>] ? scsi_scan+0x9d/0xd0
Jun  4 09:14:58 xen2 kernel:  [<c015c2cb>] ? __alloc_pages_internal+0x9b/0x3a0
Jun  4 09:14:58 xen2 kernel:  [<c0322a90>] ? store_scan+0x0/0x20
Jun  4 09:14:58 xen2 kernel:  [<c0322a9f>] ? store_scan+0xf/0x20
Jun  4 09:14:58 xen2 kernel:  [<c028384f>] ? dev_attr_store+0x2f/0x40
Jun  4 09:14:58 xen2 kernel:  [<c01c36b7>] ? flush_write_buffer+0x47/0x70
Jun  4 09:14:58 xen2 kernel:  [<c01c3724>] ? sysfs_write_file+0x44/0x70
Jun  4 09:14:58 xen2 kernel:  [<c0181fe1>] ? vfs_write+0x91/0x140
Jun  4 09:14:58 xen2 kernel:  [<c0182184>] ? sys_write+0x44/0xb0
Jun  4 09:14:58 xen2 kernel:  [<c010479a>] ? syscall_call+0x7/0xb
Jun  4 09:14:58 xen2 kernel:  =======================
Jun  4 09:14:58 xen2 kernel: Code: b6 87 ac 00 00 00 c0 e8 03 83 e0 01 75 07 0f
b3 83 34 01 00 00 89 d8 ba 03 00 00 00 e8 ae 2e f0 ff 89 d8 83 c4 14 5b 5
e 5f 5d c3 <0f> 0b eb fe ba 00 00 01 00 eb c2 89 f6 8d bc 27 00 00 00 00 55 
Jun  4 09:14:58 xen2 kernel: EIP: [<c031f9ec>] __scsi_alloc_queue+0x12c/0x140
SS:ESP 0069:ebbdfd70
Jun  4 09:14:58 xen2 kernel: ---[ end trace 33a0f0dfcb966cb4 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
