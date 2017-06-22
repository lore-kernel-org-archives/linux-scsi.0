From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 12/17] cxlflash: Refactor AFU capability checking
Date: Wed, 21 Jun 2017 21:16:02 -0500
Message-ID: <1498097762-9115-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752340AbdFVCQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:16:13 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EYjJ075481
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:12 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7r1ncxcb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:12 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:16:11 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The existing AFU capability checking infrastructure is closely tied to
the command mode capability bits. In order to support new capabilities,
refactor the existing infrastructure to be more generic.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index cbc0eb7..c96526e 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -255,21 +255,21 @@ static inline bool afu_is_irqpoll_enabled(struct afu *afu)
 	return !!afu->irqpoll_weight;
 }
 
-static inline bool afu_is_cmd_mode(struct afu *afu, u64 cmd_mode)
+static inline bool afu_has_cap(struct afu *afu, u64 cap)
 {
 	u64 afu_cap = afu->interface_version >> SISL_INTVER_CAP_SHIFT;
 
-	return afu_cap & cmd_mode;
+	return afu_cap & cap;
 }
 
 static inline bool afu_is_sq_cmd_mode(struct afu *afu)
 {
-	return afu_is_cmd_mode(afu, SISL_INTVER_CAP_SQ_CMD_MODE);
+	return afu_has_cap(afu, SISL_INTVER_CAP_SQ_CMD_MODE);
 }
 
 static inline bool afu_is_ioarrin_cmd_mode(struct afu *afu)
 {
-	return afu_is_cmd_mode(afu, SISL_INTVER_CAP_IOARRIN_CMD_MODE);
+	return afu_has_cap(afu, SISL_INTVER_CAP_IOARRIN_CMD_MODE);
 }
 
 static inline u64 lun_to_lunid(u64 lun)
-- 
2.1.0
