From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 02 Apr 2007 09:21:54 -0400
Message-ID: <46110372.4070101@emulex.com>
References: <20061208211236.GC29763@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20061208211236.GC29763@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Matt,

Have your resolved the unload race conditions yet?

We'd like to update lpfc for the async scans, but our testing gets blocked
very quickly by the bugs. The bugs are not necessarily specific to lpfc
or to FC.

Stack traces are below. Simple ismod/rmmod loop can trigger them....

-- james s



First one is an rmmod while lpfc is active in it's scan_start function.
I think we're in a sleep waiting for the board to be ready when the driver
is yanked out from underneath us.

Second one is an rmmod while do_scsi_scan_host is in a loop calling
scan_finished.

Third one is an rmmod immediately after completion of do_scan_async.


STACK TRACE 1
-------------

BUG: unable to handle kernel paging request at virtual address f8941836
  printing eip:
f8941836
*pde = 37e59067
Oops: 0000 [#1]
SMP
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirror dm_mod video sbs i2c_e6
  printing eip:
f8941836
*pde = 37e59067
  chipreg pcspkr tg3 scsi_transport_fc mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod exd
CPU:    2
EIP:    0060:[<f8941836>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-rc7-jimp #1)
EIP is at 0xf8941836
eax: 00000000   ebx: 00000000   ecx: c1900000   edx: 00000286
esi: f7ab6000   edi: f887158d   ebp: f7ab62e8   esp: ecec9f30
ds: 007b   es: 007b   ss: 0068
Process scsi_scan_6 (pid: 15927, ti=ecec9000 task=f2309000 task.ti=ecec9000)
Stack: c04a2183 f65b6cc4 f8963c80 f8963c80 f71e38d0 ffffffef c04a1cef 00008180
        00000008 f6e4aa00 00000000 00000046 00000000 f7ab62e8 f7ab6000 f887158d
        f75fa3e0 f7ab62e8 f7ab6000 f887158d f75fa3e0 f894d6dc f89593e4 f7ab6000
Call Trace:
  [<c04a2183>] sysfs_dirent_exist+0x20/0x5f
  [<c04a1cef>] sysfs_add_file+0x66/0x70
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<f88713e0>] do_scsi_scan_host+0x30/0x8b [scsi_mod]
  [<f88715aa>] do_scan_async+0x1d/0x126 [scsi_mod]
  [<c041f7b4>] complete+0x39/0x48
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<c0436924>] kthread+0xb0/0xd8
  [<c0436874>] kthread+0x0/0xd8
  [<c0404977>] kernel_thread_helper+0x7/0x10
  =======================
