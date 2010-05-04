From: giridhar.malavali@qlogic.com
Subject: [PATCH 01/16] qla2xxx: Check for ISP84xx before processing to get 84xx firmware version.
Date: Tue,  4 May 2010 15:01:21 -0700
Message-ID: <1273010496-43045-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47138 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754867Ab0EDWBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:38 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c272af4..d416c35 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1198,9 +1198,11 @@ qla24xx_84xx_fw_version_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA84XX(ha) && ha->cs84xx)
-		if (ha->cs84xx->op_fw_version == 0)
-			rval = qla84xx_verify_chip(vha, status);
+	if (!IS_QLA84XX(ha))
+		return snprintf(buf, PAGE_SIZE, "\n");
+
+	if (ha->cs84xx && ha->cs84xx->op_fw_version == 0)
+		rval = qla84xx_verify_chip(vha, status);
 
 	if ((rval == QLA_SUCCESS) && (status[0] == 0))
 		return snprintf(buf, PAGE_SIZE, "%u\n",
-- 
1.6.2.rc1.30.gd43c

