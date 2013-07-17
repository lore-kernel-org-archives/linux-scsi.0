From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: [PATCH 1/3] arcmsr: Modify maxium outstanding command
Date: Wed, 17 Jul 2013 10:52:55 +0800
Message-ID: <1068BE1DEB04498495FD7913A7B2CA53@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0010_01CE82DB.CAE224F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60791 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3GQCwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jul 2013 22:52:31 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so1334905pdj.14
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2013 19:52:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: ching2048@gmai.com

This is a multi-part message in MIME format.

------=_NextPart_000_0010_01CE82DB.CAE224F0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit

From: Ching<ching2048@areca.com.tw>

Modify maximum outstanding command number, notify command complete with auto 
request sense, reassign ARC12x4 series to SATA type adapter
Signed-off-by: Chingching2048@areca.com.tw
--- 

------=_NextPart_000_0010_01CE82DB.CAE224F0
Content-Type: application/octet-stream;
	name="patch1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch1"

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2012-11-17 02:02:18.000000000 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-05-07 01:49:08.000000000 +0800=0A=
@@ -51,7 +51,7 @@ struct device_attribute;=0A=
 #else=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
 #endif=0A=
-#define ARCMSR_DRIVER_VERSION		"Driver Version 1.20.00.15 2012/09/30"=0A=
+#define ARCMSR_DRIVER_VERSION		"Driver Version 1.20.00.15 2013/05/06"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID		255=0A=
 #define ARCMSR_MAX_XFER_SECTORS		512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B		4096=0A=
@@ -705,6 +705,7 @@ struct AdapterControlBlock=0A=
 	#define FW_DEADLOCK	0x0010=0A=
 	atomic_t rq_map_token;=0A=
 	atomic_t ante_token_value;=0A=
+	uint32_t maxOutstanding;=0A=
 };/* HW_DEVICE_EXTENSION */=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2012-12-19 02:02:36.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-07 19:12:12.000000000 =
+0800=0A=
@@ -2,7 +2,7 @@=0A=
 =
*************************************************************************=
******=0A=
 **        O.S   : Linux=0A=
 **   FILE NAME  : arcmsr_hba.c=0A=
-**        BY    : Nick Cheng=0A=
+**        BY    : Nick Cheng, C.L. Huang=0A=
 **   Description: SCSI RAID Device Driver for=0A=
 **                ARECA RAID Host adapter=0A=
 =
*************************************************************************=
******=0A=
@@ -71,7 +71,7 @@=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
 MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("Areca SAS RAID Controller Driver");=0A=
+MODULE_DESCRIPTION("Areca SAS,SATA RAID Controller Driver");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 =0A=
@@ -1329,7 +1329,8 @@ arcmsr_report_sense_info(struct CommandC=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
 	struct SENSE_DATA *sensebuffer =3D=0A=
 		(struct SENSE_DATA *)pcmd->sense_buffer;=0A=
-	pcmd->result =3D DID_OK << 16;=0A=
+	pcmd->result =3D (DID_OK << 16) | (CHECK_CONDITION << 1)=0A=
+		| (DRIVER_SENSE << 24);=0A=
 	if (sensebuffer) {=0A=
 		int sense_data_length =3D=0A=
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE=0A=
@@ -3313,7 +3314,7 @@ arcmsr_queue_command_lck(struct scsi_cmn=0A=
 		return 0;=0A=
 	}=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
-	ARCMSR_MAX_OUTSTANDING_CMD)=0A=
+	acb->maxOutstanding)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
@@ -3710,6 +3711,10 @@ arcmsr_get_firmware_spec(struct AdapterC=0A=
 	default:=0A=
 		break;=0A=
 	}=0A=
+	if(acb->firm_numbers_queue > ARCMSR_MAX_FREECCB_NUM)=0A=
+		acb->maxOutstanding =3D ARCMSR_MAX_FREECCB_NUM-1;=0A=
+	else=0A=
+		acb->maxOutstanding =3D acb->firm_numbers_queue - 1;=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
@@ -4882,6 +4887,7 @@ static const char=0A=
 	case PCI_DEVICE_ID_ARECA_1160:=0A=
 	case PCI_DEVICE_ID_ARECA_1170:=0A=
 	case PCI_DEVICE_ID_ARECA_1201:=0A=
+	case PCI_DEVICE_ID_ARECA_1214:=0A=
 	case PCI_DEVICE_ID_ARECA_1220:=0A=
 	case PCI_DEVICE_ID_ARECA_1230:=0A=
 	case PCI_DEVICE_ID_ARECA_1260:=0A=
@@ -4889,7 +4895,6 @@ static const char=0A=
 	case PCI_DEVICE_ID_ARECA_1280:=0A=
 		type =3D "SATA";=0A=
 		break;=0A=
-	case PCI_DEVICE_ID_ARECA_1214:=0A=
 	case PCI_DEVICE_ID_ARECA_1680:=0A=
 	case PCI_DEVICE_ID_ARECA_1681:=0A=
 	case PCI_DEVICE_ID_ARECA_1880:=0A=

------=_NextPart_000_0010_01CE82DB.CAE224F0--

