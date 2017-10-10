From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 03/10] mpt3sas: Reduce memory footprints in kdump kernel
Date: Tue, 10 Oct 2017 18:41:16 +0530
Message-ID: <1507641083-20207-4-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

To reduce the memory footprints of the driver in kdump kernel,
 we have made below driver setting when system boots in to kdump kernel,

1. Used single MSI-x vector.
2. Disable RDPQ mode.
3. Set sg_table_size to 32 by default.
4) Set SCSI IO Queue depth to 200.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 844e29c..11c6afe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1990,7 +1990,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	  ioc->cpu_count, max_msix_vectors);
 
 	if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
-		local_max_msix_vectors = 8;
+		local_max_msix_vectors = (reset_devices) ? 1 : 8;
 	else
 		local_max_msix_vectors = max_msix_vectors;
 
@@ -3308,6 +3308,11 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			sg_tablesize = MPT3SAS_SG_DEPTH;
 	}
 
+	/* max sgl entries <= MPT_KDUMP_MIN_PHYS_SEGMENTS in KDUMP mode */
+	if (reset_devices)
+		sg_tablesize = min_t(unsigned short, sg_tablesize,
+		   MPT_KDUMP_MIN_PHYS_SEGMENTS);
+
 	if (sg_tablesize < MPT_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
 	else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
@@ -3340,7 +3345,10 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			ioc->internal_depth, facts->RequestCredit);
 		if (max_request_credit > MAX_HBA_QUEUE_DEPTH)
 			max_request_credit =  MAX_HBA_QUEUE_DEPTH;
-	} else
+	} else if (reset_devices)
+		max_request_credit = min_t(u16, facts->RequestCredit,
+		    (MPT3SAS_KDUMP_SCSI_IO_DEPTH + ioc->internal_depth));
+	else
 		max_request_credit = min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
 
@@ -4446,7 +4454,7 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	if ((facts->IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID))
 		ioc->ir_firmware = 1;
 	if ((facts->IOCCapabilities &
-	      MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE))
+	      MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE) && (!reset_devices))
 		ioc->rdpq_array_capable = 1;
 	if (facts->IOCCapabilities & MPI26_IOCFACTS_CAPABILITY_ATOMIC_REQ)
 		ioc->atomic_desc_capable = 1;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a77bb7d..95ee1c6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -92,6 +92,7 @@
  */
 #define MPT_MAX_PHYS_SEGMENTS	SG_CHUNK_SIZE
 #define MPT_MIN_PHYS_SEGMENTS	16
+#define MPT_KDUMP_MIN_PHYS_SEGMENTS	32
 
 #ifdef CONFIG_SCSI_MPT3SAS_MAX_SGE
 #define MPT3SAS_SG_DEPTH		CONFIG_SCSI_MPT3SAS_MAX_SGE
@@ -111,6 +112,7 @@
 #define MPT3SAS_SATA_QUEUE_DEPTH	32
 #define MPT3SAS_SAS_QUEUE_DEPTH		254
 #define MPT3SAS_RAID_QUEUE_DEPTH	128
+#define MPT3SAS_KDUMP_SCSI_IO_DEPTH	200
 
 #define MPT3SAS_RAID_MAX_SECTORS	8192
 
-- 
2.4.3
