From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/7] BNX2I: Created an active linklist which holds bnx2i
 endpoints
Date: Fri, 25 Jun 2010 18:39:27 -0700
Message-ID: <1277516372-469-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4281 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab0FZBip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 21:38:45 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This introduces a new active linklist which would link up all active
bnx2i_endpoints.  This will be used by subsequent patches that
follows.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    4 +++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   43 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 6b624e7..c17c3a3 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -299,6 +299,7 @@ struct iscsi_cid_queue {
  * @cid_que:               iscsi cid queue
  * @ep_rdwr_lock:          read / write lock to synchronize various ep lists
  * @ep_ofld_list:          connection list for pending offload completion
+ * @ep_active_list:        connection list for active offload endpoints
  * @ep_destroy_list:       connection list for pending offload completion
  * @mp_bd_tbl:             BD table to be used with middle path requests
  * @mp_bd_dma:             DMA address of 'mp_bd_tbl' memory buffer
@@ -369,6 +370,7 @@ struct bnx2i_hba {
 
 	rwlock_t ep_rdwr_lock;
 	struct list_head ep_ofld_list;
+	struct list_head ep_active_list;
 	struct list_head ep_destroy_list;
 
 	/*
@@ -645,6 +647,7 @@ enum {
  * @link:               list head to link elements
  * @hba:                adapter to which this connection belongs
  * @conn:               iscsi connection this EP is linked to
+ * @cls_ep:             associated iSCSI endpoint pointer
  * @sess:               iscsi session this EP is linked to
  * @cm_sk:              cnic sock struct
  * @hba_age:            age to detect if 'iscsid' issues ep_disconnect()
@@ -664,6 +667,7 @@ struct bnx2i_endpoint {
 	struct list_head link;
 	struct bnx2i_hba *hba;
 	struct bnx2i_conn *conn;
+	struct iscsi_endpoint *cls_ep;
 	struct cnic_sock *cm_sk;
 	u32 hba_age;
 	u32 state;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 3276555..2179296 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -386,6 +386,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
 	}
 
 	bnx2i_ep = ep->dd_data;
+	bnx2i_ep->cls_ep = ep;
 	INIT_LIST_HEAD(&bnx2i_ep->link);
 	bnx2i_ep->state = EP_STATE_IDLE;
 	bnx2i_ep->ep_iscsi_cid = (u16) -1;
@@ -678,7 +679,6 @@ bnx2i_find_ep_in_ofld_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 	return ep;
 }
 
-
 /**
  * bnx2i_find_ep_in_destroy_list - find iscsi_cid in destroy list
  * @hba: 		pointer to adapter instance
@@ -708,6 +708,41 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 	return ep;
 }
 
+
+/**
+ * bnx2i_ep_active_list_add - add an entry to ep active list
+ * @hba:	pointer to adapter instance
+ * @ep:		pointer to endpoint (transport indentifier) structure
+ *
+ * current active conn queue manager
+ */
+static int bnx2i_ep_active_list_add(struct bnx2i_hba *hba,
+				    struct bnx2i_endpoint *ep)
+{
+	write_lock_bh(&hba->ep_rdwr_lock);
+	list_add_tail(&ep->link, &hba->ep_active_list);
+	write_unlock_bh(&hba->ep_rdwr_lock);
+	return 0;
+}
+
+
+/**
+ * bnx2i_ep_active_list_del - deletes an entry to ep active list
+ * @hba:	pointer to adapter instance
+ * @ep:		pointer to endpoint (transport indentifier) structure
+ *
+ * current active conn queue manager
+ */
+static int bnx2i_ep_active_list_del(struct bnx2i_hba *hba,
+				    struct bnx2i_endpoint *ep)
+{
+	write_lock_bh(&hba->ep_rdwr_lock);
+	list_del_init(&ep->link);
+	write_unlock_bh(&hba->ep_rdwr_lock);
+	return 0;
+}
+
+
 /**
  * bnx2i_setup_host_queue_size - assigns shost->can_queue param
  * @hba:	pointer to adapter instance
@@ -784,6 +819,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		goto mp_bdt_mem_err;
 
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
+	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
 	rwlock_init(&hba->ep_rdwr_lock);
 
@@ -857,6 +893,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 
 	iscsi_host_remove(shost);
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
+	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
 	pci_dev_put(hba->pcidev);
 
@@ -1755,6 +1792,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	} else
 		rc = cnic->cm_connect(bnx2i_ep->cm_sk, &saddr);
 
+	bnx2i_ep_active_list_add(hba, bnx2i_ep);
+
 	if (rc)
 		goto release_ep;
 
@@ -1764,6 +1803,7 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	return ep;
 
 release_ep:
+	bnx2i_ep_active_list_del(hba, bnx2i_ep);
 	if (bnx2i_tear_down_conn(hba, bnx2i_ep)) {
 		mutex_unlock(&hba->net_dev_lock);
 		return ERR_PTR(rc);
@@ -1931,6 +1971,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	del_timer_sync(&bnx2i_ep->ofld_timer);
 
 destroy_conn:
+	bnx2i_ep_active_list_del(hba, bnx2i_ep);
 	if (bnx2i_tear_down_conn(hba, bnx2i_ep))
 		ret = -EINVAL;
 out:
-- 
1.7.0.5


