From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] scsi_allocate_request() reference
Date: Mon, 21 Mar 2005 14:26:06 +0100
Message-ID: <20050321132604.GA25452@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:42217 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261787AbVCUN0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 08:26:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Hi,

scsi_allocate_request() doesn't hold a reference to the device that it
points to, that is not good. This patch fixes that up.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/scsi.c 1.157 vs edited =====
--- 1.157/drivers/scsi/scsi.c	2005-03-03 09:22:17 +01:00
+++ edited/drivers/scsi/scsi.c	2005-03-21 14:24:27 +01:00
@@ -132,7 +132,11 @@
 	const int offset = ALIGN(sizeof(struct scsi_request), 4);
 	const int size = offset + sizeof(struct request);
 	struct scsi_request *sreq;
-  
+
+
+	if (!get_device(&sdev->sdev_gendev))
+		return NULL;
+
 	sreq = kmalloc(size, gfp_mask);
 	if (likely(sreq != NULL)) {
 		memset(sreq, 0, size);
@@ -141,7 +145,8 @@
 		sreq->sr_host = sdev->host;
 		sreq->sr_magic = SCSI_REQ_MAGIC;
 		sreq->sr_data_direction = DMA_BIDIRECTIONAL;
-	}
+	} else
+		put_device(&sdev->sdev_gendev);
 
 	return sreq;
 }
@@ -184,6 +189,10 @@
 void scsi_release_request(struct scsi_request *sreq)
 {
 	__scsi_release_request(sreq);
+
+	if (sreq->sr_device)
+		put_device(&sreq->sr_device->sdev_gendev);
+
 	kfree(sreq);
 }
 EXPORT_SYMBOL(scsi_release_request);

-- 
Jens Axboe

