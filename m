From: "John Stoffel" <john@stoffel.org>
Subject: 2.6.31 -  INFO: task mt:14828 blocked for more than 120 seconds
Date: Wed, 4 Nov 2009 14:15:25 -0500
Message-ID: <19185.53965.58452.36569@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757864AbZKDT2Q@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi all,

I'm running 2.6.31 on a dual PIII Xeon 550Mhz box running Debian
unstable, very much upto date.  I've got two IDE disks, two SATA
disks, two SCSI boot disks, two DLT7k tape drives and a tape library.
All on seperate controllers.  

I'm trying to erase a DLT7000 tape, but I can't interrupt the 'mt -f
/dev/dlt7k-right erase' command.  I see in dmesg the following:

   [1464778.472497] INFO: task mt:14828 blocked for more than 120
   seconds.
   [1464778.472599] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
   disables this message.
   [1464778.472700] mt            D 00000001     0 14828  14392
   0x00000000
   [1464778.472843]  f3871d20 00000086 f706fc58 00000001 f29804d0
   f3871cb8 c12f9d78 f449b000
   [1464778.473197]  78895eac 00053309 f695ef00 f69baea0 00000020
   f69b91c0 c175f864 f2863d08
   [1464778.473563]  f35c44d0 f35c474c c281a740 00000000 f3871cd8
   788ac870 00053309 00000000
   [1464778.473910] Call Trace:
   [1464778.473989]  [<c12f9d78>] ? sym_put_start_queue+0xc8/0x120
   [1464778.474062]  [<c12fa419>] ? sym_queue_scsiio+0x179/0x270
   [1464778.474134]  [<c14bf535>] schedule_timeout+0x175/0x1b0
   [1464778.474217]  [<c121fff0>] ? kobject_put+0x20/0x50
   [1464778.474288]  [<c120e047>] ? blk_peek_request+0x107/0x180
   [1464778.474368]  [<c1214f2c>] ? blk_add_timer+0x6c/0xc0
   [1464778.474452]  [<c12bc0ff>] ? put_device+0xf/0x20
   [1464778.474529]  [<c12d88f2>] ? scsi_request_fn+0xc2/0x500
   [1464778.474614]  [<c14bf2bd>] wait_for_common+0xed/0x110
   [1464778.474690]  [<c102fa30>] ? default_wake_function+0x0/0x10
   [1464778.474759]  [<c14bf372>] wait_for_completion+0x12/0x20
   [1464778.474830]  [<c12ffbb0>] st_do_scsi+0x230/0x350
   [1464778.474897]  [<c12ff3e0>] ? st_scsi_execute_end+0x0/0x50
   [1464778.474967]  [<c13006db>] st_int_ioctl+0x1eb/0xd10
   [1464778.475041]  [<c1302a8a>] st_ioctl+0x6ea/0x1290
   [1464778.475126]  [<c10a332d>] ? chrdev_open+0xcd/0x160
   [1464778.475224]  [<c10793c5>] ? filemap_fault+0xd5/0x3a0
   [1464778.475307]  [<c10a3260>] ? chrdev_open+0x0/0x160
   [1464778.475408]  [<c1078de8>] ? unlock_page+0x48/0x50
   [1464778.475511]  [<c108c280>] ? __do_fault+0x2f0/0x3d0
   [1464778.475598]  [<c13023a0>] ? st_ioctl+0x0/0x1290
   [1464778.475684]  [<c10ad358>] vfs_ioctl+0x28/0x80
   [1464778.475769]  [<c10ad4ea>] do_vfs_ioctl+0x6a/0x5c0
   [1464778.475857]  [<c108db4d>] ? handle_mm_fault+0xed/0x540
   [1464778.475946]  [<c10ada79>] sys_ioctl+0x39/0x70
   [1464778.476032]  [<c1002e28>] sysenter_do_call+0x12/0x26


Is there anyway I can kill this process?  Or see if it's actually
making any progress?  The library doesn't happen to have a window, so
it's hard to see the drive lights without opening it up.

Thanks,
John
