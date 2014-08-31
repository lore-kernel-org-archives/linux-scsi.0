From: Milan Broz <gmazyland@gmail.com>
Subject: Re: scsi_debug module deadlock on 3.17-rc2
Date: Sun, 31 Aug 2014 11:49:46 +0200
Message-ID: <5402EFBA.1020708@gmail.com>
References: <54023A60.1090208@gmail.com> <54025AE1.9030406@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53809 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaHaJtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 05:49:51 -0400
In-Reply-To: <54025AE1.9030406@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 08/31/2014 01:14 AM, Douglas Gilbert wrote:
> On 14-08-30 04:56 PM, Milan Broz wrote:
>> Hi,
>>
>> I am using scsi_debug in cryptsetup testsuite and with recent 3.17-rc kernel
>> it deadlocks on rmmod of scsi_debug module.
>>
>> For me even this simple reproducer causes deadlock:
>>    modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1
>>    DEV="/dev/"$(grep -l -e scsi_debug /sys/block/*/device/model | cut -f4 -d /)
>>    mkfs -t ext4 $DEV
>>    rmmod scsi_debug
>>
>> (adding small delay before rmmod obviously helps here)
> 
> So I used this slight variation for testing:
> 
> modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1 num_parts=1
> DEV="/dev/"$(grep -l -e scsi_debug /sys/block/*/device/model | cut -f4 -d /)"1"
> echo "mkfs -t ext4 ${DEV}"
> mkfs -t ext4 ${DEV}
> sleep 0.1
> rmmod scsi_debug
> 
>> Bisect tracked it to commit
>>    commit cbf67842c3d9e7af8ccc031332b79e88d9cca592
>>    Author: Douglas Gilbert <dgilbert@interlog.com>
>>    Date:   Sat Jul 26 11:55:35 2014 -0400
>>    scsi_debug: support scsi-mq, queues and locks
>>
>> I guess that with introducing mq the del_timer_sync() must not be called
>> with acquired queued_arr_lock.
>> (to me it looks like situation described in comment before
>> del_timer_sync() in kernel/time/timer.c...)
> 
> Looks like something a lawyer would write.

:-)

...

> Anyway the attached patch removes the lock(queued_arr_lock)
> from around the del_timer calls. Could you try it and report
> back.

Yes, the patch fixes the deadlock.
Thanks!

Tested-and-reported-by: Milan Broz <gmazyland@gmail.com>

However, removing the device (rmmod scsi_debug) now take up to 20 or more seconds.
(Nothing like flush buffers or udev settle helps seems...)

It is somehow related to udev events processing (killing udev process
will remove this delay).

I have full process trace (let me know if you want to send it),
this is just where rmmod is while waiting (note the delay in the end):

