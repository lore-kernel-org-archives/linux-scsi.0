From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: [PATCH 3.6.0- 3/6] scsi/qlogicpti: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:42 +0100
Message-ID: <1349894082-8295-1-git-send-email-srinivas.kandagatla@st.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:49544 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2JJSgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 14:36:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: srinivas.kandagatla@st.com, fthain@telegraphics.com.au, JBottomley@Parallels.com, tsbogend@alpha.frankende, linux-scsi@vger.kernel.org, grant.likely@secretlab.ca, davem@davemloft.net

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/scsi/qlogicpti.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index b191dd5..449f64e 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1473,21 +1473,9 @@ static struct platform_driver qpti_sbus_driver = {
 	.remove		= __devexit_p(qpti_sbus_remove),
 };
 
-static int __init qpti_init(void)
-{
-	return platform_driver_register(&qpti_sbus_driver);
-}
-
-static void __exit qpti_exit(void)
-{
-	platform_driver_unregister(&qpti_sbus_driver);
-}
-
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("2.1");
 MODULE_FIRMWARE("qlogic/isp1000.bin");
-
-module_init(qpti_init);
-module_exit(qpti_exit);
+module_platform_driver(qpti_sbus_driver);
-- 
1.7.0.4

