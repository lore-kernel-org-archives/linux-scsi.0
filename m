From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.11-rc6
Date: Sat, 15 Apr 2017 09:33:00 -0700
Message-ID: <1492273980.3282.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39310 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753012AbdDOQdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Apr 2017 12:33:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is larger than it would be: we missed the -rc5 fixes pull request
because of a problem linux-next found with the lowest patch which
necessitated a rebase to fix.

This is seven small fixes which are all for user visible issues that
fortunately only occur in rare circumstances.  The most serious is the
sr one in which QEMU can cause us to read beyond the end of a buffer (I
don't think it's exploitable, but just in case).  The next is the sd
capacity fix which means all non 512 byte sector drives greater than
2TB fail to be correctly sized.  The rest are either in new drivers
(qedf) or on error legs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chad Dupuis (1):
      scsi: qedf: Fix crash due to unsolicited FIP VLAN response.

Fam Zheng (1):
      scsi: sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable

Guilherme G. Piccoli (1):
      scsi: aacraid: fix PCI error recovery path

Martin K. Petersen (2):
      scsi: sd: Fix capacity calculation with 32-bit sector_t
      scsi: sr: Sanity check returned mode data

Mauricio Faria de Oliveira (1):
      scsi: ipr: do not set DID_PASSTHROUGH on CHECK CONDITION

Sawan Chandak (1):
      scsi: qla2xxx: Add fix to read correct register value for ISP82xx.

With diffstat:

 drivers/scsi/aacraid/aacraid.h | 11 ++++++++---
 drivers/scsi/aacraid/commsup.c |  3 ++-
 drivers/scsi/ipr.c             |  7 ++++++-
 drivers/scsi/qedf/qedf_fip.c   |  3 ++-
 drivers/scsi/qedf/qedf_main.c  |  1 +
 drivers/scsi/qla2xxx/qla_os.c  |  7 ++++++-
 drivers/scsi/sd.c              | 23 ++++++++++++++++++++---
 drivers/scsi/sr.c              |  6 ++++--
 8 files changed, 49 insertions(+), 12 deletions(-)

And full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d036a806f31c..d281492009fb 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1690,9 +1690,6 @@ struct aac_dev
 #define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
 	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
 
-#define aac_adapter_check_health(dev) \
-	(dev)->a_ops.adapter_check_health(dev)
-
 #define aac_adapter_restart(dev, bled, reset_type) \
 	((dev)->a_ops.adapter_restart(dev, bled, reset_type))
 
@@ -2615,6 +2612,14 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 	return capacity;
 }
 
+static inline int aac_adapter_check_health(struct aac_dev *dev)
+{
+	if (unlikely(pci_channel_offline(dev->pdev)))
+		return -1;
+
+	return (dev)->a_ops.adapter_check_health(dev);
+}
+
 /* SCp.phase values */
 #define AAC_OWNER_MIDLEVEL	0x101
 #define AAC_OWNER_LOWLEVEL	0x102
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c8172f16cf33..1f4918355fdb 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1873,7 +1873,8 @@ int aac_check_health(struct aac_dev * aac)
 	spin_unlock_irqrestore(&aac->fib_lock, flagv);
 
 	if (BlinkLED < 0) {
-		printk(KERN_ERR "%s: Host adapter dead %d\n", aac->name, BlinkLED);
+		printk(KERN_ERR "%s: Host adapter is dead (or got a PCI error) %d\n",
+				aac->name, BlinkLED);
 		goto out;
 	}
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b29afafc2885..5d5e272fd815 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6293,7 +6293,12 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 		break;
 	case IPR_IOASC_MED_DO_NOT_REALLOC: /* prevent retries */
 	case IPR_IOASA_IR_DUAL_IOA_DISABLED:
-		scsi_cmd->result |= (DID_PASSTHROUGH << 16);
+		/*
+		 * exception: do not set DID_PASSTHROUGH on CHECK CONDITION
+		 * so SCSI mid-layer and upper layers handle it accordingly.
+		 */
+		if (scsi_cmd->result != SAM_STAT_CHECK_CONDITION)
+			scsi_cmd->result |= (DID_PASSTHROUGH << 16);
 		break;
 	case IPR_IOASC_BUS_WAS_RESET:
 	case IPR_IOASC_BUS_WAS_RESET_BY_OTHER:
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index ed58b9104f58..e10b91cc3c62 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -99,7 +99,8 @@ static void qedf_fcoe_process_vlan_resp(struct qedf_ctx *qedf,
 		qedf_set_vlan_id(qedf, vid);
 
 		/* Inform waiter that it's ok to call fcoe_ctlr_link up() */
-		complete(&qedf->fipvlan_compl);
+		if (!completion_done(&qedf->fipvlan_compl))
+			complete(&qedf->fipvlan_compl);
 	}
 }
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 8e2a160490e6..cceddd995a4b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2803,6 +2803,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		atomic_set(&qedf->num_offloads, 0);
 		qedf->stop_io_on_error = false;
 		pci_set_drvdata(pdev, qedf);
+		init_completion(&qedf->fipvlan_compl);
 
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO,
 		   "QLogic FastLinQ FCoE Module qedf %s, "
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f28d38e93439..1a0bf7ef0233 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1160,8 +1160,13 @@ static inline
 uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 {
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
 
-	return ((RD_REG_DWORD(&reg->host_status)) == ISP_REG_DISCONNECT);
+	if (IS_P3P_TYPE(ha))
+		return ((RD_REG_DWORD(&reg82->host_int)) == ISP_REG_DISCONNECT);
+	else
+		return ((RD_REG_DWORD(&reg->host_status)) ==
+			ISP_REG_DISCONNECT);
 }
 
 /**************************************************************************
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9b4d29af0b..fe0f7997074e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2102,6 +2102,22 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
+/*
+ * Ensure that we don't overflow sector_t when CONFIG_LBDAF is not set
+ * and the reported logical block size is bigger than 512 bytes. Note
+ * that last_sector is a u64 and therefore logical_to_sectors() is not
+ * applicable.
+ */
+static bool sd_addressable_capacity(u64 lba, unsigned int sector_size)
+{
+	u64 last_sector = (lba + 1ULL) << (ilog2(sector_size) - 9);
+
+	if (sizeof(sector_t) == 4 && last_sector > U32_MAX)
+		return false;
+
+	return true;
+}
+
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
@@ -2167,7 +2183,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -ENODEV;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2256,7 +2272,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return sector_size;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2956,7 +2972,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
-		rw_max = BLK_DEF_MAX_SECTORS;
+		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
+				      (sector_t)BLK_DEF_MAX_SECTORS);
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0b29b9329b1c..a8f630213a1a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -836,6 +836,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	unsigned char *buffer;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	unsigned int ms_len = 128;
 	int rc, n;
 
 	static const char *loadmech[] =
@@ -862,10 +863,11 @@ static void get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
-	if (!scsi_status_is_good(rc)) {
+	if (!scsi_status_is_good(rc) || data.length > ms_len ||
+	    data.header_length + data.block_descriptor_length > data.length) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed = 1;
 		cd->cdi.mask |= (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
