From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] scsi: ibmvfc: constify dev_pm_ops structures.
Date: Thu, 29 Jun 2017 13:24:41 +0530
Message-ID: <c0ec5db7e2c3313cb7b417e76330520fd2b6136c.1498722828.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36359 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdF2Hzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 03:55:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org

dev_pm_ops are not supposed to change at runtime. All functions
working with dev_pm_ops provided by <linux/device.h> work with const
dev_pm_ops. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  41937	   1296	     20	  43253	   a8f5	drivers/scsi/ibmvscsi/ibmvfc.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  42129	   1104	     20	  43253	   a8f5	drivers/scsi/ibmvscsi/ibmvfc.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 26cd3c2..cc4e05b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4935,7 +4935,7 @@ static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
 };
 MODULE_DEVICE_TABLE(vio, ibmvfc_device_table);
 
-static struct dev_pm_ops ibmvfc_pm_ops = {
+static const struct dev_pm_ops ibmvfc_pm_ops = {
 	.resume = ibmvfc_resume
 };
 
-- 
1.9.1
