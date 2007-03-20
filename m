From: Stefan Priebe <stefan@prie.be>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
Date: Tue, 20 Mar 2007 13:23:58 +0100
Message-ID: <45FFD25E.10702@prie.be>
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com>
Reply-To: stefan@prie.be
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server077.de-nserver.de ([62.27.12.245]:46764 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXCTMYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 08:24:21 -0400
In-Reply-To: <200703201154.58234.olaf.kirch@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

 >  - on a 2.6.20 system, try "dd if=/dev/sdb of=/dev/null bs=4k count=1" or
 >    something like this (with NFS root) - does this crash, too?
no it does not crash it is also no problem to set the count= to 10000 or 
so or change the bs to 16k ...

 >  - do you have ACLs on files in /dev?
no

 >  - enable the sysrq key, make sure kernel messages go to the console
 >    by using "dmesg -n7", and when the kernel hangs, try sysrq-p, and
 >    sysrq-t
 >    (sysrq is documented in Documation/sysrq.txt in the kernel source)
 >  - try to capture the oops message - there must be one.

OK i've done the following:
1.) I've set up netconsole
2.) dmesg -n7
3.) fdisk /dev/sda
4.) sysrq-t / sysrq-p

So here is the output of -p and -t it hangs at nfs_sync_mapping_wait:
SysRq : Show Regs

