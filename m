From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] New: list_del corruption in sd driver since 2.6.39-rc4
Date: Thu, 21 Apr 2011 21:10:52 GMT
Message-ID: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39457 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1DUVKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2011 17:10:52 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3LLAqo2003792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2011 21:10:52 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802

           Summary: list_del corruption in sd driver since 2.6.39-rc4
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.39-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: casteyde.christian@free.fr
        Regression: Yes


Acer Aspire 1511LMi
Athlon 64 3GHz in 64bits mode
Slackware64 13.1
PREEMPT+slub+kmemcheck

I've just got (once, very difficult to reproduce) the following warning at boot
on -rc4 with kmemcheck and list check debugging options:

Intel ICH 0000:00:06.0: PCI INT A -> Link[LACI] -> GSI 22 (level, low) -> IRQ
22
Intel ICH 0000:00:06.0: setting latency timer to 64
firewire_net: firewire0: IPv4 over FireWire on device 00c09f000019adc5
firewire_core: refreshed device fw0
scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0 ANSI: 2
intel8x0_measure_ac97_clock: measured 52049 usecs (2528 samples)
intel8x0: clocking to 47437
sd 2:0:0:0: Attached scsi generic sg2 type 0
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2c/0x30()
Hardware name: Aspire 1510  
Modules linked in:
Pid: 310, comm: kworker/0:1 Not tainted 2.6.39-rc4 #5
Call Trace:
 [<ffffffff810379ea>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81037a35>] warn_slowpath_null+0x15/0x20
 [<ffffffff8125bffc>] kref_get+0x2c/0x30
 [<ffffffff8125ac9a>] kobject_get+0x1a/0x30
 [<ffffffff812ec704>] get_device+0x14/0x20
 [<ffffffff81307a47>] scsi_request_fn+0x37/0x4e0
 [<ffffffff812470d0>] __blk_run_queue+0x30/0x60
 [<ffffffff81248f14>] blk_delay_work+0x24/0x40
 [<ffffffff810507d1>] process_one_work+0x1a1/0x440
 [<ffffffff81050771>] ? process_one_work+0x141/0x440
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff81248ef0>] ? blk_requeue_request+0x60/0x60
 [<ffffffff81050f15>] worker_thread+0x2a5/0x380
 [<ffffffff81050c70>] ? rescuer_thread+0x200/0x200
 [<ffffffff810550be>] kthread+0xae/0xc0
 [<ffffffff81067675>] ? trace_hardirqs_on_caller+0x135/0x180
 [<ffffffff815e8a34>] kernel_thread_helper+0x4/0x10
 [<ffffffff810335ec>] ? T.1044+0x7c/0xd0
 [<ffffffff815e7682>] ? retint_restore_args+0xe/0xe
 [<ffffffff81055010>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e8a30>] ? gs_change+0xb/0xb
---[ end trace cee58f33c54e791a ]---
sd 2:0:0:0: [sdb] Attached SCSI removable disk
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: Aspire 1510  
list_del corruption, ffff88001d73a010->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 310, comm: kworker/0:1 Tainted: G        W   2.6.39-rc4 #5
Call Trace:
 [<ffffffff810379ea>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81037ac1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81269b83>] __list_del_entry+0x63/0xd0
 [<ffffffff81269c01>] list_del+0x11/0x40
 [<ffffffff8130ce4d>] scsi_device_dev_release_usercontext+0x4d/0x140
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff8130ce00>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810504e6>] execute_in_process_context+0x86/0x90
 [<ffffffff8130cdd7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff812ecdf2>] device_release+0x22/0x90
 [<ffffffff8125ac37>] kobject_release+0x47/0x90
 [<ffffffff8125abf0>] ? kobject_del+0x40/0x40
 [<ffffffff8125bf96>] kref_put+0x36/0x70
 [<ffffffff8125aaf7>] kobject_put+0x27/0x60
 [<ffffffff812ec732>] put_device+0x12/0x20
 [<ffffffff81307ab8>] scsi_request_fn+0xa8/0x4e0
 [<ffffffff812470d0>] __blk_run_queue+0x30/0x60
 [<ffffffff81248f14>] blk_delay_work+0x24/0x40
 [<ffffffff810507d1>] process_one_work+0x1a1/0x440
 [<ffffffff81050771>] ? process_one_work+0x141/0x440
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff81248ef0>] ? blk_requeue_request+0x60/0x60
 [<ffffffff81050f15>] worker_thread+0x2a5/0x380
 [<ffffffff81050c70>] ? rescuer_thread+0x200/0x200
 [<ffffffff810550be>] kthread+0xae/0xc0
 [<ffffffff81067675>] ? trace_hardirqs_on_caller+0x135/0x180
 [<ffffffff815e8a34>] kernel_thread_helper+0x4/0x10
 [<ffffffff810335ec>] ? T.1044+0x7c/0xd0
 [<ffffffff815e7682>] ? retint_restore_args+0xe/0xe
 [<ffffffff81055010>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e8a30>] ? gs_change+0xb/0xb
