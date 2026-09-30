Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF912F25F3;
	Wed, 30 Sep 2026 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758171; cv=none; b=BUcw5KtxsZW1xf8yyLAjAfmnSv9EefzXG02W3v3fHmBGhzay/tAq7b8+mB/BuTBWsMtp8HTuKi+r+MFGdVt9i+/wKa9Hy2LDgB5PfBs2St0abqjORHwhaiFmMOLuS28TU3VE6iWnp7D90XZON9Uv4Idz5fWuaMjqoU27ZAZFXPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758171; c=relaxed/simple;
	bh=2DmBzte+ZkQWQDh3ROSEnvVY5mEtFR2pyjh8HHEstM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ip25fvBSdKiFqGwqm9Zoxzy6znuYZoUPyXm99+xlkwUikoFaCiI/893xijC3waFgPstK9jCgG7uC1bWl9oGMZ/cgZYKtSEo4PcBMubIA9tgy/sBPA4umDEECubSrsvfDk2/xjrryNx3m8mhe58LDUdqaxHtxQU6AG1ibN+V6wqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EiB4m4XL; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EiB4m4XL"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f9fcecbd;
	Wed, 30 Sep 2026 16:49:23 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Brian King <brking@linux.vnet.ibm.com>,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] scsi: ibmvfc: synchronize event timer completion
Date: Wed, 30 Sep 2026 16:49:17 +0800
Message-Id: <20260930084917.2965242-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075801.2949514-1-runyu.xiao@seu.edu.cn>
References: <20260930075801.2949514-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0f181125f03a1kunm9341f46b27484f
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQh9JVklPHxlLSU5LHkIfGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=EiB4m4XLz0mrbtTyJo0X6DAbAvDpwr3ZaSrwem+0X8d70MjbWUjPAWWWsyfO+3qojHIN9mowCHHFZQsXuyiSm/lRIlrD2l+Ag2jP+ixDSY4AZL01zNNlOczNfajRqccVFek2J0NhwqavCg6FVg3Kexhm8N+7JsGHdCYwOdUkpnk=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=Jptl9/+U11paEdlC9elLjJR0bUP8PiTWBv4u6ik5r7s=;
	h=date:mime-version:subject:message-id:from;

An event completion may be deferred when the timer callback is active. MAD
events normally use ibmvfc_locked_done(), but send failures replace the
wrapper with the raw callback because the caller may already hold
host_lock. Preserve that locking requirement when the completion runs from
workqueue context.

Flush every event completion work item before taking the event pool list
lock, then remove the free-list entries while holding queue->l_lock. Route
purge completions through the same timer synchronization helper so all
completion paths obey the same ordering.

Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 61 ++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h      |  3 ++
 2 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93b9f699c..a3d016f6e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -811,6 +811,35 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
 	return ibmvfc_send_crq(vhost, 0xC002000000000000LL, 0);
 }
 
+static void ibmvfc_complete_event_work(struct work_struct *work)
+{
+	struct ibmvfc_event *evt = container_of(work, struct ibmvfc_event,
+						timer_work);
+	unsigned long flags;
+
+	timer_delete_sync(&evt->timer);
+	if (evt->done_needs_host_lock) {
+		spin_lock_irqsave(evt->vhost->host->host_lock, flags);
+		evt->done(evt);
+		spin_unlock_irqrestore(evt->vhost->host->host_lock, flags);
+	} else {
+		evt->done(evt);
+	}
+}
+
+static void ibmvfc_complete_event(struct ibmvfc_event *evt)
+{
+	/* The response path can run in hardirq context, so defer only when the
+	 * timer callback is already executing on another context.
+	 */
+	if (timer_delete_sync_try(&evt->timer) < 0) {
+		schedule_work(&evt->timer_work);
+		return;
+	}
+
+	evt->done(evt);
+}
+
 /**
  * ibmvfc_init_event_pool - Allocates and initializes the event pool for a host
  * @vhost:	ibmvfc host who owns the event pool
@@ -859,6 +888,7 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 		 */
 		atomic_set(&evt->active, -1);
 		atomic_set(&evt->free, 1);
