From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 5/6] mpt3sas: Set maximum transfer length per IO to 4MB for VDs
Date: Fri,  6 May 2016 14:29:30 +0530
Message-ID: <1462525171-6877-6-git-send-email-chaitra.basappa@broadcom.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Set maximum transfer length per IO on RAID volumes
to 4MB by setting VD's queue's max_sector to 8192.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index aa918aa..e1befba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -112,6 +112,8 @@
 #define MPT3SAS_SAS_QUEUE_DEPTH		254
 #define MPT3SAS_RAID_QUEUE_DEPTH	128
 
+#define MPT3SAS_RAID_MAX_SECTORS	8192
+
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
 #define MPT_STRING_LENGTH		64
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0fea937..abd8717 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1911,6 +1911,14 @@ scsih_slave_configure(struct scsi_device *sdev)
 			    (unsigned long long)raid_device->wwid,
 			    raid_device->num_pds, ds);
 
+		if (shost->max_sectors > MPT3SAS_RAID_MAX_SECTORS) {
+			blk_queue_max_hw_sectors(sdev->request_queue,
+						MPT3SAS_RAID_MAX_SECTORS);
+			sdev_printk(KERN_INFO, sdev,
+					"Set queue's max_sector to: %u\n",
+						MPT3SAS_RAID_MAX_SECTORS);
+		}
+
 		scsih_change_queue_depth(sdev, qdepth);
 
 		/* raid transport support */
-- 
1.8.3.1
