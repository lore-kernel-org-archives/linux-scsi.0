From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 05/10] scsi: updates sdev to add queue_depth ramp up code
Date: Thu, 03 Sep 2009 15:22:53 -0700
Message-ID: <20090903222253.24946.19964.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbZICWWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:55 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

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
 

