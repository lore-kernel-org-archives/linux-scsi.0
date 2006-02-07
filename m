From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: [PATCH 1/1] aic7xxx: port of the "qfrozen to atomic_t" patch
Date: Tue,  7 Feb 2006 14:13:00 +0100
Message-ID: <IUBJDO$FC1D2F3E6B7DE2F8332FDC61F0A7FB62@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1139317980.2A.622699.42.14128.52.42.007.16930"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:45284 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S965071AbWBGNOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 08:14:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1139317980.2A.622699.42.14128.52.42.007.16930
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

This patch is a port of Hannes Reinecke "qfrozen to atomic_t"
patch to
aic7xxx. It's a naive "copy and paste" patch but there is
differences
in  ahc_linux_run_command.
ahc_linux_run_command seems to do nasty tests with the qfrozen
counter
and the tagged or untagged command case, but it is out of my
competence.
This patch is diffed on top of the latest Christoph Hellwig
"semaphore
to completion conversion".

Compiled, will be tested this evening.
I just saw your conversation with Christoph. If you want I try
another version, tell me.

Emmanuel.

---=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.n=
et ; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/m=
n)=0A=0A

--_=__=_XaM3_.1139317980.2A.622699.42.14128.52.42.007.16930
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?qfrozen.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?qfrozen.patch?="

Subject: [PATCH 1/1] aic7xxx: port of the "qfrozen to atomic_t" patch=0A=0A=
This patch is a port of Hannes Reinecke "qfrozen to atomic_t" patch to=0A=
aic7xxx. It's a naive "copy and paste" patch but there is differences=0Ai=
n  ahc_linux_run_command.=0Aahc_linux_run_command seems to do nasty tests=
 with the qfrozen counter=0Aand the tagged or untagged command case, but =
