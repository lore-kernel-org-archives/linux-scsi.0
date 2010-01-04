From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 02/12] be2iscsi: Move freeing of resources to stop_conn
Date: Tue, 5 Jan 2010 05:05:34 +0530
Message-ID: <20100104233523.GA16729@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14302 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753978Ab0ADXfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:35:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	We need to hold on to ep resources untill invalidate and
  close connection are completed

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   23 ++++++++++-------------
 drivers/scsi/be2iscsi/be_main.c  |   31 ++++++++++---------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |    1 +
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2b3c58b..f229184 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -460,14 +460,12 @@ static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
  * beiscsi_free_ep - free endpoint
  * @ep:	pointer to iscsi endpoint structure
  */
-static void beiscsi_free_ep(struct iscsi_endpoint *ep)
+static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 {
-	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
 
 	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 	beiscsi_ep->phba = NULL;
-	iscsi_destroy_endpoint(ep);
 }
 
 /**
@@ -498,7 +496,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	if (phba->state) {
 		ret = -EBUSY;
-		SE_DEBUG(DBG_LVL_1, "The Adapet state is Not UP \n");
+		SE_DEBUG(DBG_LVL_1, "The Adapter state is Not UP \n");
 		return ERR_PTR(ret);
 	}
 
@@ -510,9 +508,10 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->phba = phba;
+	beiscsi_ep->openiscsi_ep = ep;
 
 	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
-		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
+		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn \n");
 		ret = -ENOMEM;
 		goto free_ep;
 	}
@@ -520,7 +519,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	return ep;
 
 free_ep:
-	beiscsi_free_ep(ep);
+	beiscsi_free_ep(beiscsi_ep);
 	return ERR_PTR(ret);
 }
 
@@ -547,15 +546,14 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
  * @ep: The iscsi endpoint
  * @flag: The type of connection closure
  */
-static int beiscsi_close_conn(struct iscsi_endpoint *ep, int flag)
+static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 {
 	int ret = 0;
-	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
 
 	if (MGMT_STATUS_SUCCESS !=
 	    mgmt_upload_connection(phba, beiscsi_ep->ep_cid,
-		CONNECTION_UPLOAD_GRACEFUL)) {
+		flag)) {
 		SE_DEBUG(DBG_LVL_8, "upload failed for cid 0x%x",
 			 beiscsi_ep->ep_cid);
 		ret = -1;
@@ -575,19 +573,15 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct beiscsi_hba *phba;
-	int flag = 0;
 
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect\n");
 
 	if (beiscsi_ep->conn) {
 		beiscsi_conn = beiscsi_ep->conn;
 		iscsi_suspend_queue(beiscsi_conn->conn);
-		beiscsi_close_conn(ep, flag);
 	}
 
-	beiscsi_free_ep(ep);
 }
 
 /**
@@ -637,6 +631,9 @@ void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 			 "mgmt_invalidate_connection Failed for cid=%d \n",
 			 beiscsi_ep->ep_cid);
 	}
+	beiscsi_close_conn(beiscsi_ep, CONNECTION_UPLOAD_GRACEFUL);
+	beiscsi_free_ep(beiscsi_ep);
+	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
 	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
 	iscsi_conn_stop(cls_conn, flag);
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6c512b6..1390023 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1434,6 +1434,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	unsigned int tot_nump = 0;
 	struct beiscsi_conn *beiscsi_conn;
 	struct sgl_handle *psgl_handle = NULL;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_endpoint *ep;
 	struct beiscsi_hba *phba;
 
 	cq = pbe_eq->cq;
@@ -1449,28 +1451,15 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				      dw[offsetof(struct amap_sol_cqe_ring,
 				      icd_index) / 32] & SOL_ICD_INDEX_MASK)
 				      >> 6)];
-			beiscsi_conn = phba->conn_table[psgl_handle->cid];
-			if (!beiscsi_conn || !beiscsi_conn->ep) {
-				shost_printk(KERN_WARNING, phba->shost,
-				     "Connection table empty for cid = %d\n",
-				      psgl_handle->cid);
-				return 0;
-			}
-
+			ep = phba->ep_array[psgl_handle->cid];
 		} else {
-			beiscsi_conn = phba->conn_table[(u32) ((sol->
-				 dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-				 SOL_CID_MASK) >> 6) -
+			ep = phba->ep_array[(u32) ((sol->
+				   dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+				   SOL_CID_MASK) >> 6) -
 				   phba->fw_config.iscsi_cid_start];
-			if (!beiscsi_conn || !beiscsi_conn->ep) {
-				shost_printk(KERN_WARNING, phba->shost,
-				     "Connection table empty for cid = %d\n",
-				     (u32)(sol->dw[offsetof(struct amap_sol_cqe,
-				     cid) / 32] & SOL_CID_MASK) >> 6);
-				return 0;
-			}
 		}
-
+		beiscsi_ep = ep->dd_data;
+		beiscsi_conn = beiscsi_ep->conn;
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, cq->id,
 					num_processed, 0, 0);
@@ -3044,7 +3033,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 {
 	int i, new_cid;
 
-	phba->cid_array = kmalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
+	phba->cid_array = kzalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
 				  GFP_KERNEL);
 	if (!phba->cid_array) {
 		shost_printk(KERN_ERR, phba->shost,
@@ -3052,7 +3041,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 			     "hba_setup_cid_tbls\n");
 		return -ENOMEM;
 	}
-	phba->ep_array = kmalloc(sizeof(struct iscsi_endpoint *) *
+	phba->ep_array = kzalloc(sizeof(struct iscsi_endpoint *) *
 				 phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
 	if (!phba->ep_array) {
 		shost_printk(KERN_ERR, phba->shost,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 24eaff9..6bc59e8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -231,6 +231,7 @@ struct beiscsi_endpoint {
 	struct beiscsi_hba *phba;
 	struct beiscsi_sess *sess;
 	struct beiscsi_conn *conn;
+	struct iscsi_endpoint *openiscsi_ep;
 	unsigned short ip_type;
 	char dst6_addr[ISCSI_ADDRESS_BUF_LEN];
 	unsigned long dst_addr;
-- 
1.6.4

