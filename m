From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 3/3] Ibmvscsis: Fixed a bug reported by Dan Carpenter
Date: Wed, 31 Aug 2016 11:29:01 -0500
Message-ID: <1472660941-23856-4-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41135 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753854AbcHaSjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 14:39:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7VGMe7W014470
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:22 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 255rjvk0st-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:22 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 31 Aug 2016 12:29:20 -0400
In-Reply-To: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, dan.carpenter@oracle.com
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

SUPPORTED_FORMATS is 1 << 1 so it's never zero.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d4c67b9..35455af 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1978,7 +1978,7 @@ static long ibmvscsis_srp_login(struct scsi_info *vscsi,
 		reason = SRP_LOGIN_REJ_MULTI_CHANNEL_UNSUPPORTED;
 	else if (fmt->buffers & (~SUPPORTED_FORMATS))
 		reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
-	else if ((fmt->buffers | SUPPORTED_FORMATS) == 0)
+	else if ((fmt->buffers & SUPPORTED_FORMATS) == 0)
 		reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
 
 	if (vscsi->state == SRP_PROCESSING)
-- 
2.5.4 (Apple Git-61)

