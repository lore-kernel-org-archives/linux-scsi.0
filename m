From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: spurious use after free bug in dio_bio_complete on scsi disks (with
 multipath)
Date: Fri, 22 Jan 2016 12:14:56 +0100
Message-ID: <56A20F30.4050705@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

When I enable DEBUG_PAGEALLOC (notice: needs also enablement on the command line)
I get spurious warnings like the following

[ 2664.756567] Unable to handle kernel pointer dereference in virtual kernel address space
[ 2664.756575] failing address: 000000f9ef84c000 TEID: 000000f9ef84c803
[ 2664.756577] Fault in home space mode while using kernel ASCE.
[ 2664.756582] AS:0000000000f8b007 R3:000000ff62c03007 S:000000ff62887000 P:000000f9ef84c400 
[ 2664.756618] Oops: 0011 ilc:2 [#1] SMP DEBUG_PAGEALLOC
[ 2664.756629] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc btrfs xor raid6_pq ghash_s390 prng ecb aes_s390 des_s390 des_generic sha512_s390 sha256_s390 sha1_s390 sha_common eadm_sch nfsd auth_rpcgss oid_registry nfs_acl lockd grace vhost_net tun vhost macvtap macvlan sunrpc dm_service_time dm_multipath dm_mod autofs4
[ 2664.756721] CPU: 33 PID: 0 Comm: swapper/33 Not tainted 4.4.0+ #117
[ 2664.756726] task: 000000fa6e86e0a0 ti: 000000fa6e870000 task.ti: 000000fa6e870000
[ 2664.756731] Krnl PSW : 0704e00180000000 000000000034efba (dio_bio_complete+0xf2/0x100)
[ 2664.756743]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:3
               Krnl GPRS: 0000000000000000 000000fa6e870000 0000000000000001 0000000000000000
[ 2664.756751]            000000000034efba 0000000000000000 0000000000000000 000000fa59ff2bc8
[ 2664.756754]            000000fa4e6a5f00 000000f9ef84ce00 000000fa00001000 000000fa4e6a5f38
[ 2664.756757]            0000000000001000 0000000000841a88 000000000034efba 000000fa6de6bbe8
[ 2664.756770] Krnl Code: 000000000034efac: a784ffb6            brc     8,34ef18
                          000000000034efb0: b9040029            lgr     %r2,%r9
                         #000000000034efb4: c0e5000f064e        brasl   %r14,52fc50
                         >000000000034efba: 58c09014            l       %r12,20(%r9)
                          000000000034efbe: a7f4ffec            brc     15,34ef96
                          000000000034efc2: 0707                bcr     0,%r7
                          000000000034efc4: 0707                bcr     0,%r7
                          000000000034efc6: 0707                bcr     0,%r7
[ 2664.756826] Call Trace:
[ 2664.756829] ([<000000000034efba>] dio_bio_complete+0xf2/0x100)
[ 2664.756833]  [<000000000034f26a>] dio_bio_end_aio+0x42/0x168
[ 2664.756837]  [<0000000000538b0a>] blk_update_request+0x102/0x468
[ 2664.756842]  [<0000000000607f20>] scsi_end_request+0x48/0x1d0
[ 2664.756845]  [<0000000000609b88>] scsi_io_completion+0x110/0x690
[ 2664.756849]  [<0000000000542186>] blk_done_softirq+0xb6/0xd0
[ 2664.756854]  [<0000000000165e3c>] __do_softirq+0xd4/0x4b0
[ 2664.756856]  [<00000000001665f2>] irq_exit+0xe2/0x100
[ 2664.756859]  [<000000000010ce02>] do_IRQ+0x6a/0x88
[ 2664.756863]  [<000000000081d5e6>] io_int_handler+0x11a/0x25c
[ 2664.756867]  [<0000000000104900>] enabled_wait+0x58/0xe8
[ 2664.756870] ([<00000000001048e8>] enabled_wait+0x40/0xe8)
[ 2664.756875]  [<0000000000104da2>] arch_cpu_idle+0x32/0x48
[ 2664.756880]  [<00000000001b45a6>] default_idle_call+0x3e/0x58
[ 2664.756883]  [<00000000001b481c>] cpu_startup_entry+0x25c/0x358
[ 2664.756887]  [<00000000001153ca>] smp_start_secondary+0xf2/0x100
[ 2664.756890]  [<000000000081dbb2>] restart_int_handler+0x62/0x78
[ 2664.756893]  [<000000000081d894>] save_fpu_regs+0xc/0x78
[ 2664.756895] INFO: lockdep is turned off.
[ 2664.756898] Last Breaking-Event-Address:
[ 2664.756903]  [<00000000002f0278>] kmem_cache_free+0x1f8/0x3c0
[ 2664.756907]  
[ 2664.756911] Kernel panic - not syncing: Fatal exception in interrupt


I can reproduce on 4.4 and 4.3 and had not yet the chance to go back to older
versions. I can create a dump anytime, so I can look into some data structures
if that is of any help. Any ideas or ideas how to debug that further?

Christian
