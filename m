From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support [0/4]
Date: Mon, 14 Apr 2003 11:37:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414183759.GA4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:15793 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263706AbTDNSYh (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 14:24:37 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mochel@osdl.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

This patch set is against 2.5.67 current. It will not apply to scsi-miscs-2.5
as the decl_subsys macro has added a third argument.

This patch set changes the sysfs support for scsi hosts.
- Removes the previous support of shost_devclass device class.

- Modifies scsi_debug to support the new order of object cleanup and also
  changes the structure of sdebug_host_info to help in object cleanup.

- Creates a scsi subsystem. This is rooted at the top of the sysfs tree.

- Creates a scsi_host subsystem under the scsi subsystem. Modified the
  cleanup in scsi remove host. Switched to a kobject embedded in
  scsi_host. If a driver has not be converted to the driver model or does
  not use the scsi_set_device call it will still show up in the scsi_host
  subsystem, but will not have a symlink to the parent.

The usage of driver model classes for scsi hosts was removed because many
of our drivers have not been converted to the driver model so this gave an
inconsistent model to count on for cleanup and migration of some the
procfs support. I tried adding some fake structures to use classes, but it
failed to cleanup properly do to asymmetric cleanup interfaces in the core
code and also did not seem like the correct direction to go.

This change allows for host cleanup when sysfs references drop to zero
(there still needs be work done on scsi mid get / put calls).

I have tested the insmod / rmmod cycle with scsi_debug and booted with the
ips and aic drivers.

Current Known Issues:
	- Current users of scsi_remove_host will need to have there
	  cleanup reordered to support the restoration of the call to the
	  Scsi_Host_Template release.
	- Callers of scsi_set_device should be migrated off this interface
	  if possible.
	- Need better name for symlink than adapter.
	
Example tree:

[root@elm3a49 sys]# tree -d scsi
scsi
`-- scsi_host
    |-- host0
    |   |-- 0:0:0:0
    |   |   |-- 0:0:0:0:gen
    |   |   `-- block -> ../../../../block/sda
    |   |-- 0:0:15:0
    |   |   `-- 0:0:15:0:gen
    |   |-- 0:0:1:0
    |   |   |-- 0:0:1:0:gen
    |   |   `-- block -> ../../../../block/sdb
    |   |-- 0:1:15:0
    |   |   `-- 0:1:15:0:gen
    |   `-- adapter -> ../../../devices/pci0/00:09.0
    |-- host1
    |   `-- adapter -> ../../../devices/pci1/01:03.0
    |-- host3
    |   |-- 3:0:0:0
    |   |   |-- 3:0:0:0:gen
    |   |   `-- block -> ../../../../block/sdc
    |   `-- adapter -> ../../../devices/pseudo_0/adapter0
    `-- host4
        |-- 4:0:0:0
        |   |-- 4:0:0:0:gen
        |   `-- block -> ../../../../block/sdd
        |-- 4:0:4:0
        |   |-- 4:0:4:0:gen
        |   |-- 4:0:4:0:mt
        |   |-- 4:0:4:0:mta
        |   |-- 4:0:4:0:mtan
        |   |-- 4:0:4:0:mtl
        |   |-- 4:0:4:0:mtln
        |   |-- 4:0:4:0:mtm
        |   |-- 4:0:4:0:mtmn
        |   `-- 4:0:4:0:mtn
        |-- 4:0:5:0
        |   |-- 4:0:5:0:gen
        |   `-- block -> ../../../../block/sr0
        `-- adapter -> ../../../devices/pci1/01:03.1

-andmike
--
Michael Anderson
andmike@us.ibm.com

