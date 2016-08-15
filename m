From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 2/2] sas: remove is_sas_attached()
Date: Mon, 15 Aug 2016 10:52:46 +0200
Message-ID: <9f879cf107e9474d2a03ef217d85ae3df10720d6.1471251131.git.jthumshirn@suse.de>
References: <ac01dba641b71f6e61764422ba4a3fa38d636d14.1471251131.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ac01dba641b71f6e61764422ba4a3fa38d636d14.1471251131.git.jthumshirn@suse.de>
In-Reply-To: <ac01dba641b71f6e61764422ba4a3fa38d636d14.1471251131.git.jthumshirn@suse.de>
References: <ac01dba641b71f6e61764422ba4a3fa38d636d14.1471251131.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

As there are no more users of is_sas_attached() left, remove it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 16 ----------------
 include/scsi/scsi_transport_sas.h |  9 ---------
 2 files changed, 25 deletions(-)

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
index 13c0b2b..140eeee 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -10,15 +10,6 @@ struct scsi_transport_template;
 struct sas_rphy;
 struct request;
 
-#if !IS_ENABLED(CONFIG_SCSI_SAS_ATTRS)
-static inline int is_sas_attached(struct scsi_device *sdev)
-{
-	return 0;
-}
-#else
-extern int is_sas_attached(struct scsi_device *sdev);
-#endif
-
 static inline int sas_protocol_ata(enum sas_protocol proto)
 {
 	return ((proto & SAS_PROTOCOL_SATA) ||
-- 
1.8.5.6
