From: Andrew Morton <akpm@osdl.org>
Subject: Fw: panic with AIC7xxx
Date: Fri, 28 Oct 2005 16:47:00 -0700
Message-ID: <20051028164700.6a2eea33.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6355 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750784AbVJ1XrD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 19:47:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Emmanuel =?ISO-8859-1?Q?Fust=E9?= <emmanuel.fuste@laposte.net>



Begin forwarded message:

Date: Sat, 29 Oct 2005 01:34:20 +0200
=46rom: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: panic with AIC7xxx


Hello,

I recently made the switch from 2.4.26 to 2.6.13 and 2.6.14rc5 on my ol=
d
dual 586mmx 233mhz.

I've got many problems with SMP on 2.6.13 (bad irq balancing/routing
very bad performance on IDE and SCSI) but I tried to use the long
awaited CDRW support.
I format a disc with cdrwtools -d/dev/cdrw -t4 -q
the initialisation of the disc start and ~5min later I got :

Oct 20 20:44:57 rafale kernel: scsi0:0:3:0: Attempting to queue an ABOR=
T message
Oct 20 20:44:57 rafale kernel: CDB: 0x4 0x17 0x0 0x0 0x0 0x0
Oct 20 20:44:57 rafale kernel: scsi0: At time of recovery, card was not=
 paused
Oct 20 20:44:57 rafale kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begin=
s <<<<<<<<<<<<<<<<<
Oct 20 20:44:57 rafale kernel: scsi0: Dumping Card State while idle, at=
 SEQADDR 0x9
Oct 20 20:44:57 rafale kernel: Card was paused
Oct 20 20:44:57 rafale kernel: ACCUM =3D 0x0, SINDEX =3D 0x4, DINDEX =3D=
 0xe4, ARG_2 =3D 0x0
Oct 20 20:44:57 rafale kernel: HCNT =3D 0x0 SCBPTR =3D 0x7
Oct 20 20:44:57 rafale kernel: SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] L=
ASTPHASE[0x1]:(P_BUSFREE)=20
Oct 20 20:44:57 rafale kernel: SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKC=
TL[0xa]:(SELWIDE|SELBUSB)=20
Oct 20 20:44:57 rafale kernel: SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) SE=
Q_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)=20
Oct 20 20:44:57 rafale kernel: SSTAT0[0x0] SSTAT1[0xa]:(PHASECHG|BUSFRE=
E) SSTAT2[0x0]=20
Oct 20 20:44:57 rafale kernel: SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) SIMOD=
E1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)=20
Oct 20 20:44:57 rafale kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] DFSTA=
TUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)=20
Oct 20 20:44:57 rafale kernel: STACK: 0x0 0x166 0x10c 0x3
Oct 20 20:44:57 rafale kernel: SCB count =3D 12
Oct 20 20:44:57 rafale kernel: Kernel NEXTQSCB =3D 2
Oct 20 20:44:57 rafale kernel: Card NEXTQSCB =3D 2
Oct 20 20:44:57 rafale kernel: QINFIFO entries:=20
Oct 20 20:44:57 rafale kernel: Waiting Queue entries:=20
Oct 20 20:44:57 rafale kernel: Disconnected Queue entries: 0:11=20
Oct 20 20:44:57 rafale kernel: QOUTFIFO entries:=20
Oct 20 20:44:57 rafale kernel: Sequencer Free SCB List: 7 4 5 3 1 8 6 2=
 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31=20
Oct 20 20:44:57 rafale kernel: Sequencer SCB Info:=20
Oct 20 20:44:57 rafale kernel:   0 SCB_CONTROL[0x44]:(DISCONNECTED|DISC=
ENB) SCB_SCSIID[0x37]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xb]=20
Oct 20 20:44:57 rafale kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   8 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 20 20:44:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 20 20:44:57 rafale kernel: Pending list:=20
Oct 20 20:44:57 rafale kernel:  11 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 20 20:44:57 rafale kernel: Kernel Free SCB list: 4 1 0 5 7 3 6 10 9=
 8=20
