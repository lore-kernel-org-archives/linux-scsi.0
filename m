From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 1/7] megaraid_sas: For SRIOV enabled firmware, ensure VF driver waits for 30secs before reset
Date: Thu, 20 Oct 2016 02:04:59 -0700
Message-ID: <1476954305-576-2-git-send-email-sumit.saxena@broadcom.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33799 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbcJTJFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:05:18 -0400
Received: by mail-pf0-f181.google.com with SMTP id r16so32855886pfg.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 02:05:18 -0700 (PDT)
In-Reply-To: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>, stable@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

For SRIOV enabled firmware, if there is a OCR(online controller reset)
possibility driver set the convert flag to 1, which is not happening if
there are outstanding commands even after 180 seconds.
As driver does not set convert flag to 1 and still making the OCR to run,
VF(Virtual function) driver is directly writing on to the register
instead of waiting for 30 seconds. Setting convert flag to 1 will cause
VF driver will wait for 30 secs before going for reset.

CC: stable@vger.kernel.org
Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 52d8bbf..61be7ed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2823,6 +2823,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		dev_err(&instance->pdev->dev, "pending commands remain after waiting, "
 		       "will reset adapter scsi%d.\n",
 		       instance->host->host_no);
+		*convert = 1;
 		retval = 1;
 	}
 out:
-- 
1.8.3.1

