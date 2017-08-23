From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 19/20] scsi: lpfc: fix "integer constant too large" error on 32bit archs
Date: Wed, 23 Aug 2017 16:55:48 -0700
Message-ID: <20170823235549.2883-20-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35897 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdHWX4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:39 -0400
Received: by mail-wr0-f195.google.com with SMTP id u17so587813wrf.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:38 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>, James Smart <james.smart@broadcom.com>

From: Maurizio Lombardi <mlombard@redhat.com>

cc1: warnings being treated as errors
drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_get_wwpn':
drivers/scsi/lpfc/lpfc_init.c:3253: error: integer constant is too large for 'long' type

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
v2:
  use rol64()
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1b81f734e3ef..7e7ae786121b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -37,6 +37,7 @@
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
 #include <linux/msi.h>
+#include <linux/bitops.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -3728,9 +3729,7 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
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
