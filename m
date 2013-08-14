From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
 max_msix_vectors
Date: Wed, 14 Aug 2013 18:23:20 +0530
Message-ID: <20130814125320.GA3402@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:52495
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932315Ab3HNMxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Aug 2013 08:53:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com

Added a driver module parameter max_msix_vectors. Using this module parameter
the maximum number of MSI-X vectors could be set.

The number of MSI-X vectors used would be the minimum of MSI-X vectors supported by
the HBA, the number of CPU cores and the value set to max_msix_vectors module parameter.

The default value of this module parameter is set to 8. The default value of this parameter
is set to 8 inorder to reduce the amount of memory required for Reply Descriptor Post queue.
This is because with the higher MSI-X vectors, some times kernel is not able to allocate the
requested amount of memory and crash is observed. To overcome this problem,
the default value is set to 8.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
--- 

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a32d63b..d40ba0b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -82,6 +82,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
+static int max_msix_vectors = 8;
+module_param(max_msix_vectors, int, 0);
+MODULE_PARM_DESC(max_msix_vectors,
+	" max msix vectors - (default=8)");
 
 static int mpt3sas_fwfault_debug;
 MODULE_PARM_DESC(mpt3sas_fwfault_debug,
@@ -1723,6 +1727,16 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
 	    ioc->msix_vector_count);
 
+	printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
+	  ": %d, max_msix_vectors: %d\n", ioc->name, ioc->msix_vector_count,
+	  ioc->cpu_count, max_msix_vectors);
+
+	if (max_msix_vectors > 0) {
+		ioc->reply_queue_count = min_t(int, max_msix_vectors,
+			ioc->reply_queue_count);
+		ioc->msix_vector_count = ioc->reply_queue_count;
+	}
+
 	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
 	    GFP_KERNEL);
 	if (!entries) {

