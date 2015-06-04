From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/10] qla2xxx: Remove a superfluous test
Date: Thu, 4 Jun 2015 15:56:03 -0700
Message-ID: <5570D783.5020601@sandisk.com>
References: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0091.outbound.protection.outlook.com ([157.56.110.91]:34518
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616AbbFDW4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:56:10 -0400
In-Reply-To: <5570D656.9050704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that smatch reports the following warning:

drivers/scsi/qla2xxx/qla_attr.c:1081: qla2x00_model_desc_show() warn: this array is probably non-NULL. 'vha->hw->model_desc'

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 741d6e0..2087b73 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1077,8 +1077,7 @@ qla2x00_model_desc_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	return scnprintf(buf, PAGE_SIZE, "%s\n",
-	    vha->hw->model_desc ? vha->hw->model_desc : "");
+	return scnprintf(buf, PAGE_SIZE, "%s\n", vha->hw->model_desc);
 }
 
 static ssize_t
-- 
2.1.4

