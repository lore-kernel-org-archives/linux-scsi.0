From: Douglas Gilbert <dougg@torque.net>
Subject: [RFC] SCSI Hotplug for lk 2.5
Date: Thu, 01 Aug 2002 18:57:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D49BCDB.392ACAA4@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dial4.torque.net [204.138.244.14])
	by gear.torque.net (8.9.3/8.9.3) with ESMTP id TAA06046
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2002 19:07:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

                 SCSI Hotplug for lk 2.5

The direction the lk 2.5 series is moving is to do things like
device scanning, persistent mapping and other administrative
tasks in the user space, where practical.
To this end we need driverfs to:
	- work out a device naming strategy
	- add its class hierarchy
	- allow drivers to set and show parameters (and perhaps
	  state)
	- settle down
While this is happening perhaps we can discuss the design of
the SCSI Hotplug logic.

The hotplug subsystem provides an established mechanism for
drivers in the kernel to inform user space programs primarily
that a new device has been "hot plugged" or "hot unplugged". It
is used extensively by the USB subsystem in the lk 2.4 series.
This idea might be extended to provide user space alerts for
important state changes in a device (e.g. removable media
inserted).

Here are five categories of SCSI events that are candidates for
hotplug alerts:
	1) scsi (lower level) driver addition or removal
	2) scsi host (initiator) addition or removal
	3) scsi device (target/lun) addition or removal
	4) removable media addition or removal
	5) unit attention or "asynchronous event notification"
I believe hotplug alerts for 2) and 3) are required; for 1)
is questionable and for 4) + 5) would be "nice to have".

The existing /sbin/hotplug subsystem would be called from the
kernel space with a first "command line" parameter of "scsi"
with the following environment variables:
	ACTION		add | remove [ | event {for UA or AEN} ]
	CATEGORY	DRIVER | HOST | TARGET | MEDIA | EVENT
	TARGET_PATH	{for categories TARGET, MEDIA and EVENT}
	HOST_PATH	{for categories MEDIA, TARGET, and HOST}
	DRIVER_PATH	{for all categories}
	PERIPHERAL_TYPE	{for categories MEDIA and TARGET}
	SCSI_LEVEL	{for categories MEDIA and TARGET}
	SCSI_PROTOCOL	SPI | FC | USB_MASS_STORAGE | SBP | SAS ...
	.....
	VENDOR
	PRODUCT
	REVISION

There is a trade-off between how much information is passed to
/sbin/hotplug as environment variables and how much is available
from driverfs and other sources. Timing of the alerts is important:
the ACTION=add should be as late as possible so that all driverfs
information is available (and upper level drivers have attached
to the device ?). 

ACTION=remove (apart from media) comes with no additional
driverfs (or other kernel) information because the 
host/device is gone :-) In the scsimon driver (see note c) ) there 
is the notion of ADDITION_SEQNO and REMOVAL_SEQNO to track attaches 
and detaches (in this case of hosts and targets). Sequence numbers are
easy (and SMP safe) to implement in the kernel and could act as a
key for user space programs that are tracking the state of host
and device attachments.

Comments?


Notes:
  a)	SCSI host and device hotplug alerts could be added relatively
	easily to the scsi mid level
  b)	The "..._PATH" environment variables would be relative
	paths into the driverfs tree. For example:
		TARGET_PATH="root/pci0/00:0c.0/scsi1/1:0:0:0"
		DRIVER_PATH="bus/scsi/drivers/aic7xxx"
  c)	scsimon is an optional upper level scsi subsystem driver
	described at http://www.torque.net/scsi/scsimon.html
	Linus has made it clear that he thinks this driver does too
	much in the kernel space (e.g. holding trailing device state).
	It has an example of generating hotplug alerts, see 
	sm_call_policy() [which should use snprintf() in lk 2.5]
  d)	James Bottomley would like to do as much scanning and
	device identification as possible in the user space. I still
	think the mid level needs to do a 36 byte INQUIRY (the LLDDs
	may want to see a longer inquiry) and perhaps looks for
	INQUIRY VPD page=0x83
  e)	for multipath devices I would expect a hotplug alert for
	each path a device is discovered on (perhaps this is not
	practical)	
  f)	this document was written when lk 2.5.29 was current.
	lk 2.5.30 has just been released with driverfs patches
	that address some of the issues mentioned above


Doug Gilbert
1st August 2002

