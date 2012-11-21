From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/19] qla2xxx: Ignore driver ack bit if corresponding presence bit is not set.
Date: Wed, 21 Nov 2012 02:40:36 -0500
Message-ID: <1353483644-17262-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:41001 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751876Ab2KUH6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:55 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 67f7b56..9ad66a3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4230,7 +4230,7 @@ qla83xx_need_reset_handler(scsi_qla_host_t *vha)
 	while (1) {
 		qla83xx_rd_reg(vha, QLA83XX_IDC_DRIVER_ACK, &drv_ack);
 		qla83xx_rd_reg(vha, QLA83XX_IDC_DRV_PRESENCE, &drv_presence);
-		if (drv_ack == drv_presence)
+		if ((drv_ack & drv_presence) == drv_presence)
 			break;
 
 		if (time_after_eq(jiffies, ack_timeout)) {
-- 
1.7.7

