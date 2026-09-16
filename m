Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E14E2F1A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 21:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595546; cv=none; b=bA2CR8UjdMM34ylS1QAhPVEyv1aaznQnnQ9CdDPb8lDfoM4rZf67OaK6NeRY24XSOcPTXu4+VNn4r4CjKCUW8InZTD1VzG4KJNk7lMa9pFpfQfZBfMl90M0htb45Yewp9InYLlUuWiKJF7SuCl3+SCXh6QI8MsMlEB7oyoOeHZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595546; c=relaxed/simple;
	bh=+MkD0lvtgFcRvzNTqW0PbcRvpOkRU2T7kmm3ZCXDQns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TthFyi92QEn0+H6JKa2gcFhtB81FJVvVashH6gXJsN25QjlzQ36IETcmju8k5xTtBTWeGwH18UiTuFiHRvwmKsDwJQ5U3k1etaWn8OHGXKUsJ3KA2hxtJLdOZMVMoQS1erTP1TuT8ks5gzotAW6ZDz7LziHMlzO9J4zan+qyl9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qPSY4gt1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qPSY4gt1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hlXfg3JztzlfvpW;
	Wed, 16 Sep 2026 21:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1789595519; x=1792187520; bh=+NhhxXGS/5XpOkjPkc4Dy4XTbx2py0BfX4p
	P6mbRT5E=; b=qPSY4gt11Oy/Po1a3dmI3G/Z8A0Z8EH2tJtx9QoE9mER296cP2O
	NKCnlNQH4mD8UBDgLPctUV23Ed14bVMR86acdvorW5vW+8Iaiw8GCqJgtEVznuH8
	fGyZPRafDLaSq7NjG8gmaPeFyTb/7BPx96BaYG/ADfvcjgdwTAwpj/nTHGq+eA6x
	LrzdmGthXfnuLlOVrf8Asqbtth1pCf4F5GlyvOw767a7esF9n+BpoS5iGbkM7P7f
	jU206qntQa2ydsaW71f22FIQzrIx00uyc7XT4uHrkkWAeZQisstZkqiJl1xCGrl/
	xulBN1Tft1f4bSiycWbgbFbF4Q2GS1vCyCg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Si40S8Kx_u0X; Wed, 16 Sep 2026 21:51:59 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hlXfN4x84zlfvpG;
	Wed, 16 Sep 2026 21:51:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: core: Avoid holding limits_lock across hostt->sdev_configure()
Date: Wed, 16 Sep 2026 14:51:46 -0700
Message-ID: <afc0626fa47b78d3ccc2d233aa03c8965a74efe8.1789595486.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In scsi_add_lun(), hostt->sdev_configure() is called to configure device
parameters and update queue limits. Previously, scsi_add_lun() used
queue_limits_start_update() before calling sdev_configure(), which held
&q->limits_lock across the driver callback.

Drivers such as scsi_debug create debugfs entries during sdev_configure()=
,
which acquires VFS directory inode mutexes (&sb->s_type->i_mutex_key).
Because inode mutexes can trigger memory reclaim (fs_reclaim), which
submits I/O acquiring q_usage_counter, and queue freezing acquires
limits_lock, this introduces a circular locking dependency:
  limits_lock -> i_mutex_key -> fs_reclaim ->
    q_usage_counter -> limits_lock

Since the request queue is freshly allocated and not yet reachable by
anyone else during scsi_add_lun(), there is no need to hold limits_lock
across sdev_configure(). Use a local copy of the limits and apply them
using queue_limits_set() after sdev_configure() returns.

This patch fixes the following lockdep complaint:

