From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 01:33:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505083315.GB8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:8657 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262057AbTEEISY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 04:18:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Patrick Mochel <mochel@osdl.org>

Here is update to the scsi host sysfs support. This patch uses the
reworked class and class_device support.

This patch set is against scsi-misc-2.5.

This patch set changes the sysfs support for scsi hosts.
- Removes the previous support of shost_devclass device class.

- Added support for sysfs class and class_device.

- scsi host now contains a struct device and will have its parent pointer
  set to the device passed in to scsi_add_host, the device passed in to
  scsi_set_device, or set to the legacy_bus.

- scsi_host class children list is now equal to scsi_host_list. scsi host
  host_gendev children list is not equal to my_devices.

- Modifies scsi_debug to support the new order of object cleanup and also
  changes the structure of sdebug_host_info to help in object cleanup.

This change allows for host cleanup when sysfs references drop to zero
(there still is more work to be done).

I have tested the insmod / rmmod cycle with scsi_debug and booted with the
ips and aic drivers.

Current Known Issues:
	- Current users of scsi_remove_host will need to have there
	  cleanup reordered to support the restoration of the call to the
	  Scsi_Host_Template release.
	- Callers of scsi_set_device should be migrated off this interface
	  if possible.
	
Example tree:

# tree /sys/class/scsi_host
/sys/class/scsi_host
|-- host0
|   |-- cmd_per_lun
|   |-- device -> ../../../devices/pci0/00:09.0/host0
|   |-- host_busy
|   |-- sg_tablesize
|   |-- unchecked_isa_dma
|   `-- unique_id
|-- host1
|   |-- cmd_per_lun
|   |-- device -> ../../../devices/pci1/01:03.0/host1
|   |-- host_busy
|   |-- sg_tablesize
|   |-- unchecked_isa_dma
|   `-- unique_id
`-- host3
    |-- cmd_per_lun
    |-- device -> ../../../devices/pci1/01:03.1/host3
    |-- host_busy
    |-- sg_tablesize
    |-- unchecked_isa_dma
    `-- unique_id

# tree /sys/bus/scsi/devices
/sys/bus/scsi/devices
|-- 0:0:0:0 -> ../../../devices/pci0/00:09.0/host0/0:0:0:0

-andmike
--
Michael Anderson
andmike@us.ibm.com

