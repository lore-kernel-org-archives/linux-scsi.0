From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/4] aacraid: Restart adapter on firmware assert (Update 2)
Date: Tue, 08 Aug 2006 08:52:14 -0700
Message-ID: <1155052334.4060.3.camel@markh3.pdx.osdl.net>
References: <1154617371.31319.21.camel@markh3.pdx.osdl.net>
	 <20060804152411.GB6224@infradead.org>
	 <1154961299.19279.5.camel@markh3.pdx.osdl.net>
	 <20060808152730.GA29067@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35215 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964973AbWHHPwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 11:52:24 -0400
In-Reply-To: <20060808152730.GA29067@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

If the adapter should be in a blinkled (Firmware Assert) state when the
driver loads, we will perform a warm restart of the Adapter Firmware to
see if we can rescue the adapter. Possible causes of a blinkled can
occur on some early release motherboard BIOSes, transitory PCI bus
problems on embedded systems or non-x86 based architectures, transitory
startup failures of early release drives or transitory hardware
failures; some of which can bite the adapter later at runtime. Future
enhancements will include recovery during runtime.

Fixed extra whitespace space issue.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-07-31 14:33:25.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-08-08 08:44:04.000000000 -0700
@@ -1670,6 +1670,7 @@
 #define RCV_TEMP_READINGS		0x00000025
 #define GET_COMM_PREFERRED_SETTINGS	0x00000026
 #define IOP_RESET			0x00001000
+#define IOP_RESET_ALWAYS		0x00001001
 #define RE_INIT_ADAPTER			0x000000ee
 
 /*
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rkt.c	2006-07-31 14:33:25.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rkt.c	2006-08-08 08:46:50.000000000 -0700
@@ -395,6 +395,25 @@
 	return 0;
 }
 
+static int aac_rkt_restart_adapter(struct aac_dev *dev)
+{
+	u32 var;
+
+	printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
+			dev->name, dev->id);
+
+	if (aac_rkt_check_health(dev) <= 0)
+		return 1;
+	if (rkt_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
+			&var, NULL, NULL, NULL, NULL))
+		return 1;
+	if (var != 0x00000001)
+		 return 1;
+	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
+		return 1;
+	return 0;
+}
+
 /**
  *	aac_rkt_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
@@ -417,6 +436,9 @@
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
+	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
+		if (aac_rkt_restart_adapter(dev))
+			goto error_iounmap;
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -431,13 +453,6 @@
 		printk(KERN_ERR "%s%d: adapter monitor panic.\n", dev->name, instance);
 		goto error_iounmap;
 	}
-	/*
-	 *	Check to see if the board panic'd while booting.
-	 */
-	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC) {
-		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
-		goto error_iounmap;
-	}
 	start = jiffies;
 	/*
 	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2006-07-31 14:33:25.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2006-08-08 08:46:16.000000000 -0700
@@ -394,6 +394,25 @@
 	return 0;
 }
 
+static int aac_rx_restart_adapter(struct aac_dev *dev)
+{
+	u32 var;
+
+	printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
+			dev->name, dev->id);
+
+	if (aac_rx_check_health(dev) <= 0)
+		return 1;
+	if (rx_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
+			&var, NULL, NULL, NULL, NULL))
+		return 1;
+	if (var != 0x00000001)
+		 return 1;
+	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
+		return 1;
+	return 0;
+}
+
 /**
  *	aac_rx_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
@@ -416,6 +435,9 @@
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
+	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
+		if (aac_rx_restart_adapter(dev))
+			goto error_iounmap;
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
@@ -424,13 +446,6 @@
 		goto error_iounmap;
 	}
 	/*
-	 *	Check to see if the board panic'd while booting.
-	 */
-	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC) {
-		printk(KERN_ERR "%s%d: adapter kernel panic.\n", dev->name, instance);
-		goto error_iounmap;
-	}
-	/*
 	 *	Check to see if the monitor panic'd while booting.
 	 */
 	if (rx_readl(dev, MUnit.OMRx[0]) & MONITOR_PANIC) {

-- 
Mark Haverkamp <markh@osdl.org>

