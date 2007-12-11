From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 11/30] blk_end_request: changing sx8 (take 4)
Date: Tue, 11 Dec 2007 17:46:10 -0500 (EST)
Message-ID: <20071211.174610.120442778.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

This patch converts sx8 to use blk_end_request interfaces.
Related 'uptodate' and 'is_ok' arguments are converted to 'error'.

As a result, the interfaces of internal functions below are changed.
  o carm_end_request_queued
  o carm_end_rq
  o carm_handle_array_info
  o carm_handle_scan_chan
  o carm_handle_generic
  o carm_handle_rw

The 'is_ok' is set at only one place in carm_handle_resp() below:

	int is_ok = (status == RMSG_OK);

And the value is propagated to all functions above, and no modification
in other places.
So the actual conversion of the 'is_ok' is done at only one place above.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sx8.c |   58 +++++++++++++++++++++++++---------------------------
 1 files changed, 28 insertions(+), 30 deletions(-)

Index: 2.6.24-rc4/drivers/block/sx8.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/sx8.c
+++ 2.6.24-rc4/drivers/block/sx8.c
@@ -744,16 +744,14 @@ static unsigned int carm_fill_get_fw_ver
 
 static inline void carm_end_request_queued(struct carm_host *host,
 					   struct carm_request *crq,
-					   int uptodate)
+					   int error)
 {
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = end_that_request_first(req, uptodate, req->hard_nr_sectors);
+	rc = __blk_end_request(req, error, blk_rq_bytes(req));
 	assert(rc == 0);
 
-	end_that_request_last(req, uptodate);
-
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
 }
