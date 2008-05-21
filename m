From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/advansys.c: fix compile errors
Date: Wed, 21 May 2008 20:41:52 +0300
Message-ID: <20080521174152.GF15355@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53680 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936267AbYEURoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 13:44:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following compile error on architectures not 
providing free_dma():

<--  snip  -->

...
  CC [M]  drivers/scsi/advansys.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c: In function 'advansys_board_found':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c:13876: error: implicit declaration of function 'free_dma'
make[3]: *** [drivers/scsi/advansys.o] Error 1
...
  CC [M]  drivers/scsi/advansys.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c: In function 'advansys_release':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/advansys.c:13901: error: implicit declaration of function 'free_dma'
make[3]: *** [drivers/scsi/advansys.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/advansys.c |    4 ++++
 1 file changed, 4 insertions(+)

539dd76b86cea6a8deffcbfdcc9d4e8343939b6f diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8591585..3b41906 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -13872,8 +13872,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	advansys_wide_free_mem(boardp);
 	free_irq(boardp->irq, shost);
  err_free_dma:
+#ifdef CONFIG_ISA
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
+#endif
  err_free_proc:
 	kfree(boardp->prtbuf);
  err_unmap:
@@ -13894,10 +13896,12 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(board->irq, shost);
+#ifdef CONFIG_ISA
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
+#endif
 	if (ASC_NARROW_BOARD(board)) {
 		dma_unmap_single(board->dev,
 					board->dvc_var.asc_dvc_var.overrun_dma,

