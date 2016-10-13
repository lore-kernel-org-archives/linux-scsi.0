From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mptscsih: remove bogus interpretation of request->ioprio
Date: Thu, 13 Oct 2016 10:46:41 +0200
Message-ID: <1476348401-22724-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49813 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbcJMIqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 04:46:45 -0400
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bubf2-0001v8-Cr
        for linux-scsi@vger.kernel.org; Thu, 13 Oct 2016 08:46:44 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Having an I/O priority does not mean we should send all requests as
HEAD OF QUEUE tags.

Reported-by: Adam Manzanares <adam.manzanares@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptscsih.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6c9fc11..08a807d 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1366,15 +1366,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt)
 	/* Default to untagged. Once a target structure has been allocated,
 	 * use the Inquiry data to determine if device supports tagged.
 	 */
-	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
-	    && (SCpnt->device->tagged_supported)) {
+	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES) &&
+	    SCpnt->device->tagged_supported)
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
-		if (SCpnt->request && SCpnt->request->ioprio) {
-			if (((SCpnt->request->ioprio & 0x7) == 1) ||
-				!(SCpnt->request->ioprio & 0x7))
-				scsictl |= MPI_SCSIIO_CONTROL_HEADOFQ;
-		}
-	} else
+	else
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
 
 
-- 
2.10.1.382.ga23ca1b

