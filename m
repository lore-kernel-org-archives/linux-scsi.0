From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 07 Feb 2005 13:22:29 -0600
Message-ID: <4207BFF5.4000404@us.ibm.com>
References: <20050207182753.GA16526@lists.us.dell.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050207182753.GA16526@lists.us.dell.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Matt Domsch wrote:
> Below is a patch to add some hotplug infrastructure to the Linux SCSI
> subsystem.
> 
> New files:
> include/scsi/scsi_hotplug.h
> drivers/scsi/scsi_hotplug.c
> implements a new exported function:
> 
> extern int scsi_topology_hctl_action(struct Scsi_Host *shost, unsigned int channel,
> 			      unsigned int id, unsigned int lun, enum scsi_topology_action action);
> 
> which invokes kobject_hotplug() on a temporary "scsi_topology"
> device.  This device represents a target that exists on a topology
> (i.e. was just inserted into a hot plug enclosure, or was just created
> by a RAID controller management application) but is not yet hooked
> into the kernel.
> 
> 
> In addition, two more infrastructure pieces are necessary:
> udev-050-scsi_topology.patch - adds the subsystem name "scsi_topology"
> to the list of devices *not* to wait for the creation of files in
> sysfs for - scsi_topology devices aren't to be registered in sysfs.
> 
> /etc/hotplug/scsi_topology.agent
>  handles the hotplug call, and invokes /sys/class/scsi_host/hostX/scan
>  and /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.
> 
> 
> The flow is as follows:
> 
> # echo "2" > /sys/class/scsi_host/host2/logical_drive_created
> (to be done by a management application that knows it just created
> logical drive #2 on the controller)
> 
> megaraid_mbox.c sysfs method converts logical drive number to HCTL
> value, calls scsi_topology_hctl_action().
> 
> scsi_topology_hctl_action() invokes kobject_hotplug() with a
> scsi_topology subsystem device.
> 
> kobject_hotplug() calls /sbin/hotplug or /sbin/udevsend (more likely
> the latter), which invokes /etc/hotplug/scsi_topology.agent with the
> ACTION={add,remove}.
> 
> scsi_topology.agent invokes /sys/class/scsi_host/hostX/scan or
>  /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.
> 
> From this point, we're back into known territory, with the device
> being made known, or deleted from, the kernel's view.
> 
> Thoughts?

Just curious why the following flow would not work/be preferred:

1. echo "2" > /sys/class/scsi_host/host2/logical_drive_created
2. megaraid_mbox.c sysfs method converts logical drive number to HCTL 
value, calls scsi_add_device.
3. scsi_add_device works as it does today and generates hotplug events

-Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
