From: akpm@osdl.org
Subject: [patch 25/26] drivers/scsi/psi240i.c: fix an array overrun
Date: Wed, 08 Nov 2006 19:56:37 -0800
Message-ID: <200611090356.kA93ubL3004027@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32179 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424027AbWKID7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:59:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Fix an array overrun spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/psi240i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/psi240i.c~drivers-scsi-psi240ic-fix-an-array-overrun drivers/scsi/psi240i.c
--- a/drivers/scsi/psi240i.c~drivers-scsi-psi240ic-fix-an-array-overrun
+++ a/drivers/scsi/psi240i.c
@@ -328,7 +328,7 @@ static void Irq_Handler (int irq, void *
 				pinquiryData->AdditionalLength = 35 - 4;
 
 				// Fill in vendor identification fields.
-				for ( z = 0;  z < 20;  z += 2 )
+				for ( z = 0;  z < 8;  z += 2 )
 					{
 					pinquiryData->VendorId[z]	  = ((UCHAR *)identifyData.ModelNumber)[z + 1];
 					pinquiryData->VendorId[z + 1] = ((UCHAR *)identifyData.ModelNumber)[z];
_
