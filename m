Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327303E3DB8;
	Wed, 30 Sep 2026 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755094; cv=none; b=AvoWWdbHOTEnfHOMVU1ddFoI2ysNdMWUvYinVnVpGmbmXa/iJhnep1VFkkB7pOC+Ql6HWmkL8RxDGO7i0mAS5+1apb8jd3Xmgnk/Enoxdv5mm2Md3UbFpk5ALR01pDtF3I/gtKu78YM2BIMym59qbsy0Pjukv5uGwlc7wIBb818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755094; c=relaxed/simple;
	bh=vyU1ylYRa1VYJwFXCzhmzCMq8+8oCUFfnZETjjTVHQs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PDFuCb2GnF6kco7gjIJzmkqn6+LSA4Obxgs1Z7DbH8NZxnmeQhlucKpTMRiUKpKllQNsL1adW5U7XF3+oECfrfE4EE3D9vpf7Lgp0lenLBN0tZWlg1TjSs+MxEyiKFS6mLRRJ2X+nuSINSEcB+0JNqN7hxt+5WascHO98nP9NAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=IGM0DHlC; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="IGM0DHlC"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f9ce8add;
	Wed, 30 Sep 2026 15:58:07 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@kernel.org>,
	Brian King <brking@linux.vnet.ibm.com>,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: ibmvfc: synchronize event timer completion
Date: Wed, 30 Sep 2026 15:58:01 +0800
Message-Id: <20260930075801.2949514-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0f15223fc03a1kunm3c39a5d2270ab8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGksdVhkfQ0JITUkYTx5PTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=IGM0DHlCUI0ocTU9fMH2w7Jr5IhGm2zIKdcqFY5BTuJSyTVwYXN/UGX4UiMu0qHuDzacSOBLwTllk69uO4ZxApPFga19JbeoJKronBs8WqVYF77MtjCljfGsMHrm3Hd029eZCWT5Z20HP8vdQksLpP9QCmLGbB8mgGk5vn4x3Fw=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=BfUiU8sdifpY8ApVkV3WU0a/oKOyPdhWsydCFEavjao=;
	h=date:mime-version:subject:message-id:from;

The response and purge paths remove an event from their queue and
complete it immediately after timer_delete(). A timer callback can still
be running on another CPU and can access the event while its completion
returns it to the event pool for reuse.

Use timer_delete_sync_try() in the interrupt-side completion path and defer
the completion to workqueue context when the timer callback is active.
Flush the work before releasing the event pool so an event cannot be reused
or freed while its callback is still running.

Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 40 ++++++++++++++++++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.h      |  2 ++
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93b9f699c..072008411 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -811,6 +811,28 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
 	return ibmvfc_send_crq(vhost, 0xC002000000000000LL, 0);
 }
 
+static void ibmvfc_complete_event_work(struct work_struct *work)
+{
+	struct ibmvfc_event *evt = container_of(work, struct ibmvfc_event,
+						timer_work);
+
+	timer_delete_sync(&evt->timer);
+	evt->done(evt);
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
@@ -859,6 +881,7 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 		 */
 		atomic_set(&evt->active, -1);
 		atomic_set(&evt->free, 1);
+		INIT_WORK(&evt->timer_work, ibmvfc_complete_event_work);
 		evt->crq.valid = 0x80;
 		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
 		evt->xfer_iu = pool->iu_storage + i;
@@ -886,6 +909,7 @@ static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
 
 	ENTER;
 	for (i = 0; i < pool->size; ++i) {
+		flush_work(&pool->events[i].timer_work);
 		list_del(&pool->events[i].queue_list);
 		BUG_ON(atomic_read(&pool->events[i].free) != 1);
 		if (pool->events[i].ext_list)
@@ -1134,7 +1158,7 @@ static void ibmvfc_complete_purge(struct list_head *purge_list)
 	list_for_each_entry_safe(evt, pos, purge_list, queue_list) {
 		list_del(&evt->queue_list);
 		ibmvfc_trc_end(evt);
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	}
 }
 
@@ -1162,7 +1186,7 @@ static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 	else
 		evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_DRIVER_FAILED);
 
-	timer_delete(&evt->timer);
+	timer_delete_sync_try(&evt->timer);
 }
 
 /**
@@ -1824,7 +1848,6 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 		atomic_set(&evt->active, 0);
 		list_del(&evt->queue_list);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
-		timer_delete(&evt->timer);
 
 		/* If send_crq returns H_CLOSED, return SCSI_MLQUEUE_HOST_BUSY.
 		 * Firmware will send a CRQ with a transport event (0xFF) to
@@ -1836,7 +1859,8 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 				dev_warn(vhost->dev, "Send warning. Receive queue closed, will retry.\n");
 			if (evt->cmnd)
 				scsi_dma_unmap(evt->cmnd);
-			ibmvfc_free_event(evt);
+			evt->done = ibmvfc_free_event;
+			ibmvfc_complete_event(evt);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 
@@ -1851,7 +1875,7 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 			evt->done = evt->_done;
 		}
 
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	} else {
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
@@ -3925,10 +3949,9 @@ static void ibmvfc_tasklet(void *data)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
-		timer_delete(&evt->timer);
 		list_del(&evt->queue_list);
 		ibmvfc_trc_end(evt);
-		evt->done(evt);
+		ibmvfc_complete_event(evt);
 	}
 }
 
@@ -4031,10 +4054,9 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
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
index ca80ceffe..fba2e3a23 100644
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
@@ -867,6 +868,7 @@ struct ibmvfc_event {
 	struct completion comp;
 	struct completion *eh_comp;
 	struct timer_list timer;
+	struct work_struct timer_work;
 	u16 hwq;
 	u8 reserved;
 };
-- 
2.34.1

