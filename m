From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] scsi: ibmvscsi: constify dev_pm_ops structures.
Date: Thu, 29 Jun 2017 13:13:55 +0530
Message-ID: <ff2eee2670f773454efdece4f455bb367fff3baa.1498722090.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32814 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdF2Hos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 03:44:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org

dev_pm_ops are not supposed to change at runtime. All functions
working with dev_pm_ops provided by <linux/device.h> work with const
dev_pm_ops. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  17956	   1456	      8	  19420	   4bdc	drivers/scsi/ibmvscsi/ibmvscsi.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  18164	   1264	      8	  19436	   4bec	drivers/scsi/ibmvscsi/ibmvscsi.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 1deb0a9..da22b36 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2336,7 +2336,7 @@ static int ibmvscsi_resume(struct device *dev)
 };
 MODULE_DEVICE_TABLE(vio, ibmvscsi_device_table);
 
-static struct dev_pm_ops ibmvscsi_pm_ops = {
+static const struct dev_pm_ops ibmvscsi_pm_ops = {
 	.resume = ibmvscsi_resume
 };
 
-- 
1.9.1
