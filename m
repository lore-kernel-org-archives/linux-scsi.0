From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH V2] scsi: lpfc: fix "integer constant too large" error on 32bit archs
Date: Thu, 27 Jul 2017 16:50:37 +0200
Message-ID: <1501167037-19777-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdG0Oul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jul 2017 10:50:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com
Cc: dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

cc1: warnings being treated as errors
drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_get_wwpn':
drivers/scsi/lpfc/lpfc_init.c:3253: error: integer constant is too large for 'long' type

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

v2: use rol64()
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 491aa95..e053895 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -37,6 +37,7 @@
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
 #include <linux/msi.h>
+#include <linux/bitops.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -3710,9 +3711,7 @@
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		return be64_to_cpu(wwn);
 	else
-		return (((wwn & 0xffffffff00000000) >> 32) |
-			((wwn & 0x00000000ffffffff) << 32));
-
+		return rol64(wwn, 32);
 }
 
 /**
-- 
Maurizio Lombardi
