From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Thu, 01 Jun 2006 16:40:30 -0500
Message-ID: <1149198030.3489.60.camel@mulgrave.il.steeleye.com>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
	 <447E0B78.5050700@torque.net>  <447F1425.3070205@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43986 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751014AbWFAVkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 17:40:46 -0400
In-Reply-To: <447F1425.3070205@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-06-01 at 12:21 -0400, Douglas Gilbert wrote:
> >>Also during the boot process on the x260 with an expander we see these
> >>printk's:
> >>sas: phy[n] matched wide port0
> >>If we are going to print this then we better be sure that this is truly
> >>a wide port.  It seems under the sys/class/ we have both a single
> >>port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
> >>although each phy seems to have the same sas_address the end_device
> >>attached to that phy have unique addresses.  My understanding is that a
> >>wide port has multiple phys with the same sas address and are attached
> >>to one end device.

Just for reference, this is what my x260 looks like:

./
  +-- phy-0:0/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:0@ -> ../../../../../class/sas_phy/phy-0:0
  |   +-- uevent
  +-- phy-0:1/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:1@ -> ../../../../../class/sas_phy/phy-0:1
  |   +-- uevent
  +-- phy-0:2/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:2@ -> ../../../../../class/sas_phy/phy-0:2
  |   +-- uevent
  +-- phy-0:3/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:3@ -> ../../../../../class/sas_phy/phy-0:3
  |   +-- uevent
  +-- phy-0:4/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:4@ -> ../../../../../class/sas_phy/phy-0:4
  |   +-- uevent
  +-- phy-0:5/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:5@ -> ../../../../../class/sas_phy/phy-0:5
  |   +-- uevent
  +-- phy-0:6/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:6@ -> ../../../../../class/sas_phy/phy-0:6
  |   +-- uevent
  +-- phy-0:7/
  |   +-- port@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_phy:phy-0:7@ -> ../../../../../class/sas_phy/phy-0:7
  |   +-- uevent
  +-- port-0:0/
  |   +-- expander-0:0/
  |   |   +-- phy-0-0:0/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:0@ -> ../../../../../../../class/sas_phy/phy-0-0:0
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:1/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:1@ -> ../../../../../../../class/sas_phy/phy-0-0:1
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:10/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:10@ -> ../../../../../../../class/sas_phy/phy-0-0:10
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:11/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:11@ -> ../../../../../../../class/sas_phy/phy-0-0:11
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:12/
  |   |   |   +-- port@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:12@ -> ../../../../../../../class/sas_phy/phy-0-0:12
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:2/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:2@ -> ../../../../../../../class/sas_phy/phy-0-0:2
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:3/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:3@ -> ../../../../../../../class/sas_phy/phy-0-0:3
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:4/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:4@ -> ../../../../../../../class/sas_phy/phy-0-0:4
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:5/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:5@ -> ../../../../../../../class/sas_phy/phy-0-0:5
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:6/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:6@ -> ../../../../../../../class/sas_phy/phy-0-0:6
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:7/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:7@ -> ../../../../../../../class/sas_phy/phy-0-0:7
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:8/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:8@ -> ../../../../../../../class/sas_phy/phy-0-0:8
  |   |   |   +-- uevent
  |   |   +-- phy-0-0:9/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-0:9@ -> ../../../../../../../class/sas_phy/phy-0-0:9
  |   |   |   +-- uevent
  |   |   +-- port-0:0:0/
  |   |   |   +-- end_device-0:0-0/
  |   |   |   |   +-- power/
  |   |   |   |   |   +-- state
  |   |   |   |   |   +-- wakeup
  |   |   |   |   +-- sas_device:end_device-0:0-0@ -> ../../../../../../../../class/sas_device/end_device-0:0-0
  |   |   |   |   +-- sas_end_device:end_device-0:0-0@ -> ../../../../../../../../class/sas_end_device/end_device-0:0-0
  |   |   |   |   +-- target0:0:0/
  |   |   |   |   |   +-- 0:0:0:0/
  |   |   |   |   |   |   +-- bus@ -> ../../../../../../../../../../bus/scsi
  |   |   |   |   |   |   +-- delete
  |   |   |   |   |   |   +-- device_blocked
  |   |   |   |   |   |   +-- iocounterbits
  |   |   |   |   |   |   +-- iodone_cnt
  |   |   |   |   |   |   +-- ioerr_cnt
  |   |   |   |   |   |   +-- iorequest_cnt
  |   |   |   |   |   |   +-- model
  |   |   |   |   |   |   +-- power/
  |   |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   |   +-- queue_depth
  |   |   |   |   |   |   +-- queue_type
  |   |   |   |   |   |   +-- rescan
  |   |   |   |   |   |   +-- rev
  |   |   |   |   |   |   +-- scsi_device:0:0:0:0@ -> ../../../../../../../../../../class/scsi_device/0:0:0:0
  |   |   |   |   |   |   +-- scsi_level
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- timeout
  |   |   |   |   |   |   +-- type
  |   |   |   |   |   |   +-- uevent
  |   |   |   |   |   |   +-- vendor
  |   |   |   |   |   +-- power/
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   +-- uevent
  |   |   |   |   +-- uevent
  |   |   |   +-- phy-0-0:12@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0-0:12
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_port:port-0:0:0@ -> ../../../../../../../class/sas_port/port-0:0:0
  |   |   |   +-- uevent
  |   |   +-- power/
  |   |   |   +-- state
  |   |   |   +-- wakeup
  |   |   +-- sas_device:expander-0:0@ -> ../../../../../../class/sas_device/expander-0:0
  |   |   +-- sas_expander:expander-0:0@ -> ../../../../../../class/sas_expander/expander-0:0
  |   |   +-- uevent
  |   +-- phy-0:0@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:0
  |   +-- phy-0:1@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:1
  |   +-- phy-0:2@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:2
  |   +-- phy-0:3@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:3
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_port:port-0:0@ -> ../../../../../class/sas_port/port-0:0
  |   +-- uevent
  +-- port-0:1/
  |   +-- expander-0:1/
  |   |   +-- phy-0-1:0/
  |   |   |   +-- port@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1/expander-0:1/port-0:1:0
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:0@ -> ../../../../../../../class/sas_phy/phy-0-1:0
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:1/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:1@ -> ../../../../../../../class/sas_phy/phy-0-1:1
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:10/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:10@ -> ../../../../../../../class/sas_phy/phy-0-1:10
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:11/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:11@ -> ../../../../../../../class/sas_phy/phy-0-1:11
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:12/
  |   |   |   +-- port@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1/expander-0:1/port-0:1:1
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:12@ -> ../../../../../../../class/sas_phy/phy-0-1:12
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:2/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:2@ -> ../../../../../../../class/sas_phy/phy-0-1:2
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:3/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:3@ -> ../../../../../../../class/sas_phy/phy-0-1:3
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:4/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:4@ -> ../../../../../../../class/sas_phy/phy-0-1:4
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:5/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:5@ -> ../../../../../../../class/sas_phy/phy-0-1:5
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:6/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:6@ -> ../../../../../../../class/sas_phy/phy-0-1:6
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:7/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:7@ -> ../../../../../../../class/sas_phy/phy-0-1:7
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:8/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:8@ -> ../../../../../../../class/sas_phy/phy-0-1:8
  |   |   |   +-- uevent
  |   |   +-- phy-0-1:9/
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_phy:phy-0-1:9@ -> ../../../../../../../class/sas_phy/phy-0-1:9
  |   |   |   +-- uevent
  |   |   +-- port-0:1:0/
  |   |   |   +-- end_device-0:0-0/
  |   |   |   |   +-- power/
  |   |   |   |   |   +-- state
  |   |   |   |   |   +-- wakeup
  |   |   |   |   +-- target0:0:1/
  |   |   |   |   |   +-- 0:0:1:0/
  |   |   |   |   |   |   +-- block:sda@ -> ../../../../../../../../../../block/sda
  |   |   |   |   |   |   +-- bus@ -> ../../../../../../../../../../bus/scsi
  |   |   |   |   |   |   +-- delete
  |   |   |   |   |   |   +-- device_blocked
  |   |   |   |   |   |   +-- driver@ -> ../../../../../../../../../../bus/scsi/drivers/sd
  |   |   |   |   |   |   +-- iocounterbits
  |   |   |   |   |   |   +-- iodone_cnt
  |   |   |   |   |   |   +-- ioerr_cnt
  |   |   |   |   |   |   +-- iorequest_cnt
  |   |   |   |   |   |   +-- model
  |   |   |   |   |   |   +-- power/
  |   |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   |   +-- queue_depth
  |   |   |   |   |   |   +-- queue_type
  |   |   |   |   |   |   +-- rescan
  |   |   |   |   |   |   +-- rev
  |   |   |   |   |   |   +-- scsi_device:0:0:1:0@ -> ../../../../../../../../../../class/scsi_device/0:0:1:0
  |   |   |   |   |   |   +-- scsi_disk:0:0:1:0@ -> ../../../../../../../../../../class/scsi_disk/0:0:1:0
  |   |   |   |   |   |   +-- scsi_level
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- timeout
  |   |   |   |   |   |   +-- type
  |   |   |   |   |   |   +-- uevent
  |   |   |   |   |   |   +-- vendor
  |   |   |   |   |   +-- power/
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   +-- uevent
  |   |   |   |   +-- uevent
  |   |   |   +-- phy-0-1:0@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1/expander-0:1/phy-0-1:0
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_port:port-0:1:0@ -> ../../../../../../../class/sas_port/port-0:1:0
  |   |   |   +-- uevent
  |   |   +-- port-0:1:1/
  |   |   |   +-- end_device-0:1-1/
  |   |   |   |   +-- power/
  |   |   |   |   |   +-- state
  |   |   |   |   |   +-- wakeup
  |   |   |   |   +-- sas_device:end_device-0:1-1@ -> ../../../../../../../../class/sas_device/end_device-0:1-1
  |   |   |   |   +-- sas_end_device:end_device-0:1-1@ -> ../../../../../../../../class/sas_end_device/end_device-0:1-1
  |   |   |   |   +-- target0:1:2/
  |   |   |   |   |   +-- 0:1:2:0/
  |   |   |   |   |   |   +-- bus@ -> ../../../../../../../../../../bus/scsi
  |   |   |   |   |   |   +-- delete
  |   |   |   |   |   |   +-- device_blocked
  |   |   |   |   |   |   +-- iocounterbits
  |   |   |   |   |   |   +-- iodone_cnt
  |   |   |   |   |   |   +-- ioerr_cnt
  |   |   |   |   |   |   +-- iorequest_cnt
  |   |   |   |   |   |   +-- model
  |   |   |   |   |   |   +-- power/
  |   |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   |   +-- queue_depth
  |   |   |   |   |   |   +-- queue_type
  |   |   |   |   |   |   +-- rescan
  |   |   |   |   |   |   +-- rev
  |   |   |   |   |   |   +-- scsi_device:0:1:2:0@ -> ../../../../../../../../../../class/scsi_device/0:1:2:0
  |   |   |   |   |   |   +-- scsi_level
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- timeout
  |   |   |   |   |   |   +-- type
  |   |   |   |   |   |   +-- uevent
  |   |   |   |   |   |   +-- vendor
  |   |   |   |   |   +-- power/
  |   |   |   |   |   |   +-- state
  |   |   |   |   |   |   +-- wakeup
  |   |   |   |   |   +-- uevent
  |   |   |   |   +-- uevent
  |   |   |   +-- phy-0-1:12@ -> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:1/expander-0:1/phy-0-1:12
  |   |   |   +-- power/
  |   |   |   |   +-- state
  |   |   |   |   +-- wakeup
  |   |   |   +-- sas_port:port-0:1:1@ -> ../../../../../../../class/sas_port/port-0:1:1
  |   |   |   +-- uevent
  |   |   +-- power/
  |   |   |   +-- state
  |   |   |   +-- wakeup
  |   |   +-- sas_device:expander-0:1@ -> ../../../../../../class/sas_device/expander-0:1
  |   |   +-- sas_expander:expander-0:1@ -> ../../../../../../class/sas_expander/expander-0:1
  |   |   +-- uevent
  |   +-- phy-0:4@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:4
  |   +-- phy-0:5@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:5
  |   +-- phy-0:6@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:6
  |   +-- phy-0:7@ -> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:7
  |   +-- power/
  |   |   +-- state
  |   |   +-- wakeup
  |   +-- sas_port:port-0:1@ -> ../../../../../class/sas_port/port-0:1
  |   +-- uevent
  +-- power/
  |   +-- state
  |   +-- wakeup
  +-- sas_host:host0@ -> ../../../../class/sas_host/host0
  +-- scsi_host:host0@ -> ../../../../class/scsi_host/host0
  +-- uevent

As you see: two wide ports over 8 phys on the HBA then three single
ports on the expanders for the two SES monitors and the one disk.

James


