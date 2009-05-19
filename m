From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 1/4] scsi-ml: modify change_queue_depth to take in reason why it is being called
Date: Tue, 19 May 2009 00:52:44 -0500
Message-ID: <1242712369913-git-send-email-michaelc@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
 <12427123683166-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZESFww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:52 -0400
In-Reply-To: <12427123683166-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch modifies scsi_host_tematepl->change_queue_depth so that
it takes an argument indicating why it is being called. This will be
used so that if a LLD needs to do some extra processing when
handling queue fulls or later ramp ups, it can do so.

To simplify the review, this patch only modifies scsi-ml. The next
patches will convert each driver.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_sysfs.c |    3 ++-
 include/scsi/scsi_host.h  |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fa4711d..2453948 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -783,7 +783,8 @@ sdev_store_queue_depth_rw(struct device *dev, struct device_attribute *attr,
 	if (depth < 1)
 		return -EINVAL;
 
-	retval = sht->change_queue_depth(sdev, depth);
+	retval = sht->change_queue_depth(sdev, depth,
+					 SCSI_QDEPTH_SYSFS_REQ);
 	if (retval < 0)
 		return retval;
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d123ca8..60495f5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -43,6 +43,13 @@ struct blk_queue_tags;
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
+enum {
+	SCSI_QDEPTH_SYSFS_REQ,	/* user requested change through sysfs */
+	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
+	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshhold event */
+	SCSI_QDEPTH_RAMP_DOWN, 	/* LLD/class requested due to lld/class event */
+};
+
 struct scsi_host_template {
 	struct module *module;
 	const char *name;
@@ -294,7 +301,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* change_queue_depth)(struct scsi_device *, int);
+	int (* change_queue_depth)(struct scsi_device *, int, int);
 
 	/*
 	 * Fill in this function to allow the changing of tag types
-- 
1.6.0.6