Oct 20 20:44:57 rafale kernel: Untagged Q(3): 11=20
Oct 20 20:44:57 rafale kernel:=20
Oct 20 20:44:57 rafale kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >=
>>>>>>>>>>>>>>>>>
Oct 20 20:44:57 rafale kernel: (scsi0:A:3:0): Device is disconnected, r=
e-queuing SCB
Oct 20 20:44:57 rafale kernel: Recovery code sleeping
Oct 20 20:44:57 rafale kernel: Recovery SCB completes
Oct 20 20:44:57 rafale kernel: Recovery code awake
Oct 20 20:44:57 rafale kernel: aic7xxx_abort returns 0x2002
Oct 20 20:44:57 rafale kernel: scsi0:0:3:0: Attempting to queue a TARGE=
T RESET message
Oct 20 20:44:57 rafale kernel: CDB: 0x4 0x17 0x0 0x0 0x0 0x0
Oct 20 20:44:57 rafale kernel: scsi0:0:3:0: Command not found
Oct 20 20:44:57 rafale kernel: aic7xxx_dev_reset returns 0x2002
Oct 20 20:45:08 rafale kernel: scsi: Device offlined - not ready after =
error recovery: host 0 channel 0 id 3 lun 0
Oct 20 20:45:08 rafale kernel: scsi0 (3:0): rejecting I/O to offline de=
vice



Now I use a 2.6.14rc5 kernel with great results from a performance stan=
d
point: no longer bad SMP IRQ routing/balancing, good perfs for IDE and
SCSI disc but when I try to blank a disc with the same command:
cdrwtools -d/dev/cdrw -t4 -q
Nothing append and the cd-writer/scsi bus directly crash:
Oct 26 21:07:57 rafale kernel: scsi0:0:3:0: Attempting to queue an ABOR=
T message
Oct 26 21:07:57 rafale kernel: CDB: 0x5c 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x=
c 0x0 0x0 0x0
Oct 26 21:07:57 rafale kernel: scsi0: At time of recovery, card was not=
 paused
Oct 26 21:07:57 rafale kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begin=
s <<<<<<<<<<<<<<<<<
Oct 26 21:07:57 rafale kernel: scsi0: Dumping Card State in Command pha=
se, at SEQADDR 0xb8
Oct 26 21:07:57 rafale kernel: Card was paused
Oct 26 21:07:57 rafale kernel: ACCUM =3D 0x80, SINDEX =3D 0xa0, DINDEX =
=3D 0xe4, ARG_2 =3D 0x1
Oct 26 21:07:57 rafale kernel: HCNT =3D 0xc SCBPTR =3D 0x4
Oct 26 21:07:57 rafale kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCS=
IBUSL[0x0]=20
Oct 26 21:07:57 rafale kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENA=
UTOATNP|ENRSELI)=20
Oct 26 21:07:57 rafale kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[=
0x18]:(SINGLE_EDGE)=20
Oct 26 21:07:57 rafale kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] S=
STAT0[0x0]=20
Oct 26 21:07:57 rafale kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x=
50]:(EXP_ACTIVE|SHVALID)=20
Oct 26 21:07:57 rafale kernel: SSTAT3[0xc] SIMODE0[0x8]:(ENSWRAP) SIMOD=
E1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)=20
Oct 26 21:07:57 rafale kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIR=
ECTION|SCSIEN)=20
Oct 26 21:07:57 rafale kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL)=20
Oct 26 21:07:57 rafale kernel: STACK: 0x0 0x167 0x17d 0x35
Oct 26 21:07:57 rafale kernel: SCB count =3D 12
Oct 26 21:07:57 rafale kernel: Kernel NEXTQSCB =3D 6
Oct 26 21:07:57 rafale kernel: Card NEXTQSCB =3D 6
Oct 26 21:07:57 rafale kernel: QINFIFO entries:=20
Oct 26 21:07:57 rafale kernel: Waiting Queue entries:=20
Oct 26 21:07:57 rafale kernel: Disconnected Queue entries:=20
Oct 26 21:07:57 rafale kernel: QOUTFIFO entries:=20
Oct 26 21:07:57 rafale kernel: Sequencer Free SCB List: 8 0 7 5 3 6 1 2=
 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31=20
