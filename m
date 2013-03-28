From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: Add clarifying printk to thermal access fail cases.
Date: Thu, 28 Mar 2013 08:21:25 -0400
Message-ID: <1364473287-27640-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:57832 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755389Ab3C1MoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 08:44:20 -0400
In-Reply-To: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 43345af..3b6a41c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4518,7 +4518,8 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp)
 			goto done;
 
 		ql_log(ql_log_warn, vha, 0x10c9,
-		    "Thermal not supported by I2C.\n");
+		    "Thermal not supported through I2C bus, trying alternate "
+		    "method (ISP access).\n");
 		ha->thermal_support &= ~THERMAL_SUPPORT_I2C;
 	}
 
@@ -4528,7 +4529,7 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp)
 			goto done;
 
 		ql_log(ql_log_warn, vha, 0x1019,
-		    "Thermal not supported by ISP.\n");
+		    "Thermal not supported through ISP.\n");
 		ha->thermal_support &= ~THERMAL_SUPPORT_ISP;
 	}
 
-- 
1.7.7

