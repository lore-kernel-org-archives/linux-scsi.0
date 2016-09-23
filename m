From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Fri, 23 Sep 2016 20:38:12 +0530
Message-ID: <817c1848a40a874cd5748f414d87665f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33040 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034927AbcIWPIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2016 11:08:15 -0400
Received: by mail-ua0-f170.google.com with SMTP id u68so44370783uau.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 08:08:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi Mike,

I could reproduce hard lockup using for-next kernel only in
iscsi_eh_cmd_timeout path due to spin_lock_irqsave taken in blk_timeout_work
Please refer stack trace below.

The _bh version used for frwd_lock and back_lock does not seem to be causing
any issue similar to seen with be2iscsi after replacing
_bh versions in be2iscsi.

I am testing it further, to confirm in all possible scenarios... NOPs, error
recovery, resets and reconnects.
On my setup, I affined all EQ interrupts on a single CPU.
Along with heavy IO, few of the invocations of fio were pinned to run on
same CPU.

Any call to unlock_bh with another spin_lock already held, invoking
do_softirq, might cause deadlock if bottom half used by driver
calls function which needs that another spin_lock.
Is there a code which prevents this issue?

Thanks,

JB

[ 3843.125976] ------------[ cut here ]------------
[ 3843.132217] WARNING: CPU: 20 PID: 1227 at kernel/softirq.c:150
__local_bh_enable_ip+0x6b/0x90
[ 3843.142815] Modules linked in: dm_service_time be2iscsi(E)
iscsi_boot_sysfs xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ebtable_broute rpcrdma bridge ib_isert stp
iscsi_target_mod llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
ib_iser ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 libiscsi nf_nat scsi_transport_iscsi ib_srpt
nf_conntrack target_core_mod iptable_mangle iptable_security iptable_raw
iptable_filter ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
ib_umad rdma_cm ib_cm iw_cm ocrdma ib_core dm_mirror dm_region_hash dm_log
intel_rapl sb_edac edac_core x86_pkg_temp_thermal
[ 3843.231162]  intel_powerclamp coretemp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt
iTCO_vendor_support ipmi_devintf lrw dcdbas mei_me ipmi_ssif gf128mul sg mei
glue_helper ablk_helper ioatdma cryptd ipmi_si shpchp nfsd wmi
acpi_power_meter ipmi_msghandler pcspkr dca lpc_ich acpi_pad auth_rpcgss
nfs_acl lockd grace sunrpc dm_multipath dm_mod ip_tables ext4 jbd2 mbcache
sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm drm tg3 crc32c_intel ptp i2c_core be2net megaraid_sas fjes
pps_core
[ 3843.294328] CPU: 20 PID: 1227 Comm: kworker/20:1H Tainted: G            E
4.8.0-rc1+ #3
[ 3843.304944] Hardware name: Dell Inc. PowerEdge R720/0X6H47, BIOS 1.4.8
10/25/2012
[ 3843.314798] Workqueue: kblockd blk_timeout_work
[ 3843.321350]  0000000000000086 00000000a32f4533 ffff8802216d7bd8
ffffffff8135c3cf
[ 3843.331146]  0000000000000000 0000000000000000 ffff8802216d7c18
ffffffff8108d661
[ 3843.340918]  00000096216d7c50 0000000000000200 ffff8802d07cc828
ffff8801b3632550
[ 3843.350687] Call Trace:
[ 3843.354866]  [<ffffffff8135c3cf>] dump_stack+0x63/0x84
[ 3843.362061]  [<ffffffff8108d661>] __warn+0xd1/0xf0
[ 3843.368851]  [<ffffffff8108d79d>] warn_slowpath_null+0x1d/0x20
[ 3843.376791]  [<ffffffff810930eb>] __local_bh_enable_ip+0x6b/0x90
[ 3843.384903]  [<ffffffff816fe7be>] _raw_spin_unlock_bh+0x1e/0x20
[ 3843.392940]  [<ffffffffa085f710>] beiscsi_alloc_pdu+0x2f0/0x6e0
[be2iscsi]
[ 3843.402076]  [<ffffffffa06bc358>] __iscsi_conn_send_pdu+0xf8/0x370
[libiscsi]
[ 3843.411549]  [<ffffffffa06bc6fe>] iscsi_send_nopout+0xbe/0x110 [libiscsi]
[ 3843.420639]  [<ffffffffa06bd98b>] iscsi_eh_cmd_timed_out+0x29b/0x2b0
[libiscsi]
[ 3843.430339]  [<ffffffff814cd1de>] scsi_times_out+0x5e/0x250
[ 3843.438119]  [<ffffffff813374af>] blk_rq_timed_out+0x1f/0x60
[ 3843.446009]  [<ffffffff8133759d>] blk_timeout_work+0xad/0x150
[ 3843.454010]  [<ffffffff810a6642>] process_one_work+0x152/0x400
[ 3843.462114]  [<ffffffff810a6f35>] worker_thread+0x125/0x4b0
[ 3843.469961]  [<ffffffff810a6e10>] ? rescuer_thread+0x380/0x380
[ 3843.478116]  [<ffffffff810aca28>] kthread+0xd8/0xf0
[ 3843.485212]  [<ffffffff816fedff>] ret_from_fork+0x1f/0x40
[ 3843.492908]  [<ffffffff810ac950>] ? kthread_park+0x60/0x60
[ 3843.500715] ---[ end trace 57ec0a1d8f0dd3a0 ]---
[ 3852.328667] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1Kernel
panic - not syncing: Hard LOCKUP
[ 3852.341357] Modules linked in: dm_service_time be2iscsi(E)
iscsi_boot_sysfs xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ebtable_broute rpcrdma bridge ib_isert stp
iscsi_target_mod llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
ib_iser ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 libiscsi nf_nat scsi_transport_iscsi ib_srpt
nf_conntrack target_core_mod iptable_mangle iptable_security iptable_raw
iptable_filter ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
ib_umad rdma_cm ib_cm iw_cm ocrdma ib_core dm_mirror dm_region_hash dm_log
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel iTCO_wdt iTCO_vendor_support ipmi_devintf lrw dcdbas mei_me ipm
[ 3852.341358] CPU: 1 PID: 1129 Comm: kworker/1:1H Tainted: G        W   E
4.8.0-rc1+ #3
[ 3852.341359] Hardware name: Dell Inc. PowerEdge R720/0X6H47, BIOS 1.4.8
10/25/2012
[ 3852.341359] Workqueue: kblockd blk_timeout_work
[ 3852.341360]  0000000000000086 00000000acd8294d ffff88042f605bb0
ffffffff8135c3cf
[ 3852.341361]  0000000000000000 0000000000000000 ffff88042f605bc8
ffffffff8114b3b8
[ 3852.341362]  ffff8802af358000 ffff88042f605c00 ffffffff8118546c
0000000000000001
[ 3852.341362] Call Trace:
[ 3852.341363]  <NMI>  [<ffffffff8135c3cf>] dump_stack+0x63/0x84
[ 3852.341363]  [<ffffffff8114b3b8>] watchdog_overflow_callback+0xc8/0xf0
[ 3852.341364]  [<ffffffff8118546c>] __perf_event_overflow+0x7c/0x1f0
[ 3852.341364]  [<ffffffff8118f7b4>] perf_event_overflow+0x14/0x20
[ 3852.341365]  [<ffffffff8100c46d>] intel_pmu_handle_irq+0x1dd/0x490
[ 3852.341366]  [<ffffffff8135e561>] ? ioremap_page_range+0x2a1/0x400
[ 3852.341366]  [<ffffffff811e0e00>] ? vunmap_page_range+0x1e0/0x320
[ 3852.341367]  [<ffffffff811e0f51>] ? unmap_kernel_range_noflush+0x11/0x20
[ 3852.341368]  [<ffffffff814206c6>] ? ghes_copy_tofrom_phys+0x116/0x1f0
[ 3852.341368]  [<ffffffff81053e3f>] ? native_apic_wait_icr_idle+0x1f/0x30
[ 3852.341369]  [<ffffffff810057dd>] perf_event_nmi_handler+0x2d/0x50
[ 3852.341369]  [<ffffffff810313f1>] nmi_handle+0x61/0x110
[ 3852.341370]  [<ffffffff81031954>] default_do_nmi+0x44/0x120
[ 3852.341371]  [<ffffffff81031b1b>] do_nmi+0xeb/0x160
[ 3852.341371]  [<ffffffff817011b1>] end_repeat_nmi+0x1a/0x1e
[ 3852.341372]  [<ffffffff810da737>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 3852.341373]  [<ffffffff810da737>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 3852.341373]  [<ffffffff810da737>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 3852.341374]  <<EOE>>  <IRQ>  [<ffffffff811983ba>]
queued_spin_lock_slowpath+0xb/0xf
[ 3852.341375]  [<ffffffff816feb27>] _raw_spin_lock_irqsave+0x37/0x40
[ 3852.341375]  [<ffffffff814d041b>] scsi_end_request+0x10b/0x1d0
[ 3852.341376]  [<ffffffff814d2143>] scsi_io_completion+0x153/0x650
[ 3852.341377]  [<ffffffff814c8faf>] scsi_finish_command+0xcf/0x120
[ 3852.341377]  [<ffffffff814d1927>] scsi_softirq_done+0x127/0x150
[ 3852.341378]  [<ffffffff813370dc>] blk_done_softirq+0x8c/0xc0
[ 3852.341378]  [<ffffffff81701932>] __do_softirq+0xd2/0x27a
[ 3852.341379]  [<ffffffff817009bc>] do_softirq_own_stack+0x1c/0x30
