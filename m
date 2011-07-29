From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH v2 0/3] Persistent device name using alias name
Date: Fri, 29 Jul 2011 18:09:29 +0900
Message-ID: <4E3278C9.7000703@hitachi.com>
References: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hi James,

Could you review this patches?

Best regards,

(2011/07/22 19:59), Nao Nishijima wrote:
> Hi,
>=20
> This patch series provide an "alias name" of the disk into kernel mes=
sages.
> Users can assign a preferred name to an alias name of the device.
>=20
> A raw device name of a disk does not always point a same disk at each=
 boot-up
> time. Therefore, users have to use persistent device names, which ude=
v creates
> to always access the same disk. However, kernel messages still displa=
y the raw
> device names.
>=20
> My proposal is that users can use and see persistent device names whi=
ch were
> assigned by they because users expect same name to point same disk an=
ytime.
>=20
> Why need to modify kernel messages?
> - We can see mapping of device names and persistent device names in u=
dev log.
>   If those logs output to syslog, we can search persistent device nam=
e from
>   device name, but it can cause a large amount of syslog output.
>=20
> - If we can use the persistent device names and can always see the sa=
me name on
>   the kernel log, we don't need to pay additional cost for searching =
and picking
>   a correct pair of device name and persistent device name from udev =
log.
>=20
> - Kernel messages are output to serial console when kenel crashes,
>   it's so hard to convert device name to alias name.
>=20
>=20
> Of course, I am going to modify the commands using device name so tha=
t users
> can use alias names.
>=20
>=20
> How to use:
> 1. Build and install the kernel with this series, and reboot with the=
 kernel.
>=20
> 2. Make a script of get alias_name
>=20
> [localhost]# vi /lib/udev/get_alias_name
> #!/bin/sh -e
> DEVNAME=3D`echo $1 | sed -e 's/[0-9]//g'`
> echo "ALIAS=3D`cat /sys/block/$DEVNAME/alias_name`"
> exit 0
>=20
> And you should set an execute bit,
> [localhost]# chmod +x /lib/udev/get_alias_name
>=20
> 3. Check disk's id
> Here is an example to get the serial id and the path of the device.
>=20
> [localhost]# udevadm info --query=3Dproperty --path=3D/sys/block/sda =
\
> | grep ID_SERIAL=3D
> ID_SERIAL=3D0QEMU_QEMU_HARDDISK_drive-scsi0-0-1
>=20
> Some devices does not have the serial id. For such devices,
> you may use the device path.
>=20
> [localhost]# udevadm info --query=3Dproperty --path=3D/sys/block/sr0 =
\
> | grep ID_PATH=3D
> ID_PATH=3Dpci-0000:00:01.1-scsi-1:0:0:0
>=20
>=20
> 4. Write udev rules as follows
> (The user assigns "foo" to sda and "bar" to sr0)
> We use ENV{ID_SERIAL} or ENV{ID_PATH} (get by 3) to identify a disk.
> And to assign automatically an "alias name", we use ATTR key.
> If ENV{ALIAS} is empty, we use to get an "alias_name" by get_alias_na=
me script.
>=20
> [localhost]# vi /etc/udev/rules.d/70-alias_name.rules
> SUBSYSTEM!=3D"block", GOTO=3D"end"
>=20
> # write alias name for sdX
> KERNEL=3D=3D"sd*[!0-9]", ACTION=3D=3D"add", ATTR{alias_name}=3D"foo",=
 \
> ENV{ID_SERIAL}=3D=3D"0QEMU_QEMU_HARDDISK_drive-scsi0-0-1"
>=20
> # write alias name for srX
> KERNEL=3D=3D"sr[0-9]", ACTION=3D=3D"add", ATTR{alias_name}=3D"bar", \
> ENV{ID_PATH}=3D=3D"pci-0000:00:01.1-scsi-1:0:0:0"
>=20
> # make symlink
> ENV{DEVTYPE}=3D=3D"disk", ENV{ALIAS}=3D=3D"?*", SYMLINK+=3D"disk/by-a=
lias/$env{ALIAS}"
> ENV{DEVTYPE}=3D=3D"partition", ENV{ALIAS}=3D=3D"", \
> IMPORT{program}=3D"/lib/udev/get_alias_name %k"
> ENV{DEVTYPE}=3D=3D"partition", ENV{ALIAS}=3D=3D"?*", \
> SYMLINK+=3D"disk/by-alias/$env{ALIAS}%n"
>=20
> LABEL=3D"end"
>=20
>=20
> 5. reboot
> After reboot, we can see alias name in kernel messages.
>=20
> [localhost]# ls -l /dev/disk/by-alias/
> total 0
> lrwxrwxrwx. 1 root root  9 Jul  1 21:21 bar -> ../../sr0
> lrwxrwxrwx. 1 root root  9 Jul  1 21:21 foo -> ../../sda
> lrwxrwxrwx. 1 root root 10 Jul  1 21:21 foo1 -> ../../sda1
>=20
> [localhost]# dmesg
> ...
> sd 2:0:0:0: [foo] sd_init_command: block=3D17382146, count=3D56
> sd 2:0:0:0: [foo] block=3D17382146
> sd 2:0:0:0: [foo] reading 56/56 512 byte blocks.
> sd 2:0:0:0: [foo] Send: 0xffff88007ab1a900=20
> ...
>=20
> Currently, the user must add the naming rule manually for new devices=
=2E
> In the future, it is appended automatically, as like NIC.
>=20
> Changes in v2:
> - Change alias_name string to pointer
> - Change alias_name writable to write at once
> - Drop procfs patch
>=20
> Best regards,
>=20
> ---
>=20
> Joe Perches (1):
>       sd: modify printk for alias name
>=20
> Nao Nishijima (2):
>       block: add a new attribute "alias name" in gendisk structure
>       sd: [BUGFIX] Use sd_printk instead of printk
>=20
>=20
>  Documentation/ABI/testing/sysfs-block |   15 ++++++
>  block/genhd.c                         |   84 +++++++++++++++++++++++=
++++++++++
>  drivers/scsi/scsi_lib.c               |   26 ++++++++++
>  drivers/scsi/sd.c                     |   30 +++++++++++-
>  drivers/scsi/sd.h                     |    8 +--
>  include/linux/genhd.h                 |    4 ++
>  include/scsi/scsi_device.h            |    8 +--
>  7 files changed, 162 insertions(+), 13 deletions(-)
>=20
>=20
> --
> Nao Nishijima (nao.nishijima.xt@hitachi.com)
>=20


--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
