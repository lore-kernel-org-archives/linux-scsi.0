From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: missing mptsas support for  LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS [1000:0055] (rev 02)
Date: Fri, 19 Nov 2010 21:30:33 +0100
Message-ID: <201011192130.33459.a.miskiewicz@gmail.com>
References: <201011191842.25939.a.miskiewicz@gmail.com> <201011191939.07573.a.miskiewicz@gmail.com> <D41A5B864986B546A595D85C4701A9C00102055408@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39014 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0KSUai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 15:30:38 -0500
Received: by eye27 with SMTP id 27so3024013eye.19
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 12:30:36 -0800 (PST)
In-Reply-To: <D41A5B864986B546A595D85C4701A9C00102055408@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Unrein, Jason" <Jason.Unrein@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Friday 19 of November 2010, Unrein, Jason wrote:
> Is this an on board MPT chip or is it an add-in HBA?  I'm not aware o=
f a
> DID of 0x55.  More than likely it=E2=80=99s either a megaraid board o=
r a customer
> tweaked something of ours. A photo of it if it's an add-in or a link =
to
> the product it's in would help narrow it down.  Also, if it's an mptl=
inux
> card, there should be two identifications on it.  Both should be on a
> white label with a barcode.  One will be SAS3####X... The other will =
be
> L#-####-###.

I'm almost sure it's onboard controller (cannot check, machine is avail=
able=20
remotely only).  It's Intel SR1550 server.

Anyway I found a option in normal BIOS to disable "intel swraid" and no=
w it is=20
detected nicely by mptsas without any new_id tweaks (becomes visible un=
der=20
pciid already known to mptsas).

Thanks!

> -----Original Message-----
> From: Arkadiusz Miskiewicz [mailto:a.miskiewicz@gmail.com]
> Sent: Friday, November 19, 2010 12:39 PM
> To: Moore, Eric
> Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: Re: missing mptsas support for LSI Logic / Symbios Logic SAS=
1068
> PCI-X Fusion-MPT SAS [1000:0055] (rev 02)
>=20
> On Friday 19 of November 2010, Arkadiusz Miskiewicz wrote:
> > Hi,
> >=20
> > I wonder if mptsas driver is able to support this hardware?
> >=20
> > 04:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic S=
AS1068
> > PCI- X Fusion-MPT SAS [1000:0055] (rev 02)
> >=20
> >         Subsystem: Intel Corporation Device [8086:3504]
> >=20
> > Currently driver doesn't handle 1000:0055 pciid. The problem seems =
quite
> > old since I found someone asking for it long time ago
> > http://lkml.org/lkml/2007/1/23/87
>=20
> [root@rescue mptsas]# echo 1000 0055 > new_id
> [root@rescue mptsas]#
>=20
> drives were detected, I was able to create filesystem, write, read fe=
w
> files and these short tests worked well.
>=20
> So I wonder what's the case with it not being added to mptsas driver?
> Thanks.
>=20
> [ 5689.436551] mptsas 0000:04:08.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ
> 16 [ 5689.436886] mptbase: ioc0: Initiating bringup
> [ 5690.042770] ioc0: : Capabilities=3D{Initiator}
> [ 5699.421066] scsi8 : ioc0: , FwRev=3D01120000h, Ports=3D1, MaxQ=3D5=
11, IRQ=3D16
> [ 5699.458704] mptsas: ioc0: attaching sata device: fw_channel 0, fw_=
id 0,
> phy 0, sas_addr 0x1221000000000000 [ 5699.461495] scsi 8:0:0:0:
> Direct-Access     ATA      ST9500420AS      SDM1 PQ: 0 ANSI: 5 [
> 5699.465182] sd 8:0:0:0: [sda] 976773168 512-byte logical blocks: (50=
0
> GB/465 GiB) [ 5699.465822] mptsas: ioc0: attaching sata device: fw_ch=
annel
> 0, fw_id 1, phy 1, sas_addr 0x1221000001000000 [ 5699.466599] sd 8:0:=
0:0:
> Attached scsi generic sg0 type 0
> [ 5699.469232] scsi 8:0:1:0: Direct-Access     ATA      ST9500420AS  =
  =20
> SDM1 PQ: 0 ANSI: 5 [ 5699.471140] sd 8:0:1:0: Attached scsi generic s=
g1
> type 0
> [ 5699.472842] sd 8:0:1:0: [sdb] 976773168 512-byte logical blocks: (=
500
> GB/465 GiB) [ 5699.801422] sd 8:0:0:0: [sda] Write Protect is off
> [ 5699.801425] sd 8:0:0:0: [sda] Mode Sense: 73 00 00 08
> [ 5699.806427] sd 8:0:1:0: [sdb] Write Protect is off
> [ 5699.806431] sd 8:0:1:0: [sdb] Mode Sense: 73 00 00 08
> [ 5699.822024] sd 8:0:0:0: [sda] Write cache: enabled, read cache: en=
abled,
> doesn't support DPO or FUA [ 5699.827135] sd 8:0:1:0: [sdb] Write cac=
he:
> enabled, read cache: enabled, doesn't support DPO or FUA [ 5699.92810=
8]=20
> sda:
> [ 5699.933163]  sdb: unknown partition table
> [ 5699.962440]  unknown partition table
> [ 5700.068369] sd 8:0:0:0: [sda] Attached SCSI disk
> [ 5700.073759] sd 8:0:1:0: [sdb] Attached SCSI disk


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
