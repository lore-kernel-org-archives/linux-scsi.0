From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 03/29] qla2xxx: Use a valid enode-mac if none defined.
Date: Thu, 9 Feb 2012 11:15:35 -0800
Message-ID: <1328814961-21866-4-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:34166
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758404Ab2BITcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:09 -0500
Received: from mail105-ch1 (localhost [127.0.0.1])	by
 mail105-ch1-R.bigfish.com (Postfix) with ESMTP id E4BA92602EB	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:08 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original 'defaults' were not OUI valid.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 38d8659..e5b417a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5255,9 +5255,9 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	memcpy(icb->enode_mac, nv->enode_mac, sizeof(icb->enode_mac));
 	/* Some boards (with valid NVRAMs) still have NULL enode_mac!! */
 	if (!memcmp(icb->enode_mac, "\0\0\0\0\0\0", sizeof(icb->enode_mac))) {
-		icb->enode_mac[0] = 0x01;
-		icb->enode_mac[1] = 0x02;
-		icb->enode_mac[2] = 0x03;
+		icb->enode_mac[0] = 0x00;
+		icb->enode_mac[1] = 0xC0;
+		icb->enode_mac[2] = 0xDD;
 		icb->enode_mac[3] = 0x04;
 		icb->enode_mac[4] = 0x05;
 		icb->enode_mac[5] = 0x06 + ha->port_no;
-- 
1.6.0.2


