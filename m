Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFCBC8300D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A1F2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgD3NUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:60694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgD3NUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1FAAEAFA7;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 40/41] mv_sas: use reserved tags and drop private tag allocation
Date:   Thu, 30 Apr 2020 15:19:03 +0200
Message-Id: <20200430131904.5847-41-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use reserved tags. With that all tags are maintained
by the block layer and we can drop the private tag allocation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mvsas/mv_init.c | 10 +----
 drivers/scsi/mvsas/mv_sas.c  | 98 +++++++++-----------------------------------
 drivers/scsi/mvsas/mv_sas.h  | 13 +++---
 3 files changed, 27 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5973eed94938..17dab5aa966a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -141,7 +141,6 @@ static void mvs_free(struct mvs_info *mvi)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
 		cancel_delayed_work(&mwq->work_q);
-	kfree(mvi->tags);
 	kfree(mvi);
 }
 
@@ -286,10 +285,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 			printk(KERN_DEBUG "failed to create dma pool %s.\n", pool_name);
 			goto err_out;
 	}
-	mvi->tags_num = slot_nr;
-
-	/* Initialize tags */
-	mvs_tag_init(mvi);
 	return 0;
 err_out:
 	return 1;
@@ -372,10 +367,6 @@ static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
 	mvi->sas = sha;
 	mvi->shost = shost;
 
-	mvi->tags = kzalloc(MVS_CHIP_SLOT_SZ>>3, GFP_KERNEL);
-	if (!mvi->tags)
-		goto err_out;
-
 	if (MVS_CHIP_DISP->chip_ioremap(mvi))
 		goto err_out;
 	if (!mvs_alloc(mvi, shost))
@@ -474,6 +465,7 @@ static void  mvs_post_sas_ha_init(struct Scsi_Host *shost,
 	else
 		can_queue = MVS_CHIP_SLOT_SZ;
 
+	shost->nr_reserved_cmds = 2;
 	shost->sg_tablesize = min_t(u16, SG_ALL, MVS_MAX_SG);
 	shost->can_queue = can_queue;
 	mvi->shost->cmd_per_lun = MVS_QUEUE_SIZE;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 0b647bf7dc0a..669ce9aa57ea 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -9,55 +9,6 @@
 
 #include "mv_sas.h"
 
-static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
-{
-	if (task->lldd_task) {
-		struct mvs_slot_info *slot;
-		slot = task->lldd_task;
-		*tag = slot->slot_tag;
-		return 1;
-	}
-	return 0;
-}
-
-void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
-{
-	void *bitmap = mvi->tags;
-	clear_bit(tag, bitmap);
-}
-
-void mvs_tag_free(struct mvs_info *mvi, u32 tag)
-{
-	mvs_tag_clear(mvi, tag);
-}
-
-void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
-{
-	void *bitmap = mvi->tags;
-	set_bit(tag, bitmap);
-}
-
-inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
-{
-	unsigned int index, tag;
-	void *bitmap = mvi->tags;
-
-	index = find_first_zero_bit(bitmap, mvi->tags_num);
-	tag = index;
-	if (tag >= mvi->tags_num)
-		return -SAS_QUEUE_FULL;
-	mvs_tag_set(mvi, tag);
-	*tag_out = tag;
-	return 0;
-}
-
-void mvs_tag_init(struct mvs_info *mvi)
-{
-	int i;
-	for (i = 0; i < mvi->tags_num; ++i)
-		mvs_tag_clear(mvi, i);
-}
-
 static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 {
 	unsigned long i = 0, j = 0, hi = 0;
@@ -764,10 +715,13 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 		n_elem = task->num_scatter;
 	}
 
-	rc = mvs_tag_alloc(mvi, &tag);
-	if (rc)
+	if (task->tag == -1) {
+		dev_printk(KERN_ERR, mvi->dev,
+			   "invalid sas_task tag\n");
+		rc = -EINVAL;
 		goto err_out;
-
+	}
+	tag = task->tag;
 	slot = &mvi->slot_info[tag];
 
 	task->lldd_task = NULL;
@@ -777,7 +731,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->buf = dma_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 	if (!slot->buf) {
 		rc = -ENOMEM;
-		goto err_out_tag;
+		goto err_out;
 	}
 
 	tei.task = task;
@@ -824,8 +778,6 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 
 err_out_slot_buf:
 	dma_pool_free(mvi->dma_pool, slot->buf, slot->buf_dma);
-err_out_tag:
-	mvs_tag_free(mvi, tag);
 err_out:
 
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
@@ -866,12 +818,6 @@ int mvs_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return mvs_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
 
-static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
-{
-	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
-	mvs_tag_clear(mvi, slot_idx);
-}
-
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 			  struct mvs_slot_info *slot, u32 slot_idx)
 {
@@ -909,7 +855,6 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	slot->task = NULL;
 	slot->port = NULL;
 	slot->slot_tag = 0xFFFFFFFF;
-	mvs_slot_free(mvi, slot_idx);
 }
 
 static void mvs_update_wideport(struct mvs_info *mvi, int phy_no)
