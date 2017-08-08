From: Ming Lei <ming.lei@redhat.com>
Subject: [v4.13-rc BUG] system lockup when running big buffered write(4M) to
 IB SRP via mpath
Date: Tue, 8 Aug 2017 22:17:16 +0800
Message-ID: <20170808141715.GB22763@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: loberman@redhat.com, bart.vanassche@sandisk.com
List-Id: linux-scsi@vger.kernel.org

Hi Guys,

Laurence and I see a system lockup issue when running concurrent
big buffered write(4M bytes) to IB SRP on v4.13-rc3.

1 how to reproduce

1) setup IB_SRR & multi path

	#./start_opensm.sh
	#./start_srp.sh 

	# cat start_opensm.sh 
	#!/bin/bash
	rmmod ib_srpt
	opensm -F opensm.1.conf &
	opensm -F opensm.2.conf &

	# cat start_srp.sh
	run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i mlx5_0 -p 1 1>/root/srp1.log 2>&1 &
	run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i mlx5_1 -p 1 1>/root/srp2.log 2>&1 &
	

2) run the following test script

	#./test-mp.sh
 
	#cat test-mp.sh 
	#!/bin/sh
	DEVS="360014051186d24cc27b4d049ffff94e3 36001405b2b5c6c24c084b6fa4d55da2f 36001405b26ebe76dcb94a489f6f245f8"

	for i in $DEVS; do
		for j in `seq 0 15`; do
			./hammer_write.sh $i 1>/dev/null 2>&1 &
		done
	done

	#cat hammer_write.sh
	#!/bin/bash
	while true; do
		dd if=/dev/zero of=/dev/mapper/$1 bs=4096k count=800 
	done


2 lockup log
[root@ibclient ~]# ./test-mp.sh 
[root@ibclient ~]# [  169.095494] perf: interrupt took too long (2575 > 2500), lowering kernel.perf_event_max_sample_rate to 77000
[  178.569124] perf: interrupt took too long (3249 > 3218), lowering kernel.perf_event_max_sample_rate to 61000
[  190.586624] perf: interrupt took too long (4066 > 4061), lowering kernel.perf_event_max_sample_rate to 49000
[  210.381836] perf: interrupt took too long (5083 > 5082), lowering kernel.perf_event_max_sample_rate to 39000
[  240.498659] perf: interrupt took too long (6373 > 6353), lowering kernel.perf_event_max_sample_rate to 31000

[root@ibclient ~]# 
[root@ibclient ~]# [  292.252795] perf: interrupt took too long (8006 > 7966), lowering kernel.perf_event_max_sample_rate to 24000
[  410.354443] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.432725] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.499530] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.564952] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.644493] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.698091] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.755175] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.796784] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.837690] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  410.878743] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.476823] multipath_clone_and_map: 32 callbacks suppressed
[  463.506773] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.586752] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.656880] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.698919] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.723572] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.751820] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.781110] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.828267] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.856997] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  463.885998] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.572060] multipath_clone_and_map: 5201 callbacks suppressed
[  468.602191] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.655761] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.697540] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.738610] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.779597] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.820705] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.862712] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.904662] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.945132] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  468.985128] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.643013] multipath_clone_and_map: 6569 callbacks suppressed
[  473.673466] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.713929] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.754989] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.796069] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.849768] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.891640] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.933321] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  473.973791] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  474.016739] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  474.059858] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.732265] multipath_clone_and_map: 6310 callbacks suppressed
[  478.762164] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.802327] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.844235] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.886113] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.927164] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  478.968141] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  479.008772] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  479.060225] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  479.102873] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  479.145341] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  483.834884] multipath_clone_and_map: 5703 callbacks suppressed
[  483.865056] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  483.906792] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  483.959492] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.001768] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.044785] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.087289] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.129854] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.171317] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.212314] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.263931] device-mapper: multipath: blk_get_request() returned -11 - requeuing
[  484.982608] perf: interrupt took too long (10021 > 10007), lowering kernel.perf_event_max_sample_rate to 19000
[  485.362787] watchdog: BUG: soft lockup - CPU#11 stuck for 21s! [ksoftirqd/11:78]
[  485.400762] Modules linked in: dm_round_robin xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat rpcrdma nf_conntrack ib_isert iscsi_target_mod iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ib_iser ip6table_filter ip6_tables libiscsi iptable_filter scsi_transport_iscsi target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_
 pclmul ghash_clmulni_intel
