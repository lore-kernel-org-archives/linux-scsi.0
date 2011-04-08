From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Fri, 08 Apr 2011 23:12:47 +0900
Message-ID: <4D9F17DF.5030601@hitachi.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp> <20110405161400.GA885@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20110405161400.GA885@kroah.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

Hi,

(2011/04/06 1:14), Greg KH wrote:
> On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
>> This patch series provides a SCSI option for persistent device
>> names in kernel. With this option, user can always assign a
>> same device name (e.g. sda) to a specific device according to
>> udev rules and device id.
>>
>> Issue:
>> Recently, kernel registers block devices in parallel. As a result,
>> different device names will be assigned at each boot time. This
>> will confuse file-system mounter, thus we usually use persistent
>> symbolic links provided by udev.
>=20
> Yes, that is what you should use if you care about this.
>=20
>> However, dmesg and procfs outputs
>> show device names instead of the symbolic link names. This causes
>> a serious problem when managing multiple devices (e.g. on a
>> large-scale storage), because usually, device errors are output
>> with device names on dmesg.
>=20
> Then fix your tools that read the output of these files to point to t=
he
> proper persistent name instead of trying to get the kernel to solve t=
he
> problem.
>=20

Yes, the tools should be revised if users get a device name using them.

The problem I would like to discuss here is that users can not identify
a disk from kernel messages when they DIRECTLY refer to these messages.
=46or example, a device name is used instead of a symbolic link names i=
n
bootup messages, I/O devices errors and /proc/partitions =E2=80=A6etc.

In particular, users can not identify an appropriate device from a
device name in syslog since different device name may be assigned to it
at each boot time.

My idea is able to fix this issue with small changes in scsi subsystem.
Also, it is implemented as an option. Therefore, it does not affect
users who do not select this option.


>> We also concern about some commands
>> which output device names, as well as kernel messages.
>=20
> What commands are you concerned about?
>=20

They are iostat, df, fdisk, parted and so on.
=46or example, the following sdc did not point a same disk.

# ls -l /dev/disk/by-id
=2E..
lrwxrwxrwx. 1 root root  9 Apr  8 11:17 wwn-0x50014ee057a61330 -> ../..=
/sdc
lrwxrwxrwx. 1 root root  9 Apr  8 11:17 wwn-0x50014ee204d3fcda -> ../..=
/sdd

# iostat
=2E..
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
=2E..
sdc               5.78        19.25        78.98     394124    1616821
sdd               7.66       893.45         0.86   18289518      17604

After rebooting, the same symbolic link name pointed different device n=
ame.


# ls -l /dev/disk/by-id
=2E..
lrwxrwxrwx. 1 root root  9 Apr  8 11:23 wwn-0x50014ee204d3fcda -> ../..=
/sdc
lrwxrwxrwx. 1 root root  9 Apr  8 11:23 wwn-0x50014ee057a61330 -> ../..=
/sdd


# iostat
=2E..
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
=2E..
sdc               7.65       892.22         0.86   18289518      17604
sdd               5.78        19.23        78.90     394124    1617447

>> Solution:
>> To assign a persistent device name, I create unnamed devices (not
>> a block device, but an intermediate device. users cannot read/write
>> this device). When scsi device driver finds a LU, the LU is register=
ed
>> as an unnamed device and inform to udev. After udev finds the unname=
d
>> device, udev assigns a persistent device name to a specific device
>> according to udev rules and registers it as a block device. Hence,
>> this is just a naming, not a renaming.
>=20
> Ick, so the kernel waits for userspace before you are able to use the
> device?  That sounds messy.
>=20

This option only affects the system where users selected it. Therefore,
I think that the unnamed device should not be available before users
give the name.


>> Some users are satisfied with current udev solution. Therefore, my
>> proposal is implemented as an option.
>>
>> If using this option, add the following kernel parameter.
>>
>> 	scsi_mod.persistent_name=3D1
>>
>> Also, if you want to assign a device name with sda, add the
>> following udev rules.
>>
>> SUBSYSTEM=3D=3D"scsi_unnamed", ATTR{disk_id}=3D=3D"xxx", PROGRAM=3D"=
/bin/sh
>> -c 'echo -n sda > /sys/%p/disk_name'"
>>
>> Todo:
>> - usb support
>=20
> Why?  USB uses scsi, so why would it not work as-is today?  What abou=
t
> libata devices?
>=20

