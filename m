From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: Still having major MVSAS issues.
Date: Sat, 10 Apr 2010 21:02:32 +0200
Message-ID: <4BC0CB48.6000207@powercraft.nl>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>       <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>       <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>       <CDBC7B5488B245E689B39330542DC434@usish.com.cn>       <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>       <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>       <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org> <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:53367 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab0DJTMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 15:12:42 -0400
In-Reply-To: <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>, linux-scsi@vger.kernel.org

Hello everybody,

Caspar Smit wrote, on 09-04-10 17:52:
> I'm still having troubles with SATA disks using the mvsas driver. 
> Maybe you read my previous posts about the WD disks.

I would like to confirm a lot of the issues. I saw the emails from
Caspar Smits passing by the last few days. I got a bunch of the below
storage controllers for testing, and I am not yet able to actually use
them stable.

My major killer issue is that the I am unable to load my Linux kernel
and root file system from the SATA disks attached to the controller.
Grub works fine and starts the initrd, but then mdadm fails because
the hard disk are not found fast enough by the Linux kernel and I see
"HDIO_GET_IDENTITY failed for" messages for all the connected hard drives.

Some system and hardware information.

# cat /proc/version
Linux version 2.6.32-4-amd64 (Debian 2.6.32-11) (maks@debian.org) (gcc
version 4.3.4 (Debian 4.3.4-8) ) #1 SMP Tue Apr 6 08:21:34 UTC 2010

# lspci -nn | grep SCSI
02:00.0 SCSI storage controller [0100]: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B [11ab:6485] (rev 01)

# modinfo mvsas
filename: /lib/modules/2.6.32-4-amd64/../../scsi/mvsas/mvsas.ko
version: 0.8.2
description: Marvell 88SE6440 SAS/SATA controller driver
srcversion: EE82F304DFF3A7F06086B62

Messages I also got:

[15926.816036]
/build/buildd-linux-2.6_2.6.32-11-i386-4fW2zP/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5

And the HDIO_GET_IDENTITY failed for .. stuff during boot.

I also noticed that some of the attached drives worked fine with:
smartctl -d sat -H /dev/sda but some of the identical drives did not
worked and needed the -T permissive options...

BTW I also have some 04:06.0 SCSI storage controller [0100]: Marvell
Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller
[11ab:6081] (rev 09) hardware and those use the sata_mv module. This
system works stable and no errors during boot. However the SATA
interfaces are very slow here because of the PCI bus limitation of the
hardware.

The MV88SX6081 card also boots very vast to grub compared with the
MV64460/64461/64462 card. Is there something that can be done about
this? I would really like the usability of the MV88SX6081 card but
with the full speed of the SATA links of the PCI-E enabled mvsas cards.

For those intressted I use them with mdadm raid1 with two device
pairs, with lvm2 with striping and ext4 file systems. The root file
system is also on this raid,lvm,ext4 layout.

Thanks in advance,

Kind regards,

Jelle de Jong
