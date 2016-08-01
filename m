From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Mon, 1 Aug 2016 13:59:48 -0400
Message-ID: <20160801175948.GA6685@redhat.com>
References: <20160720183321.GA20223@redhat.com>
 <317679447.7168375.1469729769593.JavaMail.zimbra@redhat.com>
 <6880321d-e14f-169b-d100-6e460dd9bd09@sandisk.com>
 <1110327939.7305916.1469819453678.JavaMail.zimbra@redhat.com>
 <a5c1a149-b1a2-b5a4-2207-bdaf32db3cbd@sandisk.com>
 <757522831.7667712.1470059860543.JavaMail.zimbra@redhat.com>
 <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
 <931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
 <1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
 <17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbcHAR7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2016 13:59:50 -0400
Content-Disposition: inline
In-Reply-To: <17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Laurence Oberman <loberman@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

With this debug patch ontop of v4.7:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 52baf8a..22baf29 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -433,10 +433,22 @@ failed:
  */
 static int must_push_back(struct multipath *m)
 {
+	bool queue_if_no_path = test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
+	bool suspend_active = (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
+			       test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags));
+	bool suspending = (suspend_active && dm_noflush_suspending(m->ti));
+
+#if 0
 	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
 		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
 		  test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
 		 dm_noflush_suspending(m->ti)));
