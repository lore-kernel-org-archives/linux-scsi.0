From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 3/8] scsi: Add template flag 'host_tagset'
Date: Mon,  5 Feb 2018 23:20:30 +0800
Message-ID: <20180205152035.15016-4-ming.lei@redhat.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205152035.15016-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Add a host template flag 'host_tagset' to enable the use of a global
tagset for block-mq.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Arun Easi <arun.easi@cavium.com>
Cc: Omar Sandoval <osandov@fb.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Don Brace <don.brace@microsemi.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Peter Rivera <peter.rivera@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 55be2550c555..9ab74ac634ea 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2274,6 +2274,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
 	shost->tag_set.flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+	if (shost->hostt->host_tagset)
+		shost->tag_set.flags |= BLK_MQ_F_GLOBAL_TAGS;
 	shost->tag_set.driver_data = shost;
 
 	return blk_mq_alloc_tag_set(&shost->tag_set);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a8b7bf879ced..f6623f887ee4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -457,6 +457,9 @@ struct scsi_host_template {
 	 */
 	unsigned int max_host_blocked;
 
+	/* True if the host supports a host-wide tagspace */
+	unsigned host_tagset:1;
+
 	/*
 	 * Default value for the blocking.  If the queue is empty,
 	 * host_blocked counts down in the request_fn until it restarts
-- 
2.9.5
