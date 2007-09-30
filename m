From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] aic94xx: fix SSP IU status print-out
Date: Sun, 30 Sep 2007 10:03:17 -0400
Message-ID: <20070930140317.GA7134@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:40656 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbXI3ODS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 10:03:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The SSP response DPRINTK in asd_get_response_tasklet() was printing
a hardcoded status result, rather than the status from the SSP
response IU.

Arguably, this should not be a DPRINTK either, since the admin might
want to know about this.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/scsi/aic94xx/aic94xx_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index ab13824..f2b23e0 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -207,7 +207,7 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 					    "stat(0x%x) is not CHECK_CONDITION"
 					    "\n",
 					    SAS_ADDR(task->dev->sas_addr),
-					    ts->stat);
+					    iu->status);
 			}
 		}
 	}  else {
