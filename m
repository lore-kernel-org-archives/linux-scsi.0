From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [PATCH 5/5] AIC7xxx :  Update error recovery
Date: Tue, 28 Mar 2006 17:57:18 +0200
Message-ID: <IWUHNI$142D1C4F33CAFBB6D4479089B20AE55F@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1143561438.2A.803505.42.12446.52.42.007.2048"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:29137 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932092AbWC1P6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:58:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1143561438.2A.803505.42.12446.52.42.007.2048
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[PATCH 5/5] AIC7xxx :  Update error recovery

Port of Hannes Reinecke patch to update error recovery.
Routines for TARGET RESET and ABORT COMMAND are split
up as the logic is quite dissimilar.

Signed-off-by: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>
---
=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1143561438.2A.803505.42.12446.52.42.007.2048
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?NEW-aic7xxx-errorrecovery.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?NEW-aic7xxx-errorrecovery.patch?="

diff -upN linux-source-2.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.c li=
nux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c=0A--- linux-source-2=
.6.16-orig2/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-03-28 10:49:09.000000=
000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xxx/aic7xxx_osm.c	20=
06-03-28 13:55:40.000000000 +0200=0A@@ -373,7 +373,7 @@ static void ahc_l=
inux_handle_scsi_status=0A 					 struct scb *);=0A static void ahc_linux_=
queue_cmd_complete(struct ahc_softc *ahc,=0A 					 struct scsi_cmnd *cmd)=
;=0A-static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_=
flag flag);=0A+static int ahc_linux_queue_abort_cmd(struct scsi_cmnd *cmd=
);=0A static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);=0A=
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,=0A 				     =
struct ahc_devinfo *devinfo);=0A@@ -712,10 +712,8 @@ ahc_linux_abort(stru=
ct scsi_cmnd *cmd)=0A {=0A 	int error;=0A =0A-	error =3D ahc_linux_queue_=
recovery_cmd(cmd, SCB_ABORT);=0A-	if (error !=3D 0)=0A-		printf("aic7xxx_=
abort returns 0x%x\n", error);=0A-	return (error);=0A+	error =3D ahc_linu=
x_queue_abort_cmd(cmd);=0A+	return error;=0A }=0A =0A /*=0A@@ -724,12 +72=
2,88 @@ ahc_linux_abort(struct scsi_cmnd *cmd)=0A static int=0A ahc_linux=
_dev_reset(struct scsi_cmnd *cmd)=0A {=0A-	int error;=0A+	struct ahc_soft=
c *ahc;=0A+	struct ahc_linux_device *dev;=0A+	struct scb *reset_scb;=0A+	=
u_int  cdb_byte;=0A+	int    retval =3D SUCCESS;=0A+	int    paused;=0A+	in=
t    wait;=0A+	unsigned long flags;=0A+	DECLARE_COMPLETION(done);=0A+=0A+=
	reset_scb =3D NULL;=0A+	paused =3D FALSE;=0A+	wait =3D FALSE;=0A+	ahc =3D=
 *(struct ahc_softc **)cmd->device->host->hostdata;=0A =0A-	error =3D ahc=
_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);=0A-	if (error !=3D 0)=0A=
-		printf("aic7xxx_dev_reset returns 0x%x\n", error);=0A-	return (error);=
=0A+	scmd_printk(KERN_INFO, cmd,=0A+			"Attempting to queue a TARGET RESE=
T message:");=0A+=0A+	printf("CDB:");=0A+	for (cdb_byte =3D 0; cdb_byte <=
 cmd->cmd_len; cdb_byte++)=0A+		printf(" 0x%x", cmd->cmnd[cdb_byte]);=0A+=
	printf("\n");=0A+=0A+	/*=0A+	 * Determine if we currently own this comma=
nd.=0A+	 */=0A+	dev =3D scsi_transport_device_data(cmd->device);=0A+=0A+	=
if (dev =3D=3D NULL) {=0A+		/*=0A+		 * No target device for this command =
exists,=0A+		 * so we must not still own the command.=0A+		 */=0A+		scmd_=
printk(KERN_INFO, cmd, "Is not an active device\n");=0A+		return  SUCCESS=
;=0A+	}=0A+=0A+	/*=0A+	 * Generate us a new SCB=0A+	 */=0A+	reset_scb =3D=
 ahc_get_scb(ahc);=0A+	if (!reset_scb) {=0A+		scmd_printk(KERN_INFO, cmd,=
 "No SCB available\n");=0A+		return FAILED;=0A+	}=0A+=0A+	reset_scb->io_c=
tx =3D cmd;=0A+	reset_scb->platform_data->dev =3D dev;=0A+	reset_scb->sg_=
count =3D 0;=0A+	ahc_set_residual(reset_scb, 0);=0A+	ahc_set_sense_residu=
al(reset_scb, 0);=0A+	reset_scb->platform_data->xfer_len =3D 0;=0A+	reset=
_scb->hscb->control =3D MK_MESSAGE;=0A+	reset_scb->hscb->scsiid =3D BUILD=
_SCSIID(ahc, cmd);=0A+	reset_scb->hscb->lun =3D cmd->device->lun;=0A+	res=
et_scb->hscb->cdb_len =3D 0;=0A+	reset_scb->flags |=3D SCB_DEVICE_RESET|S=
CB_RECOVERY_SCB|SCB_ACTIVE;=0A+=0A+	dev->openings--;=0A+	dev->active++;=0A=
+	dev->commands_issued++;=0A+=0A+	ahc_lock(ahc, &flags);=0A+=0A+	LIST_INS=
ERT_HEAD(&ahc->pending_scbs, reset_scb, pending_links);=0A+	ahc_queue_scb=
(ahc, reset_scb);=0A+=0A+	ahc->platform_data->eh_done =3D &done;=0A+	ahc_=
unlock(ahc, &flags);=0A+=0A+	printf("%s: Device reset code sleeping\n", a=
hc_name(ahc));=0A+	if (!wait_for_completion_timeout(&done, 5 * HZ)) {=0A+=
		ahc_lock(ahc, &flags);=0A+		ahc->platform_data->eh_done =3D NULL;=0A+		=
ahc_unlock(ahc, &flags);=0A+		printf("%s: Device reset timer expired (act=
ive %d)\n",=0A+			ahc_name(ahc), dev->active);=0A+		retval =3D FAILED;=0A=
+	}=0A+	printf("%s: Device reset returning 0x%x\n", ahc_name(ahc), retval=
);=0A+=0A+	return retval;=0A }=0A =0A /*=0A@@ -1954,75 +2028,113 @@ ahc_l=
inux_handle_scsi_status(struct ahc_=0A static void=0A ahc_linux_queue_cmd=
_complete(struct ahc_softc *ahc, struct scsi_cmnd *cmd)=0A {=0A+	int stat=
us;=0A+	int new_status =3D DID_OK;=0A+	int do_fallback =3D 0;=0A+	int scs=
i_status;=0A+	=0A 	/*=0A 	 * Map CAM error codes into Linux Error codes. =
 We=0A 	 * avoid the conversion so that the DV code has the=0A 	 * full e=
rror information available when making=0A 	 * state change decisions.=0A =
	 */=0A-	{=0A-		u_int new_status;=0A =0A-		switch (ahc_cmd_get_transactio=
n_status(cmd)) {=0A-		case CAM_REQ_INPROG:=0A-		case CAM_REQ_CMP:=0A-		ca=
se CAM_SCSI_STATUS_ERROR:=0A-			new_status =3D DID_OK;=0A-			break;=0A-		=
case CAM_REQ_ABORTED:=0A-			new_status =3D DID_ABORT;=0A-			break;=0A-		c=
ase CAM_BUSY:=0A-			new_status =3D DID_BUS_BUSY;=0A-			break;=0A-		case C=
AM_REQ_INVALID:=0A-		case CAM_PATH_INVALID:=0A-			new_status =3D DID_BAD_=
TARGET;=0A-			break;=0A-		case CAM_SEL_TIMEOUT:=0A-			new_status =3D DID_=
NO_CONNECT;=0A-			break;=0A-		case CAM_SCSI_BUS_RESET:=0A-		case CAM_BDR_=
SENT:=0A-			new_status =3D DID_RESET;=0A-			break;=0A-		case CAM_UNCOR_PA=
RITY:=0A-			new_status =3D DID_PARITY;=0A-			break;=0A-		case CAM_CMD_TIM=
EOUT:=0A-			new_status =3D DID_TIME_OUT;=0A-			break;=0A-		case CAM_UA_AB=
ORT:=0A-		case CAM_REQ_CMP_ERR:=0A-		case CAM_AUTOSENSE_FAIL:=0A-		case C=
AM_NO_HBA:=0A-		case CAM_DATA_RUN_ERR:=0A-		case CAM_UNEXP_BUSFREE:=0A-		=
case CAM_SEQUENCE_FAIL:=0A-		case CAM_CCB_LEN_ERR:=0A-		case CAM_PROVIDE_=
FAIL:=0A-		case CAM_REQ_TERMIO:=0A-		case CAM_UNREC_HBA_ERROR:=0A-		case =
CAM_REQ_TOO_BIG:=0A-			new_status =3D DID_ERROR;=0A-			break;=0A-		case C=
AM_REQUEUE_REQ:=0A-			new_status =3D DID_REQUEUE;=0A+	status =3D ahc_cmd_=
get_transaction_status(cmd);=0A+	switch (status) {=0A+	case CAM_REQ_INPRO=
G:=0A+	case CAM_REQ_CMP:=0A+		new_status =3D DID_OK;=0A+		break;=0A+	case=
 CAM_AUTOSENSE_FAIL:=0A+		new_status =3D DID_ERROR;=0A+		/* Fallthrough *=
/=0A+	case CAM_SCSI_STATUS_ERROR:=0A+		scsi_status =3D ahc_cmd_get_scsi_s=
tatus(cmd);=0A+=0A+		switch(scsi_status) {=0A+		case SCSI_STATUS_CMD_TERM=
INATED:=0A+		case SCSI_STATUS_CHECK_COND:=0A+			if ((cmd->result >> 24) !=
=3D DRIVER_SENSE) {=0A+				do_fallback =3D 1;=0A+			} else {=0A+				struc=
t scsi_sense_data *sense;=0A+=0A+				sense =3D (struct scsi_sense_data *)=
=0A+					&cmd->sense_buffer;=0A+				if (sense->extra_len >=3D5 &&=0A+				=
	(sense->add_sense_code =3D=3D 0x47=0A+					 || sense->add_sense_code =3D=
=3D 0x48))=0A+						do_fallback =3D 1;=0A+			}=0A 			break;=0A 		default:=
=0A-			/* We should never get here */=0A-			new_status =3D DID_ERROR;=0A =
			break;=0A 		}=0A+		break;=0A+	case CAM_REQ_ABORTED:=0A+		new_status =3D=
 DID_ABORT;=0A+		break;=0A+	case CAM_BUSY:=0A+		new_status =3D DID_BUS_BU=
SY;=0A+		break;=0A+	case CAM_REQ_INVALID:=0A+	case CAM_PATH_INVALID:=0A+	=
	new_status =3D DID_BAD_TARGET;=0A+		break;=0A+	case CAM_SEL_TIMEOUT:=0A+=
		new_status =3D DID_NO_CONNECT;=0A+		break;=0A+	case CAM_SCSI_BUS_RESET:=
=0A+	case CAM_BDR_SENT:=0A+		new_status =3D DID_RESET;=0A+		break;=0A+	ca=
se CAM_UNCOR_PARITY:=0A+		new_status =3D DID_PARITY;=0A+		do_fallback =3D=
 1;=0A+		break;=0A+	case CAM_CMD_TIMEOUT:=0A+		new_status =3D DID_TIME_OU=
T;=0A+		do_fallback =3D 1;=0A+		break;=0A+	case CAM_REQ_CMP_ERR:=0A+	case=
 CAM_UNEXP_BUSFREE:=0A+	case CAM_DATA_RUN_ERR:=0A+		new_status =3D DID_ER=
ROR;=0A+		do_fallback =3D 1;=0A+		break;=0A+	case CAM_UA_ABORT:=0A+	case =
CAM_NO_HBA:=0A+	case CAM_SEQUENCE_FAIL:=0A+	case CAM_CCB_LEN_ERR:=0A+	cas=
e CAM_PROVIDE_FAIL:=0A+	case CAM_REQ_TERMIO:=0A+	case CAM_UNREC_HBA_ERROR=
:=0A+	case CAM_REQ_TOO_BIG:=0A+		new_status =3D DID_ERROR;=0A+		break;=0A=
+	case CAM_REQUEUE_REQ:=0A+		new_status =3D DID_REQUEUE;=0A+		break;=0A+	=
default:=0A+		/* We should never get here */=0A+		new_status =3D DID_ERRO=
R;=0A+		break;=0A+	}=0A =0A-		ahc_cmd_set_transaction_status(cmd, new_sta=
tus);=0A+	if (do_fallback) {=0A+		printf("%s: device overrun (status %x) =
on %d:%d:%d\n",=0A+			ahc_name(ahc), status, cmd->device->channel,=0A+			=
cmd->device->id, cmd->device->lun);=0A 	}=0A =0A+	ahc_cmd_set_transaction=
_status(cmd, new_status);=0A+=0A 	cmd->scsi_done(cmd);=0A }=0A =0A static=
 int=0A-ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag=
)=0A+ahc_linux_queue_abort_cmd(struct scsi_cmnd *cmd)=0A {=0A 	struct ahc=
_softc *ahc;=0A 	struct ahc_linux_device *dev;=0A@@ -2044,8 +2156,7 @@ ah=
c_linux_queue_recovery_cmd(struct scsi=0A 	wait =3D FALSE;=0A 	ahc =3D *(=
struct ahc_softc **)cmd->device->host->hostdata;=0A =0A-	scmd_printk(KERN=
_INFO, cmd, "Attempting to queue a%s message\n",=0A-	       flag =3D=3D S=
CB_ABORT ? "n ABORT" : " TARGET RESET");=0A+	scmd_printk(KERN_INFO, cmd, =
"Attempting to queue an ABORT message:");=0A =0A 	printf("CDB:");=0A 	for=
 (cdb_byte =3D 0; cdb_byte < cmd->cmd_len; cdb_byte++)=0A@@ -2095,18 +220=
6,6 @@ ahc_linux_queue_recovery_cmd(struct scsi=0A 			break;=0A 	}=0A =0A=
-	if (pending_scb =3D=3D NULL && flag =3D=3D SCB_DEVICE_RESET) {=0A-=0A-	=
	/* Any SCB for this device will do for a target reset */=0A-		LIST_FOREA=
CH(pending_scb, &ahc->pending_scbs, pending_links) {=0A-		  	if (ahc_matc=
h_scb(ahc, pending_scb, scmd_id(cmd),=0A-					  scmd_channel(cmd) + 'A',=0A=
-					  CAM_LUN_WILDCARD,=0A-					  SCB_LIST_NULL, ROLE_INITIATOR))=0A-		=
		break;=0A-		}=0A-	}=0A-=0A 	if (pending_scb =3D=3D NULL) {=0A 		scmd_pr=
intk(KERN_INFO, cmd, "Command not found\n");=0A 		goto no_cmd;=0A@@ -2139=
,25 +2238,17 @@ ahc_linux_queue_recovery_cmd(struct scsi=0A 	ahc_dump_car=
d_state(ahc);=0A =0A 	disconnected =3D TRUE;=0A-	if (flag =3D=3D SCB_ABOR=
T) {=0A-		if (ahc_search_qinfifo(ahc, cmd->device->id,=0A-				       cmd-=
>device->channel + 'A',=0A-				       cmd->device->lun,=0A-				       pen=
ding_scb->hscb->tag,=0A-				       ROLE_INITIATOR, CAM_REQ_ABORTED,=0A-		=
		       SEARCH_COMPLETE) > 0) {=0A-			printf("%s:%d:%d:%d: Cmd aborted f=
rom QINFIFO\n",=0A-			       ahc_name(ahc), cmd->device->channel,=0A-				=
	cmd->device->id, cmd->device->lun);=0A-			retval =3D SUCCESS;=0A-			goto=
 done;=0A-		}=0A-	} else if (ahc_search_qinfifo(ahc, cmd->device->id,=0A-=
				      cmd->device->channel + 'A',=0A-				      cmd->device->lun, pend=
ing_scb->hscb->tag,=0A-				      ROLE_INITIATOR, /*status*/0,=0A-				    =
  SEARCH_COUNT) > 0) {=0A-		disconnected =3D FALSE;=0A+	if (ahc_search_qi=
nfifo(ahc, cmd->device->id,=0A+			       cmd->device->channel + 'A',=0A+	=
		       cmd->device->lun,=0A+			       pending_scb->hscb->tag,=0A+			   =
    ROLE_INITIATOR, CAM_REQ_ABORTED,=0A+			       SEARCH_COMPLETE) > 0) {=
=0A+		printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",=0A+		       ahc_n=
ame(ahc), cmd->device->channel,=0A+				cmd->device->id, cmd->device->lun)=
;=0A+		retval =3D SUCCESS;=0A+		goto done;=0A 	}=0A =0A 	if (disconnected=
 && (ahc_inb(ahc, SEQ_FLAGS) & NOT_IDENTIFIED) =3D=3D 0) {=0A@@ -2166,10 =
+2257,6 @@ ahc_linux_queue_recovery_cmd(struct scsi=0A 		bus_scb =3D ahc_=
lookup_scb(ahc, ahc_inb(ahc, SCB_TAG));=0A 		if (bus_scb =3D=3D pending_s=
cb)=0A 			disconnected =3D FALSE;=0A-		else if (flag !=3D SCB_ABORT=0A-		=
      && ahc_inb(ahc, SAVED_SCSIID) =3D=3D pending_scb->hscb->scsiid=0A-	=
	      && ahc_inb(ahc, SAVED_LUN) =3D=3D SCB_GET_LUN(pending_scb))=0A-			=
disconnected =3D FALSE;=0A 	}=0A =0A 	/*=0A@@ -2185,16 +2272,14 @@ ahc_li=
nux_queue_recovery_cmd(struct scsi=0A 	active_scb_index =3D ahc_inb(ahc, =
SCB_TAG);=0A 	saved_scsiid =3D ahc_inb(ahc, SAVED_SCSIID);=0A 	if (last_p=
hase !=3D P_BUSFREE=0A-	 && (pending_scb->hscb->tag =3D=3D active_scb_ind=
ex=0A-	  || (flag =3D=3D SCB_DEVICE_RESET=0A-	   && SCSIID_TARGET(ahc, sa=
ved_scsiid) =3D=3D scmd_id(cmd)))) {=0A+	 && (pending_scb->hscb->tag) =3D=
=3D active_scb_index ) {=0A =0A 		/*=0A 		 * We're active on the bus, so =
assert ATN=0A 		 * and hope that the target responds.=0A 		 */=0A 		pendi=
ng_scb =3D ahc_lookup_scb(ahc, active_scb_index);=0A-		pending_scb->flags=
 |=3D SCB_RECOVERY_SCB|flag;=0A+		pending_scb->flags |=3D SCB_RECOVERY_SC=
B|SCB_ABORT;=0A 		ahc_outb(ahc, MSG_OUT, HOST_MSG);=0A 		ahc_outb(ahc, SC=
SISIGO, last_phase|ATNO);=0A 		scmd_printk(KERN_INFO, cmd, "Device is act=
ive, asserting ATN\n");=0A@@ -2218,7 +2303,7 @@ ahc_linux_queue_recovery_=
cmd(struct scsi=0A 		 * an unsolicited reselection occurred.=0A 		 */=0A =
		pending_scb->hscb->control |=3D MK_MESSAGE|DISCONNECTED;=0A-		pending_s=
cb->flags |=3D SCB_RECOVERY_SCB|flag;=0A+		pending_scb->flags |=3D SCB_RE=
COVERY_SCB|SCB_ABORT;=0A =0A 		/*=0A 		 * Remove any cached copy of this =
SCB in the=0ACommon subdirectories: linux-source-2.6.16-orig2/drivers/scs=
i/aic7xxx/aicasm and linux-source-2.6.16/drivers/scsi/aic7xxx/aicasm=0A

--_=__=_XaM3_.1143561438.2A.803505.42.12446.52.42.007.2048--

