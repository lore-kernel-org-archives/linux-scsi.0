From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 23/42] qla2xxx: Remove setting Scsi_host->this_id during adapter probe.
Date: Wed, 22 Aug 2012 14:21:17 -0400
Message-ID: <1345659696-3670-24-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:25407 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964869Ab2HVSiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:25 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Setting this to 255 will cause any target with id 255 to not show up so leave
it at the default in our host template.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    1 -
 drivers/scsi/qla2xxx/qla_os.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 4c2da06..bd4708a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -476,7 +476,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	vha->req = base_vha->req;
 	host->can_queue = base_vha->req->length + 128;
-	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
 		host->max_cmd_len = 32;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5439d48..d3f71cc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2418,7 +2418,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 	host->max_id = ha->max_fibre_devices;
-	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->unique_id = host->host_no;
 	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
-- 
1.7.7

