From: "Stephens, Larry" <larry.stephens@lsil.com>
Subject: PATCH: mpt driver 2.05.16.02 for kernel 2.4.27
Date: Tue, 12 Oct 2004 13:15:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC3CE0375D29D51199A400508B66CA6C08E8820A@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4B08F.CF2BC2A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7561 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267709AbUJLTRF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 15:17:05 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id i9CJFfcq027864
	for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2004 12:15:41 -0700 (PDT)
Received: from exc-snake.co.lsil.com (cos1.co.lsil.com [172.21.35.86])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id i9CJGxZt022889
	for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2004 12:16:59 -0700
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4B08F.CF2BC2A0
Content-Type: text/plain;
	charset="iso-8859-1"


> Attached is a patch file, updating the mpt driver from version 2.05.16 in
> the 2.4.27 kernel source file, to driver version 2.05.16.02.
> 
>  <<mptlinux-2.05.16.02.patch>> 
> The patches to file mptbase.c do this:
> 
> *	A check for PCI Function Number was added in the mpt_toolbox
> routine.  If the Function Number is odd, the ISTWI Address to be read is
> set to 0xB2.  If even, the Address to be read is set to 0xB0.  This allows
> the correct UPIC data to be read on an I2C bus.
> 
> The patches to files mptbase.h and mptscsih do this:
> 
> *	Valid SCSI LUNS are limited to 0-63 for devices running at speeds
> slower that Ultra 160, since the LUN field in the Identify byte is limited
> to 6 bits.  This prevents multiple occurrences of the same device at LUNS
> greater than 63.
> *	Driver Version number is updated to 2.05.16.02 in file mptbase.h.
> 

------_=_NextPart_000_01C4B08F.CF2BC2A0
Content-Type: application/octet-stream;
	name="mptlinux-2.05.16.02.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-2.05.16.02.patch"

