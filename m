From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [-v3 PATCH 0/3] Persistent device name using alias
Date: Thu, 25 Aug 2011 18:03:59 +0900
Message-ID: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56249 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1HYJKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 05:10:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com

Hi,

This patch series provide an "alias" of the disk into kernel messages.

A raw device name of a disk does not always point a same disk at each boot-up
time. Therefore, users have to use persistent device names, which udev creates
to always access the same disk. However, kernel messages still display the raw
device names.

My proposal is that users can use and see persistent device names which were
assigned by themselves because users expect same name to point same disk
anytime.

Why need to modify kernel messages?
- We can see mapping of device names and persistent device names in udev log.
  If those logs output to syslog, we can search persistent device name from
  device name, but it can cause a large amount of syslog output.

- If we can use the persistent device names and can always see the same name on
  the kernel log, we don't need to pay additional cost for searching and picking
  a correct pair of device name and persistent device name from udev log.

- Kernel messages are output to serial console when kenel crashes, it's so hard
  to convert a device name to the alias.

Of course, I am going to modify the commands using device name so that users
can use an alias of the disk.

Changes in v3:
- "alias_name" was changed to "alias"
- The function to notify the partitions of uevent was deleted


How to use:
1. Build and install the kernel with this series, and reboot with the kernel.

2. Check device names.

[localhost]# cat /proc/partitions
major minor  #blocks  name

   8        0   12582912 sda
   8        1   12582878 sda1
   8        0    8388608 sdb
   8        1     512000 sdb1
   8        2    7875584 sdb2


3. Make a script of get alias

[localhost]# vi /lib/udev/get_alias
#!/bin/sh -e
DEVNAME=`echo $1 | sed -e 's/[0-9]//g'`
echo "ALIAS=`cat /sys/block/$DEVNAME/alias`"
exit 0

And you should set an execute bit,
[localhost]# chmod +x /lib/udev/get_alias

4. Check disk's id
Here is an example to get the serial id and the path of the device.
Some devices have not the serial id. Therefore, to identify a device,
users need to get the path of the device.

[localhost]# udevadm info --query=property --path=/sys/block/sda \
| grep ID_SERIAL=
ID_SERIAL=0QEMU_QEMU_HARDDISK_drive-scsi0-0-1

or you can also use the path of the device

[localhost]# udevadm info --query=property --path=/sys/block/sr0 \
| grep ID_PATH=
ID_PATH=pci-0000:00:01.1-scsi-1:0:0:0


5. Write udev rules as follows
(The user assigns "foo" to sda and "bar" to sr0)
We use ENV{ID_SERIAL} or ENV{ID_PATH} (get by 3) to identify a disk.
And to assign automatically an "alias", we use ATTR key.
If ENV{ALIAS} is empty, we use to get an "alias" by get_alias script.

[localhost]# vi /etc/udev/rules.d/70-persistent-alias.rules
SUBSYSTEM!="block", GOTO="end"
ATTR{alias}!="", GOTO="symlink"

# write alias for sdX
KERNEL=="sd*[!0-9]", ACTION=="add", ATTR{alias}="foo", \
ENV{ID_SERIAL}=="0QEMU_QEMU_HARDDISK_drive-scsi0-0-1"

# write alias for srX
KERNEL=="sr[0-9]", ACTION=="add", ATTR{alias}="bar", \
ENV{ID_PATH}=="pci-0000:00:01.1-scsi-1:0:0:0"

LABEL="symlink"

# make symlink
ENV{DEVTYPE}=="disk|partition", ENV{ALIAS}=="", \
IMPORT{program}="/lib/udev/get_alias %k"
ENV{DEVTYPE}=="disk", ENV{ALIAS}=="?*", SYMLINK+="disk/by-alias/$env{ALIAS}"
ENV{DEVTYPE}=="partition", ENV{ALIAS}=="?*", \
SYMLINK+="disk/by-alias/$env{ALIAS}%n"

LABEL="end"


6. reboot
After reboot, we can see aliases in kernel messages.

[localhost]# ls -l /dev/disk/by-alias/
total 0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 bar -> ../../sr0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 foo -> ../../sda
lrwxrwxrwx. 1 root root 10 Jul  1 21:21 foo1 -> ../../sda1

[localhost]# dmesg
...
sd 2:0:1:0: [sda] Attached SCSI disk
alias: assigned foo to sda
sd 2:0:1:0: [foo] Send: 0xffff88007a82cd00
sd 2:0:1:0: [foo] CDB: Write(10): 2a 00 01 58 0c 8a 00 00 08 00
buffer = 0xffff88007a82c500, bufflen = 4096, queuecommand 0xffffffffa00277fd
leaving scsi_dispatch_cmnd()
sd 2:0:1:0: [foo] Done: 0xffff88007a82cd00 SUCCESS
sd 2:0:1:0: [foo]  Result: hostbyte=DID_OK driverbyte=DRIVER_OK
sd 2:0:1:0: [foo] CDB: Write(10): 2a 00 01 58 0c 8a 00 00 08 00
...

When a new device is added, the udev appends a new rule manually.
In the future, it is appended automatically, as like NIC.

Best Regards,

---

Joe Perches (1):
      sd: modify printk for alias name

Nao Nishijima (2):
      sd: [cleanup] Use sd_printk() instead of printk()
      block: add a new attribute "alias" in gendisk


 Documentation/ABI/testing/sysfs-block |   13 ++++++
 block/genhd.c                         |   71 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c               |   26 ++++++++++++
 drivers/scsi/sd.c                     |   30 +++++++++++++-
 drivers/scsi/sd.h                     |    8 +---
 include/linux/genhd.h                 |    4 ++
 include/scsi/scsi_device.h            |    8 +---
 7 files changed, 147 insertions(+), 13 deletions(-)


--
Nao Nishijima (nao.nishijima.xt@hitachi.com)
