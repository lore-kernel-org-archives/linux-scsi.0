From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [02/27]
Date: Thu, 17 Feb 2005 12:35:12 -0500
Message-ID: <4214D5D0.8020006@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:47248 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262293AbVBQRfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:35:16 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZFr30210
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:15 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZFb20680
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The drivers' Kconfig and Makefile.

diff -Nru a/drivers/scsi/adp94xx/Kconfig b/drivers/scsi/adp94xx/Kconfig
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/Kconfig	2005-02-16 16:08:12 -05:00
@@ -0,1 +1,12 @@
+#
+# adp94xx 2.5.x kernel configuration file.
+#
+# $Id: //depot/razor/linux/src/Kconfig#3 $
+#
+config SCSI_ADP94XX
+	tristate "Adaptec AIC94xx SAS/SATA support"
+	depends on PCI && SCSI
+	help
+	This driver supports all of Adaptec's 3Gb/s PCI-X
+	based SAS/SATA controllers.
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/Makefile	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,22 @@
+#
+# Makefile for the Linux adp94xx SAS driver.
+#
+# $Id: //depot/razor/linux/src/Makefile.2_6#8 $
+#
+
+obj-$(CONFIG_SCSI_ADP94XX)	+= adp94xx.o
+
+# OSM and HWI Specific Files
+adp94xx-y			+= adp94xx_osm.o	\
+				   adp94xx_hwi.o	\
+				   adp94xx_seq.o	\
+				   adp94xx_discover.o
+
+# IOCTL Specific File
+adp94xx-y			+= adp94xx_ioctl.o
+
+# SATA Specific File
+adp94xx-y			+= adp94xx_sata.o
+
+EXTRA_CFLAGS += -Idrivers/scsi -UASD_DEBUG 
+



