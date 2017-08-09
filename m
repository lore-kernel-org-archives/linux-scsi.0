From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered
 write(4M) to IB SRP via mpath
Date: Tue, 08 Aug 2017 22:28:13 -0400
Message-ID: <1502245693.6511.3.camel@redhat.com>
References: <20170808141715.GB22763@ming.t460p>
         <1502237504.4017.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35038 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdHIC2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 22:28:17 -0400
Received: by mail-qk0-f176.google.com with SMTP id d145so29358505qkc.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 19:28:16 -0700 (PDT)
In-Reply-To: <1502237504.4017.1.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
Cc: "Van Assche, Bart" <bart.vanassche@sandisk.com>

On Tue, 2017-08-08 at 20:11 -0400, Laurence Oberman wrote:
> > On Tue, 2017-08-08 at 22:17 +0800, Ming Lei wrote:
> > > > Hi Guys,
> > > > 
> > > > Laurence and I see a system lockup issue when running
> > concurrent
> > > > big buffered write(4M bytes) to IB SRP on v4.13-rc3.
> > > > 
> > > > 1 how to reproduce
> > > > 
> > > > 1) setup IB_SRR & multi path
> > > > 
> > > > 	#./start_opensm.sh
> > > > 	#./start_srp.sh 
> > > > 
> > > > 	# cat start_opensm.sh 
> > > > 	#!/bin/bash
> > > > 	rmmod ib_srpt
> > > > 	opensm -F opensm.1.conf &
> > > > 	opensm -F opensm.2.conf &
> > > > 
> > > > 	# cat start_srp.sh
> > > > 	run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10
> > -t 7000
> > > > -ance -i mlx5_0 -p 1 1>/root/srp1.log 2>&1 &
> > > > 	run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10
> > -t 7000
> > > > -ance -i mlx5_1 -p 1 1>/root/srp2.log 2>&1 &
> > > > 	
> > > > 
> > > > 2) run the following test script
> > > > 
> > > > 	#./test-mp.sh
> > > >  
> > > > 	#cat test-mp.sh 
> > > > 	#!/bin/sh
> > > > 	DEVS="360014051186d24cc27b4d049ffff94e3
> > > > 36001405b2b5c6c24c084b6fa4d55da2f
> > > > 36001405b26ebe76dcb94a489f6f245f8"
> > > > 
> > > > 	for i in $DEVS; do
> > > > 		for j in `seq 0 15`; do
> > > > 			./hammer_write.sh $i 1>/dev/null 2>&1 &
> > > > 		done
> > > > 	done
> > > > 
> > > > 	#cat hammer_write.sh
> > > > 	#!/bin/bash
> > > > 	while true; do
> > > > 		dd if=/dev/zero of=/dev/mapper/$1 bs=4096k
> > count=800 
> > > > 	done
> > > > 
> > > > 
> > > > 2 lockup log
> > > > [root@ibclient ~]# ./test-mp.sh 
> > > > [root@ibclient ~]# [  169.095494] perf: interrupt took too long
> > > > (2575
> > > > > > 2500), lowering kernel.perf_event_max_sample_rate to 77000
> > 
> > > > 
> > > > [  178.569124] perf: interrupt took too long (3249 > 3218),
> > > > lowering
> > > > kernel.perf_event_max_sample_rate to 61000
> > > > [  190.586624] perf: interrupt took too long (4066 > 4061),
> > > > lowering
> > > > kernel.perf_event_max_sample_rate to 49000
> > > > [  210.381836] perf: interrupt took too long (5083 > 5082),
> > > > lowering
> > > > kernel.perf_event_max_sample_rate to 39000
> > > > [  240.498659] perf: interrupt took too long (6373 > 6353),
> > > > lowering
> > > > kernel.perf_event_max_sample_rate to 31000
> > > > 
> > > > [root@ibclient ~]# 
> > > > [root@ibclient ~]# [  292.252795] perf: interrupt took too long
> > > > (8006
> > > > > > 7966), lowering kernel.perf_event_max_sample_rate to 24000
> > 
> > > > 
> > > > [  410.354443] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.432725] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.499530] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.564952] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.644493] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.698091] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.755175] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.796784] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.837690] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  410.878743] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.476823] multipath_clone_and_map: 32 callbacks suppressed
> > > > [  463.506773] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.586752] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.656880] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.698919] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.723572] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.751820] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.781110] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.828267] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.856997] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  463.885998] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.572060] multipath_clone_and_map: 5201 callbacks
> > suppressed
> > > > [  468.602191] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.655761] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.697540] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.738610] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.779597] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.820705] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.862712] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.904662] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.945132] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  468.985128] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.643013] multipath_clone_and_map: 6569 callbacks
> > suppressed
> > > > [  473.673466] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.713929] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.754989] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.796069] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.849768] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.891640] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.933321] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  473.973791] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  474.016739] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  474.059858] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.732265] multipath_clone_and_map: 6310 callbacks
> > suppressed
> > > > [  478.762164] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.802327] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.844235] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.886113] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.927164] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  478.968141] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  479.008772] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  479.060225] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  479.102873] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  479.145341] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  483.834884] multipath_clone_and_map: 5703 callbacks
> > suppressed
> > > > [  483.865056] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  483.906792] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  483.959492] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.001768] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.044785] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.087289] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.129854] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.171317] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.212314] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.263931] device-mapper: multipath: blk_get_request()
> > returned
> > > > -11 - requeuing
> > > > [  484.982608] perf: interrupt took too long (10021 > 10007),
> > > > lowering kernel.perf_event_max_sample_rate to 19000
> > > > [  485.362787] watchdog: BUG: soft lockup - CPU#11 stuck for
> > 21s!
> > > > [ksoftirqd/11:78]
> > > > [  485.400762] Modules linked in: dm_round_robin xt_CHECKSUM
> > > > ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter
> > ipt_REJECT
> > > > nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
> > > > nfnetlink ebtable_nat ebtable_broute bridge stp llc
> > ip6table_nat
> > > > nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
> > > > ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4
> > > > nf_defrag_ipv4 nf_nat_ipv4 nf_nat rpcrdma nf_conntrack ib_isert
> > > > iscsi_target_mod iptable_mangle iptable_security iptable_raw
> > > > ebtable_filter ebtables ib_iser ip6table_filter ip6_tables
> > libiscsi
> > > > iptable_filter scsi_transport_iscsi target_core_mod ib_srp
> > > > scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> > > > rdma_cm
> > > > ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel
> > kvm
> > > > irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> > > > [  485.809222]  pcbc joydev ipmi_si aesni_intel sg hpwdt hpilo
> > > > crypto_simd iTCO_wdt cryptd iTCO_vendor_support ipmi_devintf
> > > > gpio_ich
> > > > glue_helper shpchp lpc_ich ipmi_msghandler acpi_power_meter
> > pcspkr
> > > > i7core_edac pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace
> > sunrpc
> > > > dm_multipath ip_tables xfs libcrc32c sd_mod amdkfd amd_iommu_v2
> > > > radeon mlx5_core i2c_algo_bit drm_kms_helper syscopyarea
> > > > sysfillrect
> > > > sysimgblt fb_sys_fops ttm mlxfw drm ptp hpsa pps_core
> > > > scsi_transport_sas crc32c_intel bnx2 i2c_core serio_raw devlink
> > > > dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ib_srpt]
> > > > [  486.096352] CPU: 11 PID: 78 Comm: ksoftirqd/11 Tainted:
> > > > G          I     4.13.0-rc3+ #23
> > > > [  486.142775] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > > 08/16/2015
> > > > [  486.178816] task: ffff8a3fe453df40 task.stack:
> > ffff9a6cc65a8000
> > > > [  486.212674] RIP: 0010:__blk_recalc_rq_segments+0xb8/0x3d0
> > > > [  486.242444] RSP: 0018:ffff9a6cc65aba60 EFLAGS: 00000282
> > > > ORIG_RAX:
> > > > ffffffffffffff10
> > > > [  486.284086] RAX: ffff8a4a8e26e440 RBX: 0000000000001000 RCX:
> > > > ffff8a4a8e26e440
> > > > [  486.323445] RDX: 0000000000000000 RSI: 0000000000001000 RDI:
> > > > ffff8a4a8e2699c8
> > > > [  486.363614] RBP: ffff9a6cc65abae0 R08: 0000000000007000 R09:
> > > > 0000000000000001
> > > > [  486.404621] R10: 0000000000001000 R11: 0000000000000000 R12:
> > > > 0000000000000000
> > > > [  486.445127] R13: 0000000000000000 R14: 0000000000000001 R15:
> > > > 0000000000000007
> > > > [  486.486120] FS:  0000000000000000(0000)
> > > > GS:ffff8a4b66940000(0000)
> > > > knlGS:0000000000000000
> > > > [  486.532771] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > > > [  486.565772] CR2: 00007f32bfcee000 CR3: 0000000d67609000 CR4:
> > > > 00000000000006e0
> > > > [  486.606325] Call Trace:
> > > > [  486.620269]  ? mempool_free+0x2b/0x80
> > > > [  486.641248]  blk_recalc_rq_segments+0x28/0x40
> > > > [  486.666754]  blk_update_request+0x249/0x310
> > > > [  486.690838]  end_clone_bio+0x46/0x70 [dm_mod]
> > > > [  486.715949]  bio_endio+0xa1/0x120
> > > > [  486.734408]  blk_update_request+0xb7/0x310
> > > > [  486.757313]  scsi_end_request+0x38/0x1d0
> > > > [  486.779375]  scsi_io_completion+0x13c/0x630
> > > > [  486.802928]  scsi_finish_command+0xd9/0x120
> > > > [  486.825875]  scsi_softirq_done+0x12a/0x150
> > > > [  486.849029]  __blk_mq_complete_request+0x90/0x140
> > > > [  486.875484]  blk_mq_complete_request+0x16/0x20
> > > > [  486.900631]  scsi_mq_done+0x21/0x70
> > > > [  486.920462]  srp_recv_done+0x48f/0x610 [ib_srp]
> > > > [  486.946212]  __ib_process_cq+0x5c/0xb0 [ib_core]
> > > > [  486.972576]  ib_poll_handler+0x22/0x70 [ib_core]
> > > > [  486.998638]  irq_poll_softirq+0xaf/0x110
> > > > [  487.021727]  __do_softirq+0xc9/0x269
> > > > [  487.042027]  run_ksoftirqd+0x29/0x50
> > > > [  487.062675]  smpboot_thread_fn+0x110/0x160
> > > > [  487.085597]  kthread+0x109/0x140
> > > > [  487.104113]  ? sort_range+0x30/0x30
> > > > [  487.124120]  ? kthread_park+0x60/0x60
> > > > [  487.144624]  ret_from_fork+0x25/0x30
> > > > [  487.164640] Code: c3 83 fa 09 0f 84 8e 01 00 00 48 8b 44 24
> > 20
> > > > 48
> > > > 8b 4c 24 28 45 31 ff 45 31 c0 45 31 c9 0f b6 80 36 06 00 00 88
> > 44
> > > > 24
> > > > 17 8b 59 28 <44> 8b 71 2c 44 8b 61 34 85 db 0f 84 92 01 00 00
> > 45 89
> > > > f5 45 89 
> > > > 
> > > > Message from syslogd@ibclient at Aug  8 04:12:23 ...
> > > >  kernel:watchdog: BUG: soft lockup - CPU#11 stuck for 21s!
> > > > [ksoftirqd/11:78]
> > > > 
> > > > 
> > > > 
> > > > Thanks,
> > > > Ming
> 
> > 
> > Hello Bart
> > 
> > I received your message but my work email is not seeing it.
> > So I am replying to the original email by Ming so I can properly
> > respond to your most recent message pasted below and keep the
> thread
> > in
> > the right flow.
> > 
> > I am purposefully testing buffered I/O because as you know that was
> a
> > source of pain for us last year.
> > So yes my intention always is to run large buffered and un-buffered
> > (direct) sequential I/O as its part of my regular tests that have
> > been
> > very useful in discovering many issues.
> > I also have smaller random and sequential I/O tests driven by fio
> > that
> > were not seeing the issue.
> > 
> > I will go ahead and test your patch below. I am not surprised Ming
> > was
> > able to make this happen on the stock 4.13-RC3 but he had to run 16
> > parallel jobs.
> > 
> > It was happening on his kernel with only 3 parallel jobs and had
> not
> > been happening for me with 3 parallel runs on stock upstream but
> > perhaps just takes longer on 4.13-RC3 so 16 parallel runs brings it
> > out.
> > 
> > Just one other small point, this is a "hard", not soft lockup. 
> > 
> > Unfortunately on the 7.3 base I am unable to capture a full vmcore
> > when
> > running the latest upstream kernel so if I need to get a vmcore I
> > will
> > have to use Fedora and the latest upstream.
> > 
> > I will do that if your patch is not successful but reading it and
> > looking at the stack dumps I have, it makes sense.
> > 
> > back in a bit
> > 
> > Thanks
> > Laurence
> > 
> > ----
> > Hello Laurence,
> > 
> > Is your goal perhaps to simulate a DDN workload? In that case I
> think
> > you
> > need oflag=direct to the dd argument list such that the page cache
> > writeback
> > code does not alter the size of the write requests. Anyway, this
> test
> > should
> > not trigger a lockup. Can you check whether the patch below makes
> the
> > soft
> > lockup complaints disappear (without changing the hammer_write.sh
> > test
> > script)?
> > 
> > Thanks,
> > 
> > Bart.
> > -----------------------------------------------------------------
> ----
> > -------
> > [PATCH] block: Make blk_mq_delay_kick_requeue_list() rerun the
> queue
> > at
> > a
> > quiet time
> > 
> > Drivers like dm-mpath requeue requests if no paths are available
> and
> > if configured to do so. If the queue depth is sufficiently high and
> > the queue rerunning delay sufficiently short then .requeue_work can
> > be queued so often that other work items queued on the same work
> > queue
> > do not get executed. Avoid that this happens by only rerunning the
> > queue after no blk_mq_delay_kick_requeue_list() calls have occurred
> > during @msecs milliseconds. Since the device mapper core is the
> only
> > user of blk_mq_delay_kick_requeue_list(), modify the implementation
> > of this function instead of creating a new function.
> > 
> > Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> > ---
> >  block/blk-mq.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 041f7b7fa0d6..8bfea36e92f9 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -679,8 +679,8 @@ EXPORT_SYMBOL(blk_mq_kick_requeue_list);
> >  void blk_mq_delay_kick_requeue_list(struct request_queue *q,
> >                                     unsigned long msecs)
> >  {
> > -       kblockd_schedule_delayed_work(&q->requeue_work,
> > -                                     msecs_to_jiffies(msecs));
> > +       kblockd_mod_delayed_work_on(WORK_CPU_UNBOUND, &q-
> > >requeue_work,
> > +                                   msecs_to_jiffies(msecs));
> >  }
> >  EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
> > -----

