From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 19/44] scsi: fc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
Date: Tue, 11 Oct 2016 13:28:50 +0200
Message-ID: <6b1e09e8d2adebfbad77d298d3a88754813b6124.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 9744476..d6d18ce 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3639,7 +3639,7 @@ static enum blk_eh_timer_return
 fc_bsg_job_timeout(struct request *req)
 {
 	struct fc_bsg_job *job = (void *) req->special;
-	struct Scsi_Host *shost = job->shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 	int err = 0, done = 0;
-- 
1.8.5.6
