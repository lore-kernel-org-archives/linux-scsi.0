From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 4/5] megaraid_sas: Add missing initial call to megasas_get_ld_vf_affiliation().
Date: Wed,  9 Jul 2014 15:17:57 -0700
Message-ID: <1404944278-11535-5-git-send-email-aradford@gmail.com>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41356 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbaGIWTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:23 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so9688305pdi.37
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:23 -0700 (PDT)
In-Reply-To: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

The following patch for megaraid_sas adds a missing initial call to
megasas_get_ld_vf_affiliation() at the end of megasas_probe_one().

Signed-off-by: Adam Radford <aradford@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b4c032c..6db5c12 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4992,6 +4992,10 @@ retry_irq_register:
 		goto fail_start_aen;
 	}
 
+	/* Get current SR-IOV LD/VF affiliation */
+	if (instance->requestorId)
+		megasas_get_ld_vf_affiliation(instance, 1);
+
 	return 0;
 
       fail_start_aen:
-- 
1.7.11.7

