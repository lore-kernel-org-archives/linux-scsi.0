From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/15]  qla2xxx: 2100 request-q contraints
Date: Thu, 6 May 2004 22:51:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055100.GA4893@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:62204 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262914AbUEGFtQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:49:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1924 04/04/30 10:39:56 andrew.vasquez@apc.qlogic.com +5 -0
  Older, notably the ISP2100, chips have some contraints for the request
  queue depth and number of scatter-gather elements allowed for a 
  given command.  For this chip, reduce request queue size to 128 and 
  maximum number of scatter-gather entries for a command to 32.   

 drivers/scsi/qla2xxx/qla_def.h  |   14 +++-----------
 drivers/scsi/qla2xxx/qla_init.c |    9 +++++----
 drivers/scsi/qla2xxx/qla_iocb.c |   14 +++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |   14 +++++++++-----
 drivers/scsi/qla2xxx/qla_rscn.c |    2 +-
 5 files changed, 25 insertions(+), 28 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:13:28 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:13:28 2004
@@ -209,20 +209,11 @@
 #define MAX_OUTSTANDING_COMMANDS	1024
 
 /* ISP request and response entry counts (37-65535) */
-#define REQUEST_ENTRY_CNT		2048	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_2100		128	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
-/* Calculations for SG segments */
-#define SEGS_PER_REQUEST_32	3 
-#define SEGS_PER_CONT_32	7
-#define SG_SEGMENTS_32 (SEGS_PER_REQUEST_32 + \
-    (SEGS_PER_CONT_32 * (REQUEST_ENTRY_CNT - 2)))     
-#define SEGS_PER_REQUEST_64	2 
-#define SEGS_PER_CONT_64	5
-#define SG_SEGMENTS_64 (SEGS_PER_REQUEST_64 + \
-    (SEGS_PER_CONT_64 * (REQUEST_ENTRY_CNT - 2)))     
-
 /*
  * SCSI Request Block 
  */
@@ -2123,6 +2114,7 @@
 	request_t       *request_ring_ptr;  /* Current address. */
 	uint16_t        req_ring_index;     /* Current index. */
 	uint16_t        req_q_cnt;          /* Number of available entries. */
+	uint16_t	request_q_length;
 
 	dma_addr_t	response_dma;       /* Physical address. */
 	response_t      *response_ring;     /* Base virtual address */
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:28 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:28 2004
@@ -600,10 +600,11 @@
 	ha->product_id[3] = mb[4];
 
 	/* Adjust fw RISC transfer size */
-	if (REQUEST_ENTRY_CNT > 1024)
+	if (ha->request_q_length > 1024)
 		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
 	else
-		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * REQUEST_ENTRY_CNT;
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE *
+		    ha->request_q_length;
 
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
@@ -802,7 +803,7 @@
 	/* Initialize firmware. */
 	ha->request_ring_ptr  = ha->request_ring;
 	ha->req_ring_index    = 0;
-	ha->req_q_cnt         = REQUEST_ENTRY_CNT;
+	ha->req_q_cnt         = ha->request_q_length;
 	ha->response_ring_ptr = ha->response_ring;
 	ha->rsp_ring_index    = 0;
 
@@ -1378,7 +1379,7 @@
 	 */
 	icb->request_q_outpointer = __constant_cpu_to_le16(0);
 	icb->response_q_inpointer = __constant_cpu_to_le16(0);
