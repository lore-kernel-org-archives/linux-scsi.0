From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/psi240i.c: fix an array overrun
Date: Mon, 6 Nov 2006 15:21:42 +0100
Message-ID: <20061106142142.GM5778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:18192 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1753070AbWKFOVl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 09:21:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

This patch fixes an array overrun spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6/drivers/scsi/psi240i.c.old	2006-11-06 15:18:08.000000000 +0100
+++ linux-2.6/drivers/scsi/psi240i.c	2006-11-06 15:18:43.000000000 +0100
@@ -328,7 +328,7 @@ static void Irq_Handler (int irq, void *
 				pinquiryData->AdditionalLength = 35 - 4;
 
 				// Fill in vendor identification fields.
-				for ( z = 0;  z < 20;  z += 2 )
+				for ( z = 0;  z < 8;  z += 2 )
 					{
 					pinquiryData->VendorId[z]	  = ((UCHAR *)identifyData.ModelNumber)[z + 1];
 					pinquiryData->VendorId[z + 1] = ((UCHAR *)identifyData.ModelNumber)[z];
