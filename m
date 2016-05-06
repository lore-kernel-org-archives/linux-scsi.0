From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/4] scsi: fnic: use kernel's '%pM' format option to print MAC
Date: Fri,  6 May 2016 19:23:57 +0300
Message-ID: <1462551839-44380-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbcEFQYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 12:24:05 -0400
In-Reply-To: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>

Instead of supplying each byte through stack let's use %pM specifier.

Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/fnic/vnic_dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 9795d6f..ba69d61 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		pr_err("Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
@@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		pr_err("Can't del addr [%pM], %d\n", addr, err);
 }
 
 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
-- 
2.8.1

