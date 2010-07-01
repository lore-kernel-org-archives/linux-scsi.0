From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/7 v2] BNX2I: Created an active linklist which holds
 bnx2i endpoints
Date: Thu, 1 Jul 2010 15:34:51 -0700
Message-ID: <1278023696-17817-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhDUr7ThBBoE0TZoYQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This introduces a new active linklist which would link up all active
bnx2i_endpoints.  This will be used by subsequent patches that
follows.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i.h       |    4 +++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   46 +++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

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
index 6edfde5..fb5fe88 100644
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
@@ -708,6 +708,39 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba, u32 iscsi_cid)
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
+static void bnx2i_ep_active_list_add(struct bnx2i_hba *hba,
+				     struct bnx2i_endpoint *ep)
+{
+	write_lock_bh(&hba->ep_rdwr_lock);
+	list_add_tail(&ep->link, &hba->ep_active_list);
+	write_unlock_bh(&hba->ep_rdwr_lock);
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
+static void bnx2i_ep_active_list_del(struct bnx2i_hba *hba,
+				     struct bnx2i_endpoint *ep)
+{
+	write_lock_bh(&hba->ep_rdwr_lock);
+	list_del_init(&ep->link);
+	write_unlock_bh(&hba->ep_rdwr_lock);
+}
+
+
 /**
  * bnx2i_setup_host_queue_size - assigns shost->can_queue param
  * @hba:	pointer to adapter instance
@@ -784,6 +817,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		goto mp_bdt_mem_err;
 
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
+	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
 	rwlock_init(&hba->ep_rdwr_lock);
 
@@ -857,6 +891,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 
 	iscsi_host_remove(shost);
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
+	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
 	pci_dev_put(hba->pcidev);
 
@@ -1754,15 +1789,19 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		goto conn_failed;
 	} else
 		rc = cnic->cm_connect(bnx2i_ep->cm_sk, &saddr);
-
 	if (rc)
 		goto release_ep;
 
+	bnx2i_ep_active_list_add(hba, bnx2i_ep);
+
 	if (bnx2i_map_ep_dbell_regs(bnx2i_ep))
-		goto release_ep;
+		goto del_active_ep;
+
 	mutex_unlock(&hba->net_dev_lock);
 	return ep;
 
+del_active_ep:
+	bnx2i_ep_active_list_del(hba, bnx2i_ep);
 release_ep:
 	if (bnx2i_tear_down_conn(hba, bnx2i_ep)) {
 		mutex_unlock(&hba->net_dev_lock);
@@ -1931,6 +1970,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	del_timer_sync(&bnx2i_ep->ofld_timer);
 
 destroy_conn:
+	bnx2i_ep_active_list_del(hba, bnx2i_ep);
 	if (bnx2i_tear_down_conn(hba, bnx2i_ep))
 		ret = -EINVAL;
 out:
-- 
1.7.0.5


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
