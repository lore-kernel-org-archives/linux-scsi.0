From: Jan Kara <jack@suse.cz>
Subject: Re: [bdi_unregister] 165a5e22fa INFO: task swapper:1 blocked for
 more than 120 seconds.
Date: Mon, 6 Mar 2017 16:14:15 +0100
Message-ID: <20170306151415.GA32207@quack2.suse.cz>
References: <20170305022111.yqtwyd6ognmco4gx@wfg-t540p.sh.intel.com>
 <20170306102733.GC14932@quack2.suse.cz>
 <20170306120123.GD14932@quack2.suse.cz>
 <1488810921.16832.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488810921.16832.6.camel@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, LKP <lkp@01.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon 06-03-17 06:35:21, James Bottomley wrote:
> On Mon, 2017-03-06 at 13:01 +0100, Jan Kara wrote:
> > On Mon 06-03-17 11:27:33, Jan Kara wrote:
> > > Hi,
> > > 
> > > On Sun 05-03-17 10:21:11, Wu Fengguang wrote:
> > > > FYI next-20170303 is good while mainline is bad with this error.
> > > > The attached reproduce-* may help reproduce the issue.
> > > 
> > > Thanks for report! So from the stacktrace we are in the path 
> > > testing removal of a device immediately after it has been probed 
> > > and for some reason bdi_unregister() hangs - likely waiting for 
> > > cgroup-writeback references to drop. Given how early this happens 
> > > my guess is we fail to initialize something but for now I don't see 
> > > how my patch could make a difference. I'm trying to reproduce this 
> > > to be able to debug more...
> > 
> > OK, so after some debugging I think this is yet another problem in 
> > SCSI initialization / destruction code which my patch only makes 
> > visible (added relevant maintainers).
> > 
> > I can reproduce the problem reliably with enabling:
> > 
> > CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
> > CONFIG_SCSI_DEBUG=m
> > CONFIG_BLK_CGROUP=y
> > CONFIG_MEMCG=y
> > (and thus CONFIG_CGROUP_WRITEBACK=y)
> > 
> > then 'modprobe scsi_debug' is all it takes to reproduce hang. 
> > Relevant kernel messages with some of my debugging added (attached is 
> > a patch that adds those debug messages):
> 
> This looks to be precisely the same problem Dan Williams was debugging
> for us.
> 
> > [   58.721765] scsi host0: scsi_debug: version 1.86 [20160430]
> > [   58.721765]   dev_size_mb=8, opts=0x0, submit_queues=1,
> > statistics=0
> > [   58.728946] CGWB init ffff88007fbb2000
> > [   58.730095] Created sdev ffff880078e1a000
> > [   58.731611] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug
> > 0186 PQ : 0 ANSI: 7
> > [   58.782246] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> > MB/8.00 MiB)
> > [   58.789687] sd 0:0:0:0: [sda] Write Protect is off
> > [   58.791140] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> > [   58.800879] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> > enabled, supports DPO and FUA
> > [   58.893738] sd 0:0:0:0: [sda] Attached SCSI disk
> > [   58.896808] Unreg1
> > [   58.897960] Unreg2
> > [   58.898637] Unreg3
> > [   58.899100] CGWB ffff88007fbb2000 usage_cnt: 0
> > [   58.900004] Unreg4
> > [   58.904976] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> 
> OK, can you put a WARN_ON trace in sd_shutdown and tell us where this
> is coming from.  For the device to be reused after this we have to be
> calling sd_shutdown() without going into SDEV_DEL.

Sure. The call trace is:

[   41.919244] ------------[ cut here ]------------
[   41.919263] WARNING: CPU: 4 PID: 2335 at drivers/scsi/sd.c:3332 sd_shutdown+0x2f/0x100
[   41.919268] Modules linked in: scsi_debug(+) netconsole loop btrfs raid6_pq zlib_deflate lzo_compress xor
[   41.919319] CPU: 4 PID: 2335 Comm: modprobe Not tainted 4.11.0-rc1-xen+ #49
[   41.919325] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   41.919331] Call Trace:
[   41.919343]  dump_stack+0x8e/0xf0
[   41.919354]  __warn+0x116/0x120
[   41.919361]  warn_slowpath_null+0x1d/0x20
[   41.919368]  sd_shutdown+0x2f/0x100
[   41.919374]  sd_remove+0x70/0xd0

*** Here is the unexpected step I guess...

[   41.919383]  driver_probe_device+0xe0/0x4c0
[   41.919395]  ? kobject_uevent_env+0x1bc/0x660
[   41.919403]  __device_attach_driver+0xfa/0x120
[   41.919410]  ? __driver_attach+0x110/0x110
[   41.919417]  bus_for_each_drv+0x68/0x90
[   41.919424]  __device_attach+0xb2/0x110
[   41.919432]  device_initial_probe+0x13/0x20
[   41.919439]  bus_probe_device+0xa8/0xc0
[   41.919446]  device_add+0x297/0x600
[   41.919453]  ? call_rcu_bh+0x20/0x20
[   41.919463]  ? mutex_unlock+0x12/0x20
[   41.919473]  scsi_sysfs_add_sdev+0x69/0x210
[   41.919480]  scsi_probe_and_add_lun+0xcfd/0xd10
[   41.919489]  ? find_next_zero_bit+0x10/0x20
[   41.919496]  __scsi_scan_target+0xd2/0x4c0
[   41.919506]  ? proc_register+0x41/0x130
[   41.919512]  ? proc_register+0x11c/0x130
[   41.919520]  ? trace_hardirqs_on+0xd/0x10
[   41.919527]  ? _raw_spin_unlock_irq+0x30/0x50
[   41.919534]  scsi_scan_channel+0x5f/0xa0
[   41.919541]  scsi_scan_host_selected+0xb9/0x120
[   41.919549]  do_scsi_scan_host+0x81/0x90
[   41.919555]  scsi_scan_host+0x17a/0x1b0
[   41.919568]  ? scsi_add_host_with_dma+0x302/0x310
[   41.919593]  sdebug_driver_probe+0x204/0x320 [scsi_debug]
[   41.919601]  ? driver_sysfs_add+0x90/0xb0
[   41.919608]  driver_probe_device+0xb3/0x4c0
[   41.919615]  ? kobject_uevent_env+0x1bc/0x660
[   41.919623]  __device_attach_driver+0xfa/0x120
[   41.919630]  ? __driver_attach+0x110/0x110
[   41.919636]  bus_for_each_drv+0x68/0x90
[   41.919643]  __device_attach+0xb2/0x110
[   41.919651]  device_initial_probe+0x13/0x20
[   41.919658]  bus_probe_device+0xa8/0xc0
[   41.919664]  device_add+0x297/0x600
[   41.919671]  ? dev_set_name+0x41/0x50
[   41.919681]  device_register+0x1e/0x30
[   41.919696]  sdebug_add_adapter+0xff/0x1d0 [scsi_debug]
[   41.919703]  ? kobject_uevent+0xb/0x10
[   41.919709]  ? 0xffffffffa0172000
[   41.919723]  scsi_debug_init+0x40e/0x1000 [scsi_debug]
[   41.919730]  ? 0xffffffffa0172000
[   41.919739]  do_one_initcall+0xbe/0x200

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
