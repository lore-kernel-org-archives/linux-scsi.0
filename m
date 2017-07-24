From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Please help me with kernel hung
Date: Mon, 24 Jul 2017 10:27:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707241024420.1739-100000@iolanthe.rowland.org>
References: <CABXGCsMF-pjcy+apEKRVtRjUS=G1Hh7ZXhryaH6eScp5AF5kCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60166 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1756066AbdGXO1e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 10:27:34 -0400
In-Reply-To: <CABXGCsMF-pjcy+apEKRVtRjUS=G1Hh7ZXhryaH6eScp5AF5kCg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Mon, 24 Jul 2017, Михаил Гаврилов wrote:

> Hi guys. I hope what I wrote to appropriate mailing list. Can anybody
> look in hung issue below:
> 
> [  246.751384] kernel: INFO: task scsi_eh_6:388 blocked for more than
> 120 seconds.
> [  246.752085] kernel:       Not tainted 4.13.0-0.rc1.git4.1.fc27.x86_64 #1
> [  246.752187] kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  246.752312] kernel: scsi_eh_6       D13432   388      2 0x00000080
> [  246.752332] kernel: Call Trace:
> [  246.752357] kernel:  __schedule+0x2dc/0xbb0
> [  246.752385] kernel:  schedule+0x3d/0x90
> [  246.752396] kernel:  schedule_preempt_disabled+0x15/0x20
> [  246.752406] kernel:  __mutex_lock+0x2f4/0xa00
> [  246.752422] kernel:  ? device_reset+0x24/0x50 [usb_storage]
> [  246.752460] kernel:  ? scsi_error_handler+0x96/0x620
> [  246.752470] kernel:  mutex_lock_nested+0x1b/0x20
> [  246.752478] kernel:  ? mutex_lock_nested+0x1b/0x20
> [  246.752489] kernel:  device_reset+0x24/0x50 [usb_storage]
> [  246.752502] kernel:  scsi_eh_ready_devs+0x37a/0xe10
> [  246.752523] kernel:  ? trace_hardirqs_on_caller+0xf4/0x190
> [  246.752538] kernel:  ? scsi_error_handler+0x5/0x620
> [  246.752546] kernel:  ? scsi_error_handler+0x96/0x620
> [  246.752555] kernel:  scsi_error_handler+0x505/0x620
> [  246.752589] kernel:  kthread+0x133/0x150
> [  246.752598] kernel:  ? scsi_eh_get_sense+0x250/0x250
> [  246.752607] kernel:  ? kthread_create_on_node+0x70/0x70
> [  246.752621] kernel:  ? kthread_create_on_node+0x70/0x70
> [  246.752632] kernel:  ret_from_fork+0x2a/0x40
> [  246.752672] kernel: INFO: task usb-storage:390 blocked for more
> than 120 seconds.
> [  246.752782] kernel:       Not tainted 4.13.0-0.rc1.git4.1.fc27.x86_64 #1
> [  246.752879] kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  246.753056] kernel: usb-storage     D13584   390      2 0x00000080
> [  246.753082] kernel: Call Trace:
> [  246.753114] kernel:  __schedule+0x2dc/0xbb0
> [  246.753162] kernel:  ? wait_for_completion+0x117/0x1a0
> [  246.753177] kernel:  schedule+0x3d/0x90
> [  246.753197] kernel:  schedule_timeout+0x29d/0x510
> [  246.753241] kernel:  ? mark_held_locks+0x5f/0x90
> [  246.753259] kernel:  ? _raw_spin_unlock_irq+0x2c/0x40
> [  246.753277] kernel:  ? wait_for_completion+0x117/0x1a0
> [  246.753310] kernel:  ? wait_for_completion+0x117/0x1a0
> [  246.753326] kernel:  wait_for_completion+0x136/0x1a0
> [  246.753339] kernel:  ? wait_for_completion+0x136/0x1a0
> [  246.753358] kernel:  ? wake_up_q+0x80/0x80
> [  246.753401] kernel:  usb_sg_wait+0x119/0x180
> [  246.753441] kernel:  usb_stor_bulk_transfer_sglist.part.1+0x70/0xd0
> [usb_storage]
> [  246.753477] kernel:  usb_stor_bulk_srb+0x4e/0x80 [usb_storage]
> [  246.753506] kernel:  usb_stor_Bulk_transport+0x187/0x430 [usb_storage]
> [  246.753554] kernel:  usb_stor_invoke_transport+0x3e/0x540 [usb_storage]
> [  246.753596] kernel:  ? mark_held_locks+0x5f/0x90
> [  246.753613] kernel:  ? _raw_spin_unlock_irq+0x2c/0x40
> [  246.753664] kernel:  usb_stor_transparent_scsi_command+0xe/0x10 [usb_storage]
> [  246.753685] kernel:  usb_stor_control_thread+0x1fb/0x280 [usb_storage]
> [  246.753731] kernel:  kthread+0x133/0x150
> [  246.753751] kernel:  ? fill_inquiry_response+0x20/0x20 [usb_storage]
> [  246.753766] kernel:  ? kthread_create_on_node+0x70/0x70
> [  246.753796] kernel:  ret_from_fork+0x2a/0x40
> [  246.753878] kernel:
>                        Showing all locks held in the system:
> [  246.753903] kernel: 2 locks held by kworker/6:1/63:
> [  246.753926] kernel:  #0:
> ("events_freezable_power_efficient"){.+.+.+}, at: [<ffffffff910d2830>]
> process_one_work+0x1d0/0x6a0
> [  246.754031] kernel:  #1:  ((&(&ev->dwork)->work)){+.+.+.}, at:
> [<ffffffff910d2830>] process_one_work+0x1d0/0x6a0
> [  246.754085] kernel: 1 lock held by khungtaskd/65:
> [  246.754095] kernel:  #0:  (tasklist_lock){.+.+..}, at:
> [<ffffffff911149bd>] debug_show_all_locks+0x3d/0x1a0
> [  246.754156] kernel: 1 lock held by scsi_eh_6/388:
> [  246.754166] kernel:  #0:  (&us_interface_key[i]){+.+...}, at:
> [<ffffffffc0369b34>] device_reset+0x24/0x50 [usb_storage]
> [  246.754222] kernel: 1 lock held by usb-storage/390:
> [  246.754232] kernel:  #0:  (&us_interface_key[i]){+.+...}, at:
> [<ffffffffc036c79d>] usb_stor_control_thread+0x7d/0x280 [usb_storage]
> [  246.754290] kernel: 1 lock held by lvm/519:
> [  246.754300] kernel:  #0:  (&ev->block_mutex){+.+...}, at:
> [<ffffffff91491073>] disk_block_events+0x33/0x90
> [  246.754357] kernel: 1 lock held by systemd-udevd/543:
> [  246.754366] kernel:  #0:  (&bdev->bd_mutex){+.+.+.}, at:
> [<ffffffff91319963>] __blkdev_put+0x43/0x200
> [  246.754427] kernel:
> [  246.754436] kernel: =============================================
> 
> 
> This occured after update kernel to 4.13.0-0.rc1.git4.1 then next
> reboot. After pressing reset button and follow reboot problem not
> reproduced. But sometime kernel may hangs silently.
> 
> If I'm wrong with the mailing list, tell me please appropriate mailing list.

These are the right mailing lists.

We need more information to tell what is going wrong.  Can you post the
full dmesg log?

Alan Stern