WARNING: possible circular locking dependency detected
7.3.0-rc3-dbg #8 Not tainted
------------------------------------------------------
kworker/u235:0/301 is trying to acquire lock:
ffff88815b31ea68 (&sb->s_type->i_mutex_key#2/1){+.+.}-{4:4}, at: start_di=
rop+0x53/0xa0

but task is already holding lock:
ffff88814649a288 (&q->limits_lock){+.+.}-{4:4}, at: scsi_add_lun+0xfac/0x=
1d70 [scsi_mod]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&q->limits_lock){+.+.}-{4:4}:
       __lock_acquire+0x691/0xcd0
       lock_acquire.part.0+0xd3/0x250
       lock_acquire+0x70/0x150
       __mutex_lock+0x175/0x1d00
       mutex_lock_nested+0x1f/0x30
       __loop_clr_fd+0x2d6/0x8a0 [loop]
       lo_post_release+0x79/0xa0 [loop]
       bdev_release+0x3ad/0x690
       blkdev_release+0x15/0x20
       __fput+0x359/0xa70
       fput_close_sync+0xd4/0x1a0
       __x64_sys_close+0x91/0xf0
       x64_sys_call+0x16a0/0x1850
       do_syscall_64+0xde/0xfc0
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (&q->q_usage_counter(io)#19){++++}-{0:0}:
       __lock_acquire+0x691/0xcd0
       lock_acquire.part.0+0xd3/0x250
       lock_acquire+0x70/0x150
       blk_alloc_queue+0x5d1/0x780
       blk_mq_alloc_queue+0x14b/0x270
       __blk_mq_alloc_disk+0x1d/0xd0
       loop_add+0x44c/0xad0 [loop]
       scsi_debug_init+0x128/0x1000 [scsi_debug]
       do_one_initcall+0x108/0x5f0
       do_init_module+0x2c8/0x8e0
       load_module+0x149b/0x1db0
       init_module_from_file+0x185/0x1b0
       idempotent_init_module+0x3e8/0x860
       __x64_sys_finit_module+0xe0/0x180
       x64_sys_call+0xdbc/0x1850
       do_syscall_64+0xde/0xfc0
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __lock_acquire+0x691/0xcd0
       lock_acquire.part.0+0xd3/0x250
       lock_acquire+0x70/0x150
       fs_reclaim_acquire+0xcc/0x120
       kmem_cache_alloc_lru_noprof+0x60/0x7b0
       __d_alloc+0x3a/0x8c0
       d_alloc+0x4a/0x220
       lookup_one_qstr_excl+0xf8/0x200
       start_dirop+0x61/0xa0
       simple_start_creating+0xc7/0xd0
       debugfs_start_creating+0x94/0x130
       debugfs_create_dir+0x21/0x310
       pinctrl_init+0x40/0xe0
       do_one_initcall+0x108/0x5f0
       kernel_init_freeable+0x3f3/0x480
       kernel_init+0x26/0x160
       ret_from_fork+0x6cd/0x920
       ret_from_fork_asm+0x11/0x20

-> #0 (&sb->s_type->i_mutex_key#2/1){+.+.}-{4:4}:
       check_prev_add+0xdb/0xd80
       validate_chain+0x584/0xb40
       __lock_acquire+0x691/0xcd0
       lock_acquire.part.0+0xd3/0x250
       lock_acquire+0x70/0x150
       down_write_nested+0x92/0x1f0
       start_dirop+0x53/0xa0
       simple_start_creating+0xc7/0xd0
       debugfs_start_creating+0x94/0x130
       debugfs_create_dir+0x21/0x310
       scsi_debug_sdev_configure+0x1c6/0x7c0 [scsi_debug]
       scsi_add_lun+0x107f/0x1d70 [scsi_mod]
       scsi_probe_and_add_lun+0x2d1/0xc60 [scsi_mod]
       __scsi_scan_target+0x14d/0x340 [scsi_mod]
       scsi_scan_channel+0xfd/0x1b0 [scsi_mod]
       scsi_scan_host_selected+0x220/0x2d0 [scsi_mod]
       do_scsi_scan_host+0x1cd/0x270 [scsi_mod]
       do_scan_async+0x45/0x400 [scsi_mod]
       async_run_entry_fn+0x99/0x550
       process_one_work+0xf5f/0x1600
       worker_thread+0x5f6/0x1000
       kthread+0x37d/0x480
       ret_from_fork+0x6cd/0x920
       ret_from_fork_asm+0x11/0x20

other info that might help us debug this:
Chain exists of:
  &sb->s_type->i_mutex_key#2/1 --> &q->q_usage_counter(io)#19 --> &q->lim=
its_lock
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&q->limits_lock);
                               lock(&q->q_usage_counter(io)#19);
                               lock(&q->limits_lock);
  lock(&sb->s_type->i_mutex_key#2/1);

 *** DEADLOCK ***
locks held by kworker/u235:0/301: 4, last CPU#42:
 #0: ffff888102563940 ((wq_completion)async){+.+.}-{0:0}, at: process_one=
_work+0x8e4/0x1600
 #1: ffffc90001747cf8 ((work_completion)(&entry->work)){+.+.}-{0:0}, at: =
process_one_work+0xf1c/0x1600
 #2: ffff88814bef20d8 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_hos=
t_selected+0x128/0x2d0 [scsi_mod]
 #3: ffff88814649a288 (&q->limits_lock){+.+.}-{4:4}, at: scsi_add_lun+0xf=
ac/0x1d70 [scsi_mod]

stack backtrace:
CPU: 42 UID: 0 PID: 301 Comm: kworker/u235:0 Not tainted 7.3.0-rc3-dbg #8=
 PREEMPT  b8ddc0930911aecae22b8cbdc6482fceaf8d4d55
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.=
17.0-1 04/01/2014
Workqueue: async async_run_entry_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0x61/0x80
 dump_stack+0x14/0x16
 print_circular_bug.cold+0x38/0x42
 check_noncircular+0x127/0x150
 check_prev_add+0xdb/0xd80
 validate_chain+0x584/0xb40
 __lock_acquire+0x691/0xcd0
 lock_acquire.part.0+0xd3/0x250
 lock_acquire+0x70/0x150
 down_write_nested+0x92/0x1f0
 start_dirop+0x53/0xa0
 simple_start_creating+0xc7/0xd0
 debugfs_start_creating+0x94/0x130
 debugfs_create_dir+0x21/0x310
 scsi_debug_sdev_configure+0x1c6/0x7c0 [scsi_debug]
 scsi_add_lun+0x107f/0x1d70 [scsi_mod]
 scsi_probe_and_add_lun+0x2d1/0xc60 [scsi_mod]
 __scsi_scan_target+0x14d/0x340 [scsi_mod]
 scsi_scan_channel+0xfd/0x1b0 [scsi_mod]
 scsi_scan_host_selected+0x220/0x2d0 [scsi_mod]
 do_scsi_scan_host+0x1cd/0x270 [scsi_mod]
 do_scan_async+0x45/0x400 [scsi_mod]
 async_run_entry_fn+0x99/0x550
 process_one_work+0xf5f/0x1600
 worker_thread+0x5f6/0x1000
 kthread+0x37d/0x480
 ret_from_fork+0x6cd/0x920
 ret_from_fork_asm+0x11/0x20
 </TASK>

Cc: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>
Fixes: 693a1e8cbe12 ("scsi: core: Use the atomic queue limits API in scsi=
_add_lun()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 96e4065ae8b5..97e6cf3c6f3d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1085,9 +1085,10 @@ static int scsi_add_lun(struct scsi_device *sdev, =
unsigned char *inq_result,
 		return SCSI_SCAN_LUN_PRESENT;
=20
 	/*
-	 * No need to freeze the queue as it isn't reachable to anyone else yet=
.
+	 * No need to freeze the queue or hold limits_lock during sdev_configur=
e
+	 * as the queue isn't reachable to anyone else yet.
 	 */
-	lim =3D queue_limits_start_update(sdev->request_queue);
+	lim =3D sdev->request_queue->limits;
 	if (*bflags & BLIST_MAX_512)
 		lim.max_hw_sectors =3D 512;
 	else if (*bflags & BLIST_MAX_1024)
@@ -1096,7 +1097,6 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	if (hostt->sdev_configure)
 		ret =3D hostt->sdev_configure(sdev, &lim);
 	if (ret) {
-		queue_limits_cancel_update(sdev->request_queue);
 		/*
 		 * If the LLDD reports device not present, don't clutter the
 		 * console with failure messages.
@@ -1107,7 +1107,7 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 		return SCSI_SCAN_NO_RESPONSE;
 	}
=20
-	ret =3D queue_limits_commit_update(sdev->request_queue, &lim);
+	ret =3D queue_limits_set(sdev->request_queue, &lim);
 	if (ret) {
 		sdev_printk(KERN_ERR, sdev, "failed to apply queue limits.\n");
 		return SCSI_SCAN_NO_RESPONSE;
