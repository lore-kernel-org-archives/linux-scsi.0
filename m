From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Fri, 19 Aug 2016 17:14:45 +0530
Message-ID: <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

First of all thanks for Robert and Bart for reply.

Robert,
Thanks for the URL, I have gone though this URL.
Yes I am also observing that all the interrupts are routed to one CPU.
But still I observing softlockups (sometime hardlockups) even when I
set rq_affinity to 2.

Is their any way to route the interrupts the same CPUs which has
submitted the corresponding IOs?
or
Is their any way/option in the irqbalance/kernel which can route
interrupts to CPUs (enabled in affinity_hint) in round robin manner
after specific time period.


Bart,
I have tried with your path and here is logs,

[Aug19 13:48] __blk_mq_run_hw_queue() finished after 1 ms
[  +1.196454] __blk_mq_run_hw_queue() finished after 11 ms
[Aug19 13:49] __blk_mq_run_hw_queue() finished after 20 ms
[ +14.173018] __blk_mq_run_hw_queue() finished after 278 ms
[ +14.066448] __blk_mq_run_hw_queue() finished after 588 ms
[  +5.394698] __blk_mq_run_hw_queue() finished after 1360 ms
[Aug19 13:51] __blk_mq_run_hw_queue() finished after 1539 ms
[Aug19 13:54] __blk_mq_run_hw_queue() finished after 1762 ms
[Aug19 13:55] __blk_mq_run_hw_queue() finished after 2087 ms
[Aug19 13:57] __blk_mq_run_hw_queue() finished after 2915 ms
[Aug19 14:06] perf interrupt took too long (2509 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[Aug19 14:10] __blk_mq_run_hw_queue() finished after 3266 ms
[Aug19 14:15] __blk_mq_run_hw_queue() finished after 3953 ms
[Aug19 14:22] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s!
[llvmpipe-9:3152]
[  +0.000439] __blk_mq_run_hw_queue() finished after 10058 ms
[  +0.007206] Modules linked in: mpt3sas(OE) xt_CHECKSUM
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack tun bridge stp llc ebtable_filter ebtables
ip6table_filter ip6_tables raid456 async_raid6_recov async_memcpy
async_pq async_xor xor intel_rapl async_tx iosf_mbi
x86_pkg_temp_thermal raid6_pq coretemp kvm crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel mei_me joydev pcspkr sb_edac i2c_i801
mei iTCO_wdt iTCO_vendor_support edac_core lpc_ich ipmi_ssif ipmi_si
ipmi_msghandler shpchp tpm_tis ioatdma acpi_power_meter tpm wmi
acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c ast
i2c_algo_bit drm_kms_helper ttm ixgbe drm mdio vxlan ip6_udp_tunnel
udp_tunnel crc32c_intel raid_class ptp scsi_transport_sas
[  +0.000063]  pps_core nvme dca [last unloaded: mpt3sas]
[  +0.000007] CPU: 6 PID: 3152 Comm: llvmpipe-9 Tainted: G        W
OE   4.2.0 #1
[  +0.000002] Hardware name: Supermicro SYS-2028U-TNRT+/X10DRU-i+,
BIOS 1.1 07/22/2015
[  +0.000003] task: ffff883f5cf557c0 ti: ffff883f5afd8000 task.ti:
ffff883f5afd8000
[  +0.000002] RIP: 0010:[<ffffffff810a159b>]  [<ffffffff810a159b>]
__do_softirq+0x7b/0x290
[  +0.000008] RSP: 0000:ffff883f7f183f08  EFLAGS: 00000206
[  +0.000002] RAX: ffff883f5afdc000 RBX: ffff883f7f190080 RCX: 00000000000006e0
[  +0.000002] RDX: 0000000000003508 RSI: 0000000071c139c0 RDI: ffff883f5cf557c0
[  +0.000002] RBP: ffff883f7f183f68 R08: 00003508717f8da4 R09: ffff883f7f183d80
[  +0.000002] R10: 0000000000000000 R11: 0000000000000004 R12: ffff883f7f183e78
[  +0.000001] R13: ffffffff8177304b R14: ffff883f7f183f68 R15: 0000000000000000
[  +0.000003] FS:  00007fa76b7f6700(0000) GS:ffff883f7f180000(0000)
knlGS:0000000000000000

Message from syslogd@dhcp-135-24-192-127 at Aug 19 14:22:42 ...
 kernel:NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [llvmpipe-9:3152]
[  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000002] CR2: 00007fa03a2d90c0 CR3: 0000003f61fe4000 CR4: 00000000001406e0
[  +0.000002] Stack:
[  +0.000001]  ffff883f7f18fc40 404040407f18fce8 ffff883f5afdc000
0000000100aecc1a
[  +0.000004]  00000ab10000000a 000002027f18fc58 ffff883f7f183f48
0000000000000000
[  +0.000003]  ffff883f7f1967c0 ffff883f448d57c0 0000000000000000
0000000000000001
[  +0.000003] Call Trace:
[  +0.000002]  <IRQ>
[  +0.000005]  [<ffffffff810a19c6>] irq_exit+0x116/0x120
[  +0.000005]  [<ffffffff81774eb6>] smp_apic_timer_interrupt+0x46/0x60
[  +0.000005]  [<ffffffff8177304b>] apic_timer_interrupt+0x6b/0x70
[  +0.000002]  <EOI>
[  +0.000005]  [<ffffffff810c392b>] ? finish_task_switch+0x6b/0x200
[  +0.000006]  [<ffffffff8176dabc>] __schedule+0x36c/0x950
[  +0.000002]  [<ffffffff8176e0d7>] schedule+0x37/0x80
[  +0.000006]  [<ffffffff81116a1c>] futex_wait_queue_me+0xbc/0x120
[  +0.000004]  [<ffffffff81116da9>] futex_wait+0x119/0x270
[  +0.000004]  [<ffffffff81116800>] ? futex_wake+0x90/0x180
[  +0.000003]  [<ffffffff81118d6b>] do_futex+0x12b/0xb00
[  +0.000005]  [<ffffffff810d348e>] ? set_next_entity+0x23e/0x440
[  +0.000007]  [<ffffffff810136f1>] ? __switch_to+0x261/0x4b0
[  +0.000004]  [<ffffffff811197c1>] SyS_futex+0x81/0x180
[  +0.000002]  [<ffffffff8176e0d7>] ? schedule+0x37/0x80
[  +0.000004]  [<ffffffff817721ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[  +0.000001] Code: 7e 00 01 00 00 65 48 8b 04 25 c4 3c 01 00 c7 45 c0
0a 00 00 00 48 89 45 b0 65 c7 05 6c 26 f7 7e 00 00 00 00 fb 66 0f 1f
44 00 00 <b8> ff ff ff ff 49 c7 c4 c0 a0 c0 81 0f bc 45 cc 83 c0 01 89
45

and here is the 'sar -u ALL 1 -P ALL 1'
02:22:43 PM     CPU      %usr     %nice      %sys   %iowait    %steal
    %irq     %soft    %guest    %gnice     %idle
02:22:44 PM     all      5.73      0.60     29.31     14.90      0.00
    0.00      1.57      0.00      0.00     47.89
02:22:44 PM       0      8.82      0.00     48.53     38.24      0.00
    0.00      0.00      0.00      0.00      4.41
02:22:44 PM       1     10.29      0.00     63.24     26.47      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM       2      8.96      0.00     65.67     25.37      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM       3     11.94      0.00     61.19     26.87      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM       4      8.96      0.00     64.18     26.87      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM       5      7.46      0.00     67.16     25.37      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM       6      0.00      0.00      0.00      0.00      0.00
    0.00    100.00      0.00      0.00      0.00
02:22:44 PM       7      1.33      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     98.67
02:22:44 PM       8      5.19      0.00      1.30      0.00      0.00
    0.00      0.00      0.00      0.00     93.51
02:22:44 PM       9      2.67      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     97.33
02:22:44 PM      10      2.67      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     97.33
02:22:44 PM      11      3.95      0.00      1.32      1.32      0.00
    0.00      0.00      0.00      0.00     93.42
02:22:44 PM      12     11.11      0.00     83.33      5.56      0.00
    0.00      0.00      0.00      0.00      0.00
02:22:44 PM      13      8.70      0.00     52.17     36.23      0.00
    0.00      0.00      0.00      0.00      2.90
02:22:44 PM      14      6.15      0.00     53.85     38.46      0.00
    0.00      0.00      0.00      0.00      1.54
02:22:44 PM      15      5.97      0.00     55.22     37.31      0.00
    0.00      0.00      0.00      0.00      1.49
02:22:44 PM      16      8.70      0.00     52.17     36.23      0.00
    0.00      0.00      0.00      0.00      2.90
02:22:44 PM      17      7.35      0.00     55.88     35.29      0.00
    0.00      0.00      0.00      0.00      1.47
02:22:44 PM      18      0.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00    100.00
02:22:44 PM      19      2.63      0.00      1.32      2.63      0.00
    0.00      0.00      0.00      0.00     93.42
02:22:44 PM      20      2.67      0.00      1.33      0.00      0.00
    0.00      0.00      0.00      0.00     96.00
02:22:44 PM      21      7.89      5.26      2.63      0.00      0.00
    0.00      0.00      0.00      0.00     84.21
02:22:44 PM      22      1.32      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     98.68
02:22:44 PM      23      4.05      8.11      2.70      4.05      0.00
    0.00      0.00      0.00      0.00     81.08

Still I am continuing my investigation on this.

Note:
I am taking vacation next week, please expect some delay for response.

Thanks,
Sreekanth

On Fri, Aug 19, 2016 at 2:38 AM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Sreekanth Reddy
>> Sent: Thursday, August 18, 2016 12:56 AM
>> Subject: Observing Softlockup's while running heavy IOs
>>
>> Problem statement:
>> Observing softlockups while running heavy IOs on 8 SSD drives
>> connected behind our LSI SAS 3004 HBA.
>>
> ...
>> Observing a loop in the IO path, i.e only one CPU is busy with
>> processing the interrupts and other CPUs (in the affinity_hint mask)
>> are busy with sending the IOs (these CPUs are not yet all receiving
>> any interrupts). For example, only CPU6 is busy with processing the
>> interrupts from IRQ 219 and remaining CPUs i.e CPU 7,8,9,10 & 11 are
>> just busy with pumping the IOs and they never processed any IO
>> interrupts from IRQ 219. So we are observing softlockups due to
>> existence this loop in the IO Path.
>>
>> We may not observe these softlockups if irqbalancer might have
>> balanced the interrupts among the CPUs enabled in the particular
>> irq's
>> affinity_hint mask. so that all the CPUs are equaly busy with send
>> IOs
>> and processing the interrupts. I am not sure how irqbalancer balance
>> the load among the CPUs, but here I see only one CPU from irq's
>> affinity_hint mask is busy with interrupts and remaining CPUs won't
>> receive any interrupts from this IRQ.
>>
>> Please help me with any suggestions/recomendations to slove/limit
>> these kind of softlockups. Also please let me known if I have missed
>> any setting in the irqbalance.
>>
>
> The CPUs need to be forced to self-throttle by processing interrupts for
> their own submissions, which reduces the time they can submit more IOs.
>
> See https://lkml.org/lkml/2014/9/9/931 for discussion of this
> problem when blk-mq was added.
>
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
>
