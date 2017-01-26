From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 12:47:53 -0800
Message-ID: <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485455329.2540.7.camel@sandisk.com>
 <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
 <1485456745.2540.9.camel@sandisk.com>
 <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com> <20170126185924.GA25289@lst.de>
 <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0050.outbound.protection.outlook.com ([104.47.34.50]:36352
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752737AbdAZUsM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 15:48:12 -0500
In-Reply-To: <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>

On 01/26/2017 11:01 AM, Jens Axboe wrote:
> On 01/26/2017 11:59 AM, hch@lst.de wrote:
>> On Thu, Jan 26, 2017 at 11:57:36AM -0700, Jens Axboe wrote:
>>> It's against my for-4.11/block, which you were running under Christoph's
>>> patches. Maybe he's using an older version? In any case, should be
>>> pretty trivial for you to hand apply. Just ensure that .flags is set to
>>> 0 for the common cases, and inherit 'flags' when it is passed in.
>>
>> No, the flush op cleanups you asked for last round create a conflict
>> with your patch.  They should be trivial to fix, though.
> 
> Ah, makes sense. And yes, as I said, should be trivial to hand apply the
> hunk that does fail.

Hello Jens and Christoph,

With the below patch applied the test got a little further but did not
pass unfortunately. I tried to analyze the new call stack but it's not yet
clear to me what is going on.
 
The patch I had applied on Christoph's tree:

---
 block/blk-mq-sched.c | 2 +-
 block/blk-mq.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 3bd66e50ec84..7c9318755fab 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -116,7 +116,7 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	ctx = blk_mq_get_ctx(q);
 	hctx = blk_mq_map_queue(q, ctx->cpu);
 
-	blk_mq_set_alloc_data(data, q, 0, ctx, hctx);
+	blk_mq_set_alloc_data(data, q, data->flags, ctx, hctx);
 
 	if (e) {
 		data->flags |= BLK_MQ_REQ_INTERNAL;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 83640869d9e4..6697626e5d32 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -248,7 +248,7 @@ EXPORT_SYMBOL_GPL(__blk_mq_alloc_request);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		unsigned int flags)
 {
-	struct blk_mq_alloc_data alloc_data;
+	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
 	int ret;
 
@@ -1369,7 +1369,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
-	struct blk_mq_alloc_data data;
+	struct blk_mq_alloc_data data = { };
 	struct request *rq;
 	unsigned int request_count = 0, srcu_idx;
 	struct blk_plug *plug;
@@ -1491,7 +1491,7 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
-	struct blk_mq_alloc_data data;
+	struct blk_mq_alloc_data data = { };
 	struct request *rq;
 	blk_qc_t cookie;
 	unsigned int wb_acct;
-- 
2.11.0


The new call trace:

[ 4277.729785] BUG: scheduling while atomic: mount/9209/0x00000004
[ 4277.729824] 2 locks held by mount/9209:
[ 4277.729846]  #0:  (&type->s_umount_key#25/1){+.+.+.}, at: [<ffffffff811ef6fd>] sget_userns+0x2bd/0x500
[ 4277.729881]  #1:  (rcu_read_lock){......}, at: [<ffffffff813261ae>] __blk_mq_run_hw_queue+0xde/0x1c0
[ 4277.729911] Modules linked in: dm_service_time ib_srp scsi_transport_srp target_core_user uio target_core_pscsi target_core_file ib_srpt target_core_iblock target_core_mod brd netconsole xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_
ipv4 nf_nat libcrc32c nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables af_packet ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad 
rdma_cm configfs ib_cm iw_cm msr mlx4_ib ib_core sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel ipmi_ssif kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64 mlx4_core crypto_simd iTCO_wdt
[ 4277.730048]  tg3 iTCO_vendor_support dcdbas glue_helper ptp ipmi_si pcspkr pps_core devlink ipmi_devintf cryptd libphy fjes ipmi_msghandler tpm_tis mei_me tpm_tis_core lpc_ich mfd_core shpchp mei tpm wmi button hid_generic usbhid mgag200 i2c_algo_bit drm_kms_helper sysco
pyarea sysfillrect sysimgblt fb_sys_fops ttm sr_mod cdrom drm ehci_pci ehci_hcd usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua autofs4
[ 4277.730135] CPU: 11 PID: 9209 Comm: mount Not tainted 4.10.0-rc5-dbg+ #2
[ 4277.730159] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
[ 4277.730187] Call Trace:
[ 4277.730212]  dump_stack+0x68/0x93
[ 4277.730236]  __schedule_bug+0x5b/0x80
[ 4277.730259]  __schedule+0x762/0xb00
[ 4277.730281]  schedule+0x38/0x90
[ 4277.730302]  schedule_timeout+0x2fe/0x640
[ 4277.730324]  ? mark_held_locks+0x6f/0xa0
[ 4277.730349]  ? ktime_get+0x74/0x130
[ 4277.730370]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[ 4277.730391]  ? trace_hardirqs_on+0xd/0x10
[ 4277.730418]  ? ktime_get+0x98/0x130
[ 4277.730623]  ? __delayacct_blkio_start+0x1a/0x30
[ 4277.730647]  io_schedule_timeout+0x9f/0x110
[ 4277.730669]  blk_mq_get_tag+0x158/0x260
[ 4277.730691]  ? remove_wait_queue+0x70/0x70
[ 4277.730714]  __blk_mq_alloc_request+0x16/0xe0
[ 4277.730735]  blk_mq_sched_get_request+0x308/0x350
[ 4277.730757]  ? blk_mq_sched_bypass_insert+0x70/0x70
[ 4277.730781]  blk_mq_alloc_request+0x5e/0xb0
[ 4277.730805]  blk_get_request+0x31/0x110
[ 4277.730828]  multipath_clone_and_map+0xcd/0x140 [dm_multipath]
[ 4277.730854]  map_request+0x3c/0x290 [dm_mod]
[ 4277.730885]  dm_mq_queue_rq+0x77/0x100 [dm_mod]
[ 4277.730908]  blk_mq_dispatch_rq_list+0x1ff/0x320
[ 4277.730931]  blk_mq_sched_dispatch_requests+0xa9/0xe0
[ 4277.730955]  __blk_mq_run_hw_queue+0x122/0x1c0
[ 4277.730977]  ? __blk_mq_run_hw_queue+0xde/0x1c0
[ 4277.731000]  blk_mq_run_hw_queue+0x84/0x90
[ 4277.731022]  blk_sq_make_request+0x53c/0xc90
[ 4277.731044]  ? generic_make_request+0xca/0x290
[ 4277.731066]  generic_make_request+0xd7/0x290
[ 4277.731087]  submit_bio+0x5f/0x120
[ 4277.731108]  ? __find_get_block+0x27f/0x300
[ 4277.731129]  submit_bh_wbc+0x14d/0x180
[ 4277.731154]  ? __end_buffer_read_notouch+0x20/0x20
[ 4277.731177]  ll_rw_block+0xa8/0xb0
[ 4277.731203]  __breadahead+0x30/0x40
[ 4277.731232]  __ext4_get_inode_loc+0x3fe/0x4e0
[ 4277.731254]  ext4_iget+0x6b/0xbc0
[ 4277.731277]  ext4_fill_super+0x1c8b/0x33d0
[ 4277.731589]  mount_bdev+0x17b/0x1b0
[ 4277.731613]  ? ext4_calculate_overhead+0x430/0x430
[ 4277.731637]  ext4_mount+0x10/0x20
[ 4277.731659]  mount_fs+0xf/0xa0
[ 4277.731682]  vfs_kern_mount+0x66/0x170
[ 4277.731704]  do_mount+0x19b/0xd70
[ 4277.731726]  ? _copy_from_user+0x7a/0xb0
[ 4277.731748]  ? memdup_user+0x4e/0x80
[ 4277.731771]  SyS_mount+0x7e/0xd0
[ 4277.731793]  entry_SYSCALL_64_fastpath+0x18/0xad
[ 4277.731814] RIP: 0033:0x7fe575771afa
[ 4277.731835] RSP: 002b:00007fffd2261248 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[ 4277.731858] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fe575771afa
[ 4277.731880] RDX: 0000556f0b7b1010 RSI: 0000556f0b7af1d0 RDI: 0000556f0b7afed0
[ 4277.731901] RBP: 0000556f0b7af060 R08: 0000000000000000 R09: 0000000000000020
[ 4277.731923] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 00007fe575c731a4