diff -uarN linux-2.4.27/drivers/message/fusion/mptbase.c =
now/drivers/message/fusion/mptbase.c=0A=
--- linux-2.4.27/drivers/message/fusion/mptbase.c	2004-08-07 =
18:26:04.000000000 -0500=0A=
+++ now/drivers/message/fusion/mptbase.c	2004-08-05 09:30:19.000000000 =
-0500=0A=
@@ -4821,6 +4821,7 @@=0A=
 {=0A=
 	ToolboxIstwiReadWriteRequest_t	*pReq;=0A=
 	u32		*toolbox_alloc;=0A=
+	struct pci_dev	*pdev;=0A=
 	dma_addr_t	 toolbox_dma;=0A=
 	MPT_FRAME_HDR	*mf;=0A=
 	unsigned long	 flags;=0A=
@@ -4861,7 +4862,11 @@=0A=
 	pReq->NumAddressBytes =3D 0x01;=0A=
 	pReq->Reserved4 =3D 0;=0A=
 	pReq->DataLength =3D 0x04;=0A=
-	pReq->DeviceAddr =3D 0xB0;=0A=
+	pdev =3D (struct pci_dev *) ioc->pcidev;=0A=
+	if (pdev->devfn & 1)=0A=
+		pReq->DeviceAddr =3D 0xB2;=0A=
+	else=0A=
+		pReq->DeviceAddr =3D 0xB0;=0A=
 	pReq->Addr1 =3D 0;=0A=
 	pReq->Addr2 =3D 0;=0A=
 	pReq->Addr3 =3D 0;=0A=
diff -uarN linux-2.4.27/drivers/message/fusion/mptbase.h =
now/drivers/message/fusion/mptbase.h=0A=
--- linux-2.4.27/drivers/message/fusion/mptbase.h	2004-08-07 =
18:26:04.000000000 -0500=0A=
+++ now/drivers/message/fusion/mptbase.h	2004-08-05 09:38:32.000000000 =
-0500=0A=
@@ -81,8 +81,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"2.05.16"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.16"=0A=
+#define MPT_LINUX_VERSION_COMMON	"2.05.16.02"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.16.02"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -98,6 +98,7 @@=0A=
 #define MPT_MAX_FC_DEVICES		255=0A=
 #define MPT_MAX_SCSI_DEVICES		16=0A=
 #define MPT_LAST_LUN			255=0A=
+#define MPT_NON_IU_LAST_LUN		63=0A=
 #define MPT_SENSE_BUFFER_ALLOC		64=0A=
 	/* allow for 256 max sense alloc, but only 255 max request */=0A=
 #if MPT_SENSE_BUFFER_ALLOC >=3D 256=0A=
@@ -404,7 +405,7 @@=0A=
 	ScsiCmndTracker		 WaitQ;=0A=
 	ScsiCmndTracker		 SentQ;=0A=
 	ScsiCmndTracker		 DoneQ;=0A=
-	u32			 num_luns;=0A=
+	u32			 last_lun;=0A=
 	u32			 luns[8];		/* Max LUNs is 256 */=0A=
 	u8			 pad[4];=0A=
 	u8			 inq_data[8];=0A=
diff -uarN linux-2.4.27/drivers/message/fusion/mptscsih.c =
now/drivers/message/fusion/mptscsih.c=0A=
--- linux-2.4.27/drivers/message/fusion/mptscsih.c	2004-08-07 =
18:26:04.000000000 -0500=0A=
+++ now/drivers/message/fusion/mptscsih.c	2004-08-05 10:03:40.000000000 =
-0500=0A=
@@ -2452,7 +2452,6 @@=0A=
 	int	 datadir;=0A=
 	u32	 datalen;=0A=
 	u32	 scsictl;=0A=
-	u32	 scsidir;=0A=
 	u32	 cmd_len;=0A=
 	int	 my_idx;=0A=
 	int	 ii;=0A=
@@ -2467,6 +2466,29 @@=0A=
 	SCpnt->scsi_done =3D done;=0A=
 =0A=
 	pTarget =3D hd->Targets[target];=0A=
+	=0A=
+	if ( pTarget ) {=0A=
+		if ( lun > pTarget->last_lun ) {=0A=
+			dsprintk((MYIOC_s_INFO_FMT=0A=
+				"qcmd: lun=3D%d > last_lun=3D%d on id=3D%d\n",=0A=
+				hd->ioc->name, lun, pTarget->last_lun, target));=0A=
+			SCpnt->result =3D DID_BAD_TARGET << 16;=0A=
+			SCpnt->scsi_done(SCpnt);=0A=
+			return FAILED;=0A=
+		}=0A=
+		/* Default to untagged. Once a target structure has been =0A=
+		 * allocated, use the Inquiry data to determine if device =0A=
+		 * supports tagged.=0A=
+	 	*/=0A=
+		if ( (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
+		    && (SCpnt->device->tagged_supported)) {=0A=
+			scsictl =3D MPI_SCSIIO_CONTROL_SIMPLEQ;=0A=
+		} else {=0A=
+			scsictl =3D MPI_SCSIIO_CONTROL_UNTAGGED;=0A=
+		}=0A=
+=0A=
+	} else=0A=
+		scsictl =3D MPI_SCSIIO_CONTROL_UNTAGGED;=0A=
 =0A=
 	dmfprintk((MYIOC_s_INFO_FMT "qcmd: SCpnt=3D%p, done()=3D%p\n",=0A=
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt, done));=0A=
@@ -2513,24 +2535,13 @@=0A=
 	datadir =3D mptscsih_io_direction(SCpnt);=0A=
 	if (datadir =3D=3D SCSI_DATA_READ) {=0A=
 		datalen =3D SCpnt->request_bufflen;=0A=
-		scsidir =3D MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) =
*/=0A=
+		scsictl |=3D MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) =
*/=0A=
 	} else if (datadir =3D=3D SCSI_DATA_WRITE) {=0A=
 		datalen =3D SCpnt->request_bufflen;=0A=
-		scsidir =3D MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT (host-->ioc-->dev) =
*/=0A=
+		scsictl |=3D MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT =
(host-->ioc-->dev) */=0A=
 	} else {=0A=
 		datalen =3D 0;=0A=
-		scsidir =3D MPI_SCSIIO_CONTROL_NODATATRANSFER;=0A=
-	}=0A=
-=0A=
-	/* Default to untagged. Once a target structure has been =
allocated,=0A=
-	 * use the Inquiry data to determine if device supports tagged.=0A=
-	 */=0A=
-	if (   pTarget=0A=
-	    && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
-	    && (SCpnt->device->tagged_supported)) {=0A=
-		scsictl =3D scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;=0A=
-	} else {=0A=
-		scsictl =3D scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;=0A=
+		scsictl |=3D MPI_SCSIIO_CONTROL_NODATATRANSFER;=0A=
 	}=0A=
 =0A=
 	/* Use the above information to set up the message frame=0A=
@@ -4943,6 +4954,7 @@=0A=
 		vdev->ioc_id =3D hd->ioc->id;=0A=
 		vdev->target_id =3D target_id;=0A=
 		vdev->bus_id =3D bus_id;=0A=
+		vdev->last_lun =3D MPT_LAST_LUN;=0A=
 =0A=
 		hd->Targets[target_id] =3D vdev;=0A=
 		dprintk((KERN_INFO "  *NEW* Target structure (id %d) @ %p\n",=0A=
@@ -5305,7 +5317,7 @@=0A=
 	MPT_ADAPTER		*ioc =3D hd->ioc;=0A=
 	Config_t		*pReq;=0A=
 	SCSIDevicePage1_t	*pData;=0A=
-	VirtDevice		*pTarget;=0A=
+	VirtDevice		*pTarget=3DNULL;=0A=
 	MPT_FRAME_HDR		*mf;=0A=
 	dma_addr_t		 dataDma;=0A=
 	u16			 req_idx;=0A=
@@ -5470,6 +5482,17 @@=0A=
 		pData->Reserved =3D 0;=0A=
 		pData->Configuration =3D cpu_to_le32(configuration);=0A=
 =0A=
+		if ( pTarget ) {=0A=
+			if ( requested & MPI_SCSIDEVPAGE1_RP_IU ) {=0A=
+				pTarget->last_lun =3D MPT_LAST_LUN;=0A=
+			} else {=0A=
+				pTarget->last_lun =3D MPT_NON_IU_LAST_LUN;=0A=
+			}=0A=
+			dsprintk((MYIOC_s_INFO_FMT=0A=
+				"writeSDP1: last_lun=3D%d on id=3D%d\n",=0A=
+				ioc->name, pTarget->last_lun, id));=0A=
+		}=0A=
+=0A=
 		dprintk((MYIOC_s_INFO_FMT=0A=
 			"write SDP1: id %d pgaddr 0x%x req 0x%x config 0x%x\n",=0A=
 				ioc->name, id, (id | (bus<<8)),=0A=

------_=_NextPart_000_01C4B08F.CF2BC2A0--
