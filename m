From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/12] qla2xxx: Correction to sysfs edc interface.
Date: Tue, 16 Aug 2011 11:31:51 -0700
Message-ID: <1313519515-23122-9-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48472 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HPSpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:45:12 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Corrects the return value for the cases where read/write edc fails;
this prevents sysfs from retrying the operation until forever.

Corrects the printk width specifier for the first byte of buf.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index df0002f..c9c42a6 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -668,9 +668,9 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 	    dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x7074,
-		    "Unable to write EDC (%x) %02x:%04x:%02x:%02x\n",
+		    "Unable to write EDC (%x) %02x:%04x:%02x:%02hhx\n",
 		    rval, dev, adr, opt, len, buf[8]);
-		return 0;
+		return -EINVAL;
 	}
 
 	return count;
@@ -727,7 +727,7 @@ qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 		ql_log(ql_log_info, vha, 0x7075,
 		    "Unable to write EDC status (%x) %02x:%04x:%02x.\n",
 		    rval, dev, adr, opt, len);
-		return 0;
+		return -EINVAL;
 	}
 
 	ha->edc_data_len = len;
-- 
1.6.0.2


