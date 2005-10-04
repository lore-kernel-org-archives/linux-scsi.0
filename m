From: Age Strand <aages@imr.no>
Subject: Re: 2.6.14-rc2-git7 crashed on amd64 (usenet gateway) after 18
	hours
Date: Tue, 04 Oct 2005 12:47:39 +0200
Message-ID: <1128422860.6848.55.camel@itse6863.imr.no>
References: <dhinf5$skf$1@news.cistron.nl>
	 <20050930001301.08eeab9d.akpm@osdl.org> <dhj7qr$id0$1@news.cistron.nl>
	 <Pine.LNX.4.63.0509301457460.5429@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3gm2xse5w+mG1qWryx7g"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.imr.no ([82.134.28.194]:51752 "EHLO ns.imr.no")
	by vger.kernel.org with ESMTP id S1751210AbVJDKrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 06:47:42 -0400
Received: from post2.imr.no ([10.1.2.137])
	by ns.imr.no with esmtp (Exim 4.43)
	id 1EMkKi-00019D-Nu
	for linux-scsi@vger.kernel.org; Tue, 04 Oct 2005 12:47:40 +0200
In-Reply-To: <Pine.LNX.4.63.0509301457460.5429@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Laas <jens.laas@data.slu.se>
Cc: Danny ter Haar <dth@cistron.nl>, linux-scsi@vger.kernel.org


--=-3gm2xse5w+mG1qWryx7g
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-09-30 at 15:04 +0200, Jens Laas wrote:
> (05.09.30 kl.11:33) Danny ter Haar skrev f=F6ljande till linux-scsi@vger.=
kern...:
>=20
> > Andrew Morton  <akpm@osdl.org> wrote:
>=20
> > My colleque found in kern.log the real first announcement:
> >
> > Sep 30 00:26:54 newsgate kernel: scsi1: Transmission error detected
> > Sep 30 00:26:54 newsgate kernel: LQISTAT1[0x8]:(LQICRCI_NLQ) LASTPHASE[=
0x1]:(P_DATAOUT|P_BUSFREE)
> > Sep 30 00:26:54 newsgate kernel: SCSISIGI[0x60]:(P_DATAIN_DT) PERRDIAG[=
0x4]:(CRCERR)
> > Sep 30 00:26:54 newsgate kernel: >>>>>>>>>>>>>>>>>> Dump Card State Beg=
ins <<<<<<<<<<<<<<<<<
>=20
> I dont know if its the same problem as above but we have seen this:
> Sep  1 14:21:00 mail1 kernel: scsi1: Unexpected PKT busfree condition
> Sep  1 14:21:00 mail1 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins=20
> <<<<<<<<<<<<<<<<<
>=20
> busfree is mentioned in both.
>=20
> What is most disappointing is that there is no recovery. Which is no fun=20
> when 2700 mail accounts becomes unreachable.
>=20
> I would expect the card to be reinitialized and communication resumed.
>=20
> Failing that I would like the error be communicated upwards in the kernel=
=20
> so some sort of recovery on fs level can be done (forced unmount perhaps)=
.

Hi Jens,=20

I'll just chime in here and say that I have seen problems with the
aic79xx driver and 39320A-R hardware - albeit on older kernels (2.6.9).
This is the kernel RHEL4 ships with.

Our setup is:

Dell PowerEdge 2850
Dell PowerVault 220S external rack, with 14 disks (one hot-spare).
Kernel 2.6.9-11.ELsmp
Machine is file server for 600+ persons.

We're having problems with an md RAID running off an Adaptec 39320A-R
card. We're getting PKT busfree errors at random intervals which result
in RAID disks going offline. We had to scrap the 79xx raid setup due to
this after it first flipped the hot-spare offline a couple of times, and
then it kicked an additional 2 active disks offline. Not good for a
RAID5.  All this within a week of operation.=20

We're back to running a PERC4/DC hw RAID on the disk array now. Slower
but stable.

>From what I gather there is a bit of a debate going on about the aix7Yxx
driver tree and SCSI core in general, SAS etc etc. Christoph informed me
that the adaptec xx320 support could do with some updating and that the
developers just recently had 320 hw to play with.

