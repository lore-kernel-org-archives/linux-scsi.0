From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/8] block: update chunk_sectors in blk_stack_limits()
Date: Fri, 31 Jul 2015 15:36:14 +0200
Message-ID: <1438349780-116429-3-git-send-email-hare@suse.de>
References: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbbGaNgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:36:25 -0400
In-Reply-To: <1438349780-116429-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-settings.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 12600bf..63aa067 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -647,6 +647,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			t->discard_granularity;
 	}
 
+	if (b->chunk_sectors)
+		t->chunk_sectors = max(t->chunk_sectors, b->chunk_sectors);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
-- 
1.8.5.2

