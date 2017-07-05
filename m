From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 02/15] megaraid_sas: set minimum value of resetwaittime to be 1 secs
Date: Wed,  5 Jul 2017 05:00:16 -0700
Message-ID: <1499256029-16319-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33151 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdGEMBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:16 -0400
Received: by mail-pf0-f173.google.com with SMTP id e7so128778548pfk.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:15 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Setting resetwaittime to 0 during a FW fault will result in driver
not calling the OCR.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 316c3df..395c3aa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5478,7 +5478,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->throttlequeuedepth =
 				MEGASAS_THROTTLE_QUEUE_DEPTH;
 
-	if (resetwaittime > MEGASAS_RESET_WAIT_TIME)
+	if ((resetwaittime < 1) ||
+	    (resetwaittime > MEGASAS_RESET_WAIT_TIME))
 		resetwaittime = MEGASAS_RESET_WAIT_TIME;
 
 	if ((scmd_timeout < 10) || (scmd_timeout > MEGASAS_DEFAULT_CMD_TIMEOUT))
-- 
1.8.3.1
