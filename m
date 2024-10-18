Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA384E18
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 01:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729214468; cv=none; b=hhuh8bQyU0J/sBsii2nFS0BkrxXtR+fiKCItme1NUNzOyA2bPv24/lwpNi0EgHLU24yX5hFxw4j8g6MVLrbHctzWH8sTU4WO+V/oifBmLV+60pElyHau5Ui5XNpm6xvBpKidkuFkNyuLoRvADnjvqkhhJGqNfff4/NDdK6ZBmtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729214468; c=relaxed/simple;
	bh=22tC3XS96w9ArKwQohnqAqZqdqDzf6qGokP9ZmXIJ3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RW4Xu0CAgz/oOuIlAv3EOEszWd63dXVDAv3btI/FE+mX9n0pJW7dUSh3/L2ko9APXP2wqtqfERtmEsqYoNdAPIJYuGW+JTIXQes7y9W4YojG8LABUOzyOfuhacWBwODAZLgH9Nvo5odBZ1lMl1DIrlW98NiCSl0Og7RUW43nDaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxO8nf8L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxO8nf8L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729214464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=22tC3XS96w9ArKwQohnqAqZqdqDzf6qGokP9ZmXIJ3Q=;
	b=XxO8nf8LoM9mXWgSjCN9Fbc385KVv3xGnPzhN+fd6h7M8kWYD61J8iRjS54eQUGSYF4ig0
	bZrhwGVvrIEvLmjV7fF/WAzi20tgGfPmLQeSipdxUCt7C8q2nSMJ2sEoAXahdVeoSKyVkD
	OXMXx2STCAV+lmIZt/xAOV5h86lkFrU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-2uBipMplMPGNLQJPO7t_bw-1; Thu,
 17 Oct 2024 21:21:01 -0400
X-MC-Unique: 2uBipMplMPGNLQJPO7t_bw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3DF419560BF;
	Fri, 18 Oct 2024 01:20:59 +0000 (UTC)
Received: from fedora (unknown [10.72.116.56])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2856119560A2;
	Fri, 18 Oct 2024 01:20:54 +0000 (UTC)
Date: Fri, 18 Oct 2024 09:20:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Cc: ming.lei@redhat.com, linux-scsi@vger.kernel.org,
	Guangwu Zhang <guazhang@redhat.com>
Subject: [Report] queue_freeze & queue_enter deadlock in scsi
Message-ID: <ZxG38G9BuFdBpBHZ@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hello,

In our RH internal test done by Guangwu, the following warning is reported when
setting `write_cache` sysfs attribute, and turns out it is one race between
freezing queue and entering queue.