@@ -793,9 +791,9 @@ static inline void carm_round_robin(stru
 }
 
 static inline void carm_end_rq(struct carm_host *host, struct carm_request *crq,
-			int is_ok)
+			       int error)
 {
-	carm_end_request_queued(host, crq, is_ok);
+	carm_end_request_queued(host, crq, error);
 	if (max_queue == 1)
 		carm_round_robin(host);
 	else if ((host->n_msgs <= CARM_MSG_LOW_WATER) &&
@@ -873,14 +871,14 @@ queue_one_request:
 	sg = &crq->sg[0];
 	n_elem = blk_rq_map_sg(q, rq, sg);
 	if (n_elem <= 0) {
-		carm_end_rq(host, crq, 0);
+		carm_end_rq(host, crq, -EIO);
 		return;		/* request with no s/g entries? */
 	}
 
 	/* map scatterlist to PCI bus addresses */
 	n_elem = pci_map_sg(host->pdev, sg, n_elem, pci_dir);
 	if (n_elem <= 0) {
-		carm_end_rq(host, crq, 0);
+		carm_end_rq(host, crq, -EIO);
 		return;		/* request with no s/g entries? */
 	}
 	crq->n_elem = n_elem;
@@ -941,7 +939,7 @@ queue_one_request:
 
 static void carm_handle_array_info(struct carm_host *host,
 				   struct carm_request *crq, u8 *mem,
-				   int is_ok)
+				   int error)
 {
 	struct carm_port *port;
 	u8 *msg_data = mem + sizeof(struct carm_array_info);
@@ -952,9 +950,9 @@ static void carm_handle_array_info(struc
 
 	DPRINTK("ENTER\n");
 
-	carm_end_rq(host, crq, is_ok);
+	carm_end_rq(host, crq, error);
 
-	if (!is_ok)
+	if (error)
 		goto out;
 	if (le32_to_cpu(desc->array_status) & ARRAY_NO_EXIST)
 		goto out;
@@ -1001,7 +999,7 @@ out:
 
 static void carm_handle_scan_chan(struct carm_host *host,
 				  struct carm_request *crq, u8 *mem,
-				  int is_ok)
+				  int error)
 {
 	u8 *msg_data = mem + IOC_SCAN_CHAN_OFFSET;
 	unsigned int i, dev_count = 0;
@@ -1009,9 +1007,9 @@ static void carm_handle_scan_chan(struct
 
 	DPRINTK("ENTER\n");
 
-	carm_end_rq(host, crq, is_ok);
+	carm_end_rq(host, crq, error);
 
-	if (!is_ok) {
+	if (error) {
 		new_state = HST_ERROR;
 		goto out;
 	}
@@ -1033,23 +1031,23 @@ out:
 }
 
 static void carm_handle_generic(struct carm_host *host,
-				struct carm_request *crq, int is_ok,
+				struct carm_request *crq, int error,
 				int cur_state, int next_state)
 {
 	DPRINTK("ENTER\n");
 
-	carm_end_rq(host, crq, is_ok);
+	carm_end_rq(host, crq, error);
 
 	assert(host->state == cur_state);
-	if (is_ok)
-		host->state = next_state;
-	else
+	if (error)
 		host->state = HST_ERROR;
+	else
+		host->state = next_state;
 	schedule_work(&host->fsm_task);
 }
 
 static inline void carm_handle_rw(struct carm_host *host,
-				  struct carm_request *crq, int is_ok)
+				  struct carm_request *crq, int error)
 {
 	int pci_dir;
 
@@ -1062,7 +1060,7 @@ static inline void carm_handle_rw(struct
 
 	pci_unmap_sg(host->pdev, &crq->sg[0], crq->n_elem, pci_dir);
 
-	carm_end_rq(host, crq, is_ok);
+	carm_end_rq(host, crq, error);
 }
 
 static inline void carm_handle_resp(struct carm_host *host,
@@ -1071,7 +1069,7 @@ static inline void carm_handle_resp(stru
 	u32 handle = le32_to_cpu(ret_handle_le);
 	unsigned int msg_idx;
 	struct carm_request *crq;
-	int is_ok = (status == RMSG_OK);
+	int error = (status == RMSG_OK) ? 0 : -EIO;
 	u8 *mem;
 
 	VPRINTK("ENTER, handle == 0x%x\n", handle);
@@ -1090,7 +1088,7 @@ static inline void carm_handle_resp(stru
 	/* fast path */
 	if (likely(crq->msg_type == CARM_MSG_READ ||
 		   crq->msg_type == CARM_MSG_WRITE)) {
-		carm_handle_rw(host, crq, is_ok);
+		carm_handle_rw(host, crq, error);
 		return;
 	}
 
@@ -1100,7 +1098,7 @@ static inline void carm_handle_resp(stru
 	case CARM_MSG_IOCTL: {
 		switch (crq->msg_subtype) {
 		case CARM_IOC_SCAN_CHAN:
-			carm_handle_scan_chan(host, crq, mem, is_ok);
+			carm_handle_scan_chan(host, crq, mem, error);
 			break;
 		default:
 			/* unknown / invalid response */
@@ -1112,21 +1110,21 @@ static inline void carm_handle_resp(stru
 	case CARM_MSG_MISC: {
 		switch (crq->msg_subtype) {
 		case MISC_ALLOC_MEM:
-			carm_handle_generic(host, crq, is_ok,
+			carm_handle_generic(host, crq, error,
 					    HST_ALLOC_BUF, HST_SYNC_TIME);
 			break;
 		case MISC_SET_TIME:
-			carm_handle_generic(host, crq, is_ok,
+			carm_handle_generic(host, crq, error,
 					    HST_SYNC_TIME, HST_GET_FW_VER);
 			break;
 		case MISC_GET_FW_VER: {
 			struct carm_fw_ver *ver = (struct carm_fw_ver *)
 				mem + sizeof(struct carm_msg_get_fw_ver);
-			if (is_ok) {
+			if (!error) {
 				host->fw_ver = le32_to_cpu(ver->version);
 				host->flags |= (ver->features & FL_FW_VER_MASK);
 			}
-			carm_handle_generic(host, crq, is_ok,
+			carm_handle_generic(host, crq, error,
 					    HST_GET_FW_VER, HST_PORT_SCAN);
 			break;
 		}
@@ -1140,7 +1138,7 @@ static inline void carm_handle_resp(stru
 	case CARM_MSG_ARRAY: {
 		switch (crq->msg_subtype) {
 		case CARM_ARRAY_INFO:
-			carm_handle_array_info(host, crq, mem, is_ok);
+			carm_handle_array_info(host, crq, mem, error);
 			break;
 		default:
 			/* unknown / invalid response */
@@ -1159,7 +1157,7 @@ static inline void carm_handle_resp(stru
 err_out:
 	printk(KERN_WARNING DRV_NAME "(%s): BUG: unhandled message type %d/%d\n",
 	       pci_name(host->pdev), crq->msg_type, crq->msg_subtype);
-	carm_end_rq(host, crq, 0);
+	carm_end_rq(host, crq, -EIO);
 }
 
 static inline void carm_handle_responses(struct carm_host *host)
