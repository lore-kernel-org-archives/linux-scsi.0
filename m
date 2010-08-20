From: =?ISO-8859-15?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Maybe a bug in libata-core
Date: Fri, 20 Aug 2010 23:48:09 +0200
Message-ID: <4C6EF819.4000202@stud.tu-ilmenau.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:49776 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0HTWDP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2010 18:03:15 -0400
Received: from [192.168.178.20] (erft-5d80defb.pool.mediaWays.net [93.128.222.251])
	(authenticated bits=0)
	by wega.rz.tu-ilmenau.de (8.12.11/8.12.11/Debian-3) with ESMTP id o7KLmJmP015534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2010 23:48:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 Hi List!

After sending a WRITE_DMA_FUA_EXT ATA-command via SG_IO Passthru to a
harddisk (here: /dev/sdd), my kernel panics.  The is what I find in syslog:

Aug 20 23:29:49 dobbelherz kernel: ------------[ cut here ]------------
Aug 20 23:29:49 dobbelherz kernel: kernel BUG at
drivers/ata/libata-core.c:5136!
Aug 20 23:29:49 dobbelherz kernel: invalid opcode: 0000 [#1] SMP
Aug 20 23:29:49 dobbelherz kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.5/0000:02:00.0/host7/target7:0:0/7:0:0:0/block/sdd/dev
Aug 20 23:29:49 dobbelherz kernel: CPU 0
Aug 20 23:29:49 dobbelherz kernel: Modules linked in: snd_seq
snd_seq_device cifs nls_iso8859_15 nls_cp1250 vfat fat vboxdrv nvidia(P)
arc4 ecb snd_h
da_intel rtl8187 snd_hda_codec snd_ctxfi snd_hwdep mac80211 snd_pcm
cfg80211 snd_timer 8250_pnp ahci snd 8250 rtc_cmos eeprom_93cx6 libahci
rtc_core
serial_core soundcore snd_page_alloc rtc_lib
Aug 20 23:29:49 dobbelherz kernel:
Aug 20 23:29:49 dobbelherz kernel: Pid: 2764, comm: scsi Tainted:
P            2.6.35-gentoo-r1-dobbelherz #2 P5W DH Deluxe/P5W DH Deluxe
Aug 20 23:29:49 dobbelherz kernel: RIP: 0010:[<ffffffff81250a56>] 
[<ffffffff81250a56>] ata_qc_issue+0x286/0x330
Aug 20 23:29:49 dobbelherz kernel: RSP: 0018:ffff88004a0299b8  EFLAGS:
00010046
Aug 20 23:29:49 dobbelherz kernel: RAX: 0000000000000002 RBX:
ffff88007b588128 RCX: 0000000000000000
Aug 20 23:29:49 dobbelherz kernel: RDX: ffff88007b589d38 RSI:
00000000ffffffe1 RDI: ffff88007b588128
Aug 20 23:29:49 dobbelherz kernel: RBP: ffff88007b588000 R08:
0000000000000000 R09: 0000000000000000
Aug 20 23:29:49 dobbelherz kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffff88007b589d38
Aug 20 23:29:49 dobbelherz kernel: R13: 0000000000000002 R14:
0000000000000002 R15: ffffffff81235b90
Aug 20 23:29:49 dobbelherz kernel: FS:  00007fffed71b710(0000)
GS:ffff880001600000(0000) knlGS:0000000000000000
Aug 20 23:29:49 dobbelherz kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Aug 20 23:29:49 dobbelherz kernel: CR2: 00007f753cdc12b8 CR3:
000000007d6af000 CR4: 00000000000006f0
Aug 20 23:29:49 dobbelherz kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 20 23:29:49 dobbelherz kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 20 23:29:49 dobbelherz kernel: Process scsi (pid: 2764, threadinfo
ffff88004a028000, task ffff88005500b480)
Aug 20 23:29:49 dobbelherz kernel: Stack:
Aug 20 23:29:49 dobbelherz kernel: ffff880001611e00 ffff88007ade32f0
0000000000000000 ffff88007b588128
Aug 20 23:29:49 dobbelherz kernel: <0> 0000000000000000 ffff88007b589ea8
ffffffff812585c0 ffff88007b588000
Aug 20 23:29:49 dobbelherz kernel: <0> ffffffff81235b90 ffffffff81255a80
ffffffffffffffff ffff88007f2088c0
Aug 20 23:29:49 dobbelherz kernel: Call Trace:
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff812585c0>] ?
ata_scsi_pass_thru+0x0/0x300
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81235b90>] ? scsi_done+0x0/0x20
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81255a80>] ?
ata_scsi_translate+0xa0/0x190
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81235b90>] ? scsi_done+0x0/0x20
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81258e6b>] ?
ata_scsi_queuecmd+0xab/0x2b0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81235c99>] ?
scsi_dispatch_cmd+0xe9/0x240
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff8123bb21>] ?
scsi_request_fn+0x3e1/0x530
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff811784f0>] ?
__blk_run_queue+0x50/0x140
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81175e0b>] ?
elv_insert+0x10b/0x1a0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff8117c569>] ?
blk_execute_rq_nowait+0x59/0xb0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff8117c621>] ?
blk_execute_rq+0x61/0xb0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81178ea3>] ?
get_request_wait+0x23/0x140
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81180472>] ? sg_io+0x212/0x3d0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81180ce7>] ?
scsi_cmd_ioctl+0x2c7/0x490
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81365e7f>] ?
schedule+0x23f/0x6a0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff81243e32>] ? sd_ioctl+0x92/0xf0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff8117dfe1>] ?
__blkdev_driver_ioctl+0xa1/0xe0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff8117e49b>] ?
blkdev_ioctl+0x20b/0x7e0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810af700>] ?
cp_new_stat+0xe0/0x100
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810d6ed7>] ?
block_ioctl+0x37/0x40
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810ba165>] ?
vfs_ioctl+0x35/0xd0
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810ba328>] ?
do_vfs_ioctl+0x88/0x530
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810af7f1>] ?
sys_newstat+0x31/0x50
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810ba819>] ?
sys_ioctl+0x49/0x80
Aug 20 23:29:49 dobbelherz kernel: [<ffffffff810023eb>] ?
system_call_fastpath+0x16/0x1b
Aug 20 23:29:49 dobbelherz kernel: Code: ff ff 0f 1f 00 4c 8b 35 89 13
25 00 e9 81 fe ff ff 48 83 bb a0 00 00 00 00 74 10 83 7b 54 00 74 0a 83
7b 64 00 0f 85 25 fe ff ff <0f> 0b eb fe 49 8d 7c 24 28 41 83 4c 24 38
06 48 c7 c6 0b 81 43
Aug 20 23:29:49 dobbelherz kernel: RIP  [<ffffffff81250a56>]
ata_qc_issue+0x286/0x330
Aug 20 23:29:49 dobbelherz kernel: RSP <ffff88004a0299b8>
Aug 20 23:29:49 dobbelherz kernel: ---[ end trace bb586d9f3dc3cf97 ]---

Please tell me if you need any more docs for a fix...

Cheers,
Stefan
