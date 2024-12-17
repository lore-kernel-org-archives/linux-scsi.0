Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390271D7986
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734474635; cv=none; b=OmtHoGYWJAMb6HxXmOLZPHZ27WE8VyidRTTgAoSSN5FAkHqvvrGFufIU+U1FAPvqjjm6t0NNIiIkbw7GoDJLrxfOalT7Bl2W2GQ/LSnXjKjSAmBj1cccfdq/x1bnvtQS964+CHLfsB3F/9O01P/b94PdZNluBy2U3D6uDjeqfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734474635; c=relaxed/simple;
	bh=1zZeWbrbpFIbWkurcgeLMiOptQugVrvR+iT8Miee75M=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FTTiUiWCwjJ8jT+pjfKxUVlLQVRpjOyxswLUegQkQnTclTaHPjDoRn0Y0kFDH9rwdToCi/UxnqUxMxY7AICndFxsEQEikQlU4TLxy/bA5CV+TzE7wW0bv5LhdzhWCzfActmKf35UJPYM/DLQ0S/jygwCbfepwTCfuCxy3cNulHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JGeFYmU6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JGeFYmU6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YCWjP4PjYz6ClY9G;
	Tue, 17 Dec 2024 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:subject
	:subject:from:from:content-language:user-agent:mime-version:date
	:date:message-id:received:received; s=mr01; t=1734474630; x=
	1737066631; bh=+SeWvDxYnaq0AgC9aM68HXynnDClFNgXrSS+blbtCrc=; b=J
	GeFYmU6kObKXep5xwn69XQmmIvwbuapBHafPFFdOCKBBIyf2IOMBqJeeQZt8zE+9
	qhm5GVfcjIlLovZgptC17cJtU552G10ElTEYuGnQnrdXq3bgdcMETcteo3aVq4T6
	ms0WuGoeuYMJHWiTjhVV8oUSf5ZsoBrUs+vAxsuJFbkDEwQhJTbO8oab1VH3pPNf
	rLQIcz8lBIG/kGVdWP3x3Vqyy/mNdnb2LgsxvxrwWKUDz9GOIdL5Qq74GwJEVBml
	6LTKoGV36tsZM7+jT1myWgIZ1/eTdi8KOaOs9ITTBQnKAc4Cp6mtOMq/lYY8bYOd
	96sy9aWnwF/64Nu5ke0qA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6mq5h9myC1Vu; Tue, 17 Dec 2024 22:30:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YCWjK6ZWSz6ClY9D;
	Tue, 17 Dec 2024 22:30:29 +0000 (UTC)
Message-ID: <e78b6e21-7b7b-40b1-8a2f-bbcfb4e794f3@acm.org>
Date: Tue, 17 Dec 2024 14:30:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: block/032 triggers lockdep complaint with v6.13-rc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

If I run test block/032, a lockdep complaint appears. Has anyone else 
noticed this?

Thanks,

Bart.

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc3-dbg #23 Not tainted
------------------------------------------------------
check/8526 is trying to acquire lock:
ffff88811e19c458 (&q->sysfs_lock){+.+.}-{4:4}, at: 
blk_unregister_queue+0xa7/0x2b0

