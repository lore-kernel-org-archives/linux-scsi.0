From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 01/10] scsi-ml: modify change_queue_depth to take in reason
	why it is being called
Date: Thu, 03 Sep 2009 15:22:31 -0700
Message-ID: <20090903222231.24946.87680.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbZICWWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:31 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch modifies scsi_host_tematepl->change_queue_depth so that
it takes an argument indicating why it is being called. This will be
used so that if a LLD needs to do some extra processing when
handling queue fulls or later ramp ups, it can do so.

To simplify the review, this patch only modifies scsi-ml. The next
patches will convert each driver.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/scsi_sysfs.c |    3 ++-
 include/scsi/scsi_host.h  |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 91482f2..4530626 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -766,7 +766,8 @@ sdev_store_queue_depth_rw(struct device *dev, struct device_attribute *attr,
 	if (depth < 1)
 		return -EINVAL;
 
-	retval = sht->change_queue_depth(sdev, depth);
+	retval = sht->change_queue_depth(sdev, depth,
+					 SCSI_QDEPTH_DEFAULT);
 	if (retval < 0)
 		return retval;
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..854d510 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -43,6 +43,12 @@ struct blk_queue_tags;
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
+enum {
+	SCSI_QDEPTH_DEFAULT,	/* default requested change, e.g. from sysfs */
+	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
+	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshhold event */
+};
+
 struct scsi_host_template {
 	struct module *module;
 	const char *name;
@@ -294,7 +300,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* change_queue_depth)(struct scsi_device *, int);
+	int (* change_queue_depth)(struct scsi_device *, int, int);
 
 	/*
 	 * Fill in this function to allow the changing of tag types

