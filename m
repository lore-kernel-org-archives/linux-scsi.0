From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 09/44] scsi: fc: Export fc_bsg_jobdone
Date: Tue, 11 Oct 2016 13:28:40 +0200
Message-ID: <c83b16ca221d77b169e49d0a9d9935afc23e506a.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Export fc_bsg_jobdone so drivers can use it directly instead of doing
the round-trip via struct fc_bsg_job::job_done().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 include/scsi/scsi_transport_fc.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index eafc7555..b0ce417 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3583,8 +3583,7 @@ fc_destroy_bsgjob(struct fc_bsg_job *job)
  *                  completed
  * @job:	fc_bsg_job that is complete
  */
-static void
-fc_bsg_jobdone(struct fc_bsg_job *job)
+void fc_bsg_jobdone(struct fc_bsg_job *job)
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
@@ -3611,6 +3610,7 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 	}
 	blk_complete_request(req);
 }
+EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 
 /**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 921b097..f90044a 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -842,5 +842,6 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+void fc_bsg_jobdone(struct fc_bsg_job *job);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.8.5.6
