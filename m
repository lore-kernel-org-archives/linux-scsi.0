From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 31/39] megaraid_sas: During OCR, if get_ctrl_info fails do not continue with OCR
Date: Wed,  8 Feb 2017 01:29:25 -0800
Message-ID: <1486546173-20713-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34628 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933207AbdBHJbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:31:35 -0500
Received: by mail-pg0-f51.google.com with SMTP id 14so47608580pgg.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:31:35 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Error handling: If controller reset is not able to
recover, kill HBA and quit immediately.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 207df1e..00e52a3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4285,6 +4285,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					__func__, __LINE__);
 				megaraid_sas_kill_hba(instance);
 				retval = FAILED;
+				goto out;
 			}
 			/* Reset load balance info */
 			if (fusion->load_balance_info)
-- 
2.8.3