Sorry, my explanation was not sufficient.
It is required to get scsi id using a scsi inguiry command in order to
create the udev rule, especially in ATTR(disk_id) item in it. The USB
devices, however, do not respond to the command and we can not get thei=
r
scsi id.


>> - hot-remove support
>=20
> So once you have assigned a name and the device is removed bad things
> happen?  What is the problem with this?
>=20

I am deeply sorry for that I forgot including the release function in
this patch.


> Note, any review of the code below does not imply that I agree with t=
he
> ideas here at all.  In fact, I really don't like this idea at all, bu=
t I
> might as well review the code anyway for your future contributions :)
>=20

I am profoundly grateful for your review :)


>>
>> I've already started discussion about device naming at LKML.
>> https://lkml.org/lkml/2010/10/8/31
>>
>> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
>> ---
>>
>>  drivers/scsi/Makefile       |    1=20
>>  drivers/scsi/scsi_sysfs.c   |   26 +++
>>  drivers/scsi/scsi_unnamed.c |  340 ++++++++++++++++++++++++++++++++=
+++++++++++
>>  drivers/scsi/scsi_unnamed.h |   25 +++
>>  4 files changed, 387 insertions(+), 5 deletions(-)
>>  create mode 100644 drivers/scsi/scsi_unnamed.c
>>  create mode 100644 drivers/scsi/scsi_unnamed.h
>>
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 7ad0b8a..782adc1 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -167,6 +167,7 @@ scsi_mod-$(CONFIG_SYSCTL)	+=3D scsi_sysctl.o
>>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+=3D scsi_proc.o
>>  scsi_mod-y			+=3D scsi_trace.o
>>  scsi_mod-$(CONFIG_PM)		+=3D scsi_pm.o
>> +scsi_mod-y			+=3D scsi_unnamed.o
>> =20
>>  scsi_tgt-y			+=3D scsi_tgt_lib.o scsi_tgt_if.o
>> =20
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index e44ff64..7959f5d 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -22,6 +22,7 @@
>> =20
>>  #include "scsi_priv.h"
>>  #include "scsi_logging.h"
>> +#include "scsi_unnamed.h"
>> =20
>>  static struct device_type scsi_dev_type;
>> =20
>> @@ -393,13 +394,27 @@ int scsi_sysfs_register(void)
>>  {
>>  	int error;
>> =20
>> +	error =3D scsi_unnamed_register(&scsi_bus_type);
>> +	if (error)
>> +		goto cleanup;
>> +
>>  	error =3D bus_register(&scsi_bus_type);
>> -	if (!error) {
>> -		error =3D class_register(&sdev_class);
>> -		if (error)
>> -			bus_unregister(&scsi_bus_type);
>> -	}
>> +	if (error)
>> +		goto cleanup_scsi_unnamed;
>> +
>> +	error =3D class_register(&sdev_class);
>> +	if (error)
>> +		goto cleanup_bus;
>> +
>> +	return 0;
>> +
>> +cleanup_bus:
>> +	bus_unregister(&scsi_bus_type);
>> +
>> +cleanup_scsi_unnamed:
>> +	scsi_unnamed_unregister();
>> =20
>> +cleanup:
>>  	return error;
>>  }
>> =20
>> @@ -407,6 +422,7 @@ void scsi_sysfs_unregister(void)
>>  {
>>  	class_unregister(&sdev_class);
>>  	bus_unregister(&scsi_bus_type);
>> +	scsi_unnamed_unregister();
>>  }
>> =20
>>  /*
>> diff --git a/drivers/scsi/scsi_unnamed.c b/drivers/scsi/scsi_unnamed=
=2Ec
>> new file mode 100644
>> index 0000000..ed96945
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_unnamed.c
>> @@ -0,0 +1,340 @@
>> +/*
>> + * scsi_unnamed.c - SCSI driver for unnmaed device
>> + *
>> + * Copyright: Copyright (c) Hitachi, Ltd. 2011
>> + *            Authors: Nao Nishijima <nao.nishijima.xt@hitachi.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; either version 2 of the License, o=
r
>> + * (at your option) any later version.
>=20
> Do you _REALLY_ mean "any later version?  Are you sure about that?  I=
f
> so, fine, just be careful please.
>=20

OK, I will remove those paragraph.

>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public Licens=
e
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 =
USA
>=20
> Unless you wish to track the movements of the FSF's office space for =
the
> next 40+ years and keep this file up to date, just remove this paragr=
aph
> please.
>=20

OK, I will remove those paragraph.


>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/device.h>
>> +#include <linux/slab.h>
>> +#include <linux/kobject.h>
>> +#include <linux/kdev_t.h>
>> +#include <linux/sysdev.h>
>> +#include <linux/list.h>
>> +#include <linux/wait.h>
>> +
>> +#include <scsi/scsi_driver.h>
>> +#include <scsi/scsi_device.h>
>> +#include <scsi/scsi.h>
>> +
>> +#define MAX_BUFFER_LEN	256
>> +#define DISK_NAME_LEN	32
>=20
> Why this limitation?
>=20

Device name limitation which used kernel is 32.

include/linux/genhd.h
=2E..
#define DISK_NAME_LEN                   32
=2E..
struct gendisk {
=2E..
char disk_name[DISK_NAME_LEN];  /* name of major driver */