@@ -1418,7 +1363,6 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
 /* optional SAM-3 */
 int mvs_query_task(struct sas_task *task)
 {
-	u32 tag;
 	struct scsi_lun lun;
 	struct mvs_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED;
@@ -1426,18 +1370,15 @@ int mvs_query_task(struct sas_task *task)
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 		struct domain_device *dev = task->dev;
-		struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-		struct mvs_info *mvi = mvi_dev->mvi_info;
 
 		int_to_scsilun(cmnd->device->lun, &lun);
-		rc = mvs_find_tag(mvi, task, &tag);
-		if (rc == 0) {
+		if (task->tag == -1) {
 			rc = TMF_RESP_FUNC_FAILED;
 			return rc;
 		}
 
 		tmf_task.tmf = TMF_QUERY_TASK;
-		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(task->tag);
 
 		rc = mvs_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 		switch (rc) {
@@ -1463,7 +1404,6 @@ int mvs_abort_task(struct sas_task *task)
 	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
-	u32 tag;
 
 	if (!mvi_dev) {
 		mv_printk("Device has removed\n");
@@ -1484,15 +1424,14 @@ int mvs_abort_task(struct sas_task *task)
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 
 		int_to_scsilun(cmnd->device->lun, &lun);
-		rc = mvs_find_tag(mvi, task, &tag);
-		if (rc == 0) {
+		if (task->tag == -1) {
 			mv_printk("No such tag in %s\n", __func__);
 			rc = TMF_RESP_FUNC_FAILED;
 			return rc;
 		}
 
 		tmf_task.tmf = TMF_ABORT_TASK;
-		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(task->tag);
 
 		rc = mvs_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 
@@ -1714,7 +1653,8 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	/* race condition*/
-	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	aborted = (task->task_state_flags & SAS_TASK_STATE_ABORTED) ||
+		(flags & MVS_SLOT_CMPL_SLOT_RESET);
 	spin_unlock(&task->task_state_lock);
 
 	memset(tstat, 0, sizeof(*tstat));
@@ -1732,7 +1672,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 	/* when no device attaching, go ahead and complete by error handling*/
-	if (unlikely(!mvi_dev || flags)) {
+	if (unlikely(!mvi_dev || (flags & MVS_SLOT_CMPL_PHY_GONE))) {
 		if (!mvi_dev)
 			mv_dprintk("port has not device.\n");
 		tstat->stat = SAS_PHY_DOWN;
@@ -1845,7 +1785,7 @@ void mvs_do_release_task(struct mvs_info *mvi,
 			slot_idx, slot->slot_tag, task);
 		MVS_CHIP_DISP->command_active(mvi, slot_idx);
 
-		mvs_slot_complete(mvi, slot_idx, 1);
+		mvs_slot_complete(mvi, slot_idx, MVS_SLOT_CMPL_PHY_GONE);
 	}
 }
 
@@ -2067,14 +2007,16 @@ int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 		rx_desc = le32_to_cpu(mvi->rx[rx_prod_idx + 1]);
 
 		if (likely(rx_desc & RXQ_DONE))
-			mvs_slot_complete(mvi, rx_desc, 0);
+			mvs_slot_complete(mvi, rx_desc, MVS_SLOT_CMPL_NONE);
 		if (rx_desc & RXQ_ATTN) {
 			attn = true;
 		} else if (rx_desc & RXQ_ERR) {
 			if (!(rx_desc & RXQ_DONE))
-				mvs_slot_complete(mvi, rx_desc, 0);
+				mvs_slot_complete(mvi, rx_desc,
+						  MVS_SLOT_CMPL_NONE);
 		} else if (rx_desc & RXQ_SLOT_RESET) {
-			mvs_slot_free(mvi, rx_desc);
+			mvs_slot_complete(mvi, rx_desc,
+					  MVS_SLOT_CMPL_SLOT_RESET);
 		}
 	}
 
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 327fdd5ee962..480a5129eff4 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -83,6 +83,12 @@ enum dev_reset {
 	MVS_PHY_TUNE	= 2,
 };
 
+enum mvs_slot_complete_flags {
+	MVS_SLOT_CMPL_NONE = 0,
+	MVS_SLOT_CMPL_PHY_GONE = 1,
+	MVS_SLOT_CMPL_SLOT_RESET = 2,
+};
+
 struct mvs_info;
 struct mvs_prv_info;
 
@@ -370,8 +376,6 @@ struct mvs_info {
 	u32 chip_id;
 	const struct mvs_chip_info *chip;
 
-	int tags_num;
-	unsigned long *tags;
 	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
 	struct mvs_port port[MVS_MAX_PHYS];
@@ -424,11 +428,6 @@ struct mvs_task_exec_info {
 
 /******************** function prototype *********************/
 void mvs_get_sas_addr(void *buf, u32 buflen);
-void mvs_tag_clear(struct mvs_info *mvi, u32 tag);
-void mvs_tag_free(struct mvs_info *mvi, u32 tag);
-void mvs_tag_set(struct mvs_info *mvi, unsigned int tag);
-int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out);
-void mvs_tag_init(struct mvs_info *mvi);
 void mvs_iounmap(void __iomem *regs);
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex);
 void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
-- 
2.16.4

