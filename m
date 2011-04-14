From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Thu, 14 Apr 2011 17:15:36 +0900
Message-ID: <4DA6AD28.5020604@hitachi.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp> <20110405161454.GB885@kroah.com> <4D9F16AD.2090408@hitachi.com> <20110408161212.GA12111@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20110408161212.GA12111@kroah.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

Hi,

(2011/04/09 1:12), Greg KH wrote:
> On Fri, Apr 08, 2011 at 11:07:41PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> (2011/04/06 1:14), Greg KH wrote:
>>> On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
>>>> This patch series provides a SCSI option for persistent device
>>>> names in kernel. With this option, user can always assign a
>>>> same device name (e.g. sda) to a specific device according to
>>>> udev rules and device id.
>>>>
>>>> Issue:
>>>> Recently, kernel registers block devices in parallel. As a result,
>>>> different device names will be assigned at each boot time. This
>>>> will confuse file-system mounter, thus we usually use persistent
>>>> symbolic links provided by udev. However, dmesg and procfs outputs
>>>> show device names instead of the symbolic link names. This causes
>>>> a serious problem when managing multiple devices (e.g. on a
>>>> large-scale storage), because usually, device errors are output
>>>> with device names on dmesg. We also concern about some commands
>>>> which output device names, as well as kernel messages.
>>>>
>>>> Solution:
>>>> To assign a persistent device name, I create unnamed devices (not
>>>> a block device, but an intermediate device. users cannot read/writ=
e
>>>> this device). When scsi device driver finds a LU, the LU is regist=
ered
>>>> as an unnamed device and inform to udev. After udev finds the unna=
med
>>>> device, udev assigns a persistent device name to a specific device
>>>> according to udev rules and registers it as a block device. Hence,
>>>> this is just a naming, not a renaming.
>>>>
>>>> Some users are satisfied with current udev solution. Therefore, my
>>>> proposal is implemented as an option.
>>>>
>>>> If using this option, add the following kernel parameter.
>>>>
>>>> 	scsi_mod.persistent_name=3D1
>>>>
>>>> Also, if you want to assign a device name with sda, add the
>>>> following udev rules.
>>>>
>>>> SUBSYSTEM=3D=3D"scsi_unnamed", ATTR{disk_id}=3D=3D"xxx", PROGRAM=3D=
"/bin/sh
>>>> -c 'echo -n sda > /sys/%p/disk_name'"
>>>
>>> Also, where is the "real" program you have created to properly name
>>> devices from userspace?  You need that to properly test this patch,
>>> right?
>>>
>>
>> In the udev rule described above, notation =E2=80=9Cxxx=E2=80=9D ind=
icated by
>> ATTR(disk_id) is scsi id given by disk. Then, when udev finds this r=
ule,
>> "/bin/sh -c 'echo -n sda>  /sys/%p/disk_name'" indicated by PROGRAM =
is
>> operated using xxx (scsi id) if udev find the disk with scic id xxx.
>> Thus, persistent device name is assigned.
>>
>> I have tested this patch using the udev rule. and It works well.
>=20
> That's nice, but it's a "toy".  What have you used to test this with
> 20000 scsi devices to properly work like it does today?  Where is the
> program that will name them in a deterministic manner?
>=20
> We have that functionality today, you can't break it.
>=20
> thanks,

Indeed, I have not (can not, of course) tested 20000 scsi devices to
properly work. This feature targets only scsi disk/cdrom/tape devices.
Not all devices. We expect the target users are system administrators
who need to control all devices for maintenance. They know all devices
connected to the server and those devices will tested before connecting=
=2E

We expect that admin will enable this option after installation. This
means that device names are assigned by current mechanism when
installation. Admin enables the option and makes udev rules (we are
planning to make shell script which generate udev rules use by-id and
assigned device names). In other word, this feature will be used just
for "fixing" the names.

In our scenario, admin appends a new rule manually when a new LU is
added. In the future, we are planning to enhance udev to append a new
rule automatically as like as NIC.

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
