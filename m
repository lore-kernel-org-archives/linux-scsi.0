From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 07/11] libata: separate ATAPI code
Date: Mon, 29 Oct 2012 17:01:34 +0800
Message-ID: <1351501298-3716-8-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399Ab2J2JCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2012 05:02:03 -0400
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

The atapi_eh_tur and atapi_eh_request_sense can be reused by ZPODD
code, so separate them out to a file named libata-atapi.c. A header
file libata-atapi.h is added and the Makefile is modified accordingly.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/Makefile       |  2 +-
 drivers/ata/libata-atapi.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-atapi.h |  7 ++++
 drivers/ata/libata-eh.c    | 86 +-------------------------------------------
 4 files changed, 97 insertions(+), 86 deletions(-)
 create mode 100644 drivers/ata/libata-atapi.c
 create mode 100644 drivers/ata/libata-atapi.h

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index a5120ff..335407c 100644
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
diff --git a/drivers/ata/libata-atapi.h b/drivers/ata/libata-atapi.h
new file mode 100644
index 0000000..4d2e441
--- /dev/null
+++ b/drivers/ata/libata-atapi.h
@@ -0,0 +1,7 @@
+#ifndef __LIBATA_ATAPI_H__
+#define __LIBATA_ATAPI_H__
+
+unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
+unsigned int atapi_eh_request_sense(struct ata_device *dev, u8 *sense_buf, u8 dfl_sense_key);
+
+#endif
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 2659894..c2f2357 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -47,6 +47,7 @@
 #include <linux/libata.h>
 
 #include "libata.h"
+#include "libata-atapi.h"
 
 enum {
 	/* speed down verdicts */
@@ -1579,91 +1580,6 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
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
-- 
1.7.12.4

