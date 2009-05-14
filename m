From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 6/6] mvsas: optimization of code
Date: Fri, 15 May 2009 05:31:05 +0800
Message-ID: <20090514213105.GB17959@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:8677 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760059AbZENMkT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 08:40:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From e982ad0e48db5f18a81647927f1ca6e2fafe3e48 Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Thu, 14 May 2009 20:41:21 -0400
Subject: [PATCH 6/6] mvsas: optimization of code

remove all the cast from void * or to void *

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com

---
 drivers/scsi/mvsas/mv_sas.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 3b40d00..7bcdd98 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -28,7 +28,7 @@ static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
 {
 	if (task->lldd_task) {
 		struct mvs_slot_info *slot;
-		slot = (struct mvs_slot_info *) task->lldd_task;
+		slot = task->lldd_task;
 		*tag = slot->slot_tag;
 		return 1;
 	}
@@ -37,7 +37,7 @@ static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
 
 void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-	void *bitmap = (void *) &mvi->tags;
+	void *bitmap = &mvi->tags;
 	clear_bit(tag, bitmap);
 }
 
@@ -48,14 +48,14 @@ void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 
 void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
 {
-	void *bitmap = (void *) &mvi->tags;
+	void *bitmap = &mvi->tags;
 	set_bit(tag, bitmap);
 }
 
 inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
 	unsigned int index, tag;
-	void *bitmap = (void *) &mvi->tags;
+	void *bitmap = &mvi->tags;
 
 	index = find_first_zero_bit(bitmap, mvi->tags_num);
 	tag = index;
@@ -591,8 +591,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 {
 	struct sas_task *task = tei->task;
 	struct domain_device *dev = task->dev;
-	struct mvs_device *mvi_dev =
-		(struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
 	struct mvs_slot_info *slot;
@@ -733,8 +732,7 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct mvs_port *port = tei->port;
 	struct domain_device *dev = task->dev;
-	struct mvs_device *mvi_dev =
-		(struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct asd_sas_port *sas_port = dev->port;
 	struct mvs_slot_info *slot;
 	void *buf_prd;
@@ -894,7 +892,7 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 	spin_lock_irqsave(&mvi->lock, flags);
 	do {
 		dev = t->dev;
-		mvi_dev = (struct mvs_device *)dev->lldd_dev;
+		mvi_dev = dev->lldd_dev;
 		if (DEV_IS_GONE(mvi_dev)) {
 			if (mvi_dev)
 				mv_dprintk("device %d not ready.\n",
@@ -987,7 +985,7 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 		}
 		slot->task = t;
 		slot->port = tei.port;
-		t->lldd_task = (void *) slot;
+		t->lldd_task = slot;
 		list_add_tail(&slot->entry, &tei.port->list);
 		/* TODO: select normal or high priority */
 		spin_lock(&t->task_state_lock);
@@ -1139,7 +1137,7 @@ static void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
 	if (((s[1] & 0x00FFFFFF) == 0x00EB1401) && (*(u8 *)&s[3] == 0x01))
 		s[1] = 0x00EB1401 | (*((u8 *)&s[1] + 3) & 0x10);
 
-	return (void *)s;
+	return s;
 }
 
 static u32 mvs_is_sig_fis_received(u32 irq_status)
@@ -1176,7 +1174,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 					sas_phy->oob_mode = SATA_OOB_MODE;
 				phy->frame_rcvd_size =
 				    sizeof(struct dev_to_host_fis);
-				mvs_get_d2h_reg(mvi, i, (void *)id);
+				mvs_get_d2h_reg(mvi, i, id);
 			} else {
 				u32 tmp;
 				dev_printk(KERN_DEBUG, mvi->dev,
@@ -1317,7 +1315,7 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
 		res = -1;
 		goto found_out;
 	}
-	dev->lldd_dev = (void *)mvi_device;
+	dev->lldd_dev = mvi_device;
 	mvi_device->dev_type = dev->dev_type;
 	mvi_device->mvi_info = mvi;
 	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
@@ -1356,7 +1354,7 @@ int mvs_dev_found(struct domain_device *dev)
 void mvs_dev_gone_notify(struct domain_device *dev, int lock)
 {
 	unsigned long flags = 0;
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (lock)
@@ -1532,7 +1530,7 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 	unsigned long flags;
 	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
 	struct mvs_tmf_task tmf_task;
-	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device * mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	tmf_task.tmf = TMF_LU_RESET;
@@ -1654,7 +1652,7 @@ int mvs_abort_task(struct sas_task *task)
 			struct mvs_slot_info *slot;
 
 			if (task->lldd_task) {
-				slot = (struct mvs_slot_info *)task->lldd_task;
+				slot = task->lldd_task;
 				slot_no = (u32) (slot - mvi->slot_info);
 				mvs_slot_complete(mvi, slot_no, 1);
 			}
@@ -1708,7 +1706,7 @@ int mvs_clear_task_set(struct domain_device *dev, u8 *lun)
 static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 			u32 slot_idx, int err)
 {
-	struct mvs_device *mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+	struct mvs_device *mvi_dev = task->dev->lldd_dev;
 	struct task_status_struct *tstat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
 	int stat = SAM_GOOD;
@@ -1785,7 +1783,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		return -1;
 
 	tstat = &task->task_status;
-	mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+	mvi_dev = task->dev->lldd_dev;
 
 	mvs_hba_cq_dump(mvi);
 
-- 
1.6.0.3

