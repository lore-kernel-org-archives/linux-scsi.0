From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 05/10] libata: separate ATAPI code
Date: Fri,  9 Nov 2012 14:51:57 +0800
Message-ID: <1352443922-13734-6-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

The atapi_eh_tur and atapi_eh_request_sense can be reused by ZPODD
code, so separate them out to a file named libata-atapi.c, and the
Makefile is modified accordingly. No functional changes should result
from this commit.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/Makefile       |  2 +-
 drivers/ata/libata-atapi.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-eh.c    | 85 --------------------------------------------
 drivers/ata/libata.h       |  4 +++
 4 files changed, 93 insertions(+), 86 deletions(-)
 create mode 100644 drivers/ata/libata-atapi.c

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 85e3de4..36377f9 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -103,7 +103,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
-libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
+libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-atapi.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/libata-atapi.c b/drivers/ata/libata-atapi.c
new file mode 100644
index 0000000..28684ae
--- /dev/null
+++ b/drivers/ata/libata-atapi.c
@@ -0,0 +1,88 @@
+#include <linux/libata.h>
+#include <scsi/scsi_cmnd.h>
+#include "libata.h"
+
+/**
+ *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
+ *	@dev: target ATAPI device
+ *	@r_sense_key: out parameter for sense_key
+ *
+ *	Perform ATAPI TEST_UNIT_READY.
+ *
+ *	LOCKING:
+ *	EH context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask on failure.
+ */
+unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
+{
+	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_NODATA;
+
+	err_mask = ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
+	if (err_mask == AC_ERR_DEV)
+		*r_sense_key = tf.feature >> 4;
+	return err_mask;
+}
+
+/**
+ *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
+ *	@dev: device to perform REQUEST_SENSE to
+ *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
+ *	@dfl_sense_key: default sense key to use
+ *
+ *	Perform ATAPI REQUEST_SENSE after the device reported CHECK
+ *	SENSE.  This function is EH helper.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask on failure
+ */
+unsigned int atapi_eh_request_sense(struct ata_device *dev,
+				    u8 *sense_buf, u8 dfl_sense_key)
+{
+	u8 cdb[ATAPI_CDB_LEN] =	{
+		REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };
+	struct ata_port *ap = dev->link->ap;
+	struct ata_taskfile tf;
+
+	DPRINTK("ATAPI request sense\n");
+
+	/* FIXME: is this needed? */
+	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
+
+	/* initialize sense_buf with the error register,
+	 * for the case where they are -not- overwritten
+	 */
+	sense_buf[0] = 0x70;
+	sense_buf[2] = dfl_sense_key;
+
+	/* some devices time out if garbage left in tf */
+	ata_tf_init(dev, &tf);
+
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+
+	/* is it pointless to prefer PIO for "safety reasons"? */
+	if (ap->flags & ATA_FLAG_PIO_DMA) {
+		tf.protocol = ATAPI_PROT_DMA;
+		tf.feature |= ATAPI_PKT_DMA;
+	} else {
+		tf.protocol = ATAPI_PROT_PIO;
+		tf.lbam = SCSI_SENSE_BUFFERSIZE;
+		tf.lbah = 0;
+	}
+
+	return ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
+				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
+}
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e60437c..6487b88 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1579,91 +1579,6 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 }
 
 /**
- *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
- *	@dev: target ATAPI device
- *	@r_sense_key: out parameter for sense_key
- *
- *	Perform ATAPI TEST_UNIT_READY.
- *
- *	LOCKING:
- *	EH context (may sleep).
- *
- *	RETURNS:
- *	0 on success, AC_ERR_* mask on failure.
- */
-static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
-{
-	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
-	struct ata_taskfile tf;
-	unsigned int err_mask;
-
-	ata_tf_init(dev, &tf);
-
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-	tf.command = ATA_CMD_PACKET;
-	tf.protocol = ATAPI_PROT_NODATA;
-
-	err_mask = ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
-	if (err_mask == AC_ERR_DEV)
-		*r_sense_key = tf.feature >> 4;
-	return err_mask;
-}
-
-/**
- *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
- *	@dev: device to perform REQUEST_SENSE to
- *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
- *	@dfl_sense_key: default sense key to use
- *
- *	Perform ATAPI REQUEST_SENSE after the device reported CHECK
- *	SENSE.  This function is EH helper.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, AC_ERR_* mask on failure
- */
-static unsigned int atapi_eh_request_sense(struct ata_device *dev,
-					   u8 *sense_buf, u8 dfl_sense_key)
-{
-	u8 cdb[ATAPI_CDB_LEN] =
-		{ REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };
-	struct ata_port *ap = dev->link->ap;
-	struct ata_taskfile tf;
-
-	DPRINTK("ATAPI request sense\n");
-
-	/* FIXME: is this needed? */
-	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
-
-	/* initialize sense_buf with the error register,
-	 * for the case where they are -not- overwritten
-	 */
-	sense_buf[0] = 0x70;
-	sense_buf[2] = dfl_sense_key;
-
-	/* some devices time out if garbage left in tf */
-	ata_tf_init(dev, &tf);
-
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-	tf.command = ATA_CMD_PACKET;
-
-	/* is it pointless to prefer PIO for "safety reasons"? */
-	if (ap->flags & ATA_FLAG_PIO_DMA) {
-		tf.protocol = ATAPI_PROT_DMA;
-		tf.feature |= ATAPI_PKT_DMA;
-	} else {
-		tf.protocol = ATAPI_PROT_PIO;
-		tf.lbam = SCSI_SENSE_BUFFERSIZE;
-		tf.lbah = 0;
-	}
-
-	return ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
-				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
-}
-
-/**
  *	ata_eh_analyze_serror - analyze SError for a failed port
  *	@link: ATA link to analyze SError for
  *
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 55ad37e..5d68210 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -247,4 +247,8 @@ static inline void zpodd_deinit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
 #endif /* CONFIG_SATA_ZPODD */
 
+/* libata-atapi.c */
+unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
+unsigned int atapi_eh_request_sense(struct ata_device *dev, u8 *sense_buf, u8 dfl_sense_key);
+
 #endif /* __LIBATA_H__ */
-- 
1.7.12.4

