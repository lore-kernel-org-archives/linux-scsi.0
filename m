From: Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH] Make sure that scsi_request_fn() isn't called recursively forever
Date: Sun, 10 Feb 2008 14:02:32 +0100
Message-ID: <878x1tnevr.fsf_-_@denkblock.local>
References: <87bq6pkczj.fsf@denkblock.local>
	<1202599854.4254.43.camel@localhost.localdomain>
	<87ejblnf94.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:51788 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbYBJNCn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 08:02:43 -0500
In-Reply-To: <87ejblnf94.fsf@denkblock.local> (Elias Oltmanns's message of
	"Sun, 10 Feb 2008 13:54:31 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Currently, scsi_dev_queue_ready() and scsi_host_queue_ready() decrease the
device_blocked or host_blocked counter respectively *before* they determine
the right return value. If the device can't accept a request for some
reason and max_host_blocked or max_device_blocked has been set to 1, this
may lead to scsi_request_fn() being called recursively without giving the
low level driver a chance to unjam the device.

This patch applies to 2.6.24. Please include it in the stable updates as
well.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/scsi/scsi_lib.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a9ac5b1..7513bed 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1357,14 +1357,12 @@ static inline int scsi_dev_queue_ready(s
 		/*
 		 * unblock after device_blocked iterates to zero
 		 */
-		if (--sdev->device_blocked == 0) {
+		if (sdev->device_blocked-- == 1)
 			SCSI_LOG_MLQUEUE(3,
 				   sdev_printk(KERN_INFO, sdev,
-				   "unblocking device at zero depth\n"));
-		} else {
-			blk_plug_device(q);
-			return 0;
-		}
+				   "device will be unblocked next time\n"));
+		blk_plug_device(q);
+		return 0;
 	}
 	if (sdev->device_blocked)
 		return 0;
@@ -1389,14 +1387,12 @@ static inline int scsi_host_queue_ready(
 		/*
 		 * unblock after host_blocked iterates to zero
 		 */
-		if (--shost->host_blocked == 0) {
+		if (shost->host_blocked-- == 1)
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d unblocking host at zero depth\n",
+				printk("scsi%d host will be unblocked next time\n",
 					shost->host_no));
-		} else {
-			blk_plug_device(q);
-			return 0;
-		}
+		blk_plug_device(q);
+		return 0;
 	}
 	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
 	    shost->host_blocked || shost->host_self_blocked) {
