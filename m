From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 1/7] aacraid: add restart adapter platform function
Date: Thu, 15 Mar 2007 10:26:05 -0700
Message-ID: <1173979565.30374.21.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60744 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXCOR0H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:26:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

This patch updates the adapter restart function to deal with some
adapters that have specific IOP reset needs. Since the code for
restarting the adapter was in two places, changed over to utilizing a
platform function in one place.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:28:05.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:30:07.000000000 -0700
@@ -497,6 +497,7 @@ struct adapter_ops
 	void (*adapter_enable_int)(struct aac_dev *dev);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
+	int  (*adapter_restart)(struct aac_dev *dev, int bled);
 	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
 	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
@@ -1060,6 +1061,9 @@ struct aac_dev
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
 
+#define aac_adapter_restart(dev,bled) \
+	(dev)->a_ops.adapter_restart(dev,bled)
+
 #define aac_adapter_ioremap(dev, size) \
 	(dev)->a_ops.adapter_ioremap(dev, size)
 
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2007-03-15 08:28:05.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:07.000000000 -0700
@@ -1035,7 +1035,6 @@ static void aac_handle_aif(struct aac_de
 static int _aac_reset_adapter(struct aac_dev *aac)
 {
 	int index, quirks;
-	u32 ret;
 	int retval;
 	struct Scsi_Host *host;
 	struct scsi_device *dev;
@@ -1059,20 +1058,10 @@ static int _aac_reset_adapter(struct aac
 	 *	If a positive health, means in a known DEAD PANIC
 	 * state and the adapter could be reset to `try again'.
 	 */
-	retval = aac_adapter_check_health(aac);
-	if (retval == 0)
-		retval = aac_adapter_sync_cmd(aac, IOP_RESET_ALWAYS,
-		  0, 0, 0, 0, 0, 0, &ret, NULL, NULL, NULL, NULL);
-	if (retval)
-		retval = aac_adapter_sync_cmd(aac, IOP_RESET,
-		  0, 0, 0, 0, 0, 0, &ret, NULL, NULL, NULL, NULL);
+	retval = aac_adapter_restart(aac, aac_adapter_check_health(aac));
 
 	if (retval)
 		goto out;
-	if (ret != 0x00000001) {
-		retval = -ENODEV;
-		goto out;
-	}
 
 	/*
 	 *	Loop through the fibs, close the synchronous FIBS
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2007-03-15 08:28:05.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2007-03-15 08:30:07.000000000 -0700
@@ -460,22 +460,31 @@ static int aac_rx_ioremap(struct aac_dev
 	return 0;
 }
 
-static int aac_rx_restart_adapter(struct aac_dev *dev)
+static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
 {
 	u32 var;
 
-	printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
-			dev->name, dev->id);
-
-	if (aac_rx_check_health(dev) <= 0)
-		return 1;
-	if (rx_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
-			&var, NULL, NULL, NULL, NULL))
-		return 1;
+	if (bled)
+		printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
+			dev->name, dev->id, bled);
+	else
+		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
+		  0, 0, 0, 0, 0, 0, &var, NULL, NULL, NULL, NULL);
+	if (bled)
+		bled = aac_adapter_sync_cmd(dev, IOP_RESET,
+		  0, 0, 0, 0, 0, 0, &var, NULL, NULL, NULL, NULL);
+
+	if (bled)
+		return -EINVAL;
+	if (var == 0x3803000F) { /* USE_OTHER_METHOD */
+		rx_writel(dev, MUnit.reserved2, 3);
+		msleep(5000); /* Delay 5 seconds */
+		var = 0x00000001;
+	}
 	if (var != 0x00000001)
-		 return 1;
+		return -EINVAL;
 	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
-		return 1;
+		return -ENODEV;
 	return 0;
 }
 
@@ -532,9 +541,12 @@ int _aac_rx_init(struct aac_dev *dev)
 	 *	Check to see if the board panic'd while booting.
 	 */
 	status = rx_readl(dev, MUnit.OMRx[0]);
-	if (status & KERNEL_PANIC)
-		if (aac_rx_restart_adapter(dev))
+	if (status & KERNEL_PANIC) {
+		if ((status = aac_rx_check_health(dev)) <= 0)
+			goto error_iounmap;
+		if (aac_rx_restart_adapter(dev, status))
 			goto error_iounmap;
+	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -572,6 +584,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
+	dev->a_ops.adapter_restart = aac_rx_restart_adapter;
 
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we

-- 
Mark Haverkamp <markh@linux-foundation.org>

