From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 21/35] qla2xxx: Add fix in driver unload for pending activity.
Date: Thu, 25 Sep 2014 05:16:52 -0400
Message-ID: <1411636626-7566-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:42047 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbaIYJvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:23 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
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
index 4880f0b..72b94f9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -860,8 +860,10 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
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

