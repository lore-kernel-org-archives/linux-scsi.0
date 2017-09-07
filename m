From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 04/12] scsi: sd_zbc: Move zbc disk declarations to sd_zbc.h
Date: Fri,  8 Sep 2017 01:16:32 +0900
Message-ID: <20170907161640.30465-5-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Introduce sd_zbc.h to gather ZBC disk related declarations and avoid
cluttering sd.h.

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     |  1 +
 drivers/scsi/sd.h     | 48 ---------------------------------------
 drivers/scsi/sd_zbc.c |  7 +-----
 drivers/scsi/sd_zbc.h | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 54 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c5d05b1c58a5..1cd113df2d3a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -68,6 +68,7 @@
 #include <scsi/scsicam.h>
 
 #include "sd.h"
+#include "sd_zbc.h"
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 99c4dde9b6bf..c9a627e7eebd 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -277,52 +277,4 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 	return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
 }
 
-#ifdef CONFIG_BLK_DEV_ZONED
-
-extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
-extern void sd_zbc_remove(struct scsi_disk *sdkp);
-extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
-extern void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
-extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
-extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
-extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
-			    struct scsi_sense_hdr *sshdr);
-
-#else /* CONFIG_BLK_DEV_ZONED */
-
-static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
-				    unsigned char *buf)
-{
-	return 0;
-}
-
-static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
-
-static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
-
-static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
-{
-	/* Let the drive fail requests */
-	return BLKPREP_OK;
-}
-
-static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd) {}
-
-static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
-{
-	return BLKPREP_INVALID;
-}
-
-static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
-{
-	return BLKPREP_INVALID;
-}
-
-static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
-				   unsigned int good_bytes,
-				   struct scsi_sense_hdr *sshdr) {}
-
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d445a57f99bd..a62f8e256a26 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -28,14 +28,9 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_driver.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_eh.h>
 
 #include "sd.h"
-#include "scsi_priv.h"
+#include "sd_zbc.h"
 
 /**
  * Convert a zone descriptor to a zone struct.
diff --git a/drivers/scsi/sd_zbc.h b/drivers/scsi/sd_zbc.h
new file mode 100644
index 000000000000..5e7ecc9b2966
--- /dev/null
+++ b/drivers/scsi/sd_zbc.h
@@ -0,0 +1,62 @@
+#ifndef _SCSI_DISK_ZBC_H
+#define _SCSI_DISK_ZBC_H
+
+#ifdef CONFIG_BLK_DEV_ZONED
+
+int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
+void sd_zbc_remove(struct scsi_disk *sdkp);
+void sd_zbc_print_zones(struct scsi_disk *sdkp);
+
+int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
+void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
+
+int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
+int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
+void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
+		     struct scsi_sense_hdr *sshdr);
+
+#else /* CONFIG_BLK_DEV_ZONED */
+
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
+				    unsigned char *buf)
+{
+	return 0;
+}
+
+static inline void sd_zbc_remove(struct scsi_disk *sdkp)
+{
+}
+
+static inline void sd_zbc_print_zones(struct scsi_disk *sdkp)
+{
+}
+
+static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
+{
+	/* Let the drive fail requests */
+	return BLKPREP_OK;
+}
+
+static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
+{
+}
+
+static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_INVALID;
+}
+
+static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_INVALID;
+}
+
+static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
+				   unsigned int good_bytes,
+				   struct scsi_sense_hdr *sshdr)
+{
+}
+
+#endif /* CONFIG_BLK_DEV_ZONED */
+
+#endif /* _SCSI_DISK_ZBC_H */
-- 
2.13.5
