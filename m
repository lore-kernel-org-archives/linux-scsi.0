From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix dma mapping leak in fusion
Date: Tue, 17 Aug 2004 18:16:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817161642.GA16509@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:6635 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268325AbUHQQQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:16:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: moore@lsil.com
Cc: linux-scsi@vger.kernel.org

stop fusion from leaking dma maps when the device has been offlined


--- 1.13/drivers/message/fusion/linux_compat.h	2004-06-23 16:48:43 +02:00
+++ edited/drivers/message/fusion/linux_compat.h	2004-08-17 20:09:21 +02:00
@@ -3,16 +3,4 @@
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
-/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif /* _LINUX_COMPAT_H */
===== drivers/message/fusion/mptscsih.c 1.45 vs edited =====
--- 1.45/drivers/message/fusion/mptscsih.c	2004-08-03 01:01:01 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-08-17 20:02:54 +02:00
@@ -1019,19 +1019,18 @@
 			 * Do OS callback
 			 * Free driver resources (chain, msg buffers)
 			 */
-			if (scsi_device_online(SCpnt->device)) {
-				if (SCpnt->use_sg) {
-					pci_unmap_sg(ioc->pcidev,
-						(struct scatterlist *) SCpnt->request_buffer,
-						SCpnt->use_sg,
-						SCpnt->sc_data_direction);
-				} else if (SCpnt->request_bufflen) {
-					pci_unmap_single(ioc->pcidev,
-						SCpnt->SCp.dma_handle,
-						SCpnt->request_bufflen,
-						SCpnt->sc_data_direction);
-				}
+			if (SCpnt->use_sg) {
+				pci_unmap_sg(ioc->pcidev,
+					(struct scatterlist *) SCpnt->request_buffer,
+					SCpnt->use_sg,
+					SCpnt->sc_data_direction);
+			} else if (SCpnt->request_bufflen) {
+				pci_unmap_single(ioc->pcidev,
+					SCpnt->SCp.dma_handle,
+					SCpnt->request_bufflen,
+					SCpnt->sc_data_direction);
 			}
+
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
