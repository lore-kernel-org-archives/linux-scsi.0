From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 3/4] pm8001: add a new spinlock to protect the CCB
Date: Thu, 26 Jun 2014 17:17:35 +0200
Message-ID: <1403795856-4300-3-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbaFZPSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 11:18:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: AnandKumar.Santhanam@pmcs.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

Patch adds a new spinlock to protect the ccb management.
It may happen that concurrent threads become the same tag value 
from the 'alloc' function', the spinlock prevents this situation.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 1 +
 drivers/scsi/pm8001/pm8001_sas.c  | 7 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b21..56b61e5 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -246,6 +246,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 {
 	int i;
 	spin_lock_init(&pm8001_ha->lock);
+	spin_lock_init(&pm8001_ha->bitmap_lock);
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("pm8001_alloc: PHY:%x\n",
 				pm8001_ha->chip->n_phy));
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index be55859..34cea82 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -77,11 +77,16 @@ inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
 {
 	unsigned int tag;
 	void *bitmap = pm8001_ha->tags;
+	unsigned long flags;
 
+	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
 	tag = find_first_zero_bit(bitmap, pm8001_ha->tags_num);
-	if (tag >= pm8001_ha->tags_num)
+	if (tag >= pm8001_ha->tags_num) {
+		spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
 		return -SAS_QUEUE_FULL;
+	}
 	set_bit(tag, bitmap);
+	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
 	*tag_out = tag;
 	return 0;
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 14106ad..f6b2ac5 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -475,6 +475,7 @@ struct pm8001_hba_info {
 	struct list_head	list;
 	unsigned long		flags;
 	spinlock_t		lock;/* host-wide lock */
+	spinlock_t		bitmap_lock;
 	struct pci_dev		*pdev;/* our device */
 	struct device		*dev;
 	struct pm8001_hba_memspace io_mem[6];
-- 
1.8.3.1