---[ end trace cee58f33c54e791b ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: Aspire 1510  
list_del corruption, ffff88001d73a020->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 310, comm: kworker/0:1 Tainted: G        W   2.6.39-rc4 #5
Call Trace:
 [<ffffffff810379ea>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81037ac1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81269b83>] __list_del_entry+0x63/0xd0
 [<ffffffff81269c01>] list_del+0x11/0x40
 [<ffffffff8130ce57>] scsi_device_dev_release_usercontext+0x57/0x140
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff8130ce00>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810504e6>] execute_in_process_context+0x86/0x90
 [<ffffffff8130cdd7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff812ecdf2>] device_release+0x22/0x90
 [<ffffffff8125ac37>] kobject_release+0x47/0x90
 [<ffffffff8125abf0>] ? kobject_del+0x40/0x40
 [<ffffffff8125bf96>] kref_put+0x36/0x70
 [<ffffffff8125aaf7>] kobject_put+0x27/0x60
 [<ffffffff812ec732>] put_device+0x12/0x20
 [<ffffffff81307ab8>] scsi_request_fn+0xa8/0x4e0
 [<ffffffff812470d0>] __blk_run_queue+0x30/0x60
 [<ffffffff81248f14>] blk_delay_work+0x24/0x40
 [<ffffffff810507d1>] process_one_work+0x1a1/0x440
 [<ffffffff81050771>] ? process_one_work+0x141/0x440
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff81248ef0>] ? blk_requeue_request+0x60/0x60
 [<ffffffff81050f15>] worker_thread+0x2a5/0x380
 [<ffffffff81050c70>] ? rescuer_thread+0x200/0x200
 [<ffffffff810550be>] kthread+0xae/0xc0
 [<ffffffff81067675>] ? trace_hardirqs_on_caller+0x135/0x180
 [<ffffffff815e8a34>] kernel_thread_helper+0x4/0x10
 [<ffffffff810335ec>] ? T.1044+0x7c/0xd0
 [<ffffffff815e7682>] ? retint_restore_args+0xe/0xe
 [<ffffffff81055010>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e8a30>] ? gs_change+0xb/0xb
---[ end trace cee58f33c54e791c ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: Aspire 1510  
list_del corruption, ffff88001d73a080->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 310, comm: kworker/0:1 Tainted: G        W   2.6.39-rc4 #5
Call Trace:
 [<ffffffff810379ea>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81037ac1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81269b83>] __list_del_entry+0x63/0xd0
 [<ffffffff81269c01>] list_del+0x11/0x40
 [<ffffffff8130ce64>] scsi_device_dev_release_usercontext+0x64/0x140
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff8130ce00>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810504e6>] execute_in_process_context+0x86/0x90
 [<ffffffff8130cdd7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff812ecdf2>] device_release+0x22/0x90
 [<ffffffff8125ac37>] kobject_release+0x47/0x90
 [<ffffffff8125abf0>] ? kobject_del+0x40/0x40
 [<ffffffff8125bf96>] kref_put+0x36/0x70
 [<ffffffff8125aaf7>] kobject_put+0x27/0x60
 [<ffffffff812ec732>] put_device+0x12/0x20
 [<ffffffff81307ab8>] scsi_request_fn+0xa8/0x4e0
 [<ffffffff812470d0>] __blk_run_queue+0x30/0x60
 [<ffffffff81248f14>] blk_delay_work+0x24/0x40
 [<ffffffff810507d1>] process_one_work+0x1a1/0x440
 [<ffffffff81050771>] ? process_one_work+0x141/0x440
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff81248ef0>] ? blk_requeue_request+0x60/0x60
 [<ffffffff81050f15>] worker_thread+0x2a5/0x380
 [<ffffffff81050c70>] ? rescuer_thread+0x200/0x200
 [<ffffffff810550be>] kthread+0xae/0xc0
 [<ffffffff81067675>] ? trace_hardirqs_on_caller+0x135/0x180
 [<ffffffff815e8a34>] kernel_thread_helper+0x4/0x10
 [<ffffffff810335ec>] ? T.1044+0x7c/0xd0
 [<ffffffff815e7682>] ? retint_restore_args+0xe/0xe
 [<ffffffff81055010>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e8a30>] ? gs_change+0xb/0xb
