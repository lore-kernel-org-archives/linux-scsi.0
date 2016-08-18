From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Observing Softlockup's while running heavy IOs
Date: Thu, 18 Aug 2016 11:25:33 +0530
Message-ID: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35461 "EHLO
	mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbcHRFzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 01:55:35 -0400
Received: by mail-ua0-f169.google.com with SMTP id n59so13576475uan.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 22:55:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, irqbalance@lists.infradead.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

Hi,

Problem statement:
Observing softlockups while running heavy IOs on 8 SSD drives
connected behind our LSI SAS 3004 HBA.

System configuration:
OS & kernel version: Fedora 23, v4.2.3-300.fc23.x86_64
NUMA : disabled,
CPUs : 24 logical cpus,
SCSI_MQ:  enabled
Driver : mpt3sas,
MSIx vectors: we have enabled only 2 MSIx vectors using driver module
parameter 'max_msix_vectors' set to 2,
IRQbalance version: v1.0.9
IRQbalance policy : 'subset'
rq_affinity : 2

mpt3sas IRQs info:
irq number =  219, smp_affinity = 000040     affinity_hint = 000fff
irq number =  220, smp_affinity = 001000     affinity_hint = fff000

issued IOs using fio tool with below parameters,
iodepth=128
direct=1
runtime=300
group_reporting
ioengine=libaio
cpus_allowed=6,7,8,9,10,11,18,19,20,21,22,23
time_based
[Ran-Read-4k-IOPs]
numjobs=24
rw=randread
bs=4k


My Analysis:
Observing a loop in the IO path, i.e only one CPU is busy with
processing the interrupts and other CPUs (in the affinity_hint mask)
are busy with sending the IOs (these CPUs are not yet all receiving
any interrupts). For example, only CPU6 is busy with processing the
interrupts from IRQ 219 and remaining CPUs i.e CPU 7,8,9,10 & 11 are
just busy with pumping the IOs and they never processed any IO
interrupts from IRQ 219. So we are observing softlockups due to
existence this loop in the IO Path.

We may not observe these softlockups if irqbalancer might have
balanced the interrupts among the CPUs enabled in the particular irq's
affinity_hint mask. so that all the CPUs are equaly busy with send IOs
and processing the interrupts. I am not sure how irqbalancer balance
the load among the CPUs, but here I see only one CPU from irq's
affinity_hint mask is busy with interrupts and remaining CPUs won't
receive any interrupts from this IRQ.

Please help me with any suggestions/recomendations to slove/limit
these kind of softlockups. Also please let me known if I have missed
any setting in the irqbalance.

Here is my 'sar -u ALL -P ALL 1' command output when softlock occurred,

12:16:11 PM     CPU      %usr     %nice      %sys   %iowait    %steal
    %irq     %soft    %guest    %gnice     %idle
12:16:12 PM     all      6.31      0.00     31.62      4.49      0.00
    0.00      2.59      0.00      0.00     54.99
12:16:12 PM       0      4.08      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     95.92
12:16:12 PM       1      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM       2      2.97      0.00      1.98      0.00      0.00
    0.00      0.00      0.00      0.00     95.05
12:16:12 PM       3      7.00      0.00      1.00      0.00      0.00
    0.00      0.00      0.00      0.00     92.00
12:16:12 PM       4      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM       5      4.04      0.00      1.01      0.00      0.00
    0.00      0.00      0.00      0.00     94.95
12:16:12 PM       6      0.00      0.00      0.00      0.00      0.00
    0.00    100.00      0.00      0.00      0.00
12:16:12 PM       7     17.02      0.00     58.51      0.00      0.00
    0.00      0.00      0.00      0.00     24.47
12:16:12 PM       8     14.13      0.00     61.96     23.91      0.00
    0.00      0.00      0.00      0.00      0.00
12:16:12 PM       9      5.21      0.00     14.58     80.21      0.00
    0.00      0.00      0.00      0.00      0.00
