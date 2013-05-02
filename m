From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/2] [SCSI] a3000: use module_platform_driver_probe()
Date: Thu, 02 May 2013 15:30:31 +0900
Message-ID: <000e01ce46fe$8b81cc20$a2856460$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56302 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3EBGad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 02:30:33 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM500J04REWEVK0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 02 May 2013 15:30:32 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Geert Uytterhoeven' <geert@linux-m68k.org>, Jingoo Han <jg1.han@samsung.com>

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/a3000.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index c487916..c0f4f42 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -280,18 +280,7 @@ static struct platform_driver amiga_a3000_scsi_driver = {
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


