From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: [PATCH] scsi_to_dma_dir
Date: Tue, 03 Jun 2003 14:14:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpu1b7l5nu.fsf@hina.wild-wind.fr.eu.org>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:16144 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S264974AbTFCMBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 08:01:45 -0400
Received: from hina.wild-wind.fr.eu.org ([192.168.70.139])
	by young-lust.wild-wind.fr.eu.org with esmtp (Exim 3.35 #1 (Debian))
	id 19NASs-0008WS-00
	for <linux-scsi@vger.kernel.org>; Tue, 03 Jun 2003 14:00:30 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

This included patch adds scsi_to_dma_dir to scsi.h, to serve a similar
purpose as scsi_to_{sbus,pci}_dir for the generic DMA API.

It is conditionnaly defined on CONFIG_EISA or CONFIG_MCA, because most
non-PCI archs are still including asm-generic/dma-mapping.h and its
bunch of PCI functions...

I've been using it in my updated aha1740 driver for some times.

Patch is against latest 2.5.70-bk.

Thanks,

        M.

diff -ruN linux-2.5.70/drivers/scsi/scsi.h linux-current/drivers/scsi/scsi.h
--- linux-2.5.70/drivers/scsi/scsi.h	2003-06-01 16:32:37.000000000 +0200
+++ linux-current/drivers/scsi/scsi.h	2003-06-01 19:02:41.000000000 +0200
@@ -66,6 +66,32 @@
 #endif
 #endif
 
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+/*
+ * XXX FIXME :
+ *  
+ * We should be able to have this unconditionnaly
+ * defined. Unfortunately, most non-PCI architectures are still
+ * including asm-generic/dma-mapping.h, which has lots of references
+ * to PCI functions...
+ */
+#include <linux/dma-mapping.h>
+#if ((SCSI_DATA_UNKNOWN == DMA_BIDIRECTIONAL) && (SCSI_DATA_WRITE == DMA_TO_DEVICE) && (SCSI_DATA_READ == DMA_FROM_DEVICE) && (SCSI_DATA_NONE == DMA_NONE))
+#define scsi_to_dma_dir(scsi_dir)   ((enum dma_data_direction)(scsi_dir))
+#else
+extern __inline__ enum dma_data_direction scsi_to_dma_dir(unsigned char scsi_dir)
+{
+        if (scsi_dir == SCSI_DATA_UNKNOWN)
+                return DMA_BIDIRECTIONAL;
+        if (scsi_dir == SCSI_DATA_WRITE)
+                return DMA_TO_DEVICE;
+        if (scsi_dir == SCSI_DATA_READ)
+                return DMA_FROM_DEVICE;
+        return DMA_NONE;
+}
+#endif
+#endif
+
 /*
  * Some defs, in case these are not defined elsewhere.
  */

-- 
Places change, faces change. Life is so very strange.
