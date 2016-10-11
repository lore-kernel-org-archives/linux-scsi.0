From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 38/44] scsi: fc: Use bsg_destroy_job
Date: Tue, 11 Oct 2016 13:29:09 +0200
Message-ID: <08a21c272065e1ff86c697a7c4f242ecb6494ad4.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

fc_destroy_bsgjob() and bsg_destroy_job() are now 1:1 copies, so use the
later.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a0e150a..4b9324f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/bsg-lib.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -3554,23 +3555,6 @@ fc_vport_sched_delete(struct work_struct *work)
  * BSG support
  */
 
-
-/**
- * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
- * @job:	fc_bsg_job that is to be torn down
- */
-static void
-fc_destroy_bsgjob(struct kref *kref)
-{
-	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
-
-	put_device(job->dev);	/* release reference for the request */
-
-	kfree(job->request_payload.sg_list);
-	kfree(job->reply_payload.sg_list);
-	kfree(job);
-}
-
 /**
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
@@ -3640,7 +3624,7 @@ fc_bsg_job_timeout(struct request *req)
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
 		if (err == -EAGAIN) {
-			kref_put(&job->kref, fc_destroy_bsgjob);
+			kref_put(&job->kref, bsg_destroy_job);
 			return BLK_EH_RESET_TIMER;
 		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
-- 
1.8.5.6
