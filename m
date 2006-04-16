From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: lpfc target renumbering problem
Date: Sun, 16 Apr 2006 04:06:11 +0200
Message-ID: <4441A693.7060004@ludd.luth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mother.ludd.ltu.se ([130.240.16.3]:34489 "EHLO
	mother.ludd.ltu.se") by vger.kernel.org with ESMTP id S932193AbWDPCGQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 22:06:16 -0400
Received: from [192.168.1.104] (root@localhost [127.0.0.1])
	by mother.ludd.ltu.se (8.13.6+Sun/8.12.10) with ESMTP id k3G267mG018084
	for <linux-scsi@vger.kernel.org>; Sun, 16 Apr 2006 04:06:08 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

=46irst some background info:
I have a Infortrend A16F-R2211 diskarray connected to two independent
Qlogic 5200 to which I also have connected a couple of machines with tw=
o
Exmulex LP10000-M2 HBA's, all running CentOS 4.3.

The Infortrend box have four SFP-ports which is connected to two
redundant controllers which each have two "channels".
In the Infortrend-box you can configure logical drives (and optionally
logical volumes) which then can be mapped to LUNs on each channel.
Each logical drive can only be assigned to one controller, but in case
of a controller failure, the other controller will take over the logica=
l
drives from the failed controller.
A LUN mapped to a logical drive will have the same WWNN on both
channels, but different WWPN.



Now to my problem:
I was hoping to be able to set up a fault tolerant solution using
multipathing so that if a controller, fabric, fiber-cable or HBA fails,
a filesystem is still accessible on the hosts using device-mapper-multi=
path.
This works ok if a fabric, fibre-cable or HBA fails, but when a
controller fails all paths become "stale".
This seems to be due to the fact that the lpfc-driver maps the LUNs to
different target numbers after a controller failure, but only if the
disks are "active" (i.e mounted)

If I do 'cat /proc/scsi/lpfc/*' when everything is ok, it looks like th=
is:
lpfc0t00 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91
lpfc1t00 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91
At the same time, the output from 'multipath -ll' is:
mpath1 (3600d0230000000000b01910b4d313400)
[size=3D97 GB][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 1:0:0:0 sde 8:16  [active][ready]
 \_ 2:0:0:0 sdf 8:32  [active][ready]


If I manually fail the controller, while having the filesystem mounted
the output from 'cat /proc/scsi/lpfc/*' looks like this:
lpfc0t01 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91
lpfc1t01 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91
Due to this both paths fails and the filsystem is inaccessible

I've tried:
echo 1 >/sys/class/scsi_device/1:0:0:0/device/delete
echo 1 >/sys/class/scsi_device/2:0:0:0/device/delete
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan

But this will render me new sdb/sdc at 1:0:1:0/2:0:1:0 which isn't what
I need.

When I "fix" the failed controller, and the diskarray returns to
two-controller-mode, 'cat /proc/scsi/lpfc/*' looks like this again:
lpfc0t00 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91
lpfc1t00 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
20:00:00:d0:23:0b:01:91


If I don't have the filsystem mounted (and not mapped via dm-multipath
either), but accessible as sdb/sdc, and then manually fail the
controller, the targetnumber isn't renumbered.



Now my question:
Is there anything I can do to "fix" this, or do I have to "accept" that
this hardware/software-combination can't do what I want?


I'm running CentOS 4.3 on x86_64, running kernel 2.6.9-34.ELsmp which
has a lpfc-driver identifying itself as "Emulex LightPulse Fibre Channe=
l
SCSI driver 8.0.16.18"

--
Roger H=E5kansson

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
