Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98826C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 07:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7431560E8D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 07:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhKOIAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 03:00:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236511AbhKOIAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 03:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636963027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VmohK0tiIlRIVbO7XoY7h1rjoxi/NcnBHYHOCX4xRYo=;
        b=VNzK6Re2LMDFMcKTGLac3/D1JVeH6TZnwYrIiCesYdwrLKLvfe7mQo/s+iL3mE4RxCrlzb
        B8pCEMTFEAbmv+BFdKqO3+pr1c7dolvte7fHhEsQCox3Q8bjI5ZUR4cUYBMNUyMNuk2nNS
        3HRb85eK/QrTTPkLtLF12aaXzU9lCD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-iW_v4f2JM62vPnk3AIm1XQ-1; Mon, 15 Nov 2021 02:57:03 -0500
X-MC-Unique: iW_v4f2JM62vPnk3AIm1XQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F627100F942;
        Mon, 15 Nov 2021 07:57:02 +0000 (UTC)
Received: from localhost (ovpn-8-36.pek2.redhat.com [10.72.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0068E60BE5;
        Mon, 15 Nov 2021 07:56:58 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        ChanghuiZhong <czhong@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] blk-mq: sync blk-mq queue in both blk_cleanup_queue and disk_release()
Date:   Mon, 15 Nov 2021 15:56:50 +0800
Message-Id: <20211115075650.578051-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For avoiding to slow down queue destroy, we don't call
blk_mq_quiesce_queue() in blk_cleanup_queue(), instead of delaying to
sync blk-mq queue in blk_release_queue().

However, this way has caused kernel oops[1], reported by Changhui. The log
shows that scsi_device can be freed before running blk_release_queue(),
which is expected too since scsi_device is released after the scsi disk
is closed and the scsi_device is removed.

Fixes the issue by sync blk-mq in both blk_cleanup_queue() and
disk_release():

1) when disk_release() is run, the disk has been closed, and any sync
dispatch activities have been done, so sync blk-mq queue is enough to quiesce
filesystem dispatch activity.

2) in blk_cleanup_queue(), we only focus on passthrough request, and
passthrough request is always explicitly allocated & freed by
passthrough request caller, so once queue is frozen, all sync dispatch activity
for passthrough request has been done, then it is enough to sync blk-mq queue
for avoiding to run any dispatch activity.

[1] kernel panic log
[12622.769416] BUG: kernel NULL pointer dereference, address: 0000000000000300
[12622.777186] #PF: supervisor read access in kernel mode
[12622.782918] #PF: error_code(0x0000) - not-present page
[12622.788649] PGD 0 P4D 0
[12622.791474] Oops: 0000 [#1] PREEMPT SMP PTI
[12622.796138] CPU: 10 PID: 744 Comm: kworker/10:1H Kdump: loaded Not tainted 5.15.0+ #1
[12622.804877] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 1.5.4 10/002/2015
[12622.813321] Workqueue: kblockd blk_mq_run_work_fn
[12622.818572] RIP: 0010:sbitmap_get+0x75/0x190
[12622.823336] Code: 85 80 00 00 00 41 8b 57 08 85 d2 0f 84 b1 00 00 00 45 31 e4 48 63 cd 48 8d 1c 49 48 c1 e3 06 49 03 5f 10 4c 8d 6b 40 83 f0 01 <48> 8b 33 44 89 f2 4c 89 ef 0f b6 c8 e8 fa f3 ff ff 83 f8 ff 75 58
[12622.844290] RSP: 0018:ffffb00a446dbd40 EFLAGS: 00010202
[12622.850120] RAX: 0000000000000001 RBX: 0000000000000300 RCX: 0000000000000004
[12622.858082] RDX: 0000000000000006 RSI: 0000000000000082 RDI: ffffa0b7a2dfe030
[12622.866042] RBP: 0000000000000004 R08: 0000000000000001 R09: ffffa0b742721334
[12622.874003] R10: 0000000000000008 R11: 0000000000000008 R12: 0000000000000000
[12622.881964] R13: 0000000000000340 R14: 0000000000000000 R15: ffffa0b7a2dfe030
[12622.889926] FS:  0000000000000000(0000) GS:ffffa0baafb40000(0000) knlGS:0000000000000000
[12622.898956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12622.905367] CR2: 0000000000000300 CR3: 0000000641210001 CR4: 00000000001706e0
[12622.913328] Call Trace:
[12622.916055]  <TASK>
[12622.918394]  scsi_mq_get_budget+0x1a/0x110
[12622.922969]  __blk_mq_do_dispatch_sched+0x1d4/0x320
[12622.928404]  ? pick_next_task_fair+0x39/0x390
[12622.933268]  __blk_mq_sched_dispatch_requests+0xf4/0x140
[12622.939194]  blk_mq_sched_dispatch_requests+0x30/0x60
[12622.944829]  __blk_mq_run_hw_queue+0x30/0xa0
[12622.949593]  process_one_work+0x1e8/0x3c0
[12622.954059]  worker_thread+0x50/0x3b0
[12622.958144]  ? rescuer_thread+0x370/0x370
[12622.962616]  kthread+0x158/0x180
[12622.966218]  ? set_kthread_struct+0x40/0x40
[12622.970884]  ret_from_fork+0x22/0x30
[12622.974875]  </TASK>
[12622.977309] Modules linked in: scsi_debug rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs sunrpc dm_multipath intel_rapl_msr intel_rapl_common dell_wmi_descriptor sb_edac rfkill video x86_pkg_temp_thermal intel_powerclamp dcdbas coretemp kvm_intel kvm mgag200 irqbypass i2c_algo_bit rapl drm_kms_helper ipmi_ssif intel_cstate intel_uncore syscopyarea sysfillrect sysimgblt fb_sys_fops pcspkr cec mei_me lpc_ich mei ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sr_mod cdrom sd_mod t10_pi sg ixgbe ahci libahci crct10dif_pclmul crc32_pclmul crc32c_intel libata megaraid_sas ghash_clmulni_intel tg3 wdat_wdt mdio dca wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug]

