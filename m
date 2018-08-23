From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH] scsi: qla1280: Fix memory leak when open DUMP_IT_BACK
Date: Thu, 23 Aug 2018 05:19:03 -0400
Message-ID: <1535015943-4907-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mdr@sgi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If open DUMP_IT_BACK and unfortunately fw is error, memory leak
will happen.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/scsi/qla1280.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 390775d..abdcf70 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1756,8 +1756,12 @@ static void qla1280_mailbox_timeout(struct timer_list *t)
 #endif
 
 	fw = qla1280_request_firmware(ha);
-	if (IS_ERR(fw))
+	if (IS_ERR(fw)) {
+#if DUMP_IT_BACK
+		pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
+#endif
 		return PTR_ERR(fw);
+	}
 
 	fw_data = (const __le16 *)&fw->data[0];
 	ha->fwstart = __le16_to_cpu(fw_data[2]);
-- 
1.8.3.1