Hello Bart

So the patch is working to avoid the clone failures messages and
requeue -11 messages of my original issue however both the hard lockup
and soft lockup persists. It's is a lot harder to get the hard lockup
now though with the patch.

The soft LOCKUPS due to the spins on the ksoftirqd are almost expected
because of how hard we are driving this and are easy to recreate.

I did boot the original Ming kernel and reproduced first for baseline. 
I then patched it with your simple patch.

I was not paying enough attention to Ming's message but he was seeing a
ksoftirq soft LOCKUP on the stock upstream kernel NOT the hard LOCKUP.
I did not check his log message carefully so assumed he meant hard
LOCKUP.

I guess that's why you said "soft LOCKUP" 

I did get into a few soft lockups before I hit another hard LOCKUP.

So I am now again not sure about the hard LOCKUP on the stock and 7.4
kernel. I will have to retest and baseline myself as Ming is away now
on vacation.

The soft lockups still happen but they recover unless panic_on_
soft_lockup is set and I almost expect them with how the softirqd is
spinning here.

We see high spin rates here and I am only running 7 parallel writes.

 PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
COMMAND     
   20 root      20   0       0      0      0 R 100.0  0.0   0:27.11
kworker/u6+ 
   24 root      20   0       0      0      0 R 100.0  0.0   0:21.56
