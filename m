From: Jan Kara <jack@suse.cz>
Subject: Re: [bdi_unregister] 165a5e22fa INFO: task swapper:1 blocked for
 more than 120 seconds.
Date: Tue, 7 Mar 2017 17:26:56 +0100
Message-ID: <20170307162656.GB11837@quack2.suse.cz>
References: <20170305022111.yqtwyd6ognmco4gx@wfg-t540p.sh.intel.com>
 <20170306102733.GC14932@quack2.suse.cz>
 <20170306120123.GD14932@quack2.suse.cz>
 <1488810921.16832.6.camel@linux.vnet.ibm.com>
 <20170306151415.GA32207@quack2.suse.cz>
 <1488815095.25848.7.camel@linux.vnet.ibm.com>
 <20170306161345.GB32207@quack2.suse.cz>
 <1488821142.25848.27.camel@linux.vnet.ibm.com>
 <20170307144109.GI2578@quack2.suse.cz>
 <1488903029.2363.16.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755820AbdCGQrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Mar 2017 11:47:10 -0500
Content-Disposition: inline
In-Reply-To: <1488903029.2363.16.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, LKP <lkp@01.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Tue 07-03-17 08:10:29, James Bottomley wrote:
> On Tue, 2017-03-07 at 15:41 +0100, Jan Kara wrote:
> > On Mon 06-03-17 09:25:42, James Bottomley wrote:
> > > On Mon, 2017-03-06 at 17:13 +0100, Jan Kara wrote:
> > > > On Mon 06-03-17 07:44:55, James Bottomley wrote:
> > ...
> > > > > > Sure. The call trace is:
> > > > > > 
> > > > > > [   41.919244] ------------[ cut here ]------------
> > > > > > [   41.919263] WARNING: CPU: 4 PID: 2335 at
> > > > > > drivers/scsi/sd.c:3332
> > > > > > sd_shutdown+0x2f/0x100
> > > > > > [   41.919268] Modules linked in: scsi_debug(+) netconsole 
> > > > > > loop btrfs raid6_pq zlib_deflate lzo_compress xor
> > > > > > [   41.919319] CPU: 4 PID: 2335 Comm: modprobe Not tainted 
> > > > > > 4.11.0-rc1-xen+ #49
> > > > > > [   41.919325] Hardware name: Bochs Bochs, BIOS Bochs
> > > > > > 01/01/2011
> > > > > > [   41.919331] Call Trace:
> > > > > > [   41.919343]  dump_stack+0x8e/0xf0
> > > > > > [   41.919354]  __warn+0x116/0x120
> > > > > > [   41.919361]  warn_slowpath_null+0x1d/0x20
> > > > > > [   41.919368]  sd_shutdown+0x2f/0x100
> > > > > > [   41.919374]  sd_remove+0x70/0xd0
> > > > > > 
> > > > > > *** Here is the unexpected step I guess...
> > > > > > 
> > > > > > [   41.919383]  driver_probe_device+0xe0/0x4c0
> > > > > 
> > > > > Exactly.  It's this, I think
> > > > > 
> > > > > 	bool test_remove =
> > > > > IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE)
> > > > > &&
> > > > > 			   !drv->suppress_bind_attrs;
> > > > > 
> > > > > You have that config option set.
> > > > 
> > > > Yes - or better said 0-day testing has it set. Maybe that is not 
> > > > a sane default for 0-day tests? The option is explicitely marked 
> > > > as "unstable"... Fengguang?
> > > > 
> > > > > So the drivers base layer is calling ->remove after probe and
> > > > > triggering the destruction of the queue.
> > > > > 
> > > > > What to do about this (apart from nuke such a stupid option) is
> > > > > somewhat more problematic.
> > > > 
> > > > I guess this is between you and Greg :).
> > > 
> > > Nice try, sport ... you qualify just behind Dan in the "not my 
> > > problem" olympic hurdles event.  I'm annoyed because there's no 
> > > indication in the log that the driver add behaviour is radically 
> > > altered, so I've been staring at the wrong code for weeks. 
> > >  However, the unbind/rebind should work, so the real issue is that 
> > > your bdi changes (or perhaps something else in block) have induced 
> > > a regression in the unbinding of upper layer drivers.  If you're 
> > > going to release the bdi in del_gendisk, you have to have some 
> > > mechanism for re-acquiring it on re-probe (likely with the same 
> > > name) otherwise rebind is broken for every block driver.
> > 
> > So my patch does not release bdi in del_gendisk(). Bdi has two
> > initialization / destruction phases (similarly to request queue). You
> > allocate and initialize bdi through bdi_init(), then you call
> > bdi_register() to register it (which happens in device_add_disk()). 
> > On shutdown you have to first call bdi_unregister() (used to be 
> > called from blk_cleanup_queue(), my patch moved it to del_gendisk()). 
> > After that the last reference to bdi may be dropped which does final 
> > bdi destruction.
> > 
> > So do I understand correctly that SCSI may call device_add_disk(),
> > del_gendisk() repeatedly for the same request queue?
> 
> Yes.  The upper drivers (sd, sr, st and sg) follow a device model. 
>  They can thus be bound and unbound many times during the lifetime of a
> SCSI device.
> 
> >  If yes, then indeed I have a bug to fix... But gendisk seems to get 
> > allocated from scratch on each probe so we don't call 
> > device_add_disk(), del_gendisk() more times on the same disk, right?
> 
> Right, gendisk, being a generic representation of a disk is a property
> of the upper layer drivers.  We actually cheat and use it in all of
> them (including the apparent character ones, they use alloc_disk,
> put_disk but not add_disk).  So it has to be freed when the driver is
> unbound and reallocated when it is bound.  It's the fundamental entity
> which embeds the SCSI upper layer driver lifetime.
> 
> > > The fact that the second rebind tried with a different name 
> > > indicates that sd_devt_release wasn't called, so some vestige of 
> > > the devt remains on the subsequent rebind.
> > 
> > Yep, I guess that's caused by Dan's patch (commit 0dba1314d4f8 now) 
> > which calls put_disk_devt() only in blk_cleanup_queue() which, if I
> > understood you correctly, does not get called during unbind-bind 
> > cycle? In fact Dan's patch would end up leaking devt's because of 
> > repeated device_add_disk() calls for the same request queue...
> 
> That's a bit unfortunate.
> 
> > > Here's the problem: the queue belongs to SCSI (the lower layer), so 
> > > it's not going to change because it doesn't see the release.  The
> > > gendisk and its allied stuff belongs to sd so it gets freed and re
> > > -created for the same queue.  Something in block is very confused
> > > when this happens.
> > 
> > Yep, I think the binding of request queue to different gendisks is
> > something I or Dan did not expect.
> 
> OK, so I think we now understand why this is happening ... the question
> is what we do about it?  Is it fixable or do we need to go back to
> basics?  The fundamental property which got broken by these patches is
> the idea of the separation of the lifecycles of the queue and the
> gendisk.  The only requirement is that the queue must exist before the
> gendisk is created and must be destroyed after it.  This doesn't forbid
> there being many gendisk lifetimes over one queue lifetime and this is
> what we rely on for the SCSI driver model.  We rarely get called on it
> because unbind/rebind of a ULD is rarely done in production (it's
> mostly a devtest thing).

For now I think it's fixable. Let's see what I'll be able to come up with.
Let me also note that before my patch moving bdi_unregister() to
del_gendisk() (commit 165a5e22fafb), the SCSI driver model was buggy in a
different way - because bdi_unregister() was called only from
blk_cleanup_queue(), we were leaking bdi->owner reference to gendisk by
repeated calls to bdi_register_owner() from device_add_disk() and
thus gendisks were never freed after unbind/bind (I've actually verified
this bug exists with debug messages). Also as a result request queue use
count was steadily increasing with each new gendisk and request queue could
never get freed after unbind / rebind.

My patch silently fixed this leakage but introduced a different set of
problems which I'll try to fix.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
