Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADCB3546C6;
	Fri, 21 Aug 2026 07:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295643; cv=none; b=EWiXlRVEiELlPbgAC+GF8glkxG8eD1Bon3pIGMVJ/ei/UiPrfe0i/2KNlHaFsSwcdHNafd+mldaC/tyzkkE+HJH3jPQMWvhcFBXQjsCXeXTLScRvi8tSZwER8lAFpVihbuRW0QPyEKp+enJsKobEzqfaYjgivOGsvpDxoepvrjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295643; c=relaxed/simple;
	bh=7vRc4/5nWxZqmEu9spWr4L5DJwjIdM1ws5cnGp2tb4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h0IPPr8b2sIpuMaGFVy8xwkCpHOzN4CWJ1AXT8ZXPGaUTNywb98+DRoogrIO2DigAtjchKMWCP5GxpQDvKCTgVWQQjEB/JKUq+6ZYNKYPcjBWliwJnfb5z62uEdWnw7nJBh4LcoQ6bm3NO/hdck84LdQkYysUNbtXx8VdiEuQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=mqeh2tg1; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="mqeh2tg1"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4ad024b8f;
	Fri, 21 Aug 2026 15:00:28 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] scsi: qla2xxx: synchronize EDIF entry teardown with timer
Date: Fri, 21 Aug 2026 15:00:21 +0800
Message-Id: <20260821070021.92448-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
References: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0231efb7103a1kunm7fc24418191608
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSxofVh0YT0pKSkweTh9CHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=mqeh2tg1jCeSTQEOU9tCrnikE7fO0RYO9hKl6bPico0MrfvX9q4RyMsvn2FVQld399nukuc9gJqk+U3Hxyff8S7nGkTouioQ6pYD7eNg3r/G/HnDuE7UYH+V7IGKJYMpNRUI0uiKEZZRURGGwej8R3iYU6xmUGRR7+/5diC7iL8=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=D+WgD/XrnTuez4VDQa51p1aYlufs25+9mtb2URz+Kpo=;
	h=date:mime-version:subject:message-id:from;

The EDIF RX rekey path arms a delayed SA delete timer from
qla24xx_sadb_update().  When the firmware reports the corresponding
RX delete, qla28xx_sa_update_iocb_entry() tears down the entry from
the response path.  The timer callback may already be running on another
CPU and dereferences the entry and its fcport.

The response path runs in interrupt context and cannot call
timer_shutdown_sync() directly.  Keep the entry linked while deferred
teardown is pending, mark it as free-pending, and queue the freeing work
on the adapter workqueue.  The worker waits for the timer before it
removes and frees the entry, while fcport teardown cancels the work before
freeing the entry or the fcport.

Protect EDIF list lookup and entry updates with indx_list_lock as well.
The previous lookup walked the list without its lock and returned a raw
pointer that callers could use after another path had removed and freed
the entry.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260821002708.425265-1-runyu.xiao@seu.edu.cn
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/qla2xxx/qla_def.h  |   2 +
 drivers/scsi/qla2xxx/qla_edif.c | 206 ++++++++++++++++++++++----------
 2 files changed, 143 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5593ad7fad27..f1a43e03e67a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5367,9 +5367,11 @@ struct edif_list_entry {
 	uint32_t delete_sa_index;
 	uint32_t count;				/* counter for filtering sa_index */
 #define EDIF_ENTRY_FLAGS_CLEANUP	0x01	/* this index is being cleaned up */
+#define EDIF_ENTRY_FLAGS_FREE_PENDING	0x02	/* entry is queued for freeing */
 	uint32_t flags;				/* used by sadb cleanup code */
 	fc_port_t *fcport;			/* needed by rx delay timer function */
 	struct timer_list timer;		/* rx delay timer */
+	struct work_struct free_work;
 	struct list_head next;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index eccedb38a515..53760477ad3a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -11,6 +11,8 @@
 #include <linux/delay.h>
 #include <scsi/scsi_tcq.h>
 
+static void qla_edif_list_free_sa_index_work(struct work_struct *work);
+
 static struct edif_sa_index_entry *qla_edif_sadb_find_sa_index_entry(uint16_t nport_handle,
 		struct list_head *sa_list);
 static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
@@ -77,15 +79,16 @@ static void qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
 	kfree(node);
 }
 