Oct 26 21:07:57 rafale kernel: Sequencer SCB Info:=20
Oct 26 21:07:57 rafale kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   1 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:07:57 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   3 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:07:57 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   4 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:07:57 rafale kernel: SCB_TAG[0x7]=20
Oct 26 21:07:57 rafale kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   7 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:07:57 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   8 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:07:57 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:07:57 rafale kernel: Pending list:=20
Oct 26 21:07:57 rafale kernel:   7 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:07:57 rafale kernel: Kernel Free SCB list: 3 5 4 0 11 2 1 10 =
9 8=20
Oct 26 21:07:57 rafale kernel: Untagged Q(3): 7=20
Oct 26 21:07:57 rafale kernel:=20
Oct 26 21:07:57 rafale kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >=
>>>>>>>>>>>>>>>>>
Oct 26 21:07:57 rafale kernel: scsi0:0:3:0: Device is active, asserting=
 ATN
Oct 26 21:07:57 rafale kernel: Recovery code sleeping
Oct 26 21:07:57 rafale kernel: (scsi0:A:3:0): Abort Message Sent
Oct 26 21:07:57 rafale kernel: (scsi0:A:3:0): Recovery SCB completes
Oct 26 21:07:57 rafale kernel: Recovery code awake
Oct 26 21:07:57 rafale kernel: Unexpected busfree in Message-out phase
Oct 26 21:07:57 rafale kernel: SEQADDR =3D=3D 0x1a8
Oct 26 21:07:57 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:3:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x5c 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x=
c 0x0 0x0 0x0
Oct 26 21:08:58 rafale kernel: scsi0: At time of recovery, card was not=
 paused
Oct 26 21:08:58 rafale kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begin=
s <<<<<<<<<<<<<<<<<
Oct 26 21:08:58 rafale kernel: scsi0: Dumping Card State in Command pha=
se, at SEQADDR 0xb8
Oct 26 21:08:58 rafale kernel: Card was paused
Oct 26 21:08:58 rafale kernel: ACCUM =3D 0x80, SINDEX =3D 0xa0, DINDEX =
=3D 0xe4, ARG_2 =3D 0x1
Oct 26 21:08:58 rafale kernel: HCNT =3D 0xc SCBPTR =3D 0x4
Oct 26 21:08:58 rafale kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCS=
IBUSL[0x0]=20
Oct 26 21:08:58 rafale kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENA=
UTOATNP|ENRSELI)=20
Oct 26 21:08:58 rafale kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[=
0x18]:(SINGLE_EDGE)=20
Oct 26 21:08:58 rafale kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] S=
STAT0[0x0]=20
Oct 26 21:08:58 rafale kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x=
50]:(EXP_ACTIVE|SHVALID)=20
Oct 26 21:08:58 rafale kernel: SSTAT3[0xc] SIMODE0[0x8]:(ENSWRAP) SIMOD=
E1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)=20
Oct 26 21:08:58 rafale kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIR=
ECTION|SCSIEN)=20
Oct 26 21:08:58 rafale kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL)=20
Oct 26 21:08:58 rafale kernel: STACK: 0xe4 0x167 0x17d 0x35
Oct 26 21:08:58 rafale kernel: SCB count =3D 12
Oct 26 21:08:58 rafale kernel: Kernel NEXTQSCB =3D 10
Oct 26 21:08:58 rafale kernel: Card NEXTQSCB =3D 7
Oct 26 21:08:58 rafale kernel: QINFIFO entries: 7 3 5 4 0 11 2 1=20
Oct 26 21:08:58 rafale kernel: Waiting Queue entries:=20
Oct 26 21:08:58 rafale kernel: Disconnected Queue entries:=20
Oct 26 21:08:58 rafale kernel: QOUTFIFO entries:=20
Oct 26 21:08:58 rafale kernel: Sequencer Free SCB List: 8 0 7 5 3 6 1 2=
 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31=20