Code:  Bad EIP value.
EIP: [<f8941836>] 0xf8941836 SS:ESP 0068:ecec9f30
  <0>Oops: 0000 [#2]
SMP
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirror dm_mod video sbs i2c_ed
CPU:    3
EIP:    0060:[<f8941836>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-rc7-jimp #1)
EIP is at 0xf8941836
eax: 00000000   ebx: 00000000   ecx: c1902000   edx: 00000286
esi: f74ff000   edi: f887158d   ebp: f74ff2e8   esp: ec3c1f30
ds: 007b   es: 007b   ss: 0068
Process scsi_scan_5 (pid: 15919, ti=ec3c1000 task=f7b92000 task.ti=ec3c1000)
Stack: c04a2183 ece3821c f8963c80 f8963c80 f6b3942c ffffffef c04a1cef 00008180
        00000008 f6efea00 00000000 00000046 00000002 f74ff2e8 f74ff000 f887158d
        f7897de0 f74ff2e8 f74ff000 f887158d f7897de0 f894d6dc f89593e4 f74ff000
Call Trace:
  [<c04a2183>] sysfs_dirent_exist+0x20/0x5f
  [<c04a1cef>] sysfs_add_file+0x66/0x70
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<f88713e0>] do_scsi_scan_host+0x30/0x8b [scsi_mod]
  [<f88715aa>] do_scan_async+0x1d/0x126 [scsi_mod]
  [<f887158d>] do_scan_async+0x0/0x126 [scsi_mod]
  [<c0436924>] kthread+0xb0/0xd8
  [<c0436874>] kthread+0x0/0xd8
  [<c0404977>] kernel_thread_helper+0x7/0x10
  =======================

STACK TRACE 2
-------------

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
  printing eip:
c0548435
*pde = 00000000
Oops: 0000 [#3]
SMP
Modules linked in: lpfc autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirror dm_mod video sbs d
CPU:    3
EIP:    0060:[<c0548435>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20-rc7-jimp #1)
EIP is at make_class_name+0x27/0x7d
eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: 0000000b
esi: f887c29a   edi: 00000000   ebp: 00000000   esp: edd27ec4
ds: 007b   es: 007b   ss: 0068
Process fc_wq_7 (pid: 16050, ti=edd27000 task=f68b4550 task.ti=edd27000)
Stack: f65d35f8 f8889e20 f65d35f8 f65d35f0 f8889da0 c0548616 00000000 f65d35f0
        f69f0030 f6fdc000 00000000 c054869c f65d3400 f88720f8 f65d3400 f69f0030
        f8872152 f65d3400 f69f0000 f88721c9 f6fdc014 f6d1d848 f8872233 f8872247
Call Trace:
  [<c0548616>] class_device_del+0x8c/0x10a
  [<c054869c>] class_device_unregister+0x8/0x10
  [<f88720f8>] __scsi_remove_device+0x1d/0x60 [scsi_mod]
  [<f8872152>] scsi_remove_device+0x17/0x20 [scsi_mod]
  [<f88721c9>] __scsi_remove_target+0x6e/0xa1 [scsi_mod]
  [<f8872233>] __remove_child+0x0/0x18 [scsi_mod]
  [<f8872247>] __remove_child+0x14/0x18 [scsi_mod]
  [<c0545dc0>] device_for_each_child+0x1a/0x3c
  [<f887222a>] scsi_remove_target+0x2e/0x37 [scsi_mod]
  [<f88b7ae6>] fc_rport_final_delete+0x51/0x9a [scsi_transport_fc]
  [<c04339ff>] run_workqueue+0x85/0x125
  [<c042eb72>] do_sigaction+0x10f/0x149
  [<f88b7a95>] fc_rport_final_delete+0x0/0x9a [scsi_transport_fc]
  [<c0434359>] worker_thread+0xf9/0x124
  [<c0421072>] default_wake_function+0x0/0xc
  [<c0434260>] worker_thread+0x0/0x124
  [<c0436924>] kthread+0xb0/0xd8
  [<c0436874>] kthread+0x0/0xd8
  [<c0404977>] kernel_thread_helper+0x7/0x10
  =======================
Code: 5b 04 5b c3 55 31 ed 57 89 c7 56 89 c6 53 83 cb ff 83 ec 04 89 d9 89 14 24 89 e8 f2 ae f7 d1

STACK TRACE 3
-------------

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
  printing eip:
00000000
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: lpfc autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirror dm_mod video sbs d
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20-rc7-jimp #1)
EIP is at _stext+0x3fbffc70/0x14
eax: f64c2830   ebx: f64c2830   ecx: f887181b   edx: f6ee1414
esi: f6ee1414   edi: f6ee1414   ebp: c054a70a   esp: eb5f4e98
ds: 007b   es: 007b   ss: 0068
Process vol_id (pid: 32421, ti=eb5f4000 task=e50c1550 task.ti=eb5f4000)
Stack: c054a625 00000000 c04daa3e ec23d4c0 e9fa4000 f6ee1400 f6ee1414 e7df8800
        f887184f e7df8a84 f6ee1400 00000286 e7df8800 c0433bc4 f8871a7c f6ee1414
        e7df890c c06c44a8 c06c4440 f6ee148c c0433bc4 c0545cc9 ffffffff eb1f8e90
Call Trace:
  [<c054a625>] attribute_container_device_trigger+0x33/0xa2
  [<c04daa3e>] kobject_cleanup+0x3e/0x5e
  [<f887184f>] scsi_target_reap_usercontext+0x34/0x89 [scsi_mod]
  [<c0433bc4>] execute_in_process_context+0x16/0x38
  [<f8871a7c>] scsi_device_dev_release_usercontext+0x92/0xba [scsi_mod]
  [<c0433bc4>] execute_in_process_context+0x16/0x38
  [<c0545cc9>] device_release+0x26/0x6b
  [<c04daa3e>] kobject_cleanup+0x3e/0x5e
  [<c04daa5e>] kobject_release+0x0/0x8
  [<c04db507>] kref_put+0x60/0x6d
  [<c04860fa>] invalidate_bh_lru+0x26/0x37
  [<f886a0ac>] scsi_device_put+0x16/0x2e [scsi_mod]
  [<f88322d7>] scsi_disk_put+0x22/0x2e [sd_mod]
  [<f8832c19>] sd_release+0x69/0x70 [sd_mod]
  [<c04570bb>] truncate_inode_pages+0x17/0x1c
  [<c048a4be>] __blkdev_put+0x5b/0x103
  [<c046c70f>] __fput+0xa5/0x15b
  [<c046a23b>] filp_close+0x51/0x58
  [<c046b168>] sys_close+0x6d/0xa3
  [<c0403d9c>] syscall_call+0x7/0xb
  =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3fbffc70/0x14 SS:ESP 0068:eb5f4e98