Pid: 1598, comm:                fdisk
EIP: 0060:[<c03bf506>] CPU: 0
EIP is at _spin_lock+0x7/0xf
  EFLAGS: 00000286    Not tainted  (2.6.20.3 #6)
EAX: c3117afc EBX: c3117a2c ECX: 00000020 EDX: 00000000
ESI: f7b63ed4 EDI: f7b63f04 EBP: f7b63edc DS: 007b ES: 007b GS: 00d8
CR0: 8005003b CR2: b7f00f90 CR3: 033ea000 CR4: 000006d0
  [<c01b5c92>] nfs_sync_mapping_wait+0x83/0x1aa
  [<c01516c5>] cache_alloc_refill+0xc8/0x196
  [<c01b5eca>] nfs_sync_mapping_range+0x97/0xb6
  [<c01ae5cf>] nfs_getattr+0x3a/0x96
  [<c01ae595>] nfs_getattr+0x0/0x96
  [<c01565d9>] vfs_getattr+0x21/0x30
  [<c01566a3>] vfs_fstat+0x22/0x31
  [<c0156c51>] sys_fstat64+0xf/0x23
  [<c015da9c>] sys_ioctl+0x33/0x4b
  [<c0114358>] do_page_fault+0x0/0x549
  [<c010291c>] syscall_call+0x7/0xb
  [<c03b0033>] call_verify+0x182/0x36f
  =======================




SysRq : Show State

                          free                        sibling
   task             PC    stack   pid father child younger older
init          S C0117721     0     1      0     2               (NOTLB)
        c313fc48 00000082 c312fa90 c0117721 00100100 00200200 f7da9600 
f7941e40
        00000010 c313fc04 00000008 00000002 c3022700 c312fa90 c312fb9c 
000008dd
        64bf803e 00000029 c312f030 c313fc90 00000000 c30013c0 c03b3515 
c03b352f
Call Trace:
  [<c0117721>] default_wake_function+0x0/0xc
  [<c03b3515>] rpc_wait_bit_interruptible+0x0/0x1f
  [<c03b352f>] rpc_wait_bit_interruptible+0x1a/0x1f
  [<c03beb38>] __wait_on_bit+0x2c/0x51
  [<c03b3515>] rpc_wait_bit_interruptible+0x0/0x1f
  [<c03bebd0>] out_of_line_wait_on_bit+0x73/0x7b
  [<c012c950>] wake_bit_function+0x0/0x3c
  [<c012c950>] wake_bit_function+0x0/0x3c
  [<c03b3c6a>] __rpc_execute+0xdb/0x18b
  [<c03b354d>] rpc_set_active+0x19/0x57
  [<c03af1ef>] rpc_call_sync+0x71/0x98
  [<c01b1824>] nfs_proc_getattr+0x5b/0x7f
  [<c01ae981>] __nfs_revalidate_inode+0xe7/0x21a
  [<c01ad415>] nfs_permission+0x0/0x133
  [<c01ad415>] nfs_permission+0x0/0x133
  [<c01ad527>] nfs_permission+0x112/0x133
  [<c01ad415>] nfs_permission+0x0/0x133
  [<c0159928>] permission+0x94/0xa2
  [<c0159e57>] __link_path_walk+0x6c/0xa59
  [<c013e20c>] __alloc_pages+0x4a/0x2a3
  [<c015a883>] link_path_walk+0x3f/0xa4
  [<c015abc5>] do_path_lookup+0x170/0x18b
  [<c015ae0c>] __user_walk_fd+0x2d/0x43
  [<c0156601>] vfs_stat_fd+0x19/0x40
  [<c0156c0b>] sys_stat64+0xf/0x23
  [<c02456d4>] copy_to_user+0x2f/0x37
  [<c01234f6>] do_gettimeofday+0x35/0x119
  [<c011f93e>] sys_time+0x1e/0x2e
  [<c010291c>] syscall_call+0x7/0xb
  =======================
ksoftirqd/0   S C33442C0     0     3      1             4     2 (L-TLB)
        c3149fb8 00000046 c013cd73 c33442c0 00000000 c30131e0 00000003 
f7931900
        c301321c 00000000 c33f5030 00000000 c3012700 c3136030 c313613c 
000001d9
        a733fbbd 00000004 c04a8cc0 c0539380 c0539380 c0120494 fffffffc 
c01204d6
Call Trace:
  [<c013cd73>] mempool_free+0x65/0x6a
  [<c0120494>] ksoftirqd+0x0/0xa7
  [<c01204d6>] ksoftirqd+0x42/0xa7
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
migration/1   S F745BF24     0     4      1             5     3 (L-TLB)
        c314bfb0 00000046 00000092 f745bf24 00000001 f745bf70 c314bf94 
f7ab03c0
        00000000 00000001 f745bf74 00000001 c301a700 c3139a90 c3139b9c 
000023c5
        b7d09ccb 00000004 c312f560 c301b054 c301a700 00000001 c314bfc4 
c0118643
Call Trace:
  [<c0118643>] migration_thread+0x7a/0xd2
  [<c01185c9>] migration_thread+0x0/0xd2
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
ksoftirqd/1   S C301B1A0     0     5      1             6     4 (L-TLB)
        c316ffb8 00000046 00000000 c301b1a0 00000008 c012a884 c301b1e0 
f7f39040
        c012aa25 c301b21c 00000000 00000001 c301a700 c3139560 c313966c 
00000c4f
        48c808e9 00000004 c312f560 c0539380 c0539380 c0120494 fffffffc 
c01204d6
Call Trace:
  [<c012a884>] rcu_do_batch+0x1a/0x7f
  [<c012aa25>] __rcu_process_callbacks+0x8f/0xa1
  [<c0120494>] ksoftirqd+0x0/0xa7
  [<c01204d6>] ksoftirqd+0x42/0xa7
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
migration/2   S F7B63F24     0     6      1             7     5 (L-TLB)
        c3171fb0 00000046 00000092 f7b63f24 00000001 f7b63f70 c3171f94 
f79703c0
        00000000 00000001 f7b63f74 00000002 c3022700 c3139030 c313913c 
000011f0
        482d3411 00000022 c312f030 c3023054 c3022700 00000002 c3171fc4 
c0118643
Call Trace:
  [<c0118643>] migration_thread+0x7a/0xd2
  [<c01185c9>] migration_thread+0x0/0xd2
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
ksoftirqd/2   S C324D780     0     7      1             8     6 (L-TLB)
        c3175fb8 00000046 c013cd73 c324d780 00000000 c30231e0 00000003 
f7ba2740
        c302321c 00000000 c053ab90 00000002 c3022700 c3155a90 c3155b9c 
00000564
        610707d5 00000004 c312f030 c0539380 c0539380 c0120494 fffffffc 
c01204d6
Call Trace:
  [<c013cd73>] mempool_free+0x65/0x6a
  [<c0120494>] ksoftirqd+0x0/0xa7
  [<c01204d6>] ksoftirqd+0x42/0xa7
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
migration/3   S F74F1F24     0     8      1             9     7 (L-TLB)
        c3177fb0 00000046 00000092 f74f1f24 00000001 f74f1f70 c3177f94 
f7ab03c0
        00000000 00000001 f74f1f74 00000003 c302a700 c3155560 c315566c 
00000ea1
        b2116928 00000004 c3136a90 c302b054 c302a700 00000003 c3177fc4 
c0118643
Call Trace:
  [<c0118643>] migration_thread+0x7a/0xd2
  [<c01185c9>] migration_thread+0x0/0xd2
  [<c012c5e6>] kthread+0x72/0x96
  [<c012c574>] kthread+0x0/0x96
  [<c01034f7>] kernel_thread_helper+0x7/0x10
  =======================
ksoftirqd/3   S C317BFC4     0     9      1            10     8 (L-TLB)
        c317bfb8 00000046 c03be392 c317bfc4 00000046 00000086 c313fee8 
00000002 c312f560 kthread+0x72/0x96
0000002e schedule_timeout+0x70/0x8d
00000082 prep_new_page+0xb2/0xea
  [<c02456d4>] inet_csk_accept+0x51/0x125


Stefan


Olaf Kirch schrieb:
 > On Tuesday 20 March 2007 11:59, Stefan Priebe wrote:
 >> Kernel command line: nfs root=/dev/nfs nfsroot=192.168.0.100:/PXE/debian
 >> ip=dhcp
 >
 > Some things that may be worth trying:
 >
 >  - on a 2.6.20 system, try "dd if=/dev/sdb of=/dev/null bs=4k count=1" or
 >    something like this (with NFS root) - does this crash, too?
 >
 >  - do you have ACLs on files in /dev?
 >
 >  - enable the sysrq key, make sure kernel messages go to the console
 >    by using "dmesg -n7", and when the kernel hangs, try sysrq-p, and 
sysrq-t
 >    (sysrq is documented in Documation/sysrq.txt in the kernel source)
 >
 >  - try to capture the oops message - there must be one.
 >
 > Olaf

