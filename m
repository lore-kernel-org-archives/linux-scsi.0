From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Wed, 15 Sep 2010 18:52:33 +0400
Message-ID: <4C90DDB1.9020003@vlnb.net>
References: <4C8F886E.2080407@vlnb.net> <20100915055649.GB22219@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0IOOwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2010 10:52:51 -0400
In-Reply-To: <20100915055649.GB22219@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

Hi Dmitry,

Dmitry Torokhov, on 09/15/2010 09:56 AM wrote:
>> Please review this second iteration of the patch set of the new
>> (although, perhaps, the oldest) SCSI target framework for Linux SCST
>> with a set of dev handlers and 2 target drivers: for local access
>> (scst_local) and for Infiniband SRP (srpt).
> 
> I am afraid that the way the code was split into the patches will hinder
> the review process. Normally every patch consists of a usable on its
> own piece of code (or a logically compete change). This way the unit of
> work (coding, testing or reviewing) is clearly defined and easier to
> comprehend.
> 
> Your patch series, unfortunately, splits Makefile and Kconfig changes
> separately from the drivers (which will cause build breakages should it
> be applied as is and someone needs to bisect), introduces header files
> in their entirety even when some of the data there is not needed till
> much later, uses facilities (for example sysfs bindings) that have not
> been introduced yet... I am afraid you'd have to rework the splitting
> process.