Oct 15 22:27:59 storageqe-105 kernel: task:systemd-udevd state stack:0 pid:924 tgid:924 ppid:1 flags:0x00004006
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: blk_queue_enter+0x164/0x220
Oct 15 22:27:59 storageqe-105 kernel: ? __pfx_autoremove_wake_function+0x10/0x10
Oct 15 22:27:59 storageqe-105 kernel: blk_mq_alloc_request+0x130/0x2c0
Oct 15 22:27:59 storageqe-105 kernel: scsi_execute_cmd+0xd1/0x330
Oct 15 22:27:59 storageqe-105 kernel: read_capacity_16+0x111/0x410 [sd_mod]
Oct 15 22:27:59 storageqe-105 kernel: sd_read_capacity+0x7e/0x340 [sd_mod]
Oct 15 22:27:59 storageqe-105 kernel: sd_revalidate_disk.isra.0+0x374/0xbd0 [sd_mod]
Oct 15 22:27:59 storageqe-105 kernel: ? scsi_block_when_processing_errors+0x25/0x100
Oct 15 22:27:59 storageqe-105 kernel: sd_open+0x13d/0x1b0 [sd_mod]
Oct 15 22:27:59 storageqe-105 kernel: blkdev_get_whole+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: bdev_open+0x208/0x3b0
Oct 15 22:27:59 storageqe-105 kernel: bdev_file_open_by_dev+0xc6/0x120
Oct 15 22:27:59 storageqe-105 kernel: disk_scan_partitions+0x6c/0xe0
Oct 15 22:27:59 storageqe-105 kernel: blkdev_ioctl+0xc4/0x270
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_ioctl+0x94/0xd0
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? blkdev_common_ioctl+0x4f3/0x9e0
Oct 15 22:27:59 storageqe-105 kernel: ? mutex_lock+0x12/0x30
Oct 15 22:27:59 storageqe-105 kernel: ? __seccomp_filter+0x303/0x520
Oct 15 22:27:59 storageqe-105 kernel: ? blkdev_ioctl+0xc4/0x270
Oct 15 22:27:59 storageqe-105 kernel: ? kmem_cache_alloc_noprof+0x105/0x2f0
Oct 15 22:27:59 storageqe-105 kernel: ? locks_insert_lock_ctx+0x52/0x90
Oct 15 22:27:59 storageqe-105 kernel: ? flock_lock_inode+0x20c/0x3c0
Oct 15 22:27:59 storageqe-105 kernel: ? locks_lock_inode_wait+0xee/0x1d0
Oct 15 22:27:59 storageqe-105 kernel: ? __x64_sys_getrandom+0xcc/0x150
Oct 15 22:27:59 storageqe-105 kernel: ? __do_sys_flock+0x125/0x1d0
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7effe5128e7f
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffd87f0d550 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 0000000000000012 RCX: 00007effe5128e7f
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000000 RSI: 000000000000125f RDI: 0000000000000012
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000000000000012 R08: 0000000000000069 R09: 00000000fffffffe
Oct 15 22:27:59 storageqe-105 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd87f0d620
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007ffd87f0d5f0 R14: 000055c870bd8e30 R15: 0000000000000000
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:smartd state stack:0 pid:1170 tgid:1170 ppid:1 flags:0x00000002
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: ? find_inode_fast+0xa7/0xd0
Oct 15 22:27:59 storageqe-105 kernel: bdev_open+0x2ae/0x3b0
Oct 15 22:27:59 storageqe-105 kernel: ? __pfx_blkdev_open+0x10/0x10
Oct 15 22:27:59 storageqe-105 kernel: blkdev_open+0xc7/0x100
Oct 15 22:27:59 storageqe-105 kernel: ? bpf_lsm_file_open+0x9/0x10
Oct 15 22:27:59 storageqe-105 kernel: do_dentry_open+0x257/0x490
Oct 15 22:27:59 storageqe-105 kernel: vfs_open+0x34/0xf0
Oct 15 22:27:59 storageqe-105 kernel: do_open+0x165/0x3d0
Oct 15 22:27:59 storageqe-105 kernel: path_openat+0x124/0x2d0
Oct 15 22:27:59 storageqe-105 kernel: ? pick_next_task+0x9a7/0xb10
Oct 15 22:27:59 storageqe-105 kernel: do_filp_open+0xc4/0x170
Oct 15 22:27:59 storageqe-105 kernel: do_sys_openat2+0xae/0xe0
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_openat+0x55/0xa0
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? _copy_to_user+0x24/0x40
Oct 15 22:27:59 storageqe-105 kernel: ? put_sg_io_hdr+0x3c/0xf0
Oct 15 22:27:59 storageqe-105 kernel: ? sg_io+0x83/0x330
Oct 15 22:27:59 storageqe-105 kernel: ? scsi_ioctl+0x333/0x560
Oct 15 22:27:59 storageqe-105 kernel: ? rseq_get_rseq_cs+0x1d/0x220
Oct 15 22:27:59 storageqe-105 kernel: ? rseq_ip_fixup+0x8d/0x1d0
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x151/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? rseq_ip_fixup+0x8d/0x1d0
Oct 15 22:27:59 storageqe-105 kernel: ? page_counter_uncharge+0x33/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? drain_stock+0x68/0xa0
Oct 15 22:27:59 storageqe-105 kernel: ? __refill_stock+0x81/0x90
Oct 15 22:27:59 storageqe-105 kernel: ? __memcg_slab_free_hook+0x100/0x150
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_work+0xf3/0x120
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_work+0xf3/0x120
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7ffa60320210
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffcee5b88f0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 0000000000000800 RCX: 00007ffa60320210
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000800 RSI: 000055f3efdf1e50 RDI: 00000000ffffff9c
Oct 15 22:27:59 storageqe-105 kernel: RBP: 000055f3efdf1e50 R08: 0000000000000001 R09: 0000000000000001
Oct 15 22:27:59 storageqe-105 kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 000055f3efed4950
Oct 15 22:27:59 storageqe-105 kernel: R13: 000055f3efea2668 R14: 000055f3ea13be69 R15: 000055f3efed4968
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:fio state stack:0 pid:13487 tgid:13487 ppid:13423 flags:0x00000002
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: bdev_release+0x66/0x160
Oct 15 22:27:59 storageqe-105 kernel: blkdev_release+0x11/0x20
Oct 15 22:27:59 storageqe-105 kernel: __fput+0xee/0x2c0
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_close+0x3c/0x80
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? update_load_avg+0x7e/0x7c0
Oct 15 22:27:59 storageqe-105 kernel: ? set_next_entity+0xd3/0x1c0
Oct 15 22:27:59 storageqe-105 kernel: ? pick_next_task_fair+0x15c/0x5b0
Oct 15 22:27:59 storageqe-105 kernel: ? __pte_offset_map+0x1b/0x130
Oct 15 22:27:59 storageqe-105 kernel: ? next_uptodate_folio+0x89/0x2a0
Oct 15 22:27:59 storageqe-105 kernel: ? filemap_map_pages+0x50b/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_read_fault+0xfa/0x1e0
Oct 15 22:27:59 storageqe-105 kernel: ? do_fault+0x12f/0x340
Oct 15 22:27:59 storageqe-105 kernel: ? __handle_mm_fault+0x2e8/0x720
Oct 15 22:27:59 storageqe-105 kernel: ? __count_memcg_events+0x58/0xf0
Oct 15 22:27:59 storageqe-105 kernel: ? handle_mm_fault+0x234/0x350
Oct 15 22:27:59 storageqe-105 kernel: ? do_user_addr_fault+0x347/0x640
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffdcfda29d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 00007f6d6c5364d0 RCX: 00007f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Oct 15 22:27:59 storageqe-105 kernel: R10: 00007ffdcfda2a60 R11: 0000000000000293 R12: 00007f6d64648000
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007f6d6c536c50 R14: 0000000000000001 R15: 00007f6d64648000
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:fio state stack:0 pid:13488 tgid:13488 ppid:13423 flags:0x00000002
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: bdev_release+0x66/0x160
Oct 15 22:27:59 storageqe-105 kernel: blkdev_release+0x11/0x20
Oct 15 22:27:59 storageqe-105 kernel: __fput+0xee/0x2c0
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_close+0x3c/0x80
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? do_read_fault+0xfa/0x1e0
Oct 15 22:27:59 storageqe-105 kernel: ? do_fault+0x12f/0x340
Oct 15 22:27:59 storageqe-105 kernel: ? __handle_mm_fault+0x2e8/0x720
Oct 15 22:27:59 storageqe-105 kernel: ? __count_memcg_events+0x58/0xf0
Oct 15 22:27:59 storageqe-105 kernel: ? handle_mm_fault+0x234/0x350
Oct 15 22:27:59 storageqe-105 kernel: ? do_user_addr_fault+0x347/0x640
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffdcfda29d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 00007f6d6c536690 RCX: 00007f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Oct 15 22:27:59 storageqe-105 kernel: R10: 00007ffdcfda2a60 R11: 0000000000000293 R12: 00007f6d64676c00
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007f6d6c536c50 R14: 0000000000000001 R15: 00007f6d64676c00
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:fio state stack:0 pid:13489 tgid:13489 ppid:13423 flags:0x00000002
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: bdev_release+0x66/0x160
Oct 15 22:27:59 storageqe-105 kernel: blkdev_release+0x11/0x20
Oct 15 22:27:59 storageqe-105 kernel: __fput+0xee/0x2c0
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_close+0x3c/0x80
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x151/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? __pte_offset_map+0x1b/0x130
Oct 15 22:27:59 storageqe-105 kernel: ? next_uptodate_folio+0x89/0x2a0
Oct 15 22:27:59 storageqe-105 kernel: ? filemap_map_pages+0x50b/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: ? cputime_adjust+0x29/0xc0
Oct 15 22:27:59 storageqe-105 kernel: ? task_cputime_adjusted+0x70/0xb0
Oct 15 22:27:59 storageqe-105 kernel: ? get_task_mm+0x42/0x50
Oct 15 22:27:59 storageqe-105 kernel: ? mmput+0x12/0x30
Oct 15 22:27:59 storageqe-105 kernel: ? getrusage+0x225/0x490
Oct 15 22:27:59 storageqe-105 kernel: ? _copy_to_user+0x24/0x40
Oct 15 22:27:59 storageqe-105 kernel: ? __do_sys_getrusage+0x6b/0xb0
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_work+0xf3/0x120
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? do_syscall_64+0x89/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? handle_mm_fault+0x234/0x350
Oct 15 22:27:59 storageqe-105 kernel: ? do_user_addr_fault+0x347/0x640
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffdcfda29d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 00007f6d6c536850 RCX: 00007f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Oct 15 22:27:59 storageqe-105 kernel: R10: 00007ffdcfda2a60 R11: 0000000000000293 R12: 00007f6d646a5800
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007f6d6c536c50 R14: 0000000000000001 R15: 00007f6d646a5800
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:fio state stack:0 pid:13490 tgid:13490 ppid:13423 flags:0x00000002
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: bdev_release+0x66/0x160
Oct 15 22:27:59 storageqe-105 kernel: blkdev_release+0x11/0x20
Oct 15 22:27:59 storageqe-105 kernel: __fput+0xee/0x2c0
Oct 15 22:27:59 storageqe-105 kernel: __x64_sys_close+0x3c/0x80
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? _copy_to_user+0x24/0x40
Oct 15 22:27:59 storageqe-105 kernel: ? __do_sys_getrusage+0x6b/0xb0
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_work+0xf3/0x120
Oct 15 22:27:59 storageqe-105 kernel: ? syscall_exit_to_user_mode+0x10/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffdcfda29d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 00007f6d6c536a10 RCX: 00007f6d6d614f3a
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Oct 15 22:27:59 storageqe-105 kernel: R10: 00007ffdcfda2a60 R11: 0000000000000293 R12: 00007f6d646d4400
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007f6d6c536c50 R14: 0000000000000001 R15: 00007f6d646d4400
Oct 15 22:27:59 storageqe-105 kernel: </TASK>
Oct 15 22:27:59 storageqe-105 kernel: task:sh state stack:0 pid:13870 tgid:13870 ppid:1524 flags:0x00004006
Oct 15 22:27:59 storageqe-105 kernel: Call Trace:
Oct 15 22:27:59 storageqe-105 kernel: <TASK>
Oct 15 22:27:59 storageqe-105 kernel: __schedule+0x239/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: schedule+0x27/0xa0
Oct 15 22:27:59 storageqe-105 kernel: schedule_preempt_disabled+0x15/0x30
Oct 15 22:27:59 storageqe-105 kernel: __mutex_lock.constprop.0+0x3d0/0x6d0
Oct 15 22:27:59 storageqe-105 kernel: ? sched_balance_newidle+0x2c8/0x460
Oct 15 22:27:59 storageqe-105 kernel: queue_wc_store+0x12f/0x170
Oct 15 22:27:59 storageqe-105 kernel: ? __schedule+0x241/0x5f0
Oct 15 22:27:59 storageqe-105 kernel: ? prepare_to_wait_event+0x56/0x190
Oct 15 22:27:59 storageqe-105 kernel: ? finish_wait+0x44/0x90
Oct 15 22:27:59 storageqe-105 kernel: ? blk_mq_freeze_queue_wait+0xc6/0xd0
Oct 15 22:27:59 storageqe-105 kernel: ? __pfx_autoremove_wake_function+0x10/0x10
Oct 15 22:27:59 storageqe-105 kernel: queue_attr_store+0x82/0xc0
Oct 15 22:27:59 storageqe-105 kernel: kernfs_fop_write_iter+0x13e/0x1f0
Oct 15 22:27:59 storageqe-105 kernel: vfs_write+0x291/0x460
Oct 15 22:27:59 storageqe-105 kernel: ksys_write+0x6d/0xf0
Oct 15 22:27:59 storageqe-105 kernel: do_syscall_64+0x7d/0x160
Oct 15 22:27:59 storageqe-105 kernel: ? memcg1_check_events+0x17/0x30
Oct 15 22:27:59 storageqe-105 kernel: ? __mod_memcg_lruvec_state+0xa0/0x150
Oct 15 22:27:59 storageqe-105 kernel: ? __lruvec_stat_mod_folio+0x86/0xd0
Oct 15 22:27:59 storageqe-105 kernel: ? __folio_mod_stat+0x26/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? do_anonymous_page+0x3e4/0x550
Oct 15 22:27:59 storageqe-105 kernel: ? __handle_mm_fault+0x2e8/0x720
Oct 15 22:27:59 storageqe-105 kernel: ? __count_memcg_events+0x58/0xf0
Oct 15 22:27:59 storageqe-105 kernel: ? handle_mm_fault+0x234/0x350
Oct 15 22:27:59 storageqe-105 kernel: ? do_user_addr_fault+0x347/0x640
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: ? clear_bhb_loop+0x25/0x80
Oct 15 22:27:59 storageqe-105 kernel: entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct 15 22:27:59 storageqe-105 kernel: RIP: 0033:0x7fc7f7c8d6a4
Oct 15 22:27:59 storageqe-105 kernel: RSP: 002b:00007ffdcddda428 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
Oct 15 22:27:59 storageqe-105 kernel: RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fc7f7c8d6a4
Oct 15 22:27:59 storageqe-105 kernel: RDX: 0000000000000010 RSI: 0000557f6ce97900 RDI: 0000000000000001
Oct 15 22:27:59 storageqe-105 kernel: RBP: 0000557f6ce97900 R08: 0000000000000073 R09: 00000000ffffffff
Oct 15 22:27:59 storageqe-105 kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000010
Oct 15 22:27:59 storageqe-105 kernel: R13: 00007fc7f7d635c0 R14: 0000000000000010 R15: 00007fc7f7d60f00
Oct 15 22:27:59 storageqe-105 kernel: </TASK>



Thanks,
Ming

