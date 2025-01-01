Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C383207
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jan 2025 09:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735723223; cv=none; b=ffsDtMPfKOGf2dspSYBAa+Y4RRpmPEvf82l7Au3RsVujWlmk8OpREs6+7qD3MVrBx71O9QlOoJg9bBwr9QkOzuf1AMR+IMQ6vA+WN79F9XZ+6pLfwd8/Ob6m1LIa9pxppXs6j0C8r0s4bU2WoHY0szGREpI20lNB/l6bSRX+VdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735723223; c=relaxed/simple;
	bh=hQJvdX4QJOocwOvz4ijkTr6tJaOyUae0EMfejLph8rE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rGCYwIxiyan8ge7yClOjExcshMZw8d2sQ+guOFHDq9MRlbUOk+kINh2E95/AkykiYU8+BQ4v80iJ13pkOiLiycSiN4CHuX7svzCzR2ykDwO+EDDNj3mBiyRId57xF36SacGQhpxGvcTQHsUUiibQyVk5/CGBCLi4E53Mz3YRMPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ae31bb8ee3so222921985ab.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jan 2025 01:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735723220; x=1736328020;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4ZwQUf6J+HDq4oj7df8oFoxZf4Wr17N/hefmLedhtI=;
        b=hqqBAbm3P6squ3cwF4Y7ZuFHD4rdTCj+kUFohVDN2q/gegt54mfo3bVgbQeyId1Osv
         36RlIKZXqRDaXazYrtDFOZf9So14qaTo7oVMMTZ+laYO0voZXi/U2xHo5DAlZRA7Lzj/
         AYcaZb8wyAb/imxiXEccJRInAnShIo0YI179c6kmysRNhN5wyQabbdjL8LKk4gTNwpTe
         7mAPUuhH57i2oNT2kEdkpSJ/LPBHUpSm/+E5IHAUgQ/MGzR2NqLl63zptNCsVqvgPqQU
         dNTJo8/iiViBv5j1Tw/yJbbJg93I+akC95X117L7YQ/eG+WXu41MxfSrR3m0d3vqw6BE
         1gvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXN3qAOSynbrU2C3XajxHJ4IMzaALDsNQJIJERCzDsV2wIwfXdWE8v9OhOTi5WHJEdZ8I9FMURwXi4N@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf0S9h1R6kjuv7HvwyKvSKu0eTgOWOuWDfqs9yC45slhkFX5su
	2bw+z1ImmIRem0ThfrFDVthretX16UPNPlynh6JsiTWjAVC7Rt730d+EXopu97VNYQyXyb6D1XM
	+RGrfRHmwR0D+ribsMBrM6pIjIPZKQw4PCFBSxwiNqXVmVvtaCUAEF/g=
X-Google-Smtp-Source: AGHT+IFvJIH4oV8+mqJKeRvENMFIb5z8V/DPByhPoSTnfWIfnQxYZfgVvjXueK81gAFOxyvigTZ0dWng3RkVbYtOQY9H1gi5RoAV
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:318c:b0:3a7:c5c8:aa53 with SMTP id
 e9e14a558f8ab-3c2d2d51374mr382227545ab.13.1735723219962; Wed, 01 Jan 2025
 01:20:19 -0800 (PST)
Date: Wed, 01 Jan 2025 01:20:19 -0800
In-Reply-To: <672ad483.050a0220.2edce.1519.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677508d3.050a0220.25abdd.09c5.GAE@google.com>
Subject: Re: [syzbot] [scsi?] possible deadlock in sd_remove
From: syzbot <syzbot+566d48f3784973a22771@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, 
	james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    573067a5a685 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=156f28b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=566d48f3784973a22771
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148656df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143dd818580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d3b5c855aa0/disk-573067a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0c06fc1ead83/vmlinux-573067a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3390e59b9e4b/Image-573067a5.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+566d48f3784973a22771@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc3-syzkaller-g573067a5a685 #0 Not tainted
------------------------------------------------------
kworker/1:2/2269 is trying to acquire lock:
ffff0000dfbc03e0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: touch_work_lockdep_map+0x74/0x11c kernel/workqueue.c:3909

