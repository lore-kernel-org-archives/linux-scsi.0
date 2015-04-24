From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/23] advansys: Remove call to dma_cache_sync()
Date: Fri, 24 Apr 2015 13:18:41 +0200
Message-ID: <1429874322-85488-24-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966351AbbDXLSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:53 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Only required if the dma buffer has been allocated via
dma_alloc_noncoherent(), which this one is not.
With that call removed we can now also compile on ARM.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig    |  2 +-
 drivers/scsi/advansys.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b021bcb..a4564b3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -503,7 +503,7 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on SCSI && VIRT_TO_BUS && !ARM
+	depends on SCSI && VIRT_TO_BUS
 	depends on ISA || EISA || PCI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7142a79..3b81f44 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7510,17 +7510,17 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
+static __le32 asc_get_sense_buffer_dma(struct scsi_cmnd *scp)
 {
 	struct asc_board *board = shost_priv(scp->device->host);
+
 	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
-					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+					     SCSI_SENSE_BUFFERSIZE,
+					     DMA_FROM_DEVICE);
 	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
 		ASC_DBG(1, "failed to map sense buffer\n");
 		return 0;
 	}
-	dma_cache_sync(board->dev, scp->sense_buffer,
-		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
 }
 
@@ -7549,7 +7549,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	asc_scsi_q->q1.target_lun = scp->device->lun;
 	asc_scsi_q->q2.target_ix =
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
-	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
+	asc_scsi_q->q1.sense_addr = asc_get_sense_buffer_dma(scp);
 	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
 	if (!asc_scsi_q->q1.sense_addr)
 		return ASC_BUSY;
-- 
1.8.5.2

