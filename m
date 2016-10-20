From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 2/7] megaraid_sas: Send correct PhysArm to FW for R1 VD downgrade
Date: Thu, 20 Oct 2016 02:05:00 -0700
Message-ID: <1476954305-576-3-git-send-email-sumit.saxena@broadcom.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33819 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbcJTJFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:05:21 -0400
Received: by mail-pf0-f171.google.com with SMTP id r16so32856810pfg.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 02:05:21 -0700 (PDT)
In-Reply-To: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

This patch fixes the issue of wrong PhysArm was sent to firmware for R1
VD downgrade.

Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index e413113..f237d00 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -782,7 +782,8 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
-			pd = MR_ArPdGet(arRef, physArm + 1, map);
+			physArm = physArm + 1;
+			pd = MR_ArPdGet(arRef, physArm, map);
 			if (pd != MR_PD_INVALID)
 				*pDevHandle = MR_PdDevHandleGet(pd, map);
 		}
@@ -879,7 +880,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
 			/* Get alternate Pd. */
-			pd = MR_ArPdGet(arRef, physArm + 1, map);
+			physArm = physArm + 1;
+			pd = MR_ArPdGet(arRef, physArm, map);
 			if (pd != MR_PD_INVALID)
 				/* Get dev handle from Pd */
 				*pDevHandle = MR_PdDevHandleGet(pd, map);
-- 
1.8.3.1

