From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 15/24] scsi_devinfo: move scsi_get_device_flags into scsi_devinfo.h
Date: Wed, 13 Jan 2016 09:09:50 +0100
Message-ID: <1452672599-9820-16-git-send-email-hare@suse.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbcAMIKT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 03:10:19 -0500
In-Reply-To: <1452672599-9820-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_get_device_flags is just a wrapper for scsi_get_device_flags_keyed.
The latter is exported, the former isn't. And both functions _and_
the 'key' values are only defined in the (internal) scsi_priv.h
header file.
This patch moves these definitions into scsi_devinfo.h to make them
available for other modules.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_devinfo.c       | 21 ---------------------
 drivers/scsi/scsi_priv.h          | 12 ------------
 drivers/scsi/scsi_transport_spi.c |  1 +
 include/scsi/scsi_devinfo.h       | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13..601ff49 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -546,27 +546,6 @@ static int scsi_dev_info_list_add_str(char *dev_list)
 }
 
 /**
- * get_device_flags - get device specific flags from the dynamic device list.
- * @sdev:       &scsi_device to get flags for
- * @vendor:	vendor name
- * @model:	model name
- *
- * Description:
- *     Search the global scsi_dev_info_list (specified by list zero)
- *     for an entry matching @vendor and @model, if found, return the
- *     matching flags value, else return the host or global default
- *     settings.  Called during scan time.
- **/
-int scsi_get_device_flags(struct scsi_device *sdev,
-			  const unsigned char *vendor,
-			  const unsigned char *model)
-{
-	return scsi_get_device_flags_keyed(sdev, vendor, model,
-					   SCSI_DEVINFO_GLOBAL);
-}
-
-
-/**
  * scsi_get_device_flags_keyed - get device specific flags from the dynamic device list
  * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 27b4d0a..b91ffee 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -43,18 +43,6 @@ static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 
 /* scsi_devinfo.c */
 
-/* list of keys for the lists */
-enum {
-	SCSI_DEVINFO_GLOBAL = 0,
-	SCSI_DEVINFO_SPI,
-};
-
-extern int scsi_get_device_flags(struct scsi_device *sdev,
-				 const unsigned char *vendor,
-				 const unsigned char *model);
-extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
-				       const unsigned char *vendor,
-				       const unsigned char *model, int key);
 extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
 					int flags, int key);
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 319868f..cae212b 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_devinfo.h>
 
 #define SPI_NUM_ATTRS 14	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 96e3f56..aca3c80 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -38,4 +38,36 @@
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
 
+/* list of keys for the lists */
+enum {
+	SCSI_DEVINFO_GLOBAL = 0,
+	SCSI_DEVINFO_SPI,
+};
+
+extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+				       const unsigned char *vendor,
+				       const unsigned char *model, int key);
+
+/**
+ * scsi_get_device_flags - get device specific flags from the dynamic
+ *                         device list.
+ * @sdev:       &scsi_device to get flags for
+ * @vendor:	vendor name
+ * @model:	model name
+ *
+ * Description:
+ *     Search the global scsi_dev_info_list (specified by list zero)
+ *     for an entry matching @vendor and @model, if found, return the
+ *     matching flags value, else return the host or global default
+ *     settings.  Called during scan time.
+ **/
+static inline int scsi_get_device_flags(struct scsi_device *sdev,
+					const unsigned char *vendor,
+					const unsigned char *model)
+{
+	return scsi_get_device_flags_keyed(sdev, vendor, model,
+					   SCSI_DEVINFO_GLOBAL);
+}
+
+
 #endif
-- 
1.8.5.6

