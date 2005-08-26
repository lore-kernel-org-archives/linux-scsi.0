From: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Subject: fibre channel/multipath questions
Date: Fri, 26 Aug 2005 18:12:23 +0200
Message-ID: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumbler.kulnet.kuleuven.ac.be ([134.58.240.45]:10174 "EHLO
	thumbler.kulnet.kuleuven.ac.be") by vger.kernel.org with ESMTP
	id S965092AbVHZQMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2005 12:12:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by thumbler.kulnet.kuleuven.ac.be (Postfix) with ESMTP id DD2DF137CB4
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 18:12:15 +0200 (CEST)
Received: from smtp01.kuleuven.be (octavianus.kulnet.kuleuven.ac.be [134.58.240.71])
	by thumbler.kulnet.kuleuven.ac.be (Postfix) with ESMTP id C5890137BC9
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 18:12:14 +0200 (CEST)
Received: from [??1] (s2.cc.kuleuven.ac.be [134.58.10.97])
	by smtp01.kuleuven.be (Postfix) with ESMTP id B809563D45
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 18:12:14 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey guys,

Let me introduce myself.
I'm Rik Bobbaers, working at the KULeuven (university in belgium)
I'm a linux sysadmin, followed a linux kernel internals course and a de=
vice=20
drivers course.

I have some machines that i want to connect to a SAN, which also has an=
=20
IBM/ESS (shark) connection. The san is split in 2 (for failover). each =
server=20
has 2 qlogic fibrechannel cards, which are both connected to different =
san=20
switches. I want failover/loadbalancing over those (du'uh ;))

hardware: Dell PE 1750, dual =A0xeon cpu, 1 gig ram
distro: Debian/unstable (normally it's a stable)
kernel version: vanilla 2.6.13-rc6
bootloader: lilo (maybe switch to grub necessary?)
udev version: 0.067-1
multipath version: 0.4.2.4-2
fibre channel cards:
0000:01:04.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter =
(rev=20
02)
0000:03:06.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter =
(rev=20
02)


Now the questions:
1. If i unplug one cable (simulating a sanswitch breakdown/upgrade/...)=
, the=20
timer starts, giving a timeout after fc_dev_loss_tmo seconds. In the no=
rmal=20
situation, this is 35 seconds (the qlogic driver adds 5 seconds to the =
normal=20
30). This timer can be set to a max of SCSI_DEVICE_BLOCK_MAX_TIMEOUT, b=
eing=20
15000 it seems, which is 4 hours 10 minutes.
If you plug your cable in again before this timer reached 0, it reactiv=
ates=20
the device, making reintegration in the multipath possible (disks keep =
the=20
same major:minor number). If the timer runs out, the devices are remove=
d=20
permanently. When you plug the cable back in, it gives the newly found =
disks=20
other major:minor numbers and device names (same major, but well... ;))=
,=20
which makes reintegration in the multipath impossible unless you unmoun=
t=20
everything etc... This is not the behaviour you want on a SAN network i=
n a=20
failover/loadbalancing environment imho. Is there a way you can make th=
e=20
disks be rerecognised as "the same disks as before"? So that the device=
s can=20
be removed by the driver, but re-made when the san connection returns a=
fter=20
an undetermined amount of time?
If not, is it dangerous to set the SCSI_DEVICE_BLOCK_MAX_TIMEOUT to ...=
 let's=20
say 2^32 (uint_32)? Or redefine it in drivers/scsi/scsi_transport_fc.c =
? What=20
would be the consequences? I can imagine that this could cause memory=20
problems, workqueue problems or so. I didn't find anything on this on t=
he=20
lkml list archives or so.

2. Is it possible to make the fibrechannel driver get loaded AFTER the =
others?=20
(Our kernels have no modules support, so i built it all in the kernel f=
or=20
security reasons etc...) The reason is very simple. If I have 1 disk on=
 ESS,=20
it now becomes /dev/sda on scsi0, /dev/sdb on scsi1 and the local disks=
=20
are /dev/sdc and /dev/sdd. If I add another ESS disk , it will be /dev/=
sde=20
and /dev/sdf, after a reboot, they will be /dev/sdc and /dev/sdd, the =A0=
local=20
disks will become /dev/sde and /dev/sdf. At first i thought, use e2labe=
l, but=20
that's only for ext2/3 filesystems, our systems run on reiserfs. Are th=
ere=20
any sollutions for this in a monolythical kernel or is the only way to =
fix=20
this, compile the driver as modules and load them at boottime?

I tried patching the current code a little bit, which was quite hard (s=
ince=20
i've never done this before). I allready learned a lot, but I would lik=
e to=20
learn some more so that I could eventually even try to help out on thes=
e=20
things.

I hope this is enough information, if not, please ask!

thanks a million,

--=20
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT =A0 =A0 =A0 =A0 =A0-=3D- Tel: +32 485 52 71 50
Rik.Bobbaers@cc.kuleuven.be -=3D- http://harry.ulyssis.org
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
