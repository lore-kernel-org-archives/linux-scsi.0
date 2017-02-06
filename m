From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 21/39] megaraid_sas: avoid unaligned access in ioctl path
Date: Mon,  6 Feb 2017 01:59:54 -0800
Message-ID: <1486375212-17329-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35000 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdBFKCX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:23 -0500
Received: by mail-pf0-f171.google.com with SMTP id f144so23078660pfa.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:23 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix kernel warning for accessing unaligned memory access in driver.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c38b9c3..907b2bf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -43,6 +43,7 @@
 #include <linux/uio.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <asm/unaligned.h>
 #include <linux/fs.h>
 #include <linux/compat.h>
 #include <linux/blkdev.h>
@@ -7002,7 +7003,8 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
 				ioc->sense_off);
 
-		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
+		if (copy_to_user((void __user *)((unsigned long)
+				 get_unaligned((unsigned long *)sense_ptr)),
 				 sense, ioc->sense_len)) {
 			dev_err(&instance->pdev->dev, "Failed to copy out to user "
 					"sense data\n");
-- 
2.8.3
