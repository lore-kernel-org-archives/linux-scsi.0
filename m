From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.2.0-rc3-next-20111128 lockdep splat during boot..
Date: Thu, 1 Dec 2011 00:17:18 +0100
Message-ID: <201112010017.19156.rjw@sisk.pl>
References: <23526.1322620187@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <23526.1322620187@turing-police.cc.vt.edu>
Sender: linux-acpi-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday, November 30, 2011, Valdis.Kletnieks@vt.edu wrote:
> Seen this twice out of two boots while initrd was waiting for me to
> enter the passphrase for encrypted LVM.  No idea *who* to toss this
> one at - got ACPI, PM, SCSI and vtconsole all listed in tracebacks, so
> I'm tossing this at everybody and hope it sticks. ;)

This was caused by one of my patches in linux-next and was linux-next-only.

I've already replaced the offending patch with a new version.

Thanks,
Rafael


> [   14.708463] 
> [   14.708747] =========================================================
> [   14.709229] [ INFO: possible irq lock inversion dependency detected ]
> [   14.709229] 3.2.0-rc3-next-20111128 #41
> [   14.709229] ---------------------------------------------------------
> [   14.709229] ksoftirqd/0/3 just changed the state of lock:
> [   14.709229]  (&(&dev->power.lock)->rlock){..-...}, at: [<ffffffff812f0cea>] pm_suspend_timer_fn+0x1d/0x72
> [   14.709229] but this lock took another, SOFTIRQ-unsafe lock in the past:
> [   14.709229]  (&(&k->k_lock)->rlock){+.+...}
> [   14.709229] 
> [   14.709229] and interrupts could create inverse lock ordering between them.
> [   14.709229] 
> [   14.709229] 
> [   14.709229] other info that might help us debug this:
> [   14.709229]  Possible interrupt unsafe locking scenario:
> [   14.709229] 
> [   14.709229]        CPU0                    CPU1
> [   14.709229]        ----                    ----
> [   14.709229]   lock(&(&k->k_lock)->rlock);
> [   14.709229]                                local_irq_disable();
> [   14.709229]                                lock(&(&dev->power.lock)->rlock);
> [   14.709229]                                lock(&(&k->k_lock)->rlock);
> [   14.709229]   <Interrupt>
> [   14.709229]     lock(&(&dev->power.lock)->rlock);
> [   14.709229] 
> [   14.709229]  *** DEADLOCK ***
> [   14.709229] 
> [   14.709229] 1 lock held by ksoftirqd/0/3:
> [   14.709229]  #0:  (&dev->power.suspend_timer){+.-...}, at: [<ffffffff81048e30>] call_timer_fn+0x0/0x1f7
> [   14.709229] 
> [   14.709229] the shortest dependencies between 2nd lock and 1st lock:
> [   14.709229]  -> (&(&k->k_lock)->rlock){+.+...} ops: 7510 {
> [   14.709229]     HARDIRQ-ON-W at:
> [   14.709229]                                          [<ffffffff8106c4c9>] mark_irqflags+0xd2/0x13e
> [   14.709229]                                          [<ffffffff8106c760>] __lock_acquire+0x22b/0x3e2
> [   14.709229]                                          [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   14.709229]                                          [<ffffffff815b9b41>] _raw_spin_lock+0x36/0x45
> [   14.709229]                                          [<ffffffff81587e52>] klist_add_tail+0x20/0x3f
> [   14.709229]                                          [<ffffffff812ea646>] device_add+0x23e/0x336
> [   14.709229]                                          [<ffffffff812ea755>] device_register+0x17/0x1c
> [   14.709229]                                          [<ffffffff812ea80c>] device_create_vargs+0xb2/0xea
> [   14.709229]                                          [<ffffffff812ea870>] device_create+0x2c/0x2e
> [   14.709229]                                          [<ffffffff81b40717>] vtconsole_class_init+0x97/0xf3
> [   14.709229]                                          [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
> [   14.709229]                                          [<ffffffff81b1cbec>] kernel_init+0xcd/0x147
> [   14.709229]                                          [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   14.709229]     SOFTIRQ-ON-W at:
> [   14.709229]                                          [<ffffffff8106c4e9>] mark_irqflags+0xf2/0x13e
> [   14.709229]                                          [<ffffffff8106c760>] __lock_acquire+0x22b/0x3e2
> [   14.709229]                                          [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   14.709229]                                          [<ffffffff815b9b41>] _raw_spin_lock+0x36/0x45
> [   14.709229]                                          [<ffffffff81587e52>] klist_add_tail+0x20/0x3f
> [   14.709229]                                          [<ffffffff812ea646>] device_add+0x23e/0x336
> [   14.709229]                                          [<ffffffff812ea755>] device_register+0x17/0x1c
> [   14.709229]                                          [<ffffffff812ea80c>] device_create_vargs+0xb2/0xea
> [   14.709229]                                          [<ffffffff812ea870>] device_create+0x2c/0x2e
> [   14.709229]                                          [<ffffffff81b40717>] vtconsole_class_init+0x97/0xf3
> [   14.709229]                                          [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
> [   14.709229]                                          [<ffffffff81b1cbec>] kernel_init+0xcd/0x147
> [   14.709229]                                          [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   14.709229]     INITIAL USE at:
> [   14.709229]                                         [<ffffffff8106c77f>] __lock_acquire+0x24a/0x3e2
> [   14.709229]                                         [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   14.709229]                                         [<ffffffff815b9b41>] _raw_spin_lock+0x36/0x45
> [   14.709229]                                         [<ffffffff81587e52>] klist_add_tail+0x20/0x3f
> [   14.709229]                                         [<ffffffff812ea646>] device_add+0x23e/0x336
> [   14.709229]                                         [<ffffffff812ea755>] device_register+0x17/0x1c
> [   14.709229]                                         [<ffffffff812ea80c>] device_create_vargs+0xb2/0xea
> [   14.709229]                                         [<ffffffff812ea870>] device_create+0x2c/0x2e
> [   14.709229]                                         [<ffffffff81b40717>] vtconsole_class_init+0x97/0xf3
> [   14.709229]                                         [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
> [   14.709229]                                         [<ffffffff81b1cbec>] kernel_init+0xcd/0x147
> [   14.709229]                                         [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   14.709229]   }
> [   14.709229]   ... key      at: [<ffffffff8246d980>] __key.16100+0x0/0x680
> [   14.709229]   ... acquired at:
> [   14.709229]    [<ffffffff8106bdfa>] check_prevs_add+0x8b/0x104
> [   15.001689]    [<ffffffff8106c1d4>] validate_chain+0x361/0x39d
> [   15.001689]    [<ffffffff8106c89e>] __lock_acquire+0x369/0x3e2
> [   15.001689]    [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   15.001689]    [<ffffffff815b9b41>] _raw_spin_lock+0x36/0x45
> [   15.001689]    [<ffffffff81587a6d>] klist_next+0x21/0xd2
> [   15.001689]    [<ffffffff812e94fb>] device_for_each_child+0x40/0x6a
> [   15.001689]    [<ffffffff812f0a52>] rpm_suspend+0x27d/0x4f8
> [   15.001689]    [<ffffffff812f18ba>] __pm_runtime_suspend+0x6c/0x89
> [   15.001689]    [<ffffffff81304389>] scsi_runtime_idle+0x2b/0x2f
> [   15.001689]    [<ffffffff812f0349>] __rpm_callback+0x2f/0x56
> [   15.001689]    [<ffffffff812f0eb3>] rpm_idle+0x174/0x1db
> [   15.001689]    [<ffffffff812f0fdd>] __pm_runtime_idle+0x6d/0x8a
> [   15.001689]    [<ffffffff813044c2>] scsi_autopm_put_host+0x15/0x17
> [   15.001689]    [<ffffffff812fcd22>] scsi_error_handler+0xb2/0x100
> [   15.001689]    [<ffffffff8105965e>] kthread+0x7f/0x87
> [   15.001689]    [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   15.001689] 
> [   15.001689] -> (&(&dev->power.lock)->rlock){..-...} ops: 738 {
> [   15.001689]    IN-SOFTIRQ-W at:
> [   15.001689]                                        [<ffffffff8106c479>] mark_irqflags+0x82/0x13e
> [   15.001689]                                        [<ffffffff8106c760>] __lock_acquire+0x22b/0x3e2
> [   15.001689]                                        [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   15.001689]                                        [<ffffffff815b9c3a>] _raw_spin_lock_irqsave+0x44/0x57
> [   15.001689]                                        [<ffffffff812f0cea>] pm_suspend_timer_fn+0x1d/0x72
> [   15.001689]                                        [<ffffffff81048ee3>] call_timer_fn+0xb3/0x1f7
> [   15.001689]                                        [<ffffffff810491d1>] run_timer_softirq+0x1aa/0x1f2
> [   15.001689]                                        [<ffffffff81041da8>] __do_softirq+0x110/0x278
> [   15.001689]                                        [<ffffffff81041fe0>] run_ksoftirqd+0xd0/0x20e
> [   15.001689]                                        [<ffffffff8105965e>] kthread+0x7f/0x87
> [   15.001689]                                        [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   15.001689]    INITIAL USE at:
> [   15.001689]                                       [<ffffffff8106c77f>] __lock_acquire+0x24a/0x3e2
> [   15.001689]                                       [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   15.001689]                                       [<ffffffff815b9c3a>] _raw_spin_lock_irqsave+0x44/0x57
> [   15.001689]                                       [<ffffffff812f0fcf>] __pm_runtime_idle+0x5f/0x8a
> [   15.001689]                                       [<ffffffff812ec6cf>] device_attach+0x88/0x9c
> [   15.001689]                                       [<ffffffff812ebe27>] bus_probe_device+0x24/0x62
> [   15.001689]                                       [<ffffffff812ea5f3>] device_add+0x1eb/0x336
> [   15.001689]                                       [<ffffffff812ea755>] device_register+0x17/0x1c
> [   15.001689]                                       [<ffffffff8127917f>] acpi_device_register+0x150/0x221
> [   15.001689]                                       [<ffffffff81279412>] acpi_add_single_object+0x1c2/0x226
> [   15.001689]                                       [<ffffffff81279514>] acpi_bus_check_add+0x9e/0xe6
> [   15.001689]                                       [<ffffffff8127958f>] acpi_bus_scan+0x33/0x77
> [   15.001689]                                       [<ffffffff81b3e736>] acpi_scan_init+0x4b/0xce
> [   15.001689]                                       [<ffffffff81b3e59c>] acpi_init+0x9e/0xb4
> [   15.001689]                                       [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
> [   15.001689]                                       [<ffffffff81b1cbec>] kernel_init+0xcd/0x147
> [   15.001689]                                       [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   15.001689]  }
> [   15.001689]  ... key      at: [<ffffffff8245b100>] __key.18419+0x0/0x8
> [   15.001689]  ... acquired at:
> [   15.001689]    [<ffffffff8106b67a>] check_usage_forwards+0x95/0xa6
> [   15.001689]    [<ffffffff815984de>] mark_lock_irq+0x94/0x120
> [   15.001689]    [<ffffffff8106c384>] mark_lock+0xaf/0x122
> [   15.001689]    [<ffffffff8106c479>] mark_irqflags+0x82/0x13e
> [   15.001689]    [<ffffffff8106c760>] __lock_acquire+0x22b/0x3e2
> [   15.001689]    [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   15.001689]    [<ffffffff815b9c3a>] _raw_spin_lock_irqsave+0x44/0x57
> [   15.001689]    [<ffffffff812f0cea>] pm_suspend_timer_fn+0x1d/0x72
> [   15.001689]    [<ffffffff81048ee3>] call_timer_fn+0xb3/0x1f7
> [   15.001689]    [<ffffffff810491d1>] run_timer_softirq+0x1aa/0x1f2
> [   15.001689]    [<ffffffff81041da8>] __do_softirq+0x110/0x278
> [   15.001689]    [<ffffffff81041fe0>] run_ksoftirqd+0xd0/0x20e
> [   15.001689]    [<ffffffff8105965e>] kthread+0x7f/0x87
> [   15.001689]    [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   15.001689] 
> [   15.001689] 
> [   15.001689] stack backtrace:
> [   15.001689] Pid: 3, comm: ksoftirqd/0 Not tainted 3.2.0-rc3-next-20111128 #41
> [   15.001689] Call Trace:
> [   15.001689]  [<ffffffff8106b5d6>] print_irq_inversion_bug.part.16+0x19f/0x1ae
> [   15.001689]  [<ffffffff8106b67a>] check_usage_forwards+0x95/0xa6
> [   15.001689]  [<ffffffff8100366d>] ? dump_trace+0x201/0x219
> [   15.001689]  [<ffffffff8106b5e5>] ? print_irq_inversion_bug.part.16+0x1ae/0x1ae
> [   15.001689]  [<ffffffff815984de>] mark_lock_irq+0x94/0x120
> [   15.001689]  [<ffffffff8106c384>] mark_lock+0xaf/0x122
> [   15.001689]  [<ffffffff8106c479>] mark_irqflags+0x82/0x13e
> [   15.001689]  [<ffffffff8106c760>] __lock_acquire+0x22b/0x3e2
> [   15.001689]  [<ffffffff812f0cea>] ? pm_suspend_timer_fn+0x1d/0x72
> [   15.001689]  [<ffffffff8106ce4d>] lock_acquire+0x103/0x153
> [   15.001689]  [<ffffffff812f0cea>] ? pm_suspend_timer_fn+0x1d/0x72
> [   15.001689]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   15.001689]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   15.001689]  [<ffffffff815b9c3a>] _raw_spin_lock_irqsave+0x44/0x57
> [   15.001689]  [<ffffffff812f0cea>] ? pm_suspend_timer_fn+0x1d/0x72
> [   18.416714]  [<ffffffff810491d9>] ? run_timer_softirq+0x1b2/0x1f2
> [   18.416714]  [<ffffffff812f0cea>] pm_suspend_timer_fn+0x1d/0x72
> [   18.416714]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   18.416714]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   18.416714]  [<ffffffff81048ee3>] call_timer_fn+0xb3/0x1f7
> [   18.416714]  [<ffffffff81048e30>] ? del_timer+0x75/0x75
> [   18.416714]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   18.416714]  [<ffffffff812f0ccd>] ? rpm_suspend+0x4f8/0x4f8
> [   18.416714]  [<ffffffff810491d1>] run_timer_softirq+0x1aa/0x1f2
> [   18.416714]  [<ffffffff81041da8>] __do_softirq+0x110/0x278
> [   18.416714]  [<ffffffff81041fe0>] run_ksoftirqd+0xd0/0x20e
> [   18.416714]  [<ffffffff81041f10>] ? __do_softirq+0x278/0x278
> [   18.416714]  [<ffffffff8105965e>] kthread+0x7f/0x87
> [   18.416714]  [<ffffffff815c1bf4>] kernel_thread_helper+0x4/0x10
> [   18.416714]  [<ffffffff815ba7e1>] ? retint_restore_args+0xe/0xe
> [   18.416714]  [<ffffffff810595df>] ? __init_kthread_worker+0x55/0x55
> [   18.416714]  [<ffffffff815c1bf0>] ? gs_change+0xb/0xb
> 
> 

