From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] scsi: qla2xxx: print port name via %*phC
Date: Tue, 29 Apr 2014 17:26:41 +0300
Message-ID: <1398781601-10658-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaD2O0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2014 10:26:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Instead of pushing each byte via stack let's use custom specifier which allows
to print small buffers as a hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 68fb66fd..c9b2421 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1492,9 +1492,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
-	snprintf(port_name, 36, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
-		fc_wwpn[0], fc_wwpn[1], fc_wwpn[2], fc_wwpn[3], fc_wwpn[4],
-		fc_wwpn[5], fc_wwpn[6], fc_wwpn[7]);
+	snprintf(port_name, sizeof(port_name), "%8phC", fc_wwpn);
 	/*
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
-- 
1.9.2

