From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 5/5] optimization of code
Date: Tue, 12 May 2009 01:06:40 +0800
Message-ID: <20090511170640.GD9638@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:4592 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752516AbZEKIP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:15:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From 698781e21a8595159a84a8c91b6bfa26d1a99108 Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 11 May 2009 22:19:25 +0800
Subject: [PATCH 5/5] optimization of code

Using sticky field to improve retrieve performance.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |   29 ++++++++++++++---------------
 drivers/scsi/mvsas/mv_sas.h |    3 ++-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 3fc396f..c05e4c0 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -225,7 +225,8 @@ struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 {
 	unsigned long i = 0, j = 0, n = 0, num = 0;
-	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 	struct sas_ha_struct *sha = dev->port->ha;
 
 	while (sha->sas_port[i]) {
@@ -872,8 +873,8 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 				struct mvs_tmf_task *tmf)
 {
 	struct domain_device *dev = task->dev;
-	struct mvs_info *mvi;
-	struct mvs_device *mvi_dev;
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 	struct mvs_task_exec_info tei;
 	struct sas_task *t = task;
 	struct mvs_slot_info *slot;
@@ -890,8 +891,6 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 		return 0;
 	}
 
-	mvi = mvs_find_dev_mvi(task->dev);
-
 	spin_lock_irqsave(&mvi->lock, flags);
 	do {
 		dev = t->dev;
@@ -1320,7 +1319,7 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
 	}
 	dev->lldd_dev = (void *)mvi_device;
 	mvi_device->dev_type = dev->dev_type;
-
+	mvi_device->mvi_info = mvi;
 	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
 		int phy_id;
 		u8 phy_num = parent_dev->ex_dev.num_phys;
@@ -1357,10 +1356,8 @@ int mvs_dev_found(struct domain_device *dev)
 void mvs_dev_gone_notify(struct domain_device *dev, int lock)
 {
 	unsigned long flags = 0;
-	struct mvs_info *mvi;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-
-	mvi = mvs_find_dev_mvi(dev);
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (lock)
 		spin_lock_irqsave(&mvi->lock, flags);
@@ -1535,8 +1532,8 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 	unsigned long flags;
 	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
 	struct mvs_tmf_task tmf_task;
-	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
 	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	tmf_task.tmf = TMF_LU_RESET;
 	mvi_dev->dev_status = MVS_DEV_EH;
@@ -1558,8 +1555,8 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
 {
 	unsigned long flags;
 	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
-	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (mvi_dev->dev_status != MVS_DEV_EH)
 		return TMF_RESP_FUNC_COMPLETE;
@@ -1587,7 +1584,8 @@ int mvs_query_task(struct sas_task *task)
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 		struct domain_device *dev = task->dev;
-		struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+		struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+		struct mvs_info *mvi = mvi_dev->mvi_info;
 
 		int_to_scsilun(cmnd->device->lun, &lun);
 		rc = mvs_find_tag(mvi, task, &tag);
@@ -1619,10 +1617,12 @@ int mvs_abort_task(struct sas_task *task)
 	struct scsi_lun lun;
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
-	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 	u32 tag;
+
 	if (mvi->exp_req)
 		mvi->exp_req--;
 	spin_lock_irqsave(&task->task_state_lock, flags);
@@ -1652,7 +1652,6 @@ int mvs_abort_task(struct sas_task *task)
 		if (rc == TMF_RESP_FUNC_COMPLETE) {
 			u32 slot_no;
 			struct mvs_slot_info *slot;
-			struct mvs_info *mvi = mvs_find_dev_mvi(dev);
 
 			if (task->lldd_task) {
 				slot = (struct mvs_slot_info *)task->lldd_task;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 93735ed..aa2270a 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -231,7 +231,9 @@ struct mvs_phy {
 };
 
 struct mvs_device {
+	struct list_head		dev_entry;
 	enum sas_dev_type dev_type;
+	struct mvs_info *mvi_info;
 	struct domain_device *sas_device;
 	u32 attached_phy;
 	u32 device_id;
@@ -239,7 +241,6 @@ struct mvs_device {
 	u8 taskfileset;
 	u8 dev_status;
 	u16 reserved;
-	struct list_head		dev_entry;
 };
 
 struct mvs_slot_info {
-- 
1.6.2.1

