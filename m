From: "Frkuska, Joshua" <joshua_frkuska@mentor.com>
Subject: Behavior for hot-plugging SD card in USB SD card reader
Date: Thu, 12 May 2016 23:02:05 +0900
Message-ID: <57348CDD.9000303@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45256 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbcELOCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 10:02:08 -0400
Received: from svr-orw-fem-02x.mgc.mentorg.com ([147.34.96.206] helo=SVR-ORW-FEM-02.mgc.mentorg.com)
	by relay1.mentorg.com with esmtp
	id 1b0rBn-0002VL-L1 from Joshua_Frkuska@mentor.com
	for linux-scsi@vger.kernel.org; Thu, 12 May 2016 07:02:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have two questions regarding the behavior for hot-plugging SD card in 
USB SD card reader relating to the scsi sub system.

Before the questions, the background and my understanding:

On the 3.14.y branch and later (not sure about 4.2+), when using a USB 
SD card reader with sd card inserted and filesystem mounted, there are 4 
possible cases for physical removal of the sd card. The first is when 
the card (not usb reader) is removed and the scsi device is not busy 
(being accessed). The second is with the sd card busy (being accessed) 
and then the sd card is removed. The 3rd and 4th are the similar but 
with the usb reader itself being removed with the sd card inserted. This 
mail focuses on the behavior of the second case where the sd card is 
busy and then removed.

If my understanding is correct, in the scenario above, access of the 
scsi disk block device keeps the reference count positive. This is 
followed by the removal of the sd card which in the non-busy case would 
make the reference count zero and allow the disk partitions to be 
unmounted. However in the busy case any new sd card inserted into the 
card reader should recalculate the geometry and allow the disk 
partitions to be discovered and be auto-mounted. However, it seems that 
the scsi disk reference count does not go to zero and we are unable to 
unmount the partition. A lazy unmount appears to occur leaving a stale 
device node. Similar behavior can be seen on inserting a USB flash based 
storage device and executing the same problem case. In the case of a USB 
flash drive, after hotplug and re-insertion, a new block device node 
gets assigned as the previous one is still busy. In the case of the SD 
card, a new block device node does not get created.

A simple recreation case is to use 'tail -f' on any file on the 
auto-mounted sd card file system, then remove the SD card and then 
insert a second different SD card. The second SD card does not 
auto-mount as one would first think. The device is not listed in MP 
shadow fblock nor mounted at all.

In the case of the USB flash drive, the host adapter is created, scsi 
bus scanned, finding the scsi device controller on the bus. The device 
controller responds to the scan and the scsi disk is populated with 
appropriate geometry sizes. This is provided to the block layer, then to 
the vfs which the auto-mounter picks up on and mounts the partitions. In 
the case of the USB SD card reader, when the card reader is plugged in 
without SD card populated, the scsi device controller is still found, 
root scsi disk node still created, but its geometry is 0 and the device 
is put in a NO_MEDIUM_INSERTED state. Any open attempts on the device 
node will fail with a NOMEDIUM error. Insertion of an SD card changes 
the reported geometry of the SCSI disk during a periodic scan, the 
NOMEDIUM state removed and disk information updated. As far as kernel 
events go, a 'change' and 'add' events are provided to up to userland.

When a USB flash drive is busy (being accessed) when hotplugged 
(removed), the partition remains mounted and root and subsequent 
re-insertion creates a new root scsi device node in sequential 
alphabetical order (e.g. /dev/sdb). The reason re-population of the scsi 
disk works in the USB case is due to the entire virtual host being 
destroyed and repopulated. This repopulates the parent device node after 
the device controller is scanned and found on the virtual scsi bus. In 
the case of the sd card, removal of the SD card only changes the medium 
inserted state and does not result in a scsi disk root node re-population.

I have two questions.

1. In the case of a USB card reader sd card being hotplugged while busy, 
is the current behavior desired? If so, why? An embedded system where 
the sd card reader is physically locked/mounted to the usb hub could see 
such a scenario if the sd card is being accessed during removal from the 
user. Such a usecase is possible on PC as well.
2. If this behavior should be more similar to a USB flash drive during 
hotplug what layer modifications would be necessary? (mass storage 
driver, scsi disk, scsi layer, block, etc)

I have a few ideas how this could be done but I would appreciate any 
additional thoughts or feedback regarding creating similar behavior to a 
usb hotplug.

The current thoughts I have are:

a.) change the behavior of the scsi disk layer in the case when the 
media is ejected with its user count not equal zero. The idea is to 
force drop (up and down the layer stack) the existing references to the 
disk so that it can be properly cleaned up and removed. This is a little 
different than the usb case above as the scsi device node will be re-used.
b.) Use a notifier chain to notify the usb mass storage driver to reset 
and re-instantiate the virtual host adapter. This would be the 
equivalent to what usb is doing at hotplug.
c.) let userspace handle the change events and handle it accordingly. (a 
number of ways, re-enumerate the hub, terminate offending apps using 
node and force unmount, etc.)

Thank you in advance

