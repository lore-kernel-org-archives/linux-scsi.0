From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm8001: Fix for sata io circular lock dependency.
Date: Wed, 5 Oct 2011 09:25:13 +0300
Message-ID: <20111005062513.GC32513@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26538 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab1JEGZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2011 02:25:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>, James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

The locking in 9e79e12554d "[SCSI] pm8001: Fix for sata io circular
lock dependency." is wrong.  We should revert this patch.

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index a3de306..68695b7 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1901,7 +1901,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
        struct sas_task *t;
        struct pm8001_ccb_info *ccb;
-       unsigned long flags;
+       unsigned long flags = 0;
        u32 param;
        u32 status;
        u32 tag;
@@ -2040,7 +2040,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
                        ts->stat = SAS_QUEUE_FULL;
                        pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                        mb();/*in order to force CPU ordering*/
+                       spin_unlock_irqrestore(&pm8001_ha->lock, flags);
                        t->task_done(t);
+                       spin_lock_irqsave(&pm8001_ha->lock, flags);
                        return;
                }
                break;

We can't just call spin_unlock_irqrestore(&pm8001_ha->lock, 0);
It makes no sense to call spin_lock_irqsave() and then return
immediately.  We could call spin_lock_irq() if we don't plan to
restore the state of flags.

regards,
dan carpenter