Having that in mind, we've set out to experiment with another setup.
We're now using a 39160 controller to host a software raid on the disk
array. It's been running for a couple of days now and we've had one
"Unexpected busfree while idle" message since start of test. Nothing bad
happened though, the aic7xx driver recovered from it. It sent an ABORT
message and it was successful.

When this happened using the aic79xx driver it offlined the disks at
once. By doing that it triggered a bug in the md driver sending it off
on a Mission Impossible trying to update the superblock on all disks a
100 times, then fail, then try 100 times again, et cetera ad nauseam.
Fixed in later versions of md, I hear.=20

So it seems the aic7xxx driver handles busfree error conditions better
than aic79xx.=20

I've seen people suggest checking cable and termination - and some have
indicated that adaptec 29160/39160 hw is extremely picky about these
things.=20
See: http://monkey.org/openbsd/archive/tech/0108/msg00131.html
(yes, I know; old post, openbsd etc etc - might be relevant anyhow)

Anyway, I'm ranting. We've removed the 39320 hw from our server now, but
the log from the ordeal is attached in case anyone wants to look at what
happened. The machine setup at the time was:

Dell PowerEdge 2850
Dell PowerVault 220S external rack, with 14 disks (one hot-spare).
Kernel 2.6.9-11.ELsmp
Adaptec 39320A-R SCSI controller
md0: sw raid sda1 - sdn1 (14 disks, one hot spare).=20


Cheers,
aage


> Cheers,
> Jens
>=20
> > etc...
> >
> > Hope this gives more info on the crash..
> >
> > Danny
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> -----------------------------------------------------------------------
>      'This mail automatically becomes portable when carried.'
> -----------------------------------------------------------------------
>      Jens L=E5=E5s                              Email: jens.laas@data.slu=
.se
>      Department of Computer Services, SLU   Phone: +46 18 67 35 15
>      Vindbrov=E4gen 1
>      P.O. Box 7079
>      S-750 07 Uppsala
>      SWEDEN
> -----------------------------------------------------------------------
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
=C5ge Strand
Overingeni=F8r Unix Drift, Havforskningsinstituttet=20
Tlf: 55238500 / 55236863 (direkte)

