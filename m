From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v4 3/4] ata: Enabling ATA Command Priorities
Date: Thu, 13 Oct 2016 12:53:52 -0700
Message-ID: <1476388433-2539-4-git-send-email-adam.manzanares@hgst.com>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch checks to see if an ATA device supports NCQ command priorities.
If so and the user has specified an iocontext that indicates IO_PRIO_CLASS_RT
then we build a tf with a high priority command.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 drivers/ata/libata-core.c | 35 ++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c |  6 +++++-
 drivers/ata/libata.h      |  2 +-
 include/linux/ata.h       |  6 ++++++
 include/linux/libata.h    | 18 ++++++++++++++++++
 5 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 223a770..181b530 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -739,6 +739,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  *	@n_block: Number of blocks
  *	@tf_flags: RW/FUA etc...
  *	@tag: tag
+ *	@class: IO priority class
  *
  *	LOCKING:
  *	None.
@@ -753,7 +754,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  */
 int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		    u64 block, u32 n_block, unsigned int tf_flags,
-		    unsigned int tag)
+		    unsigned int tag, int class)
 {
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->flags |= tf_flags;
@@ -785,6 +786,12 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		tf->device = ATA_LBA;
 		if (tf->flags & ATA_TFLAG_FUA)
 			tf->device |= 1 << 7;
+
+		if (ata_ncq_prio_enabled(dev)) {
+			if (class == IOPRIO_CLASS_RT)
+				tf->hob_nsect |= ATA_PRIO_HIGH <<
+						 ATA_SHIFT_PRIO;
+		}
 	} else if (dev->flags & ATA_DFLAG_LBA) {
 		tf->flags |= ATA_TFLAG_LBA;
 
@@ -2156,6 +2163,30 @@ static void ata_dev_config_ncq_non_data(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_config_ncq_prio(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned int err_mask;
+
+	err_mask = ata_read_log_page(dev,
+				     ATA_LOG_SATA_ID_DEV_DATA,
+				     ATA_LOG_SATA_SETTINGS,
+				     ap->sector_buf,
+				     1);
+	if (err_mask) {
+		ata_dev_dbg(dev,
+			    "failed to get Identify Device data, Emask 0x%x\n",
+			    err_mask);
+		return;
+	}
+
+	if (ap->sector_buf[ATA_LOG_NCQ_PRIO_OFFSET] & BIT(3))
+		dev->flags |= ATA_DFLAG_NCQ_PRIO;
+	else
+		ata_dev_dbg(dev, "SATA page does not support priority\n");
+
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2205,6 +2236,8 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 			ata_dev_config_ncq_send_recv(dev);
 		if (ata_id_has_ncq_non_data(dev->id))
 			ata_dev_config_ncq_non_data(dev);
+		if (ata_id_has_ncq_prio(dev->id))
+			ata_dev_config_ncq_prio(dev);
 	}
 
 	return 0;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e207b33..18629e8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -50,6 +50,7 @@
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
 #include <asm/unaligned.h>
+#include <linux/ioprio.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -1757,6 +1758,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
+	struct request *rq = scmd->request;
+	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
 	u32 n_block;
@@ -1823,7 +1826,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	qc->nbytes = n_block * scmd->device->sector_size;
 
 	rc = ata_build_rw_tf(&qc->tf, qc->dev, block, n_block, tf_flags,
-			     qc->tag);
+			     qc->tag, class);
+
 	if (likely(rc == 0))
 		return 0;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 3b301a4..8f3a559 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -66,7 +66,7 @@ extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
-			   unsigned int tag);
+			   unsigned int tag, int class);
 extern u64 ata_tf_read_block(const struct ata_taskfile *tf,
 			     struct ata_device *dev);
 extern unsigned ata_exec_internal(struct ata_device *dev,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index adbc812..ebe4c3b 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -347,6 +347,7 @@ enum {
 	ATA_LOG_DEVSLP_DETO	  = 0x01,
 	ATA_LOG_DEVSLP_VALID	  = 0x07,
 	ATA_LOG_DEVSLP_VALID_MASK = 0x80,
+	ATA_LOG_NCQ_PRIO_OFFSET   = 0x09,
 
 	/* NCQ send and receive log */
 	ATA_LOG_NCQ_SEND_RECV_SUBCMDS_OFFSET	= 0x00,
@@ -897,6 +898,11 @@ static inline bool ata_id_has_ncq_non_data(const u16 *id)
 	return id[ATA_ID_SATA_CAPABILITY_2] & BIT(5);
 }
 
+static inline bool ata_id_has_ncq_prio(const u16 *id)
+{
+	return id[ATA_ID_SATA_CAPABILITY] & BIT(12);
+}
+
 static inline bool ata_id_has_trim(const u16 *id)
 {
 	if (ata_id_major_version(id) >= 7 &&
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e37d4f9..244f261 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -165,6 +165,7 @@ enum {
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
 	ATA_DFLAG_NCQ_SEND_RECV = (1 << 19), /* device supports NCQ SEND and RECV */
+	ATA_DFLAG_NCQ_PRIO	= (1 << 20), /* device supports NCQ priority */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -341,7 +342,9 @@ enum {
 	ATA_SHIFT_PIO		= 0,
 	ATA_SHIFT_MWDMA		= ATA_SHIFT_PIO + ATA_NR_PIO_MODES,
 	ATA_SHIFT_UDMA		= ATA_SHIFT_MWDMA + ATA_NR_MWDMA_MODES,
+	ATA_SHIFT_PRIO		= 6,
 
+	ATA_PRIO_HIGH		= 2,
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
 
@@ -1609,6 +1612,21 @@ static inline int ata_ncq_enabled(struct ata_device *dev)
 			      ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
 }
 
+/**
+ *	ata_ncq_prio_enabled - Test whether NCQ prio is enabled
+ *	@dev: ATA device to test for
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	1 if NCQ prio is enabled for @dev, 0 otherwise.
+ */
+static inline int ata_ncq_prio_enabled(struct ata_device *dev)
+{
+	return (dev->flags & ATA_DFLAG_NCQ_PRIO) == ATA_DFLAG_NCQ_PRIO;
+}
+
 static inline bool ata_fpdma_dsm_supported(struct ata_device *dev)
 {
 	return (dev->flags & ATA_DFLAG_NCQ_SEND_RECV) &&
-- 
2.1.4

