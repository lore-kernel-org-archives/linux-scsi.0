From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi_sysfs_add_sdev(): uevent emission versus attribute creation
Date: Fri, 22 May 2009 14:01:21 +0200
Message-ID: <4A169411.1010600@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

drivers/scsi/scsi_sysfs.c::scsi_sysfs_add_sdev() is currently performing 
the following steps (and more) in this order:

   - add target device (parent of a logical unit device = sdev)
   - add sdev_gendev (...?)
   - add sdev

     These steps implicitly generate KOBJ_ADD uevents.  Userspace is
     rushing to look at the new devices and do something with them.
     Also, the driver core looks at the sdev and attaches command set
     drivers like sd to them.

     sd discovers the block device, partitions and so on, and adds its
     own sysfs representations.  KOBJ_ADD uevents happen for the block
     device(s).  Again, userspace gets busy looing at the new block
     devices.  It starts creating /dev/disk/by-* symlinks.

     After command set driver probes and hence device_add(sdev...) are
     done, scsi_sysfs_add_sdev proceeds:

   - add request queue related attributes beneath the gendev
   - bsg_register_queue
   - add SCSI host template attributes beneath the gendev
   - transport_add_device, which among else adds transport class
     related attributes

For many years now, the sbp2 driver has been providing a host template 
attribute which contains the SBP specific target identifier and logical 
unit identifier.  Userspace is taking this attribute to create the 
/dev/disk/by-id symlink.

That's obviously racy.  The sdev's attribute should already be there 
when the disk's and partitions' symlinks are going to be created.

Most of the time it works, at some occasions it fails because userspace 
was quicker than the kernel.  Actually, I heard that it's the other way 
around for many users:  Most of the time it _doesn't_ work for them.

How am I going to fix this?

a)  We could suppress uevents until after all attributes were added, and 
generate the uevents as the last step.  But the trouble is that this 
apparently requires modification of all upper layer drivers, since 
neither suppression nor replay of uevents propagate implicitly to child 
devices.  So that doesn't sound like a feasible plan.

b)  Add the attributes before device_add?  I can't see how though.

c)  Suppress ULD binding until after all attributes were created, and 
trigger driver core's driver matching/ binding as the last step in 
scsi_sysfs_add_sdev?
-- 
Stefan Richter
-=====-==--= -=-= =-==-
http://arcgraph.de/sr/
