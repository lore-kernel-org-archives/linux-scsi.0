Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BCDC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E58207BB
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XS3OUAFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgKCNFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:05:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728435AbgKCNFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604408708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnN2yYPfP9GNF1ucx3BkbjCdSBpk7fING/WtuEGj1NQ=;
        b=XS3OUAFt/2TqG7/ca0JbicZkMjS4pGOB+uJ0yeyDg38RbUnA5F1znuVZ/g44O0LYE0PXqT
        OrqEgk+TimqSDUMRgDhznUALft4z0MpKEkigkUqEHecMlMJq5PqJ7ECxvYjiCMZGTTd0uK
        43N0mbjz3Xrd0ZqsEu0A1BTw2Rl2wQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-OuinMCwBM6-H3i-E5n2hUQ-1; Tue, 03 Nov 2020 08:05:04 -0500
X-MC-Unique: OuinMCwBM6-H3i-E5n2hUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C47710B9CA6;
        Tue,  3 Nov 2020 13:05:00 +0000 (UTC)
Received: from ovpn-112-12.rdu2.redhat.com (ovpn-112-12.rdu2.redhat.com [10.10.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49FA155763;
        Tue,  3 Nov 2020 13:04:54 +0000 (UTC)
Message-ID: <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   Qian Cai <cai@redhat.com>
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        ming.lei@redhat.com, bvanassche@acm.org, dgilbert@interlog.com,
        paolo.valente@linaro.org, hare@suse.de, hch@lst.de
Cc:     sumit.saxena@broadcom.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, megaraidlinux.pdl@broadcom.com,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Date:   Tue, 03 Nov 2020 08:04:52 -0500
In-Reply-To: <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
         <1597850436-116171-18-git-send-email-john.garry@huawei.com>
         <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
         <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com>
         <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
         <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-11-03 at 10:54 +0000, John Garry wrote:
> I have no x86 system to test that x86 config, though. How about 
> v5.10-rc2 for this issue?

v5.10-rc2 is also broken here.

[  251.941451][  T330] INFO: task systemd-udevd:551 blocked for more than 122 seconds.
[  251.949176][  T330]       Not tainted 5.10.0-rc2 #3
[  251.954094][  T330] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  251.962633][  T330] task:systemd-udevd   state:D stack:27160 pid:  551 ppid:   506 flags:0x00000324
[  251.971707][  T330] Call Trace:
[  251.974871][  T330]  __schedule+0x71d/0x1b50
[  251.979155][  T330]  ? kcore_callback+0x1d/0x1d
[  251.983709][  T330]  schedule+0xbf/0x270
[  251.987640][  T330]  schedule_timeout+0x3fc/0x590
[  251.992370][  T330]  ? usleep_range+0x120/0x120
[  251.996910][  T330]  ? wait_for_completion+0x156/0x250
[  252.002080][  T330]  ? lock_downgrade+0x700/0x700
[  252.006792][  T330]  ? rcu_read_unlock+0x40/0x40
[  252.011435][  T330]  ? do_raw_spin_lock+0x121/0x290
[  252.016324][  T330]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[  252.022178][  T330]  ? _raw_spin_unlock_irq+0x1f/0x30
[  252.027235][  T330]  wait_for_completion+0x15e/0x250
[  252.032226][  T330]  ? wait_for_completion_interruptible+0x2f0/0x2f0
[  252.038590][  T330]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[  252.044443][  T330]  ? _raw_spin_unlock_irq+0x1f/0x30
[  252.049502][  T330]  __flush_work+0x42a/0x900
[  252.053882][  T330]  ? queue_delayed_work_on+0x90/0x90
[  252.059025][  T330]  ? __queue_work+0x463/0xf40
[  252.063583][  T330]  ? init_pwq+0x320/0x320
[  252.067777][  T330]  ? queue_work_on+0x5e/0x80
[  252.072249][  T330]  ? trace_hardirqs_on+0x1c/0x150
[  252.077138][  T330]  work_on_cpu+0xe7/0x130
[  252.081347][  T330]  ? flush_delayed_work+0xc0/0xc0
[  252.086231][  T330]  ? __mutex_unlock_slowpath+0xd4/0x670
[  252.091655][  T330]  ? work_debug_hint+0x30/0x30
[  252.096284][  T330]  ? pci_device_shutdown+0x80/0x80
[  252.101274][  T330]  ? cpumask_next_and+0x57/0x80
[  252.105990][  T330]  pci_device_probe+0x500/0x5c0
[  252.110703][  T330]  ? pci_device_remove+0x1f0/0x1f0
[  252.115697][  T330]  really_probe+0x207/0xad0
[  252.120065][  T330]  ? device_driver_attach+0x120/0x120
[  252.125317][  T330]  driver_probe_device+0x1f1/0x370
[  252.130291][  T330]  device_driver_attach+0xe5/0x120
[  252.135281][  T330]  __driver_attach+0xf0/0x260
[  252.139827][  T330]  bus_for_each_dev+0x117/0x1a0
[  252.144552][  T330]  ? subsys_dev_iter_exit+0x10/0x10
[  252.149609][  T330]  bus_add_driver+0x399/0x560
[  252.154166][  T330]  driver_register+0x189/0x310
[  252.158795][  T330]  ? 0xffffffffc05c5000
[  252.162838][  T330]  megasas_init+0x117/0x1000 [megaraid_sas]
[  252.168593][  T330]  do_one_initcall+0xf6/0x510
[  252.173143][  T330]  ? perf_trace_initcall_level+0x490/0x490
[  252.178809][  T330]  ? kasan_unpoison_shadow+0x30/0x40
[  252.183973][  T330]  ? __kasan_kmalloc.constprop.11+0xc1/0xd0
[  252.189728][  T330]  ? do_init_module+0x49/0x6c0
[  252.194370][  T330]  ? kmem_cache_alloc_trace+0x12e/0x2a0
[  252.199780][  T330]  ? kasan_unpoison_shadow+0x30/0x40
[  252.204942][  T330]  do_init_module+0x1ed/0x6c0
[  252.209479][  T330]  load_module+0x4a25/0x5cf0
[  252.213950][  T330]  ? layout_and_allocate+0x2770/0x2770
[  252.219271][  T330]  ? __vmalloc_node+0x8d/0x100
[  252.223913][  T330]  ? kernel_read_file+0x485/0x5a0
[  252.228796][  T330]  ? kernel_read_file+0x305/0x5a0
[  252.233696][  T330]  ? __ia32_sys_fsconfig+0x6a0/0x6a0
[  252.238841][  T330]  ? __do_sys_finit_module+0xff/0x180
[  252.244093][  T330]  __do_sys_finit_module+0xff/0x180
[  252.249155][  T330]  ? __do_sys_init_module+0x1d0/0x1d0
[  252.254403][  T330]  ? __fget_files+0x1c3/0x2e0
[  252.258940][  T330]  do_syscall_64+0x33/0x40
[  252.263234][  T330]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  252.268984][  T330] RIP: 0033:0x7f7cf6a4878d
[  252.273276][  T330] Code: Unable to access opcode bytes at RIP 0x7f7cf6a48763.
[  252.280499][  T330] RSP: 002b:00007ffcfa94b978 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  252.288781][  T330] RAX: ffffffffffffffda RBX: 000055e01f48b730 RCX: 00007f7cf6a4878d
[  252.296628][  T330] RDX: 0000000000000000 RSI: 00007f7cf75ba82d RDI: 0000000000000006
[  252.304482][  T330] RBP: 00007f7cf75ba82d R08: 0000000000000000 R09: 00007ffcfa94baa0
[  252.312331][  T330] R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
[  252.320167][  T330] R13: 000055e01f433530 R14: 0000000000020000 R15: 0000000000000000
[  252.328052][  T330] 
[  252.328052][  T330] Showing all locks held in the system:
[  252.335722][  T330] 3 locks held by kworker/3:1/289:
[  252.340697][  T330]  #0: ffff8881001eb338 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ec/0x1610
[  252.350906][  T330]  #1: ffffc90004ef7e00 ((work_completion)(&wfc.work)){+.+.}-{0:0}, at: process_one_work+0x820/0x1610
[  252.361725][  T330]  #2: ffff88810dc600e0 (&shost->scan_mutex){+.+.}-{3:3}, at: scsi_scan_host_selected+0xde/0x260
[  252.372132][  T330] 1 lock held by khungtaskd/330:
[  252.376933][  T330]  #0: ffffffffb42d2de0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.52+0x0/0x30
[  252.387234][  T330] 1 lock held by systemd-journal/398:
[  252.392489][  T330] 1 lock held by systemd-udevd/551:
[  252.397550][  T330]  #0: ffff888109a49218 (&dev->mutex){....}-{3:3}, at: device_driver_attach+0x37/0x120
[  252.407085][  T330] 
[  252.409285][  T330] =============================================
[  252.409285][  T330] 