[  132.918141] sd 3:0:0:0: [sdh] Attached SCSI disk
[  137.476448] SysRq : Show State
...
[  137.485711] kworker/0:2     D c16ce000     0   274      2 0x00000000
[  137.485724] Workqueue: events_freezable_power_ disk_events_workfn
[  137.485728]  dc915c2c 00000046 dc915bcc c16ce000 debad340 0000001f de15e250 c00530f0
[  137.485741]  00000002 c00530f0 00000001 c00530f0 c0053698 dc915c0c c106e934 c1465cdd
[  137.485753]  c00530f0 dc915c44 dc915c0c c128925f dc915c1c c106ea49 00000282 c1ff7d80
[  137.485765] Call Trace:
[  137.485772]  [<c106e934>] ? mark_held_locks+0x64/0x90
[  137.485779]  [<c1465cdd>] ? _raw_spin_unlock_irqrestore+0x4d/0x70
[  137.485785]  [<c128925f>] ? __this_cpu_preempt_check+0xf/0x20
[  137.485792]  [<c106ea49>] ? trace_hardirqs_on_caller+0xe9/0x220
[  137.485798]  [<c146194e>] schedule+0x1e/0x60
[  137.485804]  [<c146520f>] schedule_timeout+0x11f/0x1b0
[  137.485811]  [<c1084270>] ? internal_add_timer+0x60/0x60
[  137.485817]  [<c106ea49>] ? trace_hardirqs_on_caller+0xe9/0x220
[  137.485824]  [<c1461db6>] io_schedule_timeout+0x46/0x60
[  137.485831]  [<c146230b>] wait_for_common_io.constprop.1+0x7b/0xd0
[  137.485836]  [<c1059c60>] ? wake_up_process+0x40/0x40
[  137.485843]  [<c1462368>] wait_for_completion_io_timeout+0x8/0x10
[  137.485849]  [<c12614a1>] blk_execute_rq+0x81/0x100
[  137.485856]  [<c14622a7>] ? wait_for_common_io.constprop.1+0x17/0xd0
[  137.485863]  [<c12730f0>] ? cfq_exit_icq+0x40/0x40
[  137.485870]  [<c125a2d5>] ? elv_set_request+0x15/0x30
[  137.485877]  [<c125bd4a>] ? get_request+0x2ea/0x490
[  137.485884]  [<c1066fd0>] ? __wake_up_sync+0x10/0x10
[  137.485891]  [<c125bf59>] ? blk_get_request+0x69/0xd0
[  137.485897]  [<c13312bc>] scsi_execute+0xfc/0x190
[  137.485904]  [<c1331423>] scsi_execute_req_flags+0x53/0xb0
[  137.485912]  [<c13319be>] scsi_test_unit_ready+0x5e/0x100
[  137.485918]  [<c1349df3>] sd_check_events+0xe3/0x120
[  137.485925]  [<c12697f7>] disk_check_events+0x37/0x100
[  137.485932]  [<c12698d3>] disk_events_workfn+0x13/0x20
[  137.485939]  [<c104d096>] process_one_work+0x156/0x390
[  137.485945]  [<c104d043>] ? process_one_work+0x103/0x390
[  137.485951]  [<c104d8f9>] worker_thread+0x39/0x440
[  137.485958]  [<c104d8c0>] ? execute_in_process_context+0x70/0x70
[  137.485965]  [<c10513f3>] kthread+0xa3/0xc0
[  137.485970]  [<c106cc9d>] ? put_lock_stats.isra.21+0xd/0x30
[  137.485976]  [<c106eb8b>] ? trace_hardirqs_on+0xb/0x10
[  137.485982]  [<c14667c1>] ret_from_kernel_thread+0x21/0x30
[  137.485989]  [<c1051350>] ? kthread_create_on_node+0x160/0x160
...
[  137.493862] rmmod           D c16ce000     0  1434   1422 0x00000000
[  137.493869]  da1bbca4 00000046 deb5e050 c16ce000 199fe46e 0000001f df11c190 deb5e050
[  137.493881]  b02da1a3 da1bbcc0 c10708cb c1c0f9c8 00000004 00000000 c1c75a90 00000000
[  137.493893]  0ac0a782 b02da1a3 00000003 deb5e670 00000001 deb5e050 deb5e050 deb5e670
[  137.493905] Call Trace:
[  137.493911]  [<c10708cb>] ? __lock_acquire+0x48b/0x1c30
[  137.493917]  [<c146194e>] schedule+0x1e/0x60
[  137.493924]  [<c146523d>] schedule_timeout+0x14d/0x1b0
[  137.493930]  [<c106e934>] ? mark_held_locks+0x64/0x90
[  137.493936]  [<c1465d22>] ? _raw_spin_unlock_irq+0x22/0x50
[  137.493942]  [<c128925f>] ? __this_cpu_preempt_check+0xf/0x20
[  137.493948]  [<c106ea49>] ? trace_hardirqs_on_caller+0xe9/0x220
[  137.493954]  [<c106eb8b>] ? trace_hardirqs_on+0xb/0x10
[  137.493960]  [<c1462156>] wait_for_common+0x86/0x110
[  137.493965]  [<c1059c60>] ? wake_up_process+0x40/0x40
[  137.493971]  [<c14621f2>] wait_for_completion+0x12/0x20
[  137.493977]  [<c104c9bf>] flush_work+0x13f/0x1e0
[  137.493982]  [<c104abe0>] ? work_busy+0x80/0x80
[  137.493988]  [<c14620ea>] ? wait_for_common+0x1a/0x110
[  137.493994]  [<c104d7a7>] __cancel_work_timer+0x67/0xf0
[  137.494000]  [<c104d84d>] cancel_delayed_work_sync+0xd/0x10
[  137.494006]  [<c126ad93>] disk_block_events+0x73/0x80
[  137.494011]  [<c126ae32>] del_gendisk+0x22/0x1d0
[  137.494017]  [<c1318de1>] ? device_del+0x131/0x180
[  137.494022]  [<c134a929>] sd_remove+0x49/0xa0
[  137.494029]  [<c131bc59>] __device_release_driver+0x49/0xb0
[  137.494034]  [<c131bcda>] device_release_driver+0x1a/0x30
[  137.494040]  [<c131b7cb>] bus_remove_device+0xbb/0xf0
[  137.494045]  [<c1318d9c>] device_del+0xec/0x180
[  137.494051]  [<c1337981>] __scsi_remove_device+0xb1/0xc0
[  137.494058]  [<c13364f7>] scsi_forget_host+0x57/0x60
[  137.494064]  [<c132c75e>] scsi_remove_host+0x5e/0xf0
[  137.494074]  [<e10e4fdb>] sdebug_driver_remove+0x1b/0x80 [scsi_debug]
[  137.494081]  [<c131bc59>] __device_release_driver+0x49/0xb0
[  137.494086]  [<c131bcda>] device_release_driver+0x1a/0x30
[  137.494092]  [<c131b7cb>] bus_remove_device+0xbb/0xf0
[  137.494097]  [<c1318d9c>] device_del+0xec/0x180
[  137.494103]  [<c1318e3b>] device_unregister+0xb/0x20
[  137.494110]  [<e10e48bd>] sdebug_remove_adapter+0x4d/0x70 [scsi_debug]
[  137.494118]  [<e10e8ffd>] scsi_debug_exit+0x6e/0xac [scsi_debug]
[  137.494125]  [<c109a74d>] SyS_delete_module+0xfd/0x180
[  137.494131]  [<c14669e1>] ? restore_all+0xf/0xf
[  137.494137]  [<c128925f>] ? __this_cpu_preempt_check+0xf/0x20
[  137.494143]  [<c106ea49>] ? trace_hardirqs_on_caller+0xe9/0x220
[  137.494148]  [<c14669ae>] syscall_call+0x7/0x7
...
[  137.496322] Showing all locks held in the system:
[  137.496332] 2 locks held by kworker/0:2/274:
[  137.496334]  #0:  ("events_freezable_power_efficient"){.+.+.+}, at: [<c104d043>] process_one_work+0x103/0x390
[  137.496347]  #1:  ((&(&ev->dwork)->work)){+.+.+.}, at: [<c104d043>] process_one_work+0x103/0x390
[  137.496360] 2 locks held by agetty/1395:
[  137.496363]  #0:  (&tty->ldisc_sem){++++++}, at: [<c12d8c83>] tty_ldisc_ref_wait+0x13/0x40
[  137.496374]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<c12d6c04>] n_tty_read+0x84/0x920
[  137.496386] 3 locks held by bash/1416:
[  137.496388]  #0:  (sb_writers#5){.+.+.+}, at: [<c10f4282>] vfs_write+0x152/0x1a0
[  137.496399]  #1:  (rcu_read_lock){......}, at: [<c12dc9d0>] __handle_sysrq+0x0/0x150
[  137.496409]  #2:  (tasklist_lock){.+.+..}, at: [<c106d636>] debug_show_all_locks+0x36/0x1b0
[  137.496420] 4 locks held by rmmod/1434:
[  137.496423]  #0:  (&dev->mutex){......}, at: [<c131bcd3>] device_release_driver+0x13/0x30
[  137.496433]  #1:  (&shost->scan_mutex){+.+.+.}, at: [<c132c714>] scsi_remove_host+0x14/0xf0
[  137.496443]  #2:  (&dev->mutex){......}, at: [<c131bcd3>] device_release_driver+0x13/0x30
[  137.496453]  #3:  (&ev->block_mutex){+.+...}, at: [<c126ad42>] disk_block_events+0x22/0x80
[  137.496464] 
[  137.496467] =============================================
[  137.496467] 
[  164.035571] sd 3:0:0:0: [sdh] Synchronizing SCSI cache

Milan
