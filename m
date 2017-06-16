From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 05/11] Break up IO ctx list into a separate get and put list
Date: Thu, 15 Jun 2017 22:56:45 -0700
Message-ID: <20170616055651.9674-6-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33046 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFPF5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:11 -0400
Received: by mail-qt0-f193.google.com with SMTP id w1so7899289qtg.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:11 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Since unsol rcv ISR and command cmpl ISR both access/lock
this list, a separate get/put lists will reduce contention.

Replaced
struct list_head lpfc_nvmet_ctx_list;
with
struct list_head lpfc_nvmet_ctx_get_list;
struct list_head lpfc_nvmet_ctx_put_list;
and all correpsonding locks and counters.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 11 ++++--
 drivers/scsi/lpfc/lpfc_debugfs.c | 11 ++++--
 drivers/scsi/lpfc/lpfc_init.c    | 16 +++++---
 drivers/scsi/lpfc/lpfc_nvmet.c   | 82 +++++++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli4.h    |  9 +++--
 5 files changed, 89 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index af22602b1058..4ed48ed38e79 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -245,15 +245,18 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				atomic_read(&tgtp->xmt_abort_rsp),
 				atomic_read(&tgtp->xmt_abort_rsp_error));
 
-		spin_lock(&phba->sli4_hba.nvmet_io_lock);
+		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
+		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
 		tot = phba->sli4_hba.nvmet_xri_cnt -
-			phba->sli4_hba.nvmet_ctx_cnt;
-		spin_unlock(&phba->sli4_hba.nvmet_io_lock);
+			(phba->sli4_hba.nvmet_ctx_get_cnt +
+			phba->sli4_hba.nvmet_ctx_put_cnt);
+		spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
+		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
 
 		len += snprintf(buf + len, PAGE_SIZE - len,
 				"IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
 				"CTX Outstanding %08llx\n",
-				phba->sli4_hba.nvmet_ctx_cnt,
+				phba->sli4_hba.nvmet_xri_cnt,
 				phba->sli4_hba.nvmet_io_wait_cnt,
 				phba->sli4_hba.nvmet_io_wait_total,
 				tot);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index cc49850e18a9..ed2850645e70 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -848,15 +848,18 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		}
 
-		spin_lock(&phba->sli4_hba.nvmet_io_lock);
+		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
+		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
 		tot = phba->sli4_hba.nvmet_xri_cnt -
-			phba->sli4_hba.nvmet_ctx_cnt;
-		spin_unlock(&phba->sli4_hba.nvmet_io_lock);
+			(phba->sli4_hba.nvmet_ctx_get_cnt +
+			phba->sli4_hba.nvmet_ctx_put_cnt);
+		spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
+		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
 
 		len += snprintf(buf + len, size - len,
 				"IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
 				"CTX Outstanding %08llx\n",
-				phba->sli4_hba.nvmet_ctx_cnt,
+				phba->sli4_hba.nvmet_xri_cnt,
 				phba->sli4_hba.nvmet_io_wait_cnt,
 				phba->sli4_hba.nvmet_io_wait_total,
 				tot);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 77283705eb8d..7e73fdc154f7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1281,10 +1281,13 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 		/* Check outstanding IO count */
 		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 			if (phba->nvmet_support) {
-				spin_lock(&phba->sli4_hba.nvmet_io_lock);
+				spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
+				spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
 				tot = phba->sli4_hba.nvmet_xri_cnt -
-					phba->sli4_hba.nvmet_ctx_cnt;
-				spin_unlock(&phba->sli4_hba.nvmet_io_lock);
+					(phba->sli4_hba.nvmet_ctx_get_cnt +
+					phba->sli4_hba.nvmet_ctx_put_cnt);
+				spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
+				spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
 			} else {
 				tot = atomic_read(&phba->fc4NvmeIoCmpls);
 				data1 = atomic_read(
@@ -3487,7 +3490,6 @@ lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
 
 	/* For NVMET, ALL remaining XRIs are dedicated for IO processing */
 	nvmet_xri_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
-
 	if (nvmet_xri_cnt > phba->sli4_hba.nvmet_xri_cnt) {
 		/* els xri-sgl expanded */
 		xri_cnt = nvmet_xri_cnt - phba->sli4_hba.nvmet_xri_cnt;
@@ -5935,7 +5937,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
-		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_list);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_get_list);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_put_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_io_wait_list);
 
 		/* Fast-path XRI aborted CQ Event work queue list */
@@ -5944,7 +5947,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
-	spin_lock_init(&phba->sli4_hba.nvmet_io_lock);
+	spin_lock_init(&phba->sli4_hba.nvmet_ctx_get_lock);
+	spin_lock_init(&phba->sli4_hba.nvmet_ctx_put_lock);
 	spin_lock_init(&phba->sli4_hba.nvmet_io_wait_lock);
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 431faa0a4f3e..5fb29735e236 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -267,11 +267,11 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 	}
 	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
 
-	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_lock, iflag);
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_put_lock, iflag);
 	list_add_tail(&ctx_buf->list,
-		      &phba->sli4_hba.lpfc_nvmet_ctx_list);
-	phba->sli4_hba.nvmet_ctx_cnt++;
-	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_lock, iflag);
+		      &phba->sli4_hba.lpfc_nvmet_ctx_put_list);
+	phba->sli4_hba.nvmet_ctx_put_cnt++;
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_put_lock, iflag);
 #endif
 }
 
@@ -865,28 +865,46 @@ lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
 	struct lpfc_nvmet_ctxbuf *ctx_buf, *next_ctx_buf;
 	unsigned long flags;
 
