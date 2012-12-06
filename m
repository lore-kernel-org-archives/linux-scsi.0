From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Thu, 6 Dec 2012 16:27:14 +0200
Message-ID: <50C0AB42.8040402@mellanox.com>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com> <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org> <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com> <1354242098.3670.3.camel@obelisk.thedillows.org> <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com> <50BF9760.2080801@acm.org> <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com> <50C0A76C.20500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C0A76C.20500-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2012 16:10, Bart Van Assche wrote:
> On 12/05/12 22:32, Or Gerlitz wrote:
>> On Wed, Dec 5, 2012 at 8:50 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> 
>> wrote:
>> [...]
>>> The only way to make I/O work reliably if a failure can occur at the
>>> transport layer is to use multipathd on top of ib_srp. If a 
>>> connection fails
>>> for some reason, then the SRP SCSI host will be removed after the 
>>> SCSI error
>>> handler has finished with its error recovery strategy. And once the
>>> transport layer is operational again and srp_daemon detects that the
>>> initiator is no longer logged in srp_daemon will make ib_srp log in 
>>> again.
>>> multipathd will then cause I/O to continue over the new path.
>>
>> Claim basically understood and agreed however, does this also hold
>> when the link is back again, that is can't SRP login via this single
>> path also when there's no multipath on top?
>
> As far as I can remember the behavior of ib_srp has always been to try 
> to reconnect once to the SRP target after the SCSI error handler 
> kicked in. Other SCSI LLDs, e.g. the iSCSI initiator, can be 
> configured to keep trying to reconnect after a transport layer 
> failure. That has the advantage that the SCSI host number remains the 
> same after reconnecting succeeded as before reconnecting started.
>

Bart,

The core problem here seems to be that scsi_remove_host simply never ends.

Observing all the tasks in the system (e.g using "echo t > 
/proc/sysrq-trigger"), we've noted that
none of the SCSI EH are currently running, that is for all of them their 
trace is the following


scsi_eh_0       S 0000000000000000     0   380      2 0x00000000
  ffff88042c31be08 0000000000000046 ffff88042c31bfd8 0000000000014380
  ffff88042c31a010 0000000000014380 0000000000014380 0000000000014380
  ffff88042c31bfd8 0000000000014380 ffff88042f5be5c0 ffff88042bb48c40
Call Trace:
  [<ffffffff8139b2c0>] ? scsi_unjam_host+0x1f0/0x1f0
  [<ffffffff8155c599>] schedule+0x29/0x70
  [<ffffffff8139b335>] scsi_error_handler+0x75/0x1c0
  [<ffffffff8139b2c0>] ? scsi_unjam_host+0x1f0/0x1f0
  [<ffffffff8107cc2e>] kthread+0xee/0x100
  [<ffffffff8107cb40>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8156676c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8107cb40>] ? __init_kthread_worker+0x70/0x70

However, the flow starting in srp_remove_target hangs somewhere in the
block layer waiting for something to happen

worker/11:1    D 0000000000000000     0   163      2 0x00000000
  ffff88082be6f738 0000000000000046 ffff88082be6ffd8 0000000000014380
  ffff88082be6e010 0000000000014380 0000000000014380 0000000000014380
  ffff88082be6ffd8 0000000000014380 ffff88042f5ba580 ffff88082be6c1c0
Call Trace:
  [<ffffffff8155c599>] schedule+0x29/0x70
  [<ffffffff8155a60f>] schedule_timeout+0x14f/0x240
  [<ffffffff810674f0>] ? lock_timer_base+0x70/0x70
  [<ffffffff8155c43b>] wait_for_common+0x11b/0x170
  [<ffffffff81091ab0>] ? try_to_wake_up+0x300/0x300
  [<ffffffff8155c543>] wait_for_completion_timeout+0x13/0x20
  [<ffffffff8125ecc3>] blk_execute_rq+0x133/0x1c0
  [<ffffffff81257830>] ? get_request+0x210/0x3d0
  [<ffffffff8139dfb8>] scsi_execute+0xe8/0x180
  [<ffffffff8139e1f7>] scsi_execute_req+0xa7/0x110
  [<ffffffffa0086498>] sd_sync_cache+0xd8/0x130 [sd_mod]
  [<ffffffff8137180e>] ? __dev_printk+0x3e/0x90
  [<ffffffff81371b45>] ? dev_printk+0x45/0x50
  [<ffffffffa0086700>] sd_shutdown+0xd0/0x150 [sd_mod]
  [<ffffffffa008691c>] sd_remove+0x7c/0xc0 [sd_mod]
  [<ffffffff81375dec>] __device_release_driver+0x7c/0xe0
  [<ffffffff81375f5f>] device_release_driver+0x2f/0x50
  [<ffffffff81374e46>] bus_remove_device+0x126/0x190
  [<ffffffff81372bbb>] device_del+0x14b/0x250
  [<ffffffff813a2878>] __scsi_remove_device+0x1b8/0x1d0
  [<ffffffff8139eba6>] scsi_forget_host+0xf6/0x110
  [<ffffffff81396448>] scsi_remove_host+0x108/0x1e0
  [<ffffffffa0536c38>] srp_remove_target+0xb8/0x150 [ib_srp]
  [<ffffffffa0536d34>] srp_remove_work+0x64/0xa0 [ib_srp]
  [<ffffffff81074ce2>] process_one_work+0x1c2/0x4a0
  [<ffffffff81074c70>] ? process_one_work+0x150/0x4a0
  [<ffffffffa0536cd0>] ? srp_remove_target+0x150/0x150 [ib_srp]
  [<ffffffff8107746e>] worker_thread+0x12e/0x370
  [<ffffffff81077340>] ? manage_workers+0x180/0x180
  [<ffffffff8107cc2e>] kthread+0xee/0x100
  [<ffffffff8107cb40>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8156676c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8107cb40>] ? __init_kthread_worker+0x70/0x70


looking on the current locks in the system, we see that this kworker task
holds four locks, but none of them seems  to be mutually held by another 
task,


Showing all locks held in the system:
4 locks held by kworker/11:1/163:
  #0:  (events_long){.+.+.+}, at: [<ffffffff81074c70>] 
process_one_work+0x150/0x4a0
  #1:  ((&target->remove_work)){+.+.+.}, at: [<ffffffff81074c70>] 
process_one_work+0x150/0x4a0
  #2:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff81396374>] 
scsi_remove_host+0x34/0x1e0
  #3:  (&__lockdep_no_validate__){......}, at: [<ffffffff81375f57>] 
device_release_driver+0x27/0x50
1 lock held by bash/6298:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6319:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6321:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6323:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6325:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6327:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by mingetty/6329:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
1 lock held by agetty/6337:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81339a9e>] 
n_tty_read+0x58e/0x960
2 locks held by bash/6479:
  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff81340f52>] 
__handle_sysrq+0x32/0x190
  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff810b7b04>] 
debug_show_all_locks+0x44/0x1e0

Alex and Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
