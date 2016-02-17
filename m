From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] qlogicpti: Return correct error code
Date: Wed, 17 Feb 2016 19:02:54 +0530
Message-ID: <20160217133254.GA31334@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36495 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422971AbcBQNdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 08:33:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr

The return value of of_ioremap on failure should be -ENODEV and not
-1.

Found using Coccinelle. A simplified version of the semantic patch
used is:

//<smpl>
@@
expression *e;
@@

e = of_ioremap(...);
if (e == NULL) {
...
return
- -1
+ -ENODEV
;
}
//</smpl>

The single call site only checks that the return value is less than 0,
hence no change is required at the call site.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/scsi/qlogicpti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 676385f..69bfc0a 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -710,7 +710,7 @@ static int qpti_map_regs(struct qlogicpti *qpti)
 				 "PTI Qlogic/ISP");
 	if (!qpti->qregs) {
 		printk("PTI: Qlogic/ISP registers are unmappable\n");
-		return -1;
+		return -ENODEV;
 	}
 	if (qpti->is_pti) {
 		qpti->sreg = of_ioremap(&op->resource[0], (16 * 4096),
@@ -718,7 +718,7 @@ static int qpti_map_regs(struct qlogicpti *qpti)
 					"PTI Qlogic/ISP statreg");
 		if (!qpti->sreg) {
 			printk("PTI: Qlogic/ISP status register is unmappable\n");
-			return -1;
+			return -ENODEV;
 		}
 	}
 	return 0;
-- 
1.9.1

