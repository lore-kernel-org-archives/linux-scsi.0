From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
Date: Mon, 25 Feb 2008 12:33:52 +0800
Message-ID: <003c01c87767$9fed6050$8800a8c0@Nick>
References: <751a4f870802230954m6db5963dnb7865005a60a7bf0@mail.gmail.com>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.areca.com.tw ([220.130.178.143]:32091 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754763AbYBYEeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 23:34:06 -0500
In-Reply-To: <751a4f870802230954m6db5963dnb7865005a60a7bf0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Aron Stansvik' <elvstone@gmail.com>
Cc: 'erich' <erich@areca.com.tw>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Aron,
=46rom our field experiences and customers' feedbacks, all of them dire=
ct to
vibration and power issues.
The vibration could be caused by FANs not only by themselves.
You mentioned it could be the F/W issue.
If the environment does not meet the prerequisite, FW could not work
correctly.
Actually FW just reacts to the situations not it causes the issue.
Please check it out!!
Thank you,

-----Original Message-----
=46rom: Aron Stansvik [mailto:elvstone@gmail.com]=20
Sent: Sunday, February 24, 2008 1:54 AM
To: nick.cheng@areca.com.tw
Cc: erich; akpm@linux-foundation.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1

Hello again Areca and LKML hackers.

2008/2/18, Aron Stansvik <elvstone@gmail.com>:
> Hello Nick.
>
>  Sorry that I'm not answering until now. I've been busy.
>
>  2008/2/13, nickcheng <nick.cheng@areca.com.tw>:
>
> > Hi Aron,
>  >  From our experience and some customers' feedback, your issue coul=
d be
caused
>  >  by power instability or vibration to your HDs.
>  >  Please check step by step:
>  >  (1).under your original environment, increase the SCSI command va=
lue,
>  >  default=3D30, with the shell script, set_scsicmd_timeout(). 90 or=
 120 is
>  >  enough.
>  >  (2).if method 1 does not work, find out the vibration source or c=
hange
the
>  >  power supply
>
>
> I will try to increase that value. I don't think it's vibration; the
>  disks are firmly in place in a very heavy chassi (Silverstone
>  SST-TJ05B-T). And I really don't think there's something wrong with
>  the power supply, it's a pretty new Silverstone ST65ZF 650W. This is
>  my own personal workstation, so I don't just have another power supp=
ly
>  to test with :/
>
>  I will report back on my success/failure. Thanks for your answer.

I've now tried with both 90 and 120 for the timeout value, and the
problem still persists. It seems to happen when lots of small writes
are occuring, e.g. when installing something.

I really don't think the disks are vibrating, I don't see how they
could. One more thing I'm going to test is to use the legacy ATA power
connector instead of the SATA power connector. This was what I was
using before when I only had a single drive and no RAID controller.
Maybe my power supply is malfunctioning and not giving enough power on
the SATA power connectors.. but I doubt it.

Is there anything else that could cause this? Have you guys at Areca
tested the ARC-1200 with Raptors in RAID1?

:(

Regards,
Aron

>
>
>  Aron
>
>
>  >  If your still have any questions, please feel free to let me know=
=2E
>  >
>  >  P.S. The attached driver source, arcmsr-1.20.00.15-71224, has bee=
n
>  >  upstreamed to kernel.org and will be released in kernel 2.6.25. I=
f you
like,
>  >  you could update your driver with it.
>  >  It fixes some minor bugs, but these bugs are nothing to do with y=
our
issue.
>  >
>  >
>  >  -----Original Message-----
>  >  From: erich [mailto:erich@areca.com.tw]
>  >  Sent: Wednesday, February 13, 2008 4:33 PM
>  >  To: (=BCs=A6w=AC=EC=A7=DE)=BEG=A6u=C1=BE
>  >  Subject: Fw: Aborted commands with arcmsr and 2xWD1500ADFD in RAI=
D1
>  >
>  >
>  >
>  >  ----- Original Message -----
>  >  From: "Andrew Morton" <akpm@linux-foundation.org>
>  >  To: "Aron Stansvik" <elvstone@gmail.com>
>  >  Cc: <linux-kernel@vger.kernel.org>; <linux-scsi@vger.kernel.org>;
"erich"
>  >  <erich@areca.com.tw>
>  >  Sent: Wednesday, February 13, 2008 4:03 PM
>  >  Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAI=
D1
>  >
>  >
>  >  >
>  >  > (cc's added)
>  >  >
>  >  > On Mon, 11 Feb 2008 17:44:08 +0100 "Aron Stansvik"
<elvstone@gmail.com>
>  >  > wrote:
>  >  >
>  >  >> Hello LKML.
>  >  >>
>  >  >> Under semi-high disk I/O (e.g. installing a compiled KDE), I g=
et
the
>  >  >> following (accompanied by seconds of lock-ups on the machine):
>  >  >>
>  >  >> [ 7727.345183] arcmsr0: abort device command of scsi id =3D 0 =
lun =3D 0
>  >  >> [ 7730.348776] arcmsr0:                 scsi id =3D 0 lun =3D =
0 ccb =3D
>  >  >> '0xdfb461c0' poll command abort successfully
>  >  >> [ 8053.795943] arcmsr0: abort device command of scsi id =3D 0 =
lun =3D 0
>  >  >> [ 8056.799528] arcmsr0:                 scsi id =3D 0 lun =3D =
0 ccb =3D
>  >  >> '0xdfb595e0' poll command abort successfully
>  >  >> [ 8884.592810] arcmsr0: abort device command of scsi id =3D 0 =
lun =3D 0
>  >  >> [ 8887.596392] arcmsr0:                 scsi id =3D 0 lun =3D =
0 ccb =3D
>  >  >> '0xdfb56d80' poll command abort successfully
>  >  >> [ 8917.760216] arcmsr0: abort device command of scsi id =3D 0 =
lun =3D 0
>  >  >> [ 8920.763797] arcmsr0:                 scsi id =3D 0 lun =3D =
0 ccb =3D
>  >  >> '0xdfb472c0' poll command abort successfully
>  >  >> [ 9074.106547] arcmsr0: abort device command of scsi id =3D 0 =
lun =3D 0
>  >  >>
>  >  >> This is my setup:
>  >  >>
>  >  >> 1 x MSI K8N Master2-FAR
>  >  >> 1 x Opteron 252
>  >  >> 1 x Areca ARC1200 (sitting in a PCIe x4 socket)
>  >  >> 2 x WD1500ADFD in RAID1
>  >  >>
>  >  >> astan@rubik:~$ uname -a
>  >  >> Linux rubik 2.6.24-7-generic #1 SMP Thu Feb 7 01:29:58 UTC 200=
8
i686
>  >  >> GNU/Linux
>  >  >> astan@rubik:~$ modinfo arcmsr
>  >  >> filename:
>  >  >> /lib/modules/2.6.24-7-generic/kernel/drivers/scsi/arcmsr/arcms=
r.ko
>  >  >> version:        Driver Version 1.20.00.15 2007/08/30
>  >  >> license:        Dual BSD/GPL
>  >  >> description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID H=
OST
Adapter
>  >  >> author:         Erich Chen <support@areca.com.tw>
>  >  >> srcversion:     28EAD6AB49D4491CA04D465
>  >  >> [...]
>  >  >>
>  >  >> I've read some previous posts here on LKML that it could be th=
e
Areca
>  >  >> firmware who doesn't like my WD disks. Anyone know if this is =
an
IRQ
>  >  >> handling problem in the kernel, or if it's a problem with the =
RAID
>  >  >> controller firmware?
>  >  >>
>  >  >> Erich Chen (of Areca); have you tried the new ARC1200 in RAID1
>  >  >> configuration with Raptor disks on Linux?
>  >  >>
>  >  >> As a side note, I can tell you that I first tried running Free=
BSD
6.3
>  >  >> (RELENG_6) on this machine, but got random reboots during disk=
 I/O
>  >  >> (even with a kernel with KDB debugging turned on). This leads =
me to
>  >  >> believe that it might be a firmware issue, and that Linux just
handles
>  >  >> it more gracefully than FreeBSD.
>  >  >>
>  >  >> Any ideas or advice is appriciated. This is my first post to t=
he
LKML,
>  >  >> so please instruct me if you want more information or if you w=
ant
me
>  >  >> to take further debugging actions.
>  >  >>
>  >  >> Best regards,
>  >  >> Aron Stansvik
>  >  >
>  >
>  >
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
