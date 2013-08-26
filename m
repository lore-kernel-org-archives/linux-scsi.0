From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: [PATCH 2/3] arcmsr: Fix command throttling for ARC188x series
Date: Mon, 26 Aug 2013 12:21:30 +0800
Message-ID: <D9EDD61661F74512A33898EA49E102D7@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0029_01CEA256.CBBC1030"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0029_01CEA256.CBBC1030
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit

From: Ching <ching2048@areca.com.tw>

Fix command throttling for ARC188x series adapter.
Signed-off-by: Ching  <ching2048@areca.com.tw>
---
------=_NextPart_000_0029_01CEA256.CBBC1030
Content-Type: application/octet-stream;
	name="patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2"

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-08-26 19:23:24.000000000 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-08-26 19:25:02.000000000 +0800=0A=
@@ -51,7 +51,7 @@ struct device_attribute;=0A=
 #else=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
 #endif=0A=
-#define ARCMSR_DRIVER_VERSION		"Driver Version 1.30.00.00 2013/05/06"=0A=
+#define ARCMSR_DRIVER_VERSION		"Driver Version 1.30.00.02 2013/05/15"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID		255=0A=
 #define ARCMSR_MAX_XFER_SECTORS		512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B		4096=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-07 19:12:12.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-16 04:20:04.000000000 =
+0800=0A=
@@ -2461,12 +2461,12 @@ arcmsr_hbaC_postqueue_isr(struct Adapter=0A=
 			? true : false;=0A=
 		/* check if command done with no error */=0A=
 		arcmsr_drain_donequeue(acb, ccb, error);=0A=
+		throttling++;=0A=
 		if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
 			writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
 				&phbcmu->inbound_doorbell);=0A=
-			continue;=0A=
+			throttling =3D 0;=0A=
 		}=0A=
-		throttling++;=0A=
 	} while (readl(&phbcmu->host_int_status) &=0A=
 	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);=0A=
 }=0A=

------=_NextPart_000_0029_01CEA256.CBBC1030--
