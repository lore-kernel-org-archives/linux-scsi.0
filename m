From: <Viswas.G@pmcs.com>
Subject: [PATCH V2 4/8] pm80xx: Fix for Incorrect DMA Unmapping of SG List
Date: Tue, 11 Aug 2015 15:06:28 +0530
Message-ID: <1439285792-12030-5-git-send-email-Viswas.G@pmcs.com>
References: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37394 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933709AbbHKJeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 05:34:50 -0400
In-Reply-To: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Wang <jinpu.wang@profitbricks.com>, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Hannes Reinecke <hare@suse.com>

From: Viswas G <Viswas.G@pmcs.com>

In pm8001_ccb_task_free(), the dma unmapping is done based on
ccb->n_elem value. This should be initialized to zero in the
task_abort(). Otherwise, pm8001_ccb_task_free() will try for
dma_unmap_sg() which is invalid for task abort and can lead to
kernel crash.

Changes From V1:
None

Signed-off-by: Viswas G <Viswas.G@pmcs.com>

Reviewed-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 48f4627..949198c 100644
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

