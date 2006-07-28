From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: failed drive with adaptec 2005S raid controller
Date: Fri, 28 Jul 2006 17:23:03 -0400
Message-ID: <20060728212303.GB19563@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:25001 "EHLO
	pickle.fieldses.org") by vger.kernel.org with ESMTP
	id S1161309AbWG1VXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 17:23:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kevin Coffman <kwc@citi.umich.edu>, Olga Kornievskaia <aglo@citi.umich.edu>

We recently getting a lot of kernel oopses on one of our servers.  It's
acting as both an NFS server and client, usually running our latest
NFSv4 code, so our first impulse was to assume the fault was ours.

But we eventually noticed that one of the disks in the RAID 1 array that
we're exporting had actually failed without our realizing it.  Replacing
the disk seemed to fix the problems.

Of course we expect bad things to happen in that situation, but I assume
a failed disk shouldn't cause kernel crashes.

More details appended below, with sample oopses from our logs; let us
know if any more information would be useful.  Unfortunately, we need
this machine for other work so we probably can't afford to swap the bad
disk back in to reproduce the problem, but maybe this is of use to
someone?

--b.

----- Forwarded message from Kevin Coffman <kwc@citi.umich.edu> -----

Date: Thu, 27 Jul 2006 13:50:58 -0400
From: Kevin Coffman <kwc@citi.umich.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: screamer disk error fallout
Cc: Olga Kornievskaia <aglo@citi.umich.edu>,
	Andy Adamson <andros@citi.umich.edu>,
	Kevin Coffman <kwc@citi.umich.edu>

The solution seems to have been replacing a failed disk in the RAID 1
array, /dev/sdb.

Raid controller: Adaptec 2005S
Disk drives in array: Seagate ST373405LCV

Kernel config is attached.  Let me know what other info would be helpful.


$ df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1               497829    302572    169555  65% /
/dev/sda7               497829      8288    463839   2% /home
none                    254724         0    254724   0% /dev/shm
/dev/sda9               295564      8250    272054   3% /tmp
/dev/sda2              4127108   2054508   1862952  53% /usr
/dev/sda3              4127108    178284   3739176   5% /usr/local
/dev/sda5              4127076    249056   3668376   7% /usr/src
/dev/sda8               497829    129403    342724  28% /var
/dev/sdb1             69436796  25518876  40333824  39% /export/home
/dev/sdc1             70557052     32816  66940140   1%
/export/home/OSG-ITB/Data
/dev/sdd1             17639220     32816  16710384   1%
/export/home/OSG-ITB/Temp-shared
/bakeathon              497829    302572    169555  65% /export/bakeathon
troy:/vol/home       429496736 205484720 224012016  48% /nfs/home
novi:/vol/backup     943718400 816932992 126785408  87% /nfs/backup
$

$ /sbin/lspci
00:00.0 Host bridge: Broadcom CNB20HE Host Bridge (rev 23)
00:00.1 PCI bridge: Broadcom CNB20LE Host Bridge (rev 01)
00:00.2 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
00:00.3 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
00:03.0 RAID bus controller: Adaptec (formerly DPT) SmartRAID V
Controller (rev 01)
00:04.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro
100] (rev 08)
00:06.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro
100] (rev 08)
00:0f.0 ISA bridge: Broadcom CSB5 South Bridge (rev 93)
00:0f.1 IDE interface: Broadcom CSB5 IDE Controller (rev 93)
00:0f.2 USB Controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 05)
00:0f.3 Host bridge: Broadcom CSB5 LPC bridge
01:00.0 VGA compatible controller: ATI Technologies Inc Rage XL AGP 2X (rev 
27)
02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5701
Gigabit Ethernet (rev 15)
$

A sampling of the oops

******************************************************************************************

dereference at virtual address 00000528
 printing eip:
