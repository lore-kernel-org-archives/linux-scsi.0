From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 05/14] libata: Add command definitions for NCQ Encapsulation for READ LOG DMA EXT
Date: Mon, 25 Apr 2016 12:45:47 +0200
Message-ID: <1461581156-92581-6-git-send-email-hare@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1461581156-92581-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

ACS-4 defines an NCQ encapsulation for READ LOG DMA EXT.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/linux/ata.h    | 5 +++++
 include/linux/libata.h | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index b84210a..94ccde5 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -306,6 +306,9 @@ enum {
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
 
+	/* Subcmds for ATA_CMD_FPDMA_RECV */
+	ATA_SUBCMD_FPDMA_RECV_RD_LOG_DMA_EXT = 0x01,
+
 	/* Subcmds for ATA_CMD_FPDMA_SEND */
 	ATA_SUBCMD_FPDMA_SEND_DSM            = 0x00,
 	ATA_SUBCMD_FPDMA_SEND_WR_LOG_DMA_EXT = 0x02,
@@ -329,7 +332,9 @@ enum {
 	ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET	= 0x04,
 	ATA_LOG_NCQ_SEND_RECV_DSM_TRIM		= (1 << 0),
 	ATA_LOG_NCQ_SEND_RECV_RD_LOG_OFFSET	= 0x08,
+	ATA_LOG_NCQ_SEND_RECV_RD_LOG_SUPPORTED  = (1 << 0),
 	ATA_LOG_NCQ_SEND_RECV_WR_LOG_OFFSET	= 0x0C,
+	ATA_LOG_NCQ_SEND_RECV_WR_LOG_SUPPORTED  = (1 << 0),
 	ATA_LOG_NCQ_SEND_RECV_SIZE		= 0x10,
 
 	/* READ/WRITE LONG (obsolete) */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a418bca..09ddb5a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1642,6 +1642,13 @@ static inline bool ata_fpdma_dsm_supported(struct ata_device *dev)
 		 ATA_LOG_NCQ_SEND_RECV_DSM_TRIM);
 }
 
+static inline bool ata_fpdma_read_log_supported(struct ata_device *dev)
+{
+	return (dev->flags & ATA_DFLAG_NCQ_SEND_RECV) &&
+		(dev->ncq_send_recv_cmds[ATA_LOG_NCQ_SEND_RECV_RD_LOG_OFFSET] &
+		 ATA_LOG_NCQ_SEND_RECV_RD_LOG_SUPPORTED);
+}
+
 static inline void ata_qc_set_polling(struct ata_queued_cmd *qc)
 {
 	qc->tf.ctl |= ATA_NIEN;
-- 
1.8.5.6

