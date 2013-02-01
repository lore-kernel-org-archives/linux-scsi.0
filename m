From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 7/8] [SCSI] mpt2sas : Calulate the Reply post queue depth
 calculation as per the MPI spec
Date: Fri, 1 Feb 2013 22:02:04 +0530
Message-ID: <20130201163204.GA21721@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53774 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab3BAFh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:37:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

Reply post queue depth calculation is not as per the MPI spec.

So, Modified the mpt2sas driver code to calculate the Reply post queue depth is as per
the MPI spec.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index fc91a5a..47763b0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2487,23 +2487,25 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	/* reply free queue sizing - taking into account for 64 FW events */
 	ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 
+	/* calculate reply descriptor post queue depth */
+	ioc->reply_post_queue_depth = ioc->hba_queue_depth +
+					ioc->reply_free_queue_depth +  1 ;
 	/* align the reply post queue on the next 16 count boundary */
-	if (!ioc->reply_free_queue_depth % 16)
-		ioc->reply_post_queue_depth = ioc->reply_free_queue_depth + 16;
-	else
-		ioc->reply_post_queue_depth = ioc->reply_free_queue_depth +
-				32 - (ioc->reply_free_queue_depth % 16);
+	if (ioc->reply_post_queue_depth % 16)
+		ioc->reply_post_queue_depth += 16 - \
+			(ioc->reply_post_queue_depth % 16);
+
+
 	if (ioc->reply_post_queue_depth >
 	    facts->MaxReplyDescriptorPostQueueDepth) {
-		ioc->reply_post_queue_depth = min_t(u16,
-		    (facts->MaxReplyDescriptorPostQueueDepth -
-		    (facts->MaxReplyDescriptorPostQueueDepth % 16)),
-		    (ioc->hba_queue_depth - (ioc->hba_queue_depth % 16)));
-		ioc->reply_free_queue_depth = ioc->reply_post_queue_depth - 16;
-		ioc->hba_queue_depth = ioc->reply_free_queue_depth - 64;
+		ioc->reply_post_queue_depth =
+			facts->MaxReplyDescriptorPostQueueDepth -
+		    (facts->MaxReplyDescriptorPostQueueDepth % 16);
+		ioc->hba_queue_depth =
+			((ioc->reply_post_queue_depth - 64) / 2) - 1;
+		ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 	}
 
-
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scatter gather: "
 	    "sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), "
 	    "chains_per_io(%d)\n", ioc->name, ioc->max_sges_in_main_message,
