From: <Viswas.G@pmcs.com>
Subject: [PATCH 4/8] pm80xx: Fix for Incorrect DMA Unmapping of SG List
Date: Wed, 29 Jul 2015 11:57:16 +0530
Message-ID: <1438151240-4097-5-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35376 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbbG2G0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:19 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>

In pm8001_ccb_task_free(), the dma unmapping is done based on
ccb->n_elem value. This should be initialized to zero in the
task_abort(). Otherwise, pm8001_ccb_task_free() will try for
dma_unmap_sg() which is invalid for task abort and can lead to
kernel crash.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
---
 drivers/scsi/pm8001/pm8001_sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 4e6955f..b1c5fb9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -790,6 +790,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
 		ccb->task = task;
+		ccb->n_elem = 0;
 
 		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
-- 
1.7.1

