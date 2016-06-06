From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 4/4] Add ata pass-through path for ZAC commands.
Date: Mon,  6 Jun 2016 10:39:31 -0500
Message-ID: <1465227572-27149-5-git-send-email-shaun@tancheff.com>
References: <1465227572-27149-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1465227572-27149-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

The current generation of HBA SAS adapters support connecting SATA
drives and perform SCSI<->ATA translations in hardware.
Unfortunately the ZBC commands are not being translate (yet).

Currently users of SAS controllers can only send ZAC commands via
ata pass-through.

This method overloads the meaning of REQ_META to direct ZBC commands
to construct ZAC equivalent ATA pass through commands.
Note also that this approach expects the initiator to deal with the
little endian result due to bypassing the normal translation layers.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/ioctl.c       | 29 ++++++++++++++++++++++
 drivers/scsi/sd.c   | 70 +++++++++++++++++++++++++++++++++++++++++------------
 include/linux/ata.h | 15 ++++++++++++
 3 files changed, 99 insertions(+), 15 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 46a8553..03a5808 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -284,6 +284,35 @@ static int blk_zoned_action_ioctl(struct block_device *bdev, fmode_t mode,
 		return -EFAULT;
 	}
 
+	/*
+	 * When the low bit is set force ATA passthrough try to work around
+	 * older SAS HBA controllers that don't support ZBC to ZAC translation.
+	 *
+	 * When the low bit is clear follow the normal path but also correct
+	 * for ~0ul LBA means 'for all lbas'.
+	 *
+	 * NB: We should do extra checking here to see if the user specified
+	 *     the entire block device as opposed to a partition of the
+	 *     device....
+	 */
+	if (arg & 1) {
+		bi_rw |= REQ_META;
+		if (arg != ~0ul)
+			arg &= ~1ul; /* ~1 :: 0xFF...FE */
+	} else {
+		if (arg == ~1ul)
+			arg = ~0ul;
+	}
+
+	/*
+	 * When acting on zones we explicitly disallow using a partition.
+	 */
+	if (bdev != bdev->bd_contains) {
+		pr_err("%s: All zone operations disallowed on this device\n",
+			__func__);
+		return -EFAULT;
+	}
+
 	switch (cmd) {
 	case BLKOPENZONE:
 		bi_rw |= REQ_OPEN_ZONE;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 372b5e2..177d5fb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -53,6 +53,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
 #include <linux/blkzoned_api.h>
+#include <linux/ata.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -1182,12 +1183,29 @@ static int sd_setup_zoned_cmnd(struct scsi_cmnd *cmd)
 
 		cmd->cmd_len = 16;
 		memset(cmd->cmnd, 0, cmd->cmd_len);
-		cmd->cmnd[0] = ZBC_IN;
-		cmd->cmnd[1] = ZI_REPORT_ZONES;
-		put_unaligned_be64(sector, &cmd->cmnd[2]);
-		put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
-		/* FUTURE ... when streamid is available */
-		/* cmd->cmnd[14] = bio_get_streamid(bio); */
+		if (rq->cmd_flags & REQ_META) {
+			cmd->cmnd[0] = ATA_16;
+			cmd->cmnd[1] = (0x6 << 1) | 1;
+			cmd->cmnd[2] = 0x0e;
+			/* FUTURE ... when streamid is available */
+			/* cmd->cmnd[3] = bio_get_streamid(bio); */
+			cmd->cmnd[4] = ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES;
+			cmd->cmnd[5] = ((nr_bytes / 512) >> 8) & 0xff;
+			cmd->cmnd[6] = (nr_bytes / 512) & 0xff;
+
+			_lba_to_cmd_ata(&cmd->cmnd[7], sector);
+
+			cmd->cmnd[13] = 1 << 6;
+			cmd->cmnd[14] = ATA_CMD_ZAC_MGMT_IN;
+		} else {
+			cmd->cmnd[0] = ZBC_IN;
+			cmd->cmnd[1] = ZI_REPORT_ZONES;
+			put_unaligned_be64(sector, &cmd->cmnd[2]);
+			put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
+			/* FUTURE ... when streamid is available */
+			/* cmd->cmnd[14] = bio_get_streamid(bio); */
+		}
+
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
 		cmd->sdb.length = nr_bytes;
 		cmd->transfersize = sdp->sector_size;
@@ -1208,14 +1226,29 @@ static int sd_setup_zoned_cmnd(struct scsi_cmnd *cmd)
 	cmd->cmd_len = 16;
 	memset(cmd->cmnd, 0, cmd->cmd_len);
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-	cmd->cmnd[0] = ZBC_OUT;
-	cmd->cmnd[1] = ZO_OPEN_ZONE;
-	if (rq->cmd_flags & REQ_CLOSE_ZONE)
-		cmd->cmnd[1] = ZO_CLOSE_ZONE;
-	if (rq->cmd_flags & REQ_RESET_ZONE)
-		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
-	cmd->cmnd[14] = allbit;
-	put_unaligned_be64(sector, &cmd->cmnd[2]);
+	if (rq->cmd_flags & REQ_META) {
+		cmd->cmnd[0] = ATA_16;
+		cmd->cmnd[1] = (3 << 1) | 1;
+		cmd->cmnd[3] = allbit;
+		cmd->cmnd[4] = ATA_SUBCMD_ZAC_MGMT_OUT_RESET_WRITE_POINTER;
+		if (rq->cmd_flags & REQ_OPEN_ZONE)
+			cmd->cmnd[4] = ATA_SUBCMD_ZAC_MGMT_OUT_OPEN_ZONE;
+		if (rq->cmd_flags & REQ_CLOSE_ZONE)
+			cmd->cmnd[4] = ATA_SUBCMD_ZAC_MGMT_OUT_CLOSE_ZONE;
+		_lba_to_cmd_ata(&cmd->cmnd[7], sector);
+		cmd->cmnd[13] = 1 << 6;
+		cmd->cmnd[14] = ATA_CMD_ZAC_MGMT_OUT;
+	} else {
+		cmd->cmnd[0] = ZBC_OUT;
+		cmd->cmnd[1] = ZO_OPEN_ZONE;
+		if (rq->cmd_flags & REQ_CLOSE_ZONE)
+			cmd->cmnd[1] = ZO_CLOSE_ZONE;
+		if (rq->cmd_flags & REQ_RESET_ZONE)
+			cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+		cmd->cmnd[14] = allbit;
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+	}
+
 	cmd->transfersize = 0;
 	cmd->underflow = 0;
 	cmd->allowed = SD_MAX_RETRIES;
@@ -2806,7 +2839,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
 	unsigned char *buffer;
 	u16 rot;
-	const int vpd_len = 64;
+	const int vpd_len = 512;
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
 
@@ -2823,6 +2856,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	}
 
 	sdkp->zoned = (buffer[8] >> 4) & 3;
+	if (sdkp->zoned != 1) {
+		struct scsi_device *sdev = sdkp->device;
+
+		/* buf size is 512, page is 60 + 512, we need page 206 */
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
+			sdkp->zoned = ata_id_zoned_cap((u16 *)&buffer[60]);
+	}
 
  out:
 	kfree(buffer);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..5cc1a85 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1060,6 +1060,21 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 #endif
 }
 
+/**
+ * _lba_to_cmd_ata() - Copy lba48 to ATA command
+ * @cmd: ATA command as an array of bytes
+ * @_lba: lba48 in the low 48 bits
+ */
+static inline void _lba_to_cmd_ata(u8 *cmd, u64 _lba)
+{
+	cmd[1] =  _lba	      & 0xff;
+	cmd[3] = (_lba >>  8) & 0xff;
+	cmd[5] = (_lba >> 16) & 0xff;
+	cmd[0] = (_lba >> 24) & 0xff;
+	cmd[2] = (_lba >> 32) & 0xff;
+	cmd[4] = (_lba >> 40) & 0xff;
+}
+
 /*
  * Write LBA Range Entries to the buffer that will cover the extent from
  * sector to sector + count.  This is used for TRIM and for ADD LBA(S)
-- 
2.8.1

