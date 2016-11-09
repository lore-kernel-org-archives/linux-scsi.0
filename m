From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH] megaraid_sas: fix macro MEGASAS_IS_LOGICAL to avoid regression caused by commit 1e793f6fc0db920400574211c48f9157a37e3945
Date: Wed,  9 Nov 2016 02:59:42 -0800
Message-ID: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33726 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbcKILAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 06:00:02 -0500
Received: by mail-pf0-f171.google.com with SMTP id d2so125839791pfd.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2016 03:00:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, shivasharan.srikanteshwara@broadcom.com, axboe@kernel.dk, stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>

This patch will fix regression caused by below commit-
1e793f6 scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices

The problem was MEGASAS_IS_LOGICAL macro does not have braces and because of above commit 
using this macro was exposing lot of non-existing SCSI devices(all SCSI commands to channels-1,2,3 was
returned as SUCCESS-DID_OK by driver).

Fixes: 1e793f6fc0db920400574211c48f9157a37e3945 
Reported-by: Jens Axboe <axboe@kernel.dk>
CC: stable@vger.kernel.org
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Tested-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ca86c88..3aaea71 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2233,7 +2233,7 @@ struct megasas_instance_template {
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
-	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
-- 
1.8.3.1

