From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 19/20] scsi: lpfc: fix "integer constant too large" error on 32bit archs
Date: Fri,  4 Aug 2017 17:47:30 -0700
Message-ID: <20170805004731.1335-20-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33955 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752697AbdHEAsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:15 -0400
Received: by mail-pf0-f193.google.com with SMTP id t86so3208172pfe.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:14 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Maurizio Lombardi <mlombard@redhat.com>, James Smart <james.smart@broadcom.com>

From: Maurizio Lombardi <mlombard@redhat.com>

cc1: warnings being treated as errors
drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_get_wwpn':
drivers/scsi/lpfc/lpfc_init.c:3253: error: integer constant is too large for 'long' type

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2: use rol64()
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 19af7e2c2ac0..8c512e494353 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -37,6 +37,7 @@
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
 #include <linux/msi.h>
+#include <linux/bitops.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -3733,9 +3734,7 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
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
2.13.1