12:16:12 PM      10      4.21      0.00     14.74      0.00      0.00
    0.00      0.00      0.00      0.00     81.05
12:16:12 PM      11     13.04      0.00     61.96      0.00      0.00
    0.00      0.00      0.00      0.00     25.00
12:16:12 PM      12      0.00      0.00      0.00      0.00      0.00
    0.00    100.00      0.00      0.00      0.00
12:16:12 PM      13      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM      14      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM      15      3.03      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.97
12:16:12 PM      16      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM      17      4.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
12:16:12 PM      18      0.00      0.00    100.00      0.00      0.00
    0.00      0.00      0.00      0.00      0.00
12:16:12 PM      19     16.84      0.00     69.47      0.00      0.00
    0.00      0.00      0.00      0.00     13.68
12:16:12 PM      20     16.13      0.00     69.89      0.00      0.00
    0.00      0.00      0.00      0.00     13.98
12:16:12 PM      21      0.00      0.00    100.00      0.00      0.00
    0.00      0.00      0.00      0.00      0.00
12:16:12 PM      22      0.00      0.00    100.00      0.00      0.00
    0.00      0.00      0.00      0.00      0.00
12:16:12 PM      23     15.22      0.00     69.57      0.00      0.00
    0.00      0.00      0.00      0.00     15.22

And here is the softlockup call-trace:

