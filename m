From: "Mark F. Haigh" <Mark.Haigh@spirentcom.com>
Subject: [PATCH 2.4.29] sym53c8xx.c - Add ULL suffix to fix warning
Date: Wed, 02 Feb 2005 17:55:36 -0800
Message-ID: <42018498.6030305@spirentcom.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080608090808010303070402"
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080608090808010303070402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Noticed that in drivers/scsi/sym53c8xx.c:

sym53c8xx.c:13185: warning: integer constant is too large for "long" type

Since we're not dealing with C99 (yet), this 64 bit integer constant
needs to be suffixed with ULL.  Patch included.


Mark F. Haigh
Mark.Haigh@spirentcom.com


--------------080608090808010303070402
Content-Type: text/plain;
 name="sym53c8xx-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sym53c8xx-patch"

--- drivers/scsi/sym53c8xx.c.orig	2005-02-02 14:35:52.981929312 -0800
+++ drivers/scsi/sym53c8xx.c	2005-02-02 14:38:38.496767232 -0800
@@ -13182,7 +13182,7 @@
 	** descriptors.
 	*/
 	if (chip && (chip->features & FE_DAC)) {
-		if (pci_set_dma_mask(pdev, (u64) 0xffffffffff))
+		if (pci_set_dma_mask(pdev, (u64) 0xffffffffffULL))
 			chip->features &= ~FE_DAC_IN_USE;
 		else
 			chip->features |= FE_DAC_IN_USE;


--------------080608090808010303070402--
