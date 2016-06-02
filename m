From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/14] scsi: modify can_queue after calling mq_allocate()
Date: Thu,  2 Jun 2016 16:39:09 +0200
Message-ID: <1464878356-42407-8-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbcFBOjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:24 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When allocating a multiqueue structure the number of tags might
have been reduced due to memory pressure.
So update can_queue with the new value.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c71344a..e8fea8e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2099,6 +2099,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size, tbl_size;
+	int ret;
 
 	tbl_size = shost->sg_tablesize;
 	if (tbl_size > SG_CHUNK_SIZE)
@@ -2119,7 +2120,12 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	shost->tag_set.driver_data = shost;
 
-	return blk_mq_alloc_tag_set(&shost->tag_set);
+	ret = blk_mq_alloc_tag_set(&shost->tag_set);
+	if (!ret) {
+		/* queue depth might have been adjusted */
+		shost->can_queue = shost->tag_set.queue_depth;
+	}
+	return ret;
 }
 
 void scsi_mq_destroy_tags(struct Scsi_Host *shost)
-- 
1.8.5.6