+#else
+	if (!queue_if_no_path || !suspending)
+		DMERR_LIMIT("%s: queue_if_no_path=%d suspend_active=%d suspending=%d",
+			    __func__, queue_if_no_path, suspend_active, suspending);
+	return (queue_if_no_path || suspending);
+#endif
 }
 
 /*
@@ -459,7 +471,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (!must_push_back(m))
+		if (WARN_ON_ONCE(!must_push_back(m)))
 			r = -EIO;	/* Failed */
 		return r;
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
@@ -1347,7 +1359,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 
 	if (!atomic_read(&m->nr_valid_paths)) {
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!must_push_back(m))
+			if (WARN_ON_ONCE(!must_push_back(m)))
 				r = -EIO;
 		} else {
 			if (error == -EBADE)

I got:

Aug  1 13:41:48 client kernel: blk_update_request: I/O error, dev sdbf, sector 34376
Aug  1 13:41:48 client kernel: blk_update_request: I/O error, dev sdbf, sector 183608
Aug  1 13:41:48 client kernel: device-mapper: multipath: Failing path 67:144.
Aug  1 13:41:48 client kernel: blk_update_request: I/O error, dev sdbf, sector 237352
Aug  1 13:41:48 client kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=1
Aug  1 13:41:48 client kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=1
Aug  1 13:41:48 client kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=1
Aug  1 13:41:48 client kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=1
Aug  1 13:41:48 client kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=0
Aug  1 13:41:48 client kernel: ------------[ cut here ]------------
Aug  1 13:41:48 client kernel: WARNING: CPU: 10 PID: 6445 at drivers/md/dm-mpath.c:474 __multipath_map.isra.11+0xb7/0x240 [dm_multipath]
Aug  1 13:41:48 client kernel: Modules linked in: dm_round_robin(O) xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_c
 lmulni_intel aesni_intel glue_helper
Aug  1 13:41:48 client kernel: lrw gf128mul ablk_helper cryptd ipmi_ssif iTCO_wdt iTCO_vendor_support sg ipmi_si hpilo pcspkr ipmi_msghandler acpi_power_meter hpwdt lpc_ich shpchp i7core_edac mfd_core edac_core pcc_cpufreq acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath(O) ip_tables xfs libcrc32c mlx5_ib ib_core sd_mod radeon i2c_algo_bit drm_kms_helper syscopyarea sysfillrect mlx5_core sysimgblt fb_sys_fops ttm drm crc32c_intel serio_raw bnx2 hpsa i2c_core ptp pps_core scsi_transport_sas dm_mod(O) [last unloaded: dm_log]
Aug  1 13:41:48 client kernel: CPU: 10 PID: 6445 Comm: kworker/10:1H Tainted: G          IO    4.7.0.snitm #1
Aug  1 13:41:48 client kernel: Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
Aug  1 13:41:48 client kernel: Workqueue: kblockd blk_mq_requeue_work
Aug  1 13:41:48 client kernel: 0000000000000286 000000008737cd27 ffff880607ecfbb8 ffffffff8134259f
Aug  1 13:41:48 client kernel: 0000000000000000 0000000000000000 ffff880607ecfbf8 ffffffff81088fb1
Aug  1 13:41:48 client kernel: 000001da00000000 ffff880bd0393100 0000000000000000 0000000000000000
Aug  1 13:41:48 client kernel: Call Trace:
Aug  1 13:41:48 client kernel: [<ffffffff8134259f>] dump_stack+0x63/0x84
Aug  1 13:41:48 client kernel: [<ffffffff81088fb1>] __warn+0xd1/0xf0
Aug  1 13:41:48 client kernel: [<ffffffff810890ed>] warn_slowpath_null+0x1d/0x20
Aug  1 13:41:48 client kernel: [<ffffffffa0104e27>] __multipath_map.isra.11+0xb7/0x240 [dm_multipath]
Aug  1 13:41:48 client kernel: [<ffffffffa0104fca>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
Aug  1 13:41:48 client kernel: [<ffffffffa0002242>] map_request+0xd2/0x240 [dm_mod]
Aug  1 13:41:48 client kernel: [<ffffffffa000407e>] dm_mq_queue_rq+0x7e/0x110 [dm_mod]
Aug  1 13:41:48 client kernel: [<ffffffff81320d32>] __blk_mq_run_hw_queue+0x1f2/0x370
Aug  1 13:41:48 client kernel: [<ffffffff81320b25>] blk_mq_run_hw_queue+0x95/0xb0
Aug  1 13:41:48 client kernel: [<ffffffff81322438>] ? blk_mq_insert_request+0x88/0xc0
Aug  1 13:41:48 client kernel: [<ffffffff81321ba5>] blk_mq_start_hw_queue+0x15/0x20
Aug  1 13:41:48 client kernel: [<ffffffff81321be2>] blk_mq_start_hw_queues+0x32/0x50
Aug  1 13:41:48 client kernel: [<ffffffff813229e5>] blk_mq_requeue_work+0x115/0x140
Aug  1 13:41:48 client kernel: [<ffffffff810a1e72>] process_one_work+0x152/0x400
Aug  1 13:41:48 client kernel: [<ffffffff810a2765>] worker_thread+0x125/0x4b0
Aug  1 13:41:48 client kernel: [<ffffffff810a2640>] ? rescuer_thread+0x380/0x380
Aug  1 13:41:48 client kernel: [<ffffffff810a8298>] kthread+0xd8/0xf0
Aug  1 13:41:48 client kernel: [<ffffffff816ba17f>] ret_from_fork+0x1f/0x40
Aug  1 13:41:48 client kernel: [<ffffffff810a81c0>] ? kthread_park+0x60/0x60
Aug  1 13:41:48 client kernel: ---[ end trace 1be159facc3adabe ]---
Aug  1 13:41:48 client kernel: blk_update_request: I/O error, dev dm-28, sector 267144
Aug  1 13:41:48 client multipathd: 360001ff0b035d0000000001a8d8a001b: load table [0 62277025792 multipath 1 queue_if_no_path 0 0 0]
Aug  1 13:41:48 client multipathd: 360001ff0b035d0000000001a8d8a001b: Entering recovery mode: max_retries=12

This says to me that must_push_back is returning false because
dm_noflush_suspending() is false.  When this happens -EIO will escape up
the IO stack.

And this confirms that must_push_back() calling dm_noflush_suspending()
is quite suspect given queue_if_no_path was configured: we should
_always_ pushback if no paths are available.

I'll dig deeper on really understanding _why_ must_push_back() is coded
like it is.  There is a deep historic reason but hell if I can recall
what it is...
