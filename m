Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38352C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 04:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiBZErC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 23:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiBZEq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 23:46:59 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E97B2ACD4F;
        Fri, 25 Feb 2022 20:46:26 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id o23so6420197pgk.13;
        Fri, 25 Feb 2022 20:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=nj432UFAM5VOOemXaY0K3bg1hhvY0vsuWQ/8n9KXdJc=;
        b=2ZslV52kzn5DhxY4lpv1dNXx6o83kfvh56jWrdUv7/bu61edY/sTluyjU4zPCSwDSB
         iVkWaJ2QdxuJ9PSWNu6iywGOaPGkT1iuqTmYbCJ4F2DuYhXolxJupr5rmkZd5WAr4FD/
         KbFIzRrmrGchh2J+UA7tvCuLov26QtqnWLKtcyiP2dQWgQM7FOLp5XzQyAiyfF0B/u3k
         HOF5iJnjFFO1ZE6oFI5BGpv6JSg2OkX081hfbI52HPnh7vy03jfamhhWk2cCtuUXsBTX
         iQqq5ZfABFgktcqiBLfHNTpDqIPiBWK+4dElJmhWaHzwa99gI2MYsDN68wM/ulOq4zB7
         xqNg==
X-Gm-Message-State: AOAM530Pu5nxcBAzItQKX/UIgL392RJoxvWX+S2wF4wLR1tQ+o6IjJH7
        tIrXbw+Ux7BIkpaVVu7qlZI=
X-Google-Smtp-Source: ABdhPJw9JsnVt6xjZYsHb/PqQAywfntL+yQQmfTAkERFNbVjFjPtjbfVBeAp4kpImiLBilSKgdkp+w==
X-Received: by 2002:a63:2a45:0:b0:373:1850:d5b with SMTP id q66-20020a632a45000000b0037318500d5bmr8578548pgq.563.1645850785412;
        Fri, 25 Feb 2022 20:46:25 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e7-20020aa78c47000000b004de8f900716sm4747599pfd.127.2022.02.25.20.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 20:46:24 -0800 (PST)
Message-ID: <660e2961-bbd9-afb5-7711-54745d8c6ad6@acm.org>
Date:   Fri, 25 Feb 2022 20:46:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: move more work to disk_release
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220222141450.591193-1-hch@lst.de>
Content-Language: en-US
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:14, Christoph Hellwig wrote:
> Git branch:
> 
>      git://git.infradead.org/users/hch/block.git freeze-5.18

A patch in or before this patch series may need some additional
work. This is what I see in the kernel log if I verify the above
kernel branch with blktests:

run blktests block/027 at 2022-02-26 03:54:57
[ ... ]
==================================================================
BUG: KASAN: use-after-free in sd_release+0x2a/0x100 [sd_mod]
Read of size 8 at addr ffff888115a0a000 by task fio/7217

CPU: 1 PID: 7217 Comm: fio Not tainted 5.17.0-rc2-dbg+ #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
Call Trace:
sd 9:0:0:1: [sde] Synchronizing SCSI cache
  <TASK>
  show_stack+0x52/0x58
  dump_stack_lvl+0x5b/0x82
  print_address_description.constprop.0+0x24/0x160
  ? sd_release+0x2a/0x100 [sd_mod]
  kasan_report.cold+0x82/0xdb
  ? perf_trace_sched_numa_pair_template+0x340/0x350
  ? sd_release+0x2a/0x100 [sd_mod]
  __asan_load8+0x69/0x90
  sd_release+0x2a/0x100 [sd_mod]
  blkdev_put+0x15a/0x3b0
  blkdev_close+0x3c/0x50
  __fput+0x13d/0x430
  ____fput+0xe/0x10
  task_work_run+0x8e/0xe0
  do_exit+0x2b6/0x5e0
  do_group_exit+0x71/0x150
  __x64_sys_exit_group+0x31/0x40
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8d243d0ed1
Code: Unable to access opcode bytes at RIP 0x7f8d243d0ea7.
RSP: 002b:00007ffe2c7aae48 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f8d243d0ed1
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000013
RBP: 00007f8d1214ae90 R08: ffffffffffffe168 R09: a53fa94fea53fa95
R10: 0000000000000002 R11: 0000000000000206 R12: 00007f8d253d3c30
R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000000
  </TASK>

