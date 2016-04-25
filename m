From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 04/14] libata: Separate out ata_dev_config_ncq_send_recv()
Date: Mon, 25 Apr 2016 12:45:46 +0200
Message-ID: <1461581156-92581-5-git-send-email-hare@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbcDYKs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 06:48:26 -0400
In-Reply-To: <1461581156-92581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Move NCQ SEND/RECEIVE checks into a separate function.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-core.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7bdb2c4..fa74b57 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2079,6 +2079,31 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
+static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned int err_mask;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_SEND_RECV,
+				     0, ap->sector_buf, 1);
+	if (err_mask) {
+		ata_dev_dbg(dev,
+			    "failed to get NCQ Send/Recv Log Emask 0x%x\n",
+			    err_mask);
+	} else {
+		u8 *cmds = dev->ncq_send_recv_cmds;
+
+		dev->flags |= ATA_DFLAG_NCQ_SEND_RECV;
+		memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_SEND_RECV_SIZE);
+
+		if (dev->horkage & ATA_HORKAGE_NO_NCQ_TRIM) {
+			ata_dev_dbg(dev, "disabling queued TRIM support\n");
+			cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
+				~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
+		}
+	}
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2124,26 +2149,8 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 			ddepth, aa_desc);
 
 	if ((ap->flags & ATA_FLAG_FPDMA_AUX) &&
-	    ata_id_has_ncq_send_and_recv(dev->id)) {
-		err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_SEND_RECV,
-					     0, ap->sector_buf, 1);
-		if (err_mask) {
-			ata_dev_dbg(dev,
-				    "failed to get NCQ Send/Recv Log Emask 0x%x\n",
-				    err_mask);
-		} else {
-			u8 *cmds = dev->ncq_send_recv_cmds;
-
-			dev->flags |= ATA_DFLAG_NCQ_SEND_RECV;
-			memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_SEND_RECV_SIZE);
-
-			if (dev->horkage & ATA_HORKAGE_NO_NCQ_TRIM) {
-				ata_dev_dbg(dev, "disabling queued TRIM support\n");
-				cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=
-					~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;
-			}
-		}
-	}
+	    ata_id_has_ncq_send_and_recv(dev->id))
+		ata_dev_config_ncq_send_recv(dev);
 
 	return 0;
 }
-- 
1.8.5.6

