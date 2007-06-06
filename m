From: Kev Jackson <foamdino@gmail.com>
Subject: [patch] Use DMA_32BIT_MASK where appropriate in drivers/scsi/3w-xxxx.c|h
Date: Wed, 06 Jun 2007 16:53:30 +0700
Message-ID: <4666841A.8010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:35162 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbXFFJxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2007 05:53:41 -0400
Received: by nz-out-0506.google.com with SMTP id n1so89887nzf
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jun 2007 02:53:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com, linux-scsi@vger.kernel.org

From: Kev Jackson <foamdino@gmail.com>

-Remove TW_DMA_MASK and use DMA_32BIT_MASK as listed in kernel janitors TODO list

Signed-off-by: Kev Jackson <foamdino@gmail.com>

---
 drivers/scsi/3w-xxxx.c |    2 +-
 drivers/scsi/3w-xxxx.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

-patch applies fine on current kernel tree & new kernel compiles
-previously submitted to kernel-janitors@lists.osdl.org

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 656bdb1..15ca2a0 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2338,7 +2338,7 @@ static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_device_id *

 	pci_set_master(pdev);

-	retval = pci_set_dma_mask(pdev, TW_DMA_MASK);
+	retval = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (retval) {
 		printk(KERN_WARNING "3w-xxxx: Failed to set dma mask.");
 		goto out_disable_device;
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 0742e68..4efd6c2 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -234,7 +234,6 @@ static unsigned char tw_sense_table[][4] =
 #define TW_IOCTL_TIMEOUT                      25 /* 25 seconds */
 #define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
 #define TW_IOCTL_CHRDEV_FREE                  -1
-#define TW_DMA_MASK			      DMA_32BIT_MASK
 #define TW_MAX_CDB_LEN			      16

 /* Bitmask macros to eliminate bitfields */
