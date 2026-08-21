Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05AB2566F7;
	Fri, 21 Aug 2026 00:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787272055; cv=none; b=RFNfAoa9YR+k1iEfQ0ggaEAEZyhYaZzu8DNN1T+/uVaPPq00SS7pHeLXKO9/mVDtJUZfVvCn+v/2DfnlVvP5QnpHuWyKjjD8uiO4Y8ItO4QpsR8t/VznqJcqzaUD21wKRDNb5o3JbT7CiGeza92gmt358K1xQaVx1B+9kJs6vn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787272055; c=relaxed/simple;
	bh=EgVrecuGeFPLoF3CSDAAUNaCYnEk3mCK2i+Ad+fc+og=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XlpqW054KysM0a403nOa1HYGlZBl3M062M8iYYm0R6RtjImYKRjFQK1iH9a5vLcpNiw9kH6OLJDbM+HYvFF5hWZ6+k0OeSDkJXjXVD/90dk++7REaBE8uAadBMShnGcypKekbK53yednweSS6hd9+jqbEr2SsrnBrldCI+dLaw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=OeYoUko1; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="OeYoUko1"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4ac206720;
	Fri, 21 Aug 2026 08:27:18 +0800 (GMT+08:00)
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
Subject: [PATCH] scsi: qla2xxx: wait for the EDIF RX timer before freeing entries
Date: Fri, 21 Aug 2026 08:27:08 +0800
Message-Id: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa021b7091903a1kunm685a312a181580
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGE8ZVh5DGBgaHktKTkhIQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=OeYoUko1rnshfDv3c8UnzAOiAis9BruHMm+1Dt5WHf7uBg/7n25KyFoBnpG0XPOOXfmrbswLVQh1lOpiXjvW4VRcHb9I2EHAj7ZAJ+u2nt2OoaP/fD9ZswGoYUa2nnJeTXyhW2VL5Fp6P5YToDSGeeywPQ2W1RvdnW2BJSU2kM0=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=FJIqwYnQ/TRj4CsdPOWeUoW2pfWA1f+crYUkmyuHZwM=;
	h=date:mime-version:subject:message-id:from;

The EDIF RX rekey path arms the delayed SA delete timer from
qla24xx_sadb_update() after an application submits an RX SA delete.
When the firmware reports the corresponding RX delete through an
SA_UPDATE_IOCB_TYPE completion, qla28xx_sa_update_iocb_entry() removes
the entry. The timer callback may already be running on another CPU and
dereferences the same entry and its fcport. Session teardown can also
free entries from qla_edif_list_del() without stopping their timers.

timer_shutdown() prevents rearming but does not wait for a callback that
is already running. The response completion path can run in hardirq
context while holding hardware_lock, so it cannot call
timer_shutdown_sync() directly.

Keep an entry on the EDIF list while its deferred free work is pending.
The response path marks the entry, shuts down the timer, and queues the
work item. The worker synchronizes with the timer callback before it
removes and frees the entry. qla_edif_list_del() cancels pending work
before freeing an entry, which also keeps fcport alive until a callback
that references it has finished.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 +
 drivers/scsi/qla2xxx/qla_edif.c | 81 ++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 16 deletions(-)

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
index eccedb38a515..8ad3820470e9 100644
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
@@ -85,7 +87,8 @@ static struct edif_list_entry *qla_edif_list_find_sa_index(fc_port_t *fcport,
 	struct list_head *indx_list = &fcport->edif.edif_indx_list;
 
 	list_for_each_entry_safe(entry, tentry, indx_list, next) {
-		if (entry->handle == handle)
+		if (entry->handle == handle &&
+		    !(READ_ONCE(entry->flags) & EDIF_ENTRY_FLAGS_FREE_PENDING))
 			return entry;
 	}
 	return NULL;
@@ -185,6 +188,7 @@ static int qla_edif_list_add_sa_update_index(fc_port_t *fcport,
 	entry->count = 0;
 	entry->flags = 0;
 	timer_setup(&entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
+	INIT_WORK(&entry->free_work, qla_edif_list_free_sa_index_work);
 	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
 	list_add_tail(&entry->next, &fcport->edif.edif_indx_list);
 	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
@@ -197,7 +201,51 @@ static void qla_edif_list_delete_sa_index(fc_port_t *fcport, struct edif_list_en
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
-	list_del(&entry->next);
+	if (!list_empty(&entry->next))
+		list_del_init(&entry->next);
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+}
+
+static void qla_edif_list_free_sa_index(struct edif_list_entry *entry)
+{
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
+	unsigned long flags = 0;
+	bool free_entry = false;
+
+	timer_shutdown_sync(&entry->timer);
+
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	if (!list_empty(&entry->next)) {
+		list_del_init(&entry->next);
+		free_entry = true;
+	}
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+	if (free_entry)
+		kfree(entry);
+}
+
+static void qla_edif_list_schedule_free_sa_index(fc_port_t *fcport,
+						 struct edif_list_entry *entry)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	if (!list_empty(&entry->next) &&
+	    !(entry->flags & EDIF_ENTRY_FLAGS_FREE_PENDING)) {
+		entry->flags |= EDIF_ENTRY_FLAGS_FREE_PENDING;
+		timer_shutdown(&entry->timer);
+		schedule_work(&entry->free_work);
+	}
 	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
 }
 
@@ -417,8 +465,6 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				 */
 				if (edif_entry->delete_sa_index !=
 						INVALID_EDIF_SA_INDEX) {
-					timer_shutdown(&edif_entry->timer);
-
 					/* build and send the aen */
 					fcport->edif.rx_sa_set = 1;
 					fcport->edif.rx_sa_pending = 0;
@@ -432,7 +478,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				    __func__, edif_entry, edif_entry->update_sa_index,
 				    edif_entry->delete_sa_index);
 
-				kfree(edif_entry);
+				qla_edif_list_free_sa_index(edif_entry);
 			}
 		}
 		key_cnt++;
@@ -1666,7 +1712,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 			ql_dbg(ql_dbg_edif, vha, 0x911d,
 			    "%s: FORCE DELETE flag found for nport_handle 0x%x, sa_index 0x%x, forcing DELETE\n",
 			    __func__, fcport->loop_id, sa_index);
-			kfree(edif_entry);
+			qla_edif_list_free_sa_index(edif_entry);
 			goto force_rx_delete;
 		}
 
@@ -2843,14 +2889,12 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
 			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
-			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
-			timer_shutdown(&edif_entry->timer);
+			qla_edif_list_schedule_free_sa_index(sp->fcport, edif_entry);
 
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
 			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
 
-			kfree(edif_entry);
 		}
 	}
 
@@ -3230,16 +3274,21 @@ qla28xx_start_scsi_edif(srb_t *sp)
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
-- 
2.34.1

