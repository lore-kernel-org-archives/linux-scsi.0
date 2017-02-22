From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 2/3] block: Add blk_mq_make_unique_tag()
Date: Wed, 22 Feb 2017 11:33:34 +0100
Message-ID: <1487759615-3989-3-git-send-email-hare@suse.de>
References: <1487759615-3989-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49829 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932104AbdBVKdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:33:39 -0500
In-Reply-To: <1487759615-3989-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Implement blk_mq_make_unique_tag() to generate a unique tag
value from a given hardware queue and tag value.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq-tag.c     | 3 +--
 include/linux/blk-mq.h | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index dcf5ce3..2df6d35 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -450,8 +450,7 @@ u32 blk_mq_unique_tag(struct request *rq)
 		hwq = hctx->queue_num;
 	}
 
-	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) |
-		(rq->tag & BLK_MQ_UNIQUE_TAG_MASK);
+	return blk_mq_make_unique_tag(hwq, rq->tag);
 }
 EXPORT_SYMBOL(blk_mq_unique_tag);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4a2ab5d9..1442c34 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -212,6 +212,11 @@ static inline u16 blk_mq_unique_tag_to_tag(u32 unique_tag)
 	return unique_tag & BLK_MQ_UNIQUE_TAG_MASK;
 }
 
+static inline u32 blk_mq_make_unique_tag(u16 hwq, u16 tag)
+{
+	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) |
+		(tag & BLK_MQ_UNIQUE_TAG_MASK);
+}
 
 int blk_mq_request_started(struct request *rq);
 void blk_mq_start_request(struct request *rq);
-- 
1.8.5.6