-	list_for_each_entry_safe(
-		ctx_buf, next_ctx_buf,
-		&phba->sli4_hba.lpfc_nvmet_ctx_list, list) {
-		spin_lock_irqsave(
-			&phba->sli4_hba.abts_nvme_buf_list_lock, flags);
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
+	spin_lock_irq(&phba->sli4_hba.nvmet_ctx_put_lock);
+	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
+			&phba->sli4_hba.lpfc_nvmet_ctx_get_list, list) {
+		spin_lock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		list_del_init(&ctx_buf->list);
-		spin_unlock_irqrestore(
-			&phba->sli4_hba.abts_nvme_buf_list_lock, flags);
+		spin_unlock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		__lpfc_clear_active_sglq(phba,
 					 ctx_buf->sglq->sli4_lxritag);
 		ctx_buf->sglq->state = SGL_FREED;
 		ctx_buf->sglq->ndlp = NULL;
 
-		spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, flags);
+		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
 		list_add_tail(&ctx_buf->sglq->list,
 			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
-		spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
-				       flags);
+		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
 
 		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
 		kfree(ctx_buf->context);
 	}
+	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
+			&phba->sli4_hba.lpfc_nvmet_ctx_put_list, list) {
+		spin_lock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		list_del_init(&ctx_buf->list);
+		spin_unlock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		__lpfc_clear_active_sglq(phba,
+					 ctx_buf->sglq->sli4_lxritag);
+		ctx_buf->sglq->state = SGL_FREED;
+		ctx_buf->sglq->ndlp = NULL;
+
+		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
+		list_add_tail(&ctx_buf->sglq->list,
+			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
+		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
+
+		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
+		kfree(ctx_buf->context);
+	}
+	spin_unlock_irq(&phba->sli4_hba.nvmet_ctx_put_lock);
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
 }
 
 static int
@@ -958,12 +976,12 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 					"6407 Ran out of NVMET XRIs\n");
 			return -ENOMEM;
 		}
-		spin_lock(&phba->sli4_hba.nvmet_io_lock);
+		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
 		list_add_tail(&ctx_buf->list,
-			      &phba->sli4_hba.lpfc_nvmet_ctx_list);
-		spin_unlock(&phba->sli4_hba.nvmet_io_lock);
+			      &phba->sli4_hba.lpfc_nvmet_ctx_get_list);
+		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
 	}
-	phba->sli4_hba.nvmet_ctx_cnt = phba->sli4_hba.nvmet_xri_cnt;
+	phba->sli4_hba.nvmet_ctx_get_cnt = phba->sli4_hba.nvmet_xri_cnt;
 	return 0;
 }
 
@@ -1370,13 +1388,31 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		goto dropit;
 	}
 
-	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_lock, iflag);
-	if (phba->sli4_hba.nvmet_ctx_cnt) {
-		list_remove_head(&phba->sli4_hba.lpfc_nvmet_ctx_list,
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_get_lock, iflag);
+	if (phba->sli4_hba.nvmet_ctx_get_cnt) {
+		list_remove_head(&phba->sli4_hba.lpfc_nvmet_ctx_get_list,
 				 ctx_buf, struct lpfc_nvmet_ctxbuf, list);
-		phba->sli4_hba.nvmet_ctx_cnt--;
+		phba->sli4_hba.nvmet_ctx_get_cnt--;
+	} else {
+		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
+		if (phba->sli4_hba.nvmet_ctx_put_cnt) {
+			list_splice(&phba->sli4_hba.lpfc_nvmet_ctx_put_list,
+				    &phba->sli4_hba.lpfc_nvmet_ctx_get_list);
+			INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_put_list);
+			phba->sli4_hba.nvmet_ctx_get_cnt =
+				phba->sli4_hba.nvmet_ctx_put_cnt;
+			phba->sli4_hba.nvmet_ctx_put_cnt = 0;
+			spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
+
+			list_remove_head(
+				&phba->sli4_hba.lpfc_nvmet_ctx_get_list,
+				ctx_buf, struct lpfc_nvmet_ctxbuf, list);
+			phba->sli4_hba.nvmet_ctx_get_cnt--;
+		} else {
+			spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
+		}
 	}
-	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_lock, iflag);
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_get_lock, iflag);
 
 	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 830dc83b9c21..7a1d74e9e877 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -621,7 +621,8 @@ struct lpfc_sli4_hba {
 	uint16_t scsi_xri_start;
 	uint16_t els_xri_cnt;
 	uint16_t nvmet_xri_cnt;
-	uint16_t nvmet_ctx_cnt;
+	uint16_t nvmet_ctx_get_cnt;
+	uint16_t nvmet_ctx_put_cnt;
 	uint16_t nvmet_io_wait_cnt;
 	uint16_t nvmet_io_wait_total;
 	struct list_head lpfc_els_sgl_list;
@@ -630,7 +631,8 @@ struct lpfc_sli4_hba {
 	struct list_head lpfc_abts_nvmet_ctx_list;
 	struct list_head lpfc_abts_scsi_buf_list;
 	struct list_head lpfc_abts_nvme_buf_list;
-	struct list_head lpfc_nvmet_ctx_list;
+	struct list_head lpfc_nvmet_ctx_get_list;
+	struct list_head lpfc_nvmet_ctx_put_list;
 	struct list_head lpfc_nvmet_io_wait_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
@@ -662,7 +664,8 @@ struct lpfc_sli4_hba {
 	spinlock_t abts_nvme_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t sgl_list_lock; /* list of aborted els IOs */
-	spinlock_t nvmet_io_lock;
+	spinlock_t nvmet_ctx_get_lock; /* list of avail XRI contexts */
+	spinlock_t nvmet_ctx_put_lock; /* list of avail XRI contexts */
 	spinlock_t nvmet_io_wait_lock; /* IOs waiting for ctx resources */
 	uint32_t physical_port;
 
-- 
2.11.0
