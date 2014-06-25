From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter
 max_msix_vectors
Date: Wed, 25 Jun 2014 16:00:28 +0530
Message-ID: <20140625103028.GA12870@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:23962
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755990AbaFYKev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 06:34:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com

Added driver module parameter max_msix_vectors. Using this
module parameter the maximum number of MSI-X vectors could be set.

The number of MSI-X vectors used would be the minimum of MSI-X vectors
supported by the HBA, the number of CPU cores and the value set to
max_msix_vectors module parameters.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..ed810fb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -80,6 +80,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
+static int max_msix_vectors = -1;
+module_param(max_msix_vectors, int, 0);
+MODULE_PARM_DESC(max_msix_vectors, " max msix vectors ");
+
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -1420,6 +1424,16 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
 	    ioc->msix_vector_count);
 
+	if (max_msix_vectors > 0) {
+		ioc->reply_queue_count = min_t(int, max_msix_vectors,
+		    ioc->reply_queue_count);
+		ioc->msix_vector_count = ioc->reply_queue_count;
+	}
+
+	printk(MPT2SAS_INFO_FMT
+	"MSI-X vectors supported: %d, no of cores: %d, max_msix_vectors: %d\n",
+	 ioc->name, ioc->msix_vector_count, ioc->cpu_count, max_msix_vectors);
+
 	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
 	    GFP_KERNEL);
 	if (!entries) {
-- 
1.7.1

