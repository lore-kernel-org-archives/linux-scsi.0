From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 06/15] mpt3sas: Enhanced handling of Sense Buffer.
Date: Fri, 30 Mar 2018 15:07:15 +0530
Message-ID: <1522402644-3016-7-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Enhanced DMA allocation for Sense Buffer, if the allocation does not fit
within same 4GB.Introduced is_MSB_are_same function to check if allocted
buffer within 4GB range or not.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 701e1e7..7f3b684 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4205,6 +4205,32 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * is_MSB_are_same - checks whether all reply queues in a set are
+ *	having same upper 32bits in their base memory address.
+ * @reply_pool_start_address: Base address of a reply queue set
+ * @pool_sz: Size of single Reply Descriptor Post Queues pool size
+ *
+ * Returns 1 if reply queues in a set have a same upper 32bits
+ * in their base memory address,
+ * else 0
+ */
+
+static int
+is_MSB_are_same(long reply_pool_start_address, u32 pool_sz)
+{
+	long reply_pool_end_address;
+	unsigned long bit_divisor_16 = 0x10000;
+
+	reply_pool_end_address = reply_pool_start_address + pool_sz;
+
+	if (((reply_pool_start_address / bit_divisor_16) / (bit_divisor_16)) ==
+		((reply_pool_end_address / bit_divisor_16) / bit_divisor_16))
+		return 1;
+	else
+		return 0;
+}
+
+/**
  * _base_allocate_memory_pools - allocate start of day memory pools
  * @ioc: per adapter object
  *
@@ -4664,6 +4690,37 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->name);
 		goto out;
 	}
+	/* sense buffer requires to be in same 4 gb region.
+	 * Below function will check the same.
+	 * In case of failure, new pci pool will be created with updated
+	 * alignment. Older allocation and pool will be destroyed.
+	 * Alignment will be used such a way that next allocation if
+	 * success, will always meet same 4gb region requirement.
+	 * Actual requirement is not alignment, but we need start and end of
+	 * DMA address must have same upper 32 bit address.
+	 */
+	if (!is_MSB_are_same((long)ioc->sense, sz)) {
+		//Release Sense pool & Reallocate
+		dma_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
+		dma_pool_destroy(ioc->sense_dma_pool);
+		ioc->sense = NULL;
+
+		ioc->sense_dma_pool =
+			dma_pool_create("sense pool", &ioc->pdev->dev, sz,
+						roundup_pow_of_two(sz), 0);
+		if (!ioc->sense_dma_pool) {
+			pr_err(MPT3SAS_FMT "sense pool: pci_pool_create failed\n",
+					ioc->name);
+			goto out;
+		}
+		ioc->sense = dma_pool_alloc(ioc->sense_dma_pool, GFP_KERNEL,
+				&ioc->sense_dma);
+		if (!ioc->sense) {
+			pr_err(MPT3SAS_FMT "sense pool: pci_pool_alloc failed\n",
+					ioc->name);
+			goto out;
+		}
+	}
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 	    "sense pool(0x%p): depth(%d), element_size(%d), pool_size"
 	    "(%d kB)\n", ioc->name, ioc->sense, ioc->scsiio_depth,
-- 
1.8.3.1
