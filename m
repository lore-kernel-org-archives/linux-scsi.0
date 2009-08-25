From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/7] qla2xxx: Further limit device-table (qla_devtbl) lookup to non-24xx.
Date: Tue, 25 Aug 2009 11:36:17 -0700
Message-ID: <1251225381-768-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47031 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755836AbZHYSgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:22 -0400
In-Reply-To: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d420385..79bd898 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1794,7 +1794,8 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 	char *st, *en;
 	uint16_t index;
 	struct qla_hw_data *ha = vha->hw;
-	int use_tbl = !IS_QLA25XX(ha) && !IS_QLA81XX(ha);
+	int use_tbl = !IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) &&
+	    !IS_QLA81XX(ha);
 
 	if (memcmp(model, BINZERO, len) != 0) {
 		strncpy(ha->model_number, model, len);
-- 
1.6.2.rc1.30.gd43c

