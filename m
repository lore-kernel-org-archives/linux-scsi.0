From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered write(4M)
 to IB SRP via mpath
Date: Wed, 23 Aug 2017 20:46:56 +0800
Message-ID: <20170823124654.GC8130@ming.t460p>
References: <20170808141715.GB22763@ming.t460p>
 <1502237504.4017.1.camel@redhat.com>
 <1502245693.6511.3.camel@redhat.com>
 <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
 <1502298599.2356.7.camel@wdc.com>
 <20170823113526.GA8130@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753953AbdHWMrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 08:47:09 -0400
Content-Disposition: inline
In-Reply-To: <20170823113526.GA8130@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>

On Wed, Aug 23, 2017 at 07:35:26PM +0800, Ming Lei wrote:
> On Wed, Aug 09, 2017 at 05:10:01PM +0000, Bart Van Assche wrote:
> > On Wed, 2017-08-09 at 12:43 -0400, Laurence Oberman wrote:
> > > Your latest patch on stock upstream without Ming's latest patches is 
> > > behaving for me.
> > > 
> > > As already mentioned, the requeue -11 and clone failure messages are 
> > > gone and I am not actually seeing any soft lockups or hard lockups.
> > > 
> > > When Ming gets back I will work with him on his patch set and the lockups.
> > > 
> > > Running 10 parallel writes which easily trips into soft lockups on 
> > > Ming's kernel (even with your patch) has been stable here on 4.13-RC3 
> > > with your patch.
> > > 
> > > I will leave it running for a while now but the patch is good.
> > > 
> > > If it survives 4 hours I will add a Tested-by to your latest patch.
> > 
> > Hello Laurence,
> > 
> > I'm working on an additional patch that should reduce unnecessary requeuing
> > even further. I will let you know when it's ready.
> > 
> > Additionally, please trim e-mails when replying such that e-mails do not get
> > too long.
> 
> soft lockup still can be observed easily with patch d4acf3650c7c(
> block: Make blk_mq_delay_kick_requeue_list() rerun the queue at a quiet time),
> but no hard lockup.
> 
> With the patchset of 'blk-mq-sched: improve SCSI-MQ performance', hard
> lockup can be observed following some failure log:
> 
> 	[  269.277653] device-mapper: multipath: blk_get_request() returned -11 - requeuing
> 	[  269.321244] device-mapper: multipath: blk_get_request() returned -11 - requeuing
> 	...
> 	[  273.421688] scsi host2: SRP abort called
> 	[  273.444577] scsi host2: Sending SRP abort for tag 0x6007e
> 	[  273.673871] scsi host2: Null scmnd for RSP w/tag 0x0000000006007e received on ch 6 / QP 0x30
> 	...
> 	[  274.372110] device-mapper: multipath: blk_get_request() returned -11 - requeuing
> 	[  278.658671] scsi host2: SRP abort called
> 	[  278.690630] scsi host2: SRP abort called
> 	[  278.717634] scsi host2: SRP abort called
> 	[  278.745629] scsi host2: SRP abort called
> 	[  279.083227] multipath_clone_and_map: 1092 callbacks suppressed
> 	....
> 	[  296.210503] scsi host2: SRP reset_device called
> 	....
> 	[  303.784287] NMI watchdog: Watchdog detected hard LOCKUP on cpu 10
> 
> The trick thing is that both hard lockup and soft lockup share
> one same stack trace.

Actually I can reproduce hard lockup too on the latest linus tree(v4.13-rc6+)
by just making the test more aggressive:

1) run hammer_write.sh 32-concurrently. 
2) write 8M each time

So it isn't the patchset of 'blk-mq-sched: improve SCSI-MQ performance'
which causes the lockup.

There must be issue somewhere else, and one thing I saw is that
dm's req's completion handling isn't very efficient:

- when low level driver's req is completed, blk_update_request()
is called from scsi_end_request()

- inside blk_update_request(), end_clone_bio() is called for
each bio

- in end_clone_bio(), blk_update_request() is called to
do partial update for the dm req. That means if one request
has N bios, the same dm req need to do the expensive partial
update N times. In theory, the partial update might be avoided,
I guess the reason is that the dm rq can't be retrieved
via the low level driver's rq.


[1] hard lockup log

[  434.068240] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
[  434.068243] Modules linked in: dm_round_robin xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rpcrdma iptable_mangle ib_isert iscsi_target_mod iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ib_iser libiscsi ip6_tables scsi_transport_iscsi iptable_filter target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_
 pclmul ghash_clmulni_intel
