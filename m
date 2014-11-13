From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] scsi: don't allow setting of queue_depth bigger than can_queue
Date: Thu, 13 Nov 2014 18:59:02 +0100
Message-ID: <1415901546-8006-4-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559AbaKMR7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:09 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

We won't ever queue more commands than the host allows.  Instead of
letting drivers either reject or ignore this case handle it in
common code.  Note that various driver use internal constant or
variables that are assigned to both shost->can_queue and checked
in ->change_queue_depth - I did remove those checks as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c       | 8 +-------
 drivers/scsi/3w-9xxx.c                    | 2 --
 drivers/scsi/3w-sas.c                     | 2 --
 drivers/scsi/3w-xxxx.c                    | 2 --
 drivers/scsi/hpsa.c                       | 5 -----
 drivers/scsi/megaraid/megaraid_mbox.c     | 2 --
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 drivers/scsi/scsi_sysfs.c                 | 2 +-
 drivers/scsi/vmw_pvscsi.c                 | 8 +-------
 9 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 98a3035..8d13a19 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2410,14 +2410,8 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 static int
 srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	struct Scsi_Host *shost = sdev->host;
-	int max_depth;
-
-	max_depth = shost->can_queue;
 	if (!sdev->tagged_supported)
-		max_depth = 1;
-	if (qdepth > max_depth)
-		qdepth = max_depth;
+		qdepth = 1;
 	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 02021f5..1cf3703 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -196,8 +196,6 @@ static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
-	if (queue_depth > TW_Q_LENGTH-2)
-		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, queue_depth);
 	return queue_depth;
 } /* End twa_change_queue_depth() */
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index ac0c254..547756b 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -198,8 +198,6 @@ static int twl_change_queue_depth(struct scsi_device *sdev, int queue_depth,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
-	if (queue_depth > TW_Q_LENGTH-2)
-		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, queue_depth);
 	return queue_depth;
 } /* End twl_change_queue_depth() */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 1ec9ad9..261a4c1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -530,8 +530,6 @@ static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
-	if (queue_depth > TW_Q_LENGTH-2)
-		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, queue_depth);
 	return queue_depth;
 } /* End tw_change_queue_depth() */
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 18ea2e1..f3c04b7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4160,11 +4160,6 @@ static int hpsa_change_queue_depth(struct scsi_device *sdev,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -ENOTSUPP;
 
-	if (qdepth < 1)
-		qdepth = 1;
-	else
-		if (qdepth > h->nr_cmds)
-			qdepth = h->nr_cmds;
 	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 6b077d8..d56eb9d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -347,8 +347,6 @@ static int megaraid_change_queue_depth(struct scsi_device *sdev, int qdepth,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
-	if (qdepth > MBOX_MAX_SCSI_CMDS)
-		qdepth = MBOX_MAX_SCSI_CMDS;
 	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 107244c..445a649 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2592,8 +2592,6 @@ static int megasas_change_queue_depth(struct scsi_device *sdev,
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
-	if (queue_depth > sdev->host->can_queue)
-		queue_depth = sdev->host->can_queue;
 	scsi_adjust_queue_depth(sdev, queue_depth);
 
 	return queue_depth;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 35d93b0..bffd5ab 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -877,7 +877,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 
 	depth = simple_strtoul(buf, NULL, 0);
 
-	if (depth < 1)
+	if (depth < 1 || depth > sht->can_queue)
 		return -EINVAL;
 
 	retval = sht->change_queue_depth(sdev, depth,
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4a01c05..03ad24b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -508,20 +508,14 @@ static int pvscsi_change_queue_depth(struct scsi_device *sdev,
 				     int qdepth,
 				     int reason)
 {
-	int max_depth;
-	struct Scsi_Host *shost = sdev->host;
-
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		/*
 		 * We support only changing default.
 		 */
 		return -EOPNOTSUPP;
 
-	max_depth = shost->can_queue;
 	if (!sdev->tagged_supported)
-		max_depth = 1;
-	if (qdepth > max_depth)
-		qdepth = max_depth;
+		qdepth = 1;
 	scsi_adjust_queue_depth(sdev, qdepth);
 
 	if (sdev->inquiry_len > 7)
-- 
1.9.1

