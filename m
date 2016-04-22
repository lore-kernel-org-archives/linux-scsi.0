From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 4/5] mpt3sas: Set maximum transfer length per IO to 4MB for VDs
Date: Fri, 22 Apr 2016 16:53:13 +0530
Message-ID: <1461324194-5789-5-git-send-email-chaitra.basappa@broadcom.com>
References: <1461324194-5789-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35332 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbcDVLXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2016 07:23:46 -0400
Received: by mail-pf0-f176.google.com with SMTP id n1so40671053pfn.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2016 04:23:46 -0700 (PDT)
In-Reply-To: <1461324194-5789-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>

Set maximum transfer length per IO on RAID volumes
to 4MB by setting VD's queue's max_sector to 8192.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 32580b5..a16e7f9 100644
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

