From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/15] qla2xxx: Don't try to 'stop' firmware if already in ROM code.
Date: Mon,  6 Apr 2009 22:33:48 -0700
Message-ID: <1239082431-19496-13-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZDGFeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:05 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a4a6a14..138ae88 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4153,7 +4153,7 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 
 	ret = qla2x00_stop_firmware(vha);
 	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
-	    retries ; retries--) {
+	    ret != QLA_INVALID_COMMAND && retries ; retries--) {
 		ha->isp_ops->reset_chip(vha);
 		if (ha->isp_ops->chip_diag(vha) != QLA_SUCCESS)
 			continue;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 258c39d..7d0eeec 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2477,6 +2477,8 @@ qla2x00_stop_firmware(scsi_qla_host_t *vha)
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    vha->host_no, rval));
+		if (mcp->mb[0] == MBS_INVALID_COMMAND)
+			rval = QLA_INVALID_COMMAND;
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
-- 
1.6.2.2.404.ge96f3

