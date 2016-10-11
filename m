From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 16/44] scsi: fc: remove job_done method from struct fc_bsg_job
Date: Tue, 11 Oct 2016 13:28:47 +0200
Message-ID: <0bbc14f14ceeadd280f435ec88c9cc43d6a01c85.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753039AbcJKL33 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:29 -0400
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

Now that we've converted all LLDDs over to use fc_bsg_jobdone() directly,
remove the function pointer from struct fc_bsg_job.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 1 -
 include/scsi/scsi_transport_fc.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b0ce417..4149dac 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3744,7 +3744,6 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 		if (ret)
 			goto failjob_rls_rqst_payload;
 	}
-	job->job_done = fc_bsg_jobdone;
 	if (rport)
 		job->dev = &rport->dev;
 	else
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index f90044a..9ef583f 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -637,7 +637,6 @@ struct fc_bsg_job {
 	spinlock_t job_lock;
 	unsigned int state_flags;
 	unsigned int ref_cnt;
-	void (*job_done)(struct fc_bsg_job *);
 
 	struct fc_bsg_request *request;
 	struct fc_bsg_reply *reply;
-- 
1.8.5.6

