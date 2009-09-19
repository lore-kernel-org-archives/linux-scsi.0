From: =?ISO-8859-1?Q?Marco_Gru=DF?= <kork.test@gmail.com>
Subject: Re: Adaptec 1405 and mvsas
Date: Sun, 20 Sep 2009 00:51:33 +0200
Message-ID: <4AB56075.9030304@gmail.com>
References: <20090904141413.GA29006@hydra2.LF.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.xtra-services.com ([217.110.16.202]:44069 "EHLO
	stargate.xtra-services.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbZISXK1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Sep 2009 19:10:27 -0400
In-Reply-To: <20090904141413.GA29006@hydra2.LF.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sander@humilis.net, Ivo Simicevic <ivo@ultra.hr>

Hello,

following up to my earlier mail from September 4th.

Marco Gru=DF wrote:
> I recently acquired an Adaptec 1405 SAS/SATA HBA.
>=20
> While there is a closed-source driver by Adaptec, called adpinv, I'd =
of
> course like to get it to work with open drivers.
>=20
> A lspci -v reveals that the controller is actually using a Marvell ch=
ip:
>=20
> 02:00.0 Serial Attached SCSI controller: Adaptec Device 0450 (rev 02)
>         Subsystem: Marvell Technology Group Ltd. Device 6440
>=20
> 02:00.0 0107: 9005:0450 (rev 02)
>         Subsystem: 11ab:6440
>=20
> (The output of lspci -vv is attached below)
>=20
> So I simply added an entry for this PCI id to mvsas.c:
>=20
> [...]
>=20
> ...with limited success:

I noticed that the mvsas driver seems to have changed quite a lot
in 2.6.31, since there's now a subdir for it. I figured I'd try
my simple PCI ID hack again:

--- /usr/src/linux-2.6.31/drivers/scsi/mvsas/mv_init.c  2009-09-19 23:0=
9:44.000000000 +0200
+++ /usr/src/linux-2.6.31/drivers/scsi/mvsas/mv_init.c.orig     2009-09=
-10 00:13:59.000000000 +0200
@@ -653,15 +653,6 @@
         { PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
         { PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
         { PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
-       {
-               .vendor         =3D PCI_VENDOR_ID_ADAPTEC2,
-               .device         =3D 0x0450,
-               .subvendor      =3D PCI_VENDOR_ID_MARVELL,
-               .subdevice      =3D 0x6440,
-               .class          =3D 0,
-               .class_mask     =3D 0,
-               .driver_data    =3D chip_6440,
-       },

         { }     /* terminate list */
  };


This time I get the following upon loading (on x86_64):

Sep 19 23:24:42 debian kernel: mvsas 0000:02:00.0: mvsas: driver versio=
n 0.8.2
Sep 19 23:24:42 debian kernel: mvsas 0000:02:00.0: PCI INT A -> GSI 19 =
(level, low) -> IRQ 19
Sep 19 23:24:42 debian kernel: mvsas 0000:02:00.0: setting latency time=
r to 64
Sep 19 23:24:42 debian kernel: mvsas 0000:02:00.0: mvsas: PCI-E x4, Ban=
dwidth Usage: 2.5 Gbps
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1214:port 0 =
attach dev info is 0
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1216:port 0 =
attach sas addr is 0
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1214:port 1 =
attach dev info is 0
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1216:port 1 =
attach sas addr is 0
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1214:port 2 =
attach dev info is 20000
Sep 19 23:24:44 debian kernel: drivers/scsi/mvsas/mv_sas.c 1216:port 2 =
attach sas addr is 2
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 1214:port 3 =
attach dev info is 40400
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 1216:port 3 =
attach sas addr is 3
Sep 19 23:24:45 debian kernel: scsi5 : mvsas
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 380:phy 2 by=
te dmaded.
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 380:phy 3 by=
te dmaded.
Sep 19 23:24:45 debian kernel: sas: phy-5:2 added to port-5:0, phy_mask=
:0x4 ( 200000000000000)
Sep 19 23:24:45 debian kernel: sas: phy-5:3 added to port-5:1, phy_mask=
:0x8 ( 300000000000000)
Sep 19 23:24:45 debian kernel: sas: DOING DISCOVERY on port 0, pid:2236
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 1365:found d=
ev[0:5] is gone.
Sep 19 23:24:45 debian kernel: sas: sas_ata_phy_reset: Found ATA device=
=2E
Sep 19 23:24:45 debian kernel: ata7.00: ATA-7: OCZ-VERTEX, 1.3, max UDM=
A/133
Sep 19 23:24:45 debian kernel: ata7.00: 62533296 sectors, multi 1: LBA4=
8 NCQ (depth 31/32)
Sep 19 23:24:45 debian kernel: ata7.00: configured for UDMA/133
Sep 19 23:24:45 debian kernel: scsi 5:0:0:0: Direct-Access     ATA     =
 OCZ-VERTEX       1.3  PQ: 0 ANSI: 5
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: Attached scsi generic sg3 ty=
pe 0
Sep 19 23:24:45 debian kernel: sas: DONE DISCOVERY on port 0, pid:2236,=
 result:0
Sep 19 23:24:45 debian kernel: sas: DOING DISCOVERY on port 1, pid:2236
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: [sdd] 62533296 512-byte logi=
cal blocks: (32.0 GB/29.8 GiB)
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: [sdd] Write Protect is off
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 0=
0
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: [sdd] Write cache: enabled, =
read cache: enabled, doesn't support DPO or FUA
Sep 19 23:24:45 debian kernel:  sdd: sdd1 sdd2
Sep 19 23:24:45 debian kernel: sd 5:0:0:0: [sdd] Attached SCSI disk
Sep 19 23:24:45 debian kernel: drivers/scsi/mvsas/mv_sas.c 1365:found d=
ev[1:5] is gone.
Sep 19 23:24:45 debian kernel: sas: sas_ata_phy_reset: Found ATAPI devi=
ce.
Sep 19 23:24:45 debian kernel: ata8.00: ATAPI: HL-DT-ST DVDRAM GH20NS15=
, IL00, max UDMA/100
Sep 19 23:24:45 debian kernel: ata8.00: configured for UDMA/100
Sep 19 23:24:45 debian kernel: scsi 5:0:1:0: CD-ROM            HL-DT-ST=
 DVDRAM GH20NS15  IL00 PQ: 0 ANSI: 5
Sep 19 23:24:45 debian kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd=
-ram cd/rw xa/form2 cdda tray
Sep 19 23:24:45 debian kernel: sr 5:0:1:0: Attached scsi CD-ROM sr0
Sep 19 23:24:45 debian kernel: sr 5:0:1:0: Attached scsi generic sg4 ty=
pe 5
Sep 19 23:24:45 debian kernel: sas: DONE DISCOVERY on port 1, pid:2236,=
 result:0

This looks much better; the performance isn't exactly stellar though.

Doing 'sync; time (dd if=3D/dev/zero of=3D1G bs=3D1024 count=3D1024k; s=
ync)'
on the SSD shows me about 40MB/s are written to disk. The same SSD
achieves 150MB/s on an Intel ICH10.

Also, during this experiment, I get some of these in the syslog:

Sep 19 23:25:26 debian kernel: drivers/scsi/mvsas/mv_sas.c 2023:port 2 =
ctrl sts=3D0x199800.
Sep 19 23:25:26 debian kernel: drivers/scsi/mvsas/mv_sas.c 2025:Port 2 =
irq sts =3D 0x1000000
Sep 19 23:25:28 debian kernel: drivers/scsi/mvsas/mv_sas.c 2023:port 2 =
ctrl sts=3D0x199800.
Sep 19 23:25:28 debian kernel: drivers/scsi/mvsas/mv_sas.c 2025:Port 2 =
irq sts =3D 0x1000000
Sep 19 23:25:30 debian kernel: drivers/scsi/mvsas/mv_sas.c 2023:port 2 =
ctrl sts=3D0x199800.
Sep 19 23:25:30 debian kernel: drivers/scsi/mvsas/mv_sas.c 2025:Port 2 =
irq sts =3D 0x1000000

As stated in my previous mail: Anything I can to do help get
this controller working nicely, I'll do ;-)

Thanks!

Marco
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