---[ end trace cee58f33c54e791d ]---

=============================================
[ INFO: possible recursive locking detected ]
2.6.39-rc4 #5
---------------------------------------------
kworker/0:1/310 is trying to acquire lock:
 ((&(&q->delay_work)->work)){+.+...}, at: [<ffffffff8104f540>]
wait_on_work+0x0/0x90

but task is already holding lock:
 ((&(&q->delay_work)->work)){+.+...}, at: [<ffffffff81050771>]
process_one_work+0x141/0x440

other info that might help us debug this:
2 locks held by kworker/0:1/310:
 #0:  (kblockd){.+.+..}, at: [<ffffffff81050771>] process_one_work+0x141/0x440
 #1:  ((&(&q->delay_work)->work)){+.+...}, at: [<ffffffff81050771>]
process_one_work+0x141/0x440

stack backtrace:
Pid: 310, comm: kworker/0:1 Tainted: G        W   2.6.39-rc4 #5
Call Trace:
 [<ffffffff8106a19b>] __lock_acquire+0x151b/0x1c60
 [<ffffffff8126418d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8126418d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8106a939>] lock_acquire+0x59/0x70
 [<ffffffff8104f540>] ? wait_on_cpu_work+0xd0/0xd0
 [<ffffffff8104f584>] wait_on_work+0x44/0x90
 [<ffffffff8104f540>] ? wait_on_cpu_work+0xd0/0xd0
 [<ffffffff815e7206>] ? _raw_spin_unlock_irq+0x36/0x60
 [<ffffffff8104f6b9>] __cancel_work_timer+0xe9/0x1a0
 [<ffffffff8104f77d>] cancel_delayed_work_sync+0xd/0x10
 [<ffffffff81249514>] blk_sync_queue+0x24/0x30
 [<ffffffff81249536>] blk_cleanup_queue+0x16/0x60
 [<ffffffff81307859>] scsi_free_queue+0x9/0x10
 [<ffffffff8130ceeb>] scsi_device_dev_release_usercontext+0xeb/0x140
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff8130ce00>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810504e6>] execute_in_process_context+0x86/0x90
 [<ffffffff8130cdd7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff812ecdf2>] device_release+0x22/0x90
 [<ffffffff8125ac37>] kobject_release+0x47/0x90
 [<ffffffff8125abf0>] ? kobject_del+0x40/0x40
 [<ffffffff8125bf96>] kref_put+0x36/0x70
 [<ffffffff8125aaf7>] kobject_put+0x27/0x60
 [<ffffffff812ec732>] put_device+0x12/0x20
 [<ffffffff81307ab8>] scsi_request_fn+0xa8/0x4e0
 [<ffffffff812470d0>] __blk_run_queue+0x30/0x60
 [<ffffffff81248f14>] blk_delay_work+0x24/0x40
 [<ffffffff810507d1>] process_one_work+0x1a1/0x440
 [<ffffffff81050771>] ? process_one_work+0x141/0x440
 [<ffffffff815e7ae9>] ? error_exit+0x29/0xb0
 [<ffffffff81248ef0>] ? blk_requeue_request+0x60/0x60
 [<ffffffff81050f15>] worker_thread+0x2a5/0x380
 [<ffffffff81050c70>] ? rescuer_thread+0x200/0x200
 [<ffffffff810550be>] kthread+0xae/0xc0
 [<ffffffff81067675>] ? trace_hardirqs_on_caller+0x135/0x180
 [<ffffffff815e8a34>] kernel_thread_helper+0x4/0x10
 [<ffffffff810335ec>] ? T.1044+0x7c/0xd0
 [<ffffffff815e7682>] ? retint_restore_args+0xe/0xe
 [<ffffffff81055010>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e8a30>] ? gs_change+0xb/0xb
Intel ICH Modem 0000:00:06.1: PCI INT B -> Link[LMCI] -> GSI 21 (level, low) ->
IRQ 21
Intel ICH Modem 0000:00:06.1: setting latency timer to 64
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: NVidia nForce3 with ALC250 at irq 22
  #1: NVidia nForce3 Modem at irq 21
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (3843 buckets, 15372 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