[root@dhcp-135-24-192-127 soft_lockup_issue]# cat /opt/softlockup_calltrace.txt
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: NMI watchdog: BUG: soft
lockup - CPU#6 stuck for 23s! [fio:32228]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Modules linked in:
mpt3sas(OE) xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge
stp llc ebtable_filter ebtables ip6table_filter ip6_tables intel_rapl
iosf_mbi raid456 x86_pkg_temp_thermal async_raid6_recov async_memcpy
async_pq async_xor coretemp joydev xor async_tx ast i2c_algo_bit
raid6_pq kvm ttm drm_kms_helper drm sb_edac crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid_class scsi_transport_sas
iTCO_wdt iTCO_vendor_support i2c_i801 edac_core ipmi_ssif lpc_ich
mei_me mei ipmi_si ipmi_msghandler ioatdma tpm_tis shpchp tpm wmi
acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c ixgbe crc32c_intel mdio vxlan ip6_udp_tunnel udp_tunnel
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ptp nvme pps_core dca
[last unloaded: mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CPU: 6 PID: 32228 Comm:
fio Tainted: G        W  OEL  4.2.3-300.fc23.x86_64 #1
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Hardware name: Supermicro
SYS-2028U-TNRT+/X10DRU-i+, BIOS 1.1 07/22/2015
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: task: ffff883f5b8c8000 ti:
ffff883ecd918000 task.ti: ffff883ecd918000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RIP:
0010:[<ffffffff810a27db>]  [<ffffffff810a27db>]
__do_softirq+0x7b/0x290
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RSP: 0018:ffff883f7f183f08
 EFLAGS: 00000286
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RAX: ffff883ecd91c000 RBX:
ffff883f7f190080 RCX: 00000000000006e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RDX: 0000000000050109 RSI:
000000002a60bb93 RDI: ffff883f5b8c8000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RBP: ffff883f7f183f68 R08:
000501092a0e06ad R09: ffff883f7f183d80
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R10: 0000000000000000 R11:
0000000000000004 R12: ffff883f7f183e78
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R13: ffffffff8177984b R14:
ffff883f7f183f68 R15: 0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: FS:
00007fa884206740(0000) GS:ffff883f7f180000(0000)
knlGS:0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CR2: 00007fa87650d090 CR3:
0000003edf8ee000 CR4: 00000000001406e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Stack:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883f7f18fc40
004041407f18fce8 ffff883ecd91c000 0000000118aaea84
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: 000178ab0000000a
000000827f18fc58 ffff883f7f183f58 0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883ecd91b7d8
ffffe8ffff985300 ffff883ecd9a7100 ffff883e5d0c8080
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Call Trace:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: <IRQ>
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff810a2c09>]
irq_exit+0x119/0x120
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8177b6b6>]
smp_apic_timer_interrupt+0x46/0x60
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8177984b>]
apic_timer_interrupt+0x6b/0x70
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: <EOI>
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137c415>] ?
__bt_get.isra.5+0xe5/0x1c0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff810e66cc>] ?
queued_spin_lock_slowpath+0xdc/0x180
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81778630>]
_raw_spin_lock+0x20/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379e07>]
__blk_mq_run_hw_queue+0x157/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81378546>] ?
__blk_mq_alloc_request+0x156/0x1f0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137a2cb>]
blk_mq_map_request+0x13b/0x1e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137b1f4>]
blk_sq_make_request+0x84/0x2b0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811a571d>] ?
mempool_alloc_slab+0x1d/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8136dca6>]
generic_make_request+0xd6/0x110
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8136dd56>]
submit_bio+0x76/0x170
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811adcce>] ?
set_page_dirty_lock+0x2e/0x40
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813683bb>] ?
bio_set_pages_dirty+0x4b/0x70
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125b797>]
do_blockdev_direct_IO+0x22e7/0x2b20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813c55cd>] ?
swiotlb_map_sg_attrs+0x6d/0x130
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffffa05d237f>] ?
_base_build_sg_scmd_ieee+0x25f/0x5f0 [mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81256760>] ?
I_BDEV+0x20/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125c013>]
__blockdev_direct_IO+0x43/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379e80>] ?
__blk_mq_run_hw_queue+0x1d0/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125706c>]
blkdev_direct_IO+0x4c/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811a42cb>]
generic_file_read_iter+0x48b/0x5c0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81257c60>] ?
blkdev_write_iter+0x120/0x120
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81257c95>]
blkdev_read_iter+0x35/0x40
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126994a>]
aio_run_iocb+0x13a/0x2e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff812691df>] ?
read_events+0x12f/0x340
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff812000c6>] ?
kmem_cache_alloc+0x1d6/0x210
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126a94a>]
do_io_submit+0x23a/0x4d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817742f1>] ?
__schedule+0x371/0x950
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81774907>] ?
schedule+0x37/0x80
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126abf0>]
SyS_io_submit+0x10/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817789ae>]
entry_SYSCALL_64_fastpath+0x12/0x71
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Code: 7e 00 01 00 00 65 48
8b 04 25 c4 3c 01 00 c7 45 c0 0a 00 00 00 48 89 45 b0 65 c7 05 2c 14
f7 7e 00 00 00 00 fb 66 0f 1f 44 00 00 <b8> ff ff ff ff 49 c7 c4 c0 a0
c0 81 0f bc 45 cc 83 c0 01 89 45
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: NMI watchdog: BUG: soft
lockup - CPU#18 stuck for 23s! [fio:32235]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Modules linked in:
mpt3sas(OE) xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge
stp llc ebtable_filter ebtables ip6table_filter ip6_tables intel_rapl
iosf_mbi raid456 x86_pkg_temp_thermal async_raid6_recov async_memcpy
async_pq async_xor coretemp joydev xor async_tx ast i2c_algo_bit
raid6_pq kvm ttm drm_kms_helper drm sb_edac crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid_class scsi_transport_sas
iTCO_wdt iTCO_vendor_support i2c_i801 edac_core ipmi_ssif lpc_ich
mei_me mei ipmi_si ipmi_msghandler ioatdma tpm_tis shpchp tpm wmi
acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c ixgbe crc32c_intel mdio vxlan ip6_udp_tunnel udp_tunnel
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ptp nvme pps_core dca
[last unloaded: mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CPU: 18 PID: 32235 Comm:
fio Tainted: G        W  OEL  4.2.3-300.fc23.x86_64 #1
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Hardware name: Supermicro
SYS-2028U-TNRT+/X10DRU-i+, BIOS 1.1 07/22/2015
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: task: ffff883f3f445880 ti:
ffff883edf894000 task.ti: ffff883edf894000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RIP:
0010:[<ffffffff810e6703>]  [<ffffffff810e6703>]
queued_spin_lock_slowpath+0x113/0x180
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RSP: 0018:ffff883edf897c18
 EFLAGS: 00000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RAX: 0000000000000000 RBX:
ffff883ecf7bc000 RCX: ffff883f7f497340
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RDX: ffff883f7f597340 RSI:
00000000004c0000 RDI: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RBP: ffff883edf897c18 R08:
0000000000000101 R09: 0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R10: 0000000000001000 R11:
0000000000000000 R12: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R13: 0000000000000000 R14:
0000000017145a7c R15: 0000000000000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: FS:
00007fa884206740(0000) GS:ffff883f7f480000(0000)
knlGS:0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CR2: 00007fa876512024 CR3:
0000003e5d781000 CR4: 00000000001406e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Stack:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883edf897c28
ffffffff81778630 ffff883edf897cc8 ffffffff81379f09
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883edf897c68
ffff883f51334d58 ffff883f51364408 0000001000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883e5882af00
ffff883e5882af00 ffff883edf897c68 ffff883edf897c68
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Call Trace:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81778630>]
_raw_spin_lock+0x20/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379f09>]
__blk_mq_run_hw_queue+0x259/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379c91>]
blk_mq_run_hw_queue+0x91/0xb0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137b11c>]
blk_mq_insert_requests+0xbc/0x110
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137bc32>]
blk_mq_flush_plug_list+0x132/0x160
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813718b6>]
blk_flush_plug_list+0xb6/0x220
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81371d84>]
blk_finish_plug+0x34/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126a9aa>]
do_io_submit+0x29a/0x4d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817742f1>] ?
__schedule+0x371/0x950
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81774907>] ?
schedule+0x37/0x80
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126abf0>]
SyS_io_submit+0x10/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817789ae>]
entry_SYSCALL_64_fastpath+0x12/0x71
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Code: 12 48 c1 ea 0c 83 e8
01 83 e2 30 48 98 48 81 c2 40 73 01 00 48 03 14 c5 80 cb d2 81 48 89
0a 8b 41 08 85 c0 75 0d f3 90 8b 41 08 <85> c0 74 f7 eb 02 f3 90 8b 17
66 85 d2 75 f7 39 f2 75 0f 89 d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: NMI watchdog: BUG: soft
lockup - CPU#21 stuck for 23s! [fio:32224]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: NMI watchdog: BUG: soft
lockup - CPU#22 stuck for 23s! [fio:32220]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Modules linked in:
mpt3sas(OE) xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge
stp llc ebtable_filter ebtables ip6table_filter ip6_tables intel_rapl
iosf_mbi raid456 x86_pkg_temp_thermal async_raid6_recov async_memcpy
async_pq async_xor coretemp joydev xor async_tx ast i2c_algo_bit
raid6_pq kvm ttm drm_kms_helper drm sb_edac crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid_class scsi_transport_sas
iTCO_wdt iTCO_vendor_support i2c_i801 edac_core ipmi_ssif lpc_ich
mei_me mei ipmi_si ipmi_msghandler ioatdma tpm_tis shpchp tpm wmi
acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c ixgbe crc32c_intel mdio vxlan ip6_udp_tunnel udp_tunnel
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ptp nvme pps_core dca
[last unloaded: mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CPU: 22 PID: 32220 Comm:
fio Tainted: G        W  OEL  4.2.3-300.fc23.x86_64 #1
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Hardware name: Supermicro
SYS-2028U-TNRT+/X10DRU-i+, BIOS 1.1 07/22/2015
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: task: ffff883f5c1b8000 ti:
ffff883eb9300000 task.ti: ffff883eb9300000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RIP:
0010:[<ffffffff810e6703>]  [<ffffffff810e6703>]
queued_spin_lock_slowpath+0x113/0x180
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RSP: 0018:ffff883eb9303c18
 EFLAGS: 00000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RAX: 0000000000000000 RBX:
ffff883ecf7bc000 RCX: ffff883f7f597340
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RDX: ffff883f7f557340 RSI:
00000000005c0000 RDI: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RBP: ffff883eb9303c18 R08:
0000000000000101 R09: 0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R10: 0000000000001000 R11:
0000000000000000 R12: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R13: 0000000000000000 R14:
000000008327c0c7 R15: 0000000000000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: FS:
00007fa884206740(0000) GS:ffff883f7f580000(0000)
knlGS:0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CR2: 00007fa8841df000 CR3:
0000003ecf698000 CR4: 00000000001406e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Stack:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883eb9303c28
ffffffff81778630 ffff883eb9303cc8 ffffffff81379f09
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883eb9303c68
ffff883f51334d58 ffff883f51364408 0000001000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883ea28e4600
ffff883ea28e4600 ffff883eb9303c68 ffff883eb9303c68
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Call Trace:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81778630>]
_raw_spin_lock+0x20/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379f09>]
__blk_mq_run_hw_queue+0x259/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379c91>]
blk_mq_run_hw_queue+0x91/0xb0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137b11c>]
blk_mq_insert_requests+0xbc/0x110
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137bc32>]
blk_mq_flush_plug_list+0x132/0x160
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813718b6>]
blk_flush_plug_list+0xb6/0x220
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81371d84>]
blk_finish_plug+0x34/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126a9aa>]
do_io_submit+0x29a/0x4d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817742f1>] ?
__schedule+0x371/0x950
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81774907>] ?
schedule+0x37/0x80
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126abf0>]
SyS_io_submit+0x10/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817789ae>]
entry_SYSCALL_64_fastpath+0x12/0x71
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Code: 12 48 c1 ea 0c 83 e8
01 83 e2 30 48 98 48 81 c2 40 73 01 00 48 03 14 c5 80 cb d2 81 48 89
0a 8b 41 08 85 c0 75 0d f3 90 8b 41 08 <85> c0 74 f7 eb 02 f3 90 8b 17
66 85 d2 75 f7 39 f2 75 0f 89 d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Modules linked in:
mpt3sas(OE) xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge
stp llc ebtable_filter ebtables ip6table_filter ip6_tables intel_rapl
iosf_mbi raid456 x86_pkg_temp_thermal async_raid6_recov async_memcpy
async_pq async_xor coretemp joydev xor async_tx ast i2c_algo_bit
raid6_pq kvm ttm drm_kms_helper drm sb_edac crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid_class scsi_transport_sas
iTCO_wdt iTCO_vendor_support i2c_i801 edac_core ipmi_ssif lpc_ich
mei_me mei ipmi_si ipmi_msghandler ioatdma tpm_tis shpchp tpm wmi
acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c ixgbe crc32c_intel mdio vxlan ip6_udp_tunnel udp_tunnel
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ptp nvme pps_core dca
[last unloaded: mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CPU: 21 PID: 32224 Comm:
fio Tainted: G        W  OEL  4.2.3-300.fc23.x86_64 #1
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Hardware name: Supermicro
SYS-2028U-TNRT+/X10DRU-i+, BIOS 1.1 07/22/2015
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: task: ffff883f5a3b8000 ti:
ffff883ecfb58000 task.ti: ffff883ecfb58000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RIP:
0010:[<ffffffff810e6703>]  [<ffffffff810e6703>]
queued_spin_lock_slowpath+0x113/0x180
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RSP: 0018:ffff883ecfb5b698
 EFLAGS: 00000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RAX: 0000000000000000 RBX:
ffff883ecf7bc000 RCX: ffff883f7f557340
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RDX: ffff883f7f197340 RSI:
0000000000580000 RDI: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: RBP: ffff883ecfb5b698 R08:
0000000000000101 R09: 0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R10: 0000000118aaea81 R11:
0000000000000006 R12: ffff883f51364400
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: R13: ffff883ecfb5b648 R14:
000000006c0b2c7f R15: 0000000000000246
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: FS:
00007fa884206740(0000) GS:ffff883f7f540000(0000)
knlGS:0000000000000000
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: CR2: 00007f8d99882000 CR3:
0000003eb901c000 CR4: 00000000001406e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Stack:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883ecfb5b6a8
ffffffff81778630 ffff883ecfb5b748 ffffffff81379f09
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883ecfb5b6c8
ffff883f51334d58 ffff883f51364408 0000000800000296
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: ffff883eae160000
ffff883eae092300 ffff883ecfb5b6e8 ffff883ecfb5b6e8
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Call Trace:
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81778630>]
_raw_spin_lock+0x20/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379f09>]
__blk_mq_run_hw_queue+0x259/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379c91>]
blk_mq_run_hw_queue+0x91/0xb0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137c615>]
bt_get+0x125/0x1d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff810df960>] ?
wake_atomic_t_function+0x70/0x70
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137ca30>]
blk_mq_get_tag+0xb0/0xe0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137840b>]
__blk_mq_alloc_request+0x1b/0x1f0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137a34d>]
blk_mq_map_request+0x1bd/0x1e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8137b1f4>]
blk_sq_make_request+0x84/0x2b0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811a571d>] ?
mempool_alloc_slab+0x1d/0x30
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8136dca6>]
generic_make_request+0xd6/0x110
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8136dd56>]
submit_bio+0x76/0x170
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811adcce>] ?
set_page_dirty_lock+0x2e/0x40
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813683bb>] ?
bio_set_pages_dirty+0x4b/0x70
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125b797>]
do_blockdev_direct_IO+0x22e7/0x2b20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff813c55cd>] ?
swiotlb_map_sg_attrs+0x6d/0x130
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffffa05d237f>] ?
_base_build_sg_scmd_ieee+0x25f/0x5f0 [mpt3sas]
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81256760>] ?
I_BDEV+0x20/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125c013>]
__blockdev_direct_IO+0x43/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81379e80>] ?
__blk_mq_run_hw_queue+0x1d0/0x370
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8125706c>]
blkdev_direct_IO+0x4c/0x50
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff811a42cb>]
generic_file_read_iter+0x48b/0x5c0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81257c60>] ?
blkdev_write_iter+0x120/0x120
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81257c95>]
blkdev_read_iter+0x35/0x40
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126994a>]
aio_run_iocb+0x13a/0x2e0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff812691df>] ?
read_events+0x12f/0x340
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff812000c6>] ?
kmem_cache_alloc+0x1d6/0x210
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126a94a>]
do_io_submit+0x23a/0x4d0
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817742f1>] ?
__schedule+0x371/0x950
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff81774907>] ?
schedule+0x37/0x80
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff8126abf0>]
SyS_io_submit+0x10/0x20
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: [<ffffffff817789ae>]
entry_SYSCALL_64_fastpath+0x12/0x71
Aug 17 12:16:12 dhcp-135-24-192-127 kernel: Code: 12 48 c1 ea 0c 83 e8
01 83 e2 30 48 98 48 81 c2 40 73 01 00 48 03 14 c5 80 cb d2 81 48 89
0a 8b 41 08 85 c0 75 0d f3 90 8b 41 08 <85> c0 74 f7 eb 02 f3 90 8b 17
66 85 d2 75 f7 39 f2 75 0f 89 d0

Thanks,
Sreekanth