I can do any splitting you like. Generally, I oriented on the similarly
large work recently accepted into the kernel: DRBD. DRBD's patches were
split on per file basis. So, I did, basically, the same, only combined
some small such files into a single patch (e.g. "[PATCH 1/17]: Integration
of SCST into the Linux kernel tree" or "[PATCH 4/17]: SCST main management
files and private headers"). Making Makefile and Kconfig as a
separate patch is just a part of this approach. Unfortunately, SCST is too
big to be allowed to be sent to LKML, where the limit is 300KB, so splitting
it on separate patches and the corresponding bisecting breakage seems to be
unavoidable.

> Also patch descriptions should be improved:
> 
> "This patch contains SYSFS interface implementation"

SCST overall as well the SYSFS interface are thoroughly documented in the
SCST README and SysfsRules files, so I thought it would be unnecessary
to duplicate this text in the patch description, especially considering
that the SYSFS interface is quite big, so its description is big as well.

Would it be OK if I add to the next patches' descriptions references
where to find the corresponding documentation?
 
> - what are you trying to solve?
> - main points?

This interface provides possibility for a user to configure his/her SCST
server configuration: add/delete/manage target drivers, targets, dev handlers,
virtual devices and access control to them as well as it allows to see current
SCST configuration with necessary statistical and debug info (e.g. SGV cache
statistics).

> - why offloading of actions to a separate thread?

See below.
 
> This should be in the patch description.

OK
 
> BTW, why are you using an exclusive thread instead of exclusive
> workqueue for this?
 
This is a bit tricky. Basically, I documented it in scst.h before
struct scst_sysfs_work_item definition.

All internal SCST management is done for simplicity under scst_mutex.
It's simple, robust and worked well even under the highest load for ages.
But in 2.6.35 sysfs was improved to make lockdep to check s_active related
deadlocks and we discovered potential circular locking dependency
between scst_mutex and s_active. On some management operations lockdep triggered
output like:

[ 2036.926891] =======================================================
[ 2036.927670] [ INFO: possible circular locking dependency detected ]
[ 2036.927670] 2.6.35-scst-dbg #15
[ 2036.927670] -------------------------------------------------------
[ 2036.927670] rmmod/4715 is trying to acquire lock:
[ 2036.927670]  (s_active#230){++++.+}, at: [<78240a24>] sysfs_hash_and_remove+0x63/0x67
[ 2036.927670] 
[ 2036.927670] but task is already holding lock:
[ 2036.927670]  (&scst_mutex){+.+.+.}, at: [<fefd7fe2>] scst_unregister_virtual_device+0x58/0x216 [scst]
[ 2036.927670] 
[ 2036.927670] which lock already depends on the new lock.
[ 2036.927670] 
[ 2036.927670] 
[ 2036.927670] the existing dependency chain (in reverse order) is:
[ 2036.927670] 
[ 2036.927670] -> #2 (&scst_mutex){+.+.+.}:
[ 2036.927670]        [<78168d67>] lock_acquire+0x76/0x129
[ 2036.927670]        [<78467619>] __mutex_lock_common+0x58/0x3fc
[ 2036.927670]        [<78467a6d>] mutex_lock_nested+0x36/0x3d
[ 2036.927670]        [<f8ecec91>] vcdrom_change+0x1b9/0x500 [scst_vdisk]
[ 2036.927670]        [<f8ecf030>] vcdrom_sysfs_filename_store+0x58/0xd8 [scst_vdisk]
[ 2036.927670]        [<feffd139>] scst_dev_attr_store+0x44/0x5d [scst]
[ 2036.927670]        [<7824104f>] sysfs_write_file+0x9e/0xe8
[ 2036.927670]        [<781ee836>] vfs_write+0x91/0x17e
[ 2036.927670]        [<781ef213>] sys_write+0x42/0x69
[ 2036.927670]        [<78102d13>] sysenter_do_call+0x12/0x32
[ 2036.927670] 
[ 2036.927670] -> #1 (&virt_dev->vdev_sysfs_mutex){+.+.+.}:
[ 2036.927670]        [<78168d67>] lock_acquire+0x76/0x129
[ 2036.927670]        [<78467619>] __mutex_lock_common+0x58/0x3fc
[ 2036.927670]        [<784679f3>] mutex_lock_interruptible_nested+0x36/0x3d
[ 2036.927670]        [<f8ecebd6>] vcdrom_change+0xfe/0x500 [scst_vdisk]
[ 2036.927670]        [<f8ecf030>] vcdrom_sysfs_filename_store+0x58/0xd8 [scst_vdisk]
[ 2036.927670]        [<feffd139>] scst_dev_attr_store+0x44/0x5d [scst]
[ 2036.927670]        [<7824104f>] sysfs_write_file+0x9e/0xe8
[ 2036.927670]        [<781ee836>] vfs_write+0x91/0x17e
[ 2036.927670]        [<781ef213>] sys_write+0x42/0x69
[ 2036.927670]        [<78102d13>] sysenter_do_call+0x12/0x32
[ 2036.927670] 
[ 2036.927670] -> #0 (s_active#230){++++.+}:
[ 2036.927670]        [<78168af4>] __lock_acquire+0x1013/0x1210
[ 2036.927670]        [<78168d67>] lock_acquire+0x76/0x129
[ 2036.927670]        [<78242417>] sysfs_addrm_finish+0x100/0x150
[ 2036.927670]        [<78240a24>] sysfs_hash_and_remove+0x63/0x67
[ 2036.927670]        [<782415b6>] sysfs_remove_file+0x14/0x16
[ 2036.927670]        [<feffdb29>] scst_devt_dev_sysfs_put+0x75/0x133 [scst]
[ 2036.927670]        [<fefd6410>] scst_assign_dev_handler+0x109/0x5b6 [scst]
[ 2036.927670]        [<fefd80ce>] scst_unregister_virtual_device+0x144/0x216 [scst]
[ 2036.927670]        [<f8ed06f3>] vdev_del_device+0x47/0xd4 [scst_vdisk]
[ 2036.927670]        [<f8ed6701>] exit_scst_vdisk+0x60/0xe6 [scst_vdisk]
[ 2036.927670]        [<f8ed67b1>] exit_scst_vdisk_driver+0x12/0x46 [scst_vdisk]
[ 2036.927670]        [<7817253a>] sys_delete_module+0x139/0x214
[ 2036.927670]        [<78102d13>] sysenter_do_call+0x12/0x32
[ 2036.927670] 
[ 2036.927670] other info that might help us debug this:
[ 2036.927670] 
[ 2036.927670] 2 locks held by rmmod/4715:
[ 2036.927670]  #0:  (scst_vdisk_mutex){+.+.+.}, at: [<f8ed66f0>] exit_scst_vdisk+0x4f/0xe6 [scst_vdisk]
[ 2036.927670]  #1:  (&scst_mutex){+.+.+.}, at: [<fefd7fe2>] scst_unregister_virtual_device+0x58/0x216 [scst]
[ 2036.927670] 
[ 2036.927670] stack backtrace:
[ 2036.927670] Pid: 4715, comm: rmmod Not tainted 2.6.35-scst-dbg #15
[ 2036.927670] Call Trace:
[ 2036.927670]  [<784660a3>] ? printk+0x2d/0x32
[ 2036.927670]  [<78166cbc>] print_circular_bug+0xb4/0xb9
[ 2036.927670]  [<78168af4>] __lock_acquire+0x1013/0x1210
[ 2036.927670]  [<78168d67>] lock_acquire+0x76/0x129
[ 2036.927670]  [<78240a24>] ? sysfs_hash_and_remove+0x63/0x67
[ 2036.927670]  [<78242417>] sysfs_addrm_finish+0x100/0x150
[ 2036.927670]  [<78240a24>] ? sysfs_hash_and_remove+0x63/0x67
[ 2036.927670]  [<78240a24>] sysfs_hash_and_remove+0x63/0x67
[ 2036.927670]  [<782415b6>] sysfs_remove_file+0x14/0x16
[ 2036.927670]  [<feffdb29>] scst_devt_dev_sysfs_put+0x75/0x133 [scst]
[ 2036.927670]  [<fefd5b20>] ? scst_stop_dev_threads+0x77/0x111 [scst]
[ 2036.927670]  [<f8ece3c2>] ? vdisk_detach+0x88/0x133 [scst_vdisk]
[ 2036.927670]  [<fefd6410>] scst_assign_dev_handler+0x109/0x5b6 [scst]
[ 2036.927670]  [<ff007368>] ? scst_pr_clear_dev+0x8e/0xfc [scst]
[ 2036.927670]  [<fefd80ce>] scst_unregister_virtual_device+0x144/0x216 [scst]
[ 2036.927670]  [<f8ed06f3>] vdev_del_device+0x47/0xd4 [scst_vdisk]
[ 2036.927670]  [<f8ed6701>] exit_scst_vdisk+0x60/0xe6 [scst_vdisk]
[ 2036.927670]  [<f8ed67b1>] exit_scst_vdisk_driver+0x12/0x46 [scst_vdisk]
[ 2036.927670]  [<7817253a>] sys_delete_module+0x139/0x214
[ 2036.927670]  [<7846c87e>] ? sub_preempt_count+0x7e/0xad
[ 2036.927670]  [<78102d42>] ? sysenter_exit+0xf/0x1a
[ 2036.927670]  [<7816789d>] ? trace_hardirqs_on_caller+0x10c/0x14d
[ 2036.927670]  [<78102d13>] sysenter_do_call+0x12/0x32
[ 2036.927670]  [<7846007b>] ? init_intel_cacheinfo+0x317/0x38b

It is caused by a chicken and egg problem: SCST objects, including their sysfs hierarchy
(kobjects) are created under scst_mutex, but for some of them (ACGs and their names
attributes, ACNs, are the most problematic objects) the creation is triggered from
inside the SYSFS.

I spent a LOT of time trying to rule out this problem in an acceptable manner.
Particularly, I analyzed splitting creation of SCST objects and their kobjects, so the
latter would be created outside of scst_mutex, and making a fine grain locking for
the SCST management instead of the single scst_mutex, but all the options lead to
unacceptably complicated code. So, I have chosen the use of the separate thread for all
the SYSFS management operation with scst_mutex/s_active deadlock detecting (see
scst_sysfs_queue_wait_work()) and, if the deadlock possibility detected, returning EAGAIN
asking the user space to poll completion of the command using last_sysfs_mgmt_res
attribute. It is documented in the README and scstadmin is doing that. It, definitely,
isn't a piece of beauty, but it's simple and works, so, I believe, good enough. User space,
anyway, is supposes to hide all the complexities of the direct SYSFS manipulations under
higher level management tools like scstadmin.

> Also, kobject_del() + kobject_put() == kobject_unregister().

What do you mean? I can't find kobject_unregister() in the kernel code.
 
> And too many "naked returns", I believe common style is to only have
> return for non-void functions.

Hmm, I have not found this in the CodingStyle file. I personally started doing that
after I, adding later error recovery cases in returning void functions, several times
forgot to add the corresponding empty "return" before them, hence had them erroneously
triggered. Like:

was:

void f(void)
{
...
}

new:

void f(void)
{
...

out_error:
	error recovery code and exit
}

should be:

void f(void)
{
...
	return;

out_error:
	error recovery code and exit
}

So, I'd prefer to keep those returns to save from such mistakes in future.

Thank you,
Vlad
