From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
Date: Mon, 17 Mar 2008 09:56:50 +0800
Message-ID: <003c01c887d2$2ada2340$9a00a8c0@Nick>
References: <751a4f870803141025r2cb6bf88hdee3cf9583d9ad44@mail.gmail.com>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.areca.com.tw ([220.130.178.143]:61636 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751594AbYCQB5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 21:57:01 -0400
In-Reply-To: <751a4f870803141025r2cb6bf88hdee3cf9583d9ad44@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Aron Stansvik' <elvstone@gmail.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Aron,
We have two WDWD1500ADFD and a MSI motherboard which is not exactly the=
 same
as what you have.=20
I have tested your case two weeks ago, and do it with copy-compare test
program but I find nothing as you describe.
Could you give me your experimental directory to let me try again??=20
BTW, what is your FW version?
The latest FW version is v1.44.=20
Please check it out,
-----Original Message-----
=46rom: Aron Stansvik [mailto:elvstone@gmail.com]=20
Sent: Saturday, March 15, 2008 1:26 AM
To: nick.cheng@areca.com.tw
Cc: erich; akpm@linux-foundation.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1

2008/2/26, nickcheng <nick.cheng@areca.com.tw>:
> Hi Aron,
>  Thanks for your patience.
>  If you still got into trouble, please let me know.
>  Thank you again,

I have now tried:

* Turning on/off NCQ in the Areca RAID.
* Turning on/off read-ahead cache in the Areca RAID.
* Putting the disks in anti-vibration mounts in 5.25" slots.
* Switching SATA cables.
* Using legacy ATA power connectors instead of the SATA ones.

But I still have the problem. The power supply is 650W so there should
be plenty of power. There's only two Raptor disks, an Opteron CPU and
an nVidia 6600GT in the machine.

The Raptor two Raptor disks have different firmware on them, could
that cause any problem?

Two people who had read my post here on LKML have contacted me on
e-mail and have the same problem, but they have Seagate and Samsung
disks, and use the 1220 controller.

The problem is hard to trigger, I've not been able to trigger it with
any benchmarking tool, but in ~95% of the cases I can trigger it by
just copying a directory with lots of small files (around 500 MB).

Anyone else seeing this? I'd really like to get it to work since this
is my only computer :(

Should I try with XFS or ReiserFS instead of EXT3?

Regards,
Aron

>
> -----Original Message-----
>  From: Aron Stansvik [mailto:elvstone@gmail.com]
>
> Sent: Tuesday, February 26, 2008 6:52 AM
>  To: erich
>  Cc: nick.cheng@areca.com.tw; akpm@linux-foundation.org;
>  linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>  Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
>
>  Hi Erich.
>
>  2008/2/25, nickcheng <nick.cheng@areca.com.tw>:
>  > Hi Aron,
>  >  From our field experiences and customers' feedbacks, all of them
direct
>  to
>  >  vibration and power issues.
>  >  The vibration could be caused by FANs not only by themselves.
>
>  Okay. I have a chassi fan that is quite close to the drives, I will
>  try disabling it. I've also ordered two Nexus TwinDisk anti vibratio=
n
>  harddrive mounts with which I'll place the disks in my 5.25" slots
>  instead, away from any fans.
>
>  If this doesn't work, I'm stumped, as I really don't think it's the
>  power supply and I don't have the money to buy a new one.
>
>  >  You mentioned it could be the F/W issue.
>  >  If the environment does not meet the prerequisite, FW could not w=
ork
>  >  correctly.
>  >  Actually FW just reacts to the situations not it causes the issue=
=2E
>
>  Of course, I understand this. Just trying to figure this problem out=
=2E.
>
>  >  Please check it out!!
>
>  I'll report back with my findings with moving disk away from fans an=
d
>  using anti-vibrations mounts.
>
>  Thanks for taking your time to reply.
>
>  Aron
>
>  >  Thank you,
>  >
>  >
>  >  -----Original Message-----
>  >  From: Aron Stansvik [mailto:elvstone@gmail.com]
>  >  Sent: Sunday, February 24, 2008 1:54 AM
>  >  To: nick.cheng@areca.com.tw
>  >  Cc: erich; akpm@linux-foundation.org; linux-scsi@vger.kernel.org;
>  >  linux-kernel@vger.kernel.org
>  >
>  > Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID=
1
>  >
>  >  Hello again Areca and LKML hackers.
>  >
>  >  2008/2/18, Aron Stansvik <elvstone@gmail.com>:
>  >  > Hello Nick.
>  >  >
>  >  >  Sorry that I'm not answering until now. I've been busy.
>  >  >
>  >  >  2008/2/13, nickcheng <nick.cheng@areca.com.tw>:
>  >  >
>  >  > > Hi Aron,
>  >  >  >  From our experience and some customers' feedback, your issu=
e
could
>  be
>  >  caused
>  >  >  >  by power instability or vibration to your HDs.
>  >  >  >  Please check step by step:
>  >  >  >  (1).under your original environment, increase the SCSI comm=
and
>  value,
>  >  >  >  default=3D30, with the shell script, set_scsicmd_timeout().=
 90 or
120
>  is
>  >  >  >  enough.
>  >  >  >  (2).if method 1 does not work, find out the vibration sourc=
e or
>  change
>  >  the
>  >  >  >  power supply
>  >  >
>  >  >
>  >  > I will try to increase that value. I don't think it's vibration=
; the
>  >  >  disks are firmly in place in a very heavy chassi (Silverstone
>  >  >  SST-TJ05B-T). And I really don't think there's something wrong=
 with
>  >  >  the power supply, it's a pretty new Silverstone ST65ZF 650W. T=
his
is
>  >  >  my own personal workstation, so I don't just have another powe=
r
supply
>  >  >  to test with :/
>  >  >
>  >  >  I will report back on my success/failure. Thanks for your answ=
er.
>  >
>  >  I've now tried with both 90 and 120 for the timeout value, and th=
e
>  >  problem still persists. It seems to happen when lots of small wri=
tes
>  >  are occuring, e.g. when installing something.
>  >
>  >  I really don't think the disks are vibrating, I don't see how the=
y
>  >  could. One more thing I'm going to test is to use the legacy ATA =
power
>  >  connector instead of the SATA power connector. This was what I wa=
s
>  >  using before when I only had a single drive and no RAID controlle=
r.
>  >  Maybe my power supply is malfunctioning and not giving enough pow=
er on
>  >  the SATA power connectors.. but I doubt it.
>  >
>  >  Is there anything else that could cause this? Have you guys at Ar=
eca
>  >  tested the ARC-1200 with Raptors in RAID1?
>  >
>  >  :(
>  >
>  >  Regards,
>  >  Aron
>  >
>  >  >
>  >  >
>  >  >  Aron
>  >  >
>  >  >
>  >  >  >  If your still have any questions, please feel free to let m=
e
know.
>  >  >  >
>  >  >  >  P.S. The attached driver source, arcmsr-1.20.00.15-71224, h=
as
been
>  >  >  >  upstreamed to kernel.org and will be released in kernel 2.6=
=2E25.
If
>  you
>  >  like,
>  >  >  >  you could update your driver with it.
>  >  >  >  It fixes some minor bugs, but these bugs are nothing to do =
with
>  your
>  >  issue.
>  >  >  >
>  >  >  >
>  >  >  >  -----Original Message-----
>  >  >  >  From: erich [mailto:erich@areca.com.tw]
>  >  >  >  Sent: Wednesday, February 13, 2008 4:33 PM
>  >  >  >  To: (=BCs=A6w=AC=EC=A7=DE)=BEG=A6u=C1=BE
>  >  >  >  Subject: Fw: Aborted commands with arcmsr and 2xWD1500ADFD =
in
RAID1
>  >  >  >
>  >  >  >
>  >  >  >
>  >  >  >  ----- Original Message -----
>  >  >  >  From: "Andrew Morton" <akpm@linux-foundation.org>
>  >  >  >  To: "Aron Stansvik" <elvstone@gmail.com>
>  >  >  >  Cc: <linux-kernel@vger.kernel.org>;
<linux-scsi@vger.kernel.org>;
>  >  "erich"
>  >  >  >  <erich@areca.com.tw>
>  >  >  >  Sent: Wednesday, February 13, 2008 4:03 PM
>  >  >  >  Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD =
in
RAID1
>  >  >  >
>  >  >  >
>  >  >  >  >
>  >  >  >  > (cc's added)
>  >  >  >  >
>  >  >  >  > On Mon, 11 Feb 2008 17:44:08 +0100 "Aron Stansvik"
>  >  <elvstone@gmail.com>
>  >  >  >  > wrote:
>  >  >  >  >
>  >  >  >  >> Hello LKML.
>  >  >  >  >>
>  >  >  >  >> Under semi-high disk I/O (e.g. installing a compiled KDE=
), I
get
>  >  the
>  >  >  >  >> following (accompanied by seconds of lock-ups on the
machine):
>  >  >  >  >>
>  >  >  >  >> [ 7727.345183] arcmsr0: abort device command of scsi id =
=3D 0
lun
>  =3D 0
>  >  >  >  >> [ 7730.348776] arcmsr0:                 scsi id =3D 0 lu=
n =3D 0
ccb
>  =3D
>  >  >  >  >> '0xdfb461c0' poll command abort successfully
>  >  >  >  >> [ 8053.795943] arcmsr0: abort device command of scsi id =
=3D 0
lun
>  =3D 0
>  >  >  >  >> [ 8056.799528] arcmsr0:                 scsi id =3D 0 lu=
n =3D 0
ccb
>  =3D
>  >  >  >  >> '0xdfb595e0' poll command abort successfully
>  >  >  >  >> [ 8884.592810] arcmsr0: abort device command of scsi id =
=3D 0
lun
>  =3D 0
>  >  >  >  >> [ 8887.596392] arcmsr0:                 scsi id =3D 0 lu=
n =3D 0
ccb
>  =3D
>  >  >  >  >> '0xdfb56d80' poll command abort successfully
>  >  >  >  >> [ 8917.760216] arcmsr0: abort device command of scsi id =
=3D 0
lun
>  =3D 0
>  >  >  >  >> [ 8920.763797] arcmsr0:                 scsi id =3D 0 lu=
n =3D 0
ccb
>  =3D
>  >  >  >  >> '0xdfb472c0' poll command abort successfully
>  >  >  >  >> [ 9074.106547] arcmsr0: abort device command of scsi id =
=3D 0
lun
>  =3D 0
>  >  >  >  >>
>  >  >  >  >> This is my setup:
>  >  >  >  >>
>  >  >  >  >> 1 x MSI K8N Master2-FAR
>  >  >  >  >> 1 x Opteron 252
>  >  >  >  >> 1 x Areca ARC1200 (sitting in a PCIe x4 socket)
>  >  >  >  >> 2 x WD1500ADFD in RAID1
>  >  >  >  >>
>  >  >  >  >> astan@rubik:~$ uname -a
>  >  >  >  >> Linux rubik 2.6.24-7-generic #1 SMP Thu Feb 7 01:29:58 U=
TC
2008
>  >  i686
>  >  >  >  >> GNU/Linux
>  >  >  >  >> astan@rubik:~$ modinfo arcmsr
>  >  >  >  >> filename:
>  >  >  >  >>
/lib/modules/2.6.24-7-generic/kernel/drivers/scsi/arcmsr/arcmsr.
>  ko
>  >  >  >  >> version:        Driver Version 1.20.00.15 2007/08/30
>  >  >  >  >> license:        Dual BSD/GPL
>  >  >  >  >> description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS =
RAID
>  HOST
>  >  Adapter
>  >  >  >  >> author:         Erich Chen <support@areca.com.tw>
>  >  >  >  >> srcversion:     28EAD6AB49D4491CA04D465
>  >  >  >  >> [...]
>  >  >  >  >>
>  >  >  >  >> I've read some previous posts here on LKML that it could=
 be
the
>  >  Areca
>  >  >  >  >> firmware who doesn't like my WD disks. Anyone know if th=
is is
an
>  >  IRQ
>  >  >  >  >> handling problem in the kernel, or if it's a problem wit=
h the
>  RAID
>  >  >  >  >> controller firmware?
>  >  >  >  >>
>  >  >  >  >> Erich Chen (of Areca); have you tried the new ARC1200 in
RAID1
>  >  >  >  >> configuration with Raptor disks on Linux?
>  >  >  >  >>
>  >  >  >  >> As a side note, I can tell you that I first tried runnin=
g
>  FreeBSD
>  >  6.3
>  >  >  >  >> (RELENG_6) on this machine, but got random reboots durin=
g
disk
>  I/O
>  >  >  >  >> (even with a kernel with KDB debugging turned on). This =
leads
me
>  to
>  >  >  >  >> believe that it might be a firmware issue, and that Linu=
x
just
>  >  handles
>  >  >  >  >> it more gracefully than FreeBSD.
>  >  >  >  >>
>  >  >  >  >> Any ideas or advice is appriciated. This is my first pos=
t to
the
>  >  LKML,
>  >  >  >  >> so please instruct me if you want more information or if=
 you
>  want
>  >  me
>  >  >  >  >> to take further debugging actions.
>  >  >  >  >>
>  >  >  >  >> Best regards,
>  >  >  >  >> Aron Stansvik
>  >  >  >  >
>  >  >  >
>  >  >  >
>  >  >
>  >
>  >
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
