From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/3 -resend] [SCSI] pmcraid: remove unneeded check
Date: Wed, 27 Jun 2012 12:04:03 +0300
Message-ID: <20120627090403.GJ31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33462 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F0JEN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2012 05:04:13 -0400
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

request_size is zero here so this condition is always false.  Also we
already handled negative values some lines earlier so it's not negative
for that reason as well.

It looks like this was introduced because we applied Dan Rosenberg's fix
twice by mistake:
b5b515445f4 "[SCSI] pmcraid: reject negative request size"
5f6279da376 "[SCSI] pmcraid: reject negative request size"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I have tweaked the changelog slightly.  This was originally sent on
Fri, 16 Dec 2011.

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ea8a0b4..d81a159 100644
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
