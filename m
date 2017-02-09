From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] scsi/sd: release scan_mutex during sync_cache and
        start_stop
Date: Thu, 9 Feb 2017 09:51:06 +0100
Message-ID: <20170209085106.GA7313@lst.de>
References: <20170209010116.362206-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51038 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbdBIIvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Feb 2017 03:51:17 -0500
Content-Disposition: inline
In-Reply-To: <20170209010116.362206-1-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

And what is the lock protecting if we can just release and reacquire it
safely?  Probably nothing, but someone needs to do the audit carefully.

Once that is done we can just apply a patch like the one below and
be done with it:

---
>From 47572d7f0758cc0cbd979b1a2c3791f3b94c566e Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 9 Feb 2017 09:49:04 +0100
Subject: scsi: remove scan_mutex

All our lookup structures are properly locked these days, there shouldn't
be any need to serialize the high-level scan process.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f49c30..c92be1ad486c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1490,7 +1490,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 		return ERR_PTR(-ENOMEM);
 	scsi_autopm_get_target(starget);
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
@@ -1498,7 +1497,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 		scsi_autopm_put_host(shost);
 	}
-	mutex_unlock(&shost->scan_mutex);
 	scsi_autopm_put_target(starget);
 	/*
 	 * paired with scsi_alloc_target().  Target will be destroyed unless
@@ -1629,7 +1627,6 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 	    strncmp(scsi_scan_type, "manual", 6) == 0)
 		return;
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
@@ -1637,7 +1634,6 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 		__scsi_scan_target(parent, channel, id, lun, rescan);
 		scsi_autopm_put_host(shost);
 	}
-	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_scan_target);
 
@@ -1686,7 +1682,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 	    ((lun != SCAN_WILD_CARD) && (lun >= shost->max_lun)))
 		return -EINVAL;
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
@@ -1700,7 +1695,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 		scsi_autopm_put_host(shost);
 	}
-	mutex_unlock(&shost->scan_mutex);
 
 	return 0;
 }
@@ -1752,11 +1746,9 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
 
 	spin_lock(&async_scan_lock);
 	if (list_empty(&scanning_hosts))
@@ -1789,12 +1781,9 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	shost = data->shost;
 
-	mutex_lock(&shost->scan_mutex);
-
 	if (!shost->async_scan) {
 		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
-		mutex_unlock(&shost->scan_mutex);
 		return;
 	}
 
@@ -1806,8 +1795,6 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	shost->async_scan = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	mutex_unlock(&shost->scan_mutex);
-
 	spin_lock(&async_scan_lock);
 	list_del(&data->list);
 	if (!list_empty(&scanning_hosts)) {
@@ -1915,7 +1902,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
 
-	mutex_lock(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
 		goto out;
 	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
@@ -1929,7 +1915,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:
-	mutex_unlock(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
-- 
2.11.0
