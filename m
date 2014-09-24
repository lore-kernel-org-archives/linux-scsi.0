From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 21/35] qla2xxx: Add fix in driver unload for pending activity.
Date: Wed, 24 Sep 2014 03:08:24 -0400
Message-ID: <1411542518-2477-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:50236 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbaIXHmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:45 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6539513..b9523dc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -859,8 +859,10 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
-	while ((!(vha->flags.online) || ha->dpc_active ||
-	    ha->flags.mbox_busy))
+	while (((qla2x00_reset_active(vha)) || ha->dpc_active ||
+	    ha->flags.mbox_busy) ||
+		test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
+		test_bit(FX00_TARGET_SCAN, &vha->dpc_flags))
 		msleep(1000);
 }
 
-- 
1.7.7

