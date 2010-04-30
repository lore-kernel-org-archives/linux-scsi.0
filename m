From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/5] zfcp: Report scatter-gather limits to SCSI and block layer
Date: Fri, 30 Apr 2010 18:09:33 +0200
Message-ID: <20100430161020.017350000@de.ibm.com>
References: <20100430160932.658896000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37092 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab0D3TUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:20:00 -0400
Content-Disposition: inline; filename=700-zfcp-sg-limits.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Instead of dealing with large segments in the scatter-gather lists in
zfcp_qdio.c, report the limits to the upper layers. With these limits
in place, the code for mapping large data blocks to multiple sbales
can be removed.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    4 +++
 drivers/s390/scsi/zfcp_def.h  |    1 
 drivers/s390/scsi/zfcp_qdio.c |   45 ++++++++++--------------------------------
 drivers/s390/scsi/zfcp_qdio.h |    2 +
 drivers/s390/scsi/zfcp_scsi.c |    1 
 5 files changed, 19 insertions(+), 34 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2010-04-30 16:00:39.000000000 +0200
@@ -545,6 +545,10 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 			       &zfcp_sysfs_adapter_attrs))
 		goto failed;
 
+	/* report size limit per scatter-gather segment */
+	adapter->dma_parms.max_segment_size = ZFCP_QDIO_SBALE_LEN;
+	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
+
 	if (!zfcp_adapter_scsi_register(adapter))
 		return adapter;
 
--- a/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:39.000000000 +0200
@@ -205,6 +205,7 @@ struct zfcp_adapter {
 	struct work_struct	scan_work;
 	struct service_level	service_level;
 	struct workqueue_struct	*work_queue;
+	struct device_dma_parameters dma_parms;
 };
 
 struct zfcp_port {
--- a/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:39.000000000 +0200
@@ -206,35 +206,6 @@ static void zfcp_qdio_undo_sbals(struct 
 	zfcp_qdio_zero_sbals(sbal, first, count);
 }
 
-static int zfcp_qdio_fill_sbals(struct zfcp_qdio *qdio,
-				struct zfcp_qdio_req *q_req,
-				unsigned int sbtype, void *start_addr,
-				unsigned int total_length)
-{
-	struct qdio_buffer_element *sbale;
-	unsigned long remaining, length;
-	void *addr;
-
-	/* split segment up */
-	for (addr = start_addr, remaining = total_length; remaining > 0;
-	     addr += length, remaining -= length) {
-		sbale = zfcp_qdio_sbale_next(qdio, q_req, sbtype);
-		if (!sbale) {
-			atomic_inc(&qdio->req_q_full);
-			zfcp_qdio_undo_sbals(qdio, q_req);
-			return -EINVAL;
-		}
-
-		/* new piece must not exceed next page boundary */
-		length = min(remaining,
-			     (PAGE_SIZE - ((unsigned long)addr &
-					   (PAGE_SIZE - 1))));
-		sbale->addr = addr;
-		sbale->length = length;
-	}
-	return 0;
-}
-
 /**
  * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
  * @fsf_req: request to be processed
@@ -248,7 +219,7 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 			    int max_sbals)
 {
 	struct qdio_buffer_element *sbale;
-	int retval, bytes = 0;
+	int bytes = 0;
 
 	/* figure out last allowed SBAL */
 	zfcp_qdio_sbal_limit(qdio, q_req, max_sbals);
@@ -258,10 +229,16 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 	sbale->flags |= sbtype;
 
 	for (; sg; sg = sg_next(sg)) {
-		retval = zfcp_qdio_fill_sbals(qdio, q_req, sbtype,
-					      sg_virt(sg), sg->length);
-		if (retval < 0)
-			return retval;
+		sbale = zfcp_qdio_sbale_next(qdio, q_req, sbtype);
+		if (!sbale) {
+			atomic_inc(&qdio->req_q_full);
+			zfcp_qdio_undo_sbals(qdio, q_req);
+			return -EINVAL;
+		}
+
+		sbale->addr = sg_virt(sg);
+		sbale->length = sg->length;
+
 		bytes += sg->length;
 	}
 
--- a/drivers/s390/scsi/zfcp_qdio.h	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.h	2010-04-30 16:00:39.000000000 +0200
@@ -11,6 +11,8 @@
 
 #include <asm/qdio.h>
 
+#define ZFCP_QDIO_SBALE_LEN	PAGE_SIZE
+
 /**
  * struct zfcp_qdio_queue - qdio queue buffer, zfcp index and free count
  * @sbal: qdio buffers
--- a/drivers/s390/scsi/zfcp_scsi.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2010-04-30 16:00:39.000000000 +0200
@@ -682,6 +682,7 @@ struct zfcp_data zfcp_data = {
 		.use_clustering		 = 1,
 		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
 		.max_sectors		 = (ZFCP_MAX_SBALES_PER_REQ * 8),
+		.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 		.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	},
 };

