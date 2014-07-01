From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 1/4] megaraid_sas: Fix reset_mutex leak
Date: Mon, 30 Jun 2014 17:19:55 -0700
Message-ID: <1404173998-24363-2-git-send-email-aradford@gmail.com>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35104 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaGAAVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 20:21:06 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so9057634pdj.36
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 17:21:06 -0700 (PDT)
In-Reply-To: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

James/linux-scsi,

The following patch for megaraid_sas fixes a reset_mutex leak in megasas_reset_fusion().

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

