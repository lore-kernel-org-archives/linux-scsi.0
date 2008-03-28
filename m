From: Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] 2.6.25-rc6 initio senselen warning
Date: Thu, 27 Mar 2008 23:51:43 -0600
Message-ID: <20080328055143.GA27045@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:44628 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbYC1Fvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 01:51:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>


Building initio on parisc with gcc-4.3 yielded this warning:
drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type

and the code was:
        cblk->senselen = cpu_to_le32(SENSE_SIZE);

Given senselen is a u8, code is wrong.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 0cc8868..0a21863 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2582,7 +2582,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 	dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
 				  SENSE_SIZE, DMA_FROM_DEVICE);
 	cblk->senseptr = cpu_to_le32((u32)dma_addr);
-	cblk->senselen = cpu_to_le32(SENSE_SIZE);
+	cblk->senselen = SENSE_SIZE;
 	cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
 	cblk->cdblen = cmnd->cmd_len;
 
