From: tim.gardner@canonical.com
Subject: [PATCH v4.3-rc7] be2iscsi : Fix bogus WARN_ON length check
Date: Fri, 30 Oct 2015 12:22:58 -0600
Message-ID: <1446229378-2956-1-git-send-email-tim.gardner@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Minh Tran <minh.tran@avagotech.com>, John Soni Jose <sony.john-n@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

drivers/scsi/be2iscsi/be_main.c: In function 'be_sgl_create_contiguous':
drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  WARN_ON(!length > 0);

gcc version 5.2.1

Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
Cc: Minh Tran <minh.tran@avagotech.com>
Cc: John Soni Jose <sony.john-n@avagotech.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..5cdcd29 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
 {
 	WARN_ON(!virtual_address);
 	WARN_ON(!physical_address);
-	WARN_ON(!length > 0);
+	WARN_ON(!length);
 	WARN_ON(!sgl);
 
 	sgl->va = virtual_address;
-- 
1.9.1
