From: David Milburn <dmilburn@redhat.com>
Subject: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing task
Date: Fri, 6 Aug 2010 11:16:22 -0500
Message-ID: <20100806161622.GA8696@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab0HFQQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 12:16:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in, jeff@garzik.org

mvs_lu_reset should not call mvs_release_task phy number of times,
each phy is handled in mvs_release_task.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Srinivas <satyasrinivasp@hcl.in>
Cc: Andy Yan <ayan@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index adedaa9..013ab8d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1551,7 +1551,7 @@ static int mvs_debug_I_T_nexus_reset(struct domain_device *dev)
 int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 {
 	unsigned long flags;
-	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
+	int rc = TMF_RESP_FUNC_FAILED;
 	struct mvs_tmf_task tmf_task;
 	struct mvs_device * mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
@@ -1560,10 +1560,8 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 	mvi_dev->dev_status = MVS_DEV_EH;
 	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
-		num = mvs_find_dev_phyno(dev, phyno);
 		spin_lock_irqsave(&mvi->lock, flags);
-		for (i = 0; i < num; i++)
-			mvs_release_task(mvi, dev);
+		mvs_release_task(mvi, dev);
 		spin_unlock_irqrestore(&mvi->lock, flags);
 	}
 	/* If failed, fall-through I_T_Nexus reset */
