From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Tue, 12 Apr 2011 22:23:55 +0900
Message-ID: <4DA4526B.2030609@hitachi.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>	 <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>	 <4D9F1CD1.2020600@suse.de> <1302275652.4090.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1302275652.4090.10.camel@mulgrave.site>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

Hi, James

(2011/04/09 0:14), James Bottomley wrote:
> On Fri, 2011-04-08 at 07:33 -0700, Hannes Reinecke wrote:
>>> The problem I would like to discuss here is that users can not iden=
tify
>>> a disk from kernel messages when they DIRECTLY refer to these messa=
ges.
>>> For example, a device name is used instead of a symbolic link names=
 in
>>> bootup messages, I/O devices errors and /proc/partitions =E2=80=A6e=
tc.
>>>
>>> In particular, users can not identify an appropriate device from a
>>> device name in syslog since different device name may be assigned t=
o it
>>> at each boot time.
>>>
>>> My idea is able to fix this issue with small changes in scsi subsys=
tem.
>>> Also, it is implemented as an option. Therefore, it does not affect
>>> users who do not select this option.
>>>
>> We have been discussing this problem several times in the past, and
>> indeed on these very mailing list.
>>
>> The conclusion we arrived at is that the kernel-provided device node
>> name is inherently unstable and impossible to fix within the existin=
g
>> 'sdX' naming scheme.
>> So the choices have been to either move to a totally different namin=
g
>> scheme or keep the naming scheme and provide the required informatio=
n
>> by other means.
>> We have decided on the latter, and agreed on using udev to provide
>> persistent device names.
>> We are fully aware that any kernel related messages are subject to
>> chance after reboot, but then most kernel related messages are
>> (PID number, timestamps, login tty etc).
>> And also we are aware that any kernel messages need to be matched
>> against the current system layout to figure out any hardware-related
>> issue.
>>
>> But then basically all products requiring to filter out information
>> from kernel messages already do so I don't see a problem with that.
>>
>> Just adding an in-kernel identifier to the LUN will only be an
>> incomplete solution, as other identifiers will still be volatile.
>>
>> So I would prefer by keeping the in-kernel information as small
>> as possible to reduce memory consumption and rely on out-of-band
>> programs to provide the required mapping.
>=20
> So, while I agree totally with the above: udev and userspace is the w=
ay
> to go, I'm not totally opposed to having a non-invasive mechanism for
> indicating a user's preferred name for a device.  I think there are a
> couple of ways to do this:
>=20
>      1. Entirely in userspace: just have udev consult a preferred nam=
e
>         file and create say /dev/disk/by-preferred.  Then have all th=
e
>         tools that normally output device information do the same (i.=
e.
>         since real name to preferred name is 1:1, they could all do a
>         reverse lookup).
>      2. have a writeable sysfs preferred_name field, either in the
>         generic device or just in SCSI.  The preferred name would be
>         used by outbound only (i.e. kernel dev_printk messages and
>         possibly /proc/partitions).  All inbound uses of the device
>         would come via the standard udev mechanisms
>         (i.e. /dev/disk/by-preferred would be the usual symlink).  Th=
is
>         means from the kernel point of view, no renaming has happened=
=2E
>         We'd just try to print out the preferred name in certain
>         circumstances, which should solve most of the described probl=
em.
>=20
> James
>=20
>=20
>=20

I have a question. Why is in-kernel device name necessary? The kernel
can identify a device by major/miner number and udev can create a
device node of a prefer name.

Currently, device names are only used to show to users. Therefore I
think that in-kernel device name is unnecessary if we introduce your
/dev/disk/by-prefferd idea.


thanks,

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