-static struct edif_list_entry *qla_edif_list_find_sa_index(fc_port_t *fcport,
-		uint16_t handle)
+/* Caller must hold fcport->edif.indx_list_lock. */
+static struct edif_list_entry *
+qla_edif_list_find_sa_index_locked(fc_port_t *fcport, uint16_t handle)
 {
 	struct edif_list_entry *entry;
-	struct edif_list_entry *tentry;
 	struct list_head *indx_list = &fcport->edif.edif_indx_list;
 
-	list_for_each_entry_safe(entry, tentry, indx_list, next) {
-		if (entry->handle == handle)
+	list_for_each_entry(entry, indx_list, next) {
+		if (entry->handle == handle &&
+		    !(entry->flags & EDIF_ENTRY_FLAGS_FREE_PENDING))
 			return entry;
 	}
 	return NULL;
@@ -100,6 +103,8 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 	struct scsi_qla_host *vha = fcport->vha;
 	struct  edif_sa_ctl *sa_ctl;
 	uint16_t nport_handle;
+	u16 delete_sa_index;
+	u32 update_sa_index;
 	unsigned long flags = 0;
 
 	ql_dbg(ql_dbg_edif, vha, 0x3069,
@@ -120,7 +125,8 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 	 * we could get another rekey which will result in an error 66.
 	 */
 	if (edif_entry->delete_sa_index != INVALID_EDIF_SA_INDEX) {
-		uint16_t delete_sa_index = edif_entry->delete_sa_index;
+		delete_sa_index = edif_entry->delete_sa_index;
+		update_sa_index = edif_entry->update_sa_index;
 
 		edif_entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
 		nport_handle = edif_entry->handle;
@@ -132,7 +138,7 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 		if (sa_ctl) {
 			ql_dbg(ql_dbg_edif, vha, 0x3063,
 			    "%s: sa_ctl: %p, delete index %d, update index: %d, lid: 0x%x\n",
-			    __func__, sa_ctl, delete_sa_index, edif_entry->update_sa_index,
+			    __func__, sa_ctl, delete_sa_index, update_sa_index,
 			    nport_handle);
 
 			sa_ctl->flags = EDIF_SA_CTL_FLG_DEL;
@@ -143,7 +149,7 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 		} else {
 			ql_dbg(ql_dbg_edif, vha, 0x3063,
 			    "%s: sa_ctl not found for delete_sa_index: %d\n",
-			    __func__, edif_entry->delete_sa_index);
+			    __func__, delete_sa_index);
 		}
 	} else {
 		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
@@ -157,16 +163,19 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 static int qla_edif_list_add_sa_update_index(fc_port_t *fcport,
 		uint16_t sa_index, uint16_t handle)
 {
-	struct edif_list_entry *entry;
+	struct edif_list_entry *entry, *new_entry;
 	unsigned long flags = 0;
 
 	/* if the entry exists, then just update the sa_index */
-	entry = qla_edif_list_find_sa_index(fcport, handle);
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	entry = qla_edif_list_find_sa_index_locked(fcport, handle);
 	if (entry) {
 		entry->update_sa_index = sa_index;
 		entry->count = 0;
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 		return 0;
 	}
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 
 	/*
 	 * This is the normal path - there should be no existing entry
@@ -174,31 +183,86 @@ static int qla_edif_list_add_sa_update_index(fc_port_t *fcport,
 	 * when update is called for the first two sa_indexes
 	 * followed by a delete of the first sa_index
 	 */
-	entry = kzalloc_obj(struct edif_list_entry, GFP_ATOMIC);
-	if (!entry)
+	new_entry = kzalloc_obj(struct edif_list_entry, GFP_ATOMIC);
+	if (!new_entry)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&entry->next);
-	entry->handle = handle;
-	entry->update_sa_index = sa_index;
-	entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
-	entry->count = 0;
-	entry->flags = 0;
-	timer_setup(&entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
+	INIT_LIST_HEAD(&new_entry->next);
+	new_entry->handle = handle;
+	new_entry->update_sa_index = sa_index;
+	new_entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
+	new_entry->count = 0;
+	new_entry->flags = 0;
+	timer_setup(&new_entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
+	INIT_WORK(&new_entry->free_work, qla_edif_list_free_sa_index_work);
+
 	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
-	list_add_tail(&entry->next, &fcport->edif.edif_indx_list);
+	entry = qla_edif_list_find_sa_index_locked(fcport, handle);
+	if (entry) {
+		entry->update_sa_index = sa_index;
+		entry->count = 0;
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+		kfree(new_entry);
+		return 0;
+	}
+	list_add_tail(&new_entry->next, &fcport->edif.edif_indx_list);
 	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 	return 0;
 }
 
-/* remove an entry from the list */
-static void qla_edif_list_delete_sa_index(fc_port_t *fcport, struct edif_list_entry *entry)
+/* Caller must hold fcport->edif.indx_list_lock. */
+static void qla_edif_list_delete_sa_index_locked(struct edif_list_entry *entry)
+{
+	if (!list_empty(&entry->next))
+		list_del_init(&entry->next);
+}
+
+static void qla_edif_list_free_sa_index(struct edif_list_entry *entry)
 {
+	cancel_work_sync(&entry->free_work);
+	timer_shutdown_sync(&entry->timer);
+	kfree(entry);
+}
+
+static void qla_edif_list_free_sa_index_work(struct work_struct *work)
+{
+	struct edif_list_entry *entry = container_of(work,
+			struct edif_list_entry, free_work);
+	fc_port_t *fcport = entry->fcport;
 	unsigned long flags = 0;
+	bool free_entry = false;
+
+	timer_shutdown_sync(&entry->timer);
 
 	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
-	list_del(&entry->next);
+	if (!list_empty(&entry->next)) {
+		list_del_init(&entry->next);
+		free_entry = true;
+	}
 	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+	if (free_entry)
+		kfree(entry);
+}
+
+static bool
+qla_edif_list_schedule_free_sa_index(fc_port_t *fcport, uint16_t handle)
+{
+	struct edif_list_entry *entry;
+	bool queued = false;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	entry = qla_edif_list_find_sa_index_locked(fcport, handle);
+	if (entry &&
+	    !(entry->flags & EDIF_ENTRY_FLAGS_FREE_PENDING)) {
+		entry->flags |= EDIF_ENTRY_FLAGS_FREE_PENDING;
+		timer_shutdown(&entry->timer);
+		queued = queue_work(fcport->vha->hw->wq, &entry->free_work);
+	}
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+	return queued;
 }
 
 int qla_post_sa_replace_work(struct scsi_qla_host *vha,
@@ -403,22 +467,29 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 
 		/* Delete timer on RX */
 		if (pdir != SAU_FLG_TX) {
-			edif_entry =
-				qla_edif_list_find_sa_index(fcport, entry->handle);
+			u32 delete_sa_index;
+			u32 update_sa_index;
+			unsigned long flags = 0;
+
+			spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+			edif_entry = qla_edif_list_find_sa_index_locked(fcport, entry->handle);
+			if (edif_entry) {
+				delete_sa_index = edif_entry->delete_sa_index;
+				update_sa_index = edif_entry->update_sa_index;
+				qla_edif_list_delete_sa_index_locked(edif_entry);
+			}
+			spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
 			if (edif_entry) {
 				ql_dbg(ql_dbg_edif, vha, 0x5033,
 				    "%s: remove edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
-				    __func__, edif_entry, edif_entry->update_sa_index,
-				    edif_entry->delete_sa_index);
-				qla_edif_list_delete_sa_index(fcport, edif_entry);
+				    __func__, edif_entry, update_sa_index,
+				    delete_sa_index);
 				/*
 				 * valid delete_sa_index indicates there is a rx
 				 * delayed delete queued
 				 */
-				if (edif_entry->delete_sa_index !=
-						INVALID_EDIF_SA_INDEX) {
-					timer_shutdown(&edif_entry->timer);
-
+				if (delete_sa_index != INVALID_EDIF_SA_INDEX) {
 					/* build and send the aen */
 					fcport->edif.rx_sa_set = 1;
 					fcport->edif.rx_sa_pending = 0;
@@ -429,10 +500,10 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				}
 				ql_dbg(ql_dbg_edif, vha, 0x5033,
 				    "%s: release edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
-				    __func__, edif_entry, edif_entry->update_sa_index,
-				    edif_entry->delete_sa_index);
+				    __func__, edif_entry, update_sa_index,
+				    delete_sa_index);
 
-				kfree(edif_entry);
+				qla_edif_list_free_sa_index(edif_entry);
 			}
 		}
 		key_cnt++;
@@ -1642,6 +1713,9 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	    (sa_frame.flags & SAU_FLG_INV)) {
 		uint16_t nport_handle = fcport->loop_id;
 		uint16_t sa_index = sa_frame.fast_sa_index;
+		u16 entry_handle;
+		u32 delete_sa_index;
+		unsigned long lock_flags = 0;
 
 		/*
 		 * make sure we have an existing rx key, otherwise just process
@@ -1649,8 +1723,10 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		 * This is NOT a normal case, it indicates an error recovery or key cleanup
 		 * by the ipsec code above us.
 		 */
-		edif_entry = qla_edif_list_find_sa_index(fcport, fcport->loop_id);
+		spin_lock_irqsave(&fcport->edif.indx_list_lock, lock_flags);
+		edif_entry = qla_edif_list_find_sa_index_locked(fcport, fcport->loop_id);
 		if (!edif_entry) {
+			spin_unlock_irqrestore(&fcport->edif.indx_list_lock, lock_flags);
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s: WARNING: no active sa_index for nport_handle 0x%x, forcing delete for sa_index 0x%x\n",
 			    __func__, fcport->loop_id, sa_index);
@@ -1662,11 +1738,12 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		 * and proceed with normal delete.  The rx delay timer should not be running
 		 */
 		if ((sa_frame.flags & SAU_FLG_FORCE_DELETE) == SAU_FLG_FORCE_DELETE) {
-			qla_edif_list_delete_sa_index(fcport, edif_entry);
+			qla_edif_list_delete_sa_index_locked(edif_entry);
+			spin_unlock_irqrestore(&fcport->edif.indx_list_lock, lock_flags);
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s: FORCE DELETE flag found for nport_handle 0x%x, sa_index 0x%x, forcing DELETE\n",
 			    __func__, fcport->loop_id, sa_index);
-			kfree(edif_entry);
+			qla_edif_list_free_sa_index(edif_entry);
 			goto force_rx_delete;
 		}
 
@@ -1679,9 +1756,13 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		if (edif_entry->delete_sa_index != INVALID_EDIF_SA_INDEX) {
 			struct edif_sa_ctl *sa_ctl;
 
+			delete_sa_index = edif_entry->delete_sa_index;
+			entry_handle = edif_entry->handle;
+			spin_unlock_irqrestore(&fcport->edif.indx_list_lock, lock_flags);
+
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s: delete for lid 0x%x, delete_sa_index %d is pending\n",
-			    __func__, edif_entry->handle, edif_entry->delete_sa_index);
+			    __func__, entry_handle, delete_sa_index);
 
 			/* free up the sa_ctl that was allocated with the sa_index */
 			sa_ctl = qla_edif_find_sa_ctl_by_index(fcport, sa_index,
@@ -1709,6 +1790,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		/* configure and start the rx delay timer */
 		edif_entry->fcport = fcport;
 		edif_entry->timer.expires = jiffies + RX_DELAY_DELETE_TIMEOUT * HZ;
+		edif_entry->delete_sa_index = sa_index;
 
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
 		    "%s: adding timer, entry: %p, delete sa_index %d, lid 0x%x to edif_list\n",
@@ -1720,6 +1802,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		 * received packets with the new sa_index
 		 */
 		add_timer(&edif_entry->timer);
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, lock_flags);
 
 		/*
 		 * sa_delete for rx key with an active rx key including this one
@@ -1732,8 +1815,6 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		    "%s: delete sa_index %d, lid 0x%x to edif_list. bsg done ptr %p\n",
 		    __func__, sa_index, nport_handle, bsg_job);
 
-		edif_entry->delete_sa_index = sa_index;
-
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 		bsg_reply->result = DID_OK << 16;
 
@@ -2834,24 +2915,12 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 
 	/* if rx delete, remove the timer */
 	if ((pkt->flags & (SA_FLAG_INVALIDATE | SA_FLAG_TX)) ==  SA_FLAG_INVALIDATE) {
-		struct edif_list_entry *edif_entry;
-
 		sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
-		edif_entry = qla_edif_list_find_sa_index(sp->fcport, nport_handle);
-		if (edif_entry) {
-			ql_dbg(ql_dbg_edif, vha, 0x5033,
-			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
-			    __func__, edif_entry, pkt->sa_index);
-			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
-			timer_shutdown(&edif_entry->timer);
-
+		if (qla_edif_list_schedule_free_sa_index(sp->fcport, nport_handle))
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
-			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
-			    __func__, edif_entry, pkt->sa_index);
-
-			kfree(edif_entry);
-		}
+			    "%s: queued deferred edif_entry free for nport_handle 0x%x, new sa_index: 0x%x\n",
+			    __func__, nport_handle, pkt->sa_index);
 	}
 
 	/*
@@ -3230,16 +3299,21 @@ qla28xx_start_scsi_edif(srb_t *sp)
 void qla_edif_list_del(fc_port_t *fcport)
 {
 	struct edif_list_entry *indx_lst;
-	struct edif_list_entry *tindx_lst;
-	struct list_head *indx_list = &fcport->edif.edif_indx_list;
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
-	list_for_each_entry_safe(indx_lst, tindx_lst, indx_list, next) {
-		list_del(&indx_lst->next);
-		kfree(indx_lst);
+	for (;;) {
+		spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+		indx_lst = list_first_entry_or_null(&fcport->edif.edif_indx_list,
+						    struct edif_list_entry, next);
+		if (indx_lst)
+			list_del_init(&indx_lst->next);
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+		if (!indx_lst)
+			break;
+
+		qla_edif_list_free_sa_index(indx_lst);
 	}
-	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 }
 
 /******************
@@ -3419,9 +3493,10 @@ static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	unsigned long flags = 0;
 	uint16_t nport_handle = fcport->loop_id;
 	uint16_t cached_nport_handle;
+	u32 cached_update_sa_index;
 
 	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
-	edif_entry = qla_edif_list_find_sa_index(fcport, nport_handle);
+	edif_entry = qla_edif_list_find_sa_index_locked(fcport, nport_handle);
 	if (!edif_entry) {
 		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 		return;		/* no pending delete for this handle */
@@ -3453,6 +3528,7 @@ static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	delete_sa_index = edif_entry->delete_sa_index;
 	edif_entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
 	cached_nport_handle = edif_entry->handle;
+	cached_update_sa_index = edif_entry->update_sa_index;
 	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 
 	/* sanity check on the nport handle */
@@ -3471,7 +3547,7 @@ static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
 		    "delete index %d, update index: %d, nport handle: 0x%x, handle: 0x%x\n",
 		    delete_sa_index,
-		    edif_entry->update_sa_index, nport_handle, handle);
+		    cached_update_sa_index, nport_handle, handle);
 
 		sa_ctl->flags = EDIF_SA_CTL_FLG_DEL;
 		set_bit(EDIF_SA_CTL_REPL, &sa_ctl->state);
-- 
2.34.1

