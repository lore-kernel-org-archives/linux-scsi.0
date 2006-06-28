From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: wide port off expander support
Date: Wed, 28 Jun 2006 16:07:23 -0700
Message-ID: <1151536043.16075.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:26337 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751760AbWF1XI2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 19:08:28 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5SN8RIe013837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 19:08:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k5SN8fJZ180538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 17:08:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k5SN8O53013053
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 17:08:24 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5SN8No1013007
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 17:08:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This patch allows for a wide port to wide port cascading expander
configuration

ie:
/sys/class/scsi_host/host0 # ~/tree-1.5.0/tree device
device
|-- phy-0:0
|   |-- port
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:0 -> ../../../../../class/sas_phy/phy-0:0
|   `-- uevent
|-- phy-0:1
|   |-- port
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:1 -> ../../../../../class/sas_phy/phy-0:1
|   `-- uevent
|-- phy-0:2
|   |-- port
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:2 -> ../../../../../class/sas_phy/phy-0:2
|   `-- uevent
|-- phy-0:3
|   |-- port
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:3 -> ../../../../../class/sas_phy/phy-0:3
|   `-- uevent
|-- phy-0:4
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:4 -> ../../../../../class/sas_phy/phy-0:4
|   `-- uevent
|-- phy-0:5
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:5 -> ../../../../../class/sas_phy/phy-0:5
|   `-- uevent
|-- phy-0:6
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:6 -> ../../../../../class/sas_phy/phy-0:6
|   `-- uevent
|-- phy-0:7
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_phy:phy-0:7 -> ../../../../../class/sas_phy/phy-0:7
|   `-- uevent
|-- port-0:0
|   |-- expander-0:0
|   |   |-- phy-0:0:0
|   |   |   |-- port
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:0
-> ../../../../../../../class/sas_phy/phy-0:0:0
|   |   |   `-- uevent
|   |   |-- phy-0:0:1
|   |   |   |-- port
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:1
-> ../../../../../../../class/sas_phy/phy-0:0:1
|   |   |   `-- uevent
|   |   |-- phy-0:0:10
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:10
-> ../../../../../../../class/sas_phy/phy-0:0:10
|   |   |   `-- uevent
|   |   |-- phy-0:0:11
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:11
-> ../../../../../../../class/sas_phy/phy-0:0:11
|   |   |   `-- uevent
|   |   |-- phy-0:0:12
|   |   |   |-- port
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:12
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:12
-> ../../../../../../../class/sas_phy/phy-0:0:12
|   |   |   `-- uevent
|   |   |-- phy-0:0:2
|   |   |   |-- port
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:2
-> ../../../../../../../class/sas_phy/phy-0:0:2
|   |   |   `-- uevent
|   |   |-- phy-0:0:3
|   |   |   |-- port
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:3
-> ../../../../../../../class/sas_phy/phy-0:0:3
|   |   |   `-- uevent
|   |   |-- phy-0:0:4
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:4
-> ../../../../../../../class/sas_phy/phy-0:0:4
|   |   |   `-- uevent
|   |   |-- phy-0:0:5
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:5
-> ../../../../../../../class/sas_phy/phy-0:0:5
|   |   |   `-- uevent
|   |   |-- phy-0:0:6
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:6
-> ../../../../../../../class/sas_phy/phy-0:0:6
|   |   |   `-- uevent
|   |   |-- phy-0:0:7
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:7
-> ../../../../../../../class/sas_phy/phy-0:0:7
|   |   |   `-- uevent
|   |   |-- phy-0:0:8
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:8
-> ../../../../../../../class/sas_phy/phy-0:0:8
|   |   |   `-- uevent
|   |   |-- phy-0:0:9
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_phy:phy-0:0:9
-> ../../../../../../../class/sas_phy/phy-0:0:9
|   |   |   `-- uevent
|   |   |-- port-0:0:0
|   |   |   |-- expander-0:1
|   |   |   |   |-- phy-0:1:0
|   |   |   |   |   |-- port
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:0
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:0
-> ../../../../../../../../../class/sas_phy/phy-0:1:0
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:1
|   |   |   |   |   |-- port
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:1
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:1
-> ../../../../../../../../../class/sas_phy/phy-0:1:1
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:10
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:10
-> ../../../../../../../../../class/sas_phy/phy-0:1:10
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:11
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:11
-> ../../../../../../../../../class/sas_phy/phy-0:1:11
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:12
|   |   |   |   |   |-- port
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:12
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:12
-> ../../../../../../../../../class/sas_phy/phy-0:1:12
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:2
|   |   |   |   |   |-- port
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:2
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:2
-> ../../../../../../../../../class/sas_phy/phy-0:1:2
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:3
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:3
-> ../../../../../../../../../class/sas_phy/phy-0:1:3
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:4
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:4
-> ../../../../../../../../../class/sas_phy/phy-0:1:4
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:5
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:5
-> ../../../../../../../../../class/sas_phy/phy-0:1:5
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:6
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:6
-> ../../../../../../../../../class/sas_phy/phy-0:1:6
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:7
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:7
-> ../../../../../../../../../class/sas_phy/phy-0:1:7
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:8
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:8
-> ../../../../../../../../../class/sas_phy/phy-0:1:8
|   |   |   |   |   `-- uevent
|   |   |   |   |-- phy-0:1:9
|   |   |   |   |   |-- port
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:9
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_phy:phy-0:1:9
-> ../../../../../../../../../class/sas_phy/phy-0:1:9
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:0
|   |   |   |   |   |-- end_device-0:1:0
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:0
-> ../../../../../../../../../../class/sas_device/end_device-0:1:0
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:0
-> ../../../../../../../../../../class/sas_end_device/end_device-0:1:0
|   |   |   |   |   |   |-- target0:0:1
|   |   |   |   |   |   |   |-- 0:0:1:0
|   |   |   |   |   |   |   |   |-- block:sda
-> ../../../../../../../../../../../../block/sda
|   |   |   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- driver
-> ../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:0:1:0
-> ../../../../../../../../../../../../class/scsi_device/0:0:1:0
|   |   |   |   |   |   |   |   |-- scsi_disk:0:0:1:0
-> ../../../../../../../../../../../../class/scsi_disk/0:0:1:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:0
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:0|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:0
-> ../../../../../../../../../class/sas_port/port-0:1:0
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:1
|   |   |   |   |   |-- end_device-0:1:1
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:1
-> ../../../../../../../../../../class/sas_device/end_device-0:1:1
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:1
-> ../../../../../../../../../../class/sas_end_device/end_device-0:1:1
|   |   |   |   |   |   |-- target0:1:2
|   |   |   |   |   |   |   |-- 0:1:2:0
|   |   |   |   |   |   |   |   |-- block:sdb
-> ../../../../../../../../../../../../block/sdb
|   |   |   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- driver
-> ../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:1:2:0
-> ../../../../../../../../../../../../class/scsi_device/0:1:2:0
|   |   |   |   |   |   |   |   |-- scsi_disk:0:1:2:0
-> ../../../../../../../../../../../../class/scsi_disk/0:1:2:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:1
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:1|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:1
-> ../../../../../../../../../class/sas_port/port-0:1:1
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:12
|   |   |   |   |   |-- end_device-0:1:12
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:12
-> ../../../../../../../../../../class/sas_device/end_device-0:1:12
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:12
-> ../../../../../../../../../../class/sas_end_device/end_device-0:1:12
|   |   |   |   |   |   |-- target0:12:5
|   |   |   |   |   |   |   |-- 0:12:5:0
|   |   |   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:12:5:0
-> ../../../../../../../../../../../../class/scsi_device/0:12:5:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:12
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:12
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:12
-> ../../../../../../../../../class/sas_port/port-0:1:12
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:2
|   |   |   |   |   |-- end_device-0:1:2
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:2
-> ../../../../../../../../../../class/sas_device/end_device-0:1:2
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:2
-> ../../../../../../../../../../class/sas_end_device/end_device-0:1:2
|   |   |   |   |   |   |-- target0:2:3
|   |   |   |   |   |   |   |-- 0:2:3:0
|   |   |   |   |   |   |   |   |-- block:sdc
-> ../../../../../../../../../../../../block/sdc
|   |   |   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- driver
-> ../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:2:3:0
-> ../../../../../../../../../../../../class/scsi_device/0:2:3:0
|   |   |   |   |   |   |   |   |-- scsi_disk:0:2:3:0
-> ../../../../../../../../../../../../class/scsi_disk/0:2:3:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:2
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:2|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:2
-> ../../../../../../../../../class/sas_port/port-0:1:2
|   |   |   |   |   `-- uevent
|   |   |   |   |-- port-0:1:9
|   |   |   |   |   |-- end_device-0:1:9
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- sas_device:end_device-0:1:9
-> ../../../../../../../../../../class/sas_device/end_device-0:1:9
|   |   |   |   |   |   |-- sas_end_device:end_device-0:1:9
-> ../../../../../../../../../../class/sas_end_device/end_device-0:1:9
|   |   |   |   |   |   |-- target0:9:4
|   |   |   |   |   |   |   |-- 0:9:4:0
|   |   |   |   |   |   |   |   |-- block:sdd
-> ../../../../../../../../../../../../block/sdd
|   |   |   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |   |   |-- driver
-> ../../../../../../../../../../../../bus/scsi/drivers/sd
|   |   |   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |   |   |-- model
|   |   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |   |   |-- scsi_device:0:9:4:0
-> ../../../../../../../../../../../../class/scsi_device/0:9:4:0
|   |   |   |   |   |   |   |   |-- scsi_disk:0:9:4:0
-> ../../../../../../../../../../../../class/scsi_disk/0:9:4:0
|   |   |   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |   |   |-- type
|   |   |   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   |   |   `-- vendor
|   |   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |   `-- uevent
|   |   |   |   |   |   `-- uevent
|   |   |   |   |   |-- phy-0:1:9
-> ../../../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/phy-0:1:9|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |-- sas_port:port-0:1:9
-> ../../../../../../../../../class/sas_port/port-0:1:9
|   |   |   |   |   `-- uevent
|   |   |   |   |-- power
|   |   |   |   |   |-- state
|   |   |   |   |   `-- wakeup
|   |   |   |   |-- sas_device:expander-0:1
-> ../../../../../../../../class/sas_device/expander-0:1
|   |   |   |   |-- sas_expander:expander-0:1
-> ../../../../../../../../class/sas_expander/expander-0:1
|   |   |   |   `-- uevent
|   |   |   |-- phy-0:0:0
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:0
|   |   |   |-- phy-0:0:1
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:1
|   |   |   |-- phy-0:0:2
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:2
|   |   |   |-- phy-0:0:3
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:3
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_port:port-0:0:0
-> ../../../../../../../class/sas_port/port-0:0:0
|   |   |   `-- uevent
|   |   |-- port-0:0:12
|   |   |   |-- end_device-0:0:12
|   |   |   |   |-- power
|   |   |   |   |   |-- state
|   |   |   |   |   `-- wakeup
|   |   |   |   |-- sas_device:end_device-0:0:12
-> ../../../../../../../../class/sas_device/end_device-0:0:12
|   |   |   |   |-- sas_end_device:end_device-0:0:12
-> ../../../../../../../../class/sas_end_device/end_device-0:0:12
|   |   |   |   |-- target0:12:0
|   |   |   |   |   |-- 0:12:0:0
|   |   |   |   |   |   |-- bus
-> ../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |-- delete
|   |   |   |   |   |   |-- device_blocked
|   |   |   |   |   |   |-- iocounterbits
|   |   |   |   |   |   |-- iodone_cnt
|   |   |   |   |   |   |-- ioerr_cnt
|   |   |   |   |   |   |-- iorequest_cnt
|   |   |   |   |   |   |-- model
|   |   |   |   |   |   |-- power
|   |   |   |   |   |   |   |-- state
|   |   |   |   |   |   |   `-- wakeup
|   |   |   |   |   |   |-- queue_depth
|   |   |   |   |   |   |-- queue_type
|   |   |   |   |   |   |-- rescan
|   |   |   |   |   |   |-- rev
|   |   |   |   |   |   |-- scsi_device:0:12:0:0
-> ../../../../../../../../../../class/scsi_device/0:12:0:0
|   |   |   |   |   |   |-- scsi_level
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   |-- subsystem
-> ../../../../../../../../../../bus/scsi
|   |   |   |   |   |   |-- timeout
|   |   |   |   |   |   |-- type
|   |   |   |   |   |   |-- uevent
|   |   |   |   |   |   `-- vendor
|   |   |   |   |   |-- power
|   |   |   |   |   |   |-- state
|   |   |   |   |   |   `-- wakeup
|   |   |   |   |   `-- uevent
|   |   |   |   `-- uevent
|   |   |   |-- phy-0:0:12
-> ../../../../../../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/expander-0:0/phy-0:0:12
|   |   |   |-- power
|   |   |   |   |-- state
|   |   |   |   `-- wakeup
|   |   |   |-- sas_port:port-0:0:12
-> ../../../../../../../class/sas_port/port-0:0:12
|   |   |   `-- uevent
|   |   |-- power
|   |   |   |-- state
|   |   |   `-- wakeup
|   |   |-- sas_device:expander-0:0
-> ../../../../../../class/sas_device/expander-0:0
|   |   |-- sas_expander:expander-0:0
-> ../../../../../../class/sas_expander/expander-0:0
|   |   `-- uevent
|   |-- phy-0:0
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:0
|   |-- phy-0:1
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:1
|   |-- phy-0:2
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:2
|   |-- phy-0:3
-> ../../../../../devices/pci0000:01/0000:01:02.0/host0/phy-0:3
|   |-- power
|   |   |-- state
|   |   `-- wakeup
|   |-- sas_port:port-0:0 -> ../../../../../class/sas_port/port-0:0
|   `-- uevent
|-- power
|   |-- state
|   `-- wakeup
|-- sas_host:host0 -> ../../../../class/sas_host/host0
|-- scsi_host:host0 -> ../../../../class/scsi_host/host0
`-- uevent

