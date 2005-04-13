From: Ralf =?iso-8859-1?q?M=FCller?= <ralf@bj-ig.de>
Subject: aacraid: kernel NULL pointer dereference
Date: Wed, 13 Apr 2005 18:02:52 +0200
Message-ID: <200504131802.52341@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.bj-ig.de ([217.119.193.11]:3096 "EHLO ns.bj-ig.de")
	by vger.kernel.org with ESMTP id S261379AbVDMQC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 12:02:56 -0400
Received: from tower.bj-ig.de (tower.bj-ig.de [194.127.182.2])
	by ns.bj-ig.de (8.12.6/8.12.6/SuSE Linux 0.6) with ESMTP id j3DG1qis024639
	for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2005 18:01:52 +0200
Received: from ralf.bj-ig.de (ralf.bj-ig.de [194.127.182.13])
	by tower.bj-ig.de (8.12.6/8.12.6/SuSE Linux 0.6) with ESMTP id j3DG2rkN003112
	for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2005 18:02:53 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I currently try to set up a server with an Adaptec 2810SA RAID controller.
While testing the Adaptec command line utility aacraid (actually the
command "controller list") with a vanilla 2.6.12-rc2 kernel I got the
following kernel oops - maybe someone is interested, maybe someone as
some help for me:

Unable to handle kernel NULL pointer dereference at virtual address 0000002c
 printing eip:
c02e62fa
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in: nvram ipv6 speedstep_lib freq_table processor edd evdev joydev st sr_mod af_packet sg 3c59x mii ehci_hcd uhci_hcd e1000 usbcore i2c_i801 i2c_core intel_agp agpgart parport_pc lp parport video1394 ohci1394 raw1394 ieee1394 capability commoncap dm_mod reiserfs ide_cd cdrom ide_disk aacraid piix ide_core sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c02e62fa>]    Not tainted VLI
EFLAGS: 00010046   (2.6.12-rc2-smp)
EIP is at _spin_lock_irqsave+0x1a/0x80
eax: 00000000   ebx: 0000002c   ecx: 00000001   edx: 00000286
esi: f6116000   edi: 0000002c   ebp: bf8a4440   esp: f6117f34
ds: 007b   es: 007b   ss: 0068
Process aaccli (pid: 6691, threadinfo=f6116000 task=f5f18a60)
Stack: 00042008 00000000 f886980f 00042008 00000000 00000000 f886888d 00042008
       bf8a4440 00000000 bf8a4440 f8869243 f88708a0 f5331d80 ffffffe7 c0170888
       bf8a4440 00042008 00000000 f5331d80 00000005 f6116000 c0170a05 f6116000
Call Trace:
 [<f886980f>] fib_alloc+0xf/0x60 [aacraid]
 [<f886888d>] ioctl_send_fib+0xd/0x100 [aacraid]
 [<f8869243>] aac_do_ioctl+0xb3/0xb8 [aacraid]
 [<c0170888>] do_ioctl+0x48/0x70
 [<c0170a05>] vfs_ioctl+0x55/0x1d0
 [<c0170bc6>] sys_ioctl+0x46/0x60
 [<c01040cb>] sysenter_past_esp+0x54/0x79
Code: eb db e8 9a ef ff ff eb c0 90 8d b4 26 00 00 00 00 56 53 89 c3 b8 01 00 00 00 e8 12 65 e3 ff be 00 e0 ff ff 21 e6 9c 5a fa 31 c0 <86> 03 84 c0 7e 0c c7 43 04 00 00 00 00 89 d0 5b 5e c3 52 9d b8
 <6>note: aaccli[6691] exited with preempt_count 1

The system is a newly installed SuSE 9.3. If you need more
information - please ask.

Regard
Ralf

-- 
Van Roy's Law: -------------------------------------------------------
       An unbreakable toy is useful for breaking other toys.