Oct 26 21:08:58 rafale kernel: Sequencer SCB Info:=20
Oct 26 21:08:58 rafale kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   1 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   3 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   4 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: SCB_TAG[0x6]=20
Oct 26 21:08:58 rafale kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   7 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_S=
CSIID[0x47] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   8 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|T=
ARGET_SCB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel: Pending list:=20
Oct 26 21:08:58 rafale kernel:   1 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:  11 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   0 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   4 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   5 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   7 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   6 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: Kernel Free SCB list: 9 8=20
Oct 26 21:08:58 rafale kernel: Untagged Q(3): 6=20
Oct 26 21:08:58 rafale kernel:=20
Oct 26 21:08:58 rafale kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >=
>>>>>>>>>>>>>>>>>
Oct 26 21:08:58 rafale kernel: scsi0:0:3:0: Device is active, asserting=
 ATN
Oct 26 21:08:58 rafale kernel: Recovery code sleeping
Oct 26 21:08:58 rafale kernel: (scsi0:A:3:0): Abort Message Sent
Oct 26 21:08:58 rafale kernel: (scsi0:A:3:0): Recovery SCB completes
Oct 26 21:08:58 rafale kernel: Unexpected busfree in Message-out phase
Oct 26 21:08:58 rafale kernel: SEQADDR =3D=3D 0x1a8
Oct 26 21:08:58 rafale kernel: Recovery code awake
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x81 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x8a 0x2b 0xa1 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0xa2 0xef 0x1 0x0 0x0 =
0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0xa2 0xef 0x59 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x19 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x31 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x91 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x8a 0x2b 0xa9 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:3:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x5c 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x=
c 0x0 0x0 0x0
Oct 26 21:08:58 rafale kernel: scsi0: At time of recovery, card was not=
 paused
Oct 26 21:08:58 rafale kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begin=
s <<<<<<<<<<<<<<<<<
Oct 26 21:08:58 rafale kernel: scsi0: Dumping Card State in Command pha=
se, at SEQADDR 0xb7
Oct 26 21:08:58 rafale kernel: Card was paused
Oct 26 21:08:58 rafale kernel: ACCUM =3D 0x80, SINDEX =3D 0xa0, DINDEX =
=3D 0xe4, ARG_2 =3D 0x2
Oct 26 21:08:58 rafale kernel: HCNT =3D 0xc SCBPTR =3D 0x4
Oct 26 21:08:58 rafale kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCS=
IBUSL[0x0]=20
Oct 26 21:08:58 rafale kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENA=
UTOATNP|ENRSELI)=20
Oct 26 21:08:58 rafale kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[=
0x18]:(SINGLE_EDGE)=20
Oct 26 21:08:58 rafale kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] S=
STAT0[0x0]=20
Oct 26 21:08:58 rafale kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x=
50]:(EXP_ACTIVE|SHVALID)=20
Oct 26 21:08:58 rafale kernel: SSTAT3[0xc] SIMODE0[0x8]:(ENSWRAP) SIMOD=
E1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)=20
Oct 26 21:08:58 rafale kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIR=
ECTION|SCSIEN)=20
Oct 26 21:08:58 rafale kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL)=20
Oct 26 21:08:58 rafale kernel: STACK: 0xe4 0x167 0x17d 0x35
Oct 26 21:08:58 rafale kernel: SCB count =3D 12
Oct 26 21:08:58 rafale kernel: Kernel NEXTQSCB =3D 6
Oct 26 21:08:58 rafale kernel: Card NEXTQSCB =3D 3
Oct 26 21:08:58 rafale kernel: QINFIFO entries: 3=20
Oct 26 21:08:58 rafale kernel: Waiting Queue entries:=20
Oct 26 21:08:58 rafale kernel: Disconnected Queue entries: 8:0 5:11 3:2=
 6:5 0:4 7:1 1:7=20
Oct 26 21:08:58 rafale kernel: QOUTFIFO entries:=20
Oct 26 21:08:58 rafale kernel: Sequencer Free SCB List: 2 9 10 11 12 13=
 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31=20
