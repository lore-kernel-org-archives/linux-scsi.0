From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Tue, 8 Feb 2005 17:19:23 -0600
Message-ID: <20050208231923.GA30086@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:43905 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261682AbVBHXTb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2005 18:19:31 -0500
Content-Disposition: inline
In-Reply-To: <20050207182753.GA16526@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Mon, Feb 07, 2005 at 12:27:53PM -0600, Matt Domsch wrote:
> Below is a patch to add some hotplug infrastructure to the Linux SCSI
> subsystem.

I've added and reworked the megaraid_mbox driver to make use of this
new infrastructure.  I'll send that patch next.  The rest is unchanged
from yesterday.

I've put this work into a bkbits repo.  This is a clone of Linus's
linux-2.6, not of James' scsi-misc-2.6.
  
	bk pull http://mdomsch.bkbits.net/linux-2.6-scsi-hotplug

This will update the following files:

 Documentation/scsi/ChangeLog.megaraid  |  130 ++++++++
 drivers/scsi/Kconfig                   |   10 
 drivers/scsi/Makefile                  |    1 
 drivers/scsi/megaraid/Kconfig.megaraid |    1 
 drivers/scsi/megaraid/mega_common.h    |    3 
 drivers/scsi/megaraid/megaraid_ioctl.h |    1 
 drivers/scsi/megaraid/megaraid_mbox.c  |  500 +++++++++++++++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_mbox.h  |   28 +
 drivers/scsi/megaraid/megaraid_mm.c    |   39 ++
 drivers/scsi/megaraid/megaraid_mm.h    |    5 
 drivers/scsi/scsi_hotplug.c            |  138 +++++++++
 include/scsi/scsi_hotplug.h            |   41 ++
 12 files changed, 867 insertions, 30 deletions

through these ChangeSets:

<Matt_Domsch@dell.com> (05/02/08 1.2132.2.3)
   Release Date	: Tue Feb 08 12:27:22 EST 2005 - Matt Domsch <Matt_Domsch@dell.com>
   Current Version	: 2.20.4.6 (scsi module), 2.20.2.5 (cmm module)
   Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
   
   1.	Added two new megaraid_shost_attrs
   	/sys/class/scsi_host
   	|-- host0
   	|   |-- logical_drive_created
   	|   |-- logical_drive_destroyed
   	
   	and helper functions for them.  Written to from userspace by
   	a management application, these invoke SCSI hotplug
   	infrastructure for informing the kernel that a logical drive
   	has been created, or will be destroyed quite soon.
   	    echo "2" > logical_drive_created
           after creating logical drive #2 in the management app
   	    echo "4" > logical_drive_destroyed
   	immediately before destroying logical drive #4 in the
   	management app.  Eventually these functions should be called
   	directly from the management app.
   
   2.	Made class_device_megaraid_mbox_app_hndl and
           dev_attr_megaraid_mbox_ld static.
   
   Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

<Matt_Domsch@dell.com> (05/02/08 1.2132.2.2)
   megaraid_2.20.4.5.patch

<Matt_Domsch@dell.com> (05/02/07 1.2048.2.1)
   Below is a patch to add some hotplug infrastructure to the Linux SCSI
   subsystem.
   
   New files:
   include/scsi/scsi_hotplug.h
   drivers/scsi/scsi_hotplug.c
   implements a new exported function:
   
   extern int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
   			      unsigned int id, unsigned int lun, enum scsi_topology_action action);
   
   which invokes kobject_hotplug() on a temporary "scsi_topology"
   device.  This device represents a target that exists on a topology
   (i.e. was just inserted into a hot plug enclosure, or was just created
   by a RAID controller management application) but is not yet hooked
   into the kernel.
   
   In addition, two more infrastructure pieces are necessary:
   udev-050-scsi_topology.patch - adds the subsystem name "scsi_topology"
   to the list of devices *not* to wait for the creation of files in
   sysfs for - scsi_topology devices aren't to be registered in sysfs.
   
   /etc/hotplug/scsi_topology.agent
    handles the hotplug call, and invokes /sys/class/scsi_host/hostX/scan
    and /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.
   
   
   The flow is as follows:
   
   # echo "2" > /sys/class/scsi_host/host2/logical_drive_created
   (to be done by a management application that knows it just created
   logical drive #2 on the controller)
   
   megaraid_mbox.c sysfs method converts logical drive number to HCTL
   value, calls scsi_topology_hctl_action().
   
   scsi_topology_hctl_action() invokes kobject_hotplug() with a
   scsi_topology subsystem device.
   
   kobject_hotplug() calls /sbin/hotplug or /sbin/udevsend (more likely
   the latter), which invokes /etc/hotplug/scsi_topology.agent with the
   ACTION={add,remove}.
   
   scsi_topology.agent invokes /sys/class/scsi_host/hostX/scan or
    /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.
   
   From this point, we're back into known territory, with the device
   being made known, or deleted from, the kernel's view.
   
   Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>



-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
