From: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Subject: RE: qlogicfc bug
Date: Mon, 5 Jan 2004 15:46:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A979D299E02AD31188EA0000834A03D2087582B9@S64P17BIA40>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jasmin2.sncf.fr ([171.16.4.19]:19176 "EHLO jasmin2.sncf.fr")
	by vger.kernel.org with ESMTP id S264944AbUAEOqt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 09:46:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Yes,
I tried it out but with limited success :

In the exact same context, the qla2xxx + qla2200 modules fail to detect=
 any
device where qlogicfc succeed to see :

xa-s03:~# multipath -v -d
600508b4000156d700012000000b0000 (0 0 1 1) /dev/sda [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (0 0 1 2) /dev/sdb [HSV110 (C)COMPAQ]
60001fe1000bdad0000903507109004b (0 0 3 1) /dev/sdc [HSG80           ]
60001fe1000bdad000090371312100bf (0 0 3 2) /dev/sdd [HSG80           ]
60001fe1000bdad000090371312100c2 (0 0 3 3) /dev/sde [HSG80           ]
60001fe1000bdad00009037131210067 (0 0 4 1) /dev/sdf [HSG80           ]
60001fe1000bdad000090371312100b3 (0 0 4 2) /dev/sdg [HSG80           ]
60001fe1000bdad00009035071090024 (0 0 4 3) /dev/sdh [HSG80           ]
600508b4000156d700012000000b0000 (1 0 1 1) /dev/sdk [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (1 0 1 2) /dev/sdl [HSV110 (C)COMPAQ]

even rescaning through sysfs-host-rescan-attribute doesn't make the LUN=
s
appear with qla----.
(kernel 2.6.0-test10-mm* last time I tried)

did I miss an important step ?


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