Oct 26 21:08:58 rafale kernel: Sequencer SCB Info:=20
Oct 26 21:08:58 rafale kernel:   0 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x4]=20
Oct 26 21:08:58 rafale kernel:   1 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x7]=20
Oct 26 21:08:58 rafale kernel:   2 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SC=
B) SCB_SCSIID[0x37]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:   3 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x2]=20
Oct 26 21:08:58 rafale kernel:   4 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: SCB_TAG[0xa]=20
Oct 26 21:08:58 rafale kernel:   5 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0xb]=20
Oct 26 21:08:58 rafale kernel:   6 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x5]=20
Oct 26 21:08:58 rafale kernel:   7 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x1]=20
Oct 26 21:08:58 rafale kernel:   8 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_=
ENB|DISCENB) SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0] SCB_TAG[0x0]=20
Oct 26 21:08:58 rafale kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(T=
WIN_CHNLB|OID|TWIN_TID)=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_=
TAG[0xff]=20
Oct 26 21:08:58 rafale kernel: Pending list:=20
Oct 26 21:08:58 rafale kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSI=
ID[0x37] SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   0 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:  11 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   5 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   4 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   1 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel:   7 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) =
SCB_SCSIID[0x7]=20
Oct 26 21:08:58 rafale kernel: SCB_LUN[0x0]=20
Oct 26 21:08:58 rafale kernel: Kernel Free SCB list: 9 8=20
Oct 26 21:08:58 rafale kernel: Untagged Q(3): 10=20
Oct 26 21:08:58 rafale kernel:=20
Oct 26 21:08:58 rafale kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >=
>>>>>>>>>>>>>>>>>
Oct 26 21:08:58 rafale kernel: scsi0:0:3:0: Device is active, asserting=
 ATN
Oct 26 21:08:58 rafale kernel: Recovery code sleeping
Oct 26 21:08:58 rafale kernel: (scsi0:A:3:0): Abort Message Sent
Oct 26 21:08:58 rafale kernel: (scsi0:A:3:0): Recovery SCB completes
Oct 26 21:08:58 rafale kernel: Unexpected busfree in Message-out phase
Oct 26 21:08:58 rafale kernel: SEQADDR =3D=3D 0x1a8
Oct 26 21:08:58 rafale kernel: Recovery code awake
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x91 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x31 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x19 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0xa2 0xef 0x59 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0xa2 0xef 0x1 0x0 0x0 =
0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x8a 0x2b 0xa1 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x13 0x24 0x81 0x0 0x0=
 0x8 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Attempting to queue an ABOR=
T message
Oct 26 21:08:58 rafale kernel: CDB: 0x2a 0x0 0x0 0x8a 0x2b 0xb1 0x0 0x0=
 0x10 0x0
Oct 26 21:08:58 rafale kernel: scsi0:0:0:0: Command not found
Oct 26 21:08:58 rafale kernel: aic7xxx_abort returns 0x2002
Oct 26 21:08:58 rafale kernel: sr 0:0:3:0: SCSI error: return code =3D =
0x70000

and finish with a panic captured by hands:

SCSI0:0:3:0 Device is active, asserting ATN
Recovery code sleeping
(SCSI0:A:3:0): Abort message sent
(SCSI0:A:3:0): Recovery SCB completes
unexpected busfree in data-out phase
SEQADDR =3D=3D 0x1a8
Recovery code awake
Kernel panic - not syncing : HOST_MSG_LOOP with invalid SCB ff
Badness in smp_call_function at arc/i386/smp.c:541
[<c01102be>] smp_call_function+0x12e/0x140
[<c011c033>] printk+0x13/0x20
[<c0110923>] smp_send_stop+0x13/0x20
[<c011b799>] panic+0x49/0x100
[<e08a4001>] ahc_handle_seqint+0x1561/0x1570 [aic7xxx]
[<e08b6f2b>] ahc_linux_isr+0x21b/0x260 [aic7xxx]
[<c013d493>] handle_IRQ_event+0x33/0x60
=2E....

If it could help, log of the scsi detection at boot:

Oct 26 21:16:47 rafale kernel: SCSI subsystem initialized
Oct 26 21:16:47 rafale kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCS=
I HBA DRIVER, Rev 7.0
Oct 26 21:16:47 rafale kernel:         <Adaptec 2940 Ultra2 SCSI adapte=
r>
Oct 26 21:16:47 rafale kernel:         aic7890/91: Ultra2 Wide Channel =
A, SCSI Id=3D7, 32/253 SCBs
Oct 26 21:16:47 rafale kernel:=20
Oct 26 21:16:47 rafale kernel:   Vendor: IBM       Model: DMVS18V      =
     Rev: 02B0
