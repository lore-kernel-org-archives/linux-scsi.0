From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 01/44] scsi: Get rid of struct fc_bsg_buffer
Date: Tue, 11 Oct 2016 13:28:32 +0200
Message-ID: <7d48b2abe199453b531e3bc6b560ea417d48d013.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

struct fc_bsg_buffer is just a clone of struct bsg_buffer from bsg-lib,
so use this one instead.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_bsg.c     |  3 ++-
 drivers/scsi/scsi_transport_fc.c |  2 +-
 include/scsi/scsi_transport_fc.h | 12 +++---------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 05dcc2a..1002627 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/list.h>
+#include <linux/bsg-lib.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -211,7 +212,7 @@ lpfc_alloc_bsg_buffers(struct lpfc_hba *phba, unsigned int size,
 
 static unsigned int
 lpfc_bsg_copy_data(struct lpfc_dmabuf *dma_buffers,
-		   struct fc_bsg_buffer *bsg_buffers,
+		   struct bsg_buffer *bsg_buffers,
 		   unsigned int bytes_to_transfer, int to_buffers)
 {
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0f3a386..8ff2067 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3671,7 +3671,7 @@ fc_bsg_job_timeout(struct request *req)
 }
 
 static int
-fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
+fc_bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 {
 	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index bf66ea6..921b097 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -28,6 +28,7 @@
 #define SCSI_TRANSPORT_FC_H
 
 #include <linux/sched.h>
+#include <linux/bsg-lib.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_netlink.h>
@@ -624,13 +625,6 @@ struct fc_host_attrs {
 #define fc_host_dev_loss_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
 
-
-struct fc_bsg_buffer {
-	unsigned int payload_len;
-	int sg_cnt;
-	struct scatterlist *sg_list;
-};
-
 /* Values for fc_bsg_job->state_flags (bitflags) */
 #define FC_RQST_STATE_INPROGRESS	0
 #define FC_RQST_STATE_DONE		1
@@ -659,8 +653,8 @@ struct fc_bsg_job {
 	 */
 
 	/* DMA payloads for the request/response */
-	struct fc_bsg_buffer request_payload;
-	struct fc_bsg_buffer reply_payload;
+	struct bsg_buffer request_payload;
+	struct bsg_buffer reply_payload;
 
 	void *dd_data;			/* Used for driver-specific storage */
 };
-- 
1.8.5.6
