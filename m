From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/10] qla2xxx: Remove a superfluous test
Date: Tue, 27 Jan 2015 10:34:37 +0100
Message-ID: <54C75BAD.3080209@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0088.outbound.protection.outlook.com ([207.46.100.88]:21732
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758017AbbA0Jeq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:34:46 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that smatch reports the following warning:

drivers/scsi/qla2xxx/qla_attr.c:1081: qla2x00_model_desc_show() warn: this array is probably non-NULL. 'vha->hw->model_desc'

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
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
2.1.2

