From: brking@us.ibm.com
Subject: [PATCH 21/26] ipr: Support device reset to RAID disks
Date: Tue, 01 Nov 2005 17:02:29 -0600
Message-ID: <200511012302.jA1N2Um8023240@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39071 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751417AbVKAXCc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:02:32 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2VW2018559
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:31 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N3YDC540946
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:03:34 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2Uoh023269
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Support now exists in some ipr adapters to issue a device reset
to an Advanced Function disk.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_af_dasd_dev_reset drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_af_dasd_dev_reset	2005-10-31 21:53:40.478634672 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:40.528627072 -0600
@@ -3324,7 +3324,7 @@ static int __ipr_eh_dev_reset(struct scs
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
 
-	if (!res || (!ipr_is_gscsi(res) && !ipr_is_vset_device(res)))
+	if (!res)
 		return FAILED;
 
 	/*
_
