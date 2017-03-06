From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [bdi_unregister] 165a5e22fa INFO: task swapper:1 blocked for
 more than 120 seconds.
Date: Mon, 06 Mar 2017 09:25:42 -0800
Message-ID: <1488821142.25848.27.camel@linux.vnet.ibm.com>
References: <20170305022111.yqtwyd6ognmco4gx@wfg-t540p.sh.intel.com>
         <20170306102733.GC14932@quack2.suse.cz>
         <20170306120123.GD14932@quack2.suse.cz>
         <1488810921.16832.6.camel@linux.vnet.ibm.com>
         <20170306151415.GA32207@quack2.suse.cz>
         <1488815095.25848.7.camel@linux.vnet.ibm.com>
         <20170306161345.GB32207@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170306161345.GB32207@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, LKP <lkp@01.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-03-06 at 17:13 +0100, Jan Kara wrote:
> On Mon 06-03-17 07:44:55, James Bottomley wrote:
> > On Mon, 2017-03-06 at 16:14 +0100, Jan Kara wrote:
> > > On Mon 06-03-17 06:35:21, James Bottomley wrote:
> > > > On Mon, 2017-03-06 at 13:01 +0100, Jan Kara wrote:
> > > > > On Mon 06-03-17 11:27:33, Jan Kara wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > On Sun 05-03-17 10:21:11, Wu Fengguang wrote:
> > > > > > > FYI next-20170303 is good while mainline is bad with this
> > > > > > > error.
> > > > > > > The attached reproduce-* may help reproduce the issue.
> > > > > > 
> > > > > > Thanks for report! So from the stacktrace we are in the
> > > > > > path 
> > > > > > testing removal of a device immediately after it has been
> > > > > > probed 
> > > > > > and for some reason bdi_unregister() hangs - likely waiting
> > > > > > for
> > > > > > cgroup-writeback references to drop. Given how early this
> > > > > > happens 
> > > > > > my guess is we fail to initialize something but for now I
> > > > > > don't
> > > > > > see 
> > > > > > how my patch could make a difference. I'm trying to
> > > > > > reproduce
> > > > > > this 
> > > > > > to be able to debug more...
> > > > > 
> > > > > OK, so after some debugging I think this is yet another
> > > > > problem
> > > > > in 
> > > > > SCSI initialization / destruction code which my patch only
> > > > > makes 
> > > > > visible (added relevant maintainers).
> > > > > 
> > > > > I can reproduce the problem reliably with enabling:
> > > > > 
> > > > > CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
> > > > > CONFIG_SCSI_DEBUG=m
> > > > > CONFIG_BLK_CGROUP=y
> > > > > CONFIG_MEMCG=y
> > > > > (and thus CONFIG_CGROUP_WRITEBACK=y)
> > > > > 
> > > > > then 'modprobe scsi_debug' is all it takes to reproduce hang.
> > > > > Relevant kernel messages with some of my debugging added
> > > > > (attached is 
> > > > > a patch that adds those debug messages):
> > > > 
> > > > This looks to be precisely the same problem Dan Williams was
> > > > debugging
> > > > for us.
> > > > 
> > > > > [   58.721765] scsi host0: scsi_debug: version 1.86
> > > > > [20160430]
> > > > > [   58.721765]   dev_size_mb=8, opts=0x0, submit_queues=1,
> > > > > statistics=0
> > > > > [   58.728946] CGWB init ffff88007fbb2000
> > > > > [   58.730095] Created sdev ffff880078e1a000
> > > > > [   58.731611] scsi 0:0:0:0: Direct-Access     Linux   
> > > > >  scsi_debug
> > > > > 0186 PQ : 0 ANSI: 7
> > > > > [   58.782246] sd 0:0:0:0: [sda] 16384 512-byte logical
> > > > > blocks:
> > > > > (8.39
> > > > > MB/8.00 MiB)
> > > > > [   58.789687] sd 0:0:0:0: [sda] Write Protect is off
> > > > > [   58.791140] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> > > > > [   58.800879] sd 0:0:0:0: [sda] Write cache: enabled, read
> > > > > cache:
> > > > > enabled, supports DPO and FUA
> > > > > [   58.893738] sd 0:0:0:0: [sda] Attached SCSI disk
> > > > > [   58.896808] Unreg1
> > > > > [   58.897960] Unreg2
> > > > > [   58.898637] Unreg3
> > > > > [   58.899100] CGWB ffff88007fbb2000 usage_cnt: 0
> > > > > [   58.900004] Unreg4
> > > > > [   58.904976] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > > > 
> > > > OK, can you put a WARN_ON trace in sd_shutdown and tell us
> > > > where
> > > > this
> > > > is coming from.  For the device to be reused after this we have
> > > > to
> > > > be
> > > > calling sd_shutdown() without going into SDEV_DEL.
> > > 
> > > Sure. The call trace is:
> > > 
> > > [   41.919244] ------------[ cut here ]------------
> > > [   41.919263] WARNING: CPU: 4 PID: 2335 at
> > > drivers/scsi/sd.c:3332
> > > sd_shutdown+0x2f/0x100
> > > [   41.919268] Modules linked in: scsi_debug(+) netconsole loop
> > > btrfs
> > > raid6_pq zlib_deflate lzo_compress xor
> > > [   41.919319] CPU: 4 PID: 2335 Comm: modprobe Not tainted 4.11.0
> > > -rc1
> > > -xen+ #49
> > > [   41.919325] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > [   41.919331] Call Trace:
> > > [   41.919343]  dump_stack+0x8e/0xf0
> > > [   41.919354]  __warn+0x116/0x120
> > > [   41.919361]  warn_slowpath_null+0x1d/0x20
> > > [   41.919368]  sd_shutdown+0x2f/0x100
> > > [   41.919374]  sd_remove+0x70/0xd0
> > > 
> > > *** Here is the unexpected step I guess...
> > > 
> > > [   41.919383]  driver_probe_device+0xe0/0x4c0
> > 
> > Exactly.  It's this, I think
> > 
> > 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE)
> > &&
> > 			   !drv->suppress_bind_attrs;
> > 
> > You have that config option set.
> 
> Yes - or better said 0-day testing has it set. Maybe that is not a 
> sane default for 0-day tests? The option is explicitely marked as
> "unstable"... Fengguang?
> 
> > So the drivers base layer is calling ->remove after probe and
> > triggering the destruction of the queue.
> > 
> > What to do about this (apart from nuke such a stupid option) is
> > somewhat more problematic.
> 
> I guess this is between you and Greg :).

Nice try, sport ... you qualify just behind Dan in the "not my problem"
olympic hurdles event.  I'm annoyed because there's no indication in
the log that the driver add behaviour is radically altered, so I've
been staring at the wrong code for weeks.  However, the unbind/rebind
should work, so the real issue is that your bdi changes (or perhaps
something else in block) have induced a regression in the unbinding of
upper layer drivers.  If you're going to release the bdi in
del_gendisk, you have to have some mechanism for re-acquiring it on re
-probe (likely with the same name) otherwise rebind is broken for every
block driver.

The fact that the second rebind tried with a different name indicates
that sd_devt_release wasn't called, so some vestige of the devt remains
on the subsequent rebind.  Here's the problem: the queue belongs to
SCSI (the lower layer), so it's not going to change because it doesn't
see the release.  The gendisk and its allied stuff belongs to sd so it
gets freed and re-created for the same queue.  Something in block is
very confused when this happens.

James
