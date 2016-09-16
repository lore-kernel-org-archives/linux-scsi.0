From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: Remove redundant messages at adapter init time
Date: Fri, 16 Sep 2016 16:51:37 -0500
Message-ID: <20160916215137.7DE02B204E@b01ledav03.gho.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60633 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754783AbcIPVvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 17:51:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8GLltYl111270
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 17:51:41 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25gqe4b6kk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 17:51:41 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Fri, 16 Sep 2016 15:51:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Whenever multiple HRRQs are enabled, which is the default
setting now, we end up seeing the following message logged
prior to initialization of each HRRQ:

Starting IOA initialization sequence

This results in 16 of these messages on most adapters, which
serves little purpose. Change to just log this once.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_hrrq_message drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_hrrq_message	2016-08-30 20:53:06.909099536 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-08-30 20:53:06.915099497 -0500
@@ -8049,7 +8049,8 @@ static int ipr_ioafp_identify_hrrq(struc
 
 	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_std_inquiry;
-	dev_info(&ioa_cfg->pdev->dev, "Starting IOA initialization sequence.\n");
+	if (ioa_cfg->identify_hrrq_index == 0)
+		dev_info(&ioa_cfg->pdev->dev, "Starting IOA initialization sequence.\n");
 
 	if (ioa_cfg->identify_hrrq_index < ioa_cfg->hrrq_num) {
 		hrrq = &ioa_cfg->hrrq[ioa_cfg->identify_hrrq_index];
_

