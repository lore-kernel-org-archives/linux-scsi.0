From: giridhar.malavali@qlogic.com
Subject: [PATCH 13/17] qla2xxx: T10 DIF enablement for 81XX
Date: Fri, 28 May 2010 15:08:27 -0700
Message-ID: <1275084511-95266-14-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52696 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753555Ab0E1WIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:36 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3b70860..085c246 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1732,7 +1732,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
 	}
 
-	if (IS_QLA25XX(ha) && ql2xenabledif) {
+	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
 			vha->flags.difdix_supported = 1;
 			DEBUG18(qla_printk(KERN_INFO, ha,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fa59181..bc35ecf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1677,7 +1677,7 @@ static struct isp_operations qla81xx_isp_ops = {
 	.read_optrom		= qla25xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
-	.start_scsi		= qla24xx_start_scsi,
+	.start_scsi		= qla24xx_dif_start_scsi,
 	.abort_isp		= qla2x00_abort_isp,
 };
 
@@ -2274,7 +2274,7 @@ skip_dpc:
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    base_vha->host_no, ha));
 
-	if (IS_QLA25XX(ha) && ql2xenabledif) {
+	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
 			base_vha->flags.difdix_supported = 1;
 			DEBUG18(qla_printk(KERN_INFO, ha,
-- 
1.6.2.rc1.30.gd43c

