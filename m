From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] advansys: remove dma_cache_sync misuse
Date: Thu, 4 Jun 2009 19:33:08 +0900
Message-ID: <20090604193240S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55073 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZFDKdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2009 06:33:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

dma_cache_sync() is supposed to be used only with
dma_alloc_noncoherent().

We don't need to call any dma_sync_ functions here too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/advansys.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b756041..6b72e2d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8349,8 +8349,6 @@ static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
 	struct asc_board *board = shost_priv(scp->device->host);
 	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
 					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-	dma_cache_sync(board->dev, scp->sense_buffer,
-		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
 }
 
-- 
1.6.0.6