[  485.809222]  pcbc joydev ipmi_si aesni_intel sg hpwdt hpilo crypto_simd iTCO_wdt cryptd iTCO_vendor_support ipmi_devintf gpio_ich glue_helper shpchp lpc_ich ipmi_msghandler acpi_power_meter pcspkr i7core_edac pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod amdkfd amd_iommu_v2 radeon mlx5_core i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlxfw drm ptp hpsa pps_core scsi_transport_sas crc32c_intel bnx2 i2c_core serio_raw devlink dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ib_srpt]
[  486.096352] CPU: 11 PID: 78 Comm: ksoftirqd/11 Tainted: G          I     4.13.0-rc3+ #23
[  486.142775] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  486.178816] task: ffff8a3fe453df40 task.stack: ffff9a6cc65a8000
[  486.212674] RIP: 0010:__blk_recalc_rq_segments+0xb8/0x3d0
[  486.242444] RSP: 0018:ffff9a6cc65aba60 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff10
[  486.284086] RAX: ffff8a4a8e26e440 RBX: 0000000000001000 RCX: ffff8a4a8e26e440
[  486.323445] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff8a4a8e2699c8
[  486.363614] RBP: ffff9a6cc65abae0 R08: 0000000000007000 R09: 0000000000000001
[  486.404621] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000000
[  486.445127] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000007
[  486.486120] FS:  0000000000000000(0000) GS:ffff8a4b66940000(0000) knlGS:0000000000000000
[  486.532771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  486.565772] CR2: 00007f32bfcee000 CR3: 0000000d67609000 CR4: 00000000000006e0
[  486.606325] Call Trace:
[  486.620269]  ? mempool_free+0x2b/0x80
[  486.641248]  blk_recalc_rq_segments+0x28/0x40
[  486.666754]  blk_update_request+0x249/0x310
[  486.690838]  end_clone_bio+0x46/0x70 [dm_mod]
[  486.715949]  bio_endio+0xa1/0x120
[  486.734408]  blk_update_request+0xb7/0x310
[  486.757313]  scsi_end_request+0x38/0x1d0
[  486.779375]  scsi_io_completion+0x13c/0x630
[  486.802928]  scsi_finish_command+0xd9/0x120
[  486.825875]  scsi_softirq_done+0x12a/0x150
[  486.849029]  __blk_mq_complete_request+0x90/0x140
[  486.875484]  blk_mq_complete_request+0x16/0x20
[  486.900631]  scsi_mq_done+0x21/0x70
[  486.920462]  srp_recv_done+0x48f/0x610 [ib_srp]
[  486.946212]  __ib_process_cq+0x5c/0xb0 [ib_core]
[  486.972576]  ib_poll_handler+0x22/0x70 [ib_core]
[  486.998638]  irq_poll_softirq+0xaf/0x110
[  487.021727]  __do_softirq+0xc9/0x269
[  487.042027]  run_ksoftirqd+0x29/0x50
[  487.062675]  smpboot_thread_fn+0x110/0x160
[  487.085597]  kthread+0x109/0x140
[  487.104113]  ? sort_range+0x30/0x30
[  487.124120]  ? kthread_park+0x60/0x60
[  487.144624]  ret_from_fork+0x25/0x30
[  487.164640] Code: c3 83 fa 09 0f 84 8e 01 00 00 48 8b 44 24 20 48 8b 4c 24 28 45 31 ff 45 31 c0 45 31 c9 0f b6 80 36 06 00 00 88 44 24 17 8b 59 28 <44> 8b 71 2c 44 8b 61 34 85 db 0f 84 92 01 00 00 45 89 f5 45 89 

Message from syslogd@ibclient at Aug  8 04:12:23 ...
 kernel:watchdog: BUG: soft lockup - CPU#11 stuck for 21s! [ksoftirqd/11:78]



Thanks,
Ming