I will include genhd.h.


>> +
>> +#define SCSI_ID_BINARY	1
>> +#define SCSI_ID_ASCII	2
>> +#define SCSI_ID_UTF8	3
>> +
>> +static LIST_HEAD(su_list);
>> +static DEFINE_MUTEX(su_list_lock);
>> +
>> +static int persistent_name;
>> +MODULE_PARM_DESC(persistent_name, "SCSI unnamed device support");
>> +module_param(persistent_name, bool, S_IRUGO);
>=20
> Why is this a module parameter?
>=20

I implemented this idea as an option.


>> +
>> +static struct class su_sysfs_class =3D {
>> +	.name	=3D "scsi_unnamed",
>> +};
>=20
> Why a static class?  What is it used for?  If you are adding sysfs
> files, you need to also add Documentation/ABI/ entries at the same ti=
me.
> Please do that if you really are adding new sysfs files.
>=20

OK, I have a rethink on it.

>> +
>> +struct scsi_unnamed {
>> +	struct list_head list;
>> +	struct device dev;
>> +	char disk_name[DISK_NAME_LEN];
>> +	char disk_lun[MAX_BUFFER_LEN];
>> +	char disk_id[MAX_BUFFER_LEN];
>> +	bool assigned;
>> +};
>> +
>> +#define to_scsi_unnamed(d) \
>> +	container_of(d, struct scsi_unnamed, dev)
>> +
>> +/* Get device identification VPD page */
>> +static void store_disk_id(struct scsi_device *sdev, char *disk_id)
>> +{
>> +	unsigned char *page_83;
>> +	int page_len, id_len, j =3D 0, i =3D 8;
>> +	static const char hex_str[] =3D "0123456789abcdef";
>=20
> Don't we have functions that do this already?
>=20

I will use pack_hex_byte(), thanks.

>> +
>> +	page_83 =3D kmalloc(MAX_BUFFER_LEN, GFP_KERNEL);
>> +	if (!page_83)
>> +		return;
>> +
>> +	if (scsi_get_vpd_page(sdev, 0x83, page_83, MAX_BUFFER_LEN))
>> +		goto err;
>> +
>> +	page_len =3D ((page_83[2] << 8) | page_83[3]) + 4;
>> +	if (page_len > 0) {
>> +		if ((page_83[5] & 0x30) !=3D 0)
>> +			goto err;
>> +
>> +		id_len =3D page_83[7];
>> +		if (id_len > 0) {
>> +			switch (page_83[4] & 0x0f) {
>> +			case SCSI_ID_BINARY:
>> +				while (i < id_len) {
>> +					disk_id[j++] =3D hex_str[(page_83[i]
>> +						& 0xf0) >> 4];
>> +					disk_id[j++] =3D hex_str[page_83[i]
>> +						& 0x0f];
>> +					i++;
>> +				}
>> +				break;
>> +			case SCSI_ID_ASCII:
>> +			case SCSI_ID_UTF8:
>> +				strncpy(disk_id, strim(page_83 + 8), id_len);
>> +				break;
>> +			default:
>> +				break;
>> +			}
>> +		}
>> +	}
>> +
>> +err:
>> +	kfree(page_83);
>> +	return;
>> +}
>> +
>> +static ssize_t show_disk_name(struct device *dev,
>> +			struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_name);
>> +}
>> +
>> +static ssize_t show_disk_lun(struct device *dev,
>> +			struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_lun);
>> +}
>> +
>> +static ssize_t show_disk_id(struct device *dev,
>> +			struct device_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%s\n", to_scsi_unnamed(dev)->disk_id);
>> +}
>> +
>> +/* Assign a persistent device name */
>> +static ssize_t store_disk_name(struct device *dev,
>> +		struct device_attribute *attr, char *buf, size_t count)
>> +{
>> +	struct scsi_unnamed *su =3D to_scsi_unnamed(dev);
>> +	struct scsi_unnamed *tmp;
>> +	struct device *lu =3D dev->parent;
>> +	int ret =3D -EINVAL;
>> +
>> +	if (count >=3D DISK_NAME_LEN) {
>> +		printk(KERN_WARNING "su: Too long a persistent name!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (su->assigned) {
>> +		printk(KERN_WARNING "su: Already assigned a persistent name!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (strncmp(lu->driver->name, buf, 2)) {
>> +		printk(KERN_WARNING "su: Wrong prefix!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&su_list_lock);
>> +	list_for_each_entry(tmp, &su_list, list) {
>> +		if (!strncmp(tmp->disk_name, buf, DISK_NAME_LEN)) {
>> +			printk(KERN_WARNING "su: Duplicate name exsists!\n");
>> +			return -EINVAL;
>> +		}
>> +	}
>> +	strncpy(su->disk_name, buf, DISK_NAME_LEN);
>> +	mutex_unlock(&su_list_lock);
>> +
>> +	if (!lu->driver->probe)
>> +		return -EINVAL;
>> +
>> +	lu->init_name =3D buf;
>> +
>> +	ret =3D lu->driver->probe(lu);
>> +	if (ret) {
>> +		lu->init_name =3D NULL;
>> +		su->disk_name[0] =3D '\0';
>> +		return ret;
>> +	}
>> +
>> +	su->assigned =3D true;
>> +	return count;
>> +}
>> +
>> +static DEVICE_ATTR(disk_name, S_IRUGO|S_IWUSR, show_disk_name,
>> +			store_disk_name);
>> +static DEVICE_ATTR(disk_lun, S_IRUGO, show_disk_lun, NULL);
>> +static DEVICE_ATTR(disk_id, S_IRUGO, show_disk_id, NULL);
>> +
>> +/* Confirm the driver name and the device type */
>> +static int check_device_type(char type, const char *name)
>> +{
>> +	switch (type) {
>> +	case TYPE_DISK:
>> +	case TYPE_MOD:
>> +	case TYPE_RBC:
>> +		if (strncmp("sd", name, 2))
>> +			return -ENODEV;
>> +		break;
>> +	case TYPE_ROM:
>> +	case TYPE_WORM:
>> +		if (strncmp("sr", name, 2))
>> +			return -ENODEV;
>> +		break;
>> +	case TYPE_TAPE:
>> +		if (strncmp("st", name, 2))
>> +			return -ENODEV;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/**
>> + * scsi_unnamed_probe - Setup the unnamed device.
>> + * @dev: parent scsi device
>> + *
>> + * This function adds a unnamed device to the device model and
>> + * gets a number of device information by scsi inquiry commands.
>> + * Udev identify a device by those information.
>> + *
>> + * Unnamed devices:
>> + * This device is not a block device and user can not read/write
>> + * this device. But it can advertise device information in sysfs.
>> + */
>> +int scsi_unnamed_probe(struct device *dev)
>> +{
>> +	struct scsi_unnamed *su;
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +	int ret =3D -EINVAL;
>> +	static int i;
>> +
>> +	if (check_device_type(sdev->type, dev->driver->name))
>> +		return -ENODEV;
>> +
>> +	su =3D kzalloc(sizeof(*su), GFP_KERNEL);
>> +	if (!su)
>> +		return -ENOMEM;
>> +
>> +	device_initialize(&su->dev);
>> +	su->dev.parent =3D dev;
>> +	su->dev.class =3D &su_sysfs_class;
>=20
> You just created a device that can not be removed from the system (i.=
e.
> you have no release function.)  This is a major bug and as per the
> documentation for kobjects and the driver model in the kernel tree, I=
 am
> allowed to mock this code mercilessly :)
>=20

Oh... sorry :(


>> +	dev_set_name(&su->dev, "su%d", i++);
>> +	strncpy(su->disk_lun, dev_name(dev), MAX_BUFFER_LEN);
>> +
>> +	ret =3D device_add(&su->dev);
>> +	if (ret)
>> +		goto err;
>> +
>> +	ret =3D device_create_file(&su->dev, &dev_attr_disk_name);
>=20
> Nope, you just raced with userspace here.  NEVER create a sysfs file
> after you have added it to the system.  Userspace just got notified o=
f
> the device and is already starting to read the file.  As it's not the=
re
> yet, you just failed :(
>=20
> Use attributes properly to keep this race from happening.
>=20

OK. I'll try to be more careful in future


>=20
>> +	if (ret)
>> +		goto err_disk_name;
>> +
>> +	ret =3D device_create_file(&su->dev, &dev_attr_disk_lun);
>> +	if (ret)
>> +		goto err_disk_lun;
>> +
>> +	store_disk_id(sdev, su->disk_id);
>> +	if (su->disk_id[0] !=3D '\0') {
>> +		ret =3D device_create_file(&su->dev, &dev_attr_disk_id);
>> +		if (ret)
>> +			goto err_disk_id;
>> +	}
>> +
>> +	su->assigned =3D false;
>> +	mutex_lock(&su_list_lock);
>> +	list_add(&su->list, &su_list);
>> +	mutex_unlock(&su_list_lock);
>> +
>> +	return 0;
>> +
>> +err_disk_id:
>> +	device_remove_file(&su->dev, &dev_attr_disk_lun);
>> +
>> +err_disk_lun:
>> +	device_remove_file(&su->dev, &dev_attr_disk_name);
>> +
>> +err_disk_name:
>> +	device_del(&su->dev);
>> +
>> +err:
>> +	kfree(su);
>> +	return ret;
>> +}
>> +
>> +/* Remove a unnamed device from su_list and release resources */
>> +void scsi_unnamed_remove(struct device *dev)
>> +{
>> +	struct scsi_unnamed *tmp;
>> +
>> +	mutex_lock(&su_list_lock);
>> +	list_for_each_entry(tmp, &su_list, list) {
>> +		if (dev =3D=3D tmp->dev.parent) {
>> +			list_del(&tmp->list);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&su_list_lock);
>> +
>> +	if (tmp->disk_id[0] !=3D '\0')
>> +		device_remove_file(&tmp->dev, &dev_attr_disk_id);
>> +	device_remove_file(&tmp->dev, &dev_attr_disk_name);
>> +	device_remove_file(&tmp->dev, &dev_attr_disk_lun);
>> +	device_del(&tmp->dev);
>=20
> Your kerrnel just spit out some very nasty messages when this functio=
n
> was called, right?  Why are you ignoring them?
>=20

Sorry. I will check it.


>> +
>> +	device_release_driver(dev);
>> +
>> +	kfree(tmp);
>> +}
>> +
>> +/**
>> + * copy_persistent_name - Copy the device name
>> + * @disk_name: allocate to
>> + * @dev: scsi device
>> + *
>> + * Copy an initial name of the device to disk_name.
>> + */
>> +int copy_persistent_name(char *disk_name, struct device *dev)
>> +{
>> +	if (persistent_name) {
>> +		strncpy(disk_name, dev->init_name, DISK_NAME_LEN);
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(copy_persistent_name);
>=20
> That's a very bad global function name.
>=20

I have a bad sense :(
I will name this function scsi_unnamed_copy_persistent_name.


> EXPORT_SYMBOL_GPL?  And why is it exported at all?  Who would ever ne=
ed
> to call this from a module?
>=20

Please see the patch 2/2. This function is called by external

>> +
>> +int scsi_unnamed_register(struct bus_type *bus)
>> +{
>> +	if (persistent_name) {
>> +		bus->probe =3D scsi_unnamed_probe;
>> +		bus->remove =3D scsi_unnamed_remove;
>> +		return class_register(&su_sysfs_class);
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(scsi_unnamed_register);
>=20
> Same here, why is this exported?
>=20
>> +
>> +void scsi_unnamed_unregister(void)
>> +{
>> +	if (persistent_name)
>> +		class_unregister(&su_sysfs_class);
>> +}
>> +EXPORT_SYMBOL(scsi_unnamed_unregister);
>=20
> And here.
>=20
>> diff --git a/drivers/scsi/scsi_unnamed.h b/drivers/scsi/scsi_unnamed=
=2Eh
>> new file mode 100644
>> index 0000000..ca4e852
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_unnamed.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + * scsi_unnamed.h - SCSI driver for unnmaed device
>> + *
>> + * Copyright: Copyright (c) Hitachi, Ltd. 2011
>> + *            Authors: Nao Nishijima <nao.nishijima.xt@hitachi.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; either version 2 of the License, o=
r
>> + * (at your option) any later version.
>=20
> Same comment as above.
>=20
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public Licens=
e
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 =
USA
>=20
> And again, same comment as above.
>=20
> thanks,
>=20
> greg k-h
>=20

Thanks,

--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
