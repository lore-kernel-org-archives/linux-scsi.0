From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Fri, 11 Nov 2011 23:50:06 +0900
Message-ID: <4EBD361E.5040106@hitachi.com>
References: <20111109162512.GB1260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailx.hitachi.co.jp ([133.145.228.49]:49128 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1KKPBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 10:01:09 -0500
In-Reply-To: <20111109162512.GB1260@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

=46inally, I understood why this patch is not acceptable and would like=
 to
solve the problem of the device name mismatch in *user space* using
udev. So, could you please give me your comment about it?

I aim to unify the device name because the name shown in command output
is different from it that users use for command execution.

So, I'd like to suggest that two new API should be added to udev.
- The API that returns any symlinks such as by-uuid, by id that users
  selected before if a device name is given as arguments
  If the commands directly access to proc filesystems, they cannot get
  the symlinks. These commands should get the device name via this API.
- The API that replaces device name to symlink in text messages
=E3=80=80=E3=80=80The dmesg and syslog messages include the raw device =
names such as
  sdX. They should be replaced with symlinks to unify the device names.
- udev support alias
  Symlinks (by-uuid, by-id =E2=80=A6) is too long, compared to before (=
e.g.
  sdX). I guess most of users need more friendly and short names.

Could you give me some advice or comments?
(I will post this idea udev mailing list with prototype code)

Thanks

(2011/11/10 1:25), Tejun Heo wrote:
> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
>=20
> The commit introduced alias for block devices which is intended to be
> used during logging although actual usage hasn't been committed yet.
> This approach adds very limited benefit (raw log might be easier to
> follow) which can be trivially implemented in userland but has a lot
> of problems.
>=20
> It is much worse than netif renames because it doesn't rename the
> actual device but just adds conveninence name which isn't used
> universally or enforced.  Everything internal including device lookup
> and sysfs still uses the internal name and nothing prevents two
> devices from using conflicting alias - ie. sda can have sdb as its
> alias.
>=20
> This has been nacked by people working on device driver core, block
> layer and kernel-userland interface and shouldn't have been
> upstreamed.  Revert it.
>=20
>  http://thread.gmane.org/gmane.linux.kernel/1155104
>  http://thread.gmane.org/gmane.linux.scsi/68632
>  http://thread.gmane.org/gmane.linux.scsi/69776
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  Documentation/ABI/testing/sysfs-block |   13 ------
>  block/genhd.c                         |   71 -----------------------=
----------
>  include/linux/genhd.h                 |    4 --
>  3 files changed, 0 insertions(+), 88 deletions(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/AB=
I/testing/sysfs-block
> index 2b5d561..c1eb41c 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -206,16 +206,3 @@ Description:
>  		when a discarded area is read the discard_zeroes_data
>  		parameter will be set to one. Otherwise it will be 0 and
>  		the result of reading a discarded area is undefined.
> -What:		/sys/block/<disk>/alias
> -Date:		Aug 2011
> -Contact:	Nao Nishijima <nao.nishijima.xt@hitachi.com>
> -Description:
> -		A raw device name of a disk does not always point a same disk
> -		each boot-up time. Therefore, users have to use persistent
> -		device names, which udev creates when the kernel finds a disk,
> -		instead of raw device name. However, kernel doesn't show those
> -		persistent names on its messages (e.g. dmesg).
> -		This file can store an alias of the disk and it would be
> -		appeared in kernel messages if it is set. A disk can have an
> -		alias which length is up to 255bytes. Users can use alphabets,
> -		numbers, "-" and "_" in alias name. This file is writeonce.
> diff --git a/block/genhd.c b/block/genhd.c
> index 9253839..02e9fca 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -19,7 +19,6 @@
>  #include <linux/mutex.h>
>  #include <linux/idr.h>
>  #include <linux/log2.h>
> -#include <linux/ctype.h>
> =20
>  #include "blk.h"
> =20
> @@ -916,74 +915,6 @@ static int __init genhd_device_init(void)
> =20
>  subsys_initcall(genhd_device_init);
> =20
> -static ssize_t alias_show(struct device *dev,
> -			       struct device_attribute *attr, char *buf)
> -{
> -	struct gendisk *disk =3D dev_to_disk(dev);
> -	ssize_t ret =3D 0;
> -
> -	if (disk->alias)
> -		ret =3D snprintf(buf, ALIAS_LEN, "%s\n", disk->alias);
> -	return ret;
> -}
> -
> -static ssize_t alias_store(struct device *dev, struct device_attribu=
te *attr,
> -			   const char *buf, size_t count)
> -{
> -	struct gendisk *disk =3D dev_to_disk(dev);
> -	char *alias;
> -	char *envp[] =3D { NULL, NULL };
> -	unsigned char c;
> -	int i;
> -	ssize_t ret =3D count;
> -
> -	if (!count)
> -		return -EINVAL;
> -
> -	if (count >=3D ALIAS_LEN) {
> -		printk(KERN_ERR "alias: alias is too long\n");
> -		return -EINVAL;
> -	}
> -
> -	/* Validation check */
> -	for (i =3D 0; i < count; i++) {
> -		c =3D buf[i];
> -		if (i =3D=3D count - 1 && c =3D=3D '\n')
> -			break;
> -		if (!isalnum(c) && c !=3D '_' && c !=3D '-') {
> -			printk(KERN_ERR "alias: invalid alias\n");
> -			return -EINVAL;
> -		}
> -	}
> -
> -	if (disk->alias) {
> -		printk(KERN_INFO "alias: %s is already assigned (%s)\n",
> -		       disk->disk_name, disk->alias);
> -		return -EINVAL;
> -	}
> -
> -	alias =3D kasprintf(GFP_KERNEL, "%s", buf);
> -	if (!alias)
> -		return -ENOMEM;
> -
> -	if (alias[count - 1] =3D=3D '\n')
> -		alias[count - 1] =3D '\0';
> -
> -	envp[0] =3D kasprintf(GFP_KERNEL, "ALIAS=3D%s", alias);
> -	if (!envp[0]) {
> -		kfree(alias);
> -		return -ENOMEM;
> -	}
> -
> -	disk->alias =3D alias;
> -	printk(KERN_INFO "alias: assigned %s to %s\n", alias, disk->disk_na=
me);
> -
> -	kobject_uevent_env(&dev->kobj, KOBJ_ADD, envp);
> -
> -	kfree(envp[0]);
> -	return ret;
> -}
> -
>  static ssize_t disk_range_show(struct device *dev,
>  			       struct device_attribute *attr, char *buf)
>  {
> @@ -1043,7 +974,6 @@ static ssize_t disk_discard_alignment_show(struc=
t device *dev,
>  	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
>  }
> =20
> -static DEVICE_ATTR(alias, S_IRUGO|S_IWUSR, alias_show, alias_store);
>  static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
>  static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
>  static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
> @@ -1066,7 +996,6 @@ static struct device_attribute dev_attr_fail_tim=
eout =3D
>  #endif
> =20
>  static struct attribute *disk_attrs[] =3D {
> -	&dev_attr_alias.attr,
>  	&dev_attr_range.attr,
>  	&dev_attr_ext_range.attr,
>  	&dev_attr_removable.attr,
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 9de31bc..6d18f35 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -21,8 +21,6 @@
>  #define dev_to_part(device)	container_of((device), struct hd_struct,=
 __dev)
>  #define disk_to_dev(disk)	(&(disk)->part0.__dev)
>  #define part_to_dev(part)	(&((part)->__dev))
> -#define alias_name(disk)	((disk)->alias ? (disk)->alias : \
> -						 (disk)->disk_name)
> =20
>  extern struct device_type part_type;
>  extern struct kobject *block_depr;
> @@ -60,7 +58,6 @@ enum {
> =20
>  #define DISK_MAX_PARTS			256
>  #define DISK_NAME_LEN			32
> -#define ALIAS_LEN			256
> =20
>  #include <linux/major.h>
>  #include <linux/device.h>
> @@ -166,7 +163,6 @@ struct gendisk {
>                                           * disks that can't be parti=
tioned. */
> =20
>  	char disk_name[DISK_NAME_LEN];	/* name of major driver */
> -	char *alias;			/* alias name of disk */
>  	char *(*devnode)(struct gendisk *gd, mode_t *mode);
> =20
>  	unsigned int events;		/* supported events */


--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