but task is already holding lock:
ffff0000cad4e260 (&q->q_usage_counter(queue)#37){++++}-{0:0}, at: sd_remove+0x8c/0x118 drivers/scsi/sd.c:4072

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&q->q_usage_counter(queue)#37){++++}-{0:0}:
       blk_queue_enter+0xf0/0x538 block/blk-core.c:328
       blk_mq_alloc_request+0x3d8/0x8f0 block/blk-mq.c:652
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x144/0xd94 drivers/scsi/scsi_lib.c:304
       read_capacity_10+0x1f4/0x764 drivers/scsi/sd.c:2766
       sd_read_capacity drivers/scsi/sd.c:2834 [inline]
       sd_revalidate_disk+0xd1c/0x98a4 drivers/scsi/sd.c:3734
       sd_probe+0x6f0/0xcec drivers/scsi/sd.c:4010
       really_probe+0x38c/0x8fc drivers/base/dd.c:658
       __driver_probe_device+0x194/0x374 drivers/base/dd.c:800
       driver_probe_device+0x78/0x330 drivers/base/dd.c:830
       __device_attach_driver+0x2a8/0x4f4 drivers/base/dd.c:958
       bus_for_each_drv+0x228/0x2bc drivers/base/bus.c:459
       __device_attach_async_helper+0x210/0x2c0 drivers/base/dd.c:987
       async_run_entry_fn+0x98/0x3b4 kernel/async.c:129
       process_one_work+0x7a8/0x15cc kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x97c/0xeec kernel/workqueue.c:3391
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #2 (&q->limits_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x218/0x28f4 kernel/locking/mutex.c:585
       __mutex_lock kernel/locking/mutex.c:735 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:787
       queue_limits_start_update include/linux/blkdev.h:947 [inline]
       nvme_update_ns_info_block+0x5b4/0x2848 drivers/nvme/host/core.c:2185
       nvme_update_ns_info+0xdc/0xed0
       nvme_alloc_ns drivers/nvme/host/core.c:3897 [inline]
       nvme_scan_ns+0x2028/0x36ec drivers/nvme/host/core.c:4071
       nvme_scan_ns_sequential+0x198/0x250 drivers/nvme/host/core.c:4186
       nvme_scan_work+0x9e0/0xd18 drivers/nvme/host/core.c:4247
       process_one_work+0x7a8/0x15cc kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x97c/0xeec kernel/workqueue.c:3391
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #1 (&q->q_usage_counter(io)#50){++++}-{0:0}:
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1254/0x2070 block/blk-mq.c:3090
       __submit_bio+0x1a0/0x4f8 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x3bc/0xcbc block/blk-core.c:739
       submit_bio_noacct+0xc6c/0x166c block/blk-core.c:868
       submit_bio+0x374/0x564 block/blk-core.c:910
       submit_bh_wbc+0x3f8/0x4c8 fs/buffer.c:2814
       __block_write_full_folio+0x840/0xd74 fs/buffer.c:1904
       block_write_full_folio+0x2fc/0x3c4
       write_cache_pages+0xc8/0x20c mm/page-writeback.c:2659
       blkdev_writepages+0xac/0x100 block/fops.c:433
       do_writepages+0x304/0x7d0 mm/page-writeback.c:2702
       __writeback_single_inode+0x15c/0x15a4 fs/fs-writeback.c:1680
       writeback_sb_inodes+0x650/0x1088 fs/fs-writeback.c:1976
       __writeback_inodes_wb+0xec/0x234 fs/fs-writeback.c:2047
       wb_writeback+0x3f4/0xe9c fs/fs-writeback.c:2158
       wb_check_background_flush fs/fs-writeback.c:2228 [inline]
       wb_do_writeback fs/fs-writeback.c:2316 [inline]
       wb_workfn+0xc28/0x1048 fs/fs-writeback.c:2343
       process_one_work+0x7a8/0x15cc kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x97c/0xeec kernel/workqueue.c:3391
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #0 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5226
       lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
       touch_work_lockdep_map+0x9c/0x11c kernel/workqueue.c:3909
       start_flush_work kernel/workqueue.c:4163 [inline]
       __flush_work+0x578/0x954 kernel/workqueue.c:4195
       flush_work kernel/workqueue.c:4252 [inline]
       flush_delayed_work+0xcc/0xf8 kernel/workqueue.c:4274
       wb_shutdown+0x154/0x1d0 mm/backing-dev.c:575
       bdi_unregister+0x160/0x4f8 mm/backing-dev.c:1158
       del_gendisk+0x39c/0x870 block/genhd.c:707
       sd_remove+0x8c/0x118 drivers/scsi/sd.c:4072
       device_remove drivers/base/dd.c:569 [inline]
       __device_release_driver drivers/base/dd.c:1273 [inline]
       device_release_driver_internal+0x440/0x698 drivers/base/dd.c:1296
       device_release_driver+0x28/0x38 drivers/base/dd.c:1319
       bus_remove_device+0x314/0x3b4 drivers/base/bus.c:576
       device_del+0x480/0x828 drivers/base/core.c:3854
       __scsi_remove_device+0x178/0x368 drivers/scsi/scsi_sysfs.c:1499
       scsi_forget_host+0xe0/0x128 drivers/scsi/scsi_scan.c:2068
       scsi_remove_host+0x13c/0x6c8 drivers/scsi/hosts.c:181
       quiesce_and_remove_host drivers/usb/storage/usb.c:949 [inline]
       usb_stor_disconnect+0x13c/0x218 drivers/usb/storage/usb.c:1178
       usb_unbind_interface+0x22c/0x7ec drivers/usb/core/driver.c:458
       device_remove drivers/base/dd.c:569 [inline]
       __device_release_driver drivers/base/dd.c:1273 [inline]
       device_release_driver_internal+0x440/0x698 drivers/base/dd.c:1296
       device_release_driver+0x28/0x38 drivers/base/dd.c:1319
       bus_remove_device+0x314/0x3b4 drivers/base/bus.c:576
       device_del+0x480/0x828 drivers/base/core.c:3854
       usb_disable_device+0x354/0x760 drivers/usb/core/message.c:1418
       usb_disconnect+0x290/0x808 drivers/usb/core/hub.c:2304
       hub_port_connect drivers/usb/core/hub.c:5361 [inline]
       hub_port_connect_change drivers/usb/core/hub.c:5661 [inline]
       port_event drivers/usb/core/hub.c:5821 [inline]
       hub_event+0x1918/0x4280 drivers/usb/core/hub.c:5903
       process_one_work+0x7a8/0x15cc kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x97c/0xeec kernel/workqueue.c:3391
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

other info that might help us debug this:

Chain exists of:
  (work_completion)(&(&wb->dwork)->work) --> &q->limits_lock --> &q->q_usage_counter(queue)#37

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->q_usage_counter(queue)#37);
                               lock(&q->limits_lock);
                               lock(&q->q_usage_counter(queue)#37);
  lock((work_completion)(&(&wb->dwork)->work));

 *** DEADLOCK ***

9 locks held by kworker/1:2/2269:
 #0: ffff0000c2772148 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x60c/0x15cc kernel/workqueue.c:3203
 #1: ffff8000a0a67c20 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x6a4/0x15cc kernel/workqueue.c:3203
 #2: ffff0000cca1d190 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1014 [inline]
 #2: ffff0000cca1d190 (&dev->mutex){....}-{4:4}, at: hub_event+0x1bc/0x4280 drivers/usb/core/hub.c:5849
 #3: ffff0000dfae4190 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1014 [inline]
 #3: ffff0000dfae4190 (&dev->mutex){....}-{4:4}, at: usb_disconnect+0xec/0x808 drivers/usb/core/hub.c:2295
 #4: ffff0000d8cc5160 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1014 [inline]
 #4: ffff0000d8cc5160 (&dev->mutex){....}-{4:4}, at: __device_driver_lock drivers/base/dd.c:1095 [inline]
 #4: ffff0000d8cc5160 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0xbc/0x698 drivers/base/dd.c:1293
 #5: ffff0000df90c0e0 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_remove_host+0x44/0x6c8 drivers/scsi/hosts.c:169
 #6: ffff0000c72d6378 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1014 [inline]
 #6: ffff0000c72d6378 (&dev->mutex){....}-{4:4}, at: __device_driver_lock drivers/base/dd.c:1095 [inline]
 #6: ffff0000c72d6378 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0xbc/0x698 drivers/base/dd.c:1293
 #7: ffff0000cad4e260 (&q->q_usage_counter(queue)#37){++++}-{0:0}, at: sd_remove+0x8c/0x118 drivers/scsi/sd.c:4072
 #8: ffff80008fb82560 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x10/0x4c include/linux/rcupdate.h:336

stack backtrace:
CPU: 1 UID: 0 PID: 2269 Comm: kworker/1:2 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: usb_hub_wq hub_event
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5226
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
 touch_work_lockdep_map+0x9c/0x11c kernel/workqueue.c:3909
 start_flush_work kernel/workqueue.c:4163 [inline]
 __flush_work+0x578/0x954 kernel/workqueue.c:4195
 flush_work kernel/workqueue.c:4252 [inline]
 flush_delayed_work+0xcc/0xf8 kernel/workqueue.c:4274
 wb_shutdown+0x154/0x1d0 mm/backing-dev.c:575
 bdi_unregister+0x160/0x4f8 mm/backing-dev.c:1158
 del_gendisk+0x39c/0x870 block/genhd.c:707
 sd_remove+0x8c/0x118 drivers/scsi/sd.c:4072
 device_remove drivers/base/dd.c:569 [inline]
 __device_release_driver drivers/base/dd.c:1273 [inline]
 device_release_driver_internal+0x440/0x698 drivers/base/dd.c:1296
 device_release_driver+0x28/0x38 drivers/base/dd.c:1319
 bus_remove_device+0x314/0x3b4 drivers/base/bus.c:576
 device_del+0x480/0x828 drivers/base/core.c:3854
 __scsi_remove_device+0x178/0x368 drivers/scsi/scsi_sysfs.c:1499
 scsi_forget_host+0xe0/0x128 drivers/scsi/scsi_scan.c:2068
 scsi_remove_host+0x13c/0x6c8 drivers/scsi/hosts.c:181
 quiesce_and_remove_host drivers/usb/storage/usb.c:949 [inline]
 usb_stor_disconnect+0x13c/0x218 drivers/usb/storage/usb.c:1178
 usb_unbind_interface+0x22c/0x7ec drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:569 [inline]
 __device_release_driver drivers/base/dd.c:1273 [inline]
 device_release_driver_internal+0x440/0x698 drivers/base/dd.c:1296
 device_release_driver+0x28/0x38 drivers/base/dd.c:1319
 bus_remove_device+0x314/0x3b4 drivers/base/bus.c:576
 device_del+0x480/0x828 drivers/base/core.c:3854
 usb_disable_device+0x354/0x760 drivers/usb/core/message.c:1418
 usb_disconnect+0x290/0x808 drivers/usb/core/hub.c:2304
 hub_port_connect drivers/usb/core/hub.c:5361 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5661 [inline]
 port_event drivers/usb/core/hub.c:5821 [inline]
 hub_event+0x1918/0x4280 drivers/usb/core/hub.c:5903
 process_one_work+0x7a8/0x15cc kernel/workqueue.c:3229
 process_scheduled_works kernel/workqueue.c:3310 [inline]
 worker_thread+0x97c/0xeec kernel/workqueue.c:3391
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
