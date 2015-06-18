From: Sony John <sony.john@avagotech.com>
Subject: OOPS: While logging out of iSCSI Session when MultiPath is Enabled
Date: Thu, 18 Jun 2015 21:20:38 +0530
Message-ID: <CAJRCtXdLkC_Ywmy+ypcdF4iYfMmzbLbpzAwirTjp3LKkQBm3-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35327 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbbFRPuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2015 11:50:40 -0400
Received: by labko7 with SMTP id ko7so57360450lab.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2015 08:50:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Hi All,

We had logged in to the same target through two NIC interfaces. There
were 2 iSCSI-Session and multipath -ll showed the details fine.

The moment we issue logout command on both the session the below
kernel panic happens. If multipath is disabled there is no panic and
everything works fine.


[ 1529.694046] scsi host7: iSCSI Initiator over TCP/IP
[ 1529.788683] scsi host8: iSCSI Initiator over TCP/IP
[ 1529.841938] scsi 7:0:0:0: Direct-Access     LIO-ORG  RAMDISK-MCP
  4.0  PQ: 0 ANSI: 5
[ 1529.842682] scsi 8:0:0:0: Direct-Access     LIO-ORG  RAMDISK-MCP
  4.0  PQ: 0 ANSI: 5
[ 1529.849382] scsi 8:0:0:0: alua: supports implicit and explicit TPGS
[ 1529.851972] scsi 8:0:0:0: alua: port group 00 rel port 01
[ 1529.852416] scsi 8:0:0:0: alua: port group 00 state A non-preferred
supports TOlUSNA
[ 1529.852420] scsi 8:0:0:0: alua: Attached
[ 1529.855782] sd 8:0:0:0: [sde] 81920 512-byte logical blocks: (41.9
MB/40.0 MiB)
[ 1529.858529] sd 8:0:0:0: [sde] Write Protect is off
[ 1529.859297] sd 8:0:0:0: [sde] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[ 1529.877955] sd 8:0:0:0: [sde] Attached SCSI disk
[ 1529.917020] scsi 7:0:0:0: alua: supports implicit and explicit TPGS
[ 1529.924986] scsi 7:0:0:0: alua: port group 00 rel port 01
[ 1529.931488] scsi 7:0:0:0: alua: port group 00 state A non-preferred
supports TOlUSNA
[ 1529.940149] scsi 7:0:0:0: alua: Attached
[ 1529.946403] sd 7:0:0:0: [sdf] 81920 512-byte logical blocks: (41.9
MB/40.0 MiB)
[ 1529.956420] sd 7:0:0:0: [sdf] Write Protect is off
[ 1529.962453] sd 7:0:0:0: [sdf] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[ 1529.984070] sd 7:0:0:0: [sdf] Attached SCSI disk
[ 1530.072851] device-mapper: multipath service-time: version 0.2.0 loaded
[ 1547.063600] sd 8:0:0:0: alua: Detached
[ 1547.063652] sd 7:0:0:0: alua: Detached
[ 1547.159188] device-mapper: multipath: Failing path 8:64.
[ 1547.166336] blk_update_request: I/O error, dev dm-0, sector 81792
[ 1547.173291] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000138
[ 1547.182134] IP: [<ffffffffa00949c9>] free_rq_clone+0x29/0xb0 [dm_mod]
[ 1547.189407] PGD 0
[ 1547.191682] Oops: 0000 [#1] SMP
[ 1547.195335] Modules linked in: dm_service_time iscsi_tcp
libiscsi_tcp xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter
ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
iptable_filter ip_tables xprtrdma sunrpc ib_isert iscsi_target_mod
ib_iser ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib
rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm
x86_pkg_temp_thermal intel_powerclamp ib_sa ib_mad coretemp kvm_intel
kvm ocrdma dm_mirror ib_core ib_addr crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel dm_region_hash aesni_intel dm_log lrw
gf128mul be2iscsi iTCO_wdt glue_helper ablk_helper sb_edac
iTCO_vendor_support edac_core cryptd ipmi_devintf mei_me lpc_ich
iscsi_boot_sysfs ipmi_si mei pcspkr mfd_core dcdbas libiscsi
scsi_transport_iscsi shpchp wmi ipmi_msghandler acpi_pad
acpi_power_meter dm_multipath dm_mod uinput ext4 mbcache jbd2 mgag200
syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper sd_mod
ttm drm be2net tg3 vxlan ptp ip6_udp_tunnel i2c_core megaraid_sas
udp_tunnel pps_core
[ 1547.332744] CPU: 6 PID: 52 Comm: ksoftirqd/6 Not tainted 4.1.0-rc1+ #8
[ 1547.340083] Hardware name: Dell Inc. PowerEdge R720/0X6H47, BIOS
2.0.15 07/29/2013
[ 1547.348593] task: ffff880236372dc0 ti: ffff8802363a4000 task.ti:
ffff8802363a4000
[ 1547.357009] RIP: 0010:[<ffffffffa00949c9>]  [<ffffffffa00949c9>]
free_rq_clone+0x29/0xb0 [dm_mod]
[ 1547.367007] RSP: 0018:ffff8802363a7ce8  EFLAGS: 00010292
[ 1547.372978] RAX: 0000000000000000 RBX: ffff880034e0d9e0 RCX: 000000000000ffff
[ 1547.381007] RDX: 0000000000000000 RSI: ffffea0008d5d500 RDI: 0000000000000000
[ 1547.389033] RBP: ffff8802363a7d08 R08: ffff880235755800 R09: 0000000180200010
[ 1547.397053] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880034f3d230
[ 1547.405074] R13: ffff880233ba2000 R14: ffff880233ba2000 R15: 0000000000000000
[ 1547.413103] FS:  0000000000000000(0000) GS:ffff8802378c0000(0000)
knlGS:0000000000000000
[ 1547.422206] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1547.428663] CR2: 0000000000000138 CR3: 0000000001a9e000 CR4: 00000000000407e0
[ 1547.436684] Stack:
[ 1547.438944]  ffff880236372dc0 00000000fffffffb ffff880034e0d9e0
ffff880034e0d870
[ 1547.447303]  ffff8802363a7d48 ffffffffa0095187 ffff8802363a7d38
ffff880034e0d8e8
[ 1547.455663]  ffff880034e0d870 ffff8802363a7d60 0000000000000100
0000000000000000
[ 1547.464019] Call Trace:
[ 1547.466784]  [<ffffffffa0095187>] dm_softirq_done+0x137/0x250 [dm_mod]
[ 1547.474117]  [<ffffffff8135d5a8>] blk_done_softirq+0x98/0xc0
[ 1547.480481]  [<ffffffff810929f6>] __do_softirq+0xf6/0x670
[ 1547.486559]  [<ffffffff81092f95>] run_ksoftirqd+0x25/0x80
[ 1547.492630]  [<ffffffff810b8149>] smpboot_thread_fn+0x129/0x1f0
[ 1547.499283]  [<ffffffff810b8020>] ? sort_range+0x30/0x30
[ 1547.505256]  [<ffffffff810b3dde>] kthread+0xfe/0x120
[ 1547.510844]  [<ffffffff810b3ce0>] ? kthread_create_on_node+0x240/0x240
[ 1547.518190]  [<ffffffff817546a2>] ret_from_fork+0x42/0x70
[ 1547.524260]  [<ffffffff810b3ce0>] ? kthread_create_on_node+0x240/0x240
[ 1547.531590] Code: 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 53
48 89 fb 48 83 ec 08 4c 8b a7 60 01 00 00 4d 8b 2c 24 e8 bb b5 2b e1
48 8b 43 30 <48> 83 b8 38 01 00 00 00 74 2d 49 8b 44 24 08 48 89 df 48
8b 40
[ 1547.553456] RIP  [<ffffffffa00949c9>] free_rq_clone+0x29/0xb0 [dm_mod]
[ 1547.560820]  RSP <ffff8802363a7ce8>
[ 1547.564737] CR2: 0000000000000138
[ 1547.578943] ---[ end trace 94a969e7768856ba ]---
[ 1547.589074] Kernel panic - not syncing: Fatal exception in interrupt
[ 1547.598680] Kernel Offset: disabled
[ 1547.604979] drm_kms_helper: panic occurred, switching back to text console
[ 1547.620029] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
[ 1547.628005] ------------[ cut here ]------------
[ 1547.633164] WARNING: CPU: 6 PID: 52 at arch/x86/kernel/smp.c:124
native_smp_send_reschedule+0x5d/0x60()
[ 1547.643647] Modules linked in: dm_service_time iscsi_tcp
libiscsi_tcp xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter
ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
iptable_filter ip_tables xprtrdma sunrpc ib_isert iscsi_target_mod
ib_iser ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib
rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm
x86_pkg_temp_thermal intel_powerclamp ib_sa ib_mad coretemp kvm_intel
kvm ocrdma dm_mirror ib_core ib_addr crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel dm_region_hash aesni_intel dm_log lrw
gf128mul be2iscsi iTCO_wdt glue_helper ablk_helper sb_edac
iTCO_vendor_support edac_core cryptd ipmi_devintf mei_me lpc_ich
iscsi_boot_sysfs ipmi_si mei pcspkr mfd_core dcdbas libiscsi
scsi_transport_iscsi shpchp wmi ipmi_msghandler acpi_pad
acpi_power_meter dm_multipath dm_mod uinput ext4 mbcache jbd2 mgag200
syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper sd_mod
ttm drm be2net tg3 vxlan ptp ip6_udp_tunnel i2c_core megaraid_sas
udp_tunnel pps_core
[ 1547.779811] CPU: 6 PID: 52 Comm: ksoftirqd/6 Tainted: G      D
   4.1.0-rc1+ #8