c1055efa
*pde = 1fe3a001
Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c1055efa>]    Not tainted VLI
EFLAGS: 00010206   (2.6.17-CITI_NFS4_ALL-1 #1)
EIP is at sync_buffer+0xc/0x33
eax: 00000524   ebx: db073b10   ecx: db073b24   edx: c8f53a4c
esi: db073b10   edi: c1e25888   ebp: c1055eee   esp: db073acc
ds: 007b   es: 007b   ss: 0068
Process nfsd (pid: 2877, threadinfo=db073000 task=db072ab0)
Stack: c152a198 db073b10 c8f53a4c db073b0c 00000002 c152a235 00000002
c1055eee
     c1e25888 00000000 00000000 00000000 00000000 00000000 00000000
00000000
     00000110 c8f53a4c 00000002 00000001 db072ab0 c102ba58 c1e25898
c1e25898
Call Trace:
<c152a198> __wait_on_bit_lock+0x2a/0x52  <c152a235>
out_of_line_wait_on_bit_lock+0x75/0x7d
<c1055eee> sync_buffer+0x0/0x33  <c102ba58> wake_bit_function+0x0/0x3c
<c105603c> __lock_buffer+0x21/0x24  <c10c7d70>
journal_invalidatepage+0x8f/0x338
<c10bb490> ext3_invalidatepage+0x0/0x2d  <c1054c1d>
do_invalidatepage+0x16/0x18 <c103e62b> truncate_complete_page+0x18/0x3a
<c103e6f1> truncate_inode_pages_range+0xa4/0x266
<c103e8bc> truncate_inode_pages+0x9/0xd  <c10bb92a>
ext3_delete_inode+0x13/0xba <c10bb917> ext3_delete_inode+0x0/0xba
<c1068e99> generic_delete_inode+0x90/0xfc
 <c106895f> iput+0x64/0x66  <c1068457> d_delete+0x3c/0xcb
<c105fdd2> vfs_unlink+0x96/0xb5  <c1117977> nfsd_unlink+0x1a2/0x1fa
<c11226d2> nfsd4_proc_compound+0xe83/0x15ad  <c14d4afb>
ipt_do_table+0x2b7/0x2e0
<c1238118> copy_to_user+0x4a/0x5e  <c1477d2c> memcpy_toiovec+0x27/0x4a
<c104fdbd> cache_free_debugcheck+0x1f7/0x1ff  <c1473cd6>
release_sock+0x10/0x9b <c14a93ba> tcp_recvmsg+0x622/0x72b  <c1473a1e>
sock_common_recvmsg+0x2f/0x45
<c1471f8b> sock_recvmsg+0xc9/0xe4  <c102ba2b>
autoremove_wake_function+0x0/0x2d <c1017096> activate_task+0x5a/0xa0
<c10173f2> try_to_wake_up+0x316/0x320
<c1016442> __wake_up_common+0x2f/0x53  <c1018091> __wake_up+0x2a/0x3d
<c1508d8d> svc_sock_enqueue+0x1db/0x219  <c150a229>
svc_tcp_recvfrom+0x672/0x6dd
<c152b2f0> _spin_unlock_irq+0x5/0x7  <c152991f> schedule+0xa1b/0xa7c
<c150d729> sunrpc_cache_lookup+0x4b/0xf9  <c1124a4d>
nfsd4_decode_compound+0x2fe/0xce1
<c1125430> nfs4svc_decode_compoundargs+0x0/0x50  <c1114e8f>
nfsd_dispatch+0xbb/0x170
 <c150829d> svc_process+0x3b2/0x60d  <c1115292> nfsd+0x190/0x2ea
 <c1115102> nfsd+0x0/0x2ea  <c10016c5> kernel_thread_helper+0x5/0xb
Code: 30 85 c0 75 07 89 d8 e8 90 ff ff ff f0 0f ba 33 03 89 d8 5b 5e 5f
e9 d9 f0 ff ff 5b 5e 5f c3 f0 83 04 24 00 8b 40 1c 85 c0 74 1f <8b> 40
04 8b 80 e4 00 00 00 85 c0 74 12 8b 40 58 85 c0 74 0b 8b
EIP: [<c1055efa>] sync_buffer+0xc/0x33 SS:ESP 0068:db073acc
 BUG: nfsd/2877, lock held at task exit time!
[db2be340] {inode_init_once}
.. held by:              nfsd: 2877 [db072ab0, 116]
... acquired at:               nfsd_unlink+0xd0/0x1fa
BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
6b6b6b6b
*pde = 6b6b6b6b
Oops: 0000 [#2]
SMP
CPU:    1
EIP:    0060:[<6b6b6b6b>]    Not tainted VLI
EFLAGS: 00010012   (2.6.17-CITI_NFS4_ALL-1 #1)
EIP is at 0x6b6b6b6b
eax: db073b18   ebx: db073b18   ecx: 00000000   edx: 00000003
esi: 6b6b6b6b   edi: 00000001   ebp: c1850e8c   esp: c1850e6c
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c1850000 task=dffcc550)
Stack: c1016442 c1850ebc 00000003 c1e25888 6b6b6b6b c1e25888 c1850ebc 
00000001
     c1850eb0 c1018091 00000000 c1850ebc 00000003 00000296 c1e25888 00001000
     c1056603 00000000 c102ba10 c1850ebc c9f53b4c 00000002 ca583f90 c1056631
Call Trace:
<c1016442> __wake_up_common+0x2f/0x53
<c1018091> __wake_up+0x2a/0x3d
<c1056603> end_bio_bh_io_sync+0x0/0x39
<c102ba10> __wake_up_bit+0x29/0x2e
<c1056631> end_bio_bh_io_sync+0x2e/0x39
<c1058218> bio_endio+0x50/0x55
<c122938d> __end_that_request_first+0x184/0x478
<c104fdbd> cache_free_debugcheck+0x1f7/0x1ff
<c13746d4> scsi_end_request+0x1e/0xad
<c137497e> scsi_io_completion+0x21b/0x3f1
<c1402077> sd_rw_intr+0x27e/0x2a0
<c1370592> scsi_finish_command+0xb8/0xbd
<c122abed> blk_done_softirq+0x5d/0x69
<c1020887> __do_softirq+0x58/0xc2
<c10056f2> do_softirq+0x46/0x50
=======================
<c10056a3> do_IRQ+0x72/0x7b  <c1003c3a> common_interrupt+0x1a/0x20
<c10024a7> default_idle+0x0/0x55  <c10024d3> default_idle+0x2c/0x55
<c1002555> cpu_idle+0x59/0x6e
Code:  Bad EIP value.
EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:c1850e6c
<0>Kernel panic - not syncing: Fatal exception in interrupt
 BUG: warning at arch/i386/kernel/smp.c:537/smp_call_function()
<c100d4a2> smp_call_function+0x52/0xc0
<c101ccda> printk+0x14/0x18
<c100d523> smp_send_stop+0x13/0x1c
<c101c388> panic+0x45/0xdd
<c10045e2> die+0x242/0x276
<c101263b> do_page_fault+0x512/0x60a
<c1017096> activate_task+0x5a/0xa0
<c1012129> do_page_fault+0x0/0x60a
<c1003d93> error_code+0x4f/0x54
<c1016442> __wake_up_common+0x2f/0x53
<c1018091> __wake_up+0x2a/0x3d
<c1056603> end_bio_bh_io_sync+0x0/0x39
<c102ba10> __wake_up_bit+0x29/0x2e
<c1056631> end_bio_bh_io_sync+0x2e/0x39
<c1058218> bio_endio+0x50/0x55
<c122938d> __end_that_request_first+0x184/0x478
<c104fdbd> cache_free_debugcheck+0x1f7/0x1ff
<c13746d4> scsi_end_request+0x1e/0xad
<c137497e> scsi_io_completion+0x21b/0x3f1
<c1402077> sd_rw_intr+0x27e/0x2a0
<c1370592> scsi_finish_command+0xb8/0xbd
<c122abed> blk_done_softirq+0x5d/0x69
<c1020887> __do_softirq+0x58/0xc2
<c10056f2> do_softirq+0x46/0x50
=======================
<c10056a3> do_IRQ+0x72/0x7b
<c1003c3a> common_interrupt+0x1a/0x20
<c10024a7> default_idle+0x0/0x55
<c10024d3> default_idle+0x2c/0x55
<c1002555> cpu_idle+0x59/0x6e


******************************************************************************************

 printing eip: c10c7c6a *pde = 6b6b6b6b
Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c10c7c6a>]    Not tainted VLI
EFLAGS: 00010a93   (2.6.17-CITI_NFS4_ALL-1 #2)
EIP is at journal_invalidatepage+0x55/0x338
eax: 47006c63   ebx: 62755374   ecx: 00000002   edx: 00000002
esi: 00000001   edi: c19d6b30   ebp: 00000414   esp: db593b4c
ds: 007b   es: 007b   ss: 0068
Process nfsd (pid: 2875, threadinfo=db592000 task=db58ea70)
Stack: 00000000 c19d6b30 de760454 62755374 00000001 47006c63 c61a01cc 
c10bb3c3
     00000008 c19d6b30 00000414 c1054b5d c19d6b30 c103e567 00000414 c103e62d
     00000000 00000000 00000000 c5c1c8d4 00000000 ffffffff 0000000e 00000000
Call Trace:
<c10bb3c3> ext3_invalidatepage+0x0/0x2d
<c1054b5d> do_invalidatepage+0x16/0x18
<c103e567> truncate_complete_page+0x18/0x3a
<c103e62d> truncate_inode_pages_range+0xa4/0x266
<c103e7f8> truncate_inode_pages+0x9/0xd
<c10bb85d> ext3_delete_inode+0x13/0xba
<c10bb84a> ext3_delete_inode+0x0/0xba
<c1068dd9> generic_delete_inode+0x90/0xfc
<c106889f> iput+0x64/0x66
<c1068397> d_delete+0x3c/0xcb
<c105fd12> vfs_unlink+0x96/0xb5
<c11178b7> nfsd_unlink+0x1a2/0x1fa
<c1122612> nfsd4_proc_compound+0xe83/0x15ad
<c14d4a53> ipt_do_table+0x2b7/0x2e0
<c1238050> copy_to_user+0x4a/0x5e
<c1477c8c> memcpy_toiovec+0x27/0x4a
<c104fcf9> cache_free_debugcheck+0x1f7/0x1ff
<c1473c36> release_sock+0x10/0x9b
<c14a9312> tcp_recvmsg+0x622/0x72b
<c147397e> sock_common_recvmsg+0x2f/0x45
<c1471eeb> sock_recvmsg+0xc9/0xe4
<c102b967> autoremove_wake_function+0x0/0x2d
<c1016f9a> activate_task+0x5a/0xa0
<c10172f6> try_to_wake_up+0x316/0x320
<c1016346> __wake_up_common+0x2f/0x53
<c1017f95> __wake_up+0x2a/0x3d
<c1508ce9> svc_sock_enqueue+0x1db/0x219
<c150a185> svc_tcp_recvfrom+0x672/0x6dd
<c152b250> _spin_unlock_irq+0x5/0x7
<c152987f> schedule+0xa1b/0xa7c
<c150d685> sunrpc_cache_lookup+0x4b/0xf9
<c112498d> nfsd4_decode_compound+0x2fe/0xce1
<c1125370> nfs4svc_decode_compoundargs+0x0/0x50
<c1114dcf> nfsd_dispatch+0xbb/0x170
<c15081f9> svc_process+0x3b2/0x60d
<c11151d2> nfsd+0x190/0x2ea
<c1115042> nfsd+0x0/0x2ea
<c10016c5> kernel_thread_helper+0x5/0xb
Code: 84 01 03 00 00 8b 02 f6 c4 08 75 08 0f 0b 6d 07 6e 35 5a c1 8b 44
24 04 8b 40 0c c7 44 24 10 01 00 00 00 89 44 24 18 89 c3 31 c0 <8b> 53
14 01 c2 89 54 24 14 8b 53 04 39 04 24 89 54 24 0c 0f 87
EIP: [<c10c7c6a>] journal_invalidatepage+0x55/0x338
SS:ESP 0068:db593b4c
BUG: nfsd/2875, lock held at task exit time!
[dc6aa710] {inode_init_once}
.. held by:              nfsd: 2875 [db58ea70, 115]
... acquired at:               nfsd_unlink+0xd0/0x1fa



----- End forwarded message -----