Oct 26 21:16:47 rafale kernel:   Type:   Direct-Access                 =
     ANSI SCSI revision: 03
Oct 26 21:16:47 rafale kernel: scsi0:A:0:0: Tagged Queuing enabled.  De=
pth 8
Oct 26 21:16:47 rafale kernel:  target0:0:0: Beginning Domain Validatio=
n
Oct 26 21:16:47 rafale kernel:  target0:0:0: wide asynchronous.
Oct 26 21:16:47 rafale kernel:  target0:0:0: FAST-40 WIDE SCSI 80.0 MB/=
s ST (25 ns, offset 31)
Oct 26 21:16:47 rafale kernel:  target0:0:0: Ending Domain Validation
Oct 26 21:16:47 rafale kernel:   Vendor: YAMAHA    Model: CRW6416S     =
     Rev: 1.0d
Oct 26 21:16:47 rafale kernel:   Type:   CD-ROM                        =
     ANSI SCSI revision: 02
Oct 26 21:16:47 rafale kernel:  target0:0:3: Beginning Domain Validatio=
n
Oct 26 21:16:47 rafale kernel:  target0:0:3: Domain Validation skipping=
 write tests
Oct 26 21:16:47 rafale kernel:  target0:0:3: FAST-10 SCSI 10.0 MB/s ST =
(100 ns, offset 15)
Oct 26 21:16:47 rafale kernel:  target0:0:3: Ending Domain Validation
Oct 26 21:16:47 rafale kernel:   Vendor: TOSHIBA   Model: CD-ROM XM-350=
1TA  Rev: 1875
Oct 26 21:16:47 rafale kernel:   Type:   CD-ROM                        =
     ANSI SCSI revision: 02
Oct 26 21:16:47 rafale kernel:  target0:0:4: Beginning Domain Validatio=
n
Oct 26 21:16:47 rafale kernel:  target0:0:4: Domain Validation skipping=
 write tests
Oct 26 21:16:47 rafale kernel:  target0:0:4: Ending Domain Validation
Oct 26 21:16:47 rafale kernel: Attached scsi generic sg0 at scsi0, chan=
nel 0, id 0, lun 0,  type 0
Oct 26 21:16:47 rafale kernel: Attached scsi generic sg1 at scsi0, chan=
nel 0, id 3, lun 0,  type 5
Oct 26 21:16:47 rafale kernel: Attached scsi generic sg2 at scsi0, chan=
nel 0, id 4, lun 0,  type 5
Oct 26 21:16:47 rafale kernel: SCSI device sda: 35843670 512-byte hdwr =
sectors (18352 MB)
Oct 26 21:16:47 rafale kernel: SCSI device sda: drive cache: write back
Oct 26 21:16:47 rafale kernel: SCSI device sda: 35843670 512-byte hdwr =
sectors (18352 MB)
Oct 26 21:16:47 rafale kernel: SCSI device sda: drive cache: write back
Oct 26 21:16:47 rafale kernel:  sda: sda1 sda2 sda3 sda4
Oct 26 21:16:47 rafale kernel: Attached scsi disk sda at scsi0, channel=
 0, id 0, lun 0
Oct 26 21:16:47 rafale kernel: sr0: scsi3-mmc drive: 16x/16x writer cd/=
rw xa/form2 cdda tray
Oct 26 21:16:47 rafale kernel: Uniform CD-ROM driver Revision: 3.20
Oct 26 21:16:47 rafale kernel: Attached scsi CD-ROM sr0 at scsi0, chann=
el 0, id 3, lun 0
Oct 26 21:16:47 rafale kernel: sr1: scsi-1 drive
Oct 26 21:16:47 rafale kernel: Attached scsi CD-ROM sr1 at scsi0, chann=
el 0, id 4, lun 0

Thanks.
Emmanuel.

--=20
Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
