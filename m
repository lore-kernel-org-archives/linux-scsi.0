From: Andrey Konovalov <andreyknvl@google.com>
Subject: Use-after-free in kobject_put (scsi_host_dev_release)
Date: Fri, 11 Sep 2015 13:43:19 +0200
Message-ID: <CAAeHK+y-Sr=Yqsyn=kxsVqn0m6vqstqmqqgQ1bK1QxuhSL8ZUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, Kostya Serebryany <kcc@google.com>
List-Id: linux-scsi@vger.kernel.org

Hi!

While fuzzing the kernel (b8889c4fc6) with KASAN and Trinity I got the
following report:
(There are a few similar reports after this one, look here:
https://gist.github.com/xairy/82746e5a5876d398a88c)

==================================================================
BUG: KASAN: use-after-free in kobject_put+0x8e/0xa0 at addr ffff88003465b264
Read of size 1 by task trinity-main/12835
page:ffffea0000d196c0 count:0 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000000()
page dumped because: kasan: bad access detected
CPU: 2 PID: 12835 Comm: trinity-main Not tainted 4.2.0-kasan #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 ffff88003465b218 ffff8800337bf7b8 ffffffff819e0c85 ffff8800337bf838
 ffff8800337bf828 ffffffff8142f6cb ffff8800345d65c0 ffff8800337bf800
 0000000000000292 ffff88003467fc80 ffffffff82d690af ffff8800345d65c0
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff819e0c85>] dump_stack+0x44/0x5f lib/dump_stack.c:50
 [<     inline     >] print_address_description mm/kasan/report.c:147
 [<ffffffff8142f6cb>] kasan_report_error+0x46b/0x4a0 mm/kasan/report.c:225
 [<ffffffff82d690af>] ? mutex_lock+0xf/0x50 kernel/locking/mutex.c:97
 [<     inline     >] kasan_report mm/kasan/report.c:246
 [<ffffffff8142f73e>] __asan_report_load1_noabort+0x3e/0x40
mm/kasan/report.c:264
 [<ffffffff819e641e>] ? kobject_put+0x8e/0xa0 lib/kobject.c:671
 [<ffffffff819e641e>] kobject_put+0x8e/0xa0 lib/kobject.c:671
 [<ffffffff81ffa912>] put_device+0x12/0x20 drivers/base/core.c:1215
 [<ffffffff8207bcfd>] scsi_host_dev_release+0x25d/0x330 drivers/scsi/hosts.c:341
 [<ffffffff81ffa2b1>] device_release+0x71/0x1e0 drivers/base/core.c:247
 [<     inline     >] kobject_cleanup lib/kobject.c:629
 [<ffffffff819e6761>] kobject_release+0xc1/0x160 lib/kobject.c:658
 [<     inline     >] kref_put include/linux/kref.h:74
 [<ffffffff819e63de>] kobject_put+0x4e/0xa0 lib/kobject.c:675
 [<ffffffff81ffa912>] put_device+0x12/0x20 drivers/base/core.c:1215
 [<ffffffff820992a5>] scsi_target_dev_release+0x35/0x50
drivers/scsi/scsi_scan.c:333
 [<ffffffff81ffa2b1>] device_release+0x71/0x1e0 drivers/base/core.c:247
 [<     inline     >] kobject_cleanup lib/kobject.c:629
 [<ffffffff819e6761>] kobject_release+0xc1/0x160 lib/kobject.c:658
 [<     inline     >] kref_put include/linux/kref.h:74
 [<ffffffff819e63de>] kobject_put+0x4e/0xa0 lib/kobject.c:675
 [<ffffffff81ffa912>] put_device+0x12/0x20 drivers/base/core.c:1215
 [<ffffffff820a1245>] scsi_device_dev_release_usercontext+0x515/0x730
drivers/scsi/scsi_sysfs.c:430
 [<ffffffff820a0d30>] ? scsi_device_dev_release+0x20/0x20
drivers/scsi/scsi_sysfs.c:438
 [<ffffffff81139615>] execute_in_process_context+0xd5/0x130
