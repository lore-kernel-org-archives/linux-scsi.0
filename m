From: brking@us.ibm.com
Subject: [PATCH 07/26] ipr: Include all disks in supported list
Date: Tue, 01 Nov 2005 17:00:54 -0600
Message-ID: <200511012300.jA1N0tFa015402@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:28061 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751403AbVKAXA4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:00:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0u3h017476
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:56 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N0uXg528110
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:00:56 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0tq7015415
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:00:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Fix ipr to include all disks in the supported device list,
not just disks formatted to advanced function format.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_set_supported_devs drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_set_supported_devs	2005-10-31 21:52:59.299894792 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:00.039782312 -0600
@@ -4111,7 +4111,7 @@ static int ipr_set_supported_devs(struct
 	ipr_cmd->job_step = ipr_ioa_reset_done;
 
 	list_for_each_entry_continue(res, &ioa_cfg->used_res_q, queue) {
-		if (!ipr_is_af_dasd_device(res))
+		if (!IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
 			continue;
 
 		ipr_cmd->u.res = res;
_
