From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 05 May 2003 21:46:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB64F11.2030806@torque.net>
References: <20030505083315.GB8416@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:41484 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262143AbTEELbV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 07:31:21 -0400
In-Reply-To: <20030505083315.GB8416@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Here is update to the scsi host sysfs support. This patch uses the
> reworked class and class_device support.
> 
> This patch set is against scsi-misc-2.5.

Mike,
The set of 4 patches will apply against lk 2.5.69
with lots of offsets and at least one "fuzz 1".
It build for me and I'm running it now. A cleaner
version (against lk 2.5.69) would be good.

> This patch set changes the sysfs support for scsi hosts.
> - Removes the previous support of shost_devclass device class.
> 
> - Added support for sysfs class and class_device.
> 
> - scsi host now contains a struct device and will have its parent pointer
>   set to the device passed in to scsi_add_host, the device passed in to
>   scsi_set_device, or set to the legacy_bus.
> 
> - scsi_host class children list is now equal to scsi_host_list. scsi host
>   host_gendev children list is not equal to my_devices.
> 
> - Modifies scsi_debug to support the new order of object cleanup and also
>   changes the structure of sdebug_host_info to help in object cleanup.
> 
> This change allows for host cleanup when sysfs references drop to zero
> (there still is more work to be done).
> 
> I have tested the insmod / rmmod cycle with scsi_debug and booted with the
> ips and aic drivers.
> 
> Current Known Issues:
> 	- Current users of scsi_remove_host will need to have there
> 	  cleanup reordered to support the restoration of the call to the
> 	  Scsi_Host_Template release.
> 	- Callers of scsi_set_device should be migrated off this interface
> 	  if possible.
> 	
> Example tree:
> 
> # tree /sys/class/scsi_host
> /sys/class/scsi_host
> |-- host0
> |   |-- cmd_per_lun
> |   |-- device -> ../../../devices/pci0/00:09.0/host0
> |   |-- host_busy
> |   |-- sg_tablesize
> |   |-- unchecked_isa_dma
> |   `-- unique_id
> |-- host1
> |   |-- cmd_per_lun
> |   |-- device -> ../../../devices/pci1/01:03.0/host1
> |   |-- host_busy
> |   |-- sg_tablesize
> |   |-- unchecked_isa_dma
> |   `-- unique_id
> `-- host3
>     |-- cmd_per_lun
>     |-- device -> ../../../devices/pci1/01:03.1/host3
>     |-- host_busy
>     |-- sg_tablesize
>     |-- unchecked_isa_dma
>     `-- unique_id

What seems to be missing, at least in what I am
running here is a useful 'name'. There is no 'name'
file in the listing above (under each 'host<n>'
directory). There is a 'name' file in that 'device' (symlink)
directory but it is an empty file here.

> # tree /sys/bus/scsi/devices
> /sys/bus/scsi/devices
> |-- 0:0:0:0 -> ../../../devices/pci0/00:09.0/host0/0:0:0:0

So finally I can get some output from my
version of lsscsi (unreleased version 10):

$ lsscsi -Hl
[0]    ??
   cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
[1]    ??
   cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
[2]    ??
   cmd_per_lun=3    host_busy=0    sg_tablesize=64   unchecked_isa_dma=0
[3]    ??
   cmd_per_lun=5    host_busy=0    sg_tablesize=255  unchecked_isa_dma=0

Hosts 0 and 1 are the 2 HBAs on a Tekram 390u3w while
host 2 is a scsi_debug pseudo host and host3 is
ide-scsi. A name would be instructive.

$ lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
[3:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr0

Doug Gilbert