--=-3gm2xse5w+mG1qWryx7g
Content-Disposition: attachment; filename=pktbuserr.txt
Content-Type: text/plain; name=pktbuserr.txt; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sep 21 07:07:05 artemis kernel: scsi0: Unexpected PKT busfree condition
Sep 21 07:07:05 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:07:05 artemis kernel: scsi0: Dumping Card State at program address 0xc7 Mode 0x33
Sep 21 07:07:05 artemis kernel: Card was paused
Sep 21 07:07:05 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:07:05 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xb6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:07:05 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:07:05 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:07:05 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:07:05 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:07:05 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:07:05 artemis kernel: 
Sep 21 07:07:05 artemis kernel: SCB Count = 56 CMDS_PENDING = 1 LASTSCB 0x0 CURRSCB 0x19 NEXTSCB 0xff80
Sep 21 07:07:05 artemis kernel: qinstart = 3719 qinfifonext = 3719
Sep 21 07:07:05 artemis kernel: QINFIFO:
Sep 21 07:07:05 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:07:05 artemis kernel: Pending list:
Sep 21 07:07:05 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:07:05 artemis kernel: Total 1
Sep 21 07:07:05 artemis kernel: Kernel Free SCB list: 30 3 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:07:05 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:07:05 artemis kernel: Sequencer Complete list: 
Sep 21 07:07:05 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:07:05 artemis kernel: 
Sep 21 07:07:05 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:07:05 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:07:05 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:07:05 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:07:05 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:07:05 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:07:05 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:07:05 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:07:05 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:07:05 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:07:05 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:07:05 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:07:05 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:07:05 artemis kernel: SIMODE0[0xc] 
Sep 21 07:07:05 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:07:05 artemis kernel: scsi0: REG0 == 0x7, SINDEX = 0x10e, DINDEX = 0x10e
Sep 21 07:07:05 artemis kernel: scsi0: SCBPTR == 0x19, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xff5a
Sep 21 07:07:05 artemis kernel: CDB 1c 1 1 8 0 0
Sep 21 07:07:05 artemis kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:07:05 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:07:05 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:07:05 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:35 artemis kernel: scsi0:0:14:0: Attempting to abort cmd cc585080: 0x2a 0x0 0x11 0x17 0x5d 0xbf 0x0 0x0 0x8 0x0
Sep 21 07:08:35 artemis kernel: scsi0: At time of recovery, card was not paused
Sep 21 07:08:35 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:08:35 artemis kernel: scsi0: Dumping Card State at program address 0x26 Mode 0x22
Sep 21 07:08:35 artemis kernel: Card was paused
Sep 21 07:08:35 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:08:35 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xa6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:08:35 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:08:35 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:08:35 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:08:35 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:08:35 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:08:35 artemis kernel: 
Sep 21 07:08:35 artemis kernel: SCB Count = 56 CMDS_PENDING = 3 LASTSCB 0x0 CURRSCB 0x1e NEXTSCB 0xff80
Sep 21 07:08:35 artemis kernel: qinstart = 3721 qinfifonext = 3721
Sep 21 07:08:35 artemis kernel: QINFIFO:
Sep 21 07:08:35 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:08:35 artemis kernel:        14 ( 0x1e )
Sep 21 07:08:35 artemis kernel:        8 ( 0x3 )
Sep 21 07:08:35 artemis kernel: Pending list:
Sep 21 07:08:35 artemis kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x87] 
Sep 21 07:08:35 artemis kernel:  30 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0xe7] 
Sep 21 07:08:35 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:08:35 artemis kernel: Total 3
Sep 21 07:08:35 artemis kernel: Kernel Free SCB list: 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:08:35 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:08:35 artemis kernel: Sequencer Complete list: 
Sep 21 07:08:35 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:08:35 artemis kernel: 
Sep 21 07:08:35 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:08:35 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:35 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:35 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:35 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:35 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:08:35 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:35 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:35 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:35 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:35 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:08:35 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:08:35 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:08:35 artemis kernel: SIMODE0[0xc] 
Sep 21 07:08:35 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:08:35 artemis kernel: scsi0: REG0 == 0x3, SINDEX = 0x112, DINDEX = 0x112
Sep 21 07:08:35 artemis kernel: scsi0: SCBPTR == 0x1e, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x3
Sep 21 07:08:35 artemis kernel: CDB 2a 0 11 17 5d bf
Sep 21 07:08:35 artemis kernel: STACK: 0x14 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:35 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:08:35 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:08:35 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:35 artemis kernel: scsi0:0:14:0: Cmd aborted from QINFIFO
Sep 21 07:08:45 artemis kernel: scsi0:0:14:0: Attempting to abort cmd cc585080: 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:45 artemis kernel: scsi0: At time of recovery, card was not paused
Sep 21 07:08:45 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:08:45 artemis kernel: scsi0: Dumping Card State at program address 0x2 Mode 0x22
Sep 21 07:08:45 artemis kernel: Card was paused
Sep 21 07:08:45 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:08:45 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xa6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:08:45 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:08:45 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:08:45 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:08:45 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:08:45 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:08:45 artemis kernel: 
Sep 21 07:08:45 artemis kernel: SCB Count = 56 CMDS_PENDING = 3 LASTSCB 0x0 CURRSCB 0x3 NEXTSCB 0xff80
Sep 21 07:08:45 artemis kernel: qinstart = 3722 qinfifonext = 3722
Sep 21 07:08:45 artemis kernel: QINFIFO:
Sep 21 07:08:45 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:08:45 artemis kernel:        8 ( 0x3 )
Sep 21 07:08:45 artemis kernel:        14 ( 0x1e )
Sep 21 07:08:45 artemis kernel: Pending list:
Sep 21 07:08:45 artemis kernel:  30 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0xe7] 
Sep 21 07:08:45 artemis kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x87] 
Sep 21 07:08:45 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:08:45 artemis kernel: Total 3
Sep 21 07:08:45 artemis kernel: Kernel Free SCB list: 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:08:45 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:08:45 artemis kernel: Sequencer Complete list: 
Sep 21 07:08:45 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:08:45 artemis kernel: 
Sep 21 07:08:45 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:08:45 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:45 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:45 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:45 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:45 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:08:45 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:45 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:45 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:45 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:45 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:08:45 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:08:45 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:08:45 artemis kernel: SIMODE0[0xc] 
Sep 21 07:08:45 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:08:45 artemis kernel: scsi0: REG0 == 0x1e, SINDEX = 0x11e, DINDEX = 0x11e
Sep 21 07:08:45 artemis kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0x1e
Sep 21 07:08:45 artemis kernel: CDB 28 0 7 cb 4a 3f
Sep 21 07:08:45 artemis kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:45 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:08:45 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:08:45 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:45 artemis kernel: scsi0:0:14:0: Cmd aborted from QINFIFO
Sep 21 07:08:45 artemis kernel: scsi0:0:8:0: Attempting to abort cmd e722e800: 0x28 0x0 0x7 0xcb 0x4a 0x3f 0x0 0x0 0x8 0x0
Sep 21 07:08:45 artemis kernel: scsi0: At time of recovery, card was not paused
Sep 21 07:08:45 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:08:45 artemis kernel: scsi0: Dumping Card State at program address 0x26 Mode 0x22
Sep 21 07:08:45 artemis kernel: Card was paused
Sep 21 07:08:45 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:08:45 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xa6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:08:45 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:08:45 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:08:45 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:08:45 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:08:45 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:08:45 artemis kernel: 
Sep 21 07:08:45 artemis kernel: SCB Count = 56 CMDS_PENDING = 2 LASTSCB 0x0 CURRSCB 0x3 NEXTSCB 0xff80
Sep 21 07:08:45 artemis kernel: qinstart = 3722 qinfifonext = 3722
Sep 21 07:08:45 artemis kernel: QINFIFO:
Sep 21 07:08:45 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:08:45 artemis kernel:        8 ( 0x3 )
Sep 21 07:08:45 artemis kernel: Pending list:
Sep 21 07:08:45 artemis kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x87] 
Sep 21 07:08:45 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:08:45 artemis kernel: Total 2
Sep 21 07:08:45 artemis kernel: Kernel Free SCB list: 30 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:08:45 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:08:45 artemis kernel: Sequencer Complete list: 
Sep 21 07:08:45 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:08:45 artemis kernel: 
Sep 21 07:08:45 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:08:45 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:45 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:45 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:45 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:45 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:08:45 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:45 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:46 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:46 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:46 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:08:46 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:08:46 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:08:46 artemis kernel: SIMODE0[0xc] 
Sep 21 07:08:46 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:08:46 artemis kernel: scsi0: REG0 == 0x1e, SINDEX = 0x11e, DINDEX = 0x11e
Sep 21 07:08:46 artemis kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff5a
Sep 21 07:08:46 artemis kernel: CDB 28 0 7 cb 4a 3f
Sep 21 07:08:46 artemis kernel: STACK: 0x14 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:46 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:08:46 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:08:46 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:46 artemis kernel: scsi0:0:8:0: Cmd aborted from QINFIFO
Sep 21 07:08:55 artemis kernel: scsi0:0:8:0: Attempting to abort cmd e722e800: 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:55 artemis kernel: scsi0: At time of recovery, card was not paused
Sep 21 07:08:55 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:08:55 artemis kernel: scsi0: Dumping Card State at program address 0xc Mode 0x33
Sep 21 07:08:55 artemis kernel: Card was paused
Sep 21 07:08:55 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:08:55 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xa6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:08:55 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:08:55 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:08:55 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:08:55 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:08:55 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:08:55 artemis kernel: 
Sep 21 07:08:55 artemis kernel: SCB Count = 56 CMDS_PENDING = 2 LASTSCB 0x0 CURRSCB 0x3 NEXTSCB 0xff80
Sep 21 07:08:55 artemis kernel: qinstart = 3723 qinfifonext = 3723
Sep 21 07:08:55 artemis kernel: QINFIFO:
Sep 21 07:08:55 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:08:55 artemis kernel:        8 ( 0x3 )
Sep 21 07:08:55 artemis kernel: Pending list:
Sep 21 07:08:55 artemis kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x87] 
Sep 21 07:08:55 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:08:55 artemis kernel: Total 2
Sep 21 07:08:55 artemis kernel: Kernel Free SCB list: 30 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:08:55 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:08:55 artemis kernel: Sequencer Complete list: 
Sep 21 07:08:55 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:08:55 artemis kernel: 
Sep 21 07:08:55 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:08:55 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:55 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:55 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:55 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:55 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:08:55 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:55 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:55 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:55 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:55 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:08:55 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:08:55 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:08:55 artemis kernel: SIMODE0[0xc] 
Sep 21 07:08:55 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:08:55 artemis kernel: scsi0: REG0 == 0x7, SINDEX = 0x112, DINDEX = 0x112
Sep 21 07:08:55 artemis kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff5a
Sep 21 07:08:55 artemis kernel: CDB 0 0 0 0 0 0
Sep 21 07:08:55 artemis kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:55 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:08:55 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:08:55 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:55 artemis kernel: scsi0:0:8:0: Cmd aborted from QINFIFO
Sep 21 07:08:55 artemis kernel: scsi0:0:6:0: Attempting to abort cmd d53ce080: 0x1c 0x1 0x1 0x8 0x0 0x0
Sep 21 07:08:55 artemis kernel: scsi0: At time of recovery, card was not paused
Sep 21 07:08:55 artemis kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Sep 21 07:08:55 artemis kernel: scsi0: Dumping Card State at program address 0xa Mode 0x33
Sep 21 07:08:55 artemis kernel: Card was paused
Sep 21 07:08:55 artemis kernel: HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
Sep 21 07:08:55 artemis kernel: DFFSTAT[0x33] SCSISIGI[0xa6] SCSIPHASE[0x0] SCSIBUS[0xc0] 
Sep 21 07:08:55 artemis kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] 
Sep 21 07:08:55 artemis kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2] 
Sep 21 07:08:55 artemis kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] 
Sep 21 07:08:55 artemis kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
Sep 21 07:08:55 artemis kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
Sep 21 07:08:55 artemis kernel: 
Sep 21 07:08:55 artemis kernel: SCB Count = 56 CMDS_PENDING = 1 LASTSCB 0x0 CURRSCB 0x3 NEXTSCB 0xff80
Sep 21 07:08:55 artemis kernel: qinstart = 3723 qinfifonext = 3723
Sep 21 07:08:55 artemis kernel: QINFIFO:
Sep 21 07:08:55 artemis kernel: WAITING_TID_QUEUES:
Sep 21 07:08:55 artemis kernel: Pending list:
Sep 21 07:08:55 artemis kernel:  25 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x67] 
Sep 21 07:08:55 artemis kernel: Total 1
Sep 21 07:08:55 artemis kernel: Kernel Free SCB list: 3 30 5 2 0 18 13 50 37 26 32 54 20 42 24 43 49 8 33 41 15 1 44 10 27 35 4 46 34 12 23 48 51 16 11 29 39 47 55 38 7 14 28 21 45 22 40 31 9 36 17 19 6 53 52 
Sep 21 07:08:55 artemis kernel: Sequencer Complete DMA-inprog list: 
Sep 21 07:08:55 artemis kernel: Sequencer Complete list: 
Sep 21 07:08:55 artemis kernel: Sequencer DMA-Up and Complete list: 
Sep 21 07:08:55 artemis kernel: 
Sep 21 07:08:55 artemis kernel: scsi0: FIFO0 Free, LONGJMP == 0x823a, SCB 0x19
Sep 21 07:08:55 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:55 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:55 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:55 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:55 artemis kernel: scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x19
Sep 21 07:08:56 artemis kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
Sep 21 07:08:56 artemis kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
Sep 21 07:08:56 artemis kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
Sep 21 07:08:56 artemis kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
Sep 21 07:08:56 artemis kernel: LQIN: 0x8 0x0 0x0 0x19 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Sep 21 07:08:56 artemis kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Sep 21 07:08:56 artemis kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Sep 21 07:08:56 artemis kernel: SIMODE0[0xc] 
Sep 21 07:08:56 artemis kernel: CCSCBCTL[0x4] 
Sep 21 07:08:56 artemis kernel: scsi0: REG0 == 0x7, SINDEX = 0x112, DINDEX = 0x112
Sep 21 07:08:56 artemis kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff5a
Sep 21 07:08:56 artemis kernel: CDB 0 0 0 0 0 0
Sep 21 07:08:56 artemis kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Sep 21 07:08:56 artemis kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Sep 21 07:08:56 artemis kernel: DevQ(0:0:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:1:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:2:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:3:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:4:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:5:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:6:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:8:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:9:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:10:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:11:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:12:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:13:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:14:0): 0 waiting
Sep 21 07:08:56 artemis kernel: DevQ(0:15:0): 0 waiting
Sep 21 07:08:56 artemis kernel: (scsi0:A:6:0): Device is disconnected, re-queuing SCB
Sep 21 07:08:56 artemis kernel: Recovery code sleeping
Sep 21 07:09:00 artemis kernel: Recovery code awake
Sep 21 07:09:00 artemis kernel: Timer Expired
Sep 21 07:09:00 artemis kernel: Recovery code sleeping
Sep 21 07:09:05 artemis kernel: Recovery code awake
Sep 21 07:09:05 artemis kernel: Timer Expired
Sep 21 07:09:05 artemis kernel: scsi0: Device reset returning 0x2003
Sep 21 07:09:05 artemis kernel: Recovery code sleeping
Sep 21 07:09:10 artemis kernel: Recovery code awake
Sep 21 07:09:10 artemis kernel: Timer Expired
Sep 21 07:09:10 artemis kernel: scsi0: Device reset returning 0x2003
Sep 21 07:09:10 artemis kernel: Recovery code sleeping
Sep 21 07:09:15 artemis kernel: Recovery code awake
Sep 21 07:09:15 artemis kernel: Timer Expired
Sep 21 07:09:15 artemis kernel: scsi0: Device reset returning 0x2003
Sep 21 07:09:15 artemis kernel: Recovery SCB completes
Sep 21 07:09:15 artemis last message repeated 3 times
Sep 21 07:09:25 artemis kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 14 lun 0
Sep 21 07:09:25 artemis kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 8 lun 0
Sep 21 07:09:25 artemis kernel: scsi0 (14:0): rejecting I/O to offline device
Sep 21 07:09:25 artemis kernel: scsi0 (8:0): rejecting I/O to offline device
Sep 21 07:09:25 artemis kernel: md: write_disk_sb failed for device sdm1
Sep 21 07:09:25 artemis kernel: raid5: Disk failure on sdg1, disabling device. Operation continuing on 12 devices
Sep 21 07:09:25 artemis kernel: scsi0 (14:0): rejecting I/O to offline device
Sep 21 07:09:25 artemis kernel: raid5: Disk failure on sdm1, disabling device. Operation continuing on 11 devices
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): read_block_bitmap: Cannot read block bitmap - block_group = 5985, block_bitmap = 196145216
Sep 21 07:09:26 artemis kernel: Aborting journal on device md0.
Sep 21 07:09:26 artemis kernel: ext3_abort called.
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Sep 21 07:09:26 artemis kernel: Remounting filesystem read-only
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0) in start_transaction: Journal has aborted
Sep 21 07:09:26 artemis kernel: md: errors occurred during superblock update, repeating
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 409993217
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082917
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: RAID5 conf printout:
Sep 21 07:09:26 artemis kernel:  --- rd:13 wd:11 fd:2
Sep 21 07:09:26 artemis kernel:  disk 0, o:1, dev:sda1
Sep 21 07:09:26 artemis kernel:  disk 1, o:1, dev:sdb1
Sep 21 07:09:26 artemis kernel:  disk 2, o:1, dev:sdc1
Sep 21 07:09:26 artemis kernel:  disk 3, o:1, dev:sdd1
Sep 21 07:09:26 artemis kernel:  disk 4, o:1, dev:sde1
Sep 21 07:09:26 artemis kernel:  disk 5, o:1, dev:sdf1
Sep 21 07:09:26 artemis kernel:  disk 6, o:0, dev:sdg1
Sep 21 07:09:26 artemis kernel:  disk 7, o:1, dev:sdh1
Sep 21 07:09:26 artemis kernel:  disk 8, o:1, dev:sdi1
Sep 21 07:09:26 artemis kernel:  disk 9, o:1, dev:sdj1
Sep 21 07:09:26 artemis kernel:  disk 10, o:1, dev:sdk1
Sep 21 07:09:26 artemis kernel:  disk 11, o:1, dev:sdl1
Sep 21 07:09:26 artemis kernel:  disk 12, o:0, dev:sdm1
Sep 21 07:09:26 artemis kernel: RAID5 conf printout:
Sep 21 07:09:26 artemis kernel:  --- rd:13 wd:11 fd:2
Sep 21 07:09:26 artemis kernel:  disk 0, o:1, dev:sda1
Sep 21 07:09:26 artemis kernel:  disk 1, o:1, dev:sdb1
Sep 21 07:09:26 artemis kernel:  disk 2, o:1, dev:sdc1
Sep 21 07:09:26 artemis kernel:  disk 3, o:1, dev:sdd1
Sep 21 07:09:26 artemis kernel:  disk 4, o:1, dev:sde1
Sep 21 07:09:26 artemis kernel:  disk 5, o:1, dev:sdf1
Sep 21 07:09:26 artemis kernel:  disk 6, o:0, dev:sdg1
Sep 21 07:09:26 artemis kernel:  disk 7, o:1, dev:sdh1
Sep 21 07:09:26 artemis kernel:  disk 8, o:1, dev:sdi1
Sep 21 07:09:26 artemis kernel:  disk 9, o:1, dev:sdj1
Sep 21 07:09:26 artemis kernel:  disk 10, o:1, dev:sdk1
Sep 21 07:09:26 artemis kernel:  disk 11, o:1, dev:sdl1
Sep 21 07:09:26 artemis kernel: RAID5 conf printout:
Sep 21 07:09:26 artemis kernel:  --- rd:13 wd:11 fd:2
Sep 21 07:09:26 artemis kernel:  disk 0, o:1, dev:sda1
Sep 21 07:09:26 artemis kernel:  disk 1, o:1, dev:sdb1
Sep 21 07:09:26 artemis kernel:  disk 2, o:1, dev:sdc1
Sep 21 07:09:26 artemis kernel:  disk 3, o:1, dev:sdd1
Sep 21 07:09:26 artemis kernel:  disk 4, o:1, dev:sde1
Sep 21 07:09:26 artemis kernel:  disk 5, o:1, dev:sdf1
Sep 21 07:09:26 artemis kernel:  disk 6, o:0, dev:sdg1
Sep 21 07:09:26 artemis kernel:  disk 7, o:1, dev:sdh1
Sep 21 07:09:26 artemis kernel:  disk 8, o:1, dev:sdi1
Sep 21 07:09:26 artemis kernel:  disk 9, o:1, dev:sdj1
Sep 21 07:09:26 artemis kernel:  disk 10, o:1, dev:sdk1
Sep 21 07:09:26 artemis kernel:  disk 11, o:1, dev:sdl1
Sep 21 07:09:26 artemis kernel: RAID5 conf printout:
Sep 21 07:09:26 artemis kernel:  --- rd:13 wd:11 fd:2
Sep 21 07:09:26 artemis kernel:  disk 0, o:1, dev:sda1
Sep 21 07:09:26 artemis kernel:  disk 1, o:1, dev:sdb1
Sep 21 07:09:26 artemis kernel:  disk 2, o:1, dev:sdc1
Sep 21 07:09:26 artemis kernel:  disk 3, o:1, dev:sdd1
Sep 21 07:09:26 artemis kernel:  disk 4, o:1, dev:sde1
Sep 21 07:09:26 artemis kernel:  disk 5, o:1, dev:sdf1
Sep 21 07:09:26 artemis kernel:  disk 7, o:1, dev:sdh1
Sep 21 07:09:26 artemis kernel:  disk 8, o:1, dev:sdi1
Sep 21 07:09:26 artemis kernel:  disk 9, o:1, dev:sdj1
Sep 21 07:09:26 artemis kernel:  disk 10, o:1, dev:sdk1
Sep 21 07:09:26 artemis kernel:  disk 11, o:1, dev:sdl1
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 1648
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082918
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 409997396
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082919
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082920
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082921
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082922
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: Buffer I/O error on device md0, logical block 196082923
Sep 21 07:09:26 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0) in ext3_prepare_write: IO failure
Sep 21 07:09:26 artemis kernel: __journal_remove_journal_head: freeing b_committed_data
Sep 21 07:09:26 artemis kernel: __journal_remove_journal_head: freeing b_frozen_data
Sep 21 07:09:26 artemis kernel: __journal_remove_journal_head: freeing b_committed_data
Sep 21 07:09:26 artemis kernel: __journal_remove_journal_head: freeing b_frozen_data
Sep 21 07:09:26 artemis kernel: journal commit I/O error
Sep 21 07:09:26 artemis last message repeated 4 times
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #205193231 offset 0
Sep 21 07:09:26 artemis kernel: 
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #205193231 offset 0
Sep 21 07:09:26 artemis kernel: 
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #205193231 offset 0
Sep 21 07:09:26 artemis kernel: 
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #205193231 offset 0
Sep 21 07:09:26 artemis kernel: 
Sep 21 07:09:26 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=101744803, block=203489285
Sep 21 07:09:32 artemis kernel: printk: 29321 messages suppressed.
Sep 21 07:09:32 artemis kernel: Buffer I/O error on device md0, logical block 0
Sep 21 07:09:32 artemis kernel: lost page write due to I/O error on md0
Sep 21 07:09:55 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #114671669 contains a hole at offset 0
Sep 21 07:09:55 artemis last message repeated 9 times
Sep 21 07:10:01 artemis crond(pam_unix)[2692]: session opened for user root by (uid=0)
Sep 21 07:10:01 artemis tac_plus[2593]: Received signal 15, shutting down
Sep 21 07:10:01 artemis tacacs: tac_plus shutdown succeeded
Sep 21 07:10:01 artemis tac_plus[2712]: Reading config
Sep 21 07:10:01 artemis tac_plus[2712]: Version F4.0.3.alpha Initialized 1
Sep 21 07:10:01 artemis crond(pam_unix)[2692]: session closed for user root
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #145948742 offset 0
Sep 21 07:14:14 artemis kernel: 
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #145948742 contains a hole at offset 0
Sep 21 07:14:14 artemis last message repeated 2 times
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #27312185 offset 0
Sep 21 07:14:14 artemis kernel: 
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:14 artemis last message repeated 2 times
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #93552693 offset 0
Sep 21 07:14:14 artemis kernel: 
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #93552693 contains a hole at offset 0
Sep 21 07:14:14 artemis last message repeated 2 times
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #40730714 offset 0
Sep 21 07:14:14 artemis kernel: 
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #40730714 contains a hole at offset 0
Sep 21 07:14:14 artemis last message repeated 2 times
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #99172467 offset 0
Sep 21 07:14:14 artemis kernel: 
Sep 21 07:14:14 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #99172467 contains a hole at offset 0
Sep 21 07:14:14 artemis last message repeated 2 times
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #145948742 contains a hole at offset 0
Sep 21 07:14:15 artemis last message repeated 2 times
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #93552693 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #40730714 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #93552693 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #93552693 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #40730714 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #40730714 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #99172467 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #99172467 contains a hole at offset 0
Sep 21 07:14:15 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #99172467 contains a hole at offset 0
Sep 21 07:14:17 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:17 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:17 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #27312185 offset 0
Sep 21 07:14:17 artemis kernel: 
Sep 21 07:14:17 artemis kernel: EXT3-fs error (device md0): ext3_readdir: directory #27312185 contains a hole at offset 0
Sep 21 07:14:32 artemis last message repeated 5 times
Sep 21 07:14:34 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=19955841, block=39911428
Sep 21 07:14:34 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=95354932, block=190709761
Sep 21 07:14:34 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=187089029, block=374177796
Sep 21 07:14:34 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=116441237, block=232882180
Sep 21 07:14:38 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=166854730, block=333709314
Sep 21 07:14:38 artemis kernel: EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=192053347, block=384106499
Sep 21 07:14:38 artemis kernel: EXT3-fs error (device md0): ext3_find_entry: reading directory #157302868 offset 0
... and the list goes on forever

--=-3gm2xse5w+mG1qWryx7g--

