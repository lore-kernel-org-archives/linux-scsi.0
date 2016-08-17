From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 3/3] sas: remove is_sas_attached()
Date: Wed, 17 Aug 2016 10:40:04 +0200
Message-ID: <b65f3b27039e27c9d4aeff8451fb88855490a1d6.1471423022.git.jthumshirn@suse.de>
References: <cover.1471423022.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471423022.git.jthumshirn@suse.de>
In-Reply-To: <cover.1471423022.git.jthumshirn@suse.de>
References: <cover.1471423022.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

As there are no more users of is_sas_attached() left, remove it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 16 ----------------
 include/scsi/scsi_transport_sas.h |  6 ------
 2 files changed, 22 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3f0ff07..60b651b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -341,22 +341,6 @@ static int do_sas_phy_delete(struct device *dev, void *data)
 }
 
 /**
- * is_sas_attached - check if device is SAS attached
- * @sdev: scsi device to check
- *
- * returns true if the device is SAS attached
- */
-int is_sas_attached(struct scsi_device *sdev)
-{
-	struct Scsi_Host *shost = sdev->host;
-
-	return shost->transportt->host_attrs.ac.class ==
-		&sas_host_class.class;
-}
-EXPORT_SYMBOL(is_sas_attached);
-
-
-/**
  * sas_remove_children  -  tear down a devices SAS data structures
  * @dev:	device belonging to the sas object
  *
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 8d0d2fb..4d287cb 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -11,17 +11,11 @@ struct sas_rphy;
 struct request;
 
 #if !IS_ENABLED(CONFIG_SCSI_SAS_ATTRS)
-static inline int is_sas_attached(struct scsi_device *sdev)
-{
-	return 0;
-}
-
 static inline int scsi_is_sas_rphy(const struct device *sdev)
 {
 	return 0;
 }
 #else
-extern int is_sas_attached(struct scsi_device *sdev);
 extern int scsi_is_sas_rphy(const struct device *);
 #endif
 
-- 
1.8.5.6
