From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't leak dma maps in mptscsih_flush_running_cmds
Date: Sun, 4 Jul 2004 16:53:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040704145309.GA17877@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:45795 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265715AbUGDOxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2004 10:53:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

the scsi_device_online() check is bogus, we need to unmap for all
commands, not online for devices that are online.


--- 1.13/drivers/message/fusion/linux_compat.h	2004-06-23 16:48:43 +02:00
+++ edited/drivers/message/fusion/linux_compat.h	2004-07-04 18:47:18 +02:00
@@ -3,16 +3,5 @@
 #ifndef FUSION_LINUX_COMPAT_H
 #define FUSION_LINUX_COMPAT_H
 
-#include <linux/version.h>
-#include <scsi/scsi_device.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
-static int inline scsi_device_online(struct scsi_device *sdev)
-{
-	return sdev->online;
-}
-#endif
-
-
 /*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif /* _LINUX_COMPAT_H */
--- 1.42/drivers/message/fusion/mptscsih.c	2004-06-23 16:48:44 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-07-04 18:47:07 +02:00
@@ -995,19 +994,18 @@
 			 * Do OS callback
 			 * Free driver resources (chain, msg buffers)
 			 */
-			if (scsi_device_online(SCpnt->device)) {
-				if (SCpnt->use_sg) {
-					pci_unmap_sg(hd->ioc->pcidev,
-						(struct scatterlist *) SCpnt->request_buffer,
-						SCpnt->use_sg,
-						SCpnt->sc_data_direction);
-				} else if (SCpnt->request_bufflen) {
-					pci_unmap_single(hd->ioc->pcidev,
-						SCpnt->SCp.dma_handle,
-						SCpnt->request_bufflen,
-						SCpnt->sc_data_direction);
-				}
+			if (SCpnt->use_sg) {
+				pci_unmap_sg(hd->ioc->pcidev,
+					(struct scatterlist *) SCpnt->request_buffer,
+					SCpnt->use_sg,
+					SCpnt->sc_data_direction);
+			} else if (SCpnt->request_bufflen) {
+				pci_unmap_single(hd->ioc->pcidev,
+					SCpnt->SCp.dma_handle,
+					SCpnt->request_bufflen,
+					SCpnt->sc_data_direction);
 			}
+
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
