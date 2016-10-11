From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 11/44] bfa: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:42 +0200
Message-ID: <5f4dfe6cffec6f3cfa52dad37e33235a19cdc818.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/bfa/bfad_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 48366d8..25889b9 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3180,7 +3180,7 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	bsg_reply->result = rc;
 
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	return rc;
 error:
 	/* free the command buffer */
@@ -3556,7 +3556,7 @@ out:
 	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 
 	return rc;
 }
-- 
1.8.5.6
