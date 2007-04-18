From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: iSCSI fun in 2.6.21-rc6
Date: Wed, 18 Apr 2007 16:22:14 +0200
Message-ID: <200704181622.16171.olaf.kirch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:61012 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602AbXDROXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 10:23:14 -0400
Received: from rgmgw3.us.oracle.com (rgmgw3.us.oracle.com [138.1.186.112])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l3IENCwe010266
	for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2007 09:23:12 -0500
Received: from acsmt350.oracle.com (acsmt350.oracle.com [141.146.40.150])
	by rgmgw3.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l3IEA0HG005957
	for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2007 08:23:11 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I tried to use the iSCSI initiator with iscsitarget on 2.6.21-rc6 today,
with rather mixed results.

I could log in okay, and a device would appear. Trying to mount
that device would hang though:

kernel: iscsi: ctask enq [read cid 0 sc df57e500 cdb 0x28 itt 0x1c len 4096 cmdsn 29 win 33]
kernel: iscsi: cmdrsp [op 0x25 cid 0 itt 0x1c len 0]
...
kernel: iscsi: ctask enq [read cid 0 sc df57e500 cdb 0x28 itt 0x2b len 4096 cmdsn 44 win 33]
kernel: iscsi: cmdrsp [op 0x25 cid 0 itt 0x2b len 0]
kernel: kjournald starting.  Commit interval 5 seconds
kernel: iscsi: ctask enq [write cid 0 sc df57e500 cdb 0x2a itt 0x2c len 4096 cmdsn 45 win 33]

Nothing in the logs. tcpdump shows lots of data being transmitted, and tracing
iscsitarget shows a storm of data_out commands being received.

60 seconds later:
kernel: iscsi: aborting [sc df57e500 itt 0x2c]

and again, nothing - mount still hangs. I shut down both iscsitarget and
the initiator. Surprisingly, the mount command now finishes, and /proc/mounts
shows that the device was mounted successfully. Gingerly, I unmount the device:

scsi 3:0:0:0: rejecting I/O to dead device
Buffer I/O error on device sdc, logical block 0
lost page write due to I/O error on sdc
BUG: unable to handle kernel paging request at virtual address e101e200
 printing eip:
e085509f
*pde = 13840067
Oops: 0000 [#1]
SMP
Modules linked in: crc32c libcrc32c cpufreq_ondemand cpufreq_userspace cpufreq_pow
ersave p4_clockmod speedstep_lib freq_table ipv6 af_packet edd button snd_seq snd_seq_device battery ac nls_iso88
59_1 nls_cp437 vfat fat nls_base loop dm_mod i2c_i801 snd_intel8x0 snd_ac97_codec ac97_bus e100 snd_pcm snd_timer
 snd mii i2c_core soundcore intel_rng ehci_hcd intel_agp snd_page_alloc rng_core uhci_hcd agpgart usbcore ide_cd
cdrom ext3 jbd fan thermal sg processor ata_piix libata piix sd_mod scsi_mod ide_disk ide_core
CPU:    1
EIP:    0060:[<e085509f>]    Not tainted VLI
EFLAGS: 00010286   (2.6.21-rc6-smp #4)
EIP is at scsi_device_put+0x9/0x2e [scsi_mod]
eax: e101e200   ebx: c44a94c8   ecx: dff2f680   edx: 00000001
esi: df33c000   edi: c44a93c0   ebp: dec0504c   esp: dfa3bee8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process umount (pid: 7068, ti=dfa3a000 task=d13f91c0 task.ti=dfa3a000)
Stack: c44a94c8 df33c000 e0817360 c44a94c0 df33c000 e0817c9c dec0504c c0156d2e
       00000000 dec05040 c018afe3 c0151186 dec050b0 c31dfe00 e0e2d0a0 00000000
       00000000 c016da2d dfa298c0 c31dfe00 c017e8bb 00000001 cdfcf2a0 dfa298c0
Call Trace:
 [<e0817360>] scsi_disk_put+0x22/0x2e [sd_mod]
 [<e0817c9c>] sd_release+0x69/0x70 [sd_mod]
 [<c0156d2e>] truncate_inode_pages+0x17/0x1a
 [<c018afe3>] __blkdev_put+0x5b/0x103
 [<c0151186>] filemap_write_and_wait+0x1f/0x29
 [<c016da2d>] deactivate_super+0x51/0x64
 [<c017e8bb>] sys_umount+0x1f1/0x219
 [<c016eda2>] sys_stat64+0xf/0x23
 [<c02b4e91>] do_page_fault+0x28c/0x4ed
 [<c015e3be>] do_munmap+0x193/0x1ac
 [<c017e8fa>] sys_oldumount+0x17/0x1a
 [<c0104de4>] syscall_call+0x7/0xb
 [<c02b0000>] unix_stream_connect+0x3f/0x363
 =======================
Code: 40 75 05 39 6a 44 74 13 8d 51 f8 8b 4a 08 0f 18 01 90 8d 42 08 39 d8 75 e0 3
1 d2 5b 89 d0 5e 5f 5d c3 56 89 c6 53 8b 00 8b 40 5c <8b> 18 85 db 74 12 89 d8 e8 f7 73 8e df 85 c0 74 07 89 d8 e
8 67
EIP: [<e085509f>] scsi_device_put+0x9/0x2e [scsi_mod] SS:ESP 0068:dfa3bee8

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
