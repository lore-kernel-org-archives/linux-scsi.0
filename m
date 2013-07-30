From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 35/35] sgiwd93: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:21:48 +0900
Message-ID: <005e01ce8cfd$d5c1de70$81459b50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56263 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 04:21:49 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQQ00KQTPWCG2P0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 30 Jul 2013 17:21:48 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/sgiwd93.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index a464d95..d1243ff 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -228,7 +228,7 @@ static struct scsi_host_template sgiwd93_template = {
 
 static int sgiwd93_probe(struct platform_device *pdev)
 {
-	struct sgiwd93_platform_data *pd = pdev->dev.platform_data;
+	struct sgiwd93_platform_data *pd = dev_get_platdata(&pdev->dev);
 	unsigned char *wdregs = pd->wdregs;
 	struct hpc3_scsiregs *hregs = pd->hregs;
 	struct ip22_hostdata *hdata;
@@ -301,7 +301,7 @@ static int __exit sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
-	struct sgiwd93_platform_data *pd = pdev->dev.platform_data;
+	struct sgiwd93_platform_data *pd = dev_get_platdata(&pdev->dev);
 
 	scsi_remove_host(host);
 	free_irq(pd->irq, host);
-- 
1.7.10.4


