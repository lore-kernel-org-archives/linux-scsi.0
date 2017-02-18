From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Manual driver binding and unbinding broken for SCSI
Date: Fri, 17 Feb 2017 16:43:56 -0800
Message-ID: <1487378636.4351.45.camel@HansenPartnership.com>
References: <20170218003015.GA19776@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170218003015.GA19776@vader.DHCP.thefacebook.com>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-02-17 at 16:30 -0800, Omar Sandoval wrote:
> Hi, everyone,
> 
> As per $SUBJECT, I can cause a crash on v4.10-rc8, Jens' block/for
> -next,
> and Jan's bdi branch [1] by doing this:
> 
> # lsscsi
> [0:0:0:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sda
> # echo 0:0:0:0 > /sys/bus/scsi/drivers/sd/unbind
> # echo 0:0:0:0 > /sys/bus/scsi/drivers/sd/bind
> 
> The resulting trace looks like this:
> 
> [   19.347924] kobject (ffff8800791ea0b8): tried to init an
> initialized object, something is seriously wrong.
> [   19.349781] CPU: 1 PID: 84 Comm: kworker/u8:1 Not tainted 4.10.0
> -rc7-00210-g53f39eeaa263 #34
> [   19.350686] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.1-20161122_114906-anatol 04/01/2014
> [   19.350920] Workqueue: events_unbound async_run_entry_fn
> [   19.350920] Call Trace:
> [   19.350920]  dump_stack+0x63/0x83
> [   19.350920]  kobject_init+0x77/0x90
> [   19.350920]  blk_mq_register_dev+0x40/0x130
> [   19.350920]  blk_register_queue+0xb6/0x190
> [   19.350920]  device_add_disk+0x1ec/0x4b0
> [   19.350920]  sd_probe_async+0x10d/0x1c0 [sd_mod]
> [   19.350920]  async_run_entry_fn+0x48/0x150
> [   19.350920]  process_one_work+0x1d0/0x480
> [   19.350920]  worker_thread+0x48/0x4e0
> [   19.350920]  kthread+0x101/0x140
> [   19.350920]  ? process_one_work+0x480/0x480
> [   19.350920]  ? kthread_create_on_node+0x60/0x60
> [   19.350920]  ret_from_fork+0x2c/0x40
> 
> Additionally, on v4.10-rc8, but not on block/for-next or Jan's
> branch,
> doing this:
> 
> # echo 0:0:0:0 > /sys/bus/scsi/drivers/sd/unbind
> # modprobe scsi_debug
> 
> Causes this trace:
> 
> [   18.876096] ------------[ cut here ]------------
> [   18.877057] WARNING: CPU: 1 PID: 90 at fs/sysfs/dir.c:31
> sysfs_warn_dup+0x62/0x80
> [   18.878270] sysfs: cannot create duplicate filename
> '/devices/virtual/bdi/8:0'
> [   18.879435] Modules linked in: scsi_debug btrfs xor raid6_pq
> sd_mod virtio_scsi scsi_mod nvme nvme_core virtio_net
> [   18.881118] CPU: 1 PID: 90 Comm: kworker/u8:2 Not tainted 4.10.0
> -rc8 #34
> [   18.882114] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.1-20161122_114906-anatol 04/01/2014
> [   18.883872] Workqueue: events_unbound async_run_entry_fn
> [   18.884408] Call Trace:
> [   18.884408]  dump_stack+0x63/0x83
> [   18.884408]  __warn+0xcb/0xf0
> [   18.884408]  warn_slowpath_fmt+0x5f/0x80
> [   18.884408]  ? kernfs_path_from_node+0x4f/0x60
> [   18.884408]  sysfs_warn_dup+0x62/0x80
> [   18.884408]  sysfs_create_dir_ns+0x77/0x90
> [   18.884408]  kobject_add_internal+0xbe/0x350
> [   18.884408]  kobject_add+0x75/0xd0
> [   18.884408]  device_add+0x121/0x680
> [   18.884408]  device_create_groups_vargs+0xe0/0xf0
> [   18.884408]  device_create_vargs+0x1c/0x20
> [   18.884408]  bdi_register+0x90/0x1b0
> [   18.884408]  ? sd_revalidate_disk+0x34a/0x1d00 [sd_mod]
> [   18.884408]  bdi_register_owner+0x36/0x60
> [   18.884408]  device_add_disk+0x165/0x4a0
> [   18.884408]  ? update_autosuspend+0x51/0x60
> [   18.884408]  ? __pm_runtime_use_autosuspend+0x5c/0x70
> [   18.884408]  sd_probe_async+0x10d/0x1c0 [sd_mod]
> [   18.884408]  async_run_entry_fn+0x4a/0x170
> [   18.884408]  process_one_work+0x165/0x430
> [   18.884408]  worker_thread+0x4e/0x490
> [   18.884408]  kthread+0x101/0x140
> [   18.884408]  ? process_one_work+0x430/0x430
> [   18.884408]  ? kthread_create_on_node+0x60/0x60
> [   18.884408]  ret_from_fork+0x2c/0x40
> [   18.913090] ---[ end trace f43b051485c2a749 ]---
> 
> On all three kernels, it looks like the bdi sysfs entry hangs around
> after the block device has already been removed:

This seems to be related to a 0day test we got on the block tree,
details here:

http://marc.info/?t=148624068800001

I root caused the above to something not being released when it should
be, so it looks like you have the same problem.  It seems to be a
recent commit in the block tree, so could you bisect it since you have
a nice reproducer?

Thanks,

James
