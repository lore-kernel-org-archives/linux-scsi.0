From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v2 10/14] BNX2I: Added return code check for chip kwqe
 submission request
Date: Thu, 18 Nov 2010 17:30:05 -0800
Message-ID: <1290130209-32133-11-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4968 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab0KSBzx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 20:55:53 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Added the handling for cases when a chip request is made to the
CNIC module but the hardware is not ready to accept.  This would
lead to many unnecessary wait timeouts.
This code adds check in the connect establishment and destruction
path.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    9 +++---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   54 ++++++++++++++++++++++++++++----------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   17 ++++++++++-
 3 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 2c34e22..866a22c 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -649,6 +649,7 @@ enum {
 	EP_STATE_OFLD_FAILED            = 0x8000000,
 	EP_STATE_CONNECT_FAILED         = 0x10000000,
 	EP_STATE_DISCONN_TIMEDOUT       = 0x20000000,
+	EP_STATE_OFLD_FAILED_CID_BUSY   = 0x80000000,
 };
 
 /**
@@ -758,11 +759,11 @@ extern int bnx2i_send_iscsi_logout(struct bnx2i_conn *conn,
 				   struct iscsi_task *mtask);
 extern void bnx2i_send_cmd_cleanup_req(struct bnx2i_hba *hba,
 				       struct bnx2i_cmd *cmd);
-extern void bnx2i_send_conn_ofld_req(struct bnx2i_hba *hba,
-				     struct bnx2i_endpoint *ep);
-extern void bnx2i_update_iscsi_conn(struct iscsi_conn *conn);
-extern void bnx2i_send_conn_destroy(struct bnx2i_hba *hba,
+extern int bnx2i_send_conn_ofld_req(struct bnx2i_hba *hba,
 				    struct bnx2i_endpoint *ep);
+extern void bnx2i_update_iscsi_conn(struct iscsi_conn *conn);
+extern int bnx2i_send_conn_destroy(struct bnx2i_hba *hba,
+				   struct bnx2i_endpoint *ep);
 
 extern int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba,
 			       struct bnx2i_endpoint *ep);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 859882c..b3c264d 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -701,10 +701,11 @@ void bnx2i_send_cmd_cleanup_req(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
  * this routine prepares and posts CONN_OFLD_REQ1/2 KWQE to initiate
  * 	iscsi connection context clean-up process
  */
-void bnx2i_send_conn_destroy(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
+int bnx2i_send_conn_destroy(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 {
 	struct kwqe *kwqe_arr[2];
 	struct iscsi_kwqe_conn_destroy conn_cleanup;
+	int rc = -EINVAL;
 
 	memset(&conn_cleanup, 0x00, sizeof(struct iscsi_kwqe_conn_destroy));
 
@@ -721,7 +722,9 @@ void bnx2i_send_conn_destroy(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 
 	kwqe_arr[0] = (struct kwqe *) &conn_cleanup;
 	if (hba->cnic && hba->cnic->submit_kwqes)
-		hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, 1);
+		rc = hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, 1);
+
+	return rc;
 }
 
 
@@ -732,8 +735,8 @@ void bnx2i_send_conn_destroy(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
  *
  * 5706/5708/5709 specific - prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
-static void bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
-					  struct bnx2i_endpoint *ep)
+static int bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
+					 struct bnx2i_endpoint *ep)
 {
 	struct kwqe *kwqe_arr[2];
 	struct iscsi_kwqe_conn_offload1 ofld_req1;
@@ -741,6 +744,7 @@ static void bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
 	dma_addr_t dma_addr;
 	int num_kwqes = 2;
 	u32 *ptbl;
+	int rc = -EINVAL;
 
 	ofld_req1.hdr.op_code = ISCSI_KWQE_OPCODE_OFFLOAD_CONN1;
 	ofld_req1.hdr.flags =
@@ -778,7 +782,9 @@ static void bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
 	ofld_req2.num_additional_wqes = 0;
 
 	if (hba->cnic && hba->cnic->submit_kwqes)
-		hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, num_kwqes);
+		rc = hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, num_kwqes);
+
+	return rc;
 }
 
 
@@ -789,8 +795,8 @@ static void bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
  *
  * 57710 specific - prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
