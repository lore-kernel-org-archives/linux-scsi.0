From: <sreekanth.reddy@lsi.com>
Subject: [PATCH 03/09] [SCSI] mpt2sas : Fix for Driver oops, when loading
 driver with max_queue_depth command line option to a very small value
Date: Tue, 17 Jul 2012 15:57:05 +0530
Message-ID: <20120717102705.GA7371@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46762 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964Ab2GQK0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:26:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, jejb@kernel.org, stable@vger.kernel.org
Cc: sreekanth.reddy@lsi.com

If the specified max_queue_depth setting is less than the expected number of
internal commands, then driver will calculate the queue depth size to a negitive
number. This negitive number is actually a very large number because variable is
unsigned 16bit integer. So, the driver will ask for a very large amount of
memory for message frames and resulting into oops as memory allocation routines
will not able to handle such a large request.

So, in order to limit this kind of oops, The driver need to set the max_queue_depth
to a scsi mid layer's can_queue value. Then the overall message frames required for
IO is minimum of either (max_queue_depth plus internal commands) or the IOC global
credits.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Cc: <stable@kernel.org>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ffa32ad..f7c1394 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2424,10 +2424,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 
 	/* command line tunables  for max controller queue depth */
-	if (max_queue_depth != -1)
-		max_request_credit = (max_queue_depth < facts->RequestCredit)
-		    ? max_queue_depth : facts->RequestCredit;
-	else
+	if (max_queue_depth != -1 && max_queue_depth != 0) {
+		max_request_credit = min_t(u16, max_queue_depth +
+			ioc->hi_priority_depth + ioc->internal_depth,
+			facts->RequestCredit);
+		if (max_request_credit > MAX_HBA_QUEUE_DEPTH)
+			max_request_credit =  MAX_HBA_QUEUE_DEPTH;
+	} else
 		max_request_credit = min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
 
@@ -2502,7 +2505,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	ioc->shost->can_queue = ioc->scsiio_depth;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
 	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
 