243 directories, 285 files

This patch has been compiled and tested on a x260 with a vitesse added
between the host and the existing expander.

--Alexis
 

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

------
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_expander.c	2006-06-28 15:39:00.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c	2006-06-28 15:40:16.000000000 -0700
@@ -524,10 +524,7 @@
 		if (!parent_ex->ex_port[i])
 			break;
 
-	parent_ex->ex_port[i] = port = sas_port_alloc(&parent->rphy->dev, i);
-	BUG_ON(!port);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(port) != 0);
+	parent_ex->ex_port[i] = port = parent_phy->port;
 
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *phy = &parent_ex->ex_phy[i];
@@ -544,8 +541,6 @@
 			child->max_linkrate = max(parent->max_linkrate,
 						  phy->linkrate);
 			child->pathways++;
-			BUG_ON(phy->port != NULL);
-			phy->port = port;
 			sas_port_add_phy(port, phy->phy);
 		}
 	}
@@ -574,6 +569,10 @@
 	child->iproto = phy->attached_iproto;
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
+	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
+	BUG_ON(!phy->port);
+	/* FIXME: better error handling*/
+	BUG_ON(sas_port_add(phy->port) != 0);
 	sas_ex_get_linkrate(parent, child, phy);
 
 	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
@@ -650,6 +649,7 @@
 	struct domain_device *child = NULL;
 	struct sas_rphy *rphy;
 	struct sas_expander_device *edev;
