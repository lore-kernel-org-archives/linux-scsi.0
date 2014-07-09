From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH 7/8][RESEND] pm8001: add a new spinlock to protect the CCB
Date: Wed,  9 Jul 2014 17:21:01 +0530
Message-ID: <1404906661-15841-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49237 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbaGILv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 07:51:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com, thenzl@redhat.com

From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Patch adds a new spinlock to protect the ccb management.
It may happen that concurrent threads become the same tag value
from the 'alloc' function', the spinlock prevents this situation.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    1 +
 drivers/scsi/pm8001/pm8001_sas.c  |    7 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index aad060a..acef7d6 100644
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
1.7.1

