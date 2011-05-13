From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 13:46:59 +0200
Message-ID: <BANLkTikaFkeEaTPutOuMAnUx5gvdP=JyJQ@mail.gmail.com>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com>
	<BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70157F7BB82@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48063 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1EMLrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 07:47:00 -0400
Received: by qyk7 with SMTP id 7so272470qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2011 04:46:59 -0700 (PDT)
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70157F7BB82@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Kashyap,

But when i use a LSI 3081E-R HBA (mptsas driver) the disk ordering is
ALWAYS the same, and always in correct order.
I would like to keep that functionality when upgrading to the newer 921=
1-8i HBA.

Kind regards,

Caspar Smit

2011/5/13 Desai, Kashyap <Kashyap.Desai@lsi.com>:
> Smit,
>
> Disk ordering is not done by mpt2sas driver.
> Ordering is purely depend upon How FW discovers drivers and repots it=
 to Driver.
>
> e.a if you have slow spinning driver at slot-0, it can be reported by=
 FW at the end, though it is attached to slot-0.
>
> In summary, Disk ordering is not guaranteed.
>
> ~ Kashyap
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Caspar Smit
>> Sent: Friday, May 13, 2011 4:04 PM
>> To: linux-scsi@vger.kernel.org
>> Subject: Re: mpt2sas: bug in disk ordering?
>>
>> Hello again,
>>
>> I tried with Debian Squeeze with the latest backports kernel 2.6.38,
>> which has mpt2sas version 07.100.00.00
>> and now the disks are ordered this way:
>>
>> /dev/sdb =3D slot 3
>> /dev/sdc =3D slot 2
>> /dev/sdd =3D slot 1
>> /dev/sde =3D slot 0
>> /dev/sdf =3D slot 7
>> /dev/sdg =3D slot 6
>> /dev/sdh =3D slot 5
>> /dev/sdi =3D slot 4
>>
>> So there's more consistency here but still ordered backwards (per po=
rt)
>>
>> Kind regards,
>>
>> Caspar Smit
>>
>>
>> 2011/5/13 Caspar Smit <c.smit@truebit.nl>:
>> > Hi all,
>> >
>> > I'm having a minor issue with the disk ordering using an LSI 9211-=
8i
>> > (mpt2sas) controller.
>> >
>> > If i go into the controllers SAS config utility during boot I can
>> > identify the disks in the slots.
>> >
>> > disk 0 -> slot 0, disk 1 -> slot 1, etc.. everyhting is fine.
>> >
>> > When I boot into debian linux lenny (using the latest backports
>> > 2.6.32-31 kernel, this kernel has version 02.100.03.00 of the mpt2=
sas
>> > driver)
>> >
>> > The disks are ordered this way:
>> >
>> > /dev/sda =3D internal SSD connected to the MB
>> >
>> > /dev/sdb =3D slot 0
>> > /dev/sdc =3D slot 1
>> > /dev/sdd =3D slot 2
>> > /dev/sde =3D slot 3
>> > /dev/sdf =3D slot 7 (!)
>> > /dev/sdg =3D slot 4
>> > /dev/sdh =3D slot 5
>> > /dev/sdi =3D slot 6
>> >
>> > So it seems the first 4 disks connected to SAS port 1 are ordered
>> > correctly and the last 4 disks are not.
>> >
>> > When I check /dev/disk/by-path i see the following:
>> >
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52 pci-0000:04:00.0-s=
as-
>> > 0x500605b001d161b0:1:0-0x4433221103000000:0 -> ../../sdb
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:1-0x4433221102000000:0 -=
>
>> > ../../sdc
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:2-0x4433221101000000:0 -=
>
>> > ../../sdd
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:3-0x4433221100000000:0 -=
>
>> > ../../sde
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:4-0x4433221104000000:0 -=
>
>> > ../../sdf
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:5-0x4433221107000000:0 -=
>
>> > ../../sdg
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:6-0x4433221106000000:0 -=
>
>> > ../../sdh
>> > lrwxrwxrwx 1 root root=A0=A0 9 2011-05-13 10:52
>> > pci-0000:04:00.0-sas-0x500605b001d161b0:1:7-0x4433221105000000:0 -=
>
>> > ../../sdi
>> >
>> > This LOOKS as it should but right now it is not really correct
>> because
>> > 1:7 indicates that it should be physical slot 7 (sdi is in slot 6 =
and
>> > not in slot 7)
>> >
>> > When i use the sas2ircu command line util to LOCATE the disks and =
I
>> > use 1:7 to locate, slot 7 lights up (NOT disk sdi)
>> >
>> > Is this behavior fixed in a newer version of the driver, and if so
>> > what is the corresponding patch to fix this?
>> >
>> > Kind regards,
>> >
>> > Caspar Smit
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