ksoftirqd/2 
   60 root      20   0       0      0      0 R 100.0  0.0   0:34.61
ksoftirqd/8 

We see high SYS time because of the spinning so the soft LOCKUP is not
unexpected to be honest and it recovers.

#         <----CPU[HYPER]-----><-----------Memory-----------><---------
-Disks----------->
#Time     cpu sys inter  ctxsw Free Buff Cach Inac Slab  Map
KBRead  Reads KBWrit Writes 
21:32:11   52  52 11526  45981  65G  21G 541M  22G   7G
209M     45     11 709791    211 
21:32:12   49  49 13315  26037  65G  21G 541M  22G   6G
209M      0      0 606356    195 
21:32:13   47  47 13375  21456  65G  21G 541M  22G   6G
209M      0      0 591468    250 
21:32:14   33  33 12635    978  65G  21G 541M  22G   5G
209M      0      0 560860    365 
21:32:15   40  40 14304    734  67G  19G 541M  20G   5G
209M      0      0 429472     97 
21:32:16   36  36 16060   6220  70G  17G 541M  17G   4G
209M      0      0 312852     54 
21:32:17   31  31 16071   4962  71G  16G 540M  16G   4G
209M     24      6 253228     44 
21:32:18   31  31 15855    868  70G  17G 540M  18G   6G
209M    104     26 237696     62 
21:32:19   31  31 15983    661  70G  17G 541M  17G   7G
209M      0      0 162340     37 
21:32:20   32  32 16245   1413  70G  17G 541M  18G   9G
209M     68     17 155648     19 
21:32:21   44  44 14919  21711  68G  19G 540M  19G  10G
209M      0      0 303104     32 
21:32:22   59  59 11661  69544  68G  19G 541M  20G  10G
209M      0      0 620919     84 
21:32:23   59  59 12951   1058  67G  20G 540M  20G  10G
209M      0      0 596582    126 
21:32:24   68  67 12991   2077  66G  21G 540M  21G  10G
209M      0      0 689504    168 
21:32:25   78  78 13295   2927  66G  21G 541M  21G  10G
209M      0      0 667673    144 
21:32:26   66  66 13498   7670  65G  21G 541M  22G  10G
209M      0      0 626874     98 
21:32:27   55  55 12203   2663  65G  21G 541M  22G   9G
209M      0      0 652096    112 
21:32:28   47  47 12567  27804  65G  21G 541M  22G   8G
209M      0      0 534789    137

