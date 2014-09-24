From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 27/35] qla2xxx: Add missing ISP27xx checks to optrom code.
Date: Wed, 24 Sep 2014 03:08:30 -0400
Message-ID: <1411542518-2477-28-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:8657 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbaIXHmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:47 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alex Vechersky <alex.vechersky@qlogic.com>

Signed-off-by: Alex Vechersky <alex.vechersky@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
 drivers/scsi/qla2xxx/qla_bsg.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 9391e4b..82b92c4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -484,7 +484,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha)
-			|| IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+			|| IS_CNA_CAPABLE(ha) || IS_QLA2031(ha)
+			|| IS_QLA27XX(ha))
 			valid = 1;
 		if (!valid) {
 			ql_log(ql_log_warn, vha, 0x7065,
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 524f9eb..2e2bb6f 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1390,7 +1390,7 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-		    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+		    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha))
 			valid = 1;
 		if (!valid) {
 			ql_log(ql_log_warn, vha, 0x7058,
-- 
1.7.7

