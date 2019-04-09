From: Erwan Velu <erwanaliasr1@gmail.com>
Subject: [PATCH] scsi: megaraid_sas: Reporting evt_detail->code in megasas_decode_evt
Date: Tue,  9 Apr 2019 17:23:38 +0200
Message-ID: <20190409152338.27874-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Erwan Velu <e.velu@criteo.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MEGARAID SCSI/SAS DRIVERS" <megaraidlinux.pdl@broadcom.com>, "open list:MEGARAID SCSI/SAS DRIVERS" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When printing a megasas_decode_evt() message, the code member of the evt_detail is not reported.
This make the debugging more complicated as some code paths depends on this value.

Reporting the code member makes the context more explicit.

Signed-off-by: Erwan Velu <e.velu@criteo.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 293f5cf524d7..222166c659bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -392,8 +392,9 @@ megasas_decode_evt(struct megasas_instance *instance)
 	class_locale.word = le32_to_cpu(evt_detail->cl.word);
 
 	if (class_locale.members.class >= MFI_EVT_CLASS_CRITICAL)
-		dev_info(&instance->pdev->dev, "%d (%s/0x%04x/%s) - %s\n",
+		dev_info(&instance->pdev->dev, "%d code:%d (%s/0x%04x/%s) - %s\n",
 			le32_to_cpu(evt_detail->seq_num),
+			le32_to_cpu(instance->evt_detail->code),
 			format_timestamp(le32_to_cpu(evt_detail->time_stamp)),
 			(class_locale.members.locale),
 			format_class(class_locale.members.class),
-- 
2.21.0
