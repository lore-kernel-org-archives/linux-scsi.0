From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: [PATCH 3.6.0- 6/6] scsi/sun_esp: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:35:05 +0100
Message-ID: <1349894105-8753-1-git-send-email-srinivas.kandagatla@st.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45716 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2JJSgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 14:36:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: srinivas.kandagatla@st.com, fthain@telegraphics.com.au, JBottomley@Parallels.com, tsbogend@alpha.frankende, linux-scsi@vger.kernel.org, grant.likely@secretlab.ca, davem@davemloft.net

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/scsi/sun_esp.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 676fe9a..e4ff9c8 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -642,20 +642,8 @@ static struct platform_driver esp_sbus_driver = {
 	.remove		= __devexit_p(esp_sbus_remove),
 };
 
-static int __init sunesp_init(void)
-{
-	return platform_driver_register(&esp_sbus_driver);
-}
-
-static void __exit sunesp_exit(void)
-{
-	platform_driver_unregister(&esp_sbus_driver);
-}
-
 MODULE_DESCRIPTION("Sun ESP SCSI driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sunesp_init);
-module_exit(sunesp_exit);
+module_platform_driver(esp_sbus_driver);
-- 
1.7.0.4

