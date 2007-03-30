From: Tejun Heo <htejun@gmail.com>
Subject: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 18:43:02 +0900
Message-ID: <460CDBA6.5030608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.234]:44164 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945959AbXC3JnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 05:43:11 -0400
Received: by nz-out-0506.google.com with SMTP id s1so371898nze
        for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 02:43:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello, all.

This document tries to describe lifetime problems of the current
device driver model primarily from the point view of device drivers
and establish consensus, or at least, start discussion about how to
solve these problems.  This is primarily based on my experience with
IDE and SCSI layers and my knowledge on other drivers is limited, so I
might have generalized too aggressively.  Feel free to point out.


Table of Contents

1. Why is it this complex?
1-1. Rule #a and #b
1-2. Rule #b and #c
2. How do we solve this?
2-1. Rule #a and #b
2-2. Rule #b and #c
3. How do we get there from here?
4. Some afterthoughts


1. Why is it this complex?

Object lifetime management in device drivers is complex and thus
error-prone under the current driver model.  The primary reason is
that device drivers have to match impedances of three different life
time rules.

Rule a. The device itself.  Many devices are hot pluggable these days.
        Devices come when they come and go when they go.

Rule b. Driver model object lifetime rule.  Fundamental data
        structures used by device drivers are reference counted and
        their lifetime can be arbitrarily extended by userspace sysfs
        access.

Rule c. Module life time rule.  Most device drivers can be compiled as
        modules and thus module busy count should be managed properly.


1-1. Rule #a and #b

Being what it is, the primary concern of a device driver is the
'device' itself.  A device driver should create and release objects
representing the devices it manages as they come and go.  In one way
or another, this just has to be done, so this rule is pretty obvious
and intuitive to device driver writers.

The current device driver model mandates implementation of rule #b in
device drivers.  This makes the object lifetime management complicated
and, more importantly, less intuitive to driver writers.  As
implementing such lifetime management in each device driver is too
painful, most device driver midlayers handle this.  e.g. SCSI midlayer
handles driver model lifetime rules and presents simplified
register/unregister-immediately interface to all low level SCSI
drivers.  IDE tries to do similar and USB and netdev have their own
mechanisms too.

I'm not familiar with other layers, but it took quite a while to get
this right in the SCSI midlayer.  The current code works and low level
drivers can do away with most of lifetime management but the added
complexity is saddening to look at.


1-2. Rule #b and #c

On the surface, it seems that we're doing this mostly correctly but
subtle bugs caused by interaction between driver model lifetime and
module lifetime rules aren't difficult to find.

This happens because the two lifetime rules are closely related but
the relation is not properly represented in device driver model
itself.  A module cannot be unloaded unless all device driver objects
it hosts are released, but the only way to guarantee that is to always
grab module reference whenever grabbing relevant kobject reference.
This is ugly to code and too easy to get wrong.  Here are two such
examples.

Example 1. sysfs_schedule_callback() not grabbing the owning module

  This function is recently added to be used by suicidal sysfs nodes
  such that they don't deadlock when trying to unregister themselves.

 +#include <linux/delay.h>
  static void sysfs_schedule_callback_work(struct work_struct *work)
  {
	struct sysfs_schedule_callback_struct *ss = container_of(work,
			struct sysfs_schedule_callback_struct, work);

 +	msleep(100);
	(ss->func)(ss->data);
	kobject_put(ss->kobj);
	kfree(ss);
  }

  int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
		void *data)
  {
	struct sysfs_schedule_callback_struct *ss;

	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
	if (!ss)
		return -ENOMEM;
	kobject_get(kobj);
	ss->kobj = kobj;
	ss->func = func;
	ss->data = data;
	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
	schedule_work(&ss->work);
	return 0;
  }

  Two lines starting with '+' are inserted to make the problem
  reliably reproducible.  With the above changes,

  # insmod drivers/scsi/scsi_mod.ko; insmod drivers/scsi/sd_mod.ko; insmod drivers/ata/libata.ko; insmod drivers/ata/ahci.ko
  # echo 1 > /sys/block/sda/device/delete; rmmod ahci; rmmod libata; rmmod sd_mod; rmmod scsi_mod

  It's assumed that ahci detects /dev/sda.  The above command sequence
  causes the following oops.

  BUG: unable to handle kernel paging request at virtual address e0984020
  [--snip--]
  EIP is at 0xe0984020
  [--snip--]
   [<c0127132>] run_workqueue+0x92/0x140
   [<c01278c7>] worker_thread+0x137/0x160
   [<c012a513>] kthread+0xa3/0xd0
   [<c0104457>] kernel_thread_helper+0x7/0x10

  The problem here is that kobjec_get() in sysfs_schedule_callback()
  doesn't grab the module backing the kobject it's grabbing.  By the
  time (ss->func)(ss->kobj) runs, scsi_mod is already gone.

