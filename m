From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] [SCSI] pmcraid: remove unneeded check
Date: Fri, 16 Dec 2011 13:15:54 +0300
Message-ID: <20111216101553.GA4287@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20070 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1LPKQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 05:16:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

request_size is zero here so this condition is always false.  Also we
already handled negative values some lines earlier so it's not negative
for that reason as well.

It looks like Dan Rosenberg's fix was applied twice by mistake:
b5b515445f4 "[SCSI] pmcraid: reject negative request size"
5f6279da376 "[SCSI] pmcraid: reject negative request size"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5163edb..d6bc4e6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3870,9 +3870,6 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_buffer;
 		}
-	} else if (request_size < 0) {
-		rc = -EINVAL;
-		goto out_free_buffer;
 	}
 
 	/* If data is being written into the device, copy the data from user
