From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 09/18] qla2xxx: Corrections to returned sysfs error codes.
Date: Fri, 18 Nov 2011 09:03:13 -0800
Message-ID: <1321635802-16491-10-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:43016
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758252Ab1KRRQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:29 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Correct the erroneous return codes introduced by the following patch:
"Return sysfs error codes appropriate to conditions".

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c27b1a1..b9b9efe 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -107,7 +107,7 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 	}
-	return -EINVAL;
+	return count;
 }
 
 static struct bin_attribute sysfs_fw_dump_attr = {
@@ -387,7 +387,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		break;
 	case 3:
 		if (ha->optrom_state != QLA_SWRITING)
-			return -ENOMEM;
+			return -EINVAL;
 
 		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x7068,
-- 
1.6.0.2


