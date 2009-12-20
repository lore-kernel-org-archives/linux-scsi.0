From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 1/3] g_NCR5380: remove misleading pnp error message
Date: Sun, 20 Dec 2009 20:41:05 +0100
Message-ID: <200912202041.06891.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756301AbZLTTlX@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove misleading error message that appears after pnp card has been detected
correctly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.c	2009-12-18 21:03:01.000000000 +0100
@@ -322,10 +322,8 @@ int __init generic_NCR5380_detect(struct
 		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
 			if (count >= NO_OVERRIDES)
 				break;
-			if (pnp_device_attach(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: attach failed\n");
+			if (pnp_device_attach(dev) < 0)
 				continue;
-			}
 			if (pnp_activate_dev(dev) < 0) {
 				printk(KERN_ERR "dtc436e probe: activate failed\n");
 				pnp_device_detach(dev);


-- 
Ondrej Zary
