From: Ferenc Wagner <wferi@niif.hu>
Subject: qla2xxx: NULL pointer dereference in 2.6.26.6 on module load
Date: Thu, 16 Oct 2008 16:56:44 +0200
Message-ID: <87prm0ziz7.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:38910 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbYJPPaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2008 11:30:39 -0400
Received: from wferi by tac.ki.iif.hu with local (Exim 4.63)
	(envelope-from <wferi@niif.hu>)
	id 1KqUHM-0008BZ-IU
	for linux-scsi@vger.kernel.org; Thu, 16 Oct 2008 16:56:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

This problem is not present in 2.6.18 nor 2.6.27, but I'd like to see
it fixed in the kernel of Debian Lenny, so came here with a couple of
questions.

In driver versions: 8.01.07-k1 good, 8.02.01-k4 bad, 8.02.01-k7 good.

Console log of the failure:

qla2xxx 0000:01:06.0: Found an ISP2200, irq 16, iobase 0xd102c000
qla2xxx 0000:01:06.0: Configuring PCI space...
qla2xxx 0000:01:06.0: Configure NVRAM parameters...
udev: renamed network interface eth0 to eth-gb1
qla2xxx 0000:01:06.0: Verifying loaded RISC code...
udev: renamed network interface eth1 to eth-gb2
firmware: requesting ql2200_fw.bin
qla2xxx 0000:01:06.0: Allocated (252 KB) for firmware dump...
scsi1 : qla2xxx
qla2xxx 0000:01:06.0: 
 QLogic Fibre Channel HBA Driver: 8.02.01-k4
  QLogic QLA22xx - 
  ISP2200: PCI (66 MHz) @ 0000:01:06.0 hdma-, host#=1, fw=2.02.08 TP
qla2xxx 0000:01:06.0: LIP reset occured (f7f7).
qla2xxx 0000:01:06.0: LOOP UP detected (1 Gbps).
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<d113fd3e>] :qla2xxx:qla2x00_prep_ms_fdmi_iocb+0x1d/0xa4
*pdpt = 0000000000000000 
Oops: 0002 [#1] SMP 
Modules linked in: ata_generic(+) libata dock floppy aic7xxx(+) qla2xxx firmware_class scsi_transport_fc scsi_transport_spi scsi_tgt ohci_hcd tg3 scsi_mod usbcore serverworks ide_pci_generic ide_core thermal processor fan thermal_sys

Pid: 979, comm: qla2xxx_1_dpc Not tainted (2.6.26-1-xen-686 #1)
EIP: 0061:[<d113fd3e>] EFLAGS: 00010246 CPU: 1
EIP is at qla2x00_prep_ms_fdmi_iocb+0x1d/0xa4 [qla2xxx]
EAX: 00000000 EBX: 00000000 ECX: 00000010 EDX: 00000000
ESI: ce2bc34c EDI: 00000000 EBP: 00000000 ESP: cfd5be68
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
Process qla2xxx_1_dpc (pid: 979, ti=cfd5a000 task=ceb93a80 task.ti=cfd5a000)
Stack: 00000010 d1155ac0 ce2bc34c 00000000 ce2bc34c d113f099 86c6071e 00000200 
       ffff0a19 c0126498 ceb93a80 00000000 ce2bc34c 00000000 ce2bc34c d113f45d 
       00000063 0000001e ce2bd500 ce2bc34c 00000100 0000001e ce2bc300 ce2bd42c 
Call Trace:
 [<d113f099>] qla2x00_fdmi_rhba+0x19/0x3be [qla2xxx]
 [<c0126498>] process_timeout+0x0/0x5
 [<d113f45d>] qla2x00_fdmi_register+0x1f/0x3c1 [qla2xxx]
 [<d1134ab7>] qla2x00_configure_loop+0x5ea/0xfab [qla2xxx]
 [<d1138e2f>] qla2x00_mailbox_command+0x4cb/0x515 [qla2xxx]
 [<d1139ea3>] qla2x00_get_retry_cnt+0x3c/0xb7 [qla2xxx]
 [<c0116839>] __wake_up+0x29/0x39
 [<d11354cd>] qla2x00_loop_resync+0x55/0x9e [qla2xxx]
 [<d11326d0>] qla2x00_do_dpc+0x433/0x4bf [qla2xxx]
 [<d113229d>] qla2x00_do_dpc+0x0/0x4bf [qla2xxx]
 [<c012eb85>] kthread+0x38/0x5f
 [<c012eb4d>] kthread+0x0/0x5f
 [<c0104267>] kernel_thread_helper+0x7/0x10
 =======================
Code: 10 88 41 0e 83 c4 18 89 c8 5b 5e 5f 5d c3 55 89 d5 57 56 89 c6 53 83 ec 04 89 0c 24 8b 98 6c 11 00 00 b9 10 00 00 00 31 c0 89 df <f3> ab c6 03 29 c6 43 01 01 8b

EIP: [<d113fd3e>] qla2x00_prep_ms_fdmi_iocb+0x1d/0xa4 [qla2xxx] SS:ESP 0069:cfd5be68
---[ end trace 7ae2fc3608e49da2 ]---

I hoped that it'll be fixed by 048feec5, but that didn't happen.
Looking through git log v2.6.26..v2.6.27 drivers/scsi/qla2xxx nothing
jumped at me, but I'm not a kernel hacker.

Can you perhaps tell if the fix could be backported to 2.6.26?
Or maybe it was, just haven't yet made it into a 2.6.26.y release?
-- 
Thanks,
Feri.
