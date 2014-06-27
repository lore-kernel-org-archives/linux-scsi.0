From: Viswas G <Viswas.G@pmcs.com>
Subject: RE: [PATCH 3/4] pm8001: add a new spinlock to protect the CCB
Date: Fri, 27 Jun 2014 06:09:09 +0000
Message-ID: <DB8BCD22E410A84DA91083F3479A3DB31CD56D32@BBYEXM02.pmc-sierra.internal>
References: <1403795856-4300-3-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55488 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbaF0G2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:28:04 -0400
In-Reply-To: <1403795856-4300-3-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

HI Tomas,

This lock is not needed as we are already protecting the tag allocation and freeing with the pm8001_ha->lock. We are always acquiring this lock before calling 
pm8001_tag_alloc().

We are allocating and freeing the tag in following paths, 

1) Request/Response path : This we are protecting using pm8001_ha->lock.
2)Driver initialization : We are not using the lock here . As there only one will be running, we don't need a lock here.
 
So there is no need of a specific lock for tag allocation.

Regards,
Viswas G

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, June 26, 2014 8:48 PM
To: linux-scsi@vger.kernel.org
Cc: zzzAnand Kumar Santhanam(Nov-20-2013); Vasanthalakshmi Tharmarajan; Suresh Thiagarajan; Viswas G; Tomas Henzl
Subject: [PATCH 3/4] pm8001: add a new spinlock to protect the CCB

Patch adds a new spinlock to protect the ccb management.
It may happen that concurrent threads become the same tag value from the 'alloc' function', the spinlock prevents this situation.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 1 +  drivers/scsi/pm8001/pm8001_sas.c  | 7 ++++++-  drivers/scsi/pm8001/pm8001_sas.h  | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b21..56b61e5 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -246,6 +246,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,  {
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
@@ -77,11 +77,16 @@ inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)  {
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

