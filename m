From: Vasu Dev <vasu.dev@intel.com>
Subject: [RFC PATCH 5/9] scsi: updates sdev to add queue_depth ramp up code
Date: Wed, 26 Aug 2009 11:03:42 -0700
Message-ID: <20090826180341.23396.63480.stgit@vi1.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZHZSDl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:03:41 -0400
In-Reply-To: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Current FC HBA queue_depth ramp up code depends on :-

	1. last queue full time.
	2. last queue ramp up time.
	3. ramp up period (time interval)

The sdev already  has last_queue_full_time field to track last
queue full time but stored value is truncated by last four bits.

So this patch updates last_queue_full_time without truncating
last 4 bits to store complete value and then updates its only
current usages in scsi_track_queue_full to ignore last four bits
to keep current usages same. This will allow same
last_queue_full_time used by scsi_track_queue_full and queue_depth
ramp up code.

Adds additional new sdev fields for above 2 and 3 items.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/scsi.c        |   10 ++++++++--
 include/scsi/scsi_device.h |    6 +++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b6e0307..bffaa9c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -937,10 +937,16 @@ EXPORT_SYMBOL(scsi_adjust_queue_depth);
  */
 int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 {
-	if ((jiffies >> 4) == sdev->last_queue_full_time)
+
+	/*
+	 * Don't let QUEUE_FULLs on the same
+	 * jiffies count, they could all be from
+	 * same event.
+	 */
+	if ((jiffies >> 4) == (sdev->last_queue_full_time >> 4))
 		return 0;
 
-	sdev->last_queue_full_time = (jiffies >> 4);
+	sdev->last_queue_full_time = jiffies;
 	if (sdev->last_queue_full_depth != depth) {
 		sdev->last_queue_full_count = 1;
 		sdev->last_queue_full_depth = depth;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9af48cb..041d4f9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -83,9 +83,9 @@ struct scsi_device {
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short last_queue_full_depth; /* These two are used by */
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
-	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same
-					   jiffie count on our counter, they
-					   could all be from the same event. */
+	unsigned long last_queue_full_time;	/* last queue full time */
+	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
+	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
 	unsigned int id, lun, channel;
 

