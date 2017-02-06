From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 30/39] megaraid_sas: During OCR, if get_ctrl_info fails do not continue with OCR
Date: Mon,  6 Feb 2017 02:00:03 -0800
Message-ID: <1486375212-17329-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36221 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdBFKCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:54 -0500
Received: by mail-pg0-f49.google.com with SMTP id v184so27418044pgv.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:54 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Error handling: If controller reset is not able to
recover, kill HBA and quit immediately.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d49f6bd..9f3cbaa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4281,6 +4281,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					__func__, __LINE__);
 				megaraid_sas_kill_hba(instance);
 				retval = FAILED;
+				goto out;
 			}
 			/* Reset load balance info */
 			if (fusion->load_balance_info)
-- 
2.8.3
