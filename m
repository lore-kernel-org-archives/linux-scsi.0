From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Plug-n-Play & H/W RAID cards
Date: Fri, 11 Jun 2004 15:14:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23BD1@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:10475 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264129AbUFKTOU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 15:14:20 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i5BJEKX06115
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 12:14:20 -0700
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i5BJEJo30400
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 12:14:19 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have met with considerable resistance trying to add features to the =
2.6 tree drivers for various features we have grown used to in the 2.4 =
tree. These same features of plug-n-play activities are supported by ot=
her operating systems (Solaris, UnixWare, SCO, Windoze, Notware etc), b=
ut have been engineered out in the 2.6 SCSI tree.
=A0
The problem is the concept of the controller knowing more about the dev=
ice status than the device layers appears foreign. For instance, when a=
n array is created with `zero' initialization selected, the (array) dev=
ice comes online asynchronously at a later time. Also, when a (array) d=
evice goes offline, we know it *before* the failed reads or writes. The=
 controller also knows when a (array) device is degraded and should be =
attended to. Arrays go online and offline through management control, a=
nd we need the operating system to adjust to the current status of that=
 device.
=A0
Also, the current usage status of a device can be metered in most of th=
e other operating system SCSI layers, knowing if a device is busy will =
be used to warn the user when they try to perform array management func=
tions that could be detrimental to the operating system. It is full of =
race conditions, but this is acceptable at this level (ie, we all know =
that a user could click on a device to add to an array, then he could m=
ount the device, then he could actually commit the array creation). For=
merly we had a driver ioctl that could report the busy status for a sel=
ected target.
=A0
Detecting device busy status is now impossible in the 2.6 SCSI tree. Pa=
rt of the problem is that the entire device may have several partitions=
, some active some not, and knowing if any of those partitions are curr=
ently mounted or with active I/O would be `nice'. Probing *all* the ass=
ociated device nodes predicted for a specific logical device from user =
space takes several seconds, far too much time to perform the check whe=
n a mouse clicks. Especially problematic under various test scenarios w=
here this check is done when the machine is at or near 100% utilization=
=2E
=A0
As for devices going on-line or off-line, I have come to the conclusion=
 that the interfaces in the SCSI layer are not forthcoming, and are not=
 being exported. Previously we would perform a kernel space call to the=
 proc file system node /proc/scsi/scsi to notify the OS that the device=
 was to be added or removed. Maybe a different tactic should be taken. =
What if the Driver emulated a SAFTE device on the virtual bus created f=
or the Arrays, what user daemons are available currently that manage SA=
=46TE devices and properly notify the operating system of the managed d=
evice status? If not, no doubt I could create such an application; but =
what interfaces should it use to the OS to notify it of change of devic=
e status?
=A0
I look forward to any comments that can help us resolve these issues.
=A0
Sincerely - Mark Salyzyn
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
