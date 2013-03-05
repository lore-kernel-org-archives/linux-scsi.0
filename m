From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] [SCSI] a3000: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 12:42:31 +0900
Message-ID: <005701ce1953$77188a40$65499ec0$%han@samsung.com>
References: <005601ce1953$5b83b020$128b1060$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59635 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3CEDmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 22:42:32 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MJ6003C04YBCAD0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 05 Mar 2013 12:42:31 +0900 (KST)
Received: from DOJG1HAN02 ([12.23.120.99])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJ600EZE4YV2Y70@mmp1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 05 Mar 2013 12:42:31 +0900 (KST)
In-reply-to: <005601ce1953$5b83b020$128b1060$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/a3000.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index e29fe0e..519832d 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -279,18 +279,7 @@ static struct platform_driver amiga_a3000_scsi_driver = {
 	},
 };
 
-static int __init amiga_a3000_scsi_init(void)
-{
-	return platform_driver_probe(&amiga_a3000_scsi_driver,
-				     amiga_a3000_scsi_probe);
-}
-module_init(amiga_a3000_scsi_init);
-
-static void __exit amiga_a3000_scsi_exit(void)
-{
-	platform_driver_unregister(&amiga_a3000_scsi_driver);
-}
-module_exit(amiga_a3000_scsi_exit);
+module_platform_driver_probe(amiga_a3000_scsi_driver, amiga_a3000_scsi_probe);
 
 MODULE_DESCRIPTION("Amiga 3000 built-in SCSI");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