-static void bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
-					   struct bnx2i_endpoint *ep)
+static int bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
+					  struct bnx2i_endpoint *ep)
 {
 	struct kwqe *kwqe_arr[5];
 	struct iscsi_kwqe_conn_offload1 ofld_req1;
@@ -799,6 +805,7 @@ static void bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
 	dma_addr_t dma_addr;
 	int num_kwqes = 2;
 	u32 *ptbl;
+	int rc = -EINVAL;
 
 	ofld_req1.hdr.op_code = ISCSI_KWQE_OPCODE_OFFLOAD_CONN1;
 	ofld_req1.hdr.flags =
@@ -844,7 +851,9 @@ static void bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
 	num_kwqes += 1;
 
 	if (hba->cnic && hba->cnic->submit_kwqes)
-		hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, num_kwqes);
+		rc = hba->cnic->submit_kwqes(hba->cnic, kwqe_arr, num_kwqes);
+
+	return rc;
 }
 
 /**
@@ -855,12 +864,16 @@ static void bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
  *
  * this routine prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
-void bnx2i_send_conn_ofld_req(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
+int bnx2i_send_conn_ofld_req(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 {
+	int rc;
+
 	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
-		bnx2i_5771x_send_conn_ofld_req(hba, ep);
+		rc = bnx2i_5771x_send_conn_ofld_req(hba, ep);
 	else
-		bnx2i_570x_send_conn_ofld_req(hba, ep);
+		rc = bnx2i_570x_send_conn_ofld_req(hba, ep);
+
+	return rc;
 }
 
 
@@ -2165,11 +2178,24 @@ static void bnx2i_process_ofld_cmpl(struct bnx2i_hba *hba,
 	}
 
 	if (ofld_kcqe->completion_status) {
+		ep->state = EP_STATE_OFLD_FAILED;
 		if (ofld_kcqe->completion_status ==
 		    ISCSI_KCQE_COMPLETION_STATUS_CTX_ALLOC_FAILURE)
-			printk(KERN_ALERT "bnx2i: unable to allocate"
-					  " iSCSI context resources\n");
-		ep->state = EP_STATE_OFLD_FAILED;
+			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - unable "
+				"to allocate iSCSI context resources\n",
+				hba->netdev->name);
+		else if (ofld_kcqe->completion_status ==
+			 ISCSI_KCQE_COMPLETION_STATUS_INVALID_OPCODE)
+			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - invalid "
+				"opcode\n", hba->netdev->name);
+		else if (ofld_kcqe->completion_status ==
+			ISCSI_KCQE_COMPLETION_STATUS_CID_BUSY)
+			/* error status code valid only for 5771x chipset */
+			ep->state = EP_STATE_OFLD_FAILED_CID_BUSY;
+		else
+			printk(KERN_ALERT "bnx2i (%s): ofld1 cmpl - invalid "
+				"error code %d\n", hba->netdev->name,
+				ofld_kcqe->completion_status);
 	} else {
 		ep->state = EP_STATE_OFLD_COMPL;
 		cid_addr = ofld_kcqe->iscsi_conn_context_id;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index ac60c4c..f622e89 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1682,7 +1682,9 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 	bnx2i_ep_destroy_list_add(hba, ep);
 
 	/* destroy iSCSI context, wait for it to complete */
-	bnx2i_send_conn_destroy(hba, ep);
+	if (bnx2i_send_conn_destroy(hba, ep))
+		ep->state = EP_STATE_CLEANUP_CMPL;
+
 	wait_event_interruptible(ep->ofld_wait,
 				 (ep->state != EP_STATE_CLEANUP_START));
 
@@ -1781,7 +1783,18 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
 
-	bnx2i_send_conn_ofld_req(hba, bnx2i_ep);
+	if (bnx2i_send_conn_ofld_req(hba, bnx2i_ep)) {
+		if (bnx2i_ep->state == EP_STATE_OFLD_FAILED_CID_BUSY) {
+			printk(KERN_ALERT "bnx2i (%s): iscsi cid %d is busy\n",
+				hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
+			rc = -EBUSY;
+		} else
+			rc = -ENOSPC;
+		printk(KERN_ALERT "bnx2i (%s): unable to send conn offld kwqe"
+			"\n", hba->netdev->name);
+		bnx2i_ep_ofld_list_del(hba, bnx2i_ep);
+		goto conn_failed;
+	}
 
 	/* Wait for CNIC hardware to setup conn context and return 'cid' */
 	wait_event_interruptible(bnx2i_ep->ofld_wait,
-- 
1.7.0.5


