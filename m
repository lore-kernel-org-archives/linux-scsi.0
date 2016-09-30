From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v6 3/7] block: update chunk_sectors in blk_stack_limits()
Date: Fri, 30 Sep 2016 14:12:32 -0500
Message-ID: <20160930191237.13695-4-shaun@tancheff.com>
References: <20160930191237.13695-1-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33149 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI3TOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2016 15:14:03 -0400
In-Reply-To: <20160930191237.13695-1-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Damien Le Moal <damien.lemoal@hgst.com>, Michael T Lombardi <michael.t.lombardi@seagate.com>, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/blk-settings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b1d5b7f..55369a6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -631,6 +631,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			t->discard_granularity;
 	}
 
+	if (b->chunk_sectors)
+		t->chunk_sectors = min_not_zero(t->chunk_sectors,
+						b->chunk_sectors);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
-- 
2.9.3