+	struct asd_sas_port *port;
 	int res;
 
 	if (phy->routing_attr == DIRECT_ROUTING) {
@@ -663,6 +663,12 @@
 	child = kzalloc(sizeof(*child), GFP_KERNEL);
 	if (!child)
 		return NULL;
+
+	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
+	/* FIXME: better error handling */
+	BUG_ON(sas_port_add(phy->port) != 0);
+
+
 	switch (phy->attached_dev_type) {
 	case EDGE_DEV:
 		rphy = sas_expander_alloc(phy->port,
@@ -676,11 +682,16 @@
 		rphy = NULL;	/* shut gcc up */
 		BUG();
 	}
+	port = parent->port;
+	port->phy = phy->phy;
+	port->port = phy->port;
 	child->rphy = rphy;
 	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
 	child->parent = parent;
-	child->port = parent->port;
+	port->port_dev = child;
+	child->port = port;
+	child->port->port = phy->port;
 	child->iproto = phy->attached_iproto;
 	child->tproto = phy->attached_tproto;
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
@@ -690,6 +701,7 @@
 	parent->port->disc.max_level = max(parent->port->disc.max_level,
 					   edev->level);
 	sas_init_dev(child);
+	sas_rphy_add(child->rphy);
 	res = sas_discover_expander(child);
 	if (res) {
 		kfree(child);
@@ -1345,6 +1357,9 @@
 
 			if (level == ex->level)
 				res = sas_ex_discover_devices(dev, -1);
+			else if (level > 0)
+				res = sas_ex_discover_devices(port->port_dev, -1);
+
 		}
 	}
 





