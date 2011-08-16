From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 03/12] qla2xxx: Prevent CPU lockups when "ql2xdontresethba" module param is set.
Date: Tue, 16 Aug 2011 11:31:46 -0700
Message-ID: <1313519515-23122-4-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44864 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1HPSmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:42:39 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Driver is not releasing the lock if ql2xdontresethba is set, this might lead
to a lockup.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 2bc134b..385b6b7 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3760,10 +3760,15 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			qla82xx_idc_lock(ha);
 			break;
 		case QLA82XX_DEV_NEED_RESET:
-		    if (!ql2xdontresethba)
-			qla82xx_need_reset_handler(vha);
+			if (!ql2xdontresethba)
+				qla82xx_need_reset_handler(vha);
+			else {
+				qla82xx_idc_unlock(ha);
+				msleep(1000);
+				qla82xx_idc_lock(ha);
+			}
 			dev_init_timeout = jiffies +
-				(ha->nx_dev_init_timeout * HZ);
+			    (ha->nx_dev_init_timeout * HZ);
 			break;
 		case QLA82XX_DEV_NEED_QUIESCENT:
 			qla82xx_need_qsnt_handler(vha);
-- 
1.6.0.2