kernel/workqueue.c:2969
 [<ffffffff820a0d27>] scsi_device_dev_release+0x17/0x20
drivers/scsi/scsi_sysfs.c:436
 [<ffffffff81ffa2b1>] device_release+0x71/0x1e0 drivers/base/core.c:247
 [<     inline     >] kobject_cleanup lib/kobject.c:629
 [<ffffffff819e6761>] kobject_release+0xc1/0x160 lib/kobject.c:658
 [<     inline     >] kref_put include/linux/kref.h:74
 [<ffffffff819e63de>] kobject_put+0x4e/0xa0 lib/kobject.c:675
 [<ffffffff81ffa912>] put_device+0x12/0x20 drivers/base/core.c:1215
 [<ffffffff820750e7>] scsi_device_put+0x77/0xa0 drivers/scsi/scsi.c:961
 [<ffffffff820cb7ee>] scsi_cd_put+0x4e/0x70 drivers/scsi/sr.c:181
 [<ffffffff820cb862>] sr_block_release+0x52/0x70 drivers/scsi/sr.c:538
 [<ffffffff814e1b6c>] __blkdev_put+0x52c/0x6d0 fs/block_dev.c:1504
 [<ffffffff814e2a41>] blkdev_put+0x71/0x3a0 fs/block_dev.c:1569
 [<     inline     >] ? spin_lock include/linux/spinlock.h:302 (discriminator 1)
 [<ffffffff81a11be8>] ? lockref_put_or_lock+0x78/0x100
lib/lockref.c:142 (discriminator 1)
 [<ffffffff814e2df8>] blkdev_close+0x88/0xd0 fs/block_dev.c:1576
 [<ffffffff81442c94>] __fput+0x1f4/0x6b0 fs/file_table.c:208
 [<ffffffff814431b9>] ____fput+0x9/0x10 fs/file_table.c:244
 [<ffffffff811434ee>] task_work_run+0x12e/0x1e0 kernel/task_work.c:115
(discriminator 1)
 [<ffffffff814d1427>] ? free_fs_struct+0x47/0x60 fs/fs_struct.c:90
 [<     inline     >] ? spin_lock include/linux/spinlock.h:302
 [<     inline     >] ? task_lock include/linux/sched.h:2716
 [<ffffffff8114a0c5>] ? switch_task_namespaces+0x25/0xc0 kernel/nsproxy.c:207
 [<     inline     >] exit_task_work include/linux/task_work.h:21
 [<ffffffff810f45b5>] do_exit+0x955/0x2cf0 kernel/exit.c:746
 [<ffffffff810faf1e>] ? do_wait+0x33e/0x720 kernel/exit.c:1512
 [<ffffffff810f3c60>] ? release_task+0x14c0/0x14c0 include/linux/list.h:189
 [<ffffffff8143df57>] ? rw_verify_area+0xb7/0x290 fs/read_write.c:404
(discriminator 4)
 [<ffffffff813dab0d>] ? find_vma+0xdd/0x120 mm/mmap.c:2068
 [<ffffffff810cfff6>] ? __do_page_fault+0x2a6/0x780 arch/x86/mm/fault.c:1264
 [<     inline     >] ? SYSC_write fs/read_write.c:585
 [<ffffffff81441193>] ? SyS_write+0x103/0x220 fs/read_write.c:577
 [<ffffffff810fb492>] do_group_exit+0xe2/0x340 kernel/exit.c:874
 [<ffffffff810d0565>] ? trace_do_page_fault+0x65/0x1c0 arch/x86/mm/fault.c:1331
 [<     inline     >] SYSC_exit_group kernel/exit.c:885
 [<ffffffff810fb708>] SyS_exit_group+0x18/0x20 kernel/exit.c:883
 [<ffffffff82d6da6e>] entry_SYSCALL_64_fastpath+0x12/0x71
arch/x86/entry/entry_64.S:185
Memory state around the buggy address:
 ffff88003465b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88003465b180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88003465b200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                       ^
 ffff88003465b280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88003465b300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================

Thanks!
