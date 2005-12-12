From: Florian Ernst <florian@uni-hd.de>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Mon, 12 Dec 2005 18:53:42 +0100
Message-ID: <20051212175342.GA3125@ernst.uni-hd.de>
References: <20051121022158.82709.qmail@web88012.mail.re2.yahoo.com> <1133214118.3325.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:42640 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S932074AbVLLRyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 12:54:19 -0500
Content-Disposition: inline
In-Reply-To: <1133214118.3325.59.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 338089@bugs.debian.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Horms <horms@debian.org>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello folks,

following up to this bugreport as I experience similar problems...

I have an ASUS P2B-S mainboard featuring an Adaptec AIC-7890 Ultra2
chipset with a single device connected, a TEAC CD-R55S cd-writer,
both working reliably ever since I bought them in 1998. The transport
setting are as follows:

| Adaptec AIC7xxx driver version: 6.2.36
| Adaptec aic7890/91 Ultra2 SCSI adapter
| aic7890/91: Ultra2 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
| Allocated SCBs: 4, SG List Length: 128
|=20
| Serial EEPROM:
| 0x01bb 0x01bb 0x01bb 0x03f8 0x01f8 0x01bb 0x01bb 0x01bb
| 0x01bb 0x01bb 0x01bb 0x01bb 0x01bb 0x01bb 0x01bb 0x01bb
| 0x18a6 0x1c5e 0x2807 0x3010 0x0300 0xffff 0xffff 0xffff
| 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0300 0xb140
|=20
| Target 0 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 1 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 2 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 3 Negotiation Settings
|         User: 20.000MB/s transfers (10.000MHz, offset 127, 16bit)
(I had an old CD-ROM drive here, but it finally broke a few weeks ago.)
| Target 4 Negotiation Settings
|         User: 10.000MB/s transfers (5.000MHz, offset 127, 16bit)
|         Goal: 10.000MB/s transfers (10.000MHz, offset 15)
|         Curr: 10.000MB/s transfers (10.000MHz, offset 15)
|         Channel A Target 4 Lun 0 Settings
|                 Commands Queued 48
|                 Commands Active 0
|                 Command Openings 1
|                 Max Tagged Openings 0
|                 Device Queue Frozen Count 0
| Target 5 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 6 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 7 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 8 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 9 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 10 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 11 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 12 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 13 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 14 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
| Target 15 Negotiation Settings
|         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)


Kernels up to 2.6.13.3 worked just fine (thanks guys!). However,
when using kernel source 2.6.14.3 from kernel.org, 2.6.14-4 or
2.6.14-5 from Debian Sid (the latter both with and without James'
patch, I just naively assumed it might help) the freshly-built
kernel will allow me to mount any discs just fine, but when I start
a CD recording program (k3b in my case) it won't come up at first,
only to claim no writer device has been found later on.

During this the syslog shows:

| Dec 12 17:40:04 live k3b: resmgr: communication failure: No such file or =
directory
| Dec 12 17:41:04 live kernel: scsi0:0:4:0: Attempting to queue an ABORT me=
ssage
| Dec 12 17:41:04 live kernel: CDB: 0x12 0x0 0x0 0x0 0x24 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0
| Dec 12 17:41:04 live kernel: scsi0: At time of recovery, card was not pau=
sed
| Dec 12 17:41:04 live kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<=
<<<<<<<<<<<<<<<
| Dec 12 17:41:04 live kernel: scsi0: Dumping Card State in Command phase, =
at SEQADDR 0xb7
| Dec 12 17:41:04 live kernel: Card was paused
| Dec 12 17:41:04 live kernel: ACCUM =3D 0x80, SINDEX =3D 0xa0, DINDEX =3D =
0xe4, ARG_2 =3D 0x0
| Dec 12 17:41:04 live kernel: HCNT =3D 0xc SCBPTR =3D 0x0
| Dec 12 17:41:04 live kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUS=
L[0x20]
| Dec 12 17:41:04 live kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOA=
TNP|ENRSELI)
| Dec 12 17:41:04 live kernel: SBLKCTL[0x6]:(SELWIDE|ENAB20) SCSIRATE[0x18]=
:(SINGLE_EDGE)
| Dec 12 17:41:04 live kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT=
0[0x0]
| Dec 12 17:41:04 live kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x40]:=
(SHVALID)
| Dec 12 17:41:04 live kernel: SSTAT3[0xf]:(OFFCNT) SIMODE0[0x8]:(ENSWRAP) =
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
| Dec 12 17:41:04 live kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTI=
ON|SCSIEN)
| Dec 12 17:41:04 live kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL)
| Dec 12 17:41:04 live kernel: STACK: 0x0 0x167 0x17d 0x35
| Dec 12 17:41:04 live kernel: SCB count =3D 4
| Dec 12 17:41:04 live kernel: Kernel NEXTQSCB =3D 3
| Dec 12 17:41:04 live kernel: Card NEXTQSCB =3D 3
| Dec 12 17:41:04 live kernel: QINFIFO entries:
| Dec 12 17:41:04 live kernel: Waiting Queue entries:
| Dec 12 17:41:04 live kernel: Disconnected Queue entries:
| Dec 12 17:41:04 live kernel: QOUTFIFO entries:
| Dec 12 17:41:04 live kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 1=
0 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
| Dec 12 17:41:04 live kernel: Sequencer SCB Info:
| Dec 12 17:41:04 live kernel:   0 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0=
x47] SCB_LUN[0x0]
| Dec 12 17:41:04 live kernel: SCB_TAG[0x2]
| Dec 12 17:41:04 live kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_=
CHNLB|OID|TWIN_TID)
| Dec 12 17:41:04 live kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[=
0xff]
=2E..now identically counting up from 2 to 30...
| Dec 12 17:41:04 live kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_=
CHNLB|OID|TWIN_TID)
| Dec 12 17:41:04 live kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[=
0xff]
| Dec 12 17:41:04 live kernel: Pending list:
| Dec 12 17:41:04 live kernel:   2 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0=
x47] SCB_LUN[0x0]
| Dec 12 17:41:04 live kernel: Kernel Free SCB list: 1 0
| Dec 12 17:41:04 live kernel: Untagged Q(4): 2
| Dec 12 17:41:04 live kernel:
| Dec 12 17:41:04 live kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>=
>>>>>>>>>>>>>
| Dec 12 17:41:04 live kernel: scsi0:0:4:0: Device is active, asserting ATN
| Dec 12 17:41:04 live kernel: Recovery code sleeping
| Dec 12 17:41:09 live kernel: Recovery code awake
| Dec 12 17:41:09 live kernel: Timer Expired
| Dec 12 17:41:09 live kernel: aic7xxx_abort returns 0x2003
| Dec 12 17:41:09 live kernel: scsi0:0:4:0: Attempting to queue a TARGET RE=
SET message
| Dec 12 17:41:09 live kernel: CDB: 0x12 0x0 0x0 0x0 0x24 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0
| Dec 12 17:41:09 live kernel: aic7xxx_dev_reset returns 0x2003
| Dec 12 17:41:09 live kernel: Recovery SCB completes
| Dec 12 17:41:19 live kernel:  target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100=
 ns, offset 15)
