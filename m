From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] [SCSI] a4000t: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 12:41:44 +0900
Message-ID: <005601ce1953$5b83b020$128b1060$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45065 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3CEDlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 22:41:46 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MJ6001Y64XCR0J0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 05 Mar 2013 12:41:45 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/a4000t.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 23c76f4..70c521f 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -116,20 +116,7 @@ static struct platform_driver amiga_a4000t_scsi_driver = {
 	},
 };
 
-static int __init amiga_a4000t_scsi_init(void)
-{
-	return platform_driver_probe(&amiga_a4000t_scsi_driver,
-				     amiga_a4000t_scsi_probe);
-}
-
-module_init(amiga_a4000t_scsi_init);
-
-static void __exit amiga_a4000t_scsi_exit(void)
-{
-	platform_driver_unregister(&amiga_a4000t_scsi_driver);
-}
-
-module_exit(amiga_a4000t_scsi_exit);
+module_platform_driver_probe(amiga_a4000t_scsi_driver, amiga_a4000t_scsi_probe);
 
 MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / "
 	      "Kars de Jong <jongk@linux-m68k.org>");
-- 
1.7.2.5