We are driving this system pretty hard here and the target server is
seeing queue fulls and I am used to these if I drive it too hard.

[  568.707572] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.745714] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.783735] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.821583] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.858238] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.895975] ib_srpt srpt_queue_response: IB send queue full (needed
0)
[  568.934253] ib_srpt srpt_write_pending: IB send queue full (needed
97)
[  568.971040] ib_srpt srpt_write_pending: IB send queue full (needed
49)

So your patch helps to avoid easily getting the hard LOCKUP, does not
help the Soft lockup (as expected).

[  329.305507] watchdog: BUG: soft lockup - CPU#12 stuck for 21s!
[ksoftirqd/12:84]
[  329.305508] Modules linked in: dm_round_robin mq_deadline
xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter
ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack
ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat rpcrdma nf_conntrack ib_isert
iptable_mangle iptable_security iscsi_target_mod iptable_raw
ebtable_filter ebtables ip6table_filter ib_iser ip6_tables libiscsi
iptable_filter scsi_transport_iscsi target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm
ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul
[  329.305543]  ghash_clmulni_intel pcbc joydev aesni_intel ipmi_si sg
hpilo ipmi_devintf hpwdt crypto_simd iTCO_wdt gpio_ich
iTCO_vendor_support cryptd shpchp acpi_power_meter ipmi_msghandler
i7core_edac glue_helper pcspkr lpc_ich pcc_cpufreq nfsd auth_rpcgss
nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod
amdkfd amd_iommu_v2 radeon mlx5_core i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlxfw ptp drm
pps_core hpsa i2c_core devlink crc32c_intel serio_raw bnx2
scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: ib_srpt]
[  329.305564] CPU: 12 PID: 84 Comm: ksoftirqd/12 Tainted:
G          I     4.13.0-rc3.ming.bart+ #1
[  329.305566] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  329.305567] task: ffff91a94c070040 task.stack: ffffaa8ec65d8000
[  329.305573] RIP: 0010:__blk_recalc_rq_segments+0x1a7/0x3d0
[  329.305574] RSP: 0018:ffffaa8ec65dba60 EFLAGS: 00000202 ORIG_RAX:
ffffffffffffff10
[  329.305575] RAX: 0000000000000001 RBX: 0000000000001000 RCX:
ffff91b1149239c0
[  329.305576] RDX: 0000000000001000 RSI: 0000000000000001 RDI:
0000000000001000
[  329.305577] RBP: ffffaa8ec65dbae0 R08: 0000000000001000 R09:
0000000000000001
[  329.305578] R10: 0000000b2a506000 R11: 0000000000000000 R12:
0000000000000000
[  329.305579] R13: 0000000000000000 R14: 0000000000000000 R15:
000000000000002e
[  329.305580] FS:  0000000000000000(0000) GS:ffff91b3b7b80000(0000)
knlGS:0000000000000000
[  329.305581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  329.305582] CR2: 00007ff4591f1860 CR3: 0000000985e09000 CR4:
00000000000006e0
[  329.305583] Call Trace:
[  329.305588]  ? mempool_free+0x2b/0x80
[  329.305590]  blk_recalc_rq_segments+0x28/0x40
[  329.305592]  blk_update_request+0x249/0x310
[  329.305603]  end_clone_bio+0x46/0x70 [dm_mod]
[  329.305607]  bio_endio+0xa1/0x120
[  329.305608]  blk_update_request+0xb7/0x310
[  329.305611]  scsi_end_request+0x38/0x1d0
[  329.305613]  scsi_io_completion+0x13c/0x630
[  329.305615]  scsi_finish_command+0xd9/0x120
[  329.305616]  scsi_softirq_done+0x12a/0x150
[  329.305618]  __blk_mq_complete_request+0x90/0x140
[  329.305624]  blk_mq_complete_request+0x16/0x20
[  329.305625]  scsi_mq_done+0x21/0x70
[  329.305628]  srp_recv_done+0x48f/0x610 [ib_srp]
[  329.305639]  __ib_process_cq+0x5c/0xb0 [ib_core]
[  329.305646]  ib_poll_handler+0x22/0x70 [ib_core]
[  329.305649]  irq_poll_softirq+0xaf/0x110
[  329.305652]  __do_softirq+0xc9/0x269
[  329.305655]  run_ksoftirqd+0x29/0x50
[  329.305657]  smpboot_thread_fn+0x110/0x160
[  329.305659]  kthread+0x109/0x140
[  329.305660]  ? sort_range+0x30/0x30
[  329.305661]  ? kthread_park+0x60/0x60
[  329.305663]  ret_from_fork+0x25/0x30
[  329.305664] Code: 8b 74 24 30 48 8b 7c 24 38 41 83 c7 01 41 89 d0 41
b9 01 00 00 00 48 89 74 24 40 48 89 7c 24 48 8b 41 14 0f b6 f0 25 fb 00
00 00 <83> f8 03 0f 84 a0 00 00 00 83 fe 05 0f 84 97 00 00 00 83 fe 09 
[  331.465885] CPU: 4 PID: 36 Comm: ksoftirqd/4 Tainted:
G          I  L  4.13.0-rc3.ming.bart+ #1
[  331.516413] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  331.551403] task: ffff91a94c76df40 task.stack: ffffaa8ec6458000
[  331.584080] RIP: 0010:__blk_recalc_rq_segments+0xdf/0x3d0
[  331.614515] RSP: 0018:ffffaa8ec645ba60 EFLAGS: 00000286 ORIG_RAX:
ffffffffffffff10
[  331.656098] RAX: 0000000000001000 RBX: 0000000000001000 RCX:
ffff91b29faecdc0
[  331.696577] RDX: ffffe839e5d75300 RSI: ffff91b29faece48 RDI:
ffff91b2831f8348
[  331.736607] RBP: ffffaa8ec645bae0 R08: 0000000000004000 R09:
0000000000000001
[  331.776129] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  331.817085] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000021
[  331.857671] FS:  0000000000000000(0000) GS:ffff91b3b7a80000(0000)
knlGS:0000000000000000
[  331.904232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  331.935249] CR2: 00007f404526e000 CR3: 0000000985e09000 CR4:
00000000000006e0
[  331.976273] Call Trace:
[  331.990216]  ? mempool_free+0x2b/0x80
[  332.010310]  blk_recalc_rq_segments+0x28/0x40
[  332.034810]  blk_update_request+0x249/0x310
[  332.058259]  end_clone_bio+0x46/0x70 [dm_mod]
[  332.082851]  bio_endio+0xa1/0x120
[  332.101145]  blk_update_request+0xb7/0x310
[  332.123965]  scsi_end_request+0x38/0x1d0
[  332.145943]  scsi_io_completion+0x13c/0x630
[  332.169357]  scsi_finish_command+0xd9/0x120
[  332.193505]  scsi_softirq_done+0x12a/0x150
[  332.217044]  __blk_mq_complete_request+0x90/0x140
[  332.244498]  blk_mq_complete_request+0x16/0x20
[  332.269971]  scsi_mq_done+0x21/0x70
[  332.289591]  srp_recv_done+0x48f/0x610 [ib_srp]
[  332.315609]  __ib_process_cq+0x5c/0xb0 [ib_core]
[  332.342144]  ib_poll_handler+0x22/0x70 [ib_core]
[  332.368724]  irq_poll_softirq+0xaf/0x110
[  332.392595]  __do_softirq+0xc9/0x269
[  332.413220]  run_ksoftirqd+0x29/0x50
[  332.433214]  smpboot_thread_fn+0x110/0x160
[  332.456254]  kthread+0x109/0x140
[  332.475263]  ? sort_range+0x30/0x30
[  332.494624]  ? kthread_park+0x60/0x60
[  332.515413]  ret_from_fork+0x25/0x30
[  332.535180] Code: 17 8b 59 28 44 8b 71 2c 44 8b 61 34 85 db 0f 84 92
01 00 00 45 89 f5 45 89 e2 4c 89 ee 48 c1 e6 04 48 03 71 78 8b 46 08 48
8b 16 <44> 29 e0 48 89 54 24 30 39 d8 0f 47 c3 44 03 56 0c 45 84 db 89 

Message from syslogd@ibclient at Aug  8 22:06:38 ...
 kernel:watchdog: BUG: soft lockup - CPU#4 stuck for 23s!
[ksoftirqd/4:36]

Message from syslogd@ibclient at Aug  8 22:06:38 ...
 kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 21s!
[ksoftirqd/12:84]

I am going to leave this running overnight and see if I wake up to
another hard lockup.

Thanks as always, again the patch has helped in two ways.
1. It avoids the clone failure and requeue -11 failure messages
2. It seems to take a lot longe rnow to get into a hard lockup.

Regards
Laurence
