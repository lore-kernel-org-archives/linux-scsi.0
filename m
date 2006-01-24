From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ips soft lockup during reset/initialization
Date: Tue, 24 Jan 2006 14:43:41 -0500
Message-ID: <43D6836D.1070908@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:13257 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1030415AbWAXTnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 14:43:49 -0500
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id A77B04DC0
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 11:43:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Resetting the adapter causes the ServeRAID driver to exceed
the max time allowed by the softlock watchdog. Resetting the
hardware can easily require 30 or more seconds. To avoid the

    "BUG: soft lockup detected on CPU#0!" 

result, this patch replaces the mdelay() calls in the
initialization/reset routines with msleep().

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>


--- a/drivers/scsi/ips.c	Mon Jan  2 22:21:10 2006
+++ b/drivers/scsi/ips.c	Tue Jan 24 08:41:48 2006
@@ -5009,7 +5009,7 @@
 				break;
 
 			/* Delay for 1 Second */
-			MDELAY(IPS_ONE_SEC);
+			msleep(IPS_ONE_SEC);
 		}
 
 		if (j >= 45)
@@ -5035,7 +5035,7 @@
 				break;
 
 			/* Delay for 1 Second */
-			MDELAY(IPS_ONE_SEC);
+			msleep(IPS_ONE_SEC);
 		}
 
 		if (j >= 240)
@@ -5053,7 +5053,7 @@
 			break;
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 	}
 
 	if (i >= 240)
@@ -5103,7 +5103,7 @@
 				break;
 
 			/* Delay for 1 Second */
-			MDELAY(IPS_ONE_SEC);
+			msleep(IPS_ONE_SEC);
 		}
 
 		if (j >= 45)
@@ -5129,7 +5129,7 @@
 				break;
 
 			/* Delay for 1 Second */
-			MDELAY(IPS_ONE_SEC);
+			msleep(IPS_ONE_SEC);
 		}
 
 		if (j >= 240)
@@ -5147,7 +5147,7 @@
 			break;
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 	}
 
 	if (i >= 240)
@@ -5199,7 +5199,7 @@
 			break;
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 	}
 
 	if (i >= 45) {
@@ -5225,7 +5225,7 @@
 			if (Post != 0x4F00)
 				break;
 			/* Delay for 1 Second */
-			MDELAY(IPS_ONE_SEC);
+			msleep(IPS_ONE_SEC);
 		}
 
 		if (i >= 120) {
@@ -5255,7 +5255,7 @@
 			break;
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 	}
 
 	if (i >= 240) {
@@ -5315,12 +5315,12 @@
 		outb(IPS_BIT_RST, ha->io_addr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 
 		outb(0, ha->io_addr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 
 		if ((*ha->func.init) (ha))
 			break;
@@ -5360,12 +5360,12 @@
 		writeb(IPS_BIT_RST, ha->mem_ptr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 
 		writeb(0, ha->mem_ptr + IPS_REG_SCPR);
 
 		/* Delay for 1 Second */
-		MDELAY(IPS_ONE_SEC);
+		msleep(IPS_ONE_SEC);
 
 		if ((*ha->func.init) (ha))
 			break;
@@ -5406,7 +5406,7 @@
 		writel(0x80000000, ha->mem_ptr + IPS_REG_I960_IDR);
 
 		/* Delay for 5 Seconds */
-		MDELAY(5 * IPS_ONE_SEC);
+		msleep(5 * IPS_ONE_SEC);
 
 		/* Do a PCI config read to wait for adapter */
 		pci_read_config_byte(ha->pcidev, 4, &junk);