+		INIT_WORK(&evt->timer_work, ibmvfc_complete_event_work);
 		evt->crq.valid = 0x80;
 		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
 		evt->xfer_iu = pool->iu_storage + i;
@@ -882,18 +912,31 @@ static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
 				   struct ibmvfc_queue *queue)
 {
 	int i;
+	unsigned long flags;
 	struct ibmvfc_event_pool *pool = &queue->evt_pool;
 
 	ENTER;
+	if (!pool->size)
+		goto out;
+
+	for (i = 0; i < pool->size; ++i)
+		flush_work(&pool->events[i].timer_work);
+
+	spin_lock_irqsave(&queue->l_lock, flags);
 	for (i = 0; i < pool->size; ++i) {
 		list_del(&pool->events[i].queue_list);
 		BUG_ON(atomic_read(&pool->events[i].free) != 1);
+	}
+	spin_unlock_irqrestore(&queue->l_lock, flags);
+
+	for (i = 0; i < pool->size; ++i) {
 		if (pool->events[i].ext_list)
 			dma_pool_free(vhost->sg_pool,
 				      pool->events[i].ext_list,
 				      pool->events[i].ext_list_token);
 	}
 
+out:
 	kfree(pool->events);
 	dma_free_coherent(vhost->dev,
 			  pool->size * sizeof(*pool->iu_storage),
@@ -1134,7 +1177,7 @@ static void ibmvfc_complete_purge(struct list_head *purge_list)
 	list_for_each_entry_safe(evt, pos, purge_list, queue_list) {
 		list_del(&evt->queue_list);
 		ibmvfc_trc_end(evt);
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	}
 }
 
@@ -1162,7 +1205,7 @@ static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 	else
 		evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_DRIVER_FAILED);
 
-	timer_delete(&evt->timer);
+	timer_delete_sync_try(&evt->timer);
 }
 
 /**
@@ -1669,6 +1712,7 @@ void ibmvfc_init_event(struct ibmvfc_event *evt,
 		evt->_done = done;
 		evt->done = ibmvfc_locked_done;
 	}
+	evt->done_needs_host_lock = false;
 	evt->hwq = 0;
 }
 
@@ -1824,7 +1868,6 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 		atomic_set(&evt->active, 0);
 		list_del(&evt->queue_list);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
-		timer_delete(&evt->timer);
 
 		/* If send_crq returns H_CLOSED, return SCSI_MLQUEUE_HOST_BUSY.
 		 * Firmware will send a CRQ with a transport event (0xFF) to
@@ -1836,7 +1879,8 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 				dev_warn(vhost->dev, "Send warning. Receive queue closed, will retry.\n");
 			if (evt->cmnd)
 				scsi_dma_unmap(evt->cmnd);
-			ibmvfc_free_event(evt);
+			evt->done = ibmvfc_free_event;
+			ibmvfc_complete_event(evt);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 
@@ -1849,9 +1893,10 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 		} else {
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
 			evt->done = evt->_done;
+			evt->done_needs_host_lock = true;
 		}
 
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	} else {
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
@@ -3925,10 +3970,9 @@ static void ibmvfc_tasklet(void *data)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
-		timer_delete(&evt->timer);
 		list_del(&evt->queue_list);
 		ibmvfc_trc_end(evt);
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	}
 }
 
@@ -4031,10 +4075,9 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 	spin_unlock_irqrestore(scrq->q_lock, flags);
 
 	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
-		timer_delete(&evt->timer);
 		list_del(&evt->queue_list);
 		ibmvfc_trc_end(evt);
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	}
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ca80ceffe..912d250da 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 #include <scsi/scsi_device.h>
 #include <scsi/viosrp.h>
 #include <linux/nvme.h>
@@ -867,6 +868,8 @@ struct ibmvfc_event {
 	struct completion comp;
 	struct completion *eh_comp;
 	struct timer_list timer;
+	struct work_struct timer_work;
+	bool done_needs_host_lock;
 	u16 hwq;
 	u8 reserved;
 };
-- 
2.34.1

