From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: [RFC][PATCH 1/1] aic7xxx: Remove the platform_data->qfrozen logic
Date: Wed,  8 Feb 2006 14:06:49 +0100
Message-ID: <IUDDRD$CB72DBE5A205DF334A7B5D45477F1522@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1139404009.2A.583877.42.4423.52.42.007.9067"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:51625 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1030376AbWBHNHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 08:07:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: hch <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1139404009.2A.583877.42.4423.52.42.007.9067
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

hello,

Since we no longuer do internal queuing, we push the lock
inside ahc_linux_run_command and completly remove the bursted
internal queue freezing machinery.
Based on Hannes Reinecke patch for aic79xxx and Christoph
Hellwig comments.

Signed-off-by: Emmanuel Fuste <emmanuel.fuste@laposte.net>

--- 

 aic7xxx_osm.c |   82
++++++++++++----------------------------------------------
 aic7xxx_osm.h |    1
 2 files changed, 17 insertions(+), 66 deletions(-)

---

=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1139404009.2A.583877.42.4423.52.42.007.9067
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?qfrozen.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?qfrozen.patch?="

Subject: [RFC][PATCH 1/1] aic7xxx: Remove the platform_data->qfrozen logi=
c=0A=0ASince we no longuer do internal queuing, we push the lock inside a=
hc_linux_run_command=0Aand completly remove the bursted internal queue fr=
eezing machinery.=0ABased on Hannes Reinecke patch for aic79xxx and Chris=
toph Hellwig comments.=0A=0ASigned-off-by: Emmanuel Fuste <emmanuel.fuste=
@laposte.net>=0A=0A---=0A=0A aic7xxx_osm.c |   82 ++++++++++++-----------=
-----------------------------------=0A aic7xxx_osm.h |    1 =0A 2 files c=
hanged, 17 insertions(+), 66 deletions(-)=0A=0A--- linux-source-2.6.15-or=
ig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-07 10:48:30.000000000 +0100=
=0A+++ linux-source-2.6.15/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-02-08 =
13:44:32.000000000 +0100=0A@@ -373,8 +373,6 @@ static void ahc_linux_hand=
le_scsi_status=0A 					 struct scb *);=0A static void ahc_linux_queue_cmd=
_complete(struct ahc_softc *ahc,=0A 					 struct scsi_cmnd *cmd);=0A-stat=
ic void ahc_linux_freeze_simq(struct ahc_softc *ahc);=0A-static void ahc_=
linux_release_simq(struct ahc_softc *ahc);=0A static int  ahc_linux_queue=
_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);=0A static void ahc_l=
inux_initialize_scsi_bus(struct ahc_softc *ahc);=0A static u_int ahc_linu=
x_user_tagdepth(struct ahc_softc *ahc,=0A@@ -475,18 +473,13 @@ ahc_linux_=
queue(struct scsi_cmnd * cmd, =0A {=0A 	struct	 ahc_softc *ahc;=0A 	struc=
t	 ahc_linux_device *dev =3D scsi_transport_device_data(cmd->device);=0A-=
	int rtn =3D SCSI_MLQUEUE_HOST_BUSY;=0A-	unsigned long flags;=0A+	int	 rt=
n;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->device->host->hostdata;=0A =
=0A-	ahc_lock(ahc, &flags);=0A-	if (ahc->platform_data->qfrozen =3D=3D 0)=
 {=0A-		cmd->scsi_done =3D scsi_done;=0A-		cmd->result =3D CAM_REQ_INPROG=
 << 16;=0A-		rtn =3D ahc_linux_run_command(ahc, dev, cmd);=0A-	}=0A-	ahc_=
unlock(ahc, &flags);=0A+	cmd->scsi_done =3D scsi_done;=0A+	cmd->result =3D=
 CAM_REQ_INPROG << 16;=0A+	rtn =3D ahc_linux_run_command(ahc, dev, cmd);=0A=
 =0A 	return rtn;=0A }=0A@@ -747,14 +740,11 @@ ahc_linux_bus_reset(struct=
 scsi_cmnd *cm=0A {=0A 	struct ahc_softc *ahc;=0A 	int    found;=0A-	unsi=
gned long flags;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->device->host-=
>hostdata;=0A =0A-	ahc_lock(ahc, &flags);=0A 	found =3D ahc_reset_channel=
(ahc, scmd_channel(cmd) + 'A',=0A 				  /*initiate reset*/TRUE);=0A-	ahc_=
unlock(ahc, &flags);=0A =0A 	if (bootverbose)=0A 		printf("%s: SCSI bus r=
eset delivered. "=0A@@ -1167,9 +1157,9 @@ ahc_linux_initialize_scsi_bus(s=
truct ahc=0A 	ahc_unlock(ahc, &s);=0A 	/* Give the bus some time to recov=
er */=0A 	if ((ahc->flags & (AHC_RESET_BUS_A|AHC_RESET_BUS_B)) !=3D 0) {=0A=
-		ahc_linux_freeze_simq(ahc);=0A+		scsi_block_requests(ahc->platform_dat=
a->host);=0A 		msleep(AIC7XXX_RESET_DELAY);=0A-		ahc_linux_release_simq(a=
hc);=0A+		scsi_unblock_requests(ahc->platform_data->host);=0A 	}=0A }=0A =
=0A@@ -1406,13 +1396,9 @@ ahc_linux_run_command(struct ahc_softc *=0A 	st=
ruct	 ahc_tmode_tstate *tstate;=0A 	uint16_t mask;=0A 	struct scb_tailq *=
untagged_q =3D NULL;=0A+	unsigned long flags;=0A =0A-	/*=0A-	 * Schedule =
us to run later.  The only reason we are not=0A-	 * running is because th=
e whole controller Q is frozen.=0A-	 */=0A-	if (ahc->platform_data->qfroz=
en !=3D 0)=0A-		return SCSI_MLQUEUE_HOST_BUSY;=0A+	ahc_lock(ahc, &flags);=
=0A =0A 	/*=0A 	 * We only allow one untagged transaction=0A@@ -1426,18 +=
1412,22 @@ ahc_linux_run_command(struct ahc_softc *=0A =0A 		target_offse=
t =3D cmd->device->id + cmd->device->channel * 8;=0A 		untagged_q =3D &(a=
hc->untagged_queues[target_offset]);=0A-		if (!TAILQ_EMPTY(untagged_q))=0A=
+		if (!TAILQ_EMPTY(untagged_q)) {=0A 			/* if we're already executing an=
 untagged command=0A 			 * we're busy to another */=0A+			ahc_unlock(ahc,=
 &flags);=0A 			return SCSI_MLQUEUE_DEVICE_BUSY;=0A+		}=0A 	}=0A =0A 	/*=0A=
 	 * Get an scb to use.=0A 	 */=0A 	scb =3D ahc_get_scb(ahc);=0A-	if (!sc=
b)=0A+	if (!scb) {=0A+		ahc_unlock(ahc, &flags);=0A 		return SCSI_MLQUEUE=
_HOST_BUSY;=0A+	}=0A =0A 	scb->io_ctx =3D cmd;=0A 	scb->platform_data->de=
v =3D dev;=0A@@ -1588,6 +1578,9 @@ ahc_linux_run_command(struct ahc_softc=
 *=0A 		scb->flags |=3D SCB_UNTAGGEDQ;=0A 	}=0A 	ahc_queue_scb(ahc, scb);=
=0A+=0A+	ahc_unlock(ahc, &flags);=0A+=0A 	return 0;=0A }=0A =0A@@ -2022,4=
7 +2015,6 @@ ahc_linux_queue_cmd_complete(struct ahc_=0A 	cmd->scsi_done(=
cmd);=0A }=0A =0A-static void=0A-ahc_linux_freeze_simq(struct ahc_softc *=
ahc)=0A-{=0A-	unsigned long s;=0A-=0A-	ahc_lock(ahc, &s);=0A-	ahc->platfo=
rm_data->qfrozen++;=0A-	if (ahc->platform_data->qfrozen =3D=3D 1) {=0A-		=
scsi_block_requests(ahc->platform_data->host);=0A-=0A-		/* XXX What about=
 Twin channels? */=0A-		ahc_platform_abort_scbs(ahc, CAM_TARGET_WILDCARD,=
 ALL_CHANNELS,=0A-					CAM_LUN_WILDCARD, SCB_LIST_NULL,=0A-					ROLE_INIT=
IATOR, CAM_REQUEUE_REQ);=0A-	}=0A-	ahc_unlock(ahc, &s);=0A-}=0A-=0A-stati=
c void=0A-ahc_linux_release_simq(struct ahc_softc *ahc)=0A-{=0A-	u_long s=
;=0A-	int    unblock_reqs;=0A-=0A-	unblock_reqs =3D 0;=0A-	ahc_lock(ahc, =
&s);=0A-	if (ahc->platform_data->qfrozen > 0)=0A-		ahc->platform_data->qf=
rozen--;=0A-	if (ahc->platform_data->qfrozen =3D=3D 0)=0A-		unblock_reqs =
=3D 1;=0A-	ahc_unlock(ahc, &s);=0A-	/*=0A-	 * There is still a race here.=
  The mid-layer=0A-	 * should keep its own freeze count and use=0A-	 * a =
bottom half handler to run the queues=0A-	 * so we can unblock with our o=
wn lock held.=0A-	 */=0A-	if (unblock_reqs)=0A-		scsi_unblock_requests(ah=
c->platform_data->host);=0A-}=0A-=0A static int=0A ahc_linux_queue_recove=
ry_cmd(struct scsi_cmnd *cmd, scb_flag flag)=0A {=0A--- linux-source-2.6.=
15-orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-02-07 10:48:38.000000000 =
+0100=0A+++ linux-source-2.6.15/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-0=
2-08 13:28:43.000000000 +0100=0A@@ -368,7 +368,6 @@ struct ahc_platform_d=
ata {=0A 	struct scsi_target *starget[AHC_NUM_TARGETS]; =0A =0A 	spinlock=
_t		 spin_lock;=0A-	u_int			 qfrozen;=0A 	struct completion	*eh_done;=0A =
	struct Scsi_Host        *host;		/* pointer to scsi host */=0A #define AH=
C_LINUX_NOIRQ	((uint32_t)~0)=0A

--_=__=_XaM3_.1139404009.2A.583877.42.4423.52.42.007.9067--

