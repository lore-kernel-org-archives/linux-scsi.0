From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/3] cxlflash: Remove unnecessary existence check
Date: Fri, 25 Aug 2017 17:17:53 -0500
Message-ID: <1503699473-61505-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48825 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934007AbdHYWSC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 18:18:02 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7PMFPnC147149
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:02 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cjukvacb4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:02 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 25 Aug 2017 18:18:00 -0400
In-Reply-To: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The AFU termination sequence has been refactored over time such that
the main tear down routine, term_afu(), can no longer can be invoked
with a NULL AFU pointer. Remove the unnecessary existence check from
term_afu().

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6a4367c..76b8b7ee 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -820,8 +820,7 @@ static void term_afu(struct cxlflash_cfg *cfg)
 	for (k = cfg->afu->num_hwqs - 1; k >= 0; k--)
 		term_intr(cfg, UNMAP_THREE, k);
 
-	if (cfg->afu)
-		stop_afu(cfg);
+	stop_afu(cfg);
 
 	for (k = cfg->afu->num_hwqs - 1; k >= 0; k--)
 		term_mc(cfg, k);
-- 
2.1.0
