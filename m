From: akpm@osdl.org
Subject: [patch 19/26] revert "[SCSI] ips soft lockup during reset/initialization"
Date: Wed, 08 Nov 2006 19:56:24 -0800
Message-ID: <200611090356.kA93uOmp003983@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2482 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424011AbWKID4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jack_hammer@adaptec.com, nacc@us.ibm.com, nickpiggin@yahoo.com.au

From: Andrew Morton <akpm@osdl.org>

Revert 15084a4a63bc300c18b28a8a9afac870c552abce - it caused a
scheduling-inside-spinlock bug.

Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jack Hammer <jack_hammer@adaptec.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ips.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ips.c~revert-scsi-ips-soft-lockup-during-reset-initialization drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~revert-scsi-ips-soft-lockup-during-reset-initialization
+++ a/drivers/scsi/ips.c
@@ -5001,7 +5001,7 @@ ips_init_copperhead(ips_ha_t * ha)
 				break;
 
 			/* Delay for 1 Second */
-			msleep(IPS_ONE_SEC);
+			MDELAY(IPS_ONE_SEC);
 		}
 
 		if (j >= 45)
@@ -5027,7 +5027,7 @@ ips_init_copperhead(ips_ha_t * ha)
 				break;
 
 			/* Delay for 1 Second */
-			msleep(IPS_ONE_SEC);
+			MDELAY(IPS_ONE_SEC);
 		}
 
 		if (j >= 240)
@@ -5045,7 +5045,7 @@ ips_init_copperhead(ips_ha_t * ha)
 			break;
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 	}
 
 	if (i >= 240)
@@ -5095,7 +5095,7 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 				break;
 
 			/* Delay for 1 Second */
-			msleep(IPS_ONE_SEC);
+			MDELAY(IPS_ONE_SEC);
 		}
 
 		if (j >= 45)
@@ -5121,7 +5121,7 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 				break;
 
 			/* Delay for 1 Second */
-			msleep(IPS_ONE_SEC);
+			MDELAY(IPS_ONE_SEC);
 		}
 
 		if (j >= 240)
@@ -5139,7 +5139,7 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 			break;
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 	}
 
 	if (i >= 240)
@@ -5191,7 +5191,7 @@ ips_init_morpheus(ips_ha_t * ha)
 			break;
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 	}
 
 	if (i >= 45) {
@@ -5217,7 +5217,7 @@ ips_init_morpheus(ips_ha_t * ha)
 			if (Post != 0x4F00)
 				break;
 			/* Delay for 1 Second */
-			msleep(IPS_ONE_SEC);
+			MDELAY(IPS_ONE_SEC);
 		}
 
 		if (i >= 120) {
@@ -5247,7 +5247,7 @@ ips_init_morpheus(ips_ha_t * ha)
 			break;
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 	}
 
 	if (i >= 240) {
@@ -5307,12 +5307,12 @@ ips_reset_copperhead(ips_ha_t * ha)
 		outb(IPS_BIT_RST, ha->io_addr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 
 		outb(0, ha->io_addr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 
 		if ((*ha->func.init) (ha))
 			break;
@@ -5352,12 +5352,12 @@ ips_reset_copperhead_memio(ips_ha_t * ha
 		writeb(IPS_BIT_RST, ha->mem_ptr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 
 		writeb(0, ha->mem_ptr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		msleep(IPS_ONE_SEC);
+		MDELAY(IPS_ONE_SEC);
 
 		if ((*ha->func.init) (ha))
 			break;
@@ -5398,7 +5398,7 @@ ips_reset_morpheus(ips_ha_t * ha)
 		writel(0x80000000, ha->mem_ptr + IPS_REG_I960_IDR);
 
 		/* Delay for 5 Seconds */
-		msleep(5 * IPS_ONE_SEC);
+		MDELAY(5 * IPS_ONE_SEC);
 
 		/* Do a PCI config read to wait for adapter */
 		pci_read_config_byte(ha->pcidev, 4, &junk);
_
