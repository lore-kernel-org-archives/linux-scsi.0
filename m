From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Thu, 15 May 2008 17:01:01 +0800
Message-ID: <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org> <20080514155639.GB28594@kroah.com> <20080514162442.GO9324@parisc-linux.org> <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:5360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYEOJAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2008 05:00:38 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1332011ugf.16
        for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 02:00:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Thu, May 15, 2008 at 01:47:02PM +0800, Dave Young wrote:
> On Thu, May 15, 2008 at 12:24 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Wed, May 14, 2008 at 08:56:39AM -0700, Greg KH wrote:
> >> On Wed, May 14, 2008 at 12:09:33AM -0700, Andrew Morton wrote:
> >> >
> >> > =============================================
> >> > [ INFO: possible recursive locking detected ]
> >> > 2.6.26-rc2-mm1 #15
> >> > ---------------------------------------------
> >> > modprobe/942 is trying to acquire lock:
> >> >  (&cls->mutex){--..}, at: [<ffffffff811b431e>] device_add+0x43d/0x57a
> >> >
> >> > but task is already holding lock:
> >> >  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
> >> >
> >> > other info that might help us debug this:
> >> > 1 lock held by modprobe/942:
> >> >  #0:  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
> >> >
> >> > stack backtrace:
> >> > Pid: 942, comm: modprobe Not tainted 2.6.26-rc2-mm1 #15
> >> >
> >> > Call Trace:
> >> >  [<ffffffff81056be1>] __lock_acquire+0x90d/0xc50
> >> >  [<ffffffff8100c50f>] ? restore_args+0x0/0x30
> >> >  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
> >> >  [<ffffffff81057276>] lock_acquire+0x91/0xb7
> >> >  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
> >> >  [<ffffffff812b23ab>] mutex_lock_nested+0xf2/0x278
> >> >  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
> >> >  [<ffffffff812b3acd>] ? _spin_unlock+0x23/0x28
> >> >  [<ffffffff811b431e>] device_add+0x43d/0x57a
> >> >  [<ffffffff811b4471>] device_register+0x16/0x1b
> >> >  [<ffffffff811b4555>] device_create+0xdf/0x112
> >> >  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
> >> >  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
> >> >  [<ffffffff812b1fe1>] ? mutex_unlock+0x9/0xb
> >> >  [<ffffffff811b79b7>] ? kobj_map+0x113/0x124
> >> >  [<ffffffff810ac0f5>] ? exact_lock+0x0/0x14
> >> >  [<ffffffff810abd09>] ? exact_match+0x0/0x9
> >> >  [<ffffffffa00ec448>] :sg:sg_add+0x2a3/0x3bd
> >> >  [<ffffffff811b67b6>] class_interface_register+0x77/0xbd
> >> >  [<ffffffffa005d869>] :scsi_mod:scsi_register_interface+0x11/0x13
> >> >  [<ffffffffa00d50a3>] :sg:init_sg+0xa3/0x155
> >> >  [<ffffffff8105ea8f>] sys_init_module+0x1823/0x197a
> >> >  [<ffffffff810c45bc>] ? seq_release+0x0/0x56
> >> >  [<ffffffff8100bebb>] system_call_after_swapgs+0x7b/0x80
> >>
> >> I'm guessing that this is due to David's "change the semaphore to a
> >> mutex" patch that you have in your tree, but I refused to take as I was
> >> worried about just this issue :)
> >
> > Hm, I thought I saw the same patch from Arjan months ago ... anyway.
> >
> > class_interface_register() (at least in -rc2) holds &parent->sem (ie the
> > result of calling class_get() on the class) around calling ->add_dev.
> > The class in this case is the sg_sysfs_class, so it's calling sg_add().
> > sg_add() calls device_create() which calls device_add() which acquires
> > the &dev->class->sem.  The class in this case would _also_ seem to be
> > sg_sysfs_class.
> >
> > So why doesn't this deadlock today?
> 
> The classes are different here, first sdev_class, then sg_sysfs_class

Greg, what about using mutex_lock_nested to silence lockdep? They are
the only usage of class->mutex out of class.c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/base/core.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
--- linux/drivers/base/core.c	2008-05-15 16:48:31.000000000 +0800
+++ linux.new/drivers/base/core.c	2008-05-15 16:47:59.000000000 +0800
@@ -888,7 +888,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		mutex_lock(&dev->class->mutex);
+		mutex_lock_nested(&dev->class->mutex, SINGLE_DEPTH_NESTING);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -997,7 +997,7 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		mutex_lock(&dev->class->mutex);
+		mutex_lock_nested(&dev->class->mutex, SINGLE_DEPTH_NESTING);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->remove_dev)