but task is already holding lock:
ffff88811e19c018 (&q->q_usage_counter(queue)#28){++++}-{0:0}, at: 
sd_remove+0x95/0x150 [sd_mod]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&q->q_usage_counter(queue)#28){++++}-{0:0}:
        __lock_acquire+0xbec/0x1d90
        lock_acquire.part.0+0x13b/0x390
        lock_acquire+0x80/0xb0
        blk_queue_enter+0x3fc/0x520
        blk_mq_alloc_request+0x3dd/0x860
        scsi_execute_cmd+0x3f4/0x7b0 [scsi_mod]
        read_capacity_16+0x1d6/0xca0 [sd_mod]
        sd_read_capacity+0x196/0xa50 [sd_mod]
        sd_revalidate_disk.isra.0+0xb34/0x2090 [sd_mod]
        sd_probe+0x7f7/0xe20 [sd_mod]
        really_probe+0x1f4/0x8b0
        __driver_probe_device+0x19a/0x380
        driver_probe_device+0x4f/0x140
        __device_attach_driver+0x18c/0x290
        bus_for_each_drv+0x113/0x1a0
        __device_attach_async_helper+0x19b/0x240
        async_run_entry_fn+0x99/0x520
        process_one_work+0xdd0/0x1490
        worker_thread+0x5eb/0x1010
        kthread+0x2e5/0x3b0
        ret_from_fork+0x3a/0x80
        ret_from_fork_asm+0x11/0x20

-> #1 (&q->limits_lock){+.+.}-{4:4}:
        __lock_acquire+0xbec/0x1d90
        lock_acquire.part.0+0x13b/0x390
        lock_acquire+0x80/0xb0
        __mutex_lock+0x16f/0x13b0
        mutex_lock_nested+0x1f/0x30
        __blk_mq_update_nr_hw_queues+0x678/0x1410
        blk_mq_update_nr_hw_queues+0x31/0x40
        scsi_debug_write_info+0x34/0x1b0 [scsi_debug]
        zbc_show+0x3e/0x80 [scsi_debug]
        configfs_write_iter+0x2cf/0x4a0
        vfs_write+0x5ec/0x1220
        ksys_write+0x10a/0x1f0
        __x64_sys_write+0x76/0xb0
        x64_sys_call+0x27f/0x17d0
        do_syscall_64+0x92/0x180
        entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&q->sysfs_lock){+.+.}-{4:4}:
        check_prev_add+0x1b7/0x23b0
        validate_chain+0xf3d/0x1d70
        __lock_acquire+0xbec/0x1d90
        lock_acquire.part.0+0x13b/0x390
        lock_acquire+0x80/0xb0
        __mutex_lock+0x16f/0x13b0
        mutex_lock_nested+0x1f/0x30
        blk_unregister_queue+0xa7/0x2b0
        del_gendisk+0x266/0xb30
        sd_remove+0x95/0x150 [sd_mod]
        device_remove+0x111/0x160
        device_release_driver_internal+0x3c5/0x570
        device_release_driver+0x16/0x20
        bus_remove_device+0x1fa/0x3e0
        device_del+0x3ed/0xa20
        __scsi_remove_device+0x280/0x340 [scsi_mod]
        sdev_store_delete+0x8c/0x120 [scsi_mod]
        dev_attr_store+0x3f/0x70
        sysfs_kf_write+0x106/0x150
        kernfs_fop_write_iter+0x39e/0x5a0
        vfs_write+0x5ec/0x1220
        ksys_write+0x10a/0x1f0
        __x64_sys_write+0x76/0xb0
        x64_sys_call+0x27f/0x17d0
        do_syscall_64+0x92/0x180
        entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:
Chain exists of:
   &q->sysfs_lock --> &q->limits_lock --> &q->q_usage_counter(queue)#28
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&q->q_usage_counter(queue)#28);
                                lock(&q->limits_lock);
                                lock(&q->q_usage_counter(queue)#28);
   lock(&q->sysfs_lock);

  *** DEADLOCK ***
5 locks held by check/8526:
  #0: ffff88812e746418 (sb_writers#3){.+.+}-{0:0}, at: 
ksys_write+0x10a/0x1f0
  #1: ffff888189e4bc88 (&of->mutex#2){+.+.}-{4:4}, at: 
kernfs_fop_write_iter+0x261/0x5a0
  #2: ffff888190fee0e0 (&shost->scan_mutex){+.+.}-{4:4}, at: 
sdev_store_delete+0x84/0x120 [scsi_mod]
  #3: ffff88812e47a378 (&dev->mutex){....}-{4:4}, at: 
device_release_driver_internal+0xaa/0x570
  #4: ffff88811e19c018 (&q->q_usage_counter(queue)#28){++++}-{0:0}, at: 
sd_remove+0x95/0x150 [sd_mod]

stack backtrace:
CPU: 21 UID: 0 PID: 8526 Comm: check Not tainted 6.13.0-rc3-dbg #23 
65ecec9f9b5989219cd64cfc2b6ef3edbedebe25
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
  <TASK>
  show_stack+0x4d/0x60
  dump_stack_lvl+0x61/0x80
  dump_stack+0x14/0x16
  print_circular_bug.cold+0x39/0x43
  check_noncircular+0x2f4/0x3d0
  check_prev_add+0x1b7/0x23b0
  validate_chain+0xf3d/0x1d70
  __lock_acquire+0xbec/0x1d90
  lock_acquire.part.0+0x13b/0x390
  lock_acquire+0x80/0xb0
  __mutex_lock+0x16f/0x13b0
  mutex_lock_nested+0x1f/0x30
  blk_unregister_queue+0xa7/0x2b0
  del_gendisk+0x266/0xb30
  sd_remove+0x95/0x150 [sd_mod 95fdb9620c9f51a5a0ad41c05aada49874bfacdd]
  device_remove+0x111/0x160
  device_release_driver_internal+0x3c5/0x570
  device_release_driver+0x16/0x20
  bus_remove_device+0x1fa/0x3e0
  device_del+0x3ed/0xa20
  __scsi_remove_device+0x280/0x340 [scsi_mod 
bb02a8ce36abc63da71f0d4ee9a3085037ce1922]
  sdev_store_delete+0x8c/0x120 [scsi_mod 
bb02a8ce36abc63da71f0d4ee9a3085037ce1922]
  dev_attr_store+0x3f/0x70
  sysfs_kf_write+0x106/0x150
  kernfs_fop_write_iter+0x39e/0x5a0
  vfs_write+0x5ec/0x1220
  ksys_write+0x10a/0x1f0
  __x64_sys_write+0x76/0xb0
  x64_sys_call+0x27f/0x17d0
  do_syscall_64+0x92/0x180
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