[ 1547.788453] Hardware name: Dell Inc. PowerEdge R720/0X6H47, BIOS
2.0.15 07/29/2013
[ 1547.796907]  0000000000000000 000000008e86baba ffff8802378c3d58
ffffffff8174a1e2
[ 1547.805202]  0000000000000000 0000000000000000 ffff8802378c3d98
ffffffff8108c74a
[ 1547.813495]  ffff880200000000 0000000000000000 0000000000000006
000000000000ea28
[ 1547.821789] Call Trace:
[ 1547.824516]  <IRQ>  [<ffffffff8174a1e2>] dump_stack+0x4c/0x65
[ 1547.830959]  [<ffffffff8108c74a>] warn_slowpath_common+0x8a/0xc0
[ 1547.837665]  [<ffffffff8108c87a>] warn_slowpath_null+0x1a/0x20
[ 1547.844168]  [<ffffffff8105ae3d>] native_smp_send_reschedule+0x5d/0x60
[ 1547.851456]  [<ffffffff810d95ad>] trigger_load_balance+0x33d/0x510
[ 1547.858355]  [<ffffffff810d92e4>] ? trigger_load_balance+0x74/0x510
[ 1547.865352]  [<ffffffff810c3b8e>] scheduler_tick+0x9e/0xe0
[ 1547.871476]  [<ffffffff81114651>] update_process_times+0x51/0x60
[ 1547.878172]  [<ffffffff81126ed5>] tick_sched_handle.isra.20+0x25/0x60
[ 1547.885361]  [<ffffffff81127184>] tick_sched_timer+0x44/0x80
[ 1547.891678]  [<ffffffff81115a5d>] __run_hrtimer+0xcd/0x6d0
[ 1547.897794]  [<ffffffff81116272>] ? hrtimer_interrupt+0x92/0x230
[ 1547.904490]  [<ffffffff81127140>] ? tick_sched_do_timer+0x50/0x50
[ 1547.911295]  [<ffffffff811162e3>] hrtimer_interrupt+0x103/0x230
[ 1547.917902]  [<ffffffff8105e689>] local_apic_timer_interrupt+0x39/0x60
[ 1547.925193]  [<ffffffff817571c5>] smp_apic_timer_interrupt+0x45/0x60
[ 1547.932282]  [<ffffffff817551e3>] apic_timer_interrupt+0x73/0x80
[ 1547.938990]  <EOI>  [<ffffffff81743e62>] ? panic+0x1c6/0x20e
[ 1547.945316]  [<ffffffff81743e66>] ? panic+0x1ca/0x20e
[ 1547.950950]  [<ffffffff81743e62>] ? panic+0x1c6/0x20e
[ 1547.956585]  [<ffffffff81022c97>] oops_end+0x117/0x120
[ 1547.962316]  [<ffffffff81743623>] no_context+0x2f3/0x370
[ 1547.968242]  [<ffffffff8174371e>] __bad_area_nosemaphore+0x7e/0x1d7
[ 1547.975235]  [<ffffffff810ea98a>] ? __lock_acquire+0x4aa/0x1430
[ 1547.981840]  [<ffffffff8174388a>] bad_area_nosemaphore+0x13/0x15
[ 1547.988543]  [<ffffffff8107663c>] __do_page_fault+0x8c/0x470
[ 1547.994856]  [<ffffffff81076a50>] do_page_fault+0x30/0x80
[ 1548.000880]  [<ffffffff81754ec7>] ? native_iret+0x7/0x7
[ 1548.006708]  [<ffffffff81756328>] page_fault+0x28/0x30
[ 1548.012445]  [<ffffffffa00949c9>] ? free_rq_clone+0x29/0xb0 [dm_mod]
[ 1548.019538]  [<ffffffffa00949c5>] ? free_rq_clone+0x25/0xb0 [dm_mod]
[ 1548.026631]  [<ffffffffa0095187>] dm_softirq_done+0x137/0x250 [dm_mod]
[ 1548.033915]  [<ffffffff8135d5a8>] blk_done_softirq+0x98/0xc0
[ 1548.040228]  [<ffffffff810929f6>] __do_softirq+0xf6/0x670
[ 1548.046251]  [<ffffffff81092f95>] run_ksoftirqd+0x25/0x80
[ 1548.052274]  [<ffffffff810b8149>] smpboot_thread_fn+0x129/0x1f0
[ 1548.058878]  [<ffffffff810b8020>] ? sort_range+0x30/0x30
[ 1548.064804]  [<ffffffff810b3dde>] kthread+0xfe/0x120
[ 1548.070351]  [<ffffffff810b3ce0>] ? kthread_create_on_node+0x240/0x240
[ 1548.077635]  [<ffffffff817546a2>] ret_from_fork+0x42/0x70
[ 1548.083658]  [<ffffffff810b3ce0>] ? kthread_create_on_node+0x240/0x240
[ 1548.090942] ---[ end trace 94a969e7768856bb ]-
