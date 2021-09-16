Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AFDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 09:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C43A611C8
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 09:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhIPJGE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 05:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhIPJGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 05:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3734361164
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 09:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631783082;
        bh=DldelqA2z8ItzgPM837BY1E+S86+J4Id2fuORtGSRSM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t2JVslvDCZ0xksvzBhpYNKhv8jdoAIdinzRVGDgHJmomvynS6WCmeoFb4ToRtSAK3
         kWkGRYAXp05jbTSjxTMBKhgNBocr092K6k9wOcRsYDhVHKzyptGeG1/3hw9LTzclFZ
         6+1rSzmBlO0nRvfpBeDjf5G1MUp2Cq2Rc/9MekaaEtBtHg3CI4kReT116wj/w1TN0r
         I+HFQArH62f8mkv5xMcwNqkq+krrGnCFza9D1qruPaYB/rpAaWld/PJHTAZ5bmKX+S
         ebCWaiqnLgH6U4KD4BKnwONTr/yl34zff2b6Hi2DVFIsI6g7yKYJTjyA94TDrJ1zdf
         b8u5bSjAH34Jw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214147] ISCSI broken in last release
Date:   Thu, 16 Sep 2021 09:04:41 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214147-11613-S2CXGOPUGn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214147-11613@https.bugzilla.kernel.org/>
References: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214147

--- Comment #5 from Badalian Slava (slavon.net@gmail.com) ---
WWith turned off ISCSI and NVMEt. only NFS active

