From: Kay Sievers <kay.sievers@vrfy.org>
Subject: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 17:21:36 +0100
Message-ID: <1100622096.8606.104.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:39116 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S262029AbUKPQVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:21:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jejb@steeleye.com>

Hi,
the recent change to the scsi-sysfs interface broke the operation of
HAL:
  http://hal.freedesktop.org
  http://vrfy.org/projects/hal/HAL-fs-uuid-udi.png
  http://vrfy.org/projects/hal/hal-spec.html

We got an additional directory in the /devices directory which
changed:
  /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/1:0:0:0

to:
  /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/target1:0:0/1:0:0:0

The inserted "target1:0:0" is _not_ backed by any "bus" or "class" device
and therefore breaks the logic of HAL to bring the devices together by
its parent. (We also don't get hotplug events for the "target*" device at
creation time)

Is this intentional and we can not expected a straight chain of devices
anymore like it always was? Shouldn't there be a "class" device to have
it consistent again.

It's the usb-storage driver with an usb-stick.

Thanks,
Kay


[kay@pim ~]$ ls -l /sys/bus/scsi/devices/
total 0
lrwxrwxrwx  1 root root 0 Nov 16 05:40 1:0:0:0 -> ../../../devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/target1:0:0/1:0:0:0




[kay@pim ~]$ ls -l /sys/class/scsi*
/sys/class/scsi_device:
total 0
drwxr-xr-x  2 root root 0 Nov 16 05:27 1:0:0:0

/sys/class/scsi_generic:
total 0
drwxr-xr-x  2 root root 0 Nov 16 05:27 sg0

/sys/class/scsi_host:
total 0
drwxr-xr-x  2 root root 0 Nov 16 05:27 host1




[kay@pim ~]$ ls -l /sys/block/sda/
total 0
-r--r--r--  1 root root 4096 Nov 16 05:40 dev
lrwxrwxrwx  1 root root    0 Nov 16 05:40 device -> ../../devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/target1:0:0/1:0:0:0
drwxr-xr-x  3 root root    0 Nov 16 05:40 queue
-r--r--r--  1 root root 4096 Nov 16 05:40 range
-r--r--r--  1 root root 4096 Nov 16 05:40 removable
drwxr-xr-x  2 root root    0 Nov 16 05:40 sda1
-r--r--r--  1 root root 4096 Nov 16 05:40 size
-r--r--r--  1 root root 4096 Nov 16 05:40 stat