| Dec 12 17:42:19 live kernel: scsi0:0:4:0: Attempting to queue an ABORT me=
ssage
| Dec 12 17:42:19 live kernel: CDB: 0x12 0x0 0x0 0x0 0x24 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0
| Dec 12 17:42:19 live kernel: scsi0: At time of recovery, card was not pau=
sed
| Dec 12 17:42:19 live kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<=
<<<<<<<<<<<<<<<
| Dec 12 17:42:19 live kernel: scsi0: Dumping Card State in Command phase, =
at SEQADDR 0xb7
| Dec 12 17:42:19 live kernel: Card was paused
| Dec 12 17:42:19 live kernel: ACCUM =3D 0x80, SINDEX =3D 0xa0, DINDEX =3D =
0xe4, ARG_2 =3D 0x0
| Dec 12 17:42:19 live kernel: HCNT =3D 0xc SCBPTR =3D 0x0
| Dec 12 17:42:19 live kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUS=
L[0x20]
| Dec 12 17:42:19 live kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOA=
TNP|ENRSELI)
| Dec 12 17:42:19 live kernel: SBLKCTL[0x6]:(SELWIDE|ENAB20) SCSIRATE[0x18]=
:(SINGLE_EDGE)
| Dec 12 17:42:19 live kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT=
0[0x0]
| Dec 12 17:42:19 live kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x40]:=
(SHVALID)
| Dec 12 17:42:19 live kernel: SSTAT3[0xf]:(OFFCNT) SIMODE0[0x8]:(ENSWRAP) =
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
| Dec 12 17:42:19 live kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTI=
ON|SCSIEN)
| Dec 12 17:42:19 live kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL)
| Dec 12 17:42:19 live kernel: STACK: 0x0 0x167 0x17d 0x35
| Dec 12 17:42:19 live kernel: SCB count =3D 4
| Dec 12 17:42:19 live kernel: Kernel NEXTQSCB =3D 2
| Dec 12 17:42:19 live kernel: Card NEXTQSCB =3D 2
| Dec 12 17:42:19 live kernel: QINFIFO entries:
| Dec 12 17:42:19 live kernel: Waiting Queue entries:
| Dec 12 17:42:19 live kernel: Disconnected Queue entries:
| Dec 12 17:42:19 live kernel: QOUTFIFO entries:
| Dec 12 17:42:19 live kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 1=
0 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
| Dec 12 17:42:19 live kernel: Sequencer SCB Info:
| Dec 12 17:42:19 live kernel:   0 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0=
x47] SCB_LUN[0x0]
| Dec 12 17:42:19 live kernel: SCB_TAG[0x3]
| Dec 12 17:42:19 live kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_=
CHNLB|OID|TWIN_TID)
| Dec 12 17:42:19 live kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[=
0xff]
=2E..and now repeating this in a loop.


Well, I severely lack knowledge of kernel internals, so I'm quite lost
now. Please tell me what further information you might need, and I will
provide them.
Also I'm willing to test any patches that are thrown at me, so please
bear with me. :)


Cheers,
Flo

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDnbkms3U+TVFLPnwRAvBhAJ9X3znYQBiwUGCbwP0uhnMKwP3CDACdGIHF
ruHXpqvSjX6SeuFD6k4BskY=
=63LJ
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