[  434.068279]  pcbc aesni_intel iTCO_wdt crypto_simd gpio_ich ipmi_si iTCO_vendor_support cryptd joydev glue_helper ipmi_devintf hpwdt acpi_power_meter hpilo sg ipmi_msghandler lpc_ich i7core_edac pcspkr shpchp pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod amdkfd amd_iommu_v2 radeon mlx5_core i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlxfw drm ptp hpsa pps_core crc32c_intel serio_raw bnx2 i2c_core devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ib_srpt]
[  434.068314] CPU: 2 PID: 1039 Comm: dd Tainted: G          I     4.13.0-rc6.linus+ #28
[  434.068314] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  434.068316] task: ffff9458f4498040 task.stack: ffffbdb48fd10000
[  434.068323] RIP: 0010:__blk_recalc_rq_segments+0xd9/0x3d0
[  434.068324] RSP: 0018:ffff945b37a43d08 EFLAGS: 00000086
[  434.068325] RAX: ffff9458978a16c0 RBX: 0000000000001000 RCX: ffff9458978a16c0
[  434.068326] RDX: 0000000000000000 RSI: ffff9458978a1748 RDI: ffff9458978a69c8
[  434.068327] RBP: ffff945b37a43d88 R08: 0000000000014000 R09: 0000000000000001
[  434.068328] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  434.068329] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000001d
[  434.068330] FS:  00007f27b13ea740(0000) GS:ffff945b37a40000(0000) knlGS:0000000000000000
[  434.068331] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  434.068332] CR2: 00007f27aa600000 CR3: 0000000b1e2af000 CR4: 00000000000006e0
[  434.068333] Call Trace:
[  434.068335]  <IRQ>
[  434.068340]  ? mempool_free+0x2b/0x80
[  434.068343]  blk_recalc_rq_segments+0x28/0x40
[  434.068345]  blk_update_request+0x249/0x310
[  434.068363]  end_clone_bio+0x46/0x70 [dm_mod]
[  434.068367]  bio_endio+0xa1/0x120
[  434.068370]  blk_update_request+0xb7/0x310
[  434.068374]  scsi_end_request+0x38/0x1d0
[  434.068375]  scsi_io_completion+0x13c/0x630
[  434.068378]  scsi_finish_command+0xd9/0x120
[  434.068381]  scsi_softirq_done+0x12a/0x150
[  434.068383]  __blk_mq_complete_request_remote+0x13/0x20
[  434.068387]  flush_smp_call_function_queue+0x52/0x110
[  434.068388]  generic_smp_call_function_single_interrupt+0x13/0x30
[  434.068391]  smp_call_function_single_interrupt+0x27/0x40
[  434.068393]  call_function_single_interrupt+0x93/0xa0
[  434.068396] RIP: 0010:copy_user_generic_string+0x2c/0x40
[  434.068397] RSP: 0018:ffffbdb48fd13c78 EFLAGS: 00010246 ORIG_RAX: ffffffffffffff04
[  434.068398] RAX: 00007f27aa1f3000 RBX: 0000000000001000 RCX: 0000000000000040
[  434.068399] RDX: 0000000000000000 RSI: 00007f27aa1f2e00 RDI: ffff945a2f7b9e00
[  434.068400] RBP: ffffbdb48fd13c80 R08: ffff945a2fcf20b0 R09: 0000000000001000
[  434.068400] R10: 00000000fffff000 R11: 0000000000000000 R12: 0000000000001000
[  434.068401] R13: ffff945a2f7ba000 R14: ffffbdb48fd13e20 R15: ffff945be4817950
[  434.068402]  </IRQ>
[  434.068405]  ? I_BDEV+0x20/0x20
[  434.068408]  ? copyin+0x26/0x30
[  434.068410]  iov_iter_copy_from_user_atomic+0xbd/0x2d0
[  434.068412]  generic_perform_write+0xdd/0x1b0
[  434.068415]  __generic_file_write_iter+0x19b/0x1e0
[  434.068416]  blkdev_write_iter+0x8a/0x100
[  434.068420]  __vfs_write+0xf3/0x170
[  434.068423]  vfs_write+0xb2/0x1b0
[  434.068427]  ? syscall_trace_enter+0x1d0/0x2b0
[  434.068429]  SyS_write+0x55/0xc0
[  434.068431]  do_syscall_64+0x67/0x150
[  434.068434]  entry_SYSCALL64_slow_path+0x25/0x25
[  434.068435] RIP: 0033:0x7f27b0f0dc90
[  434.068436] RSP: 002b:00007ffe24d1d178 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  434.068438] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f27b0f0dc90
[  434.068438] RDX: 0000000000800000 RSI: 00007f27aa0fa000 RDI: 0000000000000001
[  434.068439] RBP: 0000000000800000 R08: ffffffffffffffff R09: 0000000000802003
[  434.068440] R10: 00007ffe24d1cf00 R11: 0000000000000246 R12: 0000000000800000
[  434.068441] R13: 00007f27aa0fa000 R14: 00007f27aa8fa000 R15: 0000000000000000
[  434.068442] Code: 06 00 00 88 44 24 17 8b 59 28 44 8b 71 2c 44 8b 61 34 85 db 0f 84 92 01 00 00 45 89 f5 45 89 e2 4c 89 ee 48 c1 e6 04 48 03 71 78 <8b> 46 08 48 8b 16 44 29 e0 48 89 54 24 30 39 d8 0f 47 c3 44 03 
[  434.068461] Kernel panic - not syncing: Hard LOCKUP
[  434.068463] CPU: 2 PID: 1039 Comm: dd Tainted: G          I     4.13.0-rc6.linus+ #28
[  434.068463] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  434.068463] Call Trace:
[  434.068464]  <NMI>
[  434.068467]  dump_stack+0x63/0x87
[  434.068470]  panic+0xeb/0x245
[  434.068472]  nmi_panic+0x3f/0x40
[  434.068477]  watchdog_overflow_callback+0x106/0x130
[  434.068480]  __perf_event_overflow+0x54/0xe0
[  434.068482]  perf_event_overflow+0x14/0x20
[  434.068486]  intel_pmu_handle_irq+0x203/0x4b0
[  434.068490]  perf_event_nmi_handler+0x2d/0x50
[  434.068492]  nmi_handle+0x61/0x110
[  434.068494]  default_do_nmi+0xf6/0x120
[  434.068495]  do_nmi+0x113/0x190
[  434.068497]  end_repeat_nmi+0x1a/0x1e
[  434.068499] RIP: 0010:__blk_recalc_rq_segments+0xd9/0x3d0
[  434.068499] RSP: 0018:ffff945b37a43d08 EFLAGS: 00000086
[  434.068500] RAX: ffff9458978a16c0 RBX: 0000000000001000 RCX: ffff9458978a16c0
[  434.068501] RDX: 0000000000000000 RSI: ffff9458978a1748 RDI: ffff9458978a69c8
[  434.068502] RBP: ffff945b37a43d88 R08: 0000000000014000 R09: 0000000000000001
[  434.068502] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  434.068503] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000001d
[  434.068505]  ? __blk_recalc_rq_segments+0xd9/0x3d0
[  434.068508]  ? __blk_recalc_rq_segments+0xd9/0x3d0
[  434.068510]  </NMI>
[  434.068510]  <IRQ>
[  434.068512]  ? mempool_free+0x2b/0x80
[  434.068514]  blk_recalc_rq_segments+0x28/0x40
[  434.068516]  blk_update_request+0x249/0x310
[  434.068521]  end_clone_bio+0x46/0x70 [dm_mod]
[  434.068522]  bio_endio+0xa1/0x120
[  434.068523]  blk_update_request+0xb7/0x310
[  434.068525]  scsi_end_request+0x38/0x1d0
[  434.068527]  scsi_io_completion+0x13c/0x630
[  434.068528]  scsi_finish_command+0xd9/0x120
[  434.068531]  scsi_softirq_done+0x12a/0x150
[  434.068534]  __blk_mq_complete_request_remote+0x13/0x20
[  434.068536]  flush_smp_call_function_queue+0x52/0x110
[  434.068537]  generic_smp_call_function_single_interrupt+0x13/0x30
[  434.068539]  smp_call_function_single_interrupt+0x27/0x40
[  434.068542]  call_function_single_interrupt+0x93/0xa0
[  434.068543] RIP: 0010:copy_user_generic_string+0x2c/0x40
[  434.068544] RSP: 0018:ffffbdb48fd13c78 EFLAGS: 00010246 ORIG_RAX: ffffffffffffff04
[  434.068545] RAX: 00007f27aa1f3000 RBX: 0000000000001000 RCX: 0000000000000040
[  434.068546] RDX: 0000000000000000 RSI: 00007f27aa1f2e00 RDI: ffff945a2f7b9e00
[  434.068546] RBP: ffffbdb48fd13c80 R08: ffff945a2fcf20b0 R09: 0000000000001000
[  434.068547] R10: 00000000fffff000 R11: 0000000000000000 R12: 0000000000001000
[  434.068548] R13: ffff945a2f7ba000 R14: ffffbdb48fd13e20 R15: ffff945be4817950
[  434.068548]  </IRQ>
[  434.068550]  ? I_BDEV+0x20/0x20
[  434.068551]  ? copyin+0x26/0x30
[  434.068553]  iov_iter_copy_from_user_atomic+0xbd/0x2d0
[  434.068554]  generic_perform_write+0xdd/0x1b0
[  434.068557]  __generic_file_write_iter+0x19b/0x1e0
[  434.068560]  blkdev_write_iter+0x8a/0x100
[  434.068562]  __vfs_write+0xf3/0x170
[  434.068565]  vfs_write+0xb2/0x1b0
[  434.068566]  ? syscall_trace_enter+0x1d0/0x2b0
[  434.068568]  SyS_write+0x55/0xc0
[  434.068569]  do_syscall_64+0x67/0x150
[  434.068572]  entry_SYSCALL64_slow_path+0x25/0x25
[  434.068573] RIP: 0033:0x7f27b0f0dc90
[  434.068574] RSP: 002b:00007ffe24d1d178 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  434.068575] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f27b0f0dc90
[  434.068576] RDX: 0000000000800000 RSI: 00007f27aa0fa000 RDI: 0000000000000001
[  434.068577] RBP: 0000000000800000 R08: ffffffffffffffff R09: 0000000000802003
[  434.068578] R10: 00007ffe24d1cf00 R11: 0000000000000246 R12: 0000000000800000
[  434.068579] R13: 00007f27aa0fa000 R14: 00007f27aa8fa000 R15: 0000000000000000
[  434.100416] Kernel Offset: 0x13800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  438.636598] ---[ end Kernel panic - not syncing: Hard LOCKUP


-- 
Ming
