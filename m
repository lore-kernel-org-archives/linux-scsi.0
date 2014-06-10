From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 77631] New: task scsi_eh_6:537 blocked for more than 120
 seconds.
Date: Tue, 10 Jun 2014 16:50:22 +0000
Message-ID: <bug-77631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaFJQu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 12:50:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7C117202E5
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 16:50:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 25E81202E9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 16:50:23 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=77631

            Bug ID: 77631
           Summary: task scsi_eh_6:537 blocked for more than 120 seconds.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.14.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: mikhail.v.gavrilov@gmail.com
        Regression: No

Created attachment 138941
  --> https://bugzilla.kernel.org/attachment.cgi?id=138941&action=edit
kernel log

task scsi_eh_6:537 blocked for more than 120 seconds.


[  240.036323] INFO: task scsi_eh_6:537 blocked for more than 120 seconds.
[  240.036333]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  240.036337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  240.036341] scsi_eh_6       D ffff880813528000  6184   537      2 0x00000000
[  240.036355]  ffff8808027cdc50 0000000000000046 ffff88007c988000
ffff8808027cdfd8
[  240.036366]  00000000001d5800 00000000001d5800 ffff88007c988000
ffff880810ca6bf0
[  240.036375]  ffff880810ca6bf8 0000000000000246 ffff88007c988000
ffff88080c532600
[  240.036384] Call Trace:
[  240.036400]  [<ffffffff817dafe1>] schedule_preempt_disabled+0x31/0x80
[  240.036409]  [<ffffffff817dc204>] mutex_lock_nested+0x194/0x430
[  240.036434]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  240.036450]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  240.036466]  [<ffffffffa035d9b4>] device_reset+0x24/0x50 [usb_storage]
[  240.036478]  [<ffffffff81523f0a>] scsi_try_bus_device_reset+0x2a/0x50
[  240.036487]  [<ffffffff8152601f>] scsi_eh_ready_devs+0x4df/0xc20
[  240.036495]  [<ffffffff81527886>] ? scsi_eh_get_sense+0x176/0x2a0
[  240.036504]  [<ffffffff81527eec>] scsi_error_handler+0x53c/0x830
[  240.036512]  [<ffffffff815279b0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  240.036522]  [<ffffffff810c452f>] kthread+0xff/0x120
[  240.036530]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  240.036540]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  240.036547]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  240.036553] 1 lock held by scsi_eh_6/537:
[  240.036555]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035d9b4>]
device_reset+0x24/0x50 [usb_storage]
[  240.036575] INFO: task usb-storage:539 blocked for more than 120 seconds.
[  240.036579]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  240.036582] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  240.036585] usb-storage     D ffff88081351a590  5032   539      2 0x00000000
[  240.036595]  ffff8808025ebae0 0000000000000046 ffff880800c28000
ffff8808025ebfd8
[  240.036604]  00000000001d5800 00000000001d5800 ffff880800c28000
7fffffffffffffff
[  240.036612]  ffff880810ca6dd0 ffff880810ca6dc8 ffff880800c28000
0000000000000000
[  240.036621] Call Trace:
[  240.036629]  [<ffffffff817daad9>] schedule+0x29/0x70
[  240.036637]  [<ffffffff817d9a59>] schedule_timeout+0x1f9/0x350
[  240.036648]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  240.036657]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  240.036665]  [<ffffffff810fbb75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  240.036673]  [<ffffffff817dc02c>] wait_for_completion+0xfc/0x140
[  240.036684]  [<ffffffff810d9a50>] ? wake_up_state+0x20/0x20
[  240.036692]  [<ffffffff815845fd>] usb_sg_wait+0x12d/0x190
[  240.036709]  [<ffffffffa035e4db>]
usb_stor_bulk_transfer_sglist.part.4+0x8b/0xf0 [usb_storage]
[  240.036725]  [<ffffffffa035e5b1>] usb_stor_bulk_srb+0x71/0x80 [usb_storage]
[  240.036741]  [<ffffffffa035e71c>] usb_stor_Bulk_transport+0x15c/0x360
[usb_storage]
[  240.036758]  [<ffffffffa035ef9b>] usb_stor_invoke_transport+0x3b/0x570
[usb_storage]
[  240.036766]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  240.036774]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  240.036790]  [<ffffffffa035dbce>] usb_stor_transparent_scsi_command+0xe/0x10
[usb_storage]
[  240.036807]  [<ffffffffa035fe96>] usb_stor_control_thread+0x176/0x290
[usb_storage]
[  240.036824]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  240.036840]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  240.036847]  [<ffffffff810c452f>] kthread+0xff/0x120
[  240.036854]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  240.036862]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  240.036869]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  240.036873] 1 lock held by usb-storage/539:
[  240.036876]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035fdaa>]
usb_stor_control_thread+0x8a/0x290 [usb_storage]
[  359.971932] INFO: task scsi_eh_6:537 blocked for more than 120 seconds.
[  359.971935]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  359.971936] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  359.971937] scsi_eh_6       D ffff880813528000  6184   537      2 0x00000000
[  359.971941]  ffff8808027cdc50 0000000000000046 ffff88007c988000
ffff8808027cdfd8
[  359.971943]  00000000001d5800 00000000001d5800 ffff88007c988000
ffff880810ca6bf0
[  359.971946]  ffff880810ca6bf8 0000000000000246 ffff88007c988000
ffff88080c532600
[  359.971948] Call Trace:
[  359.971953]  [<ffffffff817dafe1>] schedule_preempt_disabled+0x31/0x80
[  359.971955]  [<ffffffff817dc204>] mutex_lock_nested+0x194/0x430
[  359.971961]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  359.971964]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  359.971968]  [<ffffffffa035d9b4>] device_reset+0x24/0x50 [usb_storage]
[  359.971985]  [<ffffffff81523f0a>] scsi_try_bus_device_reset+0x2a/0x50
[  359.971987]  [<ffffffff8152601f>] scsi_eh_ready_devs+0x4df/0xc20
[  359.971989]  [<ffffffff81527886>] ? scsi_eh_get_sense+0x176/0x2a0
[  359.971991]  [<ffffffff81527eec>] scsi_error_handler+0x53c/0x830
[  359.971992]  [<ffffffff815279b0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  359.971995]  [<ffffffff810c452f>] kthread+0xff/0x120
[  359.971997]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  359.971999]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  359.972001]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  359.972002] 1 lock held by scsi_eh_6/537:
[  359.972003]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035d9b4>]
device_reset+0x24/0x50 [usb_storage]
[  359.972008] INFO: task usb-storage:539 blocked for more than 120 seconds.
[  359.972009]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  359.972009] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  359.972010] usb-storage     D ffff88081351a590  5032   539      2 0x00000000
[  359.972012]  ffff8808025ebae0 0000000000000046 ffff880800c28000
ffff8808025ebfd8
[  359.972014]  00000000001d5800 00000000001d5800 ffff880800c28000
7fffffffffffffff
[  359.972016]  ffff880810ca6dd0 ffff880810ca6dc8 ffff880800c28000
0000000000000000
[  359.972018] Call Trace:
[  359.972020]  [<ffffffff817daad9>] schedule+0x29/0x70
[  359.972021]  [<ffffffff817d9a59>] schedule_timeout+0x1f9/0x350
[  359.972025]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  359.972027]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  359.972028]  [<ffffffff810fbb75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  359.972030]  [<ffffffff817dc02c>] wait_for_completion+0xfc/0x140
[  359.972033]  [<ffffffff810d9a50>] ? wake_up_state+0x20/0x20
[  359.972035]  [<ffffffff815845fd>] usb_sg_wait+0x12d/0x190
[  359.972038]  [<ffffffffa035e4db>]
usb_stor_bulk_transfer_sglist.part.4+0x8b/0xf0 [usb_storage]
[  359.972041]  [<ffffffffa035e5b1>] usb_stor_bulk_srb+0x71/0x80 [usb_storage]
[  359.972045]  [<ffffffffa035e71c>] usb_stor_Bulk_transport+0x15c/0x360
[usb_storage]
[  359.972048]  [<ffffffffa035ef9b>] usb_stor_invoke_transport+0x3b/0x570
[usb_storage]
[  359.972050]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  359.972052]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  359.972055]  [<ffffffffa035dbce>] usb_stor_transparent_scsi_command+0xe/0x10
[usb_storage]
[  359.972059]  [<ffffffffa035fe96>] usb_stor_control_thread+0x176/0x290
[usb_storage]
[  359.972062]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  359.972065]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  359.972067]  [<ffffffff810c452f>] kthread+0xff/0x120
[  359.972068]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  359.972070]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  359.972071]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  359.972072] 1 lock held by usb-storage/539:
[  359.972073]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035fdaa>]
usb_stor_control_thread+0x8a/0x290 [usb_storage]
[  479.904100] INFO: task scsi_eh_6:537 blocked for more than 120 seconds.
[  479.904111]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  479.904114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  479.904118] scsi_eh_6       D ffff880813528000  6184   537      2 0x00000000
[  479.904131]  ffff8808027cdc50 0000000000000046 ffff88007c988000
ffff8808027cdfd8
[  479.904140]  00000000001d5800 00000000001d5800 ffff88007c988000
ffff880810ca6bf0
[  479.904148]  ffff880810ca6bf8 0000000000000246 ffff88007c988000
ffff88080c532600
[  479.904156] Call Trace:
[  479.904171]  [<ffffffff817dafe1>] schedule_preempt_disabled+0x31/0x80
[  479.904179]  [<ffffffff817dc204>] mutex_lock_nested+0x194/0x430
[  479.904204]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  479.904218]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  479.904232]  [<ffffffffa035d9b4>] device_reset+0x24/0x50 [usb_storage]
[  479.904243]  [<ffffffff81523f0a>] scsi_try_bus_device_reset+0x2a/0x50
[  479.904251]  [<ffffffff8152601f>] scsi_eh_ready_devs+0x4df/0xc20
[  479.904258]  [<ffffffff81527886>] ? scsi_eh_get_sense+0x176/0x2a0
[  479.904266]  [<ffffffff81527eec>] scsi_error_handler+0x53c/0x830
[  479.904274]  [<ffffffff815279b0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  479.904282]  [<ffffffff810c452f>] kthread+0xff/0x120
[  479.904290]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  479.904299]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  479.904305]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  479.904310] 1 lock held by scsi_eh_6/537:
[  479.904312]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035d9b4>]
device_reset+0x24/0x50 [usb_storage]
[  479.904331] INFO: task usb-storage:539 blocked for more than 120 seconds.
[  479.904334]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  479.904337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  479.904340] usb-storage     D ffff88081351a590  5032   539      2 0x00000000
[  479.904348]  ffff8808025ebae0 0000000000000046 ffff880800c28000
ffff8808025ebfd8
[  479.904357]  00000000001d5800 00000000001d5800 ffff880800c28000
7fffffffffffffff
[  479.904364]  ffff880810ca6dd0 ffff880810ca6dc8 ffff880800c28000
0000000000000000
[  479.904372] Call Trace:
[  479.904379]  [<ffffffff817daad9>] schedule+0x29/0x70
[  479.904385]  [<ffffffff817d9a59>] schedule_timeout+0x1f9/0x350
[  479.904396]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  479.904404]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  479.904411]  [<ffffffff810fbb75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  479.904418]  [<ffffffff817dc02c>] wait_for_completion+0xfc/0x140
[  479.904428]  [<ffffffff810d9a50>] ? wake_up_state+0x20/0x20
[  479.904436]  [<ffffffff815845fd>] usb_sg_wait+0x12d/0x190
[  479.904451]  [<ffffffffa035e4db>]
usb_stor_bulk_transfer_sglist.part.4+0x8b/0xf0 [usb_storage]
[  479.904465]  [<ffffffffa035e5b1>] usb_stor_bulk_srb+0x71/0x80 [usb_storage]
[  479.904480]  [<ffffffffa035e71c>] usb_stor_Bulk_transport+0x15c/0x360
[usb_storage]
[  479.904495]  [<ffffffffa035ef9b>] usb_stor_invoke_transport+0x3b/0x570
[usb_storage]
[  479.904502]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  479.904509]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  479.904523]  [<ffffffffa035dbce>] usb_stor_transparent_scsi_command+0xe/0x10
[usb_storage]
[  479.904538]  [<ffffffffa035fe96>] usb_stor_control_thread+0x176/0x290
[usb_storage]
[  479.904553]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  479.904567]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  479.904573]  [<ffffffff810c452f>] kthread+0xff/0x120
[  479.904580]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  479.904588]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  479.904593]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  479.904597] 1 lock held by usb-storage/539:
[  479.904600]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035fdaa>]
usb_stor_control_thread+0x8a/0x290 [usb_storage]
[  599.833322] INFO: task scsi_eh_6:537 blocked for more than 120 seconds.
[  599.833326]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  599.833327] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  599.833328] scsi_eh_6       D ffff880813528000  6184   537      2 0x00000000
[  599.833333]  ffff8808027cdc50 0000000000000046 ffff88007c988000
ffff8808027cdfd8
[  599.833336]  00000000001d5800 00000000001d5800 ffff88007c988000
ffff880810ca6bf0
[  599.833338]  ffff880810ca6bf8 0000000000000246 ffff88007c988000
ffff88080c532600
[  599.833340] Call Trace:
[  599.833346]  [<ffffffff817dafe1>] schedule_preempt_disabled+0x31/0x80
[  599.833348]  [<ffffffff817dc204>] mutex_lock_nested+0x194/0x430
[  599.833355]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  599.833359]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  599.833363]  [<ffffffffa035d9b4>] device_reset+0x24/0x50 [usb_storage]
[  599.833367]  [<ffffffff81523f0a>] scsi_try_bus_device_reset+0x2a/0x50
[  599.833369]  [<ffffffff8152601f>] scsi_eh_ready_devs+0x4df/0xc20
[  599.833371]  [<ffffffff81527886>] ? scsi_eh_get_sense+0x176/0x2a0
[  599.833374]  [<ffffffff81527eec>] scsi_error_handler+0x53c/0x830
[  599.833376]  [<ffffffff815279b0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  599.833379]  [<ffffffff810c452f>] kthread+0xff/0x120
[  599.833381]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  599.833384]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  599.833386]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  599.833387] 1 lock held by scsi_eh_6/537:
[  599.833388]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035d9b4>]
device_reset+0x24/0x50 [usb_storage]
[  599.833394] INFO: task usb-storage:539 blocked for more than 120 seconds.
[  599.833395]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  599.833396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  599.833396] usb-storage     D ffff88081351a590  5032   539      2 0x00000000
[  599.833399]  ffff8808025ebae0 0000000000000046 ffff880800c28000
ffff8808025ebfd8
[  599.833401]  00000000001d5800 00000000001d5800 ffff880800c28000
7fffffffffffffff
[  599.833403]  ffff880810ca6dd0 ffff880810ca6dc8 ffff880800c28000
0000000000000000
[  599.833405] Call Trace:
[  599.833408]  [<ffffffff817daad9>] schedule+0x29/0x70
[  599.833410]  [<ffffffff817d9a59>] schedule_timeout+0x1f9/0x350
[  599.833413]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  599.833416]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  599.833418]  [<ffffffff810fbb75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  599.833420]  [<ffffffff817dc02c>] wait_for_completion+0xfc/0x140
[  599.833423]  [<ffffffff810d9a50>] ? wake_up_state+0x20/0x20
[  599.833425]  [<ffffffff815845fd>] usb_sg_wait+0x12d/0x190
[  599.833430]  [<ffffffffa035e4db>]
usb_stor_bulk_transfer_sglist.part.4+0x8b/0xf0 [usb_storage]
[  599.833434]  [<ffffffffa035e5b1>] usb_stor_bulk_srb+0x71/0x80 [usb_storage]
[  599.833438]  [<ffffffffa035e71c>] usb_stor_Bulk_transport+0x15c/0x360
[usb_storage]
[  599.833442]  [<ffffffffa035ef9b>] usb_stor_invoke_transport+0x3b/0x570
[usb_storage]
[  599.833444]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  599.833446]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  599.833450]  [<ffffffffa035dbce>] usb_stor_transparent_scsi_command+0xe/0x10
[usb_storage]
[  599.833453]  [<ffffffffa035fe96>] usb_stor_control_thread+0x176/0x290
[usb_storage]
[  599.833457]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  599.833461]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  599.833463]  [<ffffffff810c452f>] kthread+0xff/0x120
[  599.833465]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  599.833467]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  599.833469]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  599.833470] 1 lock held by usb-storage/539:
[  599.833471]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035fdaa>]
usb_stor_control_thread+0x8a/0x290 [usb_storage]
[  649.166883] kworker/u16:5 (114) used greatest stack depth: 1992 bytes left
[  719.763710] INFO: task scsi_eh_6:537 blocked for more than 120 seconds.
[  719.763715]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  719.763716] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  719.763718] scsi_eh_6       D ffff880813528000  6184   537      2 0x00000000
[  719.763724]  ffff8808027cdc50 0000000000000046 ffff88007c988000
ffff8808027cdfd8
[  719.763728]  00000000001d5800 00000000001d5800 ffff88007c988000
ffff880810ca6bf0
[  719.763732]  ffff880810ca6bf8 0000000000000246 ffff88007c988000
ffff88080c532600
[  719.763735] Call Trace:
[  719.763743]  [<ffffffff817dafe1>] schedule_preempt_disabled+0x31/0x80
[  719.763746]  [<ffffffff817dc204>] mutex_lock_nested+0x194/0x430
[  719.763756]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  719.763762]  [<ffffffffa035d9b4>] ? device_reset+0x24/0x50 [usb_storage]
[  719.763768]  [<ffffffffa035d9b4>] device_reset+0x24/0x50 [usb_storage]
[  719.763774]  [<ffffffff81523f0a>] scsi_try_bus_device_reset+0x2a/0x50
[  719.763777]  [<ffffffff8152601f>] scsi_eh_ready_devs+0x4df/0xc20
[  719.763780]  [<ffffffff81527886>] ? scsi_eh_get_sense+0x176/0x2a0
[  719.763784]  [<ffffffff81527eec>] scsi_error_handler+0x53c/0x830
[  719.763787]  [<ffffffff815279b0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  719.763791]  [<ffffffff810c452f>] kthread+0xff/0x120
[  719.763794]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  719.763798]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  719.763801]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  719.763803] 1 lock held by scsi_eh_6/537:
[  719.763804]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035d9b4>]
device_reset+0x24/0x50 [usb_storage]
[  719.763812] INFO: task usb-storage:539 blocked for more than 120 seconds.
[  719.763814]       Not tainted 3.14.6-200.fc20.x86_64+debug #1
[  719.763815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  719.763816] usb-storage     D ffff88081351a590  5032   539      2 0x00000000
[  719.763820]  ffff8808025ebae0 0000000000000046 ffff880800c28000
ffff8808025ebfd8
[  719.763823]  00000000001d5800 00000000001d5800 ffff880800c28000
7fffffffffffffff
[  719.763827]  ffff880810ca6dd0 ffff880810ca6dc8 ffff880800c28000
0000000000000000
[  719.763830] Call Trace:
[  719.763833]  [<ffffffff817daad9>] schedule+0x29/0x70
[  719.763836]  [<ffffffff817d9a59>] schedule_timeout+0x1f9/0x350
[  719.763841]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  719.763844]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  719.763848]  [<ffffffff810fbb75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  719.763851]  [<ffffffff817dc02c>] wait_for_completion+0xfc/0x140
[  719.763855]  [<ffffffff810d9a50>] ? wake_up_state+0x20/0x20
[  719.763859]  [<ffffffff815845fd>] usb_sg_wait+0x12d/0x190
[  719.763865]  [<ffffffffa035e4db>]
usb_stor_bulk_transfer_sglist.part.4+0x8b/0xf0 [usb_storage]
[  719.763871]  [<ffffffffa035e5b1>] usb_stor_bulk_srb+0x71/0x80 [usb_storage]
[  719.763878]  [<ffffffffa035e71c>] usb_stor_Bulk_transport+0x15c/0x360
[usb_storage]
[  719.763884]  [<ffffffffa035ef9b>] usb_stor_invoke_transport+0x3b/0x570
[usb_storage]
[  719.763887]  [<ffffffff810fb9e9>] ? mark_held_locks+0xb9/0x140
[  719.763890]  [<ffffffff817dff8c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  719.763896]  [<ffffffffa035dbce>] usb_stor_transparent_scsi_command+0xe/0x10
[usb_storage]
[  719.763903]  [<ffffffffa035fe96>] usb_stor_control_thread+0x176/0x290
[usb_storage]
[  719.763909]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  719.763915]  [<ffffffffa035fd20>] ? fill_inquiry_response+0x20/0x20
[usb_storage]
[  719.763918]  [<ffffffff810c452f>] kthread+0xff/0x120
[  719.763920]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  719.763924]  [<ffffffff817eaafc>] ret_from_fork+0x7c/0xb0
[  719.763926]  [<ffffffff810c4430>] ? insert_kthread_work+0x80/0x80
[  719.763928] 1 lock held by usb-storage/539:
[  719.763929]  #0:  (&us_interface_key[i]){+.+.+.}, at: [<ffffffffa035fdaa>]
usb_stor_control_thread+0x8a/0x290 [usb_storage]

-- 
You are receiving this mail because:
You are the assignee for the bug.
