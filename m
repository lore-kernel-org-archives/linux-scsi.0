From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] 3w-xxxx: fix error return code in tw_probe()
Date: Fri, 23 Aug 2013 11:10:32 +0800
Message-ID: <CAPgLHd_eQf1wD9p+3bRMk_4N_+hOR7oLBgymFpjj56mDWViBgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55911 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3HWDKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 23:10:34 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so31666bkh.39
        for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2013 20:10:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@lsi.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/3w-xxxx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b9276d1..3b9c01e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2315,7 +2315,8 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
 
-	if (tw_initialize_device_extension(tw_dev)) {
+	retval = tw_initialize_device_extension(tw_dev);
+	if (retval) {
 		printk(KERN_WARNING "3w-xxxx: Failed to initialize device extension.");
 		goto out_free_device_extension;
 	}
@@ -2331,6 +2332,7 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = pci_resource_start(pdev, 0);
 	if (!tw_dev->base_addr) {
 		printk(KERN_WARNING "3w-xxxx: Failed to get io address.");
+		retval = -EIO;
 		goto out_release_mem_region;
 	}
 
@@ -2338,7 +2340,8 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (tw_reset_sequence(tw_dev))
+	retval = tw_reset_sequence(tw_dev);
+	if (retval)
 		goto out_release_mem_region;
 
 	/* Set host specific parameters */

