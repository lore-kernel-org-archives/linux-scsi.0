From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/20] mpt2sas: Added support to set the TimeStamp when sending ioc_init
Date: Wed, 23 Sep 2009 17:29:29 +0530
Message-ID: <20090923115929.GO6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41473 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbZIWMWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:22:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Added support to set the TimeStamp when sending ioc_init.
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index e92934c..112da29 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -57,6 +57,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sort.h>
 #include <linux/io.h>
+#include <linux/time.h>
 
 #include "mpt2sas_base.h"
 
@@ -2946,6 +2947,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	Mpi2IOCInitRequest_t mpi_request;
 	Mpi2IOCInitReply_t mpi_reply;
 	int r;
+	struct timeval current_time;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
@@ -2996,6 +2998,13 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	    cpu_to_le32(ioc->reply_post_free_dma);
 #endif
 
+	/* This time stamp specifies number of milliseconds
+	 * since epoch ~ midnight January 1, 1970.
+	 */
+	do_gettimeofday(&current_time);
+	mpi_request.TimeStamp = (current_time.tv_sec * 1000) +
+	    (current_time.tv_usec >> 3);
+
 	if (ioc->logging_level & MPT_DEBUG_INIT) {
 		u32 *mfp;
 		int i;
