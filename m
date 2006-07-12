From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] NCR_D700: misc fixes (section and argument ordering)
Date: Wed, 12 Jul 2006 11:55:39 -0400
Message-ID: <1152719739.3728.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10400 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751422AbWGLPzk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 11:55:40 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k6CFtdY30380
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2006 11:55:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Apparently the D700 has had an argument ordering issue for quite a while
which can cause it to get the wrong scsi_id (I just got an unbootable
voyager system because of this).  Hopefully this patch also fixes up all
the sectional mismatches within the driver.

James

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index a06f547..d05681f 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -114,7 +114,7 @@ MODULE_DESCRIPTION("NCR Dual700 SCSI Dri
 MODULE_LICENSE("GPL");
 module_param(NCR_D700, charp, 0);
 
-static __u8 __initdata id_array[2*(MCA_MAX_SLOT_NR + 1)] =
+static __u8 __devinitdata id_array[2*(MCA_MAX_SLOT_NR + 1)] =
 	{ [0 ... 2*(MCA_MAX_SLOT_NR + 1)-1] = 7 };
 
 #ifdef MODULE
@@ -173,7 +173,7 @@ struct NCR_D700_private {
 	char			pad;
 };
 
-static int 
+static int __devinit
 NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 		   int slot, u32 region, int differential)
 {
@@ -243,7 +243,7 @@ NCR_D700_intr(int irq, void *data, struc
  * essentially connectecd to the MCA bus independently, it is easier
  * to set them up as two separate host adapters, rather than one
  * adapter with two channels */
-static int
+static int __devinit
 NCR_D700_probe(struct device *dev)
 {
 	struct NCR_D700_private *p;
@@ -329,7 +329,7 @@ NCR_D700_probe(struct device *dev)
 	for (i = 0; i < 2; i++) {
 		int err;
 
-		if ((err = NCR_D700_probe_one(p, i, slot, irq,
+		if ((err = NCR_D700_probe_one(p, i, irq, slot,
 					      offset_addr + (0x80 * i),
 					      differential)) != 0)
 			printk("D700: SIOP%d: probe failed, error = %d\n",
@@ -349,7 +349,7 @@ NCR_D700_probe(struct device *dev)
 	return 0;
 }
 
-static void
+static void __devexit
 NCR_D700_remove_one(struct Scsi_Host *host)
 {
 	scsi_remove_host(host);
@@ -359,7 +359,7 @@ NCR_D700_remove_one(struct Scsi_Host *ho
 	release_region(host->base, 64);
 }
 
-static int
+static int __devexit
 NCR_D700_remove(struct device *dev)
 {
 	struct NCR_D700_private *p = dev_get_drvdata(dev);
@@ -380,7 +380,7 @@ static struct mca_driver NCR_D700_driver
 		.name		= "NCR_D700",
 		.bus		= &mca_bus_type,
 		.probe		= NCR_D700_probe,
-		.remove		= NCR_D700_remove,
+		.remove		= __devexit_p(NCR_D700_remove),
 	},
 };
 


