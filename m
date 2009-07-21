From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2 2/4] cciss: use mutex instead of flag to indicate busy
	initializing
Date: Tue, 21 Jul 2009 13:55:27 -0600
Message-ID: <20090721195527.20740.1301.stgit@bob.kio>
References: <20090721195517.20740.18994.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45647 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZGUTz3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 15:55:29 -0400
In-Reply-To: <20090721195517.20740.18994.stgit@bob.kio>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com

cciss: use mutex instead of flag to indicate busy initializing

Convert busy_initializing from simple integer flag to mutex, so we
can use it to block and thus avoid some race conditions.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 970c896..085ab11 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -751,7 +751,7 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 	printk(KERN_DEBUG "cciss_open %s\n", bdev->bd_disk->disk_name);
 #endif				/* CCISS_DEBUG */
 
-	if (host->busy_initializing || drv->busy_configuring)
+	if (mutex_is_locked(&host->busy_initializing) || drv->busy_configuring)
 		return -EBUSY;
 	/*
 	 * Root is allowed to open raw volume zero even if it's not configured
@@ -3915,7 +3915,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	if (i < 0)
 		return -1;
 
-	hba[i]->busy_initializing = 1;
+	mutex_init(&hba[i]->busy_initializing);
+	mutex_lock(&hba[i]->busy_initializing);
 	INIT_HLIST_HEAD(&hba[i]->cmpQ);
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
 
@@ -4034,7 +4035,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	hba[i]->cciss_max_sectors = 2048;
 
-	hba[i]->busy_initializing = 0;
+	mutex_unlock(&hba[i]->busy_initializing);
 
 	rebuild_lun_table(hba[i], 1);
 	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
@@ -4062,7 +4063,7 @@ clean2:
 clean1:
 	cciss_destroy_hba_sysfs_entry(hba[i]);
 clean0:
-	hba[i]->busy_initializing = 0;
+	mutex_unlock(&hba[i]->busy_initializing);
 	/* cleanup any queues that may have been initialized */
 	for (j=0; j <= hba[i]->highest_lun; j++){
 		drive_info_struct *drv = &(hba[i]->drv[j]);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 06a5db2..bf1699c 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -107,7 +107,7 @@ struct ctlr_info
 	int			nr_allocs;
 	int			nr_frees; 
 	int			busy_configuring;
-	int			busy_initializing;
+	struct mutex		busy_initializing;
 
 	/* This element holds the zero based queue number of the last
 	 * queue to be started.  It is used for fairness.

