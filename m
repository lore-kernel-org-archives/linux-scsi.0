From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [PATCH 1/5] AIC7xxx : remove qfrozen
Date: Tue, 28 Mar 2006 17:38:56 +0200
Message-ID: <IWUGSW$1A08F7ADC49061416D53454FC5B6672B@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1143560336.2A.178273.42.9900.52.42.007.14751"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:28658 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1751066AbWC1PmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:42:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1143560336.2A.178273.42.9900.52.42.007.14751
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[PATCH 1/5] AIC7xxx : remove qfrozen

This patch remove the need for platform_data->qfrozen.
Similar to his aic79xx couterpart.

Signed-off-by: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>
---

=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1143560336.2A.178273.42.9900.52.42.007.14751
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?NEW-aic7xxx-qfrozen.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?NEW-aic7xxx-qfrozen.patch?="

diff -upN linux-source-2.6.16-orig3/drivers/scsi/aic7xxx/aic7xxx_osm.c li=
nux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c=0A--- linux-source-2=
.6.16-orig3/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-03-27 16:58:49.000000=
000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c	20=
06-03-27 17:59:50.000000000 +0200=0A@@ -373,8 +373,6 @@ static void ahc_l=
inux_handle_scsi_status=0A 					 struct scb *);=0A static void ahc_linux_=
queue_cmd_complete(struct ahc_softc *ahc,=0A 					 struct scsi_cmnd *cmd)=
;=0A-static void ahc_linux_freeze_simq(struct ahc_softc *ahc);=0A-static =
void ahc_linux_release_simq(struct ahc_softc *ahc);=0A static int  ahc_li=
nux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);=0A static v=
oid ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);=0A static u_int=
 ahc_linux_user_tagdepth(struct ahc_softc *ahc,=0A@@ -475,18 +473,13 @@ a=
hc_linux_queue(struct scsi_cmnd * cmd, =0A {=0A 	struct	 ahc_softc *ahc;=0A=
 	struct	 ahc_linux_device *dev =3D scsi_transport_device_data(cmd->devic=
e);=0A-	int rtn =3D SCSI_MLQUEUE_HOST_BUSY;=0A-	unsigned long flags;=0A+	=
int	 rtn;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->device->host->hostda=
ta;=0A =0A-	ahc_lock(ahc, &flags);=0A-	if (ahc->platform_data->qfrozen =3D=
=3D 0) {=0A-		cmd->scsi_done =3D scsi_done;=0A-		cmd->result =3D CAM_REQ_=
INPROG << 16;=0A-		rtn =3D ahc_linux_run_command(ahc, dev, cmd);=0A-	}=0A=
-	ahc_unlock(ahc, &flags);=0A+	cmd->scsi_done =3D scsi_done;=0A+	cmd->res=
ult =3D CAM_REQ_INPROG << 16;=0A+	rtn =3D ahc_linux_run_command(ahc, dev,=
 cmd);=0A =0A 	return rtn;=0A }=0A@@ -747,14 +740,11 @@ ahc_linux_bus_res=
et(struct scsi_cmnd *cm=0A {=0A 	struct ahc_softc *ahc;=0A 	int    found;=
=0A-	unsigned long flags;=0A =0A 	ahc =3D *(struct ahc_softc **)cmd->devi=
ce->host->hostdata;=0A =0A-	ahc_lock(ahc, &flags);=0A 	found =3D ahc_rese=
t_channel(ahc, scmd_channel(cmd) + 'A',=0A 				  /*initiate reset*/TRUE);=
=0A-	ahc_unlock(ahc, &flags);=0A =0A 	if (bootverbose)=0A 		printf("%s: S=
CSI bus reset delivered. "=0A@@ -1175,9 +1165,9 @@ ahc_linux_initialize_s=
csi_bus(struct ahc=0A 	ahc_unlock(ahc, &s);=0A 	/* Give the bus some time=
 to recover */=0A 	if ((ahc->flags & (AHC_RESET_BUS_A|AHC_RESET_BUS_B)) !=
=3D 0) {=0A-		ahc_linux_freeze_simq(ahc);=0A+		scsi_block_requests(ahc->p=
latform_data->host);=0A 		msleep(AIC7XXX_RESET_DELAY);=0A-		ahc_linux_rel=
ease_simq(ahc);=0A+		scsi_unblock_requests(ahc->platform_data->host);=0A =
	}=0A }=0A =0A@@ -1420,13 +1410,9 @@ ahc_linux_run_command(struct ahc_sof=
tc *=0A 	struct	 ahc_tmode_tstate *tstate;=0A 	uint16_t mask;=0A 	struct =
scb_tailq *untagged_q =3D NULL;=0A+	unsigned long flags;=0A =0A-	/*=0A-	 =
* Schedule us to run later.  The only reason we are not=0A-	 * running is=
 because the whole controller Q is frozen.=0A-	 */=0A-	if (ahc->platform_=
data->qfrozen !=3D 0)=0A-		return SCSI_MLQUEUE_HOST_BUSY;=0A+	ahc_lock(ah=
c, &flags);=0A =0A 	/*=0A 	 * We only allow one untagged transaction=0A@@=
 -1440,18 +1426,22 @@ ahc_linux_run_command(struct ahc_softc *=0A =0A 		t=
arget_offset =3D cmd->device->id + cmd->device->channel * 8;=0A 		untagge=
d_q =3D &(ahc->untagged_queues[target_offset]);=0A-		if (!TAILQ_EMPTY(unt=
agged_q))=0A+		if (!TAILQ_EMPTY(untagged_q)) {=0A 			/* if we're already =
executing an untagged command=0A 			 * we're busy to another */=0A+			ahc=
_unlock(ahc, &flags);=0A 			return SCSI_MLQUEUE_DEVICE_BUSY;=0A+		}=0A 	}=
=0A =0A 	/*=0A 	 * Get an scb to use.=0A 	 */=0A 	scb =3D ahc_get_scb(ahc=
);=0A-	if (!scb)=0A+	if (!scb) {=0A+		ahc_unlock(ahc, &flags);=0A 		retur=
n SCSI_MLQUEUE_HOST_BUSY;=0A+	}=0A =0A 	scb->io_ctx =3D cmd;=0A 	scb->pla=
tform_data->dev =3D dev;=0A@@ -1602,6 +1592,9 @@ ahc_linux_run_command(st=
ruct ahc_softc *=0A 		scb->flags |=3D SCB_UNTAGGEDQ;=0A 	}=0A 	ahc_queue_=
scb(ahc, scb);=0A+=0A+	ahc_unlock(ahc, &flags);=0A+=0A 	return 0;=0A }=0A=
 =0A@@ -1637,7 +1630,6 @@ ahc_send_async(struct ahc_softc *ahc, ch=0A 	{=0A=
 		char	buf[80];=0A 		struct	scsi_target *starget;=0A-		struct	ahc_linux_=
target *targ;=0A 		struct	info_str info;=0A 		struct	ahc_initiator_tinfo =
*tinfo;=0A 		struct	ahc_tmode_tstate *tstate;=0A@@ -1676,7 +1668,6 @@ ahc=
_send_async(struct ahc_softc *ahc, ch=0A 		starget =3D ahc->platform_data=
->starget[target_offset];=0A 		if (starget =3D=3D NULL)=0A 			break;=0A-	=
	targ =3D scsi_transport_target_data(starget);=0A =0A 		target_ppr_option=
s =3D=0A 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)=0A@@ -2036,47 +202=
7,6 @@ ahc_linux_queue_cmd_complete(struct ahc_=0A 	cmd->scsi_done(cmd);=0A=
 }=0A =0A-static void=0A-ahc_linux_freeze_simq(struct ahc_softc *ahc)=0A-=
{=0A-	unsigned long s;=0A-=0A-	ahc_lock(ahc, &s);=0A-	ahc->platform_data-=
>qfrozen++;=0A-	if (ahc->platform_data->qfrozen =3D=3D 1) {=0A-		scsi_blo=
ck_requests(ahc->platform_data->host);=0A-=0A-		/* XXX What about Twin ch=
annels? */=0A-		ahc_platform_abort_scbs(ahc, CAM_TARGET_WILDCARD, ALL_CHA=
NNELS,=0A-					CAM_LUN_WILDCARD, SCB_LIST_NULL,=0A-					ROLE_INITIATOR, C=
AM_REQUEUE_REQ);=0A-	}=0A-	ahc_unlock(ahc, &s);=0A-}=0A-=0A-static void=0A=
-ahc_linux_release_simq(struct ahc_softc *ahc)=0A-{=0A-	u_long s;=0A-	int=
    unblock_reqs;=0A-=0A-	unblock_reqs =3D 0;=0A-	ahc_lock(ahc, &s);=0A-	=
if (ahc->platform_data->qfrozen > 0)=0A-		ahc->platform_data->qfrozen--;=0A=
-	if (ahc->platform_data->qfrozen =3D=3D 0)=0A-		unblock_reqs =3D 1;=0A-	=
ahc_unlock(ahc, &s);=0A-	/*=0A-	 * There is still a race here.  The mid-l=
ayer=0A-	 * should keep its own freeze count and use=0A-	 * a bottom half=
 handler to run the queues=0A-	 * so we can unblock with our own lock hel=
d.=0A-	 */=0A-	if (unblock_reqs)=0A-		scsi_unblock_requests(ahc->platform=
_data->host);=0A-}=0A-=0A static int=0A ahc_linux_queue_recovery_cmd(stru=
ct scsi_cmnd *cmd, scb_flag flag)=0A {=0A@@ -2341,19 +2291,24 @@ done:=0A=
 		ahc->platform_data->eh_done =3D &done;=0A 		ahc_unlock(ahc, &flags);=0A=
 =0A-		printf("Recovery code sleeping\n");=0A+		printf("%s: Recovery code=
 sleeping\n", ahc_name(ahc));=0A 		if (!wait_for_completion_timeout(&done=
, 5 * HZ)) {=0A 			ahc_lock(ahc, &flags);=0A 			ahc->platform_data->eh_do=
ne =3D NULL;=0A 			ahc_unlock(ahc, &flags);=0A-=0A-			printf("Timer Expir=
ed\n");=0A+			printf("%s: Timer Expired (active %d)\n",=0A+				ahc_name(a=
hc), dev->active);=0A 			retval =3D FAILED;=0A 		}=0A 		printf("Recovery =
code awake\n");=0A 	} else=0A 		ahc_unlock(ahc, &flags);=0A-	return (retv=
al);=0A+=0A+	if (retval !=3D SUCCESS)=0A+		printf("%s: Command abort retu=
rning 0x%x\n",=0A+			ahc_name(ahc), retval);=0A+	=0A+	return retval;=0A }=
=0A =0A void=0Adiff -upN linux-source-2.6.16-orig3/drivers/scsi/aic7xxx/a=
ic7xxx_osm.h linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.h=0A---=
 linux-source-2.6.16-orig3/drivers/scsi/aic7xxx/aic7xxx_osm.h	2006-03-27 =
16:58:49.000000000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/a=
ic7xxx_osm.h	2006-03-27 17:36:25.000000000 +0200=0A@@ -368,7 +368,6 @@ st=
ruct ahc_platform_data {=0A 	struct scsi_target *starget[AHC_NUM_TARGETS]=
; =0A =0A 	spinlock_t		 spin_lock;=0A-	u_int			 qfrozen;=0A 	struct compl=
etion	*eh_done;=0A 	struct Scsi_Host        *host;		/* pointer to scsi ho=
st */=0A #define AHC_LINUX_NOIRQ	((uint32_t)~0)=0ACommon subdirectories: =
linux-source-2.6.16-orig3/drivers/scsi/aic7xxx/aicasm and linux-source-2.=
6.16/drivers/scsi/aic7xxx/aicasm=0A

--_=__=_XaM3_.1143560336.2A.178273.42.9900.52.42.007.14751--

