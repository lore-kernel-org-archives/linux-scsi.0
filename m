From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/9] qla4xxx: Fix qla4xxx_dump_buffer to dump buffer correctly
Date: Thu, 1 Dec 2011 22:42:12 -0800
Message-ID: <1322808134-21665-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:1703 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1LBGzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:52 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

KERN_INFO in printk adding new line character that mess-up
dump print format. Remove KERN_INFO to fix dump format.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_dbg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index af62c3c..8d58ae2 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -20,12 +20,12 @@ void qla4xxx_dump_buffer(void *b, uint32_t size)
 	printk("------------------------------------------------------------"
 	       "--\n");
 	for (cnt = 0; cnt < size; c++) {
-		printk(KERN_INFO "%02x", *c);
+		printk("%02x", *c);
 		if (!(++cnt % 16))
-			printk(KERN_INFO "\n");
+			printk("\n");
 
 		else
-			printk(KERN_INFO "  ");
+			printk("  ");
 	}
 	printk(KERN_INFO "\n");
 }
-- 
1.7.8.rc2.3.g0911


