From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 7/8] mptfusion: resid cleanup
Date: Fri, 19 Nov 2004 08:39:49 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C5468B2@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CE4E.00EA42E0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35520 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261472AbUKSQMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:12:12 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iAJGAXcq006834
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:10:33 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iAJGC8GD030531
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:12:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CE4E.00EA42E0
Content-Type: text/plain;
	charset="iso-8859-1"

This cleanup returns residual for all completed
scsi io.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>










------_=_NextPart_000_01C4CE4E.00EA42E0
Content-Type: application/octet-stream;
	name="mptfusion-7.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-7.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 14:54:45.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 15:28:37.000000000 =
-0700=0A=
@@ -674,13 +674,14 @@=0A=
 		scsi_state =3D pScsiReply->SCSIState;=0A=
 		scsi_status =3D pScsiReply->SCSIStatus;=0A=
 		xfer_cnt =3D le32_to_cpu(pScsiReply->TransferCount);=0A=
+		sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
 =0A=
-		dreplyprintk((KERN_NOTICE " Reply (%d:%d:%d) mf=3D%p, mr=3D%p, =
sc=3D%p\n",=0A=
-				ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
-				mf, mr, sc));=0A=
-		dreplyprintk((KERN_NOTICE "IOCStatus=3D%04xh SCSIState=3D%02xh"=0A=
-				" SCSIStatus=3D%02xh xfer_cnt=3D%08xh\n",=0A=
-				status, scsi_state, scsi_status, xfer_cnt));=0A=
+		dreplyprintk((KERN_NOTICE "Reply ha=3D%d id=3D%d lun=3D%d:\n"=0A=
+			"IOCStatus=3D%04xh SCSIState=3D%02xh SCSIStatus=3D%02xh\n"=0A=
+			"resid=3D%d bufflen=3D%d xfer_cnt=3D%d\n",=0A=
+			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
+			status, scsi_state, scsi_status, sc->resid, =0A=
+			sc->request_bufflen, xfer_cnt));=0A=
 =0A=
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)=0A=
 			copy_sense_data(sc, hd, mf, pScsiReply);=0A=
@@ -730,7 +731,6 @@=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */=0A=
-			sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
 			if ( xfer_cnt >=3D sc->underflow ) {=0A=
 				/* Sufficient data transfer occurred */=0A=
 				sc->result =3D (DID_OK << 16) | scsi_status;=0A=
@@ -759,7 +759,7 @@=0A=
 				 */=0A=
 				;=0A=
 			} else {=0A=
-				if ( (xfer_cnt =3D=3D 0) || (sc->underflow > xfer_cnt)) {=0A=
+				if (xfer_cnt < sc->underflow) {=0A=
 					sc->result =3D DID_SOFT_ERROR << 16;=0A=
 				}=0A=
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | =
MPI_SCSI_STATE_NO_SCSI_STATUS)) {=0A=
@@ -773,15 +773,9 @@=0A=
 				}=0A=
 			}=0A=
 =0A=
-			/* Give report and update residual count.=0A=
-			 */=0A=
 			dreplyprintk((KERN_NOTICE "  sc->underflow=3D{report ERR if < %02xh =
bytes xfer'd}\n",=0A=
 					sc->underflow));=0A=
 			dreplyprintk((KERN_NOTICE "  ActBytesXferd=3D%02xh\n", =
xfer_cnt));=0A=
-=0A=
-			sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
-			dreplyprintk((KERN_NOTICE "  SET sc->resid=3D%02xh\n", =
sc->resid));=0A=
-			=0A=
 			/* Report Queue Full=0A=
 			 */=0A=
 			if (scsi_status =3D=3D MPI_SCSI_STATUS_TASK_SET_FULL)=0A=
@@ -836,7 +830,7 @@=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */=0A=
-				sc->result =3D DID_SOFT_ERROR << 16;=0A=
+			sc->result =3D DID_SOFT_ERROR << 16;=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_INVALID_FUNCTION:		/* 0x0001 */=0A=

------_=_NextPart_000_01C4CE4E.00EA42E0--