Example 2. sysfs attr grabbing the wrong kobject and module

  This bug has been there for a long time, probably from the day these
  attrs are implemented.

  # insmod drivers/scsi/scsi_mod.ko; insmod drivers/scsi/sd_mod.ko; insmod drivers/ata/libata.ko; insmod drivers/ata/ahci.ko
  # cat > /sys/block/sda/device/delete &
  # rmmod ahci; rmmod libata
  # kill %%

  BUG: unable to handle kernel paging request at virtual address e083b1e8
  [--snip--]
  EIP:    0060:[<e0983310>]    Not tainted VLI
  [--snip--]
   [<c0127649>] execute_in_process_context+0x19/0x40
   [<e09820f2>] scsi_target_reap+0x82/0xa0 [scsi_mod]
   [<e0984771>] scsi_device_dev_release_usercontext+0xe1/0x110 [scsi_mod]
   [<c0127649>] execute_in_process_context+0x19/0x40
   [<e09835a3>] scsi_device_dev_release+0x13/0x20 [scsi_mod]
   [<c0287247>] device_release+0x17/0x90
   [<c0213a69>] kobject_cleanup+0x49/0x80
   [<c0213aab>] kobject_release+0xb/0x10
   [<c021482b>] kref_put+0x2b/0x80
   [<c0213a14>] kobject_put+0x14/0x20
   [<c01969af>] sysfs_release+0x5f/0xb0
   [<c015dcb4>] __fput+0xb4/0x1b0
   [<c015de18>] fput+0x18/0x20
   [<c015b207>] filp_close+0x47/0x70
   [<c0119394>] put_files_struct+0xa4/0xc0
   [<c011a4bf>] do_exit+0x11f/0x7c0
   [<c011ab89>] do_group_exit+0x29/0x70
   [<c0123415>] get_signal_to_deliver+0x265/0x3f0
   [<c01036ea>] do_notify_resume+0x8a/0x7a0
   [<c010425a>] work_notifysig+0x13/0x19

  The delete attr's owner is scsi_mod.  However, it's created under
  the sysfs node for the SCSI device under the node for SCSI host
  which is driven by libata and ahci combination.  Opening the delete
  node grabs 1. struct device for the SCSI device which propagates to
  the SCSI host node and 2. module reference for sd_mod.  So, ahci and
  libata can go away even while the SCSI host they implement is still
  alive.

Both examples can be reproduced using any SCSI low level driver.
Attrs implemented similarly as in example #2 are everywhere.  This is
the standard way to implement such attrs.


2. How do we solve this?

2-1. Rule #a and #b

If you think about it, the impedance matching between rule #a and #b
should be done somewhere.  Maybe doing it in each low level driver is
what's intended when the driver model is designed but it's
impractically painful and the reality reflects that by doing it in
midlayers.

It's better if we do it in higher layers.  For example, SCSI has a
mechanism to reject new requests and drain request_queue to allow low
level driver to just unregister an existing device.  IDE currently
doesn't have such feature but it would need to do almost the same
thing to support hotplug.  If request_queue just had a feature to
drain and kill itself, both SCSI and IDE could use it.  It would be
simpler and less error-prone.  On the other hand, if it's pushed
downward, it will cause much more pain in all the low level drivers.

Orphaning sysfs nodes on unregistration is a big step in this
direction.  With sysfs reference counting out of the picture,
implementing 'disconnect immediate' interface only on a few components
(including request_queue) should suffice for most block device
drivers.  I'm not familiar with other drivers but I don't think
they'll be very different.

All in all, I'm hoping something like the following can be done in
device drivers, midlayer or low level.

* For binding

  alloc resources;
  init controller;
  register to upper layers;

* For unbinding

  unregister from upper layers; (no lingering references or objects)
  deinit controller;
  release resources;

This basically nullifies lifetime rule #b from the POV of drivers.


2-2. Rule #b and #c

One way to solve this problem is to subordinate lifetime rule #b to
rule #c.  Each kobject points to its owning module such that grabbing
a kobject automatically grabs the module.  The problem with this
approach is that it requires wide update and makes kobject_get
heavier.

Another more appealing approach is to do nothing.  Solving the problem
between rule #a and #b in the way described above means virtually
nullifying rule #b.  With rule #b gone, rule #c can't conflict with
it.  IOW, no reference from upper layer would be remaining after a
driver unregisters itself from the upper layer - the module can be
safely unloaded.


3. How do we get there from here?

The current device driver model is used by most device drivers - huge
amount of code.  We can't update them at once.  Fortunately, the
suggested solution can easily be implemented gradually.  We can add
'disconnect now' interface to upper driver interface one-by-one and
convert its users gradually.  The existing reference counting
mechanism can be left alone and used to verify that the conversion is
correct by verifying reference count is 0 after unregistering.

Once the conversion is complete (maybe after a year), we can remove
the reference counting mechanism from device driver interface.


4. Some afterthoughts

* Doing this would make module reference counting more flexible.
  Instead of being confined by implementation, it can be used to
  define when to allow and disallow module unloading.  (you can't
  unload a block driver module if a fs on it is mounted but sysfs
  access doesn't matter.)

* Outside of device driver model, kobject is currently used to supply
  something sysfs nodes can be attached to, such that both the
  information supplier and node users have something common to
  reference count.  With orphaning added, there is no need to use
  kobject this way.  IMHO, kobject should have been implementation
  detail inside the device model proper in the first place.

Thanks.

-- 
tejun
