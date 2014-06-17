From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 11/24] drviers/scsi: check sysfs init return value via IS_ERR
 at iscsi_boot_create_kset
Date: Tue, 17 Jun 2014 22:34:50 +0800
Message-ID: <53A0520A.8050509@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQOfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 10:35:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

kset_create_and_add() has been fixed to return the actual error ptr
than NULL on failure, update iscsi_boot_create_kset() to check the
return value via IS_ERR() accordingly.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/scsi/iscsi_boot_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index 680bf6f..821df62 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -443,7 +443,7 @@ struct iscsi_boot_kset *iscsi_boot_create_kset(const char *set_name)
 		return NULL;
 
 	boot_kset->kset = kset_create_and_add(set_name, NULL, firmware_kobj);
-	if (!boot_kset->kset) {
+	if (IS_ERR(boot_kset->kset)) {
 		kfree(boot_kset);
 		return NULL;
 	}
-- 
1.8.3.2
