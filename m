From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 1/5] megaraid_sas: Fix reset_mutex leak
Date: Wed,  9 Jul 2014 15:17:54 -0700
Message-ID: <1404944278-11535-2-git-send-email-aradford@gmail.com>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37887 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGIWTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:19 -0400
Received: by mail-pa0-f51.google.com with SMTP id hz1so9942888pad.38
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:18 -0700 (PDT)
In-Reply-To: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

The following patch for megaraid_sas fixes a reset_mutex leak in megasas_reset_fusion().

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Adam Radford <aradford@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2260041..0858851 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2355,6 +2355,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
 		       "returning FAILED for scsi%d.\n",
 			instance->host->host_no);
+		mutex_unlock(&instance->reset_mutex);
 		return FAILED;
 	}
 
-- 
1.7.11.7

