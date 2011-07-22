From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH v2 0/3] Persistent device name using alias name
Date: Fri, 22 Jul 2011 19:59:26 +0900
Message-ID: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, coughlan@redhat.com, kzak@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, greg@kroah.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, joe@perches.com
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch series provide an "alias name" of the disk into kernel messages.
Users can assign a preferred name to an alias name of the device.

A raw device name of a disk does not always point a same disk at each boot-up
time. Therefore, users have to use persistent device names, which udev creates
to always access the same disk. However, kernel messages still display the raw
device names.

My proposal is that users can use and see persistent device names which were
assigned by they because users expect same name to point same disk anytime.

Why need to modify kernel messages?
- We can see mapping of device names and persistent device names in udev log.
  If those logs output to syslog, we can search persistent device name from
  device name, but it can cause a large amount of syslog output.

- If we can use the persistent device names and can always see the same name on
  the kernel log, we don't need to pay additional cost for searching and picking
  a correct pair of device name and persistent device name from udev log.

- Kernel messages are output to serial console when kenel crashes,
  it's so hard to convert device name to alias name.


Of course, I am going to modify the commands using device name so that users
can use alias names.


How to use:
1. Build and install the kernel with this series, and reboot with the kernel.

2. Make a script of get alias_name

[localhost]# vi /lib/udev/get_alias_name
#!/bin/sh -e
DEVNAME=`echo $1 | sed -e 's/[0-9]//g'`
echo "ALIAS=`cat /sys/block/$DEVNAME/alias_name`"
exit 0

And you should set an execute bit,
[localhost]# chmod +x /lib/udev/get_alias_name

3. Check disk's id
Here is an example to get the serial id and the path of the device.

[localhost]# udevadm info --query=property --path=/sys/block/sda \
| grep ID_SERIAL=
ID_SERIAL=0QEMU_QEMU_HARDDISK_drive-scsi0-0-1

Some devices does not have the serial id. For such devices,
you may use the device path.

[localhost]# udevadm info --query=property --path=/sys/block/sr0 \
| grep ID_PATH=
ID_PATH=pci-0000:00:01.1-scsi-1:0:0:0


4. Write udev rules as follows
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


5. reboot
After reboot, we can see alias name in kernel messages.

[localhost]# ls -l /dev/disk/by-alias/
total 0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 bar -> ../../sr0
lrwxrwxrwx. 1 root root  9 Jul  1 21:21 foo -> ../../sda
lrwxrwxrwx. 1 root root 10 Jul  1 21:21 foo1 -> ../../sda1

[localhost]# dmesg
...
sd 2:0:0:0: [foo] sd_init_command: block=17382146, count=56
sd 2:0:0:0: [foo] block=17382146
sd 2:0:0:0: [foo] reading 56/56 512 byte blocks.
sd 2:0:0:0: [foo] Send: 0xffff88007ab1a900 
...

Currently, the user must add the naming rule manually for new devices.
In the future, it is appended automatically, as like NIC.

Changes in v2:
- Change alias_name string to pointer
- Change alias_name writable to write at once
- Drop procfs patch

Best regards,

---

Joe Perches (1):
      sd: modify printk for alias name

Nao Nishijima (2):
      block: add a new attribute "alias name" in gendisk structure
      sd: [BUGFIX] Use sd_printk instead of printk


 Documentation/ABI/testing/sysfs-block |   15 ++++++
 block/genhd.c                         |   84 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c               |   26 ++++++++++
 drivers/scsi/sd.c                     |   30 +++++++++++-
 drivers/scsi/sd.h                     |    8 +--
 include/linux/genhd.h                 |    4 ++
 include/scsi/scsi_device.h            |    8 +--
 7 files changed, 162 insertions(+), 13 deletions(-)


--
Nao Nishijima (nao.nishijima.xt@hitachi.com)
