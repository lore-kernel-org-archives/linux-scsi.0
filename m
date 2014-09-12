From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 01/18][SCSI] mpt2sas: Added driver module parameter max_msix_vectors
Date: Fri, 12 Sep 2014 15:35:16 +0530
Message-ID: <1410516333-3678-2-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added driver module parameter max_msix_vectors. Using this
module parameter the maximum number of MSI-X vectors could be set.

The number of MSI-X vectors used would be the minimum of MSI-X vectors
supported by the HBA, the number of CPU cores and the value set to
max_msix_vectors module parameters.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 2f262be..982703a 100644
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
@@ -1402,6 +1406,16 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
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
2.0.2
