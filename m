From: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Subject: RE: qlogicfc bug
Date: Mon, 5 Jan 2004 16:19:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A979D299E02AD31188EA0000834A03D2087582BA@S64P17BIA40>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jasmin1.sncf.fr ([171.16.4.18]:29577 "EHLO jasmin1.sncf.fr")
	by vger.kernel.org with ESMTP id S265060AbUAEPTv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 10:19:51 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

mmm,

btw, qla2xxx doesn't seem to decrement the host counter.
I retested with 2.6.0-mm2 with same results.
Here's the trace :

Jan  5 16:14:05 xa-s03 kernel: qla2200 0000:03:01.0: Found an ISP2200, =
irq
20, iobase 0xf8833000
Jan  5 16:14:05 xa-s03 kernel: qla2200 0000:03:01.0: Configuring PCI
space...
Jan  5 16:14:05 xa-s03 kernel: qla2200 0000:03:01.0: Configure NVRAM
parameters...
Jan  5 16:14:05 xa-s03 kernel: qla2200 0000:03:01.0: Verifying loaded R=
ISC
code...
Jan  5 16:14:05 xa-s03 kernel: qla2200 0000:03:01.0: Waiting for LIP to
complete...
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:03:01.0: LOOP UP detected (=
1
Gbps).
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:03:01.0: Topology - (F_Port=
),
Host Loop address 0xffff
Jan  5 16:14:08 xa-s03 kernel: scsi8 : qla2xxx
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:03:01.0:=20
Jan  5 16:14:08 xa-s03 kernel:  QLogic ISP2xxx PCI/PCI-X Fibre Channel =
HBA
Driver: 8.00.00b8
Jan  5 16:14:08 xa-s03 kernel:   QLogic QLA22xx -=20
Jan  5 16:14:08 xa-s03 kernel:   ISP2200: PCI (66 MHz) @ 0000:03:01.0 h=
dma-,
host#=3D8, fw=3D2.02.06 TP

Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: Found an ISP2200, =
irq
24, iobase 0xf8839000
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: Configuring PCI
space...
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: Configure NVRAM
parameters...
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: Verifying loaded R=
ISC
code...
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: Waiting for LIP to
complete...
Jan  5 16:14:08 xa-s03 kernel: qla2200 0000:06:01.0: LIP reset occured
(f7f7).
Jan  5 16:14:10 xa-s03 kernel: qla2200 0000:06:01.0: LOOP UP detected (=
1
Gbps).
Jan  5 16:14:10 xa-s03 kernel: qla2200 0000:06:01.0: Topology - (F_Port=
),
Host Loop address 0xffff
Jan  5 16:14:10 xa-s03 kernel: scsi9 : qla2xxx
Jan  5 16:14:10 xa-s03 kernel: qla2200 0000:06:01.0:=20
Jan  5 16:14:10 xa-s03 kernel:  QLogic ISP2xxx PCI/PCI-X Fibre Channel =
HBA
Driver: 8.00.00b8
Jan  5 16:14:10 xa-s03 kernel:   QLogic QLA22xx -=20
Jan  5 16:14:10 xa-s03 kernel:   ISP2200: PCI (66 MHz) @ 0000:06:01.0 h=
dma-,
host#=3D9, fw=3D2.02.06 TP


still no device seen.
I tried modules params "ql2xplogiabsentdevice=3D1" and "ql2xdoinitscan=3D=
1" with
no success either.

regards,
cvaroqui

> -----Message d'origine-----
> De:	Christoph Hellwig [SMTP:hch@infradead.org]
> Date:	lundi 5 janvier 2004 15:36
> =C0:	EXT / DEVOTEAM VAROQUI Christophe
> Cc:	'linux-scsi@vger.kernel.org'
> Objet:	Re: qlogicfc bug
>=20
> On Mon, Jan 05, 2004 at 03:29:49PM +0100, EXT / DEVOTEAM VAROQUI
> Christophe wrote:
> > Hello,
> >=20
> > here is the kernel output of a bug in qlogicfc portdb.
> > Output is truncated, but I can't do better : the server hangs hard.
> >=20
> > Context :
> > Server with 2 qlogic 2200 connected to a storageworks array eva5000
> through
> > silkworm 3800.
> > Kernel is 2.6.0-mm2 + unstable device mapper stuff for multipath.
> >=20
> > Bug spawns when rebooting the active FC-RAID controler during strea=
ming
> IO
> > on a LUN.
>=20
> The qlogicfc driver is extremly buggy.  I'd suggest using qlogic's dr=
iver
> (http://sf.net/projects/linux-qla2xxx) instead.  It's planned to merg=
e
> that driver into the kernel tree and replace qlogicfs once a few smal=
ler
> issues are worked out.=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
