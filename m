From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] osdblk: Adjust queue limits to lower device's limits
Date: Thu, 21 May 2009 17:11:28 +0300
Message-ID: <4A156110.3080900@panasas.com>
References: <4A155FF6.3060005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:10925 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755477AbZEUOLb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 10:11:31 -0400
In-Reply-To: <4A155FF6.3060005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Jens Axboe <jens.axboe@oracle.com>


call blk_queue_stack_limits() to copy queue limits from
the underline osd scsi_device. This is absolutely needed
because osdblk cannot sleep when allocating a lower-request and
therefore cannot be bouncing.

TODO: Dynamic changes of limits to the lower device queue
will not reflect in the upper driver

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/block/osdblk.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 531d234..0da8ce0 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -66,6 +66,7 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_attributes.h>
 #include <scsi/osd_sec.h>
+#include <scsi/scsi_device.h>
 
 #define DRV_NAME "osdblk"
 #define PFX DRV_NAME ": "
@@ -410,6 +411,12 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 		return rc;
 	}
 
+	/* Set our limits to the lower device limits, because osdblk cannot
+	 * sleep when allocating a lower-request and therefore cannot be
+	 * bouncing.
+	 */
+	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
+
 	blk_queue_prep_rq(q, blk_queue_start_tag);
 	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
 
-- 
1.6.2.1


