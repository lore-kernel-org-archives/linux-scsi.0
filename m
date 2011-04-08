From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Fri, 08 Apr 2011 23:07:41 +0900
Message-ID: <4D9F16AD.2090408@hitachi.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp> <20110405161454.GB885@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110405161454.GB885@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
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
>> symbolic links provided by udev. However, dmesg and procfs outputs
>> show device names instead of the symbolic link names. This causes
>> a serious problem when managing multiple devices (e.g. on a
>> large-scale storage), because usually, device errors are output
>> with device names on dmesg. We also concern about some commands
>> which output device names, as well as kernel messages.
>>
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
>>
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
>=20
> Also, where is the "real" program you have created to properly name
> devices from userspace?  You need that to properly test this patch,
> right?
>=20

In the udev rule described above, notation =E2=80=9Cxxx=E2=80=9D indica=
ted by
ATTR(disk_id) is scsi id given by disk. Then, when udev finds this rule=
,
"/bin/sh -c 'echo -n sda>  /sys/%p/disk_name'" indicated by PROGRAM is
operated using xxx (scsi id) if udev find the disk with scic id xxx.
Thus, persistent device name is assigned.

I have tested this patch using the udev rule. and It works well.


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