-	icb->request_q_length = __constant_cpu_to_le16(REQUEST_ENTRY_CNT);
+	icb->request_q_length = cpu_to_le16(ha->request_q_length);
 	icb->response_q_length = cpu_to_le16(ha->response_q_length);
 	icb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
 	icb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	Mon May  3 15:13:28 2004
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	Mon May  3 15:13:28 2004
@@ -124,7 +124,7 @@
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
-	if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+	if (ha->req_ring_index == ha->request_q_length) {
 		ha->req_ring_index = 0;
 		ha->request_ring_ptr = ha->request_ring;
 	} else {
@@ -153,7 +153,7 @@
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
-	if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+	if (ha->req_ring_index == ha->request_q_length) {
 		ha->req_ring_index = 0;
 		ha->request_ring_ptr = ha->request_ring;
 	} else {
@@ -394,7 +394,7 @@
 		if (ha->req_ring_index < cnt)
 			ha->req_q_cnt = cnt - ha->req_ring_index;
 		else
-			ha->req_q_cnt = REQUEST_ENTRY_CNT -
+			ha->req_q_cnt = ha->request_q_length -
 			    (ha->req_ring_index - cnt);
 	}
 
@@ -484,7 +484,7 @@
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
-	if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+	if (ha->req_ring_index == ha->request_q_length) {
 		ha->req_ring_index = 0;
 		ha->request_ring_ptr = ha->request_ring;
 	} else
@@ -588,7 +588,7 @@
 			if  (ha->req_ring_index < cnt)
 				ha->req_q_cnt = cnt - ha->req_ring_index;
 			else
-				ha->req_q_cnt = REQUEST_ENTRY_CNT -
+				ha->req_q_cnt = ha->request_q_length -
 				    (ha->req_ring_index - cnt);
 		}
 		/* If room for request in request ring. */
@@ -658,7 +658,7 @@
 			if (ha->req_ring_index < cnt) {
 				ha->req_q_cnt = cnt - ha->req_ring_index;
 			} else {
-				ha->req_q_cnt = REQUEST_ENTRY_CNT -
+				ha->req_q_cnt = ha->request_q_length -
 				    (ha->req_ring_index - cnt);
 			}
 		}
@@ -740,7 +740,7 @@
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
-	if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+	if (ha->req_ring_index == ha->request_q_length) {
 		ha->req_ring_index = 0;
 		ha->request_ring_ptr = ha->request_ring;
 	} else
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:13:28 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:13:28 2004
@@ -168,7 +168,6 @@
 	.slave_configure	= qla2xxx_slave_configure,
 
 	.this_id		= -1,
-	.can_queue		= REQUEST_ENTRY_CNT+128,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= SG_ALL,
@@ -1983,19 +1982,24 @@
 	if (IS_QLA2100(ha)) {
 		ha->max_targets = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
+		ha->request_q_length = REQUEST_ENTRY_CNT_2100;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
+		host->sg_tablesize = 32;
 	} else if (IS_QLA2200(ha)) {
 		ha->max_targets = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 	} else /*if (IS_QLA2300(ha))*/ {
 		ha->max_targets = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
 	}
+	host->can_queue = ha->request_q_length + 128;
 
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
@@ -2390,8 +2394,8 @@
 		(unsigned long long)ha->response_dma);
 
 	copy_info(&info,
-	    "Request Queue count = %ld, Response Queue count = %ld\n",
-	    (long)REQUEST_ENTRY_CNT, (long)ha->response_q_length);
+	    "Request Queue count = %d, Response Queue count = %d\n",
+	    ha->request_q_length, ha->response_q_length);
 
 	copy_info(&info,
 	    "Total number of active commands = %ld\n",
@@ -2861,7 +2865,7 @@
 		 * little delay and a retry.
 		 */
 		ha->request_ring = pci_alloc_consistent(ha->pdev,
-		    ((REQUEST_ENTRY_CNT + 1) * (sizeof(request_t))),
+		    ((ha->request_q_length + 1) * (sizeof(request_t))),
 		    &ha->request_dma);
 		if (ha->request_ring == NULL) {
 			qla_printk(KERN_WARNING, ha,
@@ -3077,7 +3081,7 @@
 
 	if (ha->request_ring) {
 		pci_free_consistent(ha->pdev,
-		    ((REQUEST_ENTRY_CNT + 1) * (sizeof(request_t))),
+		    ((ha->request_q_length + 1) * (sizeof(request_t))),
 		    ha->request_ring, ha->request_dma);
 	}
 
diff -Nru a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c	Mon May  3 15:13:28 2004
+++ b/drivers/scsi/qla2xxx/qla_rscn.c	Mon May  3 15:13:28 2004
@@ -385,7 +385,7 @@
 		if  (ha->req_ring_index < cnt)
 			ha->req_q_cnt = cnt - ha->req_ring_index;
 		else
-			ha->req_q_cnt = REQUEST_ENTRY_CNT -
+			ha->req_q_cnt = ha->request_q_length -
 			    (ha->req_ring_index - cnt);
 	}
 	if (ha->req_q_cnt >= 3) {
