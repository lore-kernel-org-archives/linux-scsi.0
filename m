From: Johnny Bieren <jbieren@redhat.com>
Subject: CISS driver error introduced with kernel-4.9.0-0.rc2.git1.1.fc26
Date: Mon, 7 Nov 2016 07:44:05 -0500
Message-ID: <58207715.9000403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com
Cc: iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

It appears that a check_unmap kernel failure for the CISS driver was 
introduced with kernel-4.9.0-0.rc2.git1.1.fc26.  When booting this 
kernel, or any newer kernel, I see the following:

  [    3.676658] HP CISS Driver (v 3.6.26)
0m] Reached target System Initialization.
          Starting dracut initqueue hook...
          Starting Show Plymouth Boot Screen...
[    3.756592] scsi host0: pata_amd
[    3.772866] scsi host1: pata_amd
[    3.782052] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[    3.789616] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[    3.825789] cciss 0000:02:04.0: cciss0: <0x46> at PCI 0000:02:04.0 IRQ 24 using DAC
[    3.836530] audit: type=1130 audit(1478270493.962:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=plymouth-start comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[
   OK
] Started Show[    3.839544] ------------[ cut here ]------------
  Plymouth Boot S[    3.839555] WARNING: CPU: 0 PID: 193 at lib/dma-debug.c:1164 check_unmap+0x4af/0x940
creen.
[    3.839559] cciss 0000:02:04.0: DMA-API: device driver failed to check map error[device address=0x0000000038f521c0] [size=36 bytes] [mapped as single]
[    3.839563] Modules linked in: serio_raw cciss(+) pata_amd
[    3.839566] CPU: 0 PID: 193 Comm: kworker/0:2 Not tainted 4.9.0-0.rc2.git1.1.fc26.x86_64 #1
[    3.839567] Hardware name: HP ProLiant DL385 G1, BIOS A05 03/01/2006
[    3.839573] Workqueue: events work_for_cpu_fn
[    3.839577]  ffff9e9ec05938f8 ffffffff8546cd23 ffff9e9ec0593948 0000000000000000
[    3.839579]  ffff9e9ec0593938 ffffffff850af4cb 0000048c00000082 ffff8aa07ca0ea60
[    3.839582]  ffffffff87483a00 ffff8aa07b878180 0000000000000282 ffffffff85c5ad66
[    3.839582] Call Trace:
[    3.839588]  [<ffffffff8546cd23>] dump_stack+0x86/0xc3
[    3.839591]  [<ffffffff850af4cb>] __warn+0xcb/0xf0
[    3.839593]  [<ffffffff850af54f>] warn_slowpath_fmt+0x5f/0x80
[    3.839595]  [<ffffffff854a26ff>] check_unmap+0x4af/0x940
[    3.839597]  [<ffffffff854a2c09>] debug_dma_unmap_page+0x79/0xa0
[    3.839613]  [<ffffffffc032d427>] sendcmd_withirq_core+0x217/0x260 [cciss]
[    3.839618]  [<ffffffff85906820>] ? wait_for_completion+0x110/0x140
[    3.839623]  [<ffffffffc03301a8>] sendcmd_withirq+0x98/0xb0 [cciss]
[    3.839628]  [<ffffffffc033348f>] cciss_init_one+0x1a8f/0x1f70 [cciss]
[    3.839632]  [<ffffffff854ca4f5>] local_pci_probe+0x45/0xa0
[    3.839634]  [<ffffffff850cbd74>] work_for_cpu_fn+0x14/0x20
[    3.839637]  [<ffffffff850d020e>] process_one_work+0x23e/0x6f0
[    3.839638]  [<ffffffff850d018a>] ? process_one_work+0x1ba/0x6f0
[    3.839641]  [<ffffffff850d0893>] worker_thread+0x1d3/0x490
[    3.839642]  [<ffffffff850d06c0>] ? process_one_work+0x6f0/0x6f0
[    3.839644]  [<ffffffff850d06c0>] ? process_one_work+0x6f0/0x6f0
[    3.839648]  [<ffffffff850d7b52>] kthread+0x102/0x120
[    3.839652]  [<ffffffff85111175>] ? trace_hardirqs_on_caller+0xf5/0x1b0
[    3.839655]  [<ffffffff850d7a50>] ? kthread_park+0x60/0x60
[    3.839658]  [<ffffffff8590cbfa>] ret_from_fork+0x2a/0x40
[    3.839659] ---[ end trace 1ec289ff52b16fd7 ]---
[    3.839660] Mapped at:
[    3.839663]
[    3.839663] [<ffffffff854a131c>] debug_dma_map_page+0x8c/0x160
[    3.839668]
[    3.839668] [<ffffffffc032e75f>] fill_cmd+0x1bf/0x420 [cciss]
[    3.839672]
[    3.839672] [<ffffffffc0330174>] sendcmd_withirq+0x64/0xb0 [cciss]
[    3.839676]
[    3.839676] [<ffffffffc033348f>] cciss_init_one+0x1a8f/0x1f70 [cciss]
[    3.839679]
[    3.839679] [<ffffffff854ca4f5>] local_pci_probe+0x45/0xa0
[    3.859535] scsi host2: cciss

This problem does not appear when booting with 
kernel-4.9.0-0.rc2.git0.1.fc26.  It reproduces 100% of the time, simply 
try to boot kernel-4.9.0-0.rc2.git1.1.fc26 on a host with a CISS disk.

Thank you,
Johnny