it is out of my competence.=0AThis patch is diffed on top of the latest C=
hristoph Hellwig "semaphore=0Ato completion conversion".=0A=0ASigned-off-=
by: Emmanuel Fust=C3=A9 <emmanuel.fuste@laposte.net>=0A=0A---=0A=0A aic7x=
xx_osm.c |   57 +++++++++++++++++++--------------------------------------=
=0A aic7xxx_osm.h |    2 +-=0A 2 files changed, 20 insertions(+), 39 dele=
tions(-)=0A=0A=0A--- linux-source-2.6.15-orig/drivers/scsi/aic7xxx/aic7xx=
x_osm.c	2006-02-07 10:48:30.000000000 +0100=0A+++ linux-source-2.6.15/dri=
vers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-07 13:50:40.000000000 +0100=0A@@ =
-476,17 +476,14 @@ ahc_linux_queue(struct scsi_cmnd * cmd, =0A 	struct	 a=
hc_softc *ahc;=0A 	struct	 ahc_linux_device *dev =3D scsi_transport_devic=
e_data(cmd->device);=0A 	int rtn =3D SCSI_MLQUEUE_HOST_BUSY;=0A-	unsigned=
 long flags;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->device->host->hos=
tdata;=0A =0A-	ahc_lock(ahc, &flags);=0A-	if (ahc->platform_data->qfrozen=
 =3D=3D 0) {=0A+	if (!atomic_read(&ahc->platform_data->qfrozen)) {=0A 		c=
md->scsi_done =3D scsi_done;=0A 		cmd->result =3D CAM_REQ_INPROG << 16;=0A=
 		rtn =3D ahc_linux_run_command(ahc, dev, cmd);=0A 	}=0A-	ahc_unlock(ahc=
, &flags);=0A =0A 	return rtn;=0A }=0A@@ -747,14 +744,11 @@ ahc_linux_bus=
_reset(struct scsi_cmnd *cm=0A {=0A 	struct ahc_softc *ahc;=0A 	int    fo=
und;=0A-	unsigned long flags;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->=
device->host->hostdata;=0A =0A-	ahc_lock(ahc, &flags);=0A 	found =3D ahc_=
reset_channel(ahc, scmd_channel(cmd) + 'A',=0A 				  /*initiate reset*/TR=
UE);=0A-	ahc_unlock(ahc, &flags);=0A =0A 	if (bootverbose)=0A 		printf("%=
s: SCSI bus reset delivered. "=0A@@ -1184,6 +1178,7 @@ ahc_platform_alloc=
(struct ahc_softc *ahc=0A 	memset(ahc->platform_data, 0, sizeof(struct ah=
c_platform_data));=0A 	ahc->platform_data->irq =3D AHC_LINUX_NOIRQ;=0A 	a=
hc_lockinit(ahc);=0A+	atomic_set(&ahc->platform_data->qfrozen, 0);=0A 	ah=
c->seltime =3D (aic7xxx_seltime & 0x3) << 4;=0A 	ahc->seltime_b =3D (aic7=
xxx_seltime & 0x3) << 4;=0A 	if (aic7xxx_pci_parity =3D=3D 0)=0A@@ -1406,=
13 +1401,18 @@ ahc_linux_run_command(struct ahc_softc *=0A 	struct	 ahc_t=
mode_tstate *tstate;=0A 	uint16_t mask;=0A 	struct scb_tailq *untagged_q =
=3D NULL;=0A+	unsigned long flags;=0A+=0A+	ahc_lock(ahc, &flags);=0A =0A =
	/*=0A 	 * Schedule us to run later.  The only reason we are not=0A 	 * r=
unning is because the whole controller Q is frozen.=0A 	 */=0A-	if (ahc->=
platform_data->qfrozen !=3D 0)=0A+	if (atomic_read(&ahc->platform_data->q=
frozen)) {=0A+		ahc_unlock(ahc, &flags);=0A 		return SCSI_MLQUEUE_HOST_BU=
SY;=0A+	}=0A =0A 	/*=0A 	 * We only allow one untagged transaction=0A@@ -=
1426,18 +1426,22 @@ ahc_linux_run_command(struct ahc_softc *=0A =0A 		tar=
get_offset =3D cmd->device->id + cmd->device->channel * 8;=0A 		untagged_=
q =3D &(ahc->untagged_queues[target_offset]);=0A-		if (!TAILQ_EMPTY(untag=
ged_q))=0A+		if (!TAILQ_EMPTY(untagged_q)) {=0A 			/* if we're already ex=
ecuting an untagged command=0A 			 * we're busy to another */=0A+			ahc_u=
nlock(ahc, &flags);=0A 			return SCSI_MLQUEUE_DEVICE_BUSY;=0A+		}=0A 	}=0A=
 =0A 	/*=0A 	 * Get an scb to use.=0A 	 */=0A 	scb =3D ahc_get_scb(ahc);=0A=
-	if (!scb)=0A+	if (!scb) {=0A+		ahc_unlock(ahc, &flags);=0A 		return SCS=
I_MLQUEUE_HOST_BUSY;=0A+	}=0A =0A 	scb->io_ctx =3D cmd;=0A 	scb->platform=
_data->dev =3D dev;=0A@@ -1588,6 +1592,9 @@ ahc_linux_run_command(struct =
ahc_softc *=0A 		scb->flags |=3D SCB_UNTAGGEDQ;=0A 	}=0A 	ahc_queue_scb(a=
hc, scb);=0A+=0A+	ahc_unlock(ahc, &flags);=0A+=0A 	return 0;=0A }=0A =0A@=
@ -2025,41 +2032,15 @@ ahc_linux_queue_cmd_complete(struct ahc_=0A static=
 void=0A ahc_linux_freeze_simq(struct ahc_softc *ahc)=0A {=0A-	unsigned l=
ong s;=0A =0A-	ahc_lock(ahc, &s);=0A-	ahc->platform_data->qfrozen++;=0A-	=
if (ahc->platform_data->qfrozen =3D=3D 1) {=0A+	if (!atomic_inc_and_test(=
&ahc->platform_data->qfrozen))=0A 		scsi_block_requests(ahc->platform_dat=
a->host);=0A-=0A-		/* XXX What about Twin channels? */=0A-		ahc_platform_=
abort_scbs(ahc, CAM_TARGET_WILDCARD, ALL_CHANNELS,=0A-					CAM_LUN_WILDCA=
RD, SCB_LIST_NULL,=0A-					ROLE_INITIATOR, CAM_REQUEUE_REQ);=0A-	}=0A-	ah=
c_unlock(ahc, &s);=0A }=0A =0A static void=0A ahc_linux_release_simq(stru=
ct ahc_softc *ahc)=0A {=0A-	u_long s;=0A-	int    unblock_reqs;=0A-=0A-	un=
block_reqs =3D 0;=0A-	ahc_lock(ahc, &s);=0A-	if (ahc->platform_data->qfro=
zen > 0)=0A-		ahc->platform_data->qfrozen--;=0A-	if (ahc->platform_data->=
qfrozen =3D=3D 0)=0A-		unblock_reqs =3D 1;=0A-	ahc_unlock(ahc, &s);=0A-	/=
*=0A-	 * There is still a race here.  The mid-layer=0A-	 * should keep it=
s own freeze count and use=0A-	 * a bottom half handler to run the queues=
=0A-	 * so we can unblock with our own lock held.=0A-	 */=0A-	if (unblock=
_reqs)=0A+	if (atomic_dec_and_test(&ahc->platform_data->qfrozen))=0A 		sc=
si_unblock_requests(ahc->platform_data->host);=0A }=0A =0A--- linux-sourc=
e-2.6.15-orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-02-07 10:48:38.0000=
00000 +0100=0A+++ linux-source-2.6.15/drivers/scsi/aic7xxx/aic7xxx_osm.h	=
2006-02-07 11:04:14.000000000 +0100=0A@@ -368,7 +368,7 @@ struct ahc_plat=
form_data {=0A 	struct scsi_target *starget[AHC_NUM_TARGETS]; =0A =0A 	sp=
inlock_t		 spin_lock;=0A-	u_int			 qfrozen;=0A+	atomic_t		 qfrozen;=0A 	s=
truct completion	*eh_done;=0A 	struct Scsi_Host        *host;		/* pointer=
 to scsi host */=0A #define AHC_LINUX_NOIRQ	((uint32_t)~0)=0A

--_=__=_XaM3_.1139317980.2A.622699.42.14128.52.42.007.16930--

