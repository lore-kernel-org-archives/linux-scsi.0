From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 08 Jul 2011 17:45:47 +0900
Message-ID: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56296 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1GHIqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 04:46:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de

Hi,

This patch series provides an "alias name" of the disk into kernel and procfs
messages. The user can assign a preferred name to an alias name of the device.

Based on previous discussion (*), I changed patches as follows
- This is "alias name"
- An "alias name" is stored in gendisk struct
- Add document to Documentation/ABI/testing/sysfs-block
- When the user changes an "alias name", kernel notifies udev

(*) http://marc.info/?l=linux-scsi&m=130812625531219&w=2


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


3. Make a script of get alias_name

[localhost]# vi /lib/udev/get_alias_name
#!/bin/sh -e
DEVNAME=`echo $1 | sed -e 's/[0-9]//g'`
echo "ALIAS=`cat /sys/block/$DEVNAME/alias_name`"
exit 0

And you should set an execute bit,
[localhost]# chmod +x /lib/udev/get_alias_name

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
And to assign automatically an "alias name", we use ATTR key.
If ENV{ALIAS} is empty, we use to get an "alias_name" by get_alias_name script.

[localhost]# vi /etc/udev/rules.d/70-alias_name.rules
SUBSYSTEM!="block", GOTO="end"

# write alias name for sdX
KERNEL=="sd*[!0-9]", ACTION=="add", ATTR{alias_name}="foo", \
ENV{ID_SERIAL}=="0QEMU_QEMU_HARDDISK_drive-scsi0-0-1"

# write alias name for srX
KERNEL=="sr[0-9]", ACTION=="add", ATTR{alias_name}="bar", \
ENV{ID_PATH}=="pci-0000:00:01.1-scsi-1:0:0:0"

# make symlink
ENV{DEVTYPE}=="disk", ENV{ALIAS}=="?*", SYMLINK+="disk/by-alias/$env{ALIAS}"
ENV{DEVTYPE}=="partition", ENV{ALIAS}=="", \
IMPORT{program}="/lib/udev/get_alias_name %k"
ENV{DEVTYPE}=="partition", ENV{ALIAS}=="?*", \
SYMLINK+="disk/by-alias/$env{ALIAS}%n"

LABEL="end"


6. reboot
After reboot, we can see alias name in kernel and procfs messages.

[localhost]# ls -l /dev/disk/by-alias/
total 0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 bar -> ../../sr0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 foo -> ../../sda
lrwxrwxrwx. 1 root root 10 Jul  1 21:21 foo1 -> ../../sda1

[localhost]# dmesg
...
sd 2:0:1:0: [sda] Attached SCSI disk
alias_name: assigned foo to sda
EXT4-fs (foo1): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (foo1): mounted filesystem with ordered data mode. Opts: (null)
...

[localhost]# cat /proc/partitions
major minor  #blocks  name

   8        0   12582912 foo
   8        1   12582878 foo1
   8        0    8388608 sdb
   8        1     512000 sdb1
   8        2    7875584 sdb2



When a new device is added, the udev appends a new rule manually.
In the future, it is appended automatically, as like NIC.

TODO:
- Modify blkid to show "alias name"

Best Regards,

---

Nao Nishijima (4):
      sd: cleanup for alias name
      fs: modify disk_name() for alias name
      sd: modify printk for alias_name
      block: add a new attribute "alias name" in gendisk structure


 Documentation/ABI/testing/sysfs-block |   15 ++++++
 block/genhd.c                         |   85 +++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c                     |    7 ++-
 drivers/scsi/sd.h                     |    2 -
 fs/partitions/check.c                 |    6 +-
 include/linux/genhd.h                 |    4 ++
 include/scsi/scsi_device.h            |    3 +
 7 files changed, 114 insertions(+), 8 deletions(-)


--
Nao Nishijima (nao.nishijima.xt@hitachi.com)
