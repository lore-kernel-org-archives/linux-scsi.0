From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] wd719x: add check for dma mapping errors
Date: Sat, 28 Jan 2017 01:30:52 +0300
Message-ID: <1485556252-10888-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:36378 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdA0WlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 17:41:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

wd719x_queuecommand() doesn't check if mapping dma memory succeed.
The patch adds the check and failure handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/wd719x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 2a9da2e0ea6b..41ddbdcf02e0 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -244,6 +244,12 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
 	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
 			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&wd->pdev->dev, cmd->SCp.dma_handle)) {
+		dev_err(&wd->pdev->dev, "unable to map dma\n");
+		wd719x_finish_cmd(cmd, DID_ERROR);
+		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		return 0;
+	}
 	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
 
 	/* request autosense */
-- 
2.7.4

