From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/11] qla2xxx: Log if qla82xx firmware fails to load from flash.
Date: Tue, 10 May 2011 11:30:09 -0700
Message-ID: <1305052216-17347-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39924 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751660Ab1EJSge (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:34 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 8b217f3..752b03e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2410,9 +2410,13 @@ qla82xx_load_fw(scsi_qla_host_t *vha)
 
 	if (qla82xx_fw_load_from_flash(ha) == QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
-			"Firmware loaded successfully from flash\n");
+		    "Firmware loaded successfully from flash\n");
 		return QLA_SUCCESS;
+	} else {
+		qla_printk(KERN_ERR, ha,
+		    "Firmware load from flash failed\n");
 	}
+
 try_blob_fw:
 	qla_printk(KERN_INFO, ha,
 	    "Attempting to load firmware from blob\n");
-- 
1.6.0.2

