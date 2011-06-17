From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 0/3] [RFC] Persistent device name using preferred name
Date: Fri, 17 Jun 2011 14:58:10 +0900
Message-ID: <4DFAECF2.9060105@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615153711.GB10160@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40486 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1FQF6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2011 01:58:21 -0400
In-Reply-To: <20110615153711.GB10160@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

Hi Greg,

(2011/06/16 0:37), Greg KH wrote:
> On Wed, Jun 15, 2011 at 05:16:10PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> This patch series provides preferred name into kernel and procfs
>> messages. Preferred name is user's preferred name for a device.
>>
>> The purpose of this feature is to solve the persistent device
>> naming issues which was discussed here:
>>
>>  http://marc.info/?l=3Dlinux-scsi&m=3D130200794615884&w=3D2
>>
>> There are four issues.
>> 1. kernel messages doesn't show persistent device names
>=20
> That is because a persistent device name could be anything, there are
> multiple ways of defining a device, and the kernel will not know them
> all as multiple ones could be in use for the same device.
>

Right, thus I'd like to solve it by assigning a unique preferred name
to each device. I mean, user of preferred name will decide to use one
way of defining a device, then kernel can show the name as a persistent
name for him.=E3=80=80Since this is completely based on user's choice/d=
ecision,
no one will=E3=80=80complain about that.


>> 2. procfs messages doesn't show persistent device names
>=20
> See above.
>=20
>> 3. Some commands didn't support persistent device name in arguments
>=20
> Then fix the commands!
>=20

Yes, of course. I'd like to fix those commands to accept preferred name=
s.


> Seriously, this could be done by now, it's been over a year since thi=
s
> was first discussed.  All distros could have the updated packages by =
now
> and this would not be an issue.
>=20
> I still think this is the correct way to solve the problem as it is a
> userspace issue, not a kernel one.
>=20

Agreed. In #3 and #4, I don't think it can solve in kernel space now.

>> 4. Some commands message didn't show persistent device names
>=20
> Same as #3.
>=20

Yeah. Again, I've changed my mind, I'll try to fix those commands.

>> Then I suggested the intermediate device naming which changes
>> the naming scheme, but it was rejected. I realized that we should
>> use udev to provide persistent device names instead of change the
>> naming scheme.
>=20
> Yes.
>=20
>> In LKML discussion, a new idea was suggested by James Bottomley.
>> This idea allows kernel messages show preferred names by adding a
>> new attribute to a device, kernel messages show this new attribute.
>> This idea's advantage is not to change the current naming scheme.
>>
>> I tried implementation of preferred name, and then there are two
>> discussion points.
>>
>> (a) Which devices need support?
>> Preferred name is stored in struct device. Therefore it is available
>> for all devices if we make preferred name support with other device
>> types.
>>
>> This patch series only support scsi block device. Is there the devic=
e
>> which needs support? (e.g. Ntwork devices, generic SCSI devices, etc=
=2E)
>>
>> (b) What kind of procfs form is good?
>> I implemented preferred name something like this,
>>
>> (preferred name assigned foo to sda)
>> #cat /proc/partitions
>> major minor  #blocks  name
>>
>>    8        0  488386584 foo
>>    8        1     194560 foo1
>> ...
>>
>> Do you needs device name filed?
>> Something like this,
>>
>> (preferred name assigned foo to sda)
>> #cat /proc/partitions
>> major minor  #blocks  name preferred
>>
>>    8        0  488386584 sda foo
>>    8        1     194560 sda1 foo1
>> ...
>=20
> Sorry, but you can not change the format of procfs files without
> breaking a lot of tools, that's no longer allowed.
>=20

OK, I would not change the format of procfs files.

>> Issue 3 and 4 is command releated issue. Commands have to be
>> modified to use preferred name. We need to create library for
>> preferred name.
>=20
> Again, this is quite simple and could have been finished by now :(
>=20

:(

>> Our goal is to solve those issues, and users can use and see
>> preferred name anywhere.
>=20
> I don't see how your proposed solution would solve the issue of
> userspace using different persistant names for the same device.  How
> would it know which one is correct?
>=20

My proposal don't use current persistent device names for access. Those
are used in a udev rule as information to identify a device. Something
like this:

(Example: using by-id)
SUBSYSTEM=3D=3D"block",
ENV{ID_SERIAL}=3D=3D"scsi-SATA_WDC_WD5000AAKS-_WD-WCASY6088049",
SYMLINK+=3D"disk/by-preferred/foo", PROGRAM=3D=E2=80=9Dwrite_preferred_=
name %p foo=E2=80=9D

To access a device from by-preferred persistently, I create new symboli=
c
link from /dev/disk/by-preferred/foo to /dev/sdX.

> Again, this is a userspace thing, not a kernel thing, please solve it=
 in
> userspace.
>=20

To solve it in userspace, we need mapping of a device name to a device
every boot-up time. But if kernel messages can show preferred name, we
can identify a device from only kernel messages.

Thanks,

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