Allocated by task 5692:
  kasan_save_stack+0x26/0x50
  __kasan_kmalloc+0x88/0xa0
  kmem_cache_alloc_trace+0x1a3/0x2c0
  sd_probe+0x9a/0x700 [sd_mod]
  really_probe+0x141/0x5d0
  __driver_probe_device+0x1aa/0x240
  driver_probe_device+0x4e/0x110
  __device_attach_driver+0xf6/0x160
  bus_for_each_drv+0xfd/0x160
  __device_attach_async_helper+0x138/0x190
  async_run_entry_fn+0x63/0x240
  process_one_work+0x594/0xad0
  worker_thread+0x2de/0x6b0
  kthread+0x15f/0x190
  ret_from_fork+0x1f/0x30

Freed by task 6426:
  kasan_save_stack+0x26/0x50
  kasan_set_track+0x25/0x30
  kasan_set_free_info+0x24/0x40
  __kasan_slab_free+0x100/0x140
  kfree+0xd1/0x510
  scsi_disk_release+0x41/0x50 [sd_mod]
  device_release+0x60/0x100
  kobject_cleanup+0x7f/0x1c0
  kobject_put+0x76/0x90
  put_device+0x13/0x20
  sd_remove+0x63/0x70 [sd_mod]
  __device_release_driver+0x37e/0x390
  device_release_driver+0x2b/0x40
  bus_remove_device+0x1aa/0x270
  device_del+0x2d4/0x640
  __scsi_remove_device+0x168/0x1a0
  sdev_store_delete+0x75/0xe0
  dev_attr_store+0x3e/0x60
  sysfs_kf_write+0x87/0xa0
  kernfs_fop_write_iter+0x1c7/0x270
  new_sync_write+0x296/0x3c0
  vfs_write+0x43c/0x580
  ksys_write+0xd9/0x180
  __x64_sys_write+0x42/0x50
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
  kasan_save_stack+0x26/0x50
  __kasan_record_aux_stack+0xa8/0xc0
  kasan_record_aux_stack_noalloc+0xb/0x10
  insert_work+0x3b/0x170
  __queue_work+0x32f/0x7d0
  queue_work_on+0x7e/0x90
  rpm_idle+0x432/0x460
  __pm_runtime_set_status+0x1da/0x520
  pm_runtime_remove+0xb3/0xc0
  device_pm_remove+0x108/0x190
  device_del+0x2dc/0x640
  __scsi_remove_device+0x168/0x1a0
  sdev_store_delete+0x75/0xe0
  dev_attr_store+0x3e/0x60
  sysfs_kf_write+0x87/0xa0
  kernfs_fop_write_iter+0x1c7/0x270
  new_sync_write+0x296/0x3c0
  vfs_write+0x43c/0x580
  ksys_write+0xd9/0x180
  __x64_sys_write+0x42/0x50
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
  kasan_save_stack+0x26/0x50
  __kasan_record_aux_stack+0xa8/0xc0
  kasan_record_aux_stack_noalloc+0xb/0x10
  insert_work+0x3b/0x170
  __queue_work+0x32f/0x7d0
  queue_work_on+0x7e/0x90
  queue_release_one_tty+0xbf/0xd0
  release_tty+0x241/0x290
  tty_release_struct+0x92/0xb0
  tty_release+0x5b1/0x5f0
  __fput+0x13d/0x430
  ____fput+0xe/0x10
  task_work_run+0x8e/0xe0
  exit_to_user_mode_loop+0xee/0xf0
  exit_to_user_mode_prepare+0xd6/0x100
  syscall_exit_to_user_mode+0x1e/0x50
  do_syscall_64+0x42/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888115a0a000
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
  2048-byte region [ffff888115a0a000, ffff888115a0a800)
The buggy address belongs to the page:
page:00000000fac6ce95 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888115a0f000 pfn:0x115a08
head:00000000fac6ce95 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x2000000000010200(slab|head|node=0|zone=2)
raw: 2000000000010200 ffffea00041d5408 ffffea000407d808 ffff888100042f00
raw: ffff888115a0f000 0000000000080006 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
