From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/24] qla4xxx: Correctly handle msleep_interruptible
Date: Mon, 16 Dec 2013 06:49:37 -0500
Message-ID: <1387194594-29817-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:59793 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab3LPMYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:24:03 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

If waiting for signals was interrupted then the device was put to
FAILED state. Use msleep instead of msleep_interruptible to handle
this correctly.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 0ec07ec..cbc68f9 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2820,7 +2820,7 @@ void qla4_8xxx_get_minidump(struct scsi_qla_host *ha)
 int qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 {
 	int rval = QLA_ERROR;
-	int i, timeout;
+	int i;
 	uint32_t old_count, count;
 	int need_reset = 0, peg_stuck = 1;
 
@@ -2828,13 +2828,7 @@ int qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 	old_count = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
 
 	for (i = 0; i < 10; i++) {
-		timeout = msleep_interruptible(200);
-		if (timeout) {
-			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
-					    QLA8XXX_DEV_FAILED);
-			return rval;
-		}
-
+		msleep(200);
 		count = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
 		if (count != old_count)
 			peg_stuck = 0;
-- 
1.8.2.GIT

