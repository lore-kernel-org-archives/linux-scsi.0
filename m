From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH] mptfusion: use strlcpy() instead of strncpy()
Date: Fri, 12 Jan 2018 19:46:59 +0800
Message-ID: <1515757619-29651-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3781 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754403AbeALLlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Jan 2018 06:41:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: arnd@arndb.de, wangxiongfeng2@huawei.com

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

drivers/message/fusion/mptctl.c: In function '__mptctl_ioctl.isra.3':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 12 equals destination size [-Wstringop-truncation]

The compiler requires that the destination size should be greater than
the length we copy to make sure the dest string is nul-terminated. We
can just use strlcpy() to avoid this warning.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 drivers/message/fusion/mptctl.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 7b3b413..15f2aca 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1353,8 +1353,7 @@ static int mptctl_do_reset(unsigned long arg)
 
 	/* Set the Version Strings.
 	 */
-	strncpy (karg->driverVersion, MPT_LINUX_PACKAGE_NAME, MPT_IOCTL_VERSION_LENGTH);
-	karg->driverVersion[MPT_IOCTL_VERSION_LENGTH-1]='\0';
+	strlcpy (karg->driverVersion, MPT_LINUX_PACKAGE_NAME, MPT_IOCTL_VERSION_LENGTH);
 
 	karg->busChangeEvent = 0;
 	karg->hostId = ioc->pfacts[port].PortSCSIID;
@@ -1542,10 +1541,8 @@ static int mptctl_do_reset(unsigned long arg)
 #else
 	karg.chip_type = ioc->pcidev->device;
 #endif
-	strncpy (karg.name, ioc->name, MPT_MAX_NAME);
-	karg.name[MPT_MAX_NAME-1]='\0';
-	strncpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);
-	karg.product[MPT_PRODUCT_LENGTH-1]='\0';
+	strlcpy (karg.name, ioc->name, MPT_MAX_NAME);
+	strlcpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);
 
 	/* Copy the data from kernel memory to user memory
 	 */
@@ -2513,7 +2510,7 @@ static int mptctl_do_reset(unsigned long arg)
 	cfg.dir = 0;	/* read */
 	cfg.timeout = 10;
 
-	strncpy(karg.serial_number, " ", 24);
+	strlcpy(karg.serial_number, " ", 24);
 	if (mpt_config(ioc, &cfg) == 0) {
 		if (cfg.cfghdr.hdr->PageLength > 0) {
 			/* Issue the second config page request */
@@ -2525,8 +2522,8 @@ static int mptctl_do_reset(unsigned long arg)
 				if (mpt_config(ioc, &cfg) == 0) {
 					ManufacturingPage0_t *pdata = (ManufacturingPage0_t *) pbuf;
 					if (strlen(pdata->BoardTracerNumber) > 1) {
-						strncpy(karg.serial_number, 									    pdata->BoardTracerNumber, 24);
-						karg.serial_number[24-1]='\0';
+						strlcpy(karg.serial_number,
+							pdata->BoardTracerNumber, 24);
 					}
 				}
 				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
-- 
1.8.3.1