.
```


[ 2164.273231] perf: interrupt took too long (3197 > 3148), lowering
kernel.perf_event_max_sample_rate to 62000
[ 3067.386864] perf: interrupt took too long (4023 > 3996), lowering
kernel.perf_event_max_sample_rate to 49000
[ 4508.876951] perf: interrupt took too long (5034 > 5028), lowering
kernel.perf_event_max_sample_rate to 39000
[ 7336.586251] perf: interrupt took too long (6305 > 6292), lowering
kernel.perf_event_max_sample_rate to 31000
[16343.647108] INFO: task txg_sync:897001 blocked for more than 122 seconds.
[16343.657122]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[16343.667018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[16343.676854] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[16343.686665] Call Trace:
[16343.696132]  __schedule+0x396/0x8a0
[16343.705378]  schedule+0x3c/0xa0
[16343.714360]  schedule_timeout+0x197/0x2b0
[16343.723125]  ? timer_update_keys+0x30/0x30
[16343.731752]  io_schedule_timeout+0x19/0x40
[16343.740453]  __cv_timedwait_common+0x12b/0x160 [spl]
[16343.749335]  ? wait_woken+0x80/0x80
[16343.758275]  __cv_timedwait_io+0x15/0x20 [spl]
[16343.767344]  zio_wait+0x129/0x2b0 [zfs]
[16343.776599]  dsl_pool_sync+0xd0/0x470 [zfs]
[16343.785629]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[16343.794490]  ? __kmalloc_node+0x181/0x330
[16343.803219]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[16343.811995]  spa_sync+0x389/0x690 [zfs]
[16343.820544]  txg_sync_thread+0x270/0x2f0 [zfs]
[16343.829106]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[16343.837545]  ? __thread_exit+0x20/0x20 [spl]
[16343.845678]  thread_generic_wrapper+0x6c/0x80 [spl]
[16343.853833]  kthread+0x118/0x140
[16343.861743]  ? set_kthread_struct+0x40/0x40
[16343.869501]  ret_from_fork+0x1f/0x30
[16589.391679] INFO: task txg_sync:897001 blocked for more than 122 seconds.
[16589.399411]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[16589.407078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[16589.414718] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[16589.422347] Call Trace:
[16589.429638]  __schedule+0x396/0x8a0
[16589.436751]  schedule+0x3c/0xa0
[16589.443608]  schedule_timeout+0x197/0x2b0
[16589.450258]  ? timer_update_keys+0x30/0x30
[16589.456706]  io_schedule_timeout+0x19/0x40
[16589.462926]  __cv_timedwait_common+0x12b/0x160 [spl]
[16589.469088]  ? wait_woken+0x80/0x80
[16589.475108]  __cv_timedwait_io+0x15/0x20 [spl]
[16589.481039]  zio_wait+0x129/0x2b0 [zfs]
[16589.486879]  dsl_pool_sync+0xd0/0x470 [zfs]
[16589.492585]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[16589.498376]  ? __kmalloc_node+0x181/0x330
[16589.504065]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[16589.510015]  spa_sync+0x389/0x690 [zfs]
[16589.515917]  txg_sync_thread+0x270/0x2f0 [zfs]
[16589.521867]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[16589.527853]  ? __thread_exit+0x20/0x20 [spl]
[16589.533715]  thread_generic_wrapper+0x6c/0x80 [spl]
[16589.539629]  kthread+0x118/0x140
[16589.545490]  ? set_kthread_struct+0x40/0x40
[16589.551393]  ret_from_fork+0x1f/0x30
[16712.262822] INFO: task txg_sync:897001 blocked for more than 245 seconds.
[16712.268937]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[16712.275093] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[16712.281379] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[16712.287872] Call Trace:
[16712.294197]  __schedule+0x396/0x8a0
[16712.300540]  schedule+0x3c/0xa0
[16712.306795]  schedule_timeout+0x197/0x2b0
[16712.313005]  ? timer_update_keys+0x30/0x30
[16712.319211]  io_schedule_timeout+0x19/0x40
[16712.325401]  __cv_timedwait_common+0x12b/0x160 [spl]
[16712.331551]  ? wait_woken+0x80/0x80
[16712.337545]  __cv_timedwait_io+0x15/0x20 [spl]
[16712.343428]  zio_wait+0x129/0x2b0 [zfs]
[16712.349237]  dsl_pool_sync+0xd0/0x470 [zfs]
[16712.354918]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[16712.360658]  ? __kmalloc_node+0x181/0x330
[16712.366315]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[16712.372219]  spa_sync+0x389/0x690 [zfs]
[16712.378091]  txg_sync_thread+0x270/0x2f0 [zfs]
[16712.384027]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[16712.389992]  ? __thread_exit+0x20/0x20 [spl]
[16712.395841]  thread_generic_wrapper+0x6c/0x80 [spl]
[16712.401736]  kthread+0x118/0x140
[16712.407599]  ? set_kthread_struct+0x40/0x40
[16712.413528]  ret_from_fork+0x1f/0x30
[17080.879563] INFO: task txg_sync:897001 blocked for more than 122 seconds.
[17080.885652]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[17080.891804] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[17080.898104] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[17080.904598] Call Trace:
[17080.910927]  __schedule+0x396/0x8a0
[17080.917254]  schedule+0x3c/0xa0
[17080.923501]  schedule_timeout+0x197/0x2b0
[17080.929722]  ? timer_update_keys+0x30/0x30
[17080.935962]  io_schedule_timeout+0x19/0x40
[17080.942162]  __cv_timedwait_common+0x12b/0x160 [spl]
[17080.948331]  ? wait_woken+0x80/0x80
[17080.954333]  __cv_timedwait_io+0x15/0x20 [spl]
[17080.960221]  zio_wait+0x129/0x2b0 [zfs]
[17080.966039]  dsl_pool_sync+0xd0/0x470 [zfs]
[17080.971729]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[17080.977490]  ? __kmalloc_node+0x181/0x330
[17080.983150]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[17080.989056]  spa_sync+0x389/0x690 [zfs]
[17080.994918]  txg_sync_thread+0x270/0x2f0 [zfs]
[17081.000838]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[17081.006814]  ? __thread_exit+0x20/0x20 [spl]
[17081.012668]  thread_generic_wrapper+0x6c/0x80 [spl]
[17081.018579]  kthread+0x118/0x140
[17081.024437]  ? set_kthread_struct+0x40/0x40
[17081.030328]  ret_from_fork+0x1f/0x30
[17449.496395] INFO: task txg_sync:897001 blocked for more than 122 seconds.
[17449.502486]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[17449.508658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[17449.514971] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[17449.521482] Call Trace:
[17449.527816]  __schedule+0x396/0x8a0
[17449.534139]  schedule+0x3c/0xa0
[17449.540394]  schedule_timeout+0x197/0x2b0
[17449.546614]  ? timer_update_keys+0x30/0x30
[17449.552862]  io_schedule_timeout+0x19/0x40
[17449.559082]  __cv_timedwait_common+0x12b/0x160 [spl]
[17449.565219]  ? wait_woken+0x80/0x80
[17449.571213]  __cv_timedwait_io+0x15/0x20 [spl]
[17449.577088]  zio_wait+0x129/0x2b0 [zfs]
[17449.582897]  dsl_pool_sync+0xd0/0x470 [zfs]
[17449.588566]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[17449.594304]  ? __kmalloc_node+0x181/0x330
[17449.599966]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[17449.605877]  spa_sync+0x389/0x690 [zfs]
[17449.611760]  txg_sync_thread+0x270/0x2f0 [zfs]
[17449.617729]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[17449.623713]  ? __thread_exit+0x20/0x20 [spl]
[17449.629578]  thread_generic_wrapper+0x6c/0x80 [spl]
[17449.635512]  kthread+0x118/0x140
[17449.641394]  ? set_kthread_struct+0x40/0x40
[17449.647310]  ret_from_fork+0x1f/0x30
[17940.988317] INFO: task txg_sync:897001 blocked for more than 122 seconds.
[17940.994463]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[17941.000626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[17941.006941] task:txg_sync        state:D stack:    0 pid:897001 ppid:   =
  2
flags:0x00004004
[17941.013462] Call Trace:
[17941.019812]  __schedule+0x396/0x8a0
[17941.026154]  schedule+0x3c/0xa0
[17941.032430]  schedule_timeout+0x197/0x2b0
[17941.038665]  ? timer_update_keys+0x30/0x30
[17941.044893]  io_schedule_timeout+0x19/0x40
[17941.051104]  __cv_timedwait_common+0x12b/0x160 [spl]
[17941.057261]  ? wait_woken+0x80/0x80
[17941.063275]  __cv_timedwait_io+0x15/0x20 [spl]
[17941.069174]  zio_wait+0x129/0x2b0 [zfs]
[17941.075005]  dsl_pool_sync+0xd0/0x470 [zfs]
[17941.080690]  ? spa_errlog_sync+0x25c/0x2b0 [zfs]
[17941.086450]  ? __kmalloc_node+0x181/0x330
[17941.092137]  spa_sync_iterate_to_convergence+0xf0/0x250 [zfs]
[17941.098102]  spa_sync+0x389/0x690 [zfs]
[17941.103993]  txg_sync_thread+0x270/0x2f0 [zfs]
[17941.109957]  ? txg_dispatch_callbacks+0x120/0x120 [zfs]
[17941.115964]  ? __thread_exit+0x20/0x20 [spl]
[17941.121841]  thread_generic_wrapper+0x6c/0x80 [spl]
[17941.127779]  kthread+0x118/0x140
[17941.133647]  ? set_kthread_struct+0x40/0x40
[17941.139561]  ret_from_fork+0x1f/0x30
[root@vm2 parameters]# cat /proc/locks
1: POSIX  ADVISORY  READ 999553 00:31:55 201 201
2: POSIX  ADVISORY  READ 999553 00:31:55 100 101
3: DELEG  ACTIVE    READ 999553 00:31:189 0 EOF
4: FLOCK  ADVISORY  WRITE 999321 00:18:3499 0 EOF
5: POSIX  ADVISORY  WRITE 949090 00:18:3395 0 EOF
6: POSIX  ADVISORY  WRITE 949090 00:18:3394 0 EOF
7: POSIX  ADVISORY  WRITE 948911 00:18:3322 0 EOF
8: DELEG  ACTIVE    READ 999553 00:31:55 0 EOF
9: POSIX  ADVISORY  WRITE 999305 00:18:3511 0 EOF



```

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