Reported-by: ChanghuiZhong <czhong@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c  |  4 +++-
 block/blk-mq.c    | 13 +++++++++++++
 block/blk-mq.h    |  2 ++
 block/blk-sysfs.c | 10 ----------
 block/genhd.c     |  2 ++
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9ee32f85d74e..78710567cf69 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -363,8 +363,10 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
 	blk_sync_queue(q);
-	if (queue_is_mq(q))
+	if (queue_is_mq(q)) {
+		blk_mq_sync_queue(q);
 		blk_mq_exit_queue(q);
+	}
 
 	/*
 	 * In theory, request pool of sched_tags belongs to request queue.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ab34c4f20da..36260ce0b9ec 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4417,6 +4417,19 @@ unsigned int blk_mq_rq_cpu(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_rq_cpu);
 
+void blk_mq_sync_queue(struct request_queue *q)
+{
+	if (queue_is_mq(q)) {
+		struct blk_mq_hw_ctx *hctx;
+		int i;
+
+		cancel_delayed_work_sync(&q->requeue_work);
+
+		queue_for_each_hw_ctx(q, hctx, i)
+			cancel_delayed_work_sync(&hctx->run_work);
+	}
+}
+
 static int __init blk_mq_init(void)
 {
 	int i;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 8acfa650f575..cb49591454c3 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -128,6 +128,8 @@ extern void blk_mq_hctx_kobj_init(struct blk_mq_hw_ctx *hctx);
 void blk_mq_free_plug_rqs(struct blk_plug *plug);
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
+void blk_mq_sync_queue(struct request_queue *q);
+
 void blk_mq_release(struct request_queue *q);
 
 static inline struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cef1f713370b..cd75b0f73dc6 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -791,16 +791,6 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_free_queue_stats(q->stats);
 
-	if (queue_is_mq(q)) {
-		struct blk_mq_hw_ctx *hctx;
-		int i;
-
-		cancel_delayed_work_sync(&q->requeue_work);
-
-		queue_for_each_hw_ctx(q, hctx, i)
-			cancel_delayed_work_sync(&hctx->run_work);
-	}
-
 	blk_exit_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
diff --git a/block/genhd.c b/block/genhd.c
index c5392cc24d37..01fdc0025550 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1111,6 +1111,8 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
+	blk_mq_sync_queue(disk->queue);
+
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
-- 
2.31.1

